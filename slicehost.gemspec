# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{slicehost}
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joshua Peek"]
  s.date = %q{2009-02-01}
  s.description = %q{Slicehost Capistrano recipes for configuring and managing your slice.}
  s.email = %q{josh@joshpeek.com}
  s.files = ["README", "MIT-LICENSE", "lib/capistrano/ext/slicehost", "lib/capistrano/ext/slicehost/apache.rb", "lib/capistrano/ext/slicehost/aptitude.rb", "lib/capistrano/ext/slicehost/disk.rb", "lib/capistrano/ext/slicehost/gems.rb", "lib/capistrano/ext/slicehost/git.rb", "lib/capistrano/ext/slicehost/iptables.rb", "lib/capistrano/ext/slicehost/mysql.rb", "lib/capistrano/ext/slicehost/render.rb", "lib/capistrano/ext/slicehost/ruby.rb", "lib/capistrano/ext/slicehost/slice.rb", "lib/capistrano/ext/slicehost/ssh.rb", "lib/capistrano/ext/slicehost/templates", "lib/capistrano/ext/slicehost/templates/iptables.erb", "lib/capistrano/ext/slicehost/templates/passenger.conf.erb", "lib/capistrano/ext/slicehost/templates/passenger.load.erb", "lib/capistrano/ext/slicehost/templates/sshd_config.erb", "lib/capistrano/ext/slicehost/templates/vhost.erb", "lib/capistrano/ext/slicehost.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/josh/slicehost}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Capistrano recipes for setting up and deploying to Slicehost}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capistrano>, ["> 2.5.0"])
    else
      s.add_dependency(%q<capistrano>, ["> 2.5.0"])
    end
  else
    s.add_dependency(%q<capistrano>, ["> 2.5.0"])
  end
end
