# config/deploy.rb

require 'bundler/capistrano'

# set :rvm_ruby_string, :local               # use the same ruby as used locally for deployment
# set :rvm_autolibs_flag, "read-only"        # more info: rvm help autolibs

# require "rvm/capistrano"

# Chef has already installed RVM for us and made a gemset for us. 
# before 'deploy:setup', 'rvm:install_rvm'   # install RVM -- which we don't need
#before 'deploy:setup', 'rvm:install_ruby'  # install Ruby and create gemset -- again don't need it. 
#before 'deploy:setup', 'rvm:create_gemset' # only create gemset - again, Chef did this for us already.

# but we do need to set it for system wide RVM, since we're not using User specific RVMs. 

# this is handled by the runit service we configured in Chef, so we don't need it. 
#require 'capistrano-unicorn'
#after 'deploy:restart', 'unicorn:reload' # app IS NOT preloaded
#after 'deploy:restart', 'unicorn:restart'  # app preloaded


set :application, 'olac-annotator.org'
set :stages, %w(production staging)
set :default_stage, 'production'
role :web, 'olac-annotator.org'
role :app, 'olac-annotator.org'

require 'capistrano/ext/multistage'

role :db, application, :primary => true

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# This is were we point Capistrano to the version control where our code lives.  
set :repository, "https://github.com/cfitz/olac-annotator.git"
set :deploy_to, "/var/www/#{application}"
set :branch, "master"

set :scm, :git
set :scm_verbose, true

set :deploy_via, :remote_cache
set :use_sudo, false
set :keep_releases, 3
set :user, 'rails'
set :use_sudo, false

set :bundle_without, [:development, :test, :acceptance]
set :rake, "#{rake} --trace"

before 'deploy:finalize_update', 'deploy:assets:symlink'
after 'deploy:update_code', 'deploy:assets:precompile'

# Here's some stuff if you want to use the Whenever Gem for Crontabs. Neat. But we're not using it now. 
#before 'deploy:update_code', "deploy:clear_crontab"
#after 'deploy:update_code', 'deploy:update_crontab'


namespace :deploy do
  desc <<-DESC
  Send a USR2 to the unicorn process to restart for zero downtime deploys.
  runit expects 2 to tell it to send the USR2 signal to the process.
  DESC

  task :restart, :roles => :app, :except => { :no_release => true } do
     run "sv 2 /home/#{user}/service/railsapp"
  end
  
  # This is how you can update the crontab with Cap. Not using it now. 
  
  # desc "Update the crontab file"
  #  task :update_crontab, :roles => :app, :except => { :no_release => true } do
  #    run "cd #{release_path} && bundle exec whenever --update-crontab #{application}"
  #  end
  #  
  #  desc "Update the crontab file"
  #  task :clear_crontab, :roles => :app, :except => { :no_release => true } do
  #    run "cd #{release_path} && bundle exec whenever --clear-crontab #{application}"
  #  end
 
    namespace :assets do
      # If you want to force the compilation of assets, just set the ENV['COMPILE_ASSETS']
       task :precompile, :roles => :web do
         force_compile = ENV['COMPILE_ASSETS']
         begin # on first deploys, there is no current_revision so an error gets raised. in this case we want to just compile assets and upload them. 
           from = source.next_revision(current_revision) 
         rescue
           force_compile = true
         end
         if ( force_compile) or (capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ lib/assets/ app/assets/ | wc -l").to_i > 0 )
           run_locally("rake assets:clean && rake assets:precompile")
           run_locally "cd public && tar -jcf assets.tar.bz2 assets"
           top.upload "public/assets.tar.bz2", "#{shared_path}", :via => :scp
           run "cd #{shared_path} && tar -jxf assets.tar.bz2 && rm assets.tar.bz2"
           run_locally "rm public/assets.tar.bz2"
           run_locally("rake assets:clean")
         else
          logger.info "Skipping asset precompilation because there were no asset changes"
         end
       end
       
       task :symlink, roles: :web do
         run ("rm -rf #{latest_release}/public/assets &&
               mkdir -p #{latest_release}/public &&
               mkdir -p #{shared_path}/assets &&
               ln -s #{shared_path}/assets #{latest_release}/public/assets")
       end
       
       
    end

end

#

