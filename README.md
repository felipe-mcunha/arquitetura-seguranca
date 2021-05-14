
<h1>Implementação dos mecanismos de autenticação e autorização na Plataforma Helix Sandbox-NG </h1>
<p>English version: <a href="https://github.com/m-mendes/security-architecture">Implementation of authentication and authorization mechanisms on Helix Sandbox-NG Platform</a></p>
<h3>Colaboradores do projeto:</h3>
<p>Esse trabalho foi desenvolvido pelos alunos da <a  href="https://www.fatecsaocaetano.edu.br/" target="_blank"> Fatec São Caetano do Sul</a>, como projeto de graduação orientados pelo <a  href="http://lattes.cnpq.br/3044213933175294" target="_blank">Professor Me. Fábio Henrique Cabrini</a>.</p>
<ul>
  <li><a  href="https://www.linkedin.com/in/felipe-cunha-7aa33935/" target="_blank">Felipe Matheus da Cunha</a></li>
  <li><a  href="https://www.linkedin.com/in/jo%C3%A3o-vitor-ara%C3%BAjo-bonfim-7406b619b/" target="_blank">João Vitor de Araujo Bonfim</a></li>
  <li><a  href="https://www.linkedin.com/in/matheus-pereira-mendes-900269192/" target="_blank">Matheus Pereira Mendes</a></li>
  <li><a  href="https://www.linkedin.com/in/fabio-cabrini/" target="_blank">Fábio Henrique Cabrini</a></li>
</ul>  

<h3>Descrição do projeto:</h3>
<p class="paragrafo1">A arquitetura apresentada realiza a implementação das soluções de segurança FIWARE sem a necessidade de alterações na estrutura da plataforma Helix e no Orion Context Broker, onde o usuário passa a ter acesso a plataforma Helix para visualização do funcionamento do Context Broker, porém quando for realizar a criação de entidades no Context broker é necessário se autenticar no ambiente.</p>
  <p class="paragrafo2">Anteriormente o dispositivo IoT quando se comunicava com a plataforma para realizar alterações, ocorria uma comunicação direta com o Context Broker sem a necessidade de autenticação, após a implementação, o dispositivo passa a se autenticar para realizar a leitura de informações já existentes no banco de dados, escrever informações do banco de dados, ou alterar informações já existente.</p>
  <p class="paragrafo3">Para a elaboração da arquitetura foram utilizados três soluções FIWARE, que são: Pep-proxy, AuthzForce, e Wilma Pep-Proxy, cada um responsável por uma etapa de autorização e autenticação no sistema. O Keyrock consiste em um gerenciador de identidades, onde as identidades que serão registrados no Helix deverão ser criados para receber autorização no ambiente, juntamente com a conta dos administradores que irão realizar alterações no ambiente. O Authzforce é um PDP (Policy decision point) que irá tomar as decisões baseadas em políticas de permissões previamente criadas. E por último o Wilma Pep-Proxy que é um PEP (Policy enforcement point) que terá como função interceptar o trafego e consultar o Authzforce e o Keyrcok para identificar se o dispositvo que está tentando se comunicar com o context broker possui autorização para realizar a conexão, e permissão para realizar ações na plataforma Helix.</p>
  <img src="https://user-images.githubusercontent.com/70486745/117086554-3768ae80-ad23-11eb-8cb2-30b9584b6bd9.jpg">

  <h3>Passo a passo:</h3>

<p><h4>1° Passo - O primeiro passo para instalação da arquitetura é realizar o download dos arquivos contidos no GitHub</h4>

 Para obter os arquivos digite o comando: 
 <ul>
  <li>git clone https://github.com/felipe-mcunha/arquitetura-seguranca.git</li>
  <li>cd arquitetura-seguranca</li>
</ul>
 </p> 
 


<p><h4>2° Passo - Precisamos realizar o download dos arquivos de segurança, caso tenha o helix instalado utilizaremos o arquivo requirements.sh, caso seja necessário a instalação do helix será necessário utilizar o arquivo requirements_sem_helix.sh</h4>

 Para obter os arquivos digite o comando: 
 <ul>
  <li>sudo chmod 777 requirements.sh ou requirements_sem_helix.sh</li>
  <li>./requirements.sh ou requirements_sem_helix.sh</li>
  <li>Iniciado instalação dos requisistos, Aguarde..</li>  
</ul>
 </p> 

<p><h4>3° Passo - Caso já possua o helix instalado e tenha ativado o Context Broker pule para a etapa 4</h4>
  <h4>Para quem ainda não possui, siga o passo a passo do GitHub do helix para ativar o Context Broker
<a href="https://github.com/Helix-Platform/Sandbox-NG/blob/master/docs/create_cef_context_broker.md">Creating a CEF Context Broker</a></h4>
<h4>Para validar a conexão siga o passo a passo a seguir:</h4>
<p> Copie o arquivo criando_entidade_no_helix para o bloco de notas e altere o IP
<h3>Link do youtube para realização da primeira etapa </h3>
https://www.youtube.com/watch?v=CEI9_HaFaBQ
</p>

<p><h4>4° Passo - Nessa etapa iremos subir a primeira ferramenta de segurança, o Authzforce, Siga os comandos abaixo:</h4>
<ul>
  <li>cd authzforce</li>
  <li>docker-compose up</li>
  <li>Aguarde o processo do container ser ativado</li>
  <li> Digite CTRL + Z e em seguida bg para jogar a aplicação em 2°plano</li>
  <li>Retorne para a pasta arquitetura de segurança utilizando o comando cd..</li>
</ul>

</p>

<p>
  <h4>5° Passo - Nessa etapa será configurado a segunda ferramenta de segurança, o Keyrock, Siga os comandos abaixo:</h4>
<ul>
  <li>cd keyrock</li>
  <li>nano docker-compose.yml - Será necessário configurar informações do AuthzForce</li>
  <li>Na linha 31 contêm a variavel <strong>IDM_AUTHZFORCE_HOST={IP HOST}</strong> </li>
  <li>Substitua o <strong>{IP HOST}</strong> para o ip em que o Authzforce estará configurado igual na  imagem a seguir:</li>
  <img src="https://user-images.githubusercontent.com/70486745/117071816-fada8a00-ad05-11eb-8e05-f205df9394ff.PNG">
  
  <li>Salve o arquivo apertando ctrl+O > ENTER > ctrl X</li>
  <li>docker-compose up para ativar o container do Keyrock</li>
  <li>Aguarde o processo do container ser ativado</li>
  <li>Após a instalação abra um novo terminal do putty, entre como root e acesse a pasta arquitetura-seguranca</li>
</ul>
</p>

<p>
  <h4>6° Passo - Agora precisamos realizar a criação de uma entidade no keyrock, pois para realizar a configuração do Wilma será necessário pegar alguns tokens de acesso gerados no keyrock. Siga os passos abaixo:</h4>
  <ul>
    <li>O primeiro passo é logar no keyrock utlizando o navegador, digitando o IP da máquina :3000</li>
    <li>Logue com o usuário: admin@test.com e senha: 1234</li>
    <li>Siga as imagens abaixo para obter os tokens necessários</li>
 
  </ul>
  <img src="https://user-images.githubusercontent.com/70486745/117065150-7b48bd00-acfd-11eb-98b0-2922dfc977c3.PNG">
  <img src="https://user-images.githubusercontent.com/70486745/117065658-25c0e000-acfe-11eb-8c8a-33664598c399.PNG">
  <img src="https://user-images.githubusercontent.com/70486745/117066516-332a9a00-acff-11eb-9a7f-cdb483ec5c02.PNG">
  <img src="https://user-images.githubusercontent.com/70486745/117067012-daa7cc80-acff-11eb-900f-ba50eb7486e5.jpg">
  <img src="https://user-images.githubusercontent.com/70486745/117067620-a2ed5480-ad00-11eb-9a95-80e19c928550.PNG">
  <img src="https://user-images.githubusercontent.com/70486745/117068088-345cc680-ad01-11eb-995b-5690c9a5fd52.PNG">
  <h4>Salve os tokens no bloco de notas, pois serão utilizados no passo 7</h4>
 

</p>


<p><h4>7° Passo - Agora iremos realizar a ativação e configuração do Wilma, Siga o passo a passo a seguir:</h4></p>
<ul>
  <li>cd wilma</li>
  <li>Digite o comando para fazer a criação da imagem: docker build -t pep-proxy-image . (Obs não remova o ponto e o espaço) </li>
  <li>Em seguida digite o comando nano config.js</li>
  <li>Na linha 15 informe o IP da máquina que o keyrock está ativo.</li>
  <li>Na linha 21 informe o IP que o context broker está ativo.</li>
  <li>Na linha 33, 34 e 35 será informado as credenciais gerados no keyrock no passo anterior.</li>
  <img src="https://user-images.githubusercontent.com/70486745/117068954-45f29e00-ad02-11eb-905c-2a207dfb9689.PNG">
  <li>Na linha 58 informe o IP que o Authzforce está ativo.</li>
  <li>Salve o arquivo apertando CTRL+O > ENTER > CTRL X</li>
  <li>Obs: Obtenha o caminho absoluto com o comando PWD e cole no comando abaixo no campo <strong>{CAMINHO ABOSULTO}</strong></li>
  <li>sudo docker run -d --name pep-proxy-container -v <strong>{CAMINHO ABOSULTO}</strong>/arquitetura-seguranca/wilma/config.js:/opt/fiware-pep-proxy/config.js -p 1027:1027 pep-proxy-image</li>
  <li>Aguarde o processo finalizar, e após isso as 4 ferramentas estarão conectadas.</li>
</ul>
<h3>Link do youtube para realização da segunda etapa</h3>
https://www.youtube.com/watch?v=aTkyHVxOqCo&feature=youtu.be


<p>
  

</p>


<p>8° Passo - Agora iremos obter o token de acesso do Keyrock, siga as imagens a seguir para obter o APP ID e o SECRET ID: <h4></h4></p>
<img src="https://user-images.githubusercontent.com/70486745/117069768-47709600-ad03-11eb-85c3-f8a522b7e6da.PNG">
<img src="https://user-images.githubusercontent.com/70486745/117070473-28263880-ad04-11eb-9804-3eeff16f4fd3.PNG">
Com esses tokens em mãos iremos gerar um base64 para solictar o acess token ao keyrock. utilize o echo abaixo alterando o APP ID e o SECRET que foi obtido<br><br>

<h4><strong>Obs: Utilize o arquivo validacao contido no repositorio para fazer os testes</strong></h4>

echo -n <strong>{APP_ID}</strong>:<strong>{SECRET}</strong> | base64><br>

Copie a resposta e informe no comando a seguir na opção base64 e altere para o IP da máquina que o Keyrock está instalado.<br><br>
curl -iX POST \ <br>
'http://<strong>{IP_MAQUINA}</strong>:3000/oauth2/token' \ <br>
-H 'Accept: application/json' \ <br>
-H 'Authorization: Basic <strong>{BASE64}</strong>' \ <br>
-H 'Content-Type: application/x-www-form-urlencoded' \ <br>
--data "username=admin@test.com&password=1234&grant_type=password" <br>
<br><br>


  Agora iremos verificar se as ferramentas estão conectadas, a partir do comando a seguir, a resposta que ele deve nos retornar é que domínio não existe, ou seja não tem permissão no ambiente, informe o access token obtido no comando anterior:<br><br>
<h4><strong>Obs: Utilize o arquivo validacao contido no repositorio para fazer os testes</strong></h4>
  

curl --location --request GET 'http://<strong>{IP_MAQUINA}</strong>:1027/v2/entities' \ <br>
--header 'Accept: application/json' \ <br>
--header 'fiware-service: helixiot' \ <br>
--header 'fiware-servicepath: /' \ <br>
--header 'X-Auth-Token: <strong>{ACCESS TOKEN}</strong>'<br>
<br>
<h4>Como teste para verificação se o Authzforce está recebendo regras no keyrock, siga o passo a passo a seguir para criar a regra no Keyrock e o mesmo repassar o Authzforce</h4>
<img src="https://user-images.githubusercontent.com/70486745/117084099-a7c00180-ad1c-11eb-824a-56e15fd210d3.png">
<img src="https://user-images.githubusercontent.com/70486745/117084359-63813100-ad1d-11eb-9d3f-b32430dadd13.png">
<img src="https://user-images.githubusercontent.com/70486745/117084609-02a62880-ad1e-11eb-9077-392ac54f737e.PNG">
<img src="https://user-images.githubusercontent.com/70486745/117084763-721c1800-ad1e-11eb-9d61-c64644a5873f.PNG">
<p>Nessa etapa iremos criar a regra no Keyrock para que seja transmitida ao Authzforce, Informe o nome da regra, uma descrição e o código XACML utilizado no exemplo que está disponível no arquivo regra_de_acesso.xacml</p>
<h5>Obs: Será necessário editar o Client ID do arquivo XACML na linha 25</h5>
<img src="https://user-images.githubusercontent.com/70486745/117085697-d8099f00-ad20-11eb-979c-3f70e051ccff.PNG">
<img src="https://user-images.githubusercontent.com/70486745/117085858-56fed780-ad21-11eb-8aff-85a48410756c.png">
<img src="https://user-images.githubusercontent.com/70486745/117086043-dd1b1e00-ad21-11eb-8079-6b0bd7502a57.png">
<p>Após clicar em save, o Authzforce já vai receber e criar o domínio para a entidade.</p>
<h5>Validação da regra de leitura</h5>
<p>Envie novamente o comando utilizado no passo anterior para validação de conexão, o retorno esperado deverá ser as informações na entidade do helix</p>
curl --location --request GET 'http://<strong>{IP_MAQUINA}</strong>:1027/v2/entities' \ <br>
--header 'Accept: application/json' \ <br>
--header 'fiware-service: helixiot' \ <br>
--header 'fiware-servicepath: /' \ <br>
--header 'X-Auth-Token: <strong>{ACCESS TOKEN}</strong>'<br>
<br>
<h3>Link do youtube para realização da terceira etapa </h3>
https://www.youtube.com/watch?v=qBaY3kxcSf8

