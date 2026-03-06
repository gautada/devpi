# devpi

Private Python package registry based on
[devpi-server](https://devpi.net), built on `gautada/debian`.

## Overview

Provides two indices:

- `root/pypi` — upstream PyPI proxy and cache
- A private index for internal gautada packages

Uses devpi-server with devpi-web for a browser UI.

## Usage

```shell
docker run \
  -v devpi-data:/mnt/volumes/data \
  -p 3141:3141 \
  gautada/devpi:latest
```

On first start, devpi initializes the data directory automatically.

## Environment

| Variable | Default | Description |
| --- | --- | --- |
| _(none required)_ | — | Data path is fixed at `/mnt/volumes/data` |

## Publishing Packages

Install the devpi client and configure your index:

```shell
pip install devpi-client
devpi use http://localhost:3141
devpi login root --password=''
devpi index -c gautada/dev bases=root/pypi
```

Push a package with `uv`:

```shell
uv publish --index-url http://localhost:3141/gautada/dev/
```

## Health Checks

- `appversion-check` — Compares running devpi-server version against
  the latest release on PyPI.
- `devpi-running` — Verifies the devpi API responds on port 3141.

## References

- [devpi documentation](https://devpi.net/docs/devpi/devpi/stable/+d/index.html)
- [devpi on PyPI](https://pypi.org/project/devpi-server/)
