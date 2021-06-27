RegisterServerEvent("npc-base:sv:player_settings_set")
AddEventHandler("npc-core:sv:player_settings_set", function(settingsTable)
    local src = source
    NPC.DB:UpdateSettings(src, settingsTable, function(UpdateSettings, err)
            if UpdateSettings then
                -- We are good here.
            end
    end)
end)

RegisterServerEvent("npc-core:sv:player_settings")
AddEventHandler("npc-core:sv:player_settings", function()
    local src = source
    NPC.DB:GetSettings(src, function(loadedSettings, err)
        if loadedSettings ~= nil then 
            TriggerClientEvent("npc-core:cl:player_settings", src, loadedSettings) 
        else 
            TriggerClientEvent("npc-core:cl:player_settings",src, nil) 
        end
    end)
end)
