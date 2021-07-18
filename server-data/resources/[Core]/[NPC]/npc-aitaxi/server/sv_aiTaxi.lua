-- Written with <3 by blurryrox.
RegisterServerEvent('aiTaxi:payCab')
AddEventHandler('aiTaxi:payCab', function(meters)
	local src = source
	local user = exports["npc-core"]:getModule("Player"):GetUser(src)
	local taxiPlayer = exports["npc-core"]:getModule("JobManager"):CountJob("taxi")
	local price = math.floor((meters/1000)*10)
	
	if taxiPlayer >= 1 then
		price = price + 200
	end	
	
	if user:getCash() >= tonumber(price) then
		user:removeMoney(price)
		TriggerClientEvent('aiTaxi:payment-status', src, true, price)
	else
		TriggerClientEvent('aiTaxi:payment-status', src, false)
	end
end)

RegisterServerEvent('aiTaxi:jobCountChecker')
AddEventHandler('aiTaxi:jobCountChecker', function()
	local src = source
	local user = exports["npc-core"]:getModule("Player"):GetUser(src)
	local jobCount = exports["npc-core"]:getModule("JobManager"):CountJob("taxi")
	
	TriggerClientEvent('aiTaxi:receivejobCount', src, jobCount)
end)