#!/bin/sh

APP_USER="vintagestory"
APP_GROUP="vintagestory"

# Default environment variables
VS_DATA_PATH=${VS_DATA_PATH:-/data/data}
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
- Data Path: ${VS_DATA_PATH:-/data/data}
- Log Path: ${VS_LOG_PATH:-/data/logs}
- Origin Path: ${VS_ADD_ORIGIN:-/data/origin}
- Server IP: ${VS_IP:-Not Set}
- Server Port: ${VS_PORT:-42420}
- Max Clients: ${VS_MAXCLIENTS:-16}
- Reduced Threads: ${VS_REDUCEDTHREADS:-false}
- Log Archive Count: ${VS_ARCHIVE_LOG_FILE_COUNT:-5}
- Log Archive Max Size (MB): ${VS_ARCHIVE_LOG_FILE_MAX_SIZE_MB:-1024}
- Extra Arguments: ${VS_EXTRA_ARGS:-""}
EOF

# Ensure necessary directories exist
[ -n "$VS_DATA_PATH" ] && mkdir -p "$VS_DATA_PATH"
[ -n "$VS_LOG_PATH" ] && mkdir -p "$VS_LOG_PATH"
[ -n "$VS_ADD_ORIGIN" ] && mkdir -p "$VS_ADD_ORIGIN"

# Set ownership of data directories
chown -R "$APP_USER:$APP_GROUP" "$VS_DATA_PATH"
chown -R "$APP_USER:$APP_GROUP" "$VS_LOG_PATH"
chown -R "$APP_USER:$APP_GROUP" "$VS_ADD_ORIGIN"


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