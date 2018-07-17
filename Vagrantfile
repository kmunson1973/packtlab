# Example 6
#
# Pulling out all the stops with cluster of seven Vagrant boxes.
#
domain   = 'example.com'



#Base script to run updates, install docker
$basescr = <<-BASESCRIPT
  if [ -f /tmp/scriptrun ]; then exit 0;fi
  cat /vagrant/packtlab/hosts >> /etc/hosts
  apt-get update
  apt-get install -y kubelet=1.9.8-00 kubeadm=1.9.8-00 kubectl=1.9.8-00 kubernetes-cni bash-completion
  echo "source <(kubectl completion bash)" >> ~/.bashrc
  /vagrant/packtlab/join.sh
  systemctl daemon-reload
  systemctl restart kubelet.service
  echo "nameserver 10.96.0.10" > /etc/resolv.conf
  echo "nameserver 8.8.8.8" >> /etc/resolv.conf
  echo "echo order bind,hosts" > /etc/hosts.conf
  echo "hosts: dns files" >> /etc/nsswitch.conf
  touch /tmp/scriptrun
BASESCRIPT

$primstrscr = <<-PRISCRIPT
  if [ -f /tmp/scriptrun ]; then exit 0;fi
  cat /vagrant/packtlab/hosts >> /etc/hosts
  apt-get update
  apt-get install -y kubelet=1.9.8-00 kubeadm=1.9.8-00 kubectl=1.9.8-00 kubernetes-cni bash-completion
  echo "source <(kubectl completion bash)" >> /home/vagrant/.bashrc
  echo "source <(kubectl completion bash)" >> ~/.bashrc
  kubeadm  init --pod-network-cidr 10.244.0.0/16 --apiserver-advertise-address 192.168.0.11
  mkdir -p /home/vagrant/.kube
  mkdir -p /$HOME/.kube
  cp -i /etc/kubernetes/admin.conf /$HOME/.kube/config
  cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
  chmod -R 777 /home/vagrant/.kube
  kubeadm token create $(kubeadm token generate) --print-join-command > /vagrant/packtlab/join.sh
  /vagrant/packtlab/k8smstrpods.sh
  mkdir -p /etc/cni/net.d
  systemctl daemon-reload
  systemctl restart kubelet.service
  systemctl daemon-reload
  systemctl restart kubelet.service
  echo "nameserver 10.96.0.10" > /etc/resolv.conf
  echo "nameserver 8.8.8.8" >> /etc/resolv.conf
  echo "echo order bind,hosts" > /etc/hosts.conf
  echo "hosts: dns files" >> /etc/nsswitch.conf
  echo -e "\n\n\n" | ssh-keygen -t rsa -N ""  
  touch /tmp/scriptrun
PRISCRIPT


nodes = [
  { :hostname => 'umstr01',   :ip => '192.168.0.11', :script => $primstrscr, :vmimg => 'kmunson/px-lubuntu' },
  { :hostname => 'unode01',   :ip => '192.168.0.21', :script => $basescr, :vmimg => 'kmunson/ubuntu-16.04'},
  { :hostname => 'unode02',   :ip => '192.168.0.22', :script => $basescr, :vmimg => 'kmunson/ubuntu-16.04'}
]



Vagrant.configure("2") do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|
      #nodeconfig.vm.box = "ubuntu/xenial64"
      #nodeconfig.vm.box = "bento/ubuntu-16.04"
      nodeconfig.vm.box = node[:vmimg]
      nodeconfig.vm.hostname = node[:hostname] + ".box"
      nodeconfig.vm.network :private_network  , ip: node[:ip]
      nodeconfig.vm.provider :virtualbox do |vb|
      nodeconfig.ssh.username = "vagrant"
      nodeconfig.ssh.password = "vagrant"
      #nodeconfig.ssh.insert_key  = "true"
      nodeconfig.vm.boot_timeout = 300
      vb.memory = "2048"
      vb.cpus = "2"
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off", "--natdnsproxy1", "off" ]
      if (node[:vmimg] == 'kmunson/px-lubuntu')
        vb.gui = true
      end 
      vb.customize ["modifyvm", :id,  '--macaddress1', 'auto']
      vb.linked_clone = true
      nodeconfig.vm.provision :shell, inline: (node[:script]), name: "basescript"
    end
  end
end
end


