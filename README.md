# asterisk-16-ari

This project is designed to build a standalone Asterisk 16 container that exposes an ARI service, and registers a SIP trunk.

Inbound calls are then handled exclusively by ARI through a "1-line" stasis dialplan.

The Asterisk container has no state, only the following configuration by environment variables.

## Launching and environment

Set environment variables
```
TRUNK_TYPE=Simwood; export TRUNK_TYPE
```
Currently supported options are only Simwood
```
TRUNK_USER=<your username>; export TRUNK_USER
TRUNK_PASSWORD=<your password>; export TRUNK_PASSWORD
```

```
ARI_APPLICATION=<your application name>; export ARI_APPLICATION
```

```
ARI_USER=<your username>; export ARI_USER
ARI_PASSWORD=<your password>; export ARI_PASSWORD
```

Launch using:
```
docker-compose up
```

in dev environment:
```
docker-compose -f docker-compose-dev.yaml up
```

mounts /etc/asterisk and /templates from the current working directory for development
