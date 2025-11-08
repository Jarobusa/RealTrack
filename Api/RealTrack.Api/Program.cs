using System.ComponentModel.DataAnnotations;
using Amazon.DynamoDBv2;
using Amazon.Lambda.AspNetCoreServer.Hosting;
using Microsoft.Extensions.Configuration;
using RealTrack.Api.Endpoints;

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

app.MapPersonEndpoints(ddb, tableName, TenantId);

app.Run();

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
