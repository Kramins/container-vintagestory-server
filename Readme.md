# Vintage Story Server Docker Container

This repository provides a Docker container for running a Vintage Story game server.

- **Status:** Alpha (expect breaking changes)

## Usage

Build the container:

```sh
./build-containers.sh
```

Test the container:

```sh
./test-container.sh
```

See the Dockerfile and environment variables for configuration options.

## Features
- Based on Ubuntu 24.04
- Installs all dependencies for Vintage Story server
- Data and logs are stored in `/data`

## Environment Variables

You can configure the server using the following environment variables:

| Variable                      | Default Value      | Description                       |
|-------------------------------|-------------------|-----------------------------------|
| VS_DATA_PATH                  | /data/vs          | Path for server data               |
| VS_LOG_PATH                   | /data/logs        | Path for server logs               |
| VS_ADD_ORIGIN                 | /data/origin      | Path for origin files              |
| VS_IP                         |                   | Server IP address (optional)       |
| VS_PORT                       | 42420             | Server port                        |
| VS_MAXCLIENTS                 | 16                | Maximum number of clients          |
| VS_REDUCEDTHREADS             | false             | Use reduced threads                |
| VS_ARCHIVE_LOG_FILE_COUNT     | 5                 | Log archive file count             |
| VS_ARCHIVE_LOG_FILE_MAX_SIZE_MB| 1024             | Log archive max size (MB)          |
| VS_EXTRA_ARGS                 |                   | Extra arguments for the server     |

Set these variables when running the container to customize server behavior.

## License

MIT License. See `LICENSE` file for details.
