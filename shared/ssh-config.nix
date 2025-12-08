{ pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    addKeysToAgent = if pkgs.stdenv.isDarwin then "yes" else "no";
    extraConfig = ''
      # SOPS-managed Git provider SSH keys
      Host github.com
        HostName github.com
        User git
        IdentityFile ${
          if pkgs.stdenv.isDarwin then "~/.local/share/sops/keys_gh" else "/run/secrets/keys_gh"
        }
        IdentitiesOnly yes${
          if pkgs.stdenv.isDarwin then "\n        AddKeysToAgent yes\n        UseKeychain yes" else ""
        }

      Host codeberg.org
        HostName codeberg.org
        User git
        IdentityFile ${
          if pkgs.stdenv.isDarwin then "~/.local/share/sops/keys_codeberg" else "/run/secrets/keys_codeberg"
        }
        IdentitiesOnly yes${
          if pkgs.stdenv.isDarwin then "\n        AddKeysToAgent yes\n        UseKeychain yes" else ""
        }

      Host tangled.org
        HostName tangled.org
        User git
        IdentityFile ${
          if pkgs.stdenv.isDarwin then "~/.local/share/sops/keys_tangled" else "/run/secrets/keys_tangled"
        }
        IdentitiesOnly yes${
          if pkgs.stdenv.isDarwin then "\n        AddKeysToAgent yes\n        UseKeychain yes" else ""
        }
    '';
  };
}