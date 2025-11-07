# Repository Guidelines

## Project Structure & Module Organization
`RealTrack.xcodeproj` anchors the workspace; SwiftUI sources live under `RealTrack/`. Feature screens sit inside `RealTrack/Views/` (for example `Views/House/`), with state in `ViewModels/` and data models in `Models/`. Shared helpers such as `Extensions.swift`, `Formatters.swift`, and `Validators.swift` also live in `RealTrack/`. Place SwiftData schemas in `RealTrackEntities/` alongside the views that consume them, and keep preview assets in `Preview Content/`. UI assets belong in `Assets.xcassets`, while `SeedDatabase.swift` provides deterministic demo data.

## Build, Test, and Development Commands
Use `open RealTrack.xcodeproj` to launch Xcode. Command-line builds run through `xcodebuild -scheme RealTrack -destination "platform=iOS Simulator,name=iPhone 15"`; append `clean build` when you need to reset derived data. Execute the full test suite with `xcodebuild test -scheme RealTrack -destination "platform=iOS Simulator,name=iPhone 15"`, and limit to UI coverage via `-only-testing:RealTrackUITests`.

## Coding Style & Naming Conventions
Target iOS 17+, stick to four-space indentation, and wrap lines near 120 columns. Prefer `struct` for models and view logic unless reference semantics are required. Adopt Swift API Design Guidelines: PascalCase for types, camelCase for members, and descriptive method names. Keep extensions centralized in `Extensions.swift` unless a feature-specific file improves clarity, and always re-indent with Xcode before committing.

## Testing Guidelines
Tests rely on Apple’s `Testing` framework—annotate entry points with `@Test` and assert using `#expect`. Place feature-specific unit coverage in `RealTrackTests/` (e.g. `HouseDetail+Tests.swift`) and XCUI automation in `RealTrackUITests/`. When adding SwiftData models, cover validation paths and seed fixtures, then run `xcodebuild test` or `⌘U` to confirm both suites pass.

## Commit & Pull Request Guidelines
Prefix commits with the ticket, following `#REA-<id> action`, such as `#REA-16 fix compiler errors`. Keep commits focused: separate functional work from formatting-only changes. Pull requests should describe user-facing impact, note technical decisions, link the tracked ticket, and include screenshots or simulator recordings for UI changes. Call out SwiftData migrations or seed updates so reviewers can reset local data.

## Environment & Data Tips
Launching the app in the simulator prints the active SwiftData store path from `RealTrackApp.swift`; use it to inspect persisted fixtures while debugging. Update `SeedDatabase.swift` whenever schemas evolve to keep previews and UI tests reliable.
