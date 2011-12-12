require "bundler/capistrano"
set :bundle_without,  [:development, :test]

# rbenv
set :default_environment, {
  'PATH' => "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH"
}

set :application, "rails"
set :repository,  "git@github.com:garnieretienne/rails-testing.git"
set :branch, "master"

set :scm, :git
set :deploy_via, :remote_cache
ssh_options[:forward_agent] = true
default_run_options[:pty] = true 
set :deploy_to, "/var/app/#{application}"
set :use_sudo, false
set :user, "kurt"

role :web, "testing.yuweb.com"
role :app, "testing.yuweb.com"
role :db,  "testing.yuweb.com", :primary => true

# Rewrite some defauly deployment tasks
namespace:deploy do
  desc "Start the application"
  task :start do
    sudo("/etc/init.d/#{application} start")
  end

  desc "Stop the application"
  task :stop do
    sudo("/etc/init.d/#{application} stop")
  end

  desc "Restart the application"
  task :restart do
    sudo("/etc/init.d/#{application} restart")
  end
end

# Rails 3.1: compile assets after deployment
after 'deploy:update_code' do
  run "cd #{release_path}; RAILS_ENV=production rake assets:precompile"
end

# Fix permissions
after "deploy:update_code", :roles => [:web, :db, :app] do
  sudo "chown -R #{application}:sysadmin #{deploy_to}/*" 
end
