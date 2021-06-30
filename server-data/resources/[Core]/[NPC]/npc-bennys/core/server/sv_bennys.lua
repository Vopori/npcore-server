local hmm = vehicleBaseRepairCost

RegisterServerEvent('npc-bennys:attemptPurchase')
AddEventHandler('npc-bennys:attemptPurchase', function(cheap, type, upgradeLevel)
	local src = source
	local user = exports["npc-core"]:getModule("Player"):GetUser(src)
    if type == "repair" then
        if user:getCash() >= hmm then
            user:removeMoney(hmm)
            TriggerClientEvent('npc-bennys:purchaseSuccessful', source)
        else
            TriggerClientEvent('npc-bennys:purchaseFailed', source)
        end
    elseif type == "performance" then
        if user:getCash() >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('npc-bennys:purchaseSuccessful', source)
            user:removeMoney(vehicleCustomisationPrices[type].prices[upgradeLevel])
        else
            TriggerClientEvent('npc-bennys:purchaseFailed', source)
        end
    else
        if user:getCash() >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('npc-bennys:purchaseSuccessful', source)
            user:removeMoney(vehicleCustomisationPrices[type].price)
        else
            TriggerClientEvent('npc-bennys:purchaseFailed', source)
        end
    end
end)

RegisterServerEvent('npc-bennys:updateRepairCost')
AddEventHandler('npc-bennys:updateRepairCost', function(cost)
    hmm = cost
end)

RegisterServerEvent('npc-bennys:repairciv')
AddEventHandler('npc-bennys:repairciv', function()
    local src = source
    local user = exports["npc-core"]:getModule("Player"):GetUser(src)
    user:removeMoney(450)
end)