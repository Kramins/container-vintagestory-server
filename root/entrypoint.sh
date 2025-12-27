#!/bin/sh

APP_USER="vintagestory"
APP_GROUP="vintagestory"

# Default environment variables
VS_DATA_PATH=${VS_DATA_PATH:-/data/data}
VS_MODS_PATH=${VS_MODS_PATH:-${VS_DATA_PATH}/Mods}
VS_LOG_PATH=${VS_LOG_PATH:-/data/logs}
VS_ADD_ORIGIN=${VS_ADD_ORIGIN:-/data/origin}
VS_IP=${VS_IP:-}
VS_PORT=${VS_PORT:-42420}
VS_MAXCLIENTS=${VS_MAXCLIENTS:-16}
VS_REDUCEDTHREADS=${VS_REDUCEDTHREADS:-false}
VS_ARCHIVE_LOG_FILE_COUNT=${VS_ARCHIVE_LOG_FILE_COUNT:-5}
VS_ARCHIVE_LOG_FILE_MAX_SIZE_MB=${VS_ARCHIVE_LOG_FILE_MAX_SIZE_MB:-1024}
VS_EXTRA_ARGS=${VS_EXTRA_ARGS:-""}

# Print server settings to the console
cat <<EOF
Starting Vintage Story Server with the following settings:
- Data Path: ${VS_DATA_PATH}
- Mods Path: ${VS_MODS_PATH}
- Log Path: ${VS_LOG_PATH}
- Origin Path: ${VS_ADD_ORIGIN}
- Server IP: ${VS_IP:-Not Set}
- Server Port: ${VS_PORT}
- Max Clients: ${VS_MAXCLIENTS}
- Reduced Threads: ${VS_REDUCEDTHREADS}
- Log Archive Count: ${VS_ARCHIVE_LOG_FILE_COUNT}
- Log Archive Max Size (MB): ${VS_ARCHIVE_LOG_FILE_MAX_SIZE_MB}
- Extra Arguments: ${VS_EXTRA_ARGS}
EOF

# Ensure necessary directories exist
[ -n "$VS_DATA_PATH" ] && mkdir -p "$VS_DATA_PATH"
[ -n "$VS_MODS_PATH" ] && mkdir -p "$VS_MODS_PATH"
[ -n "$VS_LOG_PATH" ] && mkdir -p "$VS_LOG_PATH"
[ -n "$VS_ADD_ORIGIN" ] && mkdir -p "$VS_ADD_ORIGIN"

# Set ownership of data directories
chown -R "$APP_USER:$APP_GROUP" "$VS_DATA_PATH"
chown -R "$APP_USER:$APP_GROUP" "$VS_MODS_PATH"
chown -R "$APP_USER:$APP_GROUP" "$VS_LOG_PATH"
chown -R "$APP_USER:$APP_GROUP" "$VS_ADD_ORIGIN"

# Download and install Granite Server if configured
if [ -n "$GS_REPO_PATH" ] && [ -n "$GS_VERSION" ]; then
    echo "Granite Server configuration detected:"
    echo "- Repository: ${GS_REPO_PATH}"
    echo "- Version: ${GS_VERSION}"
    
    if [ "$GS_VERSION" = "latest" ]; then
        echo "Fetching latest Granite Server release..."
        # Get the first release (including prereleases) from the releases list
        RELEASE_DATA=$(curl -s "https://api.github.com/repos/${GS_REPO_PATH}/releases" | grep -m 1 -B 50 "browser_download_url.*GraniteServer-Release.*\.zip")
        DOWNLOAD_URL=$(echo "$RELEASE_DATA" | grep "browser_download_url.*GraniteServer-Release.*\.zip" | head -1 | cut -d '"' -f 4)
        TAG_NAME=$(echo "$RELEASE_DATA" | grep '"tag_name":' | head -1 | cut -d '"' -f 4)
    else
        echo "Fetching Granite Server release ${GS_VERSION}..."
        DOWNLOAD_URL=$(curl -s "https://api.github.com/repos/${GS_REPO_PATH}/releases/tags/${GS_VERSION}" | grep "browser_download_url.*GraniteServer-Release.*\.zip" | cut -d '"' -f 4)
        TAG_NAME="$GS_VERSION"
    fi
    
    if [ -n "$DOWNLOAD_URL" ]; then
        echo "Downloading Granite Server ${TAG_NAME} from: ${DOWNLOAD_URL}"
        cd /tmp
        wget -q "$DOWNLOAD_URL" -O granite-server.zip
        
        if [ -f granite-server.zip ]; then
            echo "Installing Granite Server to ${VS_MODS_PATH}..."
            mv granite-server.zip "$VS_MODS_PATH/"
            chown -R "$APP_USER:$APP_GROUP" "$VS_MODS_PATH"
            echo "Granite Server ${TAG_NAME} installed successfully!"
        else
            echo "Warning: Failed to download Granite Server"
        fi
    else
        echo "Warning: Could not find download URL for Granite Server"
    fi
fi

cd /app/
# Switch to the application user
su -s /bin/sh "$APP_USER" -c "exec dotnet VintagestoryServer.dll \
  --dataPath \"$VS_DATA_PATH\" \
  ${VS_LOG_PATH:+--logPath \"$VS_LOG_PATH\"} \
  ${VS_ADD_ORIGIN:+--addOrigin \"$VS_ADD_ORIGIN\"} \
  ${VS_IP:+--ip \"$VS_IP\"} \
  --port \"$VS_PORT\" \
  --maxclients \"$VS_MAXCLIENTS\" \
  ${VS_REDUCEDTHREADS:+--reducedthreads} \
  --archiveLogFileCount \"$VS_ARCHIVE_LOG_FILE_COUNT\" \
  --archiveLogFileMaxSizeMb \"$VS_ARCHIVE_LOG_FILE_MAX_SIZE_MB\" \
  $VS_EXTRA_ARGS"