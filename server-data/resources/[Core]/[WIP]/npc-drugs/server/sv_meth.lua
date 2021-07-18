RegisterServerEvent('meth:givemoney')
AddEventHandler('meth:givemoney', function()
local src = source
local user = exports["npc-core"]:getModule("Player"):GetUser(src)
    user:addMoney(245)
end)