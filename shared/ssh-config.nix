{ ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
      AddKeysToAgent = "no";
    };
    extraConfig = ''
      # SOPS-managed Git provider SSH keys
      Host github.com
        HostName github.com
        User git
        IdentityFile /run/secrets/keys_gh
        IdentitiesOnly yes

      Host codeberg.org
        HostName codeberg.org
        User git
        IdentityFile /run/secrets/keys_codeberg
        IdentitiesOnly yes

      Host tangled.sh
        HostName tangled.org
        User git
        IdentityFile /run/secrets/keys_tangled
        IdentitiesOnly yes
    '';
  };
}
