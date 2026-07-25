#!/bin/sh
printf '\033c\033]0;%s\a' lucyd dreams
base_path="$(dirname "$(realpath "$0")")"
"$base_path/lucyd_dreams.x86_64" "$@"
