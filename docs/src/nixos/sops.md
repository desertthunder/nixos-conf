# SOPS Secrets Management

SOPS encrypts secrets with AES256-GCM for safe version control storage.
During system activation, [sops-nix](https://github.com/Mic92/sops-nix) automatically decrypts secrets where applications can access them.

```text
Encrypted File → SOPS Runtime → Machine Private Key → Decrypted Secrets → Application
```

## Setup

### 1. Generate your personal age key

```bash
# Generate proper age key pair
nix-shell -p age --run 'age-keygen -o age.txt'
```

Store this key in your password manager for access across machines. The file contains both public and private keys.

### 2. Get machine's age key

```bash
ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
```

Be sure to add to `.sops.yaml` with names matching flake configurations

### 3. Add SSH Keys

Install SOPS, set up the environment, and edit the secrets file:

```bash
nix-shell -p sops

export SOPS_AGE_KEY_FILE=$(pwd)/age.txt

# First time: encrypt the plaintext file
sops --encrypt --in-place secrets/owais.yaml

# Edit the encrypted file (add your actual SSH keys)
sops secrets/owais.yaml
```

```bash
SOPS_AGE_KEY_FILE=$(pwd)/age.txt sops secrets/owais.yaml
```

### 4. Copy age key to home-manager location

```bash
# For macOS home-manager SOPS support
mkdir -p ~/.config/sops/age
cp age.txt ~/.config/sops/age/keys.txt
```

### 5. Deploy

```bash
nix flake update
# Replace with your machine
sudo [nixos|darwin]-rebuild switch --flake .#owais-nix-thinkpad
```

## Usage

**Edit secrets**: `SOPS_AGE_KEY_FILE=$(pwd)/age.txt sops secrets/owais.yaml`

**Deploy changes**:

`sudo [nixos|darwin]-rebuild switch --flake .#owais-nix-[machine]`

**Debug**:

- NixOS: `ls -la /run/secrets/`
- macOS: `ls -la ~/.local/share/sops/`
- View encrypted: `SOPS_AGE_KEY_FILE=$(pwd)/age.txt sops -d secrets/owais.yaml`

## Updating SSH Keys

To replace an existing SSH key in the encrypted secrets:

1. **Edit the encrypted file:**

   ```bash
   SOPS_AGE_KEY_FILE=$(pwd)/age.txt sops secrets/owais.yaml
   ```

2. **Add new private key** between the `-----BEGIN` and `-----END` lines
3. **Deploy the updated secrets:**

   ```bash
   sudo [nixos|darwin]-rebuild switch --flake .#owais-nix-[machine]
   ```

## All Machines Configured

All platforms use the same encrypted `secrets/owais.yaml` file and personal age key for unified secret management across your entire fleet.
