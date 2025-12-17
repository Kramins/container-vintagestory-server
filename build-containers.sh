#!/bin/bash

# Default bake file
BAKE_FILE=""

# Parse arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --dev-container)
      BAKE_FILE="VintageStory-DevContainer.hcl"
      shift # Remove argument from processing
      ;;
    --server)
      BAKE_FILE="VintageStory-Server.hcl"
      shift # Remove argument from processing
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
  shift
done

# Check if a bake file was specified
if [ -z "$BAKE_FILE" ]; then
  echo "Error: You must specify either --dev-container or --server"
  echo "Usage: $0 [--dev-container|--server]"
  exit 1
fi

# Build using the specified bake file
docker buildx bake --file "$BAKE_FILE"