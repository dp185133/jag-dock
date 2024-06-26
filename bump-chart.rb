#!/usr/bin/env ruby

require 'yaml'

POD_NAME=ARGV[0] || 'vxfuel'

puts "POD: #{POD_NAME}"

CHART_FILE = "charts/vxfuel/Chart.yaml"

fc_chart = File.read(CHART_FILE)

chart = YAML.load(fc_chart)

ver = chart["version"]

if /(\d+\.\d+\.)(\d+)/.match(ver) then
  puts "found version #{$1}<#{$2}>"

  rev_new = $2.to_i + 1

  newver = "#{$1}#{rev_new}"

  chart["version"] = newver
  chart["appVersion"] = newver

  fc_chart = YAML.dump(chart)

  File.open(CHART_FILE, 'w') { |f| f.write(fc_chart) }

  rc = system <<SYSCOMMANDS

helm package -d charts/docs --version #{newver} charts/vxfuel && \
helm repo index charts --url https://github.com/dp185133/jag-dock/raw/main/charts && \
git add charts/docs/#{POD_NAME}-#{newver}.tgz && \
git commit -a -m "Increment #{POD_NAME} version to #{newver}" && \
git push

SYSCOMMANDS

  if not rc then
    puts "\nPACKAGING UPDATE FAILED!"
    exit 1
  else
    puts "\nUpdated '#{POD_NAME}' Charts. NEW VERSION=#{newver}"
  end
  
end



