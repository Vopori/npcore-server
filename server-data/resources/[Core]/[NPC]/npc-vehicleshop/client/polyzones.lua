local nearRepo = false

Citizen.CreateThread(function()
    exports["npc-polyzone"]:AddBoxZone("veh_shop_repo", vector3(-18.64, -1102.71, 26.67), 10.4, 5, {
		name="veh_shop_repo",
		heading=340,
		--debugPoly=true,
		minZ=25.67,
		maxZ=29.87
    }) 
end)


RegisterNetEvent('npc-polyzone:enter')
AddEventHandler('npc-polyzone:enter', function(name)
    if name == "veh_shop_repo" then
        local job = exports["isPed"]:isPed("myjob")
        if job == "car_shop" then
            nearRepo = true
            AtRepo()
            TriggerEvent('npc-ui:ShowUI', 'show', ("[E] %s"):format("Repo Vehicle"))
        end
    end
end)

RegisterNetEvent('npc-polyzone:exit')
AddEventHandler('npc-polyzone:exit', function(name)
    if name == "veh_shop_repo" then
        nearRepo = false
    end
    TriggerEvent('npc-ui:HideUI')
end)

function AtRepo()
	Citizen.CreateThread(function()
        while nearRepo do
            Citizen.Wait(5)
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle ~= 0 then
                local plate = GetVehicleNumberPlateText(vehicle)
                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent("veh_shop:repo", plate)
                end
            end
        end
    end)
end