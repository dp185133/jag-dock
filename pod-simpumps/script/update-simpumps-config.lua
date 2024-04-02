local configFileName = arg[1]

print(string.format("Updating simpumps config file: %s", configFileName))

local ifcfg_proc = io.popen('/sbin/ip addr show | grep "inet " | grep -v 127.0.0.1')
local lines = ifcfg_proc:read('*all')
ifcfg_proc:close()

local myip = string.match(lines, '%s+inet (%d+%.%d+%.%d+%.%d+)')
if myip then
   io.write(string.format("Updating simpumps server address to: %s\n", myip))
   os.execute(string.format("sed -i s/REPLACE_MYIPADDR/%s/ %s", myip, configFileName))
else
   print(string.format("Could not find container IP address: ip output=%s", lines))
end


