# config valid only for current version of Capistrano
lock "3.10.2"

set :application, "gallery"

set :repo_url, "git@github.com:CannyFoxx/gallery.git"
set :branch, "stable"

set :deploy_to, "/home/nginx/www/la.ignatovich.me"

set :format, :airbrussh
set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

append :linked_files, "config/database.yml", "config/secrets.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/files", "public/system"
set :keep_releases, 2

set :rvm_type, :system

set :sidekiq_default_hooks, true
set :sidekiq_pid, File.join(shared_path, 'tmp', 'pids', 'sidekiq.pid')
set :sidekiq_log, File.join(shared_path, 'log', 'sidekiq.log')
#set :sidekiq_processes, nil
set :sidekiq_concurrency, 4
