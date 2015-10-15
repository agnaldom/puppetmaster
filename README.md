# PuppetMaster - docker imagem

## Versão utilizada
A versão utilizada é a última estável no Debian Jessie em Outubro de 2015 (3.7.2).

## Instruções de execução
```bash
docker run -d --name puppetmaster --hostname puppet.ufpa.br -v \
/srv/docker/puppetmaster/etc/:/opt/puppet/etc/ -v \
/srv/docker/puppetmaster/var/:/opt/puppet/var/ -v \
/srv/docker/puppetmaster/var/log/:/opt/puppet/var/log/ -p 8140:8140 \
ctic_cssi/puppetmaster
```

## Com docker compose

```yaml
puppetmaster:
    image: ctic_cssi/puppetmaster
    hostname: puppet.ufpa.br
    restart: always
    volumes:
        - /srv/docker/puppetmaster/etc/:/opt/puppet/etc/
        - /srv/docker/puppetmaster/var/:/opt/puppet/var/
        - /srv/docker/puppetmaster/var/log/:/opt/puppet/var/log/
    ports:
        - "8140:8140"
```

## Persistência
Esta imagem tem os diretórios `` /opt/puppet/etc/`` e ``/opt/puppet/var/``
configurados para persistirem mesmo que os contêineres sejam destruídos.

## Como acessar

Configure os agentes apontando para puppet.ufpa.br e os certificados serão
automaticamente gerados.

## Alterar configurações
Para alterar as configurações do serviço, altere os arquivos em:

```
/srv/docker/puppetmaster/etc/
```

## Onde colocar os manifestos

Coloque os manifestos em:

```
/srv/docker/puppetmaster/etc/manifests/
```
