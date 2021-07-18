CasinoOpen = false
Debug = false
RegisterServerEvent('npc-unlock:casino')
AddEventHandler('npc-unlock:casino', function()
    local src = source
    TriggerClientEvent('npc-casino:unlock', -1)
    TriggerClientEvent("phone:addnotification", -1, "Casino","<b> -- Casino -- <b> <br> The Casino is Open! Head down there now to have the chance to win some serious money! <br>")
    CasinoOpen = true
end)


RegisterServerEvent('npc-casino:lock')
AddEventHandler('npc-casino:lock', function()
    local src = source
    TriggerClientEvent('npc-casino:lock', -1)
    TriggerClientEvent("phone:addnotification", -1, "Casino","<b> -- Casino -- <b> <br> The Casino is now Closed! Be sure to head there another day to have the chance to win some serious money! <br>")
    CasinoOpen = false
end)


RegisterNetEvent('npc-casino:CheckIfOpen')
AddEventHandler('npc-casino:CheckIfOpen', function()
    local src = source
    if CasinoOpen then
        TriggerClientEvent('npc-casino:unlock', src)
        Citizen.Wait(120000)
        TriggerClientEvent("phone:addnotification", src, "Casino","<b> -- Casino -- <b> <br> The Casino is Open! Head down there now to have the chance to win some serious money! <br>")
        if Debug then
            print('Casino is Open')
        end
    else
        TriggerClientEvent('npc-casino:lock', src)
        if Debug then
            print('Casino is Not Open')
        end
    end
end)