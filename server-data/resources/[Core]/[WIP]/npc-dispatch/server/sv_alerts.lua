RegisterServerEvent("npc-alerts:teenA")
AddEventHandler("npc-alerts:teenA",function(targetCoords)
    TriggerClientEvent('npc-alerts:policealertA', -1, targetCoords)
	return
end)

RegisterServerEvent("npc-alerts:teenB")
AddEventHandler("npc-alerts:teenB",function(targetCoords)
    TriggerClientEvent('npc-alerts:policealertB', -1, targetCoords)
	return
end)

RegisterServerEvent("npc-alerts:teenpanic")
AddEventHandler("npc-alerts:teenpanic",function(targetCoords)
    TriggerClientEvent('npc-alerts:panic', -1, targetCoords)
	return
end)

RegisterServerEvent("npc-alerts:fourA")
AddEventHandler("npc-alerts:fourA",function(targetCoords)
    TriggerClientEvent('npc-alerts:tenForteenA', -1, targetCoords)
	return
end)

RegisterServerEvent("npc-alerts:fourB")
AddEventHandler("npc-alerts:fourB",function(targetCoords)
    TriggerClientEvent('npc-alerts:tenForteenB', -1, targetCoords)
	return
end)

RegisterServerEvent("npc-alerts:downperson")
AddEventHandler("npc-alerts:downperson",function(targetCoords)
    TriggerClientEvent('npc-alerts:downalert', -1, targetCoords)
	return
end)

RegisterServerEvent("npc-alerts:shoot")
AddEventHandler("npc-alerts:shoot",function(targetCoords)
    TriggerClientEvent('npc-outlawalert:gunshotInProgress', -1, targetCoords)
	return
end)

RegisterServerEvent("npc-alerts:storerob")
AddEventHandler("npc-alerts:storerob",function(targetCoords)
    TriggerClientEvent('npc-alerts:storerobbery', -1, targetCoords)
	return
end)

RegisterServerEvent("npc-alerts:crypto")
AddEventHandler("npc-alerts:crypto",function(targetCoords)
    TriggerClientEvent('npc-alerts:cryptohack', -1, targetCoords)
	return
end)

RegisterServerEvent("npc-alerts:houserob")
AddEventHandler("npc-alerts:houserob",function(targetCoords)
    TriggerClientEvent('npc-alerts:houserobbery', -1, targetCoords)
	return
end)

RegisterServerEvent("npc-alerts:tbank")
AddEventHandler("npc-alerts:tbank",function(targetCoords)
    TriggerClientEvent('npc-alerts:banktruck', -1, targetCoords)
	return
end)

RegisterServerEvent("npc-alerts:robjew")
AddEventHandler("npc-alerts:robjew",function()
    TriggerClientEvent('npc-alerts:jewelrobbey', -1)
	return
end)

RegisterServerEvent("npc-alerts:AlertUnion:sv")
AddEventHandler("npc-alerts:AlertUnion:sv",function()
    TriggerClientEvent('npc-alerts:AlertUnion:cl', -1)
	return
end)

RegisterServerEvent("npc-alerts:AlertUnion:svC4")
AddEventHandler("npc-alerts:AlertUnion:svC4",function()
    TriggerClientEvent('npc-alerts:AlertUnion:clC4', -1)
	return
end)

RegisterServerEvent("npc-alerts:AlertPacific:sv")
AddEventHandler("npc-alerts:AlertPacific:sv",function()
    TriggerClientEvent('npc-alerts:AlertPacific:cl', -1)
	return
end)

RegisterServerEvent("npc-alerts:methexplosion:sv")
AddEventHandler("npc-alerts:methexplosion:sv",function()
    TriggerClientEvent('npc-alerts:methexplosion:cl', -1, targetCoords)
	return
end)


