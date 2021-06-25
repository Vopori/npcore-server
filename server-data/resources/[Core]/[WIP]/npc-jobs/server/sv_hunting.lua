RegisterServerEvent('npc:huntingreturnree')
AddEventHandler('npc:huntingreturnree', function()
local src = source
local user = exports["npc-base"]:getModule("Player"):GetUser(src)
    user:addMoney(250)
end)

-- RegisterServerEvent('crowded')
-- AddEventHandler('crowded', function()
--     local src = source
--     local user = exports["npc-base"]:getModule("Player"):GetUser(src)
--     user:addMoney(1000)
-- end)

RegisterServerEvent('npc:huntingdeposit')
AddEventHandler('npc:huntingdeposit', function()
    local src = source
    local user = exports["npc-base"]:getModule("Player"):GetUser(src)
    if (tonumber(user:getCash()) >= 500) then
        user:removeMoney(500)
        TriggerClientEvent('hunting:start', src)
    else
        TriggerClientEvent("DoLongHudText", src, "You need $1000", 2)
    end
end)

RegisterServerEvent('npc-hunting:sell')
AddEventHandler('npc-hunting:sell', function()
local src = source
local user = exports["npc-base"]:getModule("Player"):GetUser(src)
local randompayout = math.random(60, 85)
    user:addMoney(randompayout)
end)

RegisterServerEvent('npc-hunting:giveloadout')
AddEventHandler('npc-hunting:giveloadout', function()
    TriggerClientEvent('player:receiveItem', source, '100416529', 1)
end)

RegisterServerEvent('npc-hunting:removeloadout')
AddEventHandler('npc-hunting:removeloadout', function()
    TriggerClientEvent('inventory:removeItem', source, '100416529', 1)
end)


RegisterServerEvent("npc-hunting:retreive:license")
AddEventHandler("npc-hunting:retreive:license", function()
    local src = source
	local user = exports["npc-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
    exports.ghmattimysql:execute('SELECT * FROM user_licenses WHERE `owner`= ? AND `type` = ? AND `status` = ?', {character.id, "Hunting", "1"}, function(data)
		if data[1] then
            TriggerClientEvent("npc-hunting:allowed", src, true)
        end
    end)
end)