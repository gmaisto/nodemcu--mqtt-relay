-- file : config.lua
local module = {}

module.SSID = {}  
module.SSID["FamilyGate2"] = "Fra31Pre89T"

module.HOST = "192.168.2.37"  
module.PORT = 1883  
module.ID = node.chipid()

module.ENDPOINT = "fgdata"
module.STATUSENDPOINT = "light1"
  
return module  
