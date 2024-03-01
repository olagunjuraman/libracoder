#!/bin/sh

# Check if Azure Blob Storage details are set
if [ -z "$AZURE_STORAGE_CONNECTION_STRING" ]; then
  echo "Error: The environment variable AZURE_STORAGE_CONNECTION_STRING is not set."
  echo "Set this variable to your Azure Blob Storage connection string."
  exit 1
fi

# Start the Node.js application
echo "Starting Node.js application..."
exec node app.js
