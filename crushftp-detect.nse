local http = require "http"
local stdnse = require "stdnse"

description = [[
  This script checks if CrushFTP is detected on a web server.
]]

author = "Nithen Naidoo"
license = "Same as Nmap - See https://nmap.org/book/man-legal.html"
categories = {"default", "discovery"}

-- Define the script arguments (optional)
portrule = function(host, port)
  return port.number == 80 or port.number == 443
end

-- Main function
action = function(host, port)
  local path = "/WebInterface/login.html"
  local url = string.format("http://%s:%d%s", host.targetname or host.ip, port.number, path)
  
  stdnse.print_debug(1, "Checking for resource: %s", url)
  
  -- Perform the HTTP request
  local response = http.get(host, port, path)
  
  if response and response.status == 200 then
    return string.format("Resource %s CrushFTP found (Status: %d)", url, response.status)
  elseif response then
    return string.format("Resource %s CrushFTP not found (Status: %d)", url, response.status)
  else
    return string.format("Failed to connect to %s", url)
  end
end
