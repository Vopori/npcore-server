NPC.SpawnManager = {}

function NPC.SpawnManager.Initialize(self)
    Citizen.CreateThread(function()

        FreezeEntityPosition(PlayerPedId(), true)

        TransitionToBlurred(500)
        DoScreenFadeOut(500)

        local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)

        SetCamRot(cam, 0.0, 0.0, -45.0, 2)
        SetCamCoord(cam, -682.0, -1092.0, 226.0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)

        local ped = PlayerPedId()

        SetEntityCoordsNoOffset(ped, -682.0, -1092.0, 200.0, false, false, false, true)

        SetEntityVisible(ped, false)

        DoScreenFadeIn(10000)

        while IsScreenFadingIn() do
            Citizen.Wait(0)
        end

        Citizen.Wait(10000)

        TriggerEvent("npc-core:spawnInitialized")
        TriggerServerEvent("npc-core:spawnInitialized")

    end)
end

function NPC.SpawnManager.InitialSpawn(self)
    Citizen.CreateThread(function()
        DisableAllControlActions(0)
      
        DoScreenFadeOut(10)

        while IsScreenFadingOut() do
            Citizen.Wait(0)
        end

        local character = NPC.LocalPlayer:getCurrentCharacter()


        --Tells raid clothes to set ped to correct skin
        TriggerEvent("npc-core:initialSpawnModelLoaded")

        local ped = PlayerPedId()

        SetEntityVisible(ped, true)
        FreezeEntityPosition(PlayerPedId(), false)
        
        ClearPedTasksImmediately(ped)
        RemoveAllPedWeapons(ped)
        --ClearPlayerWantedLevel(PlayerId())

        EnableAllControlActions(0)

        TriggerEvent("character:finishedLoadingChar")
    end)
end

AddEventHandler("npc-core:firstSpawn", function()
    NPC.SpawnManager:InitialSpawn()
end)

RegisterNetEvent('npc-core:clearStates')
AddEventHandler('npc-core:clearStates', function()
    TriggerServerEvent("reset:blips")
    TriggerEvent("nowEMSDeathOff")
    TriggerEvent("nowCopDeathOff")
    TriggerEvent("stopSpeedo")
    TriggerEvent("wk:disableRadar")
    exports['srp-voice']:removePlayerFromRadio()
    exports["srp-voice"]:setVoiceProperty("radioEnabled", false)
end)
