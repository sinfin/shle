# -*- coding: utf-8 -*-
require 'droplet_kit'

# FIXME: update image_id
def create_droplet(name, image_id = 11397076)

  unless token = ENV.fetch("DIGITAL_OCEAN_TOKEN")
    raise "Missing DIGITAL_OCEAN_TOKEN in the environment"
  end

  client = DropletKit::Client.new(access_token: token)

  if client.droplets.all.find { |droplet| droplet.name == name }
    puts "Droplet already exists."
    return
  end

  ssh_keys = client.ssh_keys.all.map{|key| key.id}
  droplet_new = DropletKit::Droplet.new(name: name,
                                        region: 'ams3',
                                        image: image_id,
                                        size: '512mb',
                                        ipv6: true,
                                        private_networking: true,
                                        ssh_keys: ssh_keys)

  puts "Creating droplet #{name}..."
  droplet = client.droplets.create(droplet_new)

  while droplet.networks.v4.size == 0
    putc "."; sleep 1
    droplet = client.droplets.find(id: droplet.id)
  end

  droplet_conf = {}
  droplet_conf[:ipv4] = droplet.networks.v4.first.ip_address
  droplet_conf[:ipv6] = droplet.networks.v6.first.ip_address
  droplet_conf[:domain] = name

  # TODO Setup private network

  # Write down conf
  File.open("config/droplet.yml", 'w') { |f| YAML.dump(droplet_conf, f) }
  puts "Done! Please check the file config/droplet.yml"

end
