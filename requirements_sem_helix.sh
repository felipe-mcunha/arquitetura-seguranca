echo "Welcome to Helix Sandbox with Security Architeture"

echo "Let's start upgrading Ubuntu"
sleep 6
apt update && apt upgrade -y 
echo "Ubuntu is updated"
sleep 6

echo "Installing Helix Sandbox NG"
git clone https://github.com/Helix-Platform/Sandbox-NG.git
cd Sandbox-NG
./install.sh

echo "Now we need Docker and Docker compose, so let's start"
apt install docker -y && apt install docker-compose -y 
echo "We have Docker :)"
sleep 6

echo "Installing node, wilma needs this"
sleep 6
curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash - 
apt-get install -y nodejs 
apt-get install gcc g++ make -y 
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - 
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list 
apt-get update && sudo apt-get install yarn -y 
echo "I can see that we have node, wilma is happy"
sleep 6

echo "The gran finale, MYSQL, keyrock need this guy, (They are best friends)"
sleep 6
apt install mysql-sandbox -y
echo "Well, we have everything, so let's go to work, and remember have some fun"
echo "Byyyyyye :)"
sleep 16

clear
