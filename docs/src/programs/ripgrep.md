# ripgrep

ripgrep is installed by Home Manager and gets a small default config at
`~/.config/ripgrep/config`.

## Defaults

| Setting                      | Purpose                                                  |
| ---------------------------- | -------------------------------------------------------- |
| `--line-number`              | Show file line numbers.                                  |
| `--smart-case`               | Case-insensitive search unless the pattern has capitals. |
| `--max-columns=120`          | Avoid unreadably long output lines.                      |
| `--max-columns-preview`      | Still show a preview for long lines.                     |
| `--type-add=nix:*.nix`       | Teach ripgrep about Nix files.                           |
| `--glob=!.git/*`             | Skip Git internals.                                      |
| `--glob=!**/node_modules/**` | Skip JS dependencies.                                    |
| `--glob=!**/target/**`       | Skip Rust build output.                                  |
| `--glob=!**/.build/**`       | Skip common build output.                                |

## Usage

General search examples live in [Tools](../tools.md).

This page only documents the repo default behavior.
