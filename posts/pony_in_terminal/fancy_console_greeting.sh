#!/bin/bash
# Author: Kasia Kedzierska
# Date: 2024-09-20
# Version: 1.0
#
# Description:
# Displays a fancy greeting message in the console.
#
# (1) The script checks for required dependencies and prompts to install
#     them if missing.
# (2) Then, it composes a welcome message that includes the current date
#     and a fortune snippet.
# (3) The message is then displayed using either cowsay or ponysay, randomly
#     chosen, with color effects applied by lolcat.
#
# Usage:
#   ./fancy_console_greeting.sh [--verbose/-v]
#
# Options:
#   --verbose/-v   Enable verbose mode.

# Constants
readonly DEPENDENCIES=(cowsay fortune lolcat ponysay)

# Default settings
verbose=false

# Parse arguments
for arg in "$@"; do
  case $arg in
  --verbose | -v)
    verbose=true
    shift
    ;;
  *)
    echo "Unknown option: $arg"
    exit 1
    ;;
  esac
done

# Variables
missing_deps=()
dep=""
current_date=""
fortune_msg=""
message=""
cow_file=""

# Check for missing dependencies
for dep in "${DEPENDENCIES[@]}"; do
  if ! command -v "${dep}" &>/dev/null; then
    missing_deps+=("${dep}")
  fi
done

# If there are any dependencies to install, print a message and exit
if [[ ${#missing_deps[@]} -gt 0 ]]; then
  echo "To use fancy_console_greeting, you need to install the following " \
    "dependencies: ${missing_deps[*]}"
  exit 1
fi

# Compose the message
current_date=$(date '+%H:%M on %A, %B %d, %Y')
fortune_msg=$(fortune -s wisdom)
message="Welcome!\n\n"
message+="It's ${current_date}.\n\n"
message+="Today's wisdom:\n"
message+="${fortune_msg}"

# Randomly choose between a cow or a pony
if ((RANDOM % 2 == 0)); then
  # Sample an image from the cowsay set
  cow_file=$(cowsay -l | tail -n +2 | tr ' ' '\n' | shuf | head -n 1)
  echo -e "${message}" | cowsay -f "${cow_file}" -W 45 | lolcat -F 0.01
else
  if [ "$verbose" = true ]; then
    echo -e "${message}" | ponysay --compact
  else
    echo -e "${message}" | ponysay --compact 2>/dev/null
  fi
fi
