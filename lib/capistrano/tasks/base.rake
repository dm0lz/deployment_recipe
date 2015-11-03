
def template(from, to)
  template_path = File.expand_path("../templates/#{from}", __FILE__)
  template = ERB.new(File.new(template_path).read).result(binding)
  upload! StringIO.new(template), to
end

namespace :app do
  task :update_rvm_key do
    on roles(:all) do
      execute :gpg2, "--keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3"
    end
  end
end
before "rvm1:install:rvm", "app:update_rvm_key"

namespace :deploy do

	desc "Setup nginx and puma"
	task :setup do
    on roles(:all) do
      Rake::Task["database:setup"].invoke
      Rake::Task["nginx:setup"].invoke
      Rake::Task["puma:setup"].invoke
    end
	end

end
