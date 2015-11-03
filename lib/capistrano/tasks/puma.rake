require 'pry'

namespace :puma do

	desc "Setup puma config"
	task :setup do
    on roles(:all) do
      set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
      set :puma_state, "#{shared_path}/tmp/pids/puma.state"
      set :puma_sock, "#{shared_path}/tmp/sockets/puma.sock"
      set :puma_sock_ctl, "#{shared_path}/tmp/sockets/pumactl.sock"
      set :puma_config, "#{shared_path}/config/puma.rb"
      set :puma_user, 'deployer'
      execute "mkdir -p #{shared_path}/config"
      execute "mkdir -p #{shared_path}/tmp"
      execute "mkdir -p #{shared_path}/tmp/pids"
      execute "mkdir -p #{shared_path}/tmp/sockets"
      template "puma.rb.erb", fetch(:puma_config)
      template "puma_init.erb", "/tmp/puma_init"
      execute "chmod +x /tmp/puma_init"
      execute :sudo, "mv /tmp/puma_init /etc/init.d/puma_#{fetch(:application)}"
      execute :sudo, "update-rc.d -f puma_#{fetch(:application)} defaults"
    end
	end

  %w[start stop].each do |command|
    desc "#{command} Puma"
    task command do
      on roles(:all) do
        execute :sudo, "service puma_gocode #{command}"
      end
    end
  end

  desc "Restart Puma"
  task :restart do
    on roles(:all) do
      execute :sudo, "service puma_#{fetch(:application)} stop"
      execute :sudo, "service puma_#{fetch(:application)} start"
    end
  end

end
