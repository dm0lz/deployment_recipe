require 'pry'

namespace :nginx do

	desc "Setup nginx configuration for this application"

	task :setup do
    on roles(:all) do
      execute :sudo, "apt-get -y update"
      execute :sudo, "apt-get install -y nginx"
      template "nginx_puma.rb.erb", "/tmp/puma_conf"
      execute :sudo, "mv /tmp/puma_conf /etc/nginx/sites-enabled/#{fetch(:application)}"
      execute :sudo, "rm -f /etc/nginx/sites-enabled/default"
      Rake::Task["nginx:restart"].invoke
    end
	end

	%w(start stop restart).each do |command|
		desc "#{command} nginx"
		task command do
      on roles(:all) do
        execute :sudo, "service nginx #{command}"
      end
		end
	end

end
