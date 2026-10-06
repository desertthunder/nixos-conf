# Links the dotfiles into the throwaway home that record.sh creates, then
# undoes the run. Record it with record.sh, not by running vhs directly.

Output docs/src/assets/demos/dots-link.gif
Source docs/demos/settings.tape
Require dots

Hide
Type 'export HOME="$DEMO_HOME" PROMPT="%F{4}❯%f " && cd && clear'
Enter
Show

Type "dots link"
Sleep 400ms
Enter
Wait@20s /❯\s*$/
Sleep 4s

Hide
Type "clear"
Enter
Show

Type "dots link --apply"
Sleep 400ms
Enter
Wait@20s /❯\s*$/
Sleep 3s

Hide
Type "clear"
Enter
Show

Type "dots status"
Sleep 400ms
Enter
Wait@20s /❯\s*$/
Sleep 4s

Hide
Type "clear"
Enter
Show

Type "dots restore"
Sleep 400ms
Enter
Wait@20s /❯\s*$/
Sleep 3s
