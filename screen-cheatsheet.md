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
| Change to n-window         | `^a` + `[0-9]`                       |
| Change to next window      | `^a` + `n`                           |
| Change to previous window  | `^a` + `p`                           |
| Close current window       | `^d` or `exit` built-in (quit shell) |

## Screen areas

| Description                 | Command        |
|-----------------------------|----------------|
| Split terminal horizontally | `^a` + `S`     |
| Split terminal vertically   | `^a` + `|`     |
| Go to terminal split area   | `^a` + `[TAB]` |
| Quit split area             | `^a` + `X`     |
