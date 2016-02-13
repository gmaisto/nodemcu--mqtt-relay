-- file : config.lua
local module = {}

module.SSID = {}  
module.SSID["YOUR_WIFI_SSID"] = "YOUR_WIFI_PASSWORD"

module.HOST = "192.168.2.37"  
module.PORT = 1883  
module.ID = node.chipid()

module.ENDPOINT = "fgdata"  
return module  
