RegisterServerEvent('npc:infinity:player:ready')
AddEventHandler('npc:infinity:player:ready', function()
    local ting = GetEntityCoords(GetPlayerPed(source))
    
    TriggerClientEvent('npc:infinity:player:coords', -1, ting)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000)
        local ting = GetEntityCoords(source)

        TriggerClientEvent('npc:infinity:player:coords', -1, ting)
        TriggerEvent("npc-base:updatecoords", ting.x, ting.y, ting.z)
       -- print("[^2npc-infinity^0]^3 Sync Successful.^0")
    end
end)