**This is WIP - No stable or clean release,yet**

# caddy-proxy
Ansible based container with caddy, docker-gen and forego

- https://caddyserver.com/
- https://github.com/jwilder/docker-gen
- https://github.com/jwilder/forego/


## Usage

Start caddy-proxy

```
docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro caddy-proxy
```

Start app container

```
docker run -e VIRTUAL_HOST=plone.io -p 8080:8080 plone
```

In the example above we have a working DNS entry for ``plone.io``, we start now a plone container, using this entry.

After the container is up and running, open your browser and go to http://plone.io:8080

## ToDo

- cleanup image
- add tini to image
- add own user to image
- adjust default port and proxy settings, currently this is port 80 which is not cool
