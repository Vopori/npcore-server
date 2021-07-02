RegisterServerEvent('cunt:pay')
AddEventHandler('cunt:pay', function(money)
    local source = source
    local LocalPlayer = exports['npc-base']:getModule('LocalPlayer')
    if money ~= nil then
       TriggerClientEvent('DoLongHudText', source, 'You got $'.. money .. ' for 2 chicken', 1)
    end
end)

RegisterServerEvent('npc-chickenjob:reward')
AddEventHandler('npc-chickenjob:reward', function()
end)

RegisterServerEvent('NPC-Armour:Server:RefreshCurrentArmour')
AddEventHandler('NPC-Armour:Server:RefreshCurrentArmour', function(updateArmour, cid)
    local src = source
    exports.ghmattimysql:execute("UPDATE __characters SET armor = @armor WHERE id = @id", { 
        ['@id'] = cid,
        ['@armor'] = tonumber(updateArmour)
    })
end)

-- RegisterServerEvent('NPC-Health:Server:RefreshCurrentArmour')
-- AddEventHandler('NPC-Health:Server:RefreshCurrentArmour', function(updateHealth, cid)
--     local src = source
--     MySQL.Async.execute("UPDATE __characters SET health = @health WHERE id = @id", { 
--         ['@id'] = cid,
--         ['@health'] = tonumber(updateHealth)
--     })
-- end)

RegisterServerEvent('NPC-Stress:Server:RefreshCurrentArmour')
AddEventHandler('NPC-Stress:Server:RefreshCurrentArmour', function(updateStress, cid)
    local src = source
    exports.ghmattimysql:execute("UPDATE __characters SET stress = @stress WHERE id = @id", { 
        ['@id'] = cid,
        ['@stress'] = tonumber(updateStress)
    })
end)

RegisterServerEvent('NPC-Food:Server:RefreshCurrentArmour')
AddEventHandler('NPC-Food:Server:RefreshCurrentArmour', function(updateFood, cid)
    local src = source
    exports.ghmattimysql:execute("UPDATE __characters SET food = @food WHERE id = @id", { 
        ['@id'] = cid,
        ['@food'] = tonumber(updateFood)
    })
end)

RegisterServerEvent('NPC-Thirst:Server:RefreshCurrentArmour')
AddEventHandler('NPC-Thirst:Server:RefreshCurrentArmour', function(updateThirst, cid)
    local src = source
    exports.ghmattimysql:execute("UPDATE __characters SET water = @water WHERE id = @id", { 
        ['@id'] = cid,
        ['@water'] = tonumber(updateThirst)
    })
end)