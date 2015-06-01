def create_shared_dir(name)
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/#{name}"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/#{name}"]
end

def create_shared_file(file)
  queue! %[touch "#{deploy_to}/#{shared_path}/#{file}"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/#{file}'."]
end

def run_locally(cmd)
  puts cmd
  system cmd
end

def foreman_export
  app_root = "/home/#{user}/#{appname}/current"
  dir = "./config/deploy/#{rails_env}"
  run_locally "mkdir -p #{dir}"
  run_locally "foreman export upstart #{dir} -a #{appname} --root #{app_root} --procfile ./Procfile -u #{user} --env #{dir}/.env"
  run_locally "chmod 600 #{dir}/*.conf"
end

def sudo_upload(local,remote)
  run_locally "rsync --rsync-path=\"sudo rsync\" #{local} #{user}@#{domain}:#{remote}"
end


def upload(local,remote)
  run_locally "rsync #{local} #{user}@#{domain}:#{remote}"
end


def foreman_upload
  Dir["./config/deploy/#{rails_env}/*"].each do |file|
    sudo_upload file, "/etc/init"
  end
end
