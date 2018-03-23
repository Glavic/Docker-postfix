# Docker postfix + opendkim

## Generate private key with opendkim-genkey

```bash
docker run \
    --rm \
    -v $(pwd):/x \
    glavich/docker-postfix:latest \
    opendkim-genkey \
        -b 1024 \
        -d example.com \
        -D /x \
        -h sha256 \
        -r \
        -s selector \
        -v
```

*More on `opendkim-genkey` options can be read here: http://www.opendkim.org/opendkim-genkey.8.html*

## Create contariner

```bash
docker run \
    -d \
    glavich/docker-postfix:latest
```
