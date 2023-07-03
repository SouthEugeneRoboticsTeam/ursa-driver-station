#!/bin/sh

flutter gen-l10n > /dev/null

# If untranslated_messages.json is an empty object "{}", exit with 0
if [ "$(cat untranslated_messages.json)" = "{}" ]; then
  echo "All messages are translated!"
  exit 0
fi

echo "Untranslated messages:"
cat untranslated_messages.json | jq -r 'to_entries | .[] | .key + ":" + "\n" + "  - " + (.value | join("\n  - "))'

exit 1
