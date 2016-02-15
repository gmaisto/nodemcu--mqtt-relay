-- file : application.lua
local module = {}
m = nil
local relay = 2
local light = false

-- put GPIO Relay PIN as OUTPUT GPIO
gpio.mode(relay,gpio.OUTPUT)

-- Sends a simple ping to the broker
local function send_ping()
   if m ~= nil then
      m:publish(config.ENDPOINT .. "ping","id=" .. config.ID,0,0)
   end
end

-- Publish the light status on mqtt broker
local function send_lightstatus(status)
   if m ~= nil then
      m:publish(config.STATUSENDPOINT,status,0,0)
   end
end


-- Sends my id to the broker for registration
local function register_myself()
   if m ~= nil then
      m:subscribe(config.ENDPOINT,0,function(conn)
                --     print("Successfully subscribed to data endpoint")
      end)
   end
end

local function mqtt_start()
   m = mqtt.Client(config.ID, 120)
   -- register message callback beforehand
   m:on("message", function(conn, topic, data)
           if data ~= nil then
              -- print(topic .. ": " .. data)
              local switch,lux,temp = data.match(data,"(.+)#(.+)#(.+)")
              if (switch ~= nil and switch == "1" and light == false) then
              --   print("Switch light: ON")
                 light = true
                 gpio.write(relay,gpio.HIGH)
                 send_lightstatus("ON")
              end

              if (switch ~= nil and switch == "0" and light == true) then
              --   print("Switch light: OFF")
                 light = false
                 gpio.write(relay,gpio.LOW)
                 send_lightstatus("OFF")
              end

              if (switch ~= nil and switch == "0" and light == false) then
                 light = false
                 send_lightstatus("OFF")
              end

              if (switch ~= nil and switch == "1" and light == true) then
                 light = true
                 send_lightstatus("ON")
              end
           end
   end)
   -- Connect to broker
   m:connect(config.HOST, config.PORT, 0, 1, function(con)
                register_myself()
                -- And then pings each 1000 milliseconds
                tmr.stop(6)
                tmr.alarm(6, 1000, 1, send_ping)
   end)

   m:on("offline", function(con)
           print ("Mqtt Reconnecting...")
           tmr.alarm(1, 10000, 1, function()
                        reconnect()
           end)
   end)
end

local function reconnect()
	print ("Waiting for Wifi")
	if wifi.sta.status() == 5 and wifi.sta.getip() ~= nil then
		print ("Wifi Up!")
		tmr.stop(1)
    mqtt_start()
		-- m:connect(config.HOST, config.PORT, 0, 1, function(conn)
		-- 	print("Mqtt Connected to:" .. config.HOST)
		-- 	register_myself() --run the subscripion function
		-- end)
	end
 end

function module.start()
  mqtt_start()
end

return module
