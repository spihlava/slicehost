namespace :turnkey do
  task :configure, roles => :gateway do
    sudo 'apt-get update -y'
    sudo 'apt-get install aptitude -y'
    sudo 'aptitude install wget -y'
    ssh.configure_sshd
    ssh.reload
    iptables.configure
    aptitude.setup
  end

   task :setupdev, roles => :gateway do
    configure
    sudo 'aptitude install xauth xterm'
    mysql.install
    apache.install
    ruby.setup_18
    ruby.install_enterprise
    gems.install_rubygems
    ruby.install_passenger
    apache.upload_vhost
    git.install
    end

end
