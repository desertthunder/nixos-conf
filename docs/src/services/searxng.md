# SearXNG

Haxorus runs a private SearXNG instance at
<http://127.0.0.1:9090>. The firewall stays closed and the service listens only
on loopback, so other machines cannot connect to it.

## Search API

The instance enables the browser interface, JSON output, and RSS output. RSS is
the XML format supported by SearXNG; SearXNG does not provide a separate
`format=xml` response.

```bash
curl 'http://127.0.0.1:9090/search?q=nixos&format=json'
curl 'http://127.0.0.1:9090/search?q=nixos&format=rss'
```

The preferences page remains unlocked. Users can change the theme, language,
categories, safe search, autocomplete, and other exposed search settings.

## State and configuration

The NixOS module is `conf/services/searxng.nix`, and Haxorus enables it from
`conf/machines/thinkpad/configuration.nix`.

The service generates its secret once at `/var/lib/searx/environment` and
reuses it across rebuilds. The file is readable only by root and the `searx`
service account. No secret is stored in the Nix store.

## Checks

```bash
systemctl status searx
curl --fail http://127.0.0.1:9090/
journalctl -u searx -b
```
