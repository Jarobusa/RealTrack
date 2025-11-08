# Repository Guidelines

## Project Structure & Module Organization
- RealTrack is a property management app for rental houses, shared across partners and agencies; keep API, clients, and infra changes in sync so properties/people/addresses remain consistent.
- `Api/RealTrack.Api` contains the .NET minimal API, AWS SAM template, and config (`appsettings*.json`); treat `Program.cs` as the routing hub and keep Lambda glue (`LambdaEntryPoint`) slim.
- `RealTrackApple/RealTrack` hosts the SwiftUI app, with `Views/`, `ViewModels/`, and `Models/` mirroring each feature; shared data lives in `RealTrackEntities/` and previews/assets in `Preview Content/` and `Assets.xcassets`.
- `RealTrackReact` now houses both the Expo (web) client (`App.tsx`, `src/`) and infrastructure assets (`infrastructure/`). Keep UI files under `src/components|lib|types` and reuse the shared DynamoDB schema when introducing new views.

## Build, Test, and Development Commands
- `dotnet restore RealTrack.sln` → restore NuGet packages for every backend project.
- `dotnet run --project Api/RealTrack.Api/RealTrack.Api.csproj` → launch the local API with `appsettings.Development.json`.
- `sam local start-api --parameter-overrides TableName=RealTrackDev` → emulate the Lambda entry point (requires Docker).
- `open RealTrackApple/RealTrack.xcodeproj` or `xcodebuild -scheme RealTrack -destination "platform=iOS Simulator,name=iPhone 15"` → build the iOS client; append `test` to run the suites.
- `cfn-lint RealTrackReact/infrastructure/dynamodb-person.yml` and `aws cloudformation deploy ...` → validate and ship infra changes; substitute the stack name per environment.
- `cd RealTrackReact && npm install` (once) then `npm run web` → start the Expo-based React client in the browser; set `EXPO_PUBLIC_REALTRACK_API_URL` to target any RealTrack.Api instance.

## API Exploration (Bruno)
- Open `Api/RealTrack.Api/bruno/RealTrackApi` in Bruno to get ready-made requests for the `/persons` endpoints.
- Load the `local.bru` environment so `{{baseUrl}}` resolves to `http://localhost:5233`; override sample IDs/emails inside the request-level `vars` blocks when needed.
- Requests cover: GET by ID, search by email, search by last name (with optional prefix), and POST to create a person—mirroring `PersonEndpoints.cs`.

## Coding Style & Naming Conventions
- C#: target C# 12 features (primary constructors, collection expressions) where they clarify intent; use 4-space indentation, `var` for obvious types, preserve `TENANT#...`/`PER_...` key patterns, and run `dotnet format` before committing.
- Swift: iOS 17+, 4 spaces, PascalCase types, camelCase members; colocate feature-specific extensions, and keep SwiftData schemas near their consuming views.
- CloudFormation: 2-space YAML, PascalCase logical IDs, lowercase attribute keys (`PK`, `SK`, `GSI1PK`), and section order `Parameters → Resources → Outputs`.
- React/Expo: TypeScript with functional components, StyleSheet-based styling, and environment-aware API clients under `src/lib`. Expose runtime configuration via `EXPO_PUBLIC_` variables rather than hard-coded URLs.

## Testing Guidelines
- Add xUnit coverage under `tests/` and run `dotnet test` from the repo root, especially for new API routes or DynamoDB access patterns.
- Use `xcodebuild test -scheme RealTrack ...` (or `⌘U`) to cover both `RealTrackTests` and `RealTrackUITests`; include screenshots or simulator recordings for UI regressions.
- Infrastructure changes must pass `cfn-lint`, `aws cloudformation validate-template`, and, after deploy, `aws dynamodb describe-table` to confirm GSIs/PITR.
- The Expo client should pass `npm run typecheck` and be exercised via `npm run web` with screenshots of new flows attached to PRs.

## Commit & Pull Request Guidelines
- Follow the existing convention: `#REA-<ticket> concise action` (e.g., `#REA-42 add house detail view`); keep each commit focused.
- PRs should cite the ticket, summarize impact, list validation commands (`dotnet run`, `xcodebuild test`, `cfn-lint`), and attach payload samples or UI evidence when applicable.
- Call out schema changes (SwiftData migrations, DynamoDB attributes), new environment variables, and any manual deployment steps reviewers must repeat.

## Security & Configuration Tips
- Never hardcode secrets or ARNs; prefer environment variables (`DDB_TABLE`, AWS profiles) and SAM/CloudFormation parameters.
- Keep DynamoDB encryption (`SSESpecification`) and PITR enabled; document deviations explicitly.
- When adding client features that rely on backend contracts, update both the API DTOs and Swift/React models in the same PR to avoid desynchronization.
