ssh_options = { :keys => [File.expand_path("~/.ssh/id_dsa"),File.expand_path("~/.ssh/id_rsa") ], :port => 22 }

namespace :useradd do

  class Password < String
    @@salts ||= ('a'..'z').to_a + ('A'..'Z').to_a + ("0".."9").to_a + "./".to_a

    def self.random(length = 8)
      r = ""      
      length.times { r << @@salts[ rand( @@salts.size ) ] }
      Password.new( r )
    end
    
    def crypt()
      # do standard crypt(3) with DES which is 'universally' available, MD5 is not
      # "password".crypt("sa")         
      # => "sa3tHJ3/KuYvI" 
      salt = Password.random(2)
      super(salt)

      # crypt(3) with MD5 is not available on Windows
      # salt = Password.random(8)
      # super("$1$#{salt}")
      # DOES NOT WORK WITH WINDOWS LIBRARIES
      # "password".crypt("$1$saltsalt")                                      
      # => "$1$saltsalt$qjXMvbEw8oaL.CzflDtaK/"
      # => "$1d2n7Q0.r54s" is the result on Windows which is incorrect
    end
  end

	def ask_with_default(prompt, var, default)
		set(var) do
			Capistrano::CLI.ui.ask "#{prompt}? [#{default}] : "
		end
		
		set var, default if eval("#{var.to_s}.empty?")
	end

  desc <<-DESC
    Check that %sudo entry exists in the /etc/sudoers file. If the entry \
    for the sudo group is not found then %sudo ALL=NOPASSWD: ALL is appended \
    to the file. This makes it easy to create sudo users with this command.
    
    NOTE: this tasks requires the role 'gateway_as_root', i.e., root@host.com.
  DESC
	task :check_sudoers, :roles => :gateway_as_root do    	
      sudo <<-END
        sh -c 'grep -F "^%sudo " /etc/sudoers > /dev/null 2>&1 || test ! -f /etc/sudoers || echo "%sudo ALL=NOPASSWD: ALL" >> /etc/sudoers'
      END
  end

  desc <<-DESC
    Interactive adduser with login, groups, shell and a random password.
    
    Creates a login account on the remote host and uploads your local \
    public SSH keys to the server. The keys are placed into the .ssh folder of \
    the newly created account.
    
    The password stored in the classic UNIX crypt password format. on most systems. \
    once you change the password it is converted into the md5-crypt format.
    
    A final check is done to make sure %sudo entry exists in the \
    /etc/sudoers file. If the entry for the sudo group is not found then %sudo \   
    ALL=NOPASSWD: ALL is appended to the file. This makes it easy to create sudo \
    users with this command.
    
    NOTE: this tasks requires the role 'gateway_as_root', i.e., root@host.com.
  DESC
	task :setup, :roles => :gateway_as_root do    	
		ask_with_default("Username", :username, user)
		ask_with_default("Groups", :groups, "users,sudo")
		ask_with_default("Shell", :login_shell, "/bin/bash")
    ask_with_default("Password", :tmp, Password.random)
    passwd = Password.new(tmp.to_s).crypt
		sudo "useradd -s #{login_shell} -G #{groups} -p #{passwd} -m #{username}"
    
    authorized_keys = ssh_options[:keys].collect { |key|
      begin
        File.read("#{key}.pub")
      rescue Errno::ENOENT
      end
    }.join("\n")  
    put(authorized_keys, 
      "/tmp/authorized_keys.#{username}.tmp", :mode => 0600 )
    cmds = [
        "mkdir -p ~#{username}/.ssh",
        "mv /tmp/authorized_keys.#{username}.tmp ~#{username}/.ssh/authorized_keys",
        "chown -R #{username}:#{username} ~#{username}/.ssh",
        "chmod 700 ~#{username}/.ssh"
      ]
      cmds.each do |cmd|
        sudo cmd
      end
    
    check_sudoers
	end
end