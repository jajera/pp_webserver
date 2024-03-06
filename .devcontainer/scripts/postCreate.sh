# Include commands that you would like to execute after the container is created
wget https://apt.puppet.com/puppet-tools-release-jammy.deb
dpkg -i puppet-tools-release-jammy.deb
rm -rf puppet-tools-release-jammy.deb
apt-get update -y
export DEBIAN_FRONTEND=noninteractive
apt-get install -y \
  puppet \
  build-essential \
  ruby-dev \
  pdk \
  puppet-bolt \
  --no-install-recommends
gem install bundler
