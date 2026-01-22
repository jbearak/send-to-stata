# send-to-stata

Windows utility that sends Stata code from editors to a running Stata instance via clipboard and keystrokes.

> **Related Repositories:**
>
> - [Sight](https://github.com/jbearak/sight) - language server and VS Code extension
> - [zed-stata](https://github.com/jbearak/zed-stata) - Zed extension
> - [tree-sitter-stata](https://github.com/jbearak/tree-sitter-stata) - tree-sitter grammar

## Usage

```
send-to-stata.exe -File <path> -Row <n>           # Send statement at row
send-to-stata.exe -File <path> -FileMode          # Send entire file
send-to-stata.exe -CDWorkspace -Workspace <path>  # cd to directory
send-to-stata.exe -CDFile -File <path>            # cd to file's directory
send-to-stata.exe -Upward -File <path> -Row <n>   # Send lines 1 to row
send-to-stata.exe -Downward -File <path> -Row <n> # Send lines row to end
```

The `-CDWorkspace` option is typically called by editors (Zed, VS Code) which detect the workspace root by looking for `.git` directories and pass that path.

Options:
- `-Include` - Use `include` instead of `do`
- `-ActivateStata` - Keep focus in Stata (default returns to editor)

## Building

Requires .NET 8 SDK and Windows.

```powershell
dotnet build
dotnet test
dotnet publish -c Release -r win-x64
```

## Releasing

On Windows with Stata installed:

```powershell
.\update_version.ps1 x.y.z
```

This builds, runs tests, commits, tags, and pushes. The CI creates a GitHub Release with x64 and arm64 binaries.

## License

Copyright © 2026 Jonathan Marc Bearak

[GPLv3](LICENSE) - This project is open source software. You can use, modify, and distribute it with attribution, but any derivative works must also be open source under GPLv3.
