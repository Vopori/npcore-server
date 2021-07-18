RegisterServerEvent("npc-core:sv:player_control_set")
AddEventHandler("npc-core:sv:player_control_set", function(controlsTable)
    local src = source
    NPC.DB:UpdateControls(src, controlsTable, function(UpdateControls, err)
            if UpdateControls then
                -- We are good here.
            end
    end)
end)

RegisterServerEvent("npc-core:sv:player_controls")
AddEventHandler("npc-core:sv:player_controls", function()
    local src = source
    NPC.DB:GetControls(src, function(loadedControls, err)
        if loadedControls ~= nil then 
            TriggerClientEvent("npc-core:cl:player_control", src, loadedControls) 
        else 
            TriggerClientEvent("npc-core:cl:player_control",src, nil)
        end
    end)
end)
