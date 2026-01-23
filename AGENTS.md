# AGENTS.md

## Project Overview

Windows-only C# utility that sends Stata code to a running Stata instance. Uses Win32 APIs for clipboard, window management, and keyboard input.

## Architecture

- **SendToStata.cs** - Single-file application with all logic
  - Argument parsing (`ParseArguments`)
  - Line extraction (`GetStatementAtRow`, `GetUpwardLines`, `GetDownwardLines`)
  - Path escaping for Stata (`EscapePathForStata`, `FormatCdCommand`)
  - Win32 interop for clipboard, focus, keystrokes
- **SendToStata.Tests/** - xUnit tests with FsCheck property-based testing

## Key Constraints

- **Windows-only**: Uses Win32 APIs (user32.dll, kernel32.dll)
- **AOT compiled**: Published as native executable, no .NET runtime required
- **Tests require Stata**: Integration tests need a running Stata instance

## Build & Release

```powershell
dotnet build                    # Build
dotnet test                     # Run tests (needs Stata)
.\update_version.ps1 <version>  # Release (build, test, commit, tag, push)
```

CI builds x64 and arm64 binaries on tag push.

## Downstream Consumers

Both download from GitHub Releases and maintain version/checksums:

- **zed-stata**: Zed extension; repo includes a download script that installs the utility and configures Zed tasks and keyboard shortcuts
- **sight**: VS Code extension that downloads the .exe as needed with user confirmation
