AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  TriggerServerEvent("npc-commands:buildCommands","")
end)

RegisterCommand("cpr", function(source, args, rawCommand)
  TriggerEvent('pixerium:check', 3, 'trycpr', false)
end, false)

RegisterCommand("givekey", function(source, args, rawCommand)
  TriggerEvent("keys:give")
end, false)

RegisterCommand("window", function(source, args, rawCommand)
  TriggerEvent("car:windows",args[2], args[3])
end, false)


RegisterCommand("rollup", function(source, args, rawCommand)
  TriggerEvent("car:windowsup")
end, false)

RegisterCommand("finance", function(source, args, rawCommand)
  TriggerEvent('finance1')
end, false)


RegisterCommand("news", function(source, args, rawCommand)
  TriggerEvent('NewsStandCheck')
end, false)

RegisterCommand("confirm", function(source, args, rawCommand)
  TriggerEvent('housing:confirmed')
end, false)

RegisterCommand("notes", function(source, args, rawCommand)
  TriggerEvent('Notepad:open')
end, false)

RegisterCommand("trunkkidnap", function(source, args, rawCommand)
  TriggerEvent('ped:forceTrunk')
end, false)

RegisterCommand("trunkeject", function(source, args, rawCommand)
  TriggerEvent('ped:releaseTrunkCheck')
end, false)

RegisterCommand("trunkgetin", function(source, args, rawCommand)
  TriggerEvent('ped:forceTrunkSelf')
end, false)

RegisterCommand("trunkejectself", function(source, args, rawCommand)
  TriggerEvent('ped:releaseTrunkCheckSelf')
end, false)

RegisterCommand("anchor", function(source, args, rawCommand)
  TriggerEvent('client:anchor')
end, false)

RegisterCommand("atm", function(src, args, raw)
  TriggerEvent('bank:checkATM')
end)

RegisterCommand("tpm", function(source)
	local WaypointHandle = GetFirstBlipInfoId(8)
	
	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
	
		for height = 1, 1000 do
			SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
	
			local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
	
			if foundGround then
				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
	
				break
			end
	
			Citizen.Wait(5)
		end
	
		TriggerEvent("DoShortHudText", "Teleported.", 1)
	else
		TriggerEvent("DoShortHudText", "Marker not found.", 1)
	end
end)


