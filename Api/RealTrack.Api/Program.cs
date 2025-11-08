using System.ComponentModel.DataAnnotations;
using Amazon.DynamoDBv2;
using Amazon.DynamoDBv2.Model;
using Amazon.Lambda.AspNetCoreServer.Hosting;
using Microsoft.AspNetCore.Mvc;
using NUlid;
using Microsoft.Extensions.Configuration;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddAWSLambdaHosting(LambdaEventSource.HttpApi);
builder.Services.AddSingleton<IAmazonDynamoDB>(_ => new AmazonDynamoDBClient());

builder.Configuration["DDB_TABLE"] =
    Environment.GetEnvironmentVariable("DDB_TABLE") ?? "RealTrack";

var allowedOrigins = builder.Configuration
    .GetSection("Cors:AllowedOrigins")
    .Get<string[]>() ?? Array.Empty<string>();

builder.Services.AddCors(options =>
{
    options.AddPolicy("FrontendCors", policy =>
    {
        if (allowedOrigins.Length == 0)
        {
            policy.AllowAnyOrigin()
                  .AllowAnyMethod()
                  .AllowAnyHeader();
        }
        else
        {
            policy.WithOrigins(allowedOrigins)
                  .AllowAnyMethod()
                  .AllowAnyHeader();
        }
    });
});

var app = builder.Build();
var ddb = app.Services.GetRequiredService<IAmazonDynamoDB>();
var tableName = builder.Configuration["DDB_TABLE"]!;
const string TenantId = "TNT_demo"; // TODO: replace with tenant from auth once available.

app.UseCors("FrontendCors");

app.MapGet("/", () => Results.Ok(new { service = "RealTrack API", ok = true }));

app.MapGet("/persons/{personId}", async ([FromRoute] string personId) =>
{
    var query = await ddb.QueryAsync(new QueryRequest
    {
        TableName = tableName,
        KeyConditionExpression = "PK = :pk AND SK = :sk",
        ExpressionAttributeValues = new()
        {
            [":pk"] = Av($"TENANT#{TenantId}"),
            [":sk"] = Av($"PERSON#{personId}")
        },
        Limit = 1
    });

    if (query.Items.Count == 0) return Results.NotFound();
    return Results.Ok(ToPerson(query.Items[0]));
});

app.MapGet("/persons", async ([FromQuery] string? email,
    [FromQuery] string? lastName,
    [FromQuery] bool prefix) =>
{
    if (!string.IsNullOrWhiteSpace(email))
    {
        var normalized = NormalizeEmail(email);
        var response = await ddb.QueryAsync(new QueryRequest
        {
            TableName = tableName,
            IndexName = "GSI1",
            KeyConditionExpression = "GSI1PK = :pk AND GSI1SK = :sk",
            ExpressionAttributeValues = new()
            {
                [":pk"] = Av($"TENANT#{TenantId}#PERSON_EMAIL"),
                [":sk"] = Av(normalized)
            },
            Limit = 1
        });

        if (response.Items.Count == 0) return Results.NotFound();
        return Results.Ok(ToPerson(response.Items[0]));
    }

    if (!string.IsNullOrWhiteSpace(lastName))
    {
        var trimmed = lastName.Trim();
        var gsiSk = prefix ? trimmed : $"{trimmed}#";
        var response = await ddb.QueryAsync(new QueryRequest
        {
            TableName = tableName,
            IndexName = "GSI2",
            KeyConditionExpression = "GSI2PK = :pk AND begins_with(GSI2SK, :sk)",
            ExpressionAttributeValues = new()
            {
                [":pk"] = Av($"TENANT#{TenantId}#PERSON_NAME"),
                [":sk"] = Av(gsiSk)
            },
            Limit = 25
        });

        return Results.Ok(response.Items.Select(ToPerson));
    }

    return Results.BadRequest("Provide either ?email= or ?lastName=.");
});

app.MapPost("/persons", async ([FromBody] PersonUpsert dto) =>
{
    if (string.IsNullOrWhiteSpace(dto.FirstName) ||
        string.IsNullOrWhiteSpace(dto.LastName) ||
        string.IsNullOrWhiteSpace(dto.Email))
    {
        return Results.ValidationProblem(new Dictionary<string, string[]>
        {
            ["Person"] = ["FirstName, LastName, and Email are required."]
        });
    }

    var personId = $"PER_{Ulid.NewUlid()}";
    var now = DateTime.UtcNow.ToString("O");
    var normalizedEmail = NormalizeEmail(dto.Email);

    var item = new Dictionary<string, AttributeValue>
    {
        ["PK"] = Av($"TENANT#{TenantId}"),
        ["SK"] = Av($"PERSON#{personId}"),
        ["EntityType"] = Av("Person"),
        ["PersonId"] = Av(personId),
        ["TenantId"] = Av(TenantId),
        ["FirstName"] = Av(dto.FirstName.Trim()),
        ["LastName"] = Av(dto.LastName.Trim()),
        ["FullName"] = Av($"{dto.FirstName} {dto.LastName}".Trim()),
        ["Email"] = Av(dto.Email.Trim()),
        ["EmailNormalized"] = Av(normalizedEmail),
        ["Phone"] = Av(dto.Phone ?? string.Empty),
        ["CreatedUtc"] = Av(now),
        ["UpdatedUtc"] = Av(now),
        ["GSI1PK"] = Av($"TENANT#{TenantId}#PERSON_EMAIL"),
        ["GSI1SK"] = Av(normalizedEmail),
        ["GSI2PK"] = Av($"TENANT#{TenantId}#PERSON_NAME"),
        ["GSI2SK"] = Av($"{dto.LastName.Trim()}#{dto.FirstName.Trim()}#{personId}")
    };

    var emailLock = new Dictionary<string, AttributeValue>
    {
        ["PK"] = Av($"TENANT#{TenantId}#EMAIL#{normalizedEmail}"),
        ["SK"] = Av("LOCK")
    };

    var tx = new TransactWriteItemsRequest
    {
        TransactItems = new List<TransactWriteItem>
        {
            new()
            {
                Put = new Put
                {
                    TableName = tableName,
                    Item = item,
                    ConditionExpression = "attribute_not_exists(PK)"
                }
            },
            new()
            {
                Put = new Put
                {
                    TableName = tableName,
                    Item = emailLock,
                    ConditionExpression = "attribute_not_exists(PK)"
                }
            }
        }
    };

    try
    {
        await ddb.TransactWriteItemsAsync(tx);
    }
    catch (TransactionCanceledException)
    {
        return Results.Conflict("Email already exists for this tenant.");
    }

    return Results.Created($"/persons/{personId}", ToPerson(item));
});

app.Run();

static AttributeValue Av(string value) => new() { S = value };

static PersonResponse ToPerson(IDictionary<string, AttributeValue> item)
{
    return new PersonResponse(
        GetString(item, "PersonId"),
        GetString(item, "FirstName"),
        GetString(item, "LastName"),
        GetString(item, "Email"),
        GetString(item, "Phone"),
        GetString(item, "CreatedUtc"),
        GetString(item, "UpdatedUtc"));
}

static string GetString(IDictionary<string, AttributeValue> item, string key) =>
    item.TryGetValue(key, out var value) ? value.S ?? string.Empty : string.Empty;

static string NormalizeEmail(string email) => email.Trim().ToLowerInvariant();

public record PersonUpsert(
    [property: Required] string FirstName,
    [property: Required] string LastName,
    [property: Required] string Email,
    string? Phone);

public record PersonResponse(
    string PersonId,
    string FirstName,
    string LastName,
    string Email,
    string? Phone,
    string CreatedUtc,
    string UpdatedUtc);
