# Screen cheatsheet

## Screen sessions

| Description                  | Command            |
|------------------------------|--------------------|
| Start a new screen session   | `screen -S <name>` |
| List running sessions        | `screen -ls`       |
| Attach to a session          | `screen -r <name>` |
| The "ultimate attach"        | `screen -dRR`      |
| Detach from a screen session | `^a` + `d`         |
| Logout from a screen session | `^a` + `^\`        |

## Screen windows

| Description                | Command                              |
|----------------------------|--------------------------------------|
| Create new screen window   | `^a` + `c`                           |
| Kill current screen window | `^a` + `k`                           |
| List windows               | `^a` + `"`                           |
| Change to n-window         | `^a` + `[0-9]`                       |
| Change to next window      | `^a` + `n`                           |
| Change to previous window  | `^a` + `p`                           |
| Close current window       | `^d` or `exit` built-in (quit shell) |

## Screen regions

| Description                 | Command        |
|-----------------------------|----------------|
| Split terminal horizontally | `^a` + `S`     |
| Split terminal vertically   | `^a` + `\|`    |
| Go to terminal split area   | `^a` + `[TAB]` |
| Quit split region           | `^a` + `X`     |

## Key bindings

Create a new `.screenrc` file with the following snippet:

```
bindkey "^A^[OA" focus up
bindkey "^A^[OB" focus down
bindkey "^A^[OC" focus right
bindkey "^A^[OD" focus left
```

You can now use the following bindings to change the screen region:

- <kbd>Ctrl</kbd> + <kbd>A</kbd> + <kbd>&uarr;</kbd>
- <kbd>Ctrl</kbd> + <kbd>A</kbd> + <kbd>&darr;</kbd>
- <kbd>Ctrl</kbd> + <kbd>A</kbd> + <kbd>&rarr;</kbd>
- <kbd>Ctrl</kbd> + <kbd>A</kbd> + <kbd>&larr;</kbd>
