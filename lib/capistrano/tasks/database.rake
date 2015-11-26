require 'pry'

namespace :database do

  desc "Setup Postgres | Create Database | Create DB User | Generate and upload database.yml"

  task :setup do
    on roles(:all) do
      set :db_name, "#{fetch(:application)}_#{fetch(:stage)}"
      STDOUT.puts "Enter DB User : "
      db_user = STDIN.gets.strip
      set :db_user, db_user
      STDOUT.puts "Enter DB Password : "
      db_password = STDIN.noecho(&:gets).strip
      set :db_password, db_password
      set :db_host, "localhost"
      execute "mkdir -p #{shared_path}/config"
      template "database.yml.erb", "#{shared_path}/config/database.yml"
      # setup postgresql
      execute :sudo, "apt-get -y update"
      execute :sudo, "apt-get install -y postgresql postgresql-contrib libpq-dev"
      # Create db user if it does not exists
      if test %Q{sudo -u postgres psql -tAc "SELECT * FROM pg_roles WHERE rolname='#{fetch :db_user}'" |cut -d "|" -f 1 |grep -wq #{fetch :db_user}}
        info "User #{fetch :db_user} already exists"
      else
        execute %Q{sudo -u postgres psql -c "create user #{fetch :db_user} with password '#{fetch :db_password}';"}
        execute %Q{sudo -u postgres psql -c "ALTER ROLE #{fetch :db_user} WITH CREATEDB;"}
      end
      # Create database if it does not exists
      if test %Q{sudo -u postgres psql -lqt | cut -d \\| -f 1 | grep -wq #{fetch :db_name}}
        info "Database #{fetch :db_name} already exists"
      else
        execute %Q{sudo -u postgres psql -tAc "CREATE DATABASE #{fetch :db_name};"}
        execute %Q{sudo -u postgres psql -c "ALTER database #{fetch :db_name} OWNER to #{fetch :db_user};"}
      end
    end
  end

end
