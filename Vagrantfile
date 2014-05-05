# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 80, host: 3000

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

script = <<EOF

apt-get -y update
apt-get install python-software-properties -y
apt-add-repository ppa:brightbox/ruby-ng -y
add-apt-repository ppa:nginx/stable -y

apt-get -y update
apt-get -y install python-software-properties htop iftop iotop mytop sysstat screen byobu curl subversion git-core rsync openjdk-7-jre libpq-dev wget libyaml-ruby libzlib-ruby ruby2.0 ruby2.0-dev build-essential libxslt-dev libxml2-dev curl nano

# Setup mysql
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password toor'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password toor'
apt-get -y update
apt-get -y install mysql-server
mysql -uroot -ptoor -e "GRANT ALL ON druid.* TO 'druid'@'localhost' IDENTIFIED BY 'diurd'; CREATE database druid;"

# Setup druid
wget -c http://static.druid.io/artifacts/releases/druid-services-0.6.104-bin.tar.gz
tar -zxvf druid-services-*-bin.tar.gz
cd druid-services-0.6.104

# Setup Zookeeper
curl http://www.motorlogy.com/apache/zookeeper/zookeeper-3.4.5/zookeeper-3.4.5.tar.gz -o zookeeper-3.4.5.tar.gz
tar xzf zookeeper-3.4.5.tar.gz
cd zookeeper-3.4.5
cp conf/zoo_sample.cfg conf/zoo.cfg
./bin/zkServer.sh start
cd ..

sleep 10

# Start the coordinator node
screen -d -S coordinator_node -m java -Xmx256m -Duser.timezone=UTC -Dfile.encoding=UTF-8 -classpath lib/*:config/coordinator io.druid.cli.Main server coordinator

# Start the historical node
screen -S historical_node -d -m java -Xmx256m -Duser.timezone=UTC -Dfile.encoding=UTF-8 -classpath lib/*:config/historical io.druid.cli.Main server historical

# Start the broker node
screen -S broker_node -d -m java -Xmx256m -Duser.timezone=UTC -Dfile.encoding=UTF-8 -classpath lib/*:config/broker io.druid.cli.Main server broker

# Start the overlord node
screen -S overlord_node -d -m java -Xmx2g -Duser.timezone=UTC -Dfile.encoding=UTF-8 -classpath lib/*:config/overlord io.druid.cli.Main server overlord

EOF

config.vm.provision :shell, inline: script
end
