#!/bin/env bash

# shellcheck source=locales/en-us/misc.sh
source "tui/locales/$LOCALE/misc.sh"

# shellcheck source=locales/en-us/update.sh
source "tui/locales/$LOCALE/update.sh"

whiptail --yesno --no-button "$NO_BUTTON" --yes-button "$YES_BUTTON" --title "$TITLE" "$CONTENT" "$TUI_WINDOW_HEIGHT" "$TUI_WINDOW_WIDTH"

exit_status=$?
if [ "$exit_status" -eq 1 ]; then
  exit 0
fi
