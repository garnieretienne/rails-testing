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
set :deploy_to, "/var/app/#{application}"
set :use_sudo, false
set :user, "kurt"

role :web, "testing.yuweb.com"
role :app, "testing.yuweb.com"
role :db,  "testing.yuweb.com", :primary => true

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
