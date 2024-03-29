#!/usr/bin/env ruby

require 'yaml'

$POD_NAME=ARGV[0] || 'vxfuel'

puts "POD: #{$POD_NAME}"


class YamlFile
  attr_reader :fname
  
  def YamlFile.exists? fname
    File.exists? fname
  end

  def load
    filecontent_deploy = File.read(@fname)

    @deploy = YAML.load(filecontent_deploy)
  end

  def fname
    @fname
  end

  def initialize fname
    @fname = fname
  end

  def write
    fc_deploy = YAML.dump(@deploy)

    File.open(@fname, 'w') { |f| f.write(fc_deploy) }
  end
end

class ValuesFile < YamlFile
  @@fname = "charts/#{$POD_NAME}/values.yaml"

  def ValuesFile.exists?
    YamlFile.exists? @@fname
  end
  
  def initialize
    super @@fname
  end
  

  def full_registry_path
    "#{@deploy['global']['repository']}/#{$POD_NAME}:#{@deploy['global']['imageVersion']}"
  end
  
  def imageVersion
    @deploy["global"]["imageVersion"]
  end
  
  def imageVersion= newver
    @deploy["global"]["imageVersion"] = newver
  end
end


class DeployFile < YamlFile
  @@fname = "charts/#{$POD_NAME}/templates/deployment.yaml"

  def exists?
    YamlFile.exists? @@fname
  end
  
  def initialize
    super @@fname
  end

  def imageSpec
    @deploy["spec"]["template"]["spec"]["containers"][0]["image"]
  end

  def imageVersion= newver
    @deploy["spec"]["template"]["spec"]["containers"][0]["image"] = "#{@registry}:#{newver}"
  end
    
  
  def imageVersion
    image = self.imageSpec()
    
    if /(.*?)\:(\d+\.\d+\.\d+)/.match(image) then
      @registry = $1
      ver = $2
      ver
    else
      throw "could not read image version from deployment.yaml"
    end
  end

  def full_registry_path
    self.imageSpec
  end
end

specfile =  ValuesFile.exists? && ValuesFile.new || DeployFile.new

specfile.load()

imageVersion = specfile.imageVersion()

puts "read imageVersion from yaml files=#{imageVersion}"

unless /(\d+\.\d+\.)(\d+)/.match(imageVersion) then
  puts "Found bad imageVersion format ('#{imageVersion}')"
else
  ver_base = $1
  ver_old = $2
  puts "Current version=#{ver_base}<#{ver_old}>"

  rev_new = ver_old.to_i + 1

  specfile.imageVersion = "#{ver_base}#{rev_new}"

  specfile.write

  system <<SYSCOMMANDS

docker image tag #{$POD_NAME}:latest #{specfile.full_registry_path}
docker push #{specfile.full_registry_path}
./bump-chart.rb #{$POD_NAME}

SYSCOMMANDS
  
end



