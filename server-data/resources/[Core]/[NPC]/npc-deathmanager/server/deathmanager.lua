RegisterServerEvent('admin:revivePlayer')
AddEventHandler('admin:revivePlayer', function(target)
    if target ~= nil then
        TriggerClientEvent('admin:revivePlayerClient', target)
        TriggerClientEvent('npc-hospital:client:RemoveBleed', target) 
        TriggerClientEvent('npc-hospital:client:ResetLimbs', target)
    end
end)