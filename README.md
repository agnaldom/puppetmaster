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
  
