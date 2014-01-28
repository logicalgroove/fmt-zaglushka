set :application, 'fmt-zaglushka'
set :repo_url, 'git@github.com:logicalgroove/fmt-zaglushka.git'
set :branch, 'master'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/home/deploy/www/fmt-zaglushka'
set :scm, :git

set :format, :pretty
set :log_level, :debug
set :pty, true

set :rails_env, 'production'
set :assets_roles, [:web, :app]
set :normalize_asset_timestamps, %{public/images public/javascripts public/stylesheets}

set :linked_files, %w{config/application.yml config/mongoid.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 3

#set :rvm_ruby_version, 'ruby-2.0.0-p247@fmt-zaglushka'
#set :default_env, { rvm_bin_path: '~/.rvm/bin' }
#SSHKit.config.command_map[:rake] = "#{fetch(:default_env)[:rvm_bin_path]}/rvm ruby-#{fetch(:rvm_ruby_version)} do bundle exec rake"

task :reload_nginx, :roles => :app do
  sudo 'service nginx restart'
end

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  task :whoami do
    on roles(:all) do
      execute :whoami
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end

after "deploy", "reload_nginx"
