#!/usr/bin/env ruby

require 'yaml'

POD_NAME=ARGV[0] || 'vxfuel'

puts "POD: #{POD_NAME}"

DEPLOY_FILE = "charts/#{POD_NAME}/templates/deployment.yaml"

fc_deploy = File.read(DEPLOY_FILE)

deploy = YAML.load(fc_deploy)


#puts( deploy.inspect )
#puts( deploy["spec"]["template"]["spec"]["containers"][0]["image"])
#exit 0

image = deploy["spec"]["template"]["spec"]["containers"][0]["image"]

if /(.*?)\:(\d+\.\d+\.)(\d+)/.match(image) then
  registry = $1
  ver_base = $2
  ver_old = $3
  puts "found version #{ver_base}<#{ver_old}>"

  rev_new = ver_old.to_i + 1

  newver = "#{ver_base}#{rev_new}"

  registry_path = "#{registry}:#{newver}"

  deploy["spec"]["template"]["spec"]["containers"][0]["image"] = registry_path

  fc_deploy = YAML.dump(deploy)

  File.open(DEPLOY_FILE, 'w') { |f| f.write(fc_deploy) }

  system <<SYSCOMMANDS

docker image tag #{POD_NAME}:latest #{registry_path}
docker push #{registry_path}
./bump-version.rb #{POD_NAME}

SYSCOMMANDS
  
end



