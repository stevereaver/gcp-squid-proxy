## GCP Squid Proxy

This is a project designed to build out a Squid proxy. The idea is to give a single source IP address when accessing clients so that single IP can be whitelisted with them.

It is only possible to connect to the proxy using an IAP Tunnel.

## Installation
Firstly you need to set up a few variables. Edit `config.sh` and replace the values in side the angled brackets `< >` to values that make sense to you.

Then simply run `deploy.sh`

## Usage
Once deployed a squid proxy will be in place and you will be able to connect to it using IAP;

```gcloud compute start-iap-tunnel squid-proxy 3128 --local-host-port=localhost:3128 --zone=<ZONE> --project=<PROJECT NAME>```

Or you can ssh to a remote sever through the proxy with something like this;

``gcloud compute ssh <YOUR NAME>@squid-proxy --zone "<ZONE>" --tunnel-through-iap --project "<PROJECT NAME>" -- -tt ssh <remote server account>@<remote server IP>``

## Further Reading
There is documentation on how to use the proxy on the confluence page. 
