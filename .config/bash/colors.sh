#!/bin/bash

# From: https://raw.githubusercontent.com/wincent/wincent/master/roles/dotfiles/files/.zsh/colors

#
# Colors
#

BASE16_DIR=~/.config/base16-shell
BASE16_CONFIG=~/.base16

color() {
  BACKGROUND="$1"
  SCHEME="$2"

  if [ $# -eq 0 -a -s "$BASE16_CONFIG" ]; then
    cat $BASE16_CONFIG
    return
  fi

  if [[ "$SCHEME" = 'help' ]]; then
    BACKGROUND='help'
  fi

  case "$BACKGROUND" in
  dark|light)
    FILE="$BASE16_DIR/base16-$SCHEME.$BACKGROUND.sh"
    if [[ -x "$FILE" ]]; then
      echo "$SCHEME" > "$BASE16_CONFIG"
      echo "$BACKGROUND" >> "$BASE16_CONFIG"
      "$FILE"
    else
      echo "Scheme '$SCHEME' not found in $BASE16_DIR"
      return 1
    fi
    ;;
  help)
    echo 'color dark [ocean|grayscale|ashes|default|railscasts|tomorrow|twilight|...]'
    echo 'color light [grayscale|harmonic16|ocean|tomorrow|twilight|...]'
    echo
    echo 'Available schemes:'
    find $BASE16_DIR -name 'base16-*.sh' | \
      sed -E 's|.+/base16-||' | \
      sed -E 's/\.(dark|light)\.sh/ (\1)/' | \
      column
      ;;

  *)
    echo 'Unknown subcommand: use one of {dark,light,help}'
    ;;
  esac

}

dark() {
  color dark "$1"
}

light() {
  color light "$1"
}

if [[ -s "$BASE16_CONFIG" ]]; then
  SCHEME=$(head -1 "$BASE16_CONFIG")
  BACKGROUND=$(sed -n -e '2 p' "$BASE16_CONFIG")
  if [ "$BACKGROUND" = 'dark' ]; then
    dark "$SCHEME"
  elif [ "$BACKGROUND" = 'light' ]; then
    light "$SCHEME"
  else
    echo "error: unknown background type in $BASE16_CONFIG"
  fi
else
  # default
  dark solarized
fi
