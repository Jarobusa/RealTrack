# Repository Guidelines

## Project Structure & Module Organization
All infrastructure-as-code currently lives in `infrastructure/`. The `dynamodb-person.yml` CloudFormation template provisions the multi-tenant DynamoDB table (PK/SK primary key plus `GSI1`/`GSI2`) and its PITR backup resource. Keep new templates in the same folder, one file per stack, and group shared parameters (such as `TableName`) near the top so automation scripts can override them. When adding service-specific assets (React app, Lambda handlers, etc.), mirror the folder name (`web/`, `lambdas/`, `scripts/`) and include a README explaining how it integrates with the table schema.

## Build, Test, and Development Commands
- `cfn-lint infrastructure/dynamodb-person.yml` — static analysis for schema, property names, and region support.
- `aws cloudformation validate-template --template-body file://infrastructure/dynamodb-person.yml` — confirms the rendered template is syntactically correct before deployment.
- `aws cloudformation deploy --template-file infrastructure/dynamodb-person.yml --stack-name realtrack-dynamodb --parameter-overrides TableName=RealTrack` — provisions or updates the table; adjust `TableName` per environment.
Wrap these commands in a `make` or `npm` script only after verifying they succeed locally with AWS credentials configured via `aws configure sso` or environment variables.

## Coding Style & Naming Conventions
Use two-space indentation and lowercase keys for CloudFormation intrinsic functions (`!Ref`, `!GetAtt` as shown). Resource logical IDs stay in PascalCase (`RealTrackTable`, `RealTrackPITR`) and align with what the AWS console will display. Attribute names inside the single-table schema follow the established abbreviations (`PK`, `SK`, `GSI1PK`, `GSI1SK`, etc.); do not introduce new prefixes without documenting them in comments near the attribute definitions. Keep sections ordered logically: `Parameters`, `Resources`, `Outputs`.

## Testing Guidelines
Run `cfn-lint` on every change, and block commits if lint errors appear. Use `aws dynamodb describe-table --table-name <deployed-name>` after deployment to confirm billing mode, GSIs, and PITR settings match expectations. For schema migrations, stage updates in a throwaway stack (`realtrack-dynamodb-sandbox`) and capture API responses to attach to PRs. Name any future Jest or integration test files `<feature>.test.ts` to align with common React tooling.

## Commit & Pull Request Guidelines
Git history shows the `#REA-###` ticket prefix followed by a concise action (`#REA-16 fix compiler errors`). Continue that format, using imperative mood and keeping the summary under 72 characters. Each PR should include: context (what changed and why), testing notes (commands run, stack ARNs touched), screenshots or CLI output for infrastructure diffs, and links to the matching tracker issue. Request at least one reviewer familiar with the DynamoDB schema before merging.

## Security & Configuration Tips
Never hardcode ARNs, keys, or table names; rely on parameters or SSM references so the same template works across tenants. Leave `BillingMode: PAY_PER_REQUEST` unless there is a documented capacity plan, and keep `SSESpecification` enabled—these defaults are part of the compliance baseline. Remove temporary GSIs or debugging attributes immediately after experiments and document any schema changes in the PR description.
