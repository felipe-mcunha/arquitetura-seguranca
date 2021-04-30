# Implementação dos mecanismos de autenticação e autorização na Plataforma Helix Sandbox-NG

  A arquitetura apresentada realiza a implementação das soluções de segurança FIWARE sem a necessidade de alterações na estrutura da plataforma Helix e no Orion Context Broker, onde o usuário passa a ter acesso a plataforma Helix para visualização do funcionamento do Context Broker, porém quando for realizar a criação de entidades no Context broker é necessário se autenticar no ambiente. 
  Anteriormente o dispositivo IoT quando se comunicava com a plataforma para realizar alterações, ocorria uma comunicação direta com o Context Broker sem a necessidade de autenticação, após a implementação, o dispositivo passa a se autenticar para realizar a leitura de informações já existentes no banco de dados, escrever informações do banco de dados, ou alterar informações já existente.
  Para a elaboração da arquitetura foram utilizados três soluções FIWARE, que são: Pep-proxy, AuthzForce, e Wilma Pep-Proxy, cada um responsável por uma etapa de autorização e autenticação no sistema. O Keyrock consiste em um gerenciador de identidades, onde as identidades que serão registrados no Helix deverão ser criados para receber autorização no ambiente, juntamente com a conta dos administradores que irão realizar alterações no ambiente. O Authzforce é um PDP (Policy decision point) que irá tomar as decisões baseadas em políticas de permissões previamente criadas. E por último o Wilma Pep-Proxy que é um PEP (Policy enforcement point) que terá como função interceptar o trafego e consultar o Authzforce e o Keyrcok para identificar se o dispositvo que está tentando se comunicar com o context broker possui autorização para realizar a conexão, e permissão para realizar ações na plataforma Helix.
  
  
Passo a passo:

1 O primeiro passo para instalação da arquitetura é realizar o download dos arquivos contidos no GitHub
(link)
 Para obter os arquivos digite o comando: 
 git clone https://github.com/felipe-mcunha/arquitetura-seguranca.git
 cd arquitetura-seguranca
 
 2 Precisamos realizar o download dos arquivos de segurança, caso tenha o helix instalado utilizaremos o arquivo requirements.sh, caso seja necessário a instalação do helix será necessário utilizar o arquivo requirements_sem_helix.sh
sudo chmod 777 requirements.sh ou requirements_sem_helix.sh
./requirementes.sh ou requirements_sem_helix.sh
Iniciado instalação dos requisistos, Aguarde..
__________________________________________________________________________
3 Caso já possua o helix instalado pule para a etapa 4
Para quem ainda não possui siga o passo a passo do git hub do helix para ativar o context brocker
(link helix)

4 Nessa etapa iremos subir a primeira ferramenta de segurança, o Authzforce:
cd authzforce
docker-compose up
aguardar o processo do container ser ativado e retorne para a pasta arquitetura de segurança
cd..

5 Nessa etapa será configurado a segunda ferramenta de segurança, o Keyrock:
cd keyrock
Para subir o keyrock é necessário realizar a configuração com o Authzforce
nano docker-compose.yml
Na linha 31 contêm a variavel IDM_AUTHZFORCE_HOST={IP HOST}
Substitua o {IP HOST} para o ip em que o Authzforce está ativado
Salve o arquivo apertando ctrl+O > ENTER > ctrl X
Ative o container do keyrock:
docker-compose up
aguardar o processo do container ser ativado e retorne para a pasta arquitetura de segurança
cd..

6 Agora precisamos realizar a criação de uma entidade no keyrock, pois para realizar a configuração do Wilma será necessário pegar alguns tokens de acesso gerados no keyrock.
O primeiro passo é logar no keyrock
IP:3000
usuário admin@test.com
senha 1234
Siga as imagens abaixo para criar as identidades.
(Prints)

7 Agora iremos realizar a ativação e configuração do Wilma.
cd wilma
O primeiro passo é realizar a configuração do container:
docker build -t pep-proxy-image . (Obs não remova o ponto e o espaço) 
Agora precisamos realizar configurações no arquivo config.js:
nano config.js
Na linha 15 informe o IP da máquina que o keyrock está ativo.
Na linha 21 informe o IP que o context brocker está ativo.
Na linha 33, 34 e 35 será informado as credenciais gerados no keyrock, siga as imagens abaixo para obter as credenciais no keyrock.
(prints)
Por fim, na linha 58 informe o endereço IP que o Authzforce está ativado
Salve o arquivo apertando ctrl+O > ENTER > ctrl X
E por último iremos ativar o container do Wilma Pep Proxy
Obs: obtenha o caminho abslouto do arquivo de configuração com comando pwd
sudo docker run -d --name pep-proxy-container -v {CAMINHO ABSOLUTO}/arquitetura-seguranca/wilma/config.js:/opt/fiware-pep-proxy/config.js -p 1027:1027 pep-proxy-image
Aguarde o processo finalizar, e após isso as 4 ferramentas estarão conectadas, para validar a conexão siga o passo a passo a seguir.
___________________________________---
8 Para validar a conexão siga o passo a passo a seguir:
Primeiro iremos criar uma entidade no helix
Insira o CURL abaixo alterando para o Ip da máquina

curl --location --request POST 'http://{IP MAQUINA}:1026/v2/entities' \
--header 'Content-Type: application/json' \
--header 'fiware-service: helixiot' \
--header 'fiware-servicepath: /' \
--data-raw '{
  "id": "urn:ngsi-ld:entity:001",
  "type": "iot",
  "temperature": {
  "type": "float",
  "value": 0
    }
,
  "humidity": {
  "type": "float",
  "value": 0
	}
}
'

Agora iremos obter o token de acesso do Keyrock, siga o passo a passo para obter o APP ID e o SECRET ID
(PRINT)
Com esses tokens em mãos iremos gerar um base64 para solictar o acess token ao keyrock
echo -n {APP_ID}:{SECRET} | base64
Copie a resposta e informe no comando a seguir na opção base64 e altere para o IP da máquina que o Keyrock está instalado.
curl -iX POST \
  'http://{IP_MAQUINA}:3000/oauth2/token' \
  -H 'Accept: application/json' \
  -H 'Authorization: Basic {BASE64}' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  --data "username=admin@test.com&password=1234&grant_type=password"
  
  Agora iremos verificar se as ferramentas estão conectadas, a partir do comando a seguir, a resposta que ele deve nos retornar é que domínio não existe, ou seja não tem permissão no ambiente, informe o access token obtido no comando anterior:
  
  curl --location --request GET 'http://{IP_MAQUINA}:1027/v2/entities' \
--header 'Accept: application/json' \
--header 'fiware-service: helixiot' \
--header 'fiware-servicepath: /' \
--header 'X-Auth-Token: {ACCESS TOKEN}'

Como teste para verificação se o Authzforce está recebendo regras no keyrock, siga o passo a passo a seguir
