Citizen.CreateThread(function()
	RequestStreamedTextureDict("circlemap", false)
	while not HasStreamedTextureDictLoaded("circlemap") do
		Wait(0)
	end

    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")
    AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "circlemap", "radarmasksm")

	SetMinimapClipType(1)
    SetMinimapComponentPosition("minimap", "L", "B", -0.014, -0.030, 0.150, 0.221)
    SetMinimapComponentPosition("minimap_mask", "L", "B", -0.017, 0.021, 1.203, 0.305)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.01, 0.020, 0.25, 0.335)

    SetMinimapClipType(1)
    DisplayRadar(0)
    SetRadarBigmapEnabled(true, false)
    Citizen.Wait(0)
    SetRadarBigmapEnabled(false, false)
    DisplayRadar(1)
end)


Citizen.CreateThread(function()
    while true do
        --DontTiltMinimapThisFrame()
        HideMinimapInteriorMapThisFrame()
        SetRadarZoom(1000)
        Citizen.Wait(0)
    end
end)

local pauseActive = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        local player = PlayerPedId()
        SetRadarZoom(1000)
        SetRadarBigmapEnabled(false, false)
        local isPMA = IsPauseMenuActive()
        if isPMA and not pauseActive or IsRadarHidden() then 
            pauseActive = true 
            SendNUIMessage({
                action = "hideUI"
            })
            uiHidden = true
        elseif not isPMA and pauseActive then
            pauseActive = false
            SendNUIMessage({
                action = "displayUI"
            })
            uiHidden = false
        end
    Citizen.Wait(0)
    end
end)

RegisterNetEvent("dreams-scoreboard:playerscount")
AddEventHandler("dreams-scoreboard:playerscount", function(a)
    SetRichPresence(a .. "/90 | Eating Chicken")
    SetDiscordAppId(805180688944594984)
    SetDiscordRichPresenceAsset('dreams')
end)