# Zed

Zed is managed through Home Manager and installed from `nixpkgs-unstable` so the
editor can move faster than the system channel.

## Extensions

Extensions are declared in `programs.zed-editor.extensions`. Keep that list in
source rather than duplicating it here; it changes more often than the operating
model.

The important rule is that registry themes must have both pieces:

| Need                | Example              |
| ------------------- | -------------------- |
| Extension installed | `carbonfox`          |
| Theme selected      | `Carbonfox - opaque` |
