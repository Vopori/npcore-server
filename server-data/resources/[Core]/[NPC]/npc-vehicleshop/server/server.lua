
RegisterServerEvent('npc-vehicleshop.requestInfo')
AddEventHandler('npc-vehicleshop.requestInfo', function()
    local src = source
    local user = exports["npc-core"]:getModule("Player"):GetUser(src)
	local firstname = user:getCurrentCharacter().first_name
    local rows    

    TriggerClientEvent('npc-vehicleshop.receiveInfo', src, user:getBalance(), firstname)
    TriggerClientEvent("npc-vehicleshop.notify", src, 'error', 'Use A and D To Rotate')
end)

RegisterServerEvent('npc-vehicleshop.isPlateTaken')
AddEventHandler('npc-vehicleshop.isPlateTaken', function (plate)
	local src = source
	exports.ghmattimysql:execute("SELECT * FROM `player_vehicles` WHERE `plate` = @plate", {["plate"] = plate}, function(result)
		TriggerClientEvent('npc-vehicleshop.isPlateTaken', src, (result[1] ~= nil))
    end)
end)

RegisterServerEvent('npc-vehicleshop.CheckMoneyForVeh')
AddEventHandler('npc-vehicleshop.CheckMoneyForVeh', function(veh, price, name, vehicleProps)
    local src = source
    local user = exports["npc-core"]:getModule("Player"):GetUser(src)
	local chrctr = user:getCurrentCharacter()
	local bankbal = user:getBalance()

    if bankbal >= tonumber(price) then
        user:removeBank(tonumber(price))
        local vehiclePropsjson = json.encode(vehicleProps)
        if Cfg.SpawnVehicle then
            stateVehicle = 0
        else
            stateVehicle = 1
        end
		
		local q = [[INSERT INTO player_vehicles (steam, cid, vehicle, hash, mods, plate, state)
                VALUES(@steam, @cid, @vehicle, @hash, @mods, @plate, @state);]]
		local v = {
			["steam"] = chrctr.owner,
			["cid"] = chrctr.id,
			["vehicle"] = veh,
			["hash"] = GetHashKey(veh),
			["mods"] = vehiclePropsjson,
			["plate"] = vehicleProps.plate,
			["state"] = stateVehicle
		}
		exports.ghmattimysql:execute(q, v)
		TriggerClientEvent("npc-vehicleshop.successfulbuy", source, name, vehicleProps.plate, price)
		TriggerClientEvent('npc-vehicleshop.receiveInfo', src, user:getBalance())    
		TriggerClientEvent('npc-vehicleshop.spawnVehicle', src, veh, vehicleProps.plate)
    else
        TriggerClientEvent("npc-vehicleshop.notify", source, 'error', 'Not Enough Money')
    end
end)

RegisterServerEvent('npc-vehicleshop:npcCreate')
AddEventHandler('npc-vehicleshop:npcCreate', function()
	TriggerClientEvent('npc-vehicleshop:npcCreate', -1)
end)