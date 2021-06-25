local isVisible = false
local tabletObject = nil

-- Citizen.CreateThread(function()
-- 	while true do
--         Citizen.Wait(5)
-- 		local plyCoords = GetEntityCoords(PlayerPedId())
--         local distance = GetDistanceBetweenCoords(plyCoords.x,plyCoords.y,plyCoords.z, 260.56146240234, -371.65747070312, -44.137683868408,false)        
--         if distance <= 1.5 then
--             DrawText3DTest(260.56146240234, -371.65747070312, -44.137683868408, "[E] - Public Records") 
--             if IsControlJustReleased(0, 38) then
--                 TriggerServerEvent("mdt-civ:hotKeyOpen")
--             end
-- 		else
-- 			if distance >= 1.2 then
-- 				Citizen.Wait(1000)
-- 			end
-- 		end
-- 	end
-- end)

RegisterNetEvent("npc-civ:mdt:open")
AddEventHandler("npc-civ:mdt:open", function()
    TriggerServerEvent("mdt-civ:hotKeyOpen")
end)

TriggerServerEvent("npc-mdt-civ:getOffensesAndOfficer")
RegisterNetEvent("npc-mdt-civ:sendNUIMessage")
AddEventHandler("npc-mdt-civ:sendNUIMessage", function(messageTable)
    SendNUIMessage(messageTable)
end)

RegisterNetEvent("npc-mdt-civ:toggleVisibilty")
AddEventHandler("npc-mdt-civ:toggleVisibilty", function(reports, warrants, officer)
    local playerPed = PlayerPedId()
    if not isVisible then
        local dict = "amb@world_human_seat_wall_tablet@female@base"
        RequestAnimDict(dict)
        if tabletObject == nil then
            tabletObject = CreateObject(GetHashKey('prop_cs_tablet'), GetEntityCoords(playerPed), 1, 1, 1)
            AttachEntityToEntity(tabletObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        end
        while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
        if not IsEntityPlayingAnim(playerPed, dict, 'base', 3) then
            TaskPlayAnim(playerPed, dict, "base", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
        end
    else
        DeleteEntity(tabletObject)
        ClearPedTasks(playerPed)
        tabletObject = nil
    end
    if #warrants == 0 then warrants = false end
    if #reports == 0 then reports = false end
    SendNUIMessage({
        type = "recentReportsAndWarrantsLoaded",
        reports = reports,
        warrants = warrants,
        officer = officer
    })
    ToggleGUI()
end)

RegisterNUICallback("close", function(data, cb)
    local playerPed = PlayerPedId()
    DeleteEntity(tabletObject)
    ClearPedTasks(playerPed)
    tabletObject = nil
    ToggleGUI(false)
    cb('ok')
end)

RegisterNUICallback("performOffenderSearch", function(data, cb)
    TriggerServerEvent("npc-mdt-civ:performOffenderSearch", data.query)
    cb('ok')
end)

RegisterNUICallback("viewOffender", function(data, cb)
    TriggerServerEvent("npc-mdt-civ:getOffenderDetails", data.offender)
    cb('ok')
end)

RegisterNUICallback("performReportSearch", function(data, cb)
    TriggerServerEvent("npc-mdt-civ:performReportSearch", data.query)
    cb('ok')
end)

RegisterNUICallback("getOffender", function(data, cb)
    TriggerServerEvent("npc-mdt-civ:getOffenderDetailsById", data.char_id)
    cb('ok')
end)

RegisterNUICallback("getVehicle", function(data, cb)
    TriggerServerEvent("npc-mdt-civ:getVehicle", data.vehicle)
    cb('ok')
end)

RegisterNUICallback("getWarrants", function(data, cb)
    TriggerServerEvent("npc-mdt-civ:getWarrants")
    cb('ok')
end)

RegisterNUICallback("getReport", function(data, cb)
    TriggerServerEvent("npc-mdt-civ:getReportDetailsById", data.id)
    cb('ok')
end)

RegisterNetEvent("npc-mdt-civ:returnOffenderSearchResults")
AddEventHandler("npc-mdt-civ:returnOffenderSearchResults", function(results)
    SendNUIMessage({
        type = "returnedPersonMatches",
        matches = results
    })
end)

RegisterNetEvent("npc-mdt-civ:returnOffenderDetails")
AddEventHandler("npc-mdt-civ:returnOffenderDetails", function(data)
    SendNUIMessage({
        type = "returnedOffenderDetails",
        details = data
    })
end)

RegisterNetEvent("npc-mdt-civ:returnOffensesAndOfficer")
AddEventHandler("npc-mdt-civ:returnOffensesAndOfficer", function(data, name)
    SendNUIMessage({
        type = "offensesAndOfficerLoaded",
        offenses = data,
        name = name
    })
end)

RegisterNetEvent("npc-mdt-civ:returnReportSearchResults")
AddEventHandler("npc-mdt-civ:returnReportSearchResults", function(results)
    SendNUIMessage({
        type = "returnedReportMatches",
        matches = results
    })
end)

RegisterNetEvent("npc-mdt-civ:returnVehicleSearchInFront")
AddEventHandler("npc-mdt-civ:returnVehicleSearchInFront", function(results, plate)
    SendNUIMessage({
        type = "returnedVehicleMatchesInFront",
        matches = results,
        plate = plate
    })
end)

RegisterNetEvent("npc-mdt-civ:returnVehicleSearchResults")
AddEventHandler("npc-mdt-civ:returnVehicleSearchResults", function(results)
    SendNUIMessage({
        type = "returnedVehicleMatches",
        matches = results
    })
end)

RegisterNetEvent("npc-mdt-civ:returnVehicleDetails")
AddEventHandler("npc-mdt-civ:returnVehicleDetails", function(data)
    data.model = GetLabelText(GetDisplayNameFromVehicleModel(data.model))
    SendNUIMessage({
        type = "returnedVehicleDetails",
        details = data
    })
end)

RegisterNetEvent("npc-mdt-civ:returnWarrants")
AddEventHandler("npc-mdt-civ:returnWarrants", function(data)
    SendNUIMessage({
        type = "returnedWarrants",
        warrants = data
    })
end)

RegisterNetEvent("npc-mdt-civ:completedWarrantAction")
AddEventHandler("npc-mdt-civ:completedWarrantAction", function(data)
    SendNUIMessage({
        type = "completedWarrantAction"
    })
end)

RegisterNetEvent("npc-mdt-civ:returnReportDetails")
AddEventHandler("npc-mdt-civ:returnReportDetails", function(data)
    SendNUIMessage({
        type = "returnedReportDetails",
        details = data
    })
end)

function ToggleGUI(explicit_status)
  if explicit_status ~= nil then
    isVisible = explicit_status
  else
    isVisible = not isVisible
  end
  SetNuiFocus(isVisible, isVisible)
  SendNUIMessage({
    type = "enable",
    isVisible = isVisible
  })
end





function DrawText3DTest(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end
