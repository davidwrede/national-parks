# -*- mode: ruby -*-
# vi: set ft=ruby :

HABITAT_SCRIPT_BASE = <<EOF.freeze
sudo apt-get update
sudo apt-get -y install curl

# download the Habitat binary
echo "Downloading the Habitat binary..."
if [ ! -f ~/hab-latest.tar.gz ]; then
  wget "https://api.bintray.com/content/habitat/stable/linux/x86_64/hab-%24latest-x86_64-linux.tar.gz?bt_package=hab-x86_64-linux" -O hab-latest.tar.gz
fi

# Unpack the binary and copy the hab binary into the $HOME/bin directory.
tar -xvf hab-latest.tar.gz
hab_directory=$(ls ~ | grep hab-*-x86_64-linux)
mkdir -p ~/bin
cp $hab_directory/hab ~/bin

# Add the path to the hab to the PATH environment variable.
export PATH=$PATH:~/bin

# Set the origin used for creating packages to `myorigin`.
export HAB_ORIGIN=myorigin

# To run packages natively in Linux, the Habitat supervisor requires the `hab` user and `hab` group to be present.
sudo adduser --group hab
sudo useradd -g hab hab

EOF

WEBAPP_SCRIPT = <<EOF.freeze
  sudo hab install $(ls -t /vagrant/results/dwrede-national-parks-* | head -n1)
EOF

MONGODB_SCRIPT = <<EOF.freeze
  sudo hab install dwrede/mongodb
# sudo hab start dwrede/mongodb --peer 172.17.0.2
EOF

UTIL_SCRIPT = <<EOF.freeze
sudo hab install core/jq-static
sudo hab pkg binlink core/jq-static jq
EOF

Vagrant.configure(2) do |config|

  config.vm.box = "bento/ubuntu-14.04"
  config.vm.box_version = '2.3.0'
  config.vm.provision 'shell', privileged: false, inline: HABITAT_SCRIPT_BASE.dup
  config.vm.provider 'virtualbox' do |v|
      v.memory = 1024
      v.cpus = 1
      v.linked_clone = true
  end

  config.vm.define "hab-webapp" do |cw|
    cw.vm.hostname = "hab-webapp"
    cw.vm.provision 'shell', privileged: false, inline: WEBAPP_SCRIPT.dup
    cw.vm.network "private_network", ip: "10.0.2.16", virtualbox__intnet: true 
  end

  config.vm.define "hab-util" do |cu|
    cu.vm.hostname = "hab-util"
    cu.vm.network "private_network", ip: "10.0.2.18", virtualbox__intnet: true
    cu.vm.provision 'shell', privileged: false, inline: UTIL_SCRIPT.dup
  end

  config.vm.define "hab-mongodb" do |cm|
    cm.vm.hostname = "hab-mongodb"
    cm.vm.network "private_network", ip: "10.0.2.17", virtualbox__intnet: true 
    cm.vm.provision 'shell', privileged: false, inline: MONGODB_SCRIPT.dup
  end
end
