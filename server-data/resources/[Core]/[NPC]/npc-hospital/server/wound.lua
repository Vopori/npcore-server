local playerInjury = {}

function GetCharsInjuries(source)
    return playerInjury[source]
end

RegisterServerEvent('npc-hospital:server:SyncInjuries')
AddEventHandler('npc-hospital:server:SyncInjuries', function(data)
    playerInjury[source] = data
end)