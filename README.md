 <p>A arquitetura apresentada realiza a implementação das soluções de segurança FIWARE sem a necessidade de alterações na estrutura da plataforma Helix e no Orion Context Broker, onde o usuário passa a ter acesso a plataforma Helix para visualização do funcionamento do Context Broker, porém quando for realizar a criação de entidades no Context broker é necessário se autenticar no ambiente.<br>
  Anteriormente o dispositivo IoT quando se comunicava com a plataforma para realizar alterações, ocorria uma comunicação direta com o Context Broker sem a necessidade de autenticação, após a implementação, o dispositivo passa a se autenticar para realizar a leitura de informações já existentes no banco de dados, escrever informações do banco de dados, ou alterar informações já existente.<br>
  Para a elaboração da arquitetura foram utilizados três soluções FIWARE, que são: Pep-proxy, AuthzForce, e Wilma Pep-Proxy, cada um responsável por uma etapa de autorização e autenticação no sistema. O Keyrock consiste em um gerenciador de identidades, onde as identidades que serão registrados no Helix deverão ser criados para receber autorização no ambiente, juntamente com a conta dos administradores que irão realizar alterações no ambiente. O Authzforce é um PDP (Policy decision point) que irá tomar as decisões baseadas em políticas de permissões previamente criadas. E por último o Wilma Pep-Proxy que é um PEP (Policy enforcement point) que terá como função interceptar o trafego e consultar o Authzforce e o Keyrcok para identificar se o dispositvo que está tentando se comunicar com o context broker possui autorização para realizar a conexão, e permissão para realizar ações na plataforma Helix.
  </p>
  
  
  <h3>Passo a passo:</h3>

<p><h4>1° Passo - O primeiro passo para instalação da arquitetura é realizar o download dos arquivos contidos no GitHub</h4>

 Para obter os arquivos digite o comando: 
 <ul>
  <li>git clone https://github.com/felipe-mcunha/arquitetura-seguranca.git</li>
  <li>cd arquitetura-seguranca</li>
</ul>
 </p> 
 

 <p><h4>2° Passo - Precisamos realizar o download dos arquivos de segurança, caso tenha o helix instalado utilizaremos o arquivo requirements.sh, caso seja necessário a instalação do helix será necessário utilizar o arquivo requirements_sem_helix.sh </h4>
    Siga os comandos abaixo para instalar os recursos necessários:
  <ul>

    <li>sudo chmod 777 requirements.sh ou requirements_sem_helix.sh</li>
    <li>./requirementes.sh ou requirements_sem_helix.sh</li>
    <li>Iniciado instalação dos requisistos, Aguarde..</li>
    
  </ul>
</p>

<p><h4>3° Passo - Caso já possua o helix instalado e tenha ativado o Context Broker pule para a etapa 4</h4>
  <h4>Para quem ainda não possui siga o passo a passo do GitHub do helix para ativar o Context Broker
<a href="https://github.com/Helix-Platform/Sandbox-NG/blob/master/docs/create_cef_context_broker.md">Creating a CEF Context Broker</a></h4>
</p>

<p><h4>4° Passo - Nessa etapa iremos subir a primeira ferramenta de segurança, o Authzforce, Siga os comandos abaixo:</h4>
<ul>
  <li>cd authzforce</li>
  <li>docker-compose up</li>
  <li>Aguarde o processo do container ser ativado</li>
  <li>Retorne para a pasta arquitetura de segurança utilizando o comando cd..</li>
</ul>

</p>

<p>
  <h4>5 Nessa etapa será configurado a segunda ferramenta de segurança, o Keyrock, Siga os comandos abaixo:</h4>
<ul>
  <li>cd keyrock</li>
  <li>nano docker-compose.yml - Será necessário configurar informações do AuthzForce</li>
  <li>Na linha 31 contêm a variavel IDM_AUTHZFORCE_HOST={IP HOST} </li>
  <li>Substitua o {IP HOST} para o ip em que o Authzforce estará configurado</li>
  <li>Salve o arquivo apertando ctrl+O > ENTER > ctrl X</li>
  <li>docker-compose up para ativar o container do Keyrock</li>
  <li>Aguarde o processo do container ser ativado</li>
  <li>Retorne para a pasta arquitetura de segurança utilizando o comando cd..</li>
</ul>
</p>

<p>
  <h4>6 Agora precisamos realizar a criação de uma entidade no keyrock, pois para realizar a configuração do Wilma será necessário pegar alguns tokens de acesso gerados no keyrock. Siga os passos abaixo:</h4>
  <ul>
    <li>O primeiro passo é logar no keyrock utlizando o navegador, digitando o IP da máquina :3000</li>
    <li>Logue com o usuário: admin@test.com e senha: 1234</li>
    <li>Siga as imagens abaixo para obter o token</li>
    IMAGENS
    <li>Salve os 3 tokens no bloco de notas</li>
  </ul>
</p>


<p><h4>7 Agora iremos realizar a ativação e configuração do Wilma, Siga o passo a passo a seguir:</h4></p>
<ul>
  <li>cd wilma</li>
  <li>Digite o comando para fazer a criação da imagem: docker build -t pep-proxy-image . (Obs não remova o ponto e o espaço) </li>
  <li>Em seguida digite o comando nano config.js</li>
  <li>Na linha 15 informe o IP da máquina que o keyrock está ativo.</li>
  <li>Na linha 21 informe o IP que o context broker está ativo.</li>
  <li>Na linha 33, 34 e 35 será informado as credenciais gerados no keyrock, siga as imagens abaixo para obter as credenciais no keyrock.</li>
  IMAGEM
  <li>Salve o arquivo apertando ctrl+O > ENTER > ctrl X</li>
  <li>Obs: Obtenha o caminho abosluto com o comando PWD e cole no comando abaixo no campo {CAMINHO ABOSULTO}</li>
  <li>sudo docker run -d --name pep-proxy-container -v {CAMINHO ABSOLUTO}/arquitetura-seguranca/wilma/config.js:/opt/fiware-pep-proxy/config.js -p 1027:1027 pep-proxy-image</li>
</ul>


 
