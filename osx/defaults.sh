#!/usr/bin/env bash
# macOS preferences captured from the old Mac (2026-10-29).
# Run once on the new Mac as your normal user (no sudo), then log out and back in.
#
# Before running: create 4 desktops in Mission Control, otherwise the
# Cmd+1..4 "Switch to Desktop N" shortcuts have nothing to bind to.
#
# Not covered (set by hand): per-keyboard modifier remaps (System Settings >
# Keyboard > Keyboard Shortcuts > Modifier Keys), Alfred, AltTab, Maccy, Logi Options+.
set -euo pipefail

[[ $(uname -s) == Darwin ]] || { echo "macOS only" >&2; exit 1; }
[[ $EUID -ne 0 ]] || { echo "run as your user, not root" >&2; exit 1; }

# Close System Settings so it doesn't overwrite what we write.
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

g() { defaults write NSGlobalDomain "$@"; }

echo "Keyboard and text"
g KeyRepeat -int 1
g InitialKeyRepeat -int 15
g ApplePressAndHoldEnabled -bool false # key repeat instead of the accent popup
g AppleKeyboardUIMode -int 2           # Tab moves focus between all controls
for k in NSAutomaticSpellingCorrectionEnabled NSAutomaticCapitalizationEnabled \
  NSAutomaticQuoteSubstitutionEnabled NSAutomaticDashSubstitutionEnabled \
  NSAutomaticPeriodSubstitutionEnabled; do
  g "$k" -bool false
done

echo "Appearance"
g AppleShowAllExtensions -bool true
g AppleInterfaceStyle -string Dark

echo "Dock and Spaces"
# yabai needs a stable space order (mru-spaces off) and separate Spaces per display.
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -float 68
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock wvous-br-corner -int 1 # bottom-right hot corner: none
defaults write com.apple.spaces spans-displays -bool false

echo "Finder"
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string clmv # column view
defaults write com.apple.finder FXDefaultSearchScope -string SCcf # search current folder
defaults write com.apple.finder NewWindowTarget -string PfAF

echo "Window Manager"
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

echo "System keyboard shortcuts"
# hk <id> <enabled 0|1> <ASCII code or 65535> <virtual key code> <modifier mask>
# Written as an XML value: the old-style '{enabled = 0; ...}' syntax stores
# every number as a string, which is not what macOS itself writes.
hk() {
  local enabled=false
  [[ $2 == 1 ]] && enabled=true
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$1" \
    "<dict><key>enabled</key><$enabled/><key>value</key><dict><key>parameters</key><array><integer>$3</integer><integer>$4</integer><integer>$5</integer></array><key>type</key><string>standard</string></dict></dict>"
}
hk 32 0 65535 126 8650752   # Mission Control: off
hk 33 0 65535 125 8650752   # Application windows: off
hk 36 0 65535 103 8388608   # Show Desktop: off
hk 52 0 100 2 1572864       # Turn Dock hiding on/off: off
hk 60 0 32 49 262144        # Previous input source: off
hk 61 1 32 49 262144        # Next input source: Ctrl+Space
hk 64 0 65535 49 1048576    # Spotlight: off (Alfred takes Cmd+Space)
hk 65 0 32 49 1048576       # Finder search window: off
hk 79 1 65535 123 11534336  # Move left a space: Cmd+Left
hk 81 1 65535 124 11534336  # Move right a space: Cmd+Right
hk 118 1 49 18 1048576      # Switch to Desktop 1: Cmd+1
hk 119 1 50 19 1048576      # Switch to Desktop 2: Cmd+2
hk 120 1 51 20 1048576      # Switch to Desktop 3: Cmd+3
hk 121 1 52 21 1048576      # Switch to Desktop 4: Cmd+4

echo "Restarting Dock, Finder, SystemUIServer"
for app in Dock Finder SystemUIServer; do killall "$app" 2>/dev/null || true; done

echo "Done. Log out and back in so keyboard shortcuts and key repeat take effect."
