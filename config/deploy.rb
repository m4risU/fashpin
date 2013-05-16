set :application, "omrails"
set :repository, "git@omrails.github.com:m4risU/omrails.git"
set :scm, :git
set :scm_user, "m4risu"

set :use_sudo, false
set :deploy_to, "/home/rails/omrails/"

set :keep_releases, 5
after 'deploy:update', 'deploy:cleanup'

#server "5.9.31.163", :app, :web, :db, :primary => true
server 'redwarrior.pl', :app, :web, :db, :primary => true

set :rails_env, "production"
set :user, "rails"

set :default_environment, {
    'PATH' => "/home/rails/.rvm/gems/ruby-1.9.3-p125@omrails/bin:/home/rails/.rvm/gems/ruby-1.9.3-p125@global/bin:/home/rails/.rvm/rubies/ruby-1.9.3-p125/bin:/home/rails/.rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
    'GEM_HOME' => '/home/rails/.rvm/gems/ruby-1.9.3-p125@omrails',
    'GEM_PATH' => '/home/rails/.rvm/gems/ruby-1.9.3-p125@omrails:/home/rails/.rvm/gems/ruby-1.9.3-p125@global',
    'BUNDLE_PATH' => ''
}

after "deploy:update", "deploy:copy_yml_files"
after "deploy:update", "deploy:rvm_init"
after "deploy:rvm_init", "deploy:bundle"
before "deploy:restart", "deploy:bundle"

deploy.task "rvm_init" do
  run "cd #{release_path}; echo 'rvm use 1.9.3-p125@omrails' > #{release_path}/.rvmrc"
end

deploy.task :copy_yml_files do
  run 'ln -s /home/rails/omrails/etc/config/database.yml /home/rails/omrails/current/config/database.yml'
  run 'ln -s /home/rails/omrails/etc/data/spree /home/rails/omrails/current/public/spree'
end

deploy.task :bundle do
  run "cd #{release_path}; bundle install --path /home/rails/.rvm/gems/ruby-1.9.3-p125@omrails"
end

deploy.task :restart, :roles => :app do
  run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake db:migrate"
  run "sudo service omrails restart"
end
