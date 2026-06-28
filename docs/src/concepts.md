# Nix Concepts

This chapter is for teaching Nix and explaining the moving parts behind this
repository. Operational pages should link here instead of re-explaining flakes,
modules, or Home Manager each time they mention them.

| Topic                                                      | Use it for                                                 |
| ---------------------------------------------------------- | ---------------------------------------------------------- |
| [Language basics](./concepts/language.md)                  | Reading Nix expressions and small snippets.                |
| [Flakes](./concepts/flakes.md)                             | Understanding inputs, outputs, and the lock file.          |
| [Modules](./concepts/modules.md)                           | Understanding how NixOS and Home Manager compose settings. |
| [NixOS and Home Manager](./concepts/nixos-home-manager.md) | How system and user config fit together in this repo.      |

The rest of the book should stay practical: what owns a service, how to rebuild
it, what to check when it breaks, and which decisions matter.
