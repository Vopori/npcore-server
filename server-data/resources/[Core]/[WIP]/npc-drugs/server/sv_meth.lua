RegisterServerEvent('meth:givemoney')
AddEventHandler('meth:givemoney', function()
local src = source
local user = exports["npc-base"]:getModule("Player"):GetUser(src)
    user:addMoney(245)
end)