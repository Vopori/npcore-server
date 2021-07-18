local DISCORD_WEBHOOK5 = "https://discordapp.com/api/webhooks/832766075221180426/CWZo5u0Dmf9rCjl61e_XacVglHH8MAHVDiAwUjdXWNqNxxnjJs4cqzJOYsmr2tUgL9OM"
local DISCORD_NAME5 = "Fish Selling Logs"

local STEAM_KEY = "0C007CC382AB06D1D99D9B45EC3924B1"
local DISCORD_IMAGE = "https://i.imgur.com/zviw6oW.png" -- Default is FiveM logo.

PerformHttpRequest(DISCORD_WEBHOOK5, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME5, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })

local cachedData = {}

RegisterServerEvent('npc-fish:process')
AddEventHandler('npc-fish:process', function()
 local source = tonumber(source)
 TriggerClientEvent("player:receiveItem", source, "sushiroll", 2)
end)

RegisterServerEvent('npc-fish:processcod')
AddEventHandler('npc-fish:processcod', function()
 local source = tonumber(source)
 TriggerClientEvent("player:receiveItem", source, "sushicod", 2)
end)

RegisterServerEvent('npc-fish:processperch')
AddEventHandler('npc-fish:processperch', function()
 local source = tonumber(source)
 TriggerClientEvent("player:receiveItem", source, "perchsushi", 2)
end)

RegisterServerEvent('npc-fish:cut')
AddEventHandler('npc-fish:cut', function()
 local source = tonumber(source)
 TriggerClientEvent("player:receiveItem", source, "cutfish", 2)
end)

RegisterServerEvent('npc-fish:cutcod')
AddEventHandler('npc-fish:cutcod', function()
 local source = tonumber(source)
 TriggerClientEvent("player:receiveItem", source, "cutcod", 2)
end)

RegisterServerEvent('npc-fish:cutperch')
AddEventHandler('npc-fish:cutperch', function()
 local source = tonumber(source)
 TriggerClientEvent("player:receiveItem", source, "cutperch", 2)
end)

RegisterServerEvent('npc-fish:sellSushi')
AddEventHandler('npc-fish:sellSushi', function(money)
    local source = source
    local player = GetPlayerName(source)
    local user = exports["npc-core"]:getModule("Player"):GetUser(source)
    if money ~= nil then
        user:addMoney(money)
        if money > 51 then
        sendToDiscord5("Fish Selling Logs", "Player ID: ".. source ..", Steam: ".. player ..",  Just Received $".. money .." From Selling Fish.")
    end
end
end)

RegisterServerEvent("npc-fish:retreive:license")
AddEventHandler("npc-fish:retreive:license", function()
    local src = source
	local user = exports["npc-core"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
    exports.ghmattimysql:execute('SELECT * FROM user_licenses WHERE `owner`= ? AND `type` = ? AND `status` = ?', {character.id, "Fishing", "1"}, function(data)
		if data[1] then
            TriggerClientEvent("npc-fish:allowed", src, true)
        end
    end)
end)

function sendToDiscord5(name, message, color)
    local connect = {
      {
        ["color"] = color,
        ["title"] = "**".. name .."**",
        ["description"] = message,
      }
    }
    PerformHttpRequest(DISCORD_WEBHOOK5, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME5, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
  end