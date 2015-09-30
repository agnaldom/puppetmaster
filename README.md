# Puppet

## O que é puppet?

É uma ferramenta livre que usa uma linguagem declarativa para configurar sistemas operacionais. Sistemas como Linux, *BSDs, Solaris, Windows e outros são suportados. A ideia é que se tenha a configuração centralizada em um único ponto, e essa configuração seja distribuída para diversos nós de uma rede.

Puppet pode realizar diversas tarefas, podemos destacar como resultado do seu uso:

* Gerência de configuração.
* Automação na instalação de pacotes.
* Estabelece e garante normas e facilidade de auditoria.

Gerência de configuração.
Automação na instalação de pacotes.
Estabelece e garante normas e facilidade de auditoria.

## Cenário

2 máquinas virtuais debian 8 rodando com docker
* puppetmaster 10.15.10.81
* puppetagent  10.15.10.82

### api rest

Tanto o puppet agent quanto o puppet master possuem uma API REST que é usada para a comunicação entre eles.

Exemplos de estrutura básica das URLS para acessar estas API's:

https://yourpuppetmaster:8140/{environment}/{resource}/{key}
https://yourpuppetclient:8139/{environment}/{resource}/{key}

Mais informações:

http://docs.puppetlabs.com/guides/rest_api.html

### rede
Tanto o puppet agent quanto o puppet master possuem uma API REST que é usada para a comunicação entre eles.

### certificados

Como eu já informei, toda a comunicação entre agente é master é segura, para isto utilizamos SSL.

No ato da instalação do puppetmaster é gerado um certificado do master.

No ato da instalação de um puppet agent é gerado um certificado para este agente.

Para um agente se comunicar com o servidor ele precisa ser previamente autorizado no master, sem esse procedimento de autorização, um agente simplesmente não terá condições de se comunicar com o master para obter suas configurações.

### fucionamento
A aplicação das configurações no modo cliente/servidor segue os seguinte passos:

* Agente requisita ao Master o catálogo para máquina em que está instalado
** Agente envia junto com a solicitação os dados e o estado atual da máquina
* Master Classifica as informações recebidas  
** Master verifica quem é o sistema/máquina e o que ele precisa ter instalado/configurado
* Master avalia as configurações declaradas para aquela máquina
* Master compila as informações e devolve para o agente
* Agente recebe os dados compilados e produz um catálogo com as configurações que devem ser aplicadas
* Agente inicia a aplicação do catálogo no sistema
** Agente verifica estado atual do sistema (query)
** Agente aplica configurações do catálogo - se houver (enforce)
** Agente comunica seu estado ao nó master após aplicação do catálogo
*** Sistema reflete as configurações que foram declaradas para ele

##Configurando

### hostname e dominio

É muito importante que nas duas vms você esteja com o hostname devidamente configurado, ao se logar faça o seguinte:

### puppetmaster
vamos também configurar o arquivo hostname

echo puppetmaster > /etc/puppet/hostname

e não se esqueça do mais importante, arquivo /etc/hosts

echo 10.15.10.81 puppetmaster puppetmaster puppet >> /etc/hosts

### puppetagent
vamos também configurar o arquivo hostname

echo puppetagent > /etc/hostname

e não se esqueça do mais importante, arquivo /etc/hosts

echo 10.15.10.81 puppetagent puppetagent agent >> /etc/hosts


## puppetmaster
### instalando o masterinstalando o master

 aptitude install puppetmaster


### verificando portas

verifique se a porta 8140 está aberta

$ netstat -ntpl|grep 8140

### verificando serviço

outra forma de verificar se o puppet está rodando via passenger é acessar o endereço

https://ip_do_servidor:8140/

se receber o retorno abaixo, seu puppetmaster está funcionando.

The environment must be purely alphanumeric, not ''

## acessando puppetmaster

o puppemaster também possuia um agente puppet rodando, este agente vai procurar sempre o puppetmaster através do nome puppet ou puppet.dominio em sua rede, portando vamos fazer alguns pequenos ajustes.

### via dns

se possível crie um registro de DNS tipo A com o nome puppet apontando para máquina puppetmaster , se não for possível registro do tipo A, faça um registro do tipo CNAME, e no resolv.conf você precisa apontar para esse servidor de DNS e colocar search nomedodominio para que funcione adequadmente.

### via hosts

caso a configuração de DNS não seja uma opção, uma forma de resolver é inserir uma entrada no /etc/hosts

10.15.10.81 puppetmaster.dominio puppet

isso será suficiente para o agente funcionar

### via puppet.conf

se ainda não for uma opção, pode ainda editar o arquivo /etc/puppet.conf e inserir a diretiva

server=nomedoservidor

na seção [agente], mas prefira sempre a configuração de DNS.


## testando master

ao instalar o puppetmaster, o puppet-agent também é instalado, através dele podemos verificar se está tudo funcionando adequadamente no master.

$ puppet agent --test

saída


info: Caching catalog for puppetmaster.localdomain
info: Applying configuration version '1347301751'
info: Creating state file /var/lib/puppet/state/state.yaml
notice: Finished catalog run in 0.02 seconds

se você tiver um retorno como este, está tudo funcionando bacana.

## estrutura master

O puppetmaster uma vez instalado vai criar alguns arquivos e diretórios no /etc, precisamos entender cada um para prosseguir.

### arquivos e diretórios master

Ao instalar você verá o seguinte conteúdo no diretório /etc/puppet

puppetmater:/etc/puppet# ls -lah
total 40K
drwxr-xr-x  5 root root 4.0K May 15 16:27 .
drwxr-xr-x 70 root root 4.0K May 15 16:25 ..
-rw-r--r--  1 root root 2.5K Apr 10 15:23 auth.conf
-rw-r--r--  1 root root  459 Apr 11 00:19 fileserver.conf
drwxr-xr-x  2 root root 4.0K Apr  5 13:01 manifests
drwxr-xr-x  2 root root 4.0K Apr  5 13:01 modules
-rw-r--r--  1 root root  462 Apr 11 00:19 puppet.conf
drwxr-xr-x  2 root root 4.0K Apr  5 13:01 templates



### arquivo auth.conf

O arquivo auth.conf define acls que determinam quais recursos os agentes podem consultar no servidor puppet


### arquivo fileserver.conf

O arquivo fileserver.conf define quais redes podem acessar arquivos presentes no servidor puppet, você precisa declarar de forma explítica, veja o exemplo abaixo, mais a frente vamos mexer neste arquivo.

### arquivo puppet.conf

O arquivo puppet.conf contém tanto configurações do agent quanto do master.

### diretório manifests

No diretório manifests nós iremos declarar as configurações chamadas de manifests e os nodes que vão utilizá-las.

### # Puppet

## O que é puppet?

É uma ferramenta livre que usa uma linguagem declarativa para configurar sistemas operacionais. Sistemas como Linux, *BSDs, Solaris, Windows e outros são suportados. A ideia é que se tenha a configuração centralizada em um único ponto, e essa configuração seja distribuída para diversos nós de uma rede.

Puppet pode realizar diversas tarefas, podemos destacar como resultado do seu uso:

* Gerência de configuração.
* Automação na instalação de pacotes.
* Estabelece e garante normas e facilidade de auditoria.

Gerência de configuração.
Automação na instalação de pacotes.
Estabelece e garante normas e facilidade de auditoria.

## Cenário

2 máquinas virtuais debian 8 rodando com docker
* puppetmaster 10.15.10.81
* puppetagent  10.15.10.82

### api rest

Tanto o puppet agent quanto o puppet master possuem uma API REST que é usada para a comunicação entre eles.

Exemplos de estrutura básica das URLS para acessar estas API's:

https://yourpuppetmaster:8140/{environment}/{resource}/{key}
https://yourpuppetclient:8139/{environment}/{resource}/{key}

Mais informações:

http://docs.puppetlabs.com/guides/rest_api.html

### rede
Tanto o puppet agent quanto o puppet master possuem uma API REST que é usada para a comunicação entre eles.

### certificados

Como eu já informei, toda a comunicação entre agente é master é segura, para isto utilizamos SSL.

No ato da instalação do puppetmaster é gerado um certificado do master.

No ato da instalação de um puppet agent é gerado um certificado para este agente.

Para um agente se comunicar com o servidor ele precisa ser previamente autorizado no master, sem esse procedimento de autorização, um agente simplesmente não terá condições de se comunicar com o master para obter suas configurações.

### fucionamento
A aplicação das configurações no modo cliente/servidor segue os seguinte passos:

* Agente requisita ao Master o catálogo para máquina em que está instalado
** Agente envia junto com a solicitação os dados e o estado atual da máquina
* Master Classifica as informações recebidas  
** Master verifica quem é o sistema/máquina e o que ele precisa ter instalado/configurado
* Master avalia as configurações declaradas para aquela máquina
* Master compila as informações e devolve para o agente
* Agente recebe os dados compilados e produz um catálogo com as configurações que devem ser aplicadas
* Agente inicia a aplicação do catálogo no sistema
** Agente verifica estado atual do sistema (query)
** Agente aplica configurações do catálogo - se houver (enforce)
** Agente comunica seu estado ao nó master após aplicação do catálogo
*** Sistema reflete as configurações que foram declaradas para ele

##Configurando

### hostname e dominio

É muito importante que nas duas vms você esteja com o hostname devidamente configurado, ao se logar faça o seguinte:

### puppetmaster
vamos também configurar o arquivo hostname

echo puppetmaster > /etc/puppet/hostname

e não se esqueça do mais importante, arquivo /etc/hosts

echo 10.15.10.81 puppetmaster puppetmaster puppet >> /etc/hosts

### puppetagent
vamos também configurar o arquivo hostname

echo puppetagent > /etc/hostname

e não se esqueça do mais importante, arquivo /etc/hosts

echo 10.15.10.81 puppetagent puppetagent agent >> /etc/hosts


## puppetmaster
### instalando o masterinstalando o master

 aptitude install puppetmaster


### verificando portas

verifique se a porta 8140 está aberta

$ netstat -ntpl|grep 8140

### verificando serviço

outra forma de verificar se o puppet está rodando via passenger é acessar o endereço

https://ip_do_servidor:8140/

se receber o retorno abaixo, seu puppetmaster está funcionando.

The environment must be purely alphanumeric, not ''

## acessando puppetmaster

o puppemaster também possuia um agente puppet rodando, este agente vai procurar sempre o puppetmaster através do nome puppet ou puppet.dominio em sua rede, portando vamos fazer alguns pequenos ajustes.

### via dns

se possível crie um registro de DNS tipo A com o nome puppet apontando para máquina puppetmaster , se não for possível registro do tipo A, faça um registro do tipo CNAME, e no resolv.conf você precisa apontar para esse servidor de DNS e colocar search nomedodominio para que funcione adequadmente.

### via hosts

caso a configuração de DNS não seja uma opção, uma forma de resolver é inserir uma entrada no /etc/hosts

10.15.10.81 puppetmaster.dominio puppet

isso será suficiente para o agente funcionar

### via puppet.conf

se ainda não for uma opção, pode ainda editar o arquivo /etc/puppet.conf e inserir a diretiva

server=nomedoservidor

na seção [agente], mas prefira sempre a configuração de DNS.


## testando master

ao instalar o puppetmaster, o puppet-agent também é instalado, através dele podemos verificar se está tudo funcionando adequadamente no master.

$ puppet agent --test

saída


info: Caching catalog for puppetmaster.localdomain
info: Applying configuration version '1347301751'
info: Creating state file /var/lib/puppet/state/state.yaml
notice: Finished catalog run in 0.02 seconds

se você tiver um retorno como este, está tudo funcionando bacana.

## estrutura master

O puppetmaster uma vez instalado vai criar alguns arquivos e diretórios no /etc, precisamos entender cada um para prosseguir.

### arquivos e diretórios master

Ao instalar você verá o seguinte conteúdo no diretório /etc/puppet

puppetmater:/etc/puppet# ls -lah
total 40K
> drwxr-xr-x  5 root root 4.0K May 15 16:27 .
> drwxr-xr-x 70 root root 4.0K May 15 16:25 ..
-rw-r--r--  1 root root 2.5K Apr 10 15:23 auth.conf
-rw-r--r--  1 root root  459 Apr 11 00:19 fileserver.conf
drwxr-xr-x  2 root root 4.0K Apr  5 13:01 manifests
drwxr-xr-x  2 root root 4.0K Apr  5 13:01 modules
-rw-r--r--  1 root root  462 Apr 11 00:19 puppet.conf
drwxr-xr-x  2 root root 4.0K Apr  5 13:01 templates</code>


### arquivo auth.conf

O arquivo auth.conf define acls que determinam quais recursos os agentes podem consultar no servidor puppet


### arquivo fileserver.conf

O arquivo fileserver.conf define quais redes podem acessar arquivos presentes no servidor puppet, você precisa declarar de forma explítica, veja o exemplo abaixo, mais a frente vamos mexer neste arquivo.

### arquivo puppet.conf

O arquivo puppet.conf contém tanto configurações do agent quanto do master.

### diretório manifests

No diretório manifests nós iremos declarar as configurações chamadas de manifests e os nodes que vão utilizá-las.

### diretório modules

No diretório módulos ficam os módulos do puppet, veremos mais sobre módulos a frente.

### diretório templates

O diretório templates tem os arquivos de configuração dinâmicos. Estes arquivos tem a extensão .erb, eles contém variáveis e estruturas de repetição, através deles podemos construir arquivos com dados específicos do node.

### outros


Dependendo de como for usar o Puppet, muitos outros arquivos e diretórios serão criados nessa estrutura, vai depender de cada cenário e implementação.

## puppetagent

### instalando agent

$ aptitude install puppet

### habilitando o puppet

Para habilitar o puppet, edite o arquivo

root@puppetagent:~# vim /etc/default/puppet

E mude o valor da variável START para YES.

START=yes

Reinicie o puppet agent

root@puppetagent:~# /etc/init.d/puppet restart



## acessando puppetmaster

o agente vai procurar sempre o puppetmaster através do nome puppet ou puppet.dominio

### via dns

se possível crie um registro de DNS tipo A com o nome puppet apontando para máquina puppetmaster , se não for possível registro do tipo A, faça um registro do tipo CNAME.

### via hosts

caso a configuração de DNS não seja uma opção, uma forma de resolver é inserir uma entrada no /etc/hosts

10.15.10.81 puppetmaster puppetmaster.dominio
isso será suficiente para o agente funcionar, coloque o ip do seu puppetmaster

### via puppet.conf

se ainda não for uma opção, pode ainda editar o arquivo /etc/puppet.conf e inserir a diretiva

server=puppetmaster
na seção [agent], mas prefira a configuração de DNS dentre as 3 opções.

## estrutura agent

Quando instalamos o agente, ele nos traz o seguintes arquivos e diretórios dentro de /etc/puppet.

<p>
drwxr-xr-x 2 root root 4096 Aug 27 19:11 manifests
drwxr-xr-x 2 root root 4096 Aug 27 19:11 modules
-rw-r--r-- 1 root root  364 Aug 27 17:35 puppet.conf
drwxr-xr-x 2 root root 4096 Aug 27 19:11 templates
</p>

Basicamente tem as mesmas funções descritas na estrutura do master, porém não são utilizadas no modo cliente/servidor uma vez que os agentes buscam as configurações no puppetmaster.

## primeiro contato

aqui vamos apresentar o primeiro contato entre o puppetmaster e o puppetagent, no agente rode o comando abaixo:aqui vamos apresentar o primeiro contato entre o puppetmaster e o puppetagent, no agente rode o comando abaixo:

root@puppetagent:~# puppet agent --test
a saída será similar a esta.

info: Creating a new SSL key for puppetagent.hacklab
info: Caching certificate for ca
info: Creating a new SSL certificate request for puppetagent.hacklab
info: Certificate Request fingerprint (md5): D6:17:3E:B6:D9:43:DB:08:F7:F1:53:38:3B:A9:21:49
Exiting; no certificate found and waitforcert is disabled
observe que ao rodar o agent ele gerou um certificado digital e depois gerou uma requisição de assinatura do certificado e parou por ali pois ainda não está devidamente autorizado a utilizar recursos do puppetmaster.

é importante ressaltar que ele só gerou essa saída pois encontrou o servidor puppet graças ao ajuste no /etc/hosts, portanto fique atento as configurações de DNS ou do HOSTS.
