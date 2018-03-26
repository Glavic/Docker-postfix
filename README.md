# Docker postfix + opendkim

## Create container without private key

If you don't have private key for opendkim signature, dont' worry, it will be auto-generated.

```sh
docker run \
	-d \
	-e DKIM_DOMAIN=example.com \
	-e DKIM_SELECTOR=mail \
	glavich/docker-postfix:latest
```

![s1](https://user-images.githubusercontent.com/2729571/37899420-c6ef5bce-30eb-11e8-8caa-551ca1a3af43.gif)

On container generation, DNS TXT setting will be dumped to logs. You can see it by typing: `docker logs CONTAINER_ID` (*for example `docker logs 5bcc4f4f186e` or `docker logs amazing_banach`*).

![s2](https://user-images.githubusercontent.com/2729571/37899471-e288bbaa-30eb-11e8-9005-c6014da04b13.gif)

## Create container with private key

If you already have your own private key for opendkim signature, just add it to container folder: `/etc/opendkim/keys/`. Be sure to name it `SELECTOR.private` (*if selector is `mail`, then name file `mail.private`*).

```sh
docker run \
	-d \
	-e DKIM_DOMAIN=example.com \
	-e DKIM_SELECTOR=mail \
	-v $(pwd)/mail.private:/etc/opendkim/keys/mail.private \
	glavich/docker-postfix:latest
```

### Generate private key with opendkim-genkey

With following command, private key (*`mail.private`*) and dns txt setting (*`mail.txt`*)file, will be generated in your current folder.

```sh
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
		-s mail \
		-v
```

![s3](https://user-images.githubusercontent.com/2729571/37899518-01ff82ac-30ec-11e8-845c-7318753f349d.gif)

*More on `opendkim-genkey` options can be read here: http://www.opendkim.org/opendkim-genkey.8.html*
