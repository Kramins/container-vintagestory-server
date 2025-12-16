#!/bin/bash

# Default bake file
BAKE_FILE="docker-bake.hcl"

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

# Build using the specified bake file
docker buildx bake --file "$BAKE_FILE"