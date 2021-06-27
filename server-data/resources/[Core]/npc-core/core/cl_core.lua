NPC.Core.hasLoaded = false

function NPC.Core.Initialize(self)
    Citizen.CreateThread(function()
        while true do
            if NetworkIsSessionStarted() then
                TriggerEvent("npc-core:playerSessionStarted")
                TriggerServerEvent("npc-core:playerSessionStarted")
                break
            end
        end
    end)
end
NPC.Core:Initialize()

AddEventHandler("npc-core:playerSessionStarted", function()
    while not NPC.Core.hasLoaded do
        --print("Waiting in loop.")
        Wait(100)
    end
    ShutdownLoadingScreen()
    NPC.SpawnManager:Initialize()
end)

RegisterNetEvent("npc-core:waitForExports")
AddEventHandler("npc-core:waitForExports", function()
    if not NPC.Core.ExportsReady then return end

    while true do
        Citizen.Wait(0)
        if exports and exports["npc-core"] then
            TriggerEvent("npc-core:exportsReady")
            return
        end
    end
end)

RegisterNetEvent("customNotification")
AddEventHandler("customNotification", function(msg, length, type)

	TriggerEvent("chatMessage","SYSTEM",4,msg)
end)

RegisterNetEvent("base:disableLoading")
AddEventHandler("base:disableLoading", function()
    print("Player has spawned!")
    if not NPC.Core.hasLoaded then
         NPC.Core.hasLoaded = true
    end
end)

Citizen.CreateThread( function()
    TriggerEvent("base:disableLoading")
end)

RegisterNetEvent("paycheck:client:call")
AddEventHandler("paycheck:client:call", function()
    local cid = exports["isPed"]:isPed("cid")
    TriggerServerEvent("paycheck:server:send", cid)
end)