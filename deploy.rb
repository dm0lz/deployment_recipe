# To allow passwordless sudo, in visudo, add :
# deployer ALL=NOPASSWD: ALL
# %deployer ALL = (postgres) NOPASSWD: ALL

# Uncomment on first time you cap deploy
# before 'deploy', 'rvm1:install:rvm'
# before 'deploy', 'rvm1:install:ruby'
# before 'deploy', 'rvm1:alias:create'
# set :rvm1_alias_name, 'alias-gocode'

# config valid only for current version of Capistrano
lock '3.4.0'

set :application, "app_name"

set :repo_url,  "git@bitbucket.org:name/app_name.git"

set :site_url, "999.999.999.999"

set :deploy_to, "/home/deployer/apps/#{fetch(:application)}"

set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, true
set :use_sudo, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end


after 'deploy', 'puma:restart'

# Use capistrano-bundler instead of rvm1-capistrano3 bundler (both cannot be used at the same time)
# before 'deploy', 'rvm1:install:gems'

