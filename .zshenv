
# Homebrew configuration - for SSH
if ! echo "$PATH" | grep --quiet "brew"; then
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# add /usr/local/data/bin to the PATH if needed - for SSH
! echo "$PATH" | grep --quiet "/usr/local/data/bin" && export PATH="/usr/local/data/bin${PATH+:$PATH}"
