# Repository Guidelines

## Project Structure & Module Organization
`RealTrack.xcodeproj` anchors the workspace. The SwiftUI app code lives in `RealTrack/`, with feature screens under `Views/` (e.g. `Views/House`), state logic grouped in `VIewModels/`, and data definitions in `Models/` plus shared helpers such as `Extensions.swift`, `Formatters.swift`, and `Validators.swift`. `Assets.xcassets` and `Preview Content/` hold design assets and SwiftUI previews. `SeedDatabase.swift` seeds demo data for local development. Tests are split between `RealTrackTests/` for unit coverage and `RealTrackUITests/` for XCUI automation. Keep any SwiftData schema additions in `RealTrackEntities/` to mirror production models.

## Build, Test, and Development Commands
Run `open RealTrack.xcodeproj` to develop in Xcode. For command-line builds, use `xcodebuild -scheme RealTrack -destination "platform=iOS Simulator,name=iPhone 15"`; add `clean build` when debugging derived-data issues. Execute unit and UI suites together with `xcodebuild test -scheme RealTrack -destination "platform=iOS Simulator,name=iPhone 15"`; append `-only-testing:RealTrackUITests` to focus on UI checks. Launching the simulator via Xcode automatically prints the SwiftData store path from `RealTrackApp.swift`, which helps inspect persisted fixtures.

## Coding Style & Naming Conventions
Follow Swift API Design Guidelines: PascalCase for types, camelCase for members, and prefer `struct` over `class` unless reference semantics are required. Indent with four spaces and wrap at roughly 120 columns. Organize view models and validators by feature folder, and co-locate SwiftData models with their corresponding views to simplify previews. Keep extensions in `Extensions.swift` unless a type-specific file improves clarity. Before committing, let Xcode’s “Editor > Re-Indent” normalize whitespace and ensure you are targeting iOS 17+ to stay aligned with SwiftData usage.

## Testing Guidelines
The project adopts Apple’s `Testing` framework; annotate async-safe checks with `@Test` and use `#expect`. Place feature-specific tests alongside the module they exercise inside `RealTrackTests/`, and suffix helper files with `+Tests.swift`. Aim to cover new SwiftData schema branches with both unit tests (data validation) and UI smoke tests. Run the full suite with `⌘U` in Xcode or `xcodebuild test` prior to pushing. Update seed data when schema changes to keep previews and UI tests deterministic.

## Commit & Pull Request Guidelines
Commit summaries follow the convention `#REA-<ticket> concise action`, for example `#REA-16 fix compiler errors`. Bundle related changes per commit, keeping noise (e.g., formatting-only edits) separate. Pull requests should describe the user-facing impact, list notable technical decisions, and link the tracked ticket. Attach screenshots or simulator recordings when UI behaviour shifts, and call out schema migrations or data resets so reviewers can prepare their environments. Request review from the feature owner and tag QA whenever UI flows are touched.
