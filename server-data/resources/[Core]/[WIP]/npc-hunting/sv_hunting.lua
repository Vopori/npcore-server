local huntingItems = {
    [1] = {chance = 4, id = 'huntingcarcass1', quantity = 1}, -- really common
    [2] = {chance = 5, id = 'huntingcarcass2', quantity = 1}, -- rare
    [3] = {chance = 10, id = 'huntingcarcass3', quantity = 1}, -- rare
    [4] = {chance = 1, id = 'huntingpelt1', quantity = 1 }, -- tier 1 hunting pelt
    [5] = {chance = 2, id = 'huntingpelt2', quantity = 1 }, -- tier 2 hunting pelt
    [6] = {chance = 3, id = 'huntingpelt3', quantity = 1 }, -- tier 3 hunting pelt
}

RegisterServerEvent('npc-hunting:hasLicense')
AddEventHandler('npc-hunting:hasLicense', function(cid)
    local src = source
    exports.ghmattimysql:execute('SELECT `huntlicense` FROM __characters WHERE id = ?', {cid}, function(result)
        TriggerClientEvent('npc-hunting:hasLicense', src, result[1].huntlicense)
    end)
end)

RegisterServerEvent('npc-hunting:obtainLicense')
AddEventHandler('npc-hunting:obtainLicense', function(cid)
    print(cid)
    exports.ghmattimysql:execute("UPDATE __characters SET `huntlicense` = @huntlicense WHERE `id` = @id", {
        ['@huntlicense'] = 1,
        ['@id'] = cid
      })
    TriggerClientEvent('npc-hunting:obtainLicense', source)
end)

RegisterNetEvent('npc-GiveLoadOutForHunting')
AddEventHandler('npc-GiveLoadOutForHunting', function()
	TriggerClientEvent('npc-banned:getID', source, '100416529', 1)
end)

RegisterServerEvent('npc-hunting:getReward')
AddEventHandler('npc-hunting:getReward', function(entity, model)
    entity = tonumber(entity)
    print(entity)
    if entiy == -541762431 then
        TriggerClientEvent('npc-banned:getID', source, 'rpelt', math.random(1,2))
        local mole = math.random(1,3)
        if mole == 3 then
            TriggerClientEvent('npc-banned:getID', source, 'huntingpelt1', math.random(1,2))
        end
    end
    if entity == 307287994 then
        TriggerClientEvent('npc-banned:getID', source, 'cpelt', math.random(1,2))
        local mole = math.random(1,3)
        local mole2 = math.random(1,8)
        if mole2 == 6 then
            TriggerClientEvent('npc-banned:getID', source, 'huntingcarcass4', 1)
        end
        if mole == 2 then
            TriggerClientEvent('npc-banned:getID', source, 'ctooth', math.random(1,3))
        end
    else
    item = huntingItems[math.random(1, #huntingItems)]
    TriggerClientEvent('npc-banned:getID', source, item.id, item.quantity)
    end
end)

RegisterServerEvent('npc-hunting:sellItem')
AddEventHandler('npc-hunting:sellItem', function(item, quantity)
    -- Couger Pelt --
    if item == 'cpelt' and quantity > 0 then
        local price = math.random(85, 100) * quantity
        TriggerClientEvent('npc-hunting:sellItems', source, price)
        TriggerClientEvent('inventory:removeItem', source, item, quantity)
    -- Couger Tooth --
    elseif item == 'ctooth' and quantity > 0 then
        local price = math.random(75, 85) * quantity
        TriggerClientEvent('npc-hunting:sellItems', source, price)
        TriggerClientEvent('inventory:removeItem', source, item, quantity)
    -- Hunting Carcass Tier 1 --
    elseif item == 'huntingcarcass1' and quantity > 0 then
        local price = math.random(300, 400) * quantity
        TriggerClientEvent('npc-hunting:sellItems', source, price)
        TriggerClientEvent('inventory:removeItem', source, item, quantity)
    -- Hunting Carcass Tier 2 --
    elseif item == 'huntingcarcass2' and quantity > 0 then
        local price = math.random(500, 600) * quantity
        TriggerClientEvent('npc-hunting:sellItems', source, price)
        TriggerClientEvent('inventory:removeItem', source, item, quantity)
    -- Hunting Carcass Tier 3 --
    elseif item == 'huntingcarcass3' and quantity > 0 then
        local price = math.random(700, 800) * quantity
        TriggerClientEvent('npc-hunting:sellItems', source, price)
        TriggerClientEvent('inventory:removeItem', source, item, quantity)
    -- Hunting Carcass Tier 4 --
    elseif item == 'huntingcarcass4' and quantity > 0 then
        local price = math.random(900,1000) * quantity
        TriggerClientEvent('npc-hunting:sellItems', source, price)
        TriggerClientEvent('inventory:removeItem', source, item, quantity)
    -- Hunting Sniper Rifle --
    elseif item == '100416529' and quantity > 0 then
        local price = math.random(50,100) * quantity
        TriggerClientEvent('npc-hunting:sellItems', source, price)
        TriggerClientEvent('inventory:removeItem', source, item, quantity)
    -- Rabbit Pelt --
    elseif item == 'rpelt' and quantity > 0 then
        local price = math.random(50,150) * quantity
        TriggerClientEvent('npc-hunting:sellItems', source, price)
        TriggerClientEvent('inventory:removeItem', source, item, quantity)
    -- Hunting Pelt Tier 1 --
    elseif item == 'huntingpelt1' and quantity > 0 then
        local price = math.random(100,150) * quantity
        TriggerClientEvent('npc-hunting:sellItems', source, price)
        TriggerClientEvent('inventory:removeItem', source, item, quantity)
    -- Hunting Pelt Tier 2 --
    elseif item == 'huntingpelt2' and quantity > 0 then
        local price = math.random(150, 200) * quantity
        TriggerClientEvent('npc-hunting:sellItems', source, price)
        TriggerClientEvent('inventory:removeItem', source, item, quantity)
    -- Hunting Pelt Tier 3 --
    elseif item == 'huntingpelt3' and quantity > 0 then
        local price = math.random(200, 250) * quantity
        TriggerClientEvent('npc-hunting:sellItems', source, price)
        TriggerClientEvent('inventory:removeItem', source, item, quantity)
    end
end)

RegisterServerEvent('checkhunting')
AddEventHandler('checkhunting', function(cid)
    print(cid)
    local src = source
    exports.ghmattimysql:execute('SELECT `huntlicense` FROM __characters WHERE `id`= ?', {cid}, function(result)
        print(result[1].huntlicense)
        if result[1].huntlicense ~= nil then
            local license = result[1].huntlicense
            TriggerClientEvent('npc-hunting:license:check', src, license, cid)
        end
    end)
end)


RegisterServerEvent('npc-hunting:giveloadout')
AddEventHandler('npc-hunting:giveloadout', function()
    TriggerClientEvent('npc-banned:getID', source, '100416529', 1)
end)

RegisterServerEvent('npc-hunting:buyAmmo')
AddEventHandler('npc-hunting:buyAmmo', function()
    TriggerClientEvent('npc-banned:getID', source, '100416529', 1)
end)

RegisterServerEvent('npc-hunting:removeloadout')
AddEventHandler('npc-hunting:removeloadout', function()
    TriggerClientEvent('inventory:removeItem', source, '100416529', 1)
end)

--