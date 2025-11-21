#!/bin/bash

dotfiles_can_install() {
  if [[ ! "$(uname)" =~ 'Darwin' ]]; then
    return 1
  fi
  return 0
}

dotfiles_run_install() {
  local script_target="$HOME/Library/Scripts/keymap-uk2us.sh"

  ln -sf ../../.local/scripts/keymap-uk2us.sh "$script_target"
  cat <<EOF >"$HOME/Library/LaunchAgents/com.user.keymap-uk2us.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.user.keymap-uk2us</string>
    <key>ProgramArguments</key>
    <array>
      <string>$script_target</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
  </dict>
</plist>
EOF
}
