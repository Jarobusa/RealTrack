# Repository Guidelines

## Project Structure & Module Organization
- `package.json`, `App.tsx`, and the `src/` tree form the Expo-managed React (web) client. Keep UI logic inside feature-specific components under `src/components/` and API helpers under `src/lib/`.
- Expo config lives in `app.config.ts`; it exposes `extra.apiUrl`, derived from `EXPO_PUBLIC_REALTRACK_API_URL`, so the app can point at any RealTrack.Api surface without code changes.
- Infrastructure-as-code remains in `infrastructure/`. The `dynamodb-person.yml` template provisions the multi-tenant DynamoDB table plus PITR. Keep one template per stack and centralize reusable parameters (`TableName`, billing mode, etc.) at the top of each file.

## Build, Test, and Development Commands
- `npm install` (run inside `RealTrackReact/`) — installs Expo/React dependencies.
- `npm run web` — launches the Expo dev server in web mode; ensure `EXPO_PUBLIC_REALTRACK_API_URL` is set (defaults to `http://localhost:5233`).
- `npm run typecheck` — TypeScript `--noEmit` pass for the Expo client; keep it green before pushing UI changes.
- `cfn-lint infrastructure/dynamodb-person.yml`, `aws cloudformation validate-template`, `aws cloudformation deploy ...` — continue to use these for DynamoDB infrastructure work; document the exact parameters in your PR.

## Coding Style & Naming Conventions
- React: TypeScript-first, functional components only, hooks for state, and StyleSheet objects for styling (no inline anonymous styles unless dynamic). Keep fetch logic isolated in `src/lib/api.ts`.
- Expo env vars must be prefixed with `EXPO_PUBLIC_`. Reference them via `process.env.EXPO_PUBLIC_*` or `Constants.expoConfig.extra`.
- CloudFormation files stay 2-space indented with PascalCase logical IDs and the existing attribute prefixes (`PK`, `SK`, `GSI1PK`, etc.).

## Testing Guidelines
- For the Expo client rely on `npm run typecheck` plus manual verification via `npm run web`. Add Jest or integration tests under `src/__tests__/` if components gain complex logic.
- Infra changes: run `cfn-lint` on every change and verify deployed tables with `aws dynamodb describe-table --table-name <name>` before merging. Capture relevant CLI output for PRs.

## Commit & Pull Request Guidelines
Prefix commits with `#REA-### action`, mirroring the rest of the monorepo. PRs should describe UI screenshots or screen recordings for the Expo app, the RealTrack.Api environment hit during testing, and any infrastructure changes. Include `npm run typecheck`, `npm run web`, and CloudFormation commands (if touched) in the validation checklist.

## Security & Configuration Tips
- Never hardcode base URLs or credentials; use `EXPO_PUBLIC_REALTRACK_API_URL` for the Expo app and CloudFormation parameters/SSM for infrastructure.
- Keep DynamoDB encryption/PITR enabled in templates, and remove experimental GSIs immediately after use. Document any new environment variables or secrets handling steps in both the PR and `AGENTS.md`.
