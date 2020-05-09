# asterisk-16-ari

This project is designed to build a standalone Asterisk 16 container that exposes an ARI service, and registers a SIP trunk.

Inbound calls are then handled exclusively by ARI through a "1-line" stasis dialplan.

The Asterisk container has no state, only the following configuration by environment variables...

## Launching and environment

Set environment variables
```
export TRUNK_TYPE=Simwood;
```
Currently supported options are `IPCortex` and `Simwood`. For _Simwood_, SIP Registrar is hard coded, for IPCortex, you will need to set this to the domain name of the appliance/service you are using:
```
export SIP_REGISTRAR=<myserver>;
```
This container uses TLS, so the Registrar must be a FQDN of a server listening on 5061 with a verifiable certificate, *not an IP address*.

For all service types, you will need SIP credentials to register with authentication:

```
export TRUNK_USER=<your username>;
export TRUNK_PASSWORD=<your password>;
```

Then you will need to set the name and credentials that the stasis application will use to connect to Asterisk:

```
export ARI_APPLICATION=<your application name>;
```

```
export ARI_USER=<your username>;
export ARI_PASSWORD=<your password>;
```

Launch using:
```
docker-compose start
```

## Dev environment
In dev environment:
```
docker-compose -f docker-compose-dev.yaml start
```

The dev.yaml service spec mounts /etc/asterisk and /templates from the current working directory for development. /etc/asterisk is still initialised (overwritten) from the templates and environment at container start time, but can then by modified on the host filesystem to experiment with settings. This may need Asterisk re-starts, which can be accomplished by connecting to the asterisk CLI:

```
docker-compose exec  asterisk-16-ari rasterisk
```


When done commit changes to templates (with environment substitution) for production use and test by restarting service.
