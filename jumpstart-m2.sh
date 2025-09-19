#!/usr/bin/env bash

set -e
clear
# Get terminal width
term_width=$(tput cols)

# ASCII Art Lines
ascii_art=(
"░█▀▄░█░░░█▀█░▀▀█░█▀▀░█░█░█▀█░█▀▀░█░█"
"░█▀▄░█░░░█▀█░▄▀░░█▀▀░█▀█░█▀█░█░░░█▀▄"
"░▀▀░░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀"
)

subtitle="Blazehack - Jumpstart M2"

# Print ASCII art centered
for line in "${ascii_art[@]}"; do
    padding=$(( (term_width - ${#line}) / 2 ))
    printf "%*s%s\n" "$padding" "" "$line"
    sleep 0.3
done

# Print subtitle centered
padding=$(( (term_width - ${#subtitle}) / 2 ))
printf "\n%*s%s\n\n" "$padding" "" "$subtitle"

echo ""

# Get the current directory name
CURRENT_DIR=$(basename "$PWD")

if [[ "$CURRENT_DIR" != "blazenote-backend" ]]; then
  if [[ -d "blazenote-backend" ]]; then
    cd blazenote-backend || { echo "[ERROR] Failed to cd into blazenote-backend"; exit 1; }
  else
    echo "[ERROR] blazenote-backend directory not found in current location."
    exit 1
  fi
else
  echo "[OK] Already in blazenote-backend/"
fi

echo "Checking out starter branch..."
git checkout starter

echo ""

# Ask for Cloudflare Account ID if not set
echo ""
if [ -z "$CLOUDFLARE_ACCOUNT_ID" ]; then
  while true; do
    echo ""
    read -p "Please enter your Cloudflare Account ID: " CLOUDFLARE_ACCOUNT_ID
    echo "Account ID entered: $CLOUDFLARE_ACCOUNT_ID"
    read -p "Is this correct? Double check please [Y/n]: " confirm
    confirm=${confirm:-Y}
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      break
    fi
  done
fi

export CLOUDFLARE_ACCOUNT_ID

# We need to open this url, if not user will be prompt to create a pages.dev domain, complicating the process
URL="https://dash.cloudflare.com/${CLOUDFLARE_ACCOUNT_ID}/workers-and-pages"
if command -v xdg-open > /dev/null; then
  xdg-open "$URL"
elif command -v open > /dev/null; then
  open "$URL"
elif command -v start > /dev/null; then
  start "$URL"
else
  echo "Please open this URL manually: $URL"
fi

wrangler login

echo ""
echo "Installing dependencies..."
npm install

echo "Preparing to deploy..."
sleep 10

wrangler deploy
echo ""
echo ""
echo "[OK] Backend deployed"
echo "[OK] Please continue with Jumpstart: Step 4 - Setting up the backend"