-- file: mqtt.lua
relayPort = 4
lightStatus = 0

gpio.mode(relayPort, gpio.OUTPUT)

-- init mqtt client with keepalive timer 120sec
m = mqtt.Client("garage", 120)

-- setup Last Will and Testament (optional)
-- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
-- to topic "/lwt" if client don't send keepalive packet
m:lwt("/lwt", "offline", 0, 0)

m:on("connect", function(client) print ("connected") end)
m:on("offline", function(client) print ("offline") end)

-- on publish message receive event
m:on("message", function(client, topic, data) 
  print(topic .. ":" ) 
  if data ~= nil then
    print(data)
  end
end)

-- for TLS: m:connect("192.168.11.118", secure-port, 1)
m:connect("192.168.2.37", 1883, 0, 1, function(client) print("connected") end)

-- Calling subscribe/publish only makes sense once the connection
-- was successfully established. In a real-world application you want
-- move those into the 'connect' callback or make otherwise sure the 
-- connection was established.

-- subscribe topic with qos = 0
m:subscribe("/fgdata",0, function(client) print("subscribe success") end)
-- publish a message with data = hello, QoS = 0, retain = 0
-- m:publish("/topic","hello",0,0, function(client) print("sent") end)

m:close();
-- you can call m:connect again
