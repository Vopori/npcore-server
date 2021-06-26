  
posX = -0.01
posY = 0.00-- 0.0152

width = 0.200
height = 0.28 --0.354

-- width = 0.183
-- height = 0.32--0.354

Citizen.CreateThread(function()
	RequestStreamedTextureDict("circlemap", false)
	while not HasStreamedTextureDictLoaded("circlemap") do
		Wait(100)
	end

	AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

	SetMinimapClipType(1)
	SetMinimapComponentPosition('minimap', 'L', 'B', posX, posY, width, height)
	-- SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.0, 0.032, 0.101, 0.259)
	SetMinimapComponentPosition('minimap_mask', 'L', 'B', posX, posY, width, height)
	SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.01, 0.010, 0.256, 0.320)
    
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(false, false)
    Wait(100)
    SetRadarBigmapEnabled(false, false)
    Citizen.Wait(1000)
    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)

local UIRadar = false
local UIHidden = false

Citizen.CreateThread(
    function()
        while true do

            Citizen.Wait(500)
            
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped)
            local serverid = GetPlayerServerId(PlayerId())
            local pauseMenu = IsPauseMenuActive()

            if vehicle ~= 0 then
                SendNUIMessage(
                    {
                        action = "displayUI"
                    }
                )
                DisplayRadar(true)
            elseif vehicle == 0 then
                SendNUIMessage(
                    {
                        action = "hideUI"
                    }
                )
                DisplayRadar(false)
            end
        end
    end
)