# Checks this machine's packages, mise tools, and MCP servers. Both commands
# only read state, so this tape runs against the real home directory.

Output docs/src/assets/demos/dots-doctor.gif
Source docs/demos/settings.tape
Set Height 520
Require dots

Hide
Type 'PROMPT="%F{4}❯%f " && clear'
Enter
Show

Type "dots doctor"
Sleep 400ms
Enter
Wait@60s /❯\s*$/
Sleep 3s

Type "dots mcp"
Sleep 400ms
Enter
Wait@30s /❯\s*$/
Sleep 3s
