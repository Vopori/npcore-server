-- posX = -0.01
-- posY = 0.00-- 0.0152

-- width = 0.200
-- height = 0.28 --0.354

-- Citizen.CreateThread(function()
-- 	RequestStreamedTextureDict("circlemap", false)
-- 	while not HasStreamedTextureDictLoaded("circlemap") do
-- 		Wait(100)
-- 	end

-- 	AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

-- 	SetMinimapClipType(1)
-- 	SetMinimapComponentPosition('minimap', 'L', 'B', posX, posY, width, height)
-- 	-- SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.0, 0.032, 0.101, 0.259)
-- 	SetMinimapComponentPosition('minimap_mask', 'L', 'B', posX, posY, width, height)
-- 	SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.01, 0.024, 0.256, 0.337)

--     local minimap = RequestScaleformMovie("minimap")
--     SetRadarBigmapEnabled(true, false)
--     Wait(0)
--     SetRadarBigmapEnabled(false, false)

--     while true do
--         Wait(0)
--         BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
--         ScaleformMovieMethodAddParamInt(3)
--         EndScaleformMovieMethod()
--     end
-- end)

-- local isPause = false
-- local uiHidden = false

-- Citizen.CreateThread(function()
--     while true do
--         Wait(0)
--         if IsBigmapActive() or IsPauseMenuActive() and not isPause or IsRadarHidden() then
--             if not uiHidden then
--                 SendNUIMessage({
--                     action = "hideUI"
--                 })
--                 uiHidden = true
--             end
--         elseif uiHidden or IsPauseMenuActive() and isPause then
--             SendNUIMessage({
--                 action = "displayUI"
--             })
--             uiHidden = false
--         end
--     end
-- end)


-- -- local uiHidden = false

-- -- Citizen.CreateThread(function()
-- -- 	while true do
-- -- 		Wait(0)
-- -- 		if IsBigmapActive() or IsRadarHidden() then
-- -- 			if not uiHidden then
-- -- 				SendNUIMessage({
-- -- 					action = "hideUI"
-- -- 				})
-- -- 				uiHidden = true
-- -- 			end
-- -- 		elseif uiHidden then
-- -- 			SendNUIMessage({
-- -- 				action = "displayUI"
-- -- 			})
-- -- 			uiHidden = false
-- -- 		end
-- -- 	end
-- -- end)

local UIHidden = false
local UIRadar = false

--Cricle Radar
Citizen.CreateThread(
    function()
        RequestStreamedTextureDict("circlemap", false)
        while not HasStreamedTextureDictLoaded("circlemap") do
            Wait(100)
        end

        AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

        SetMinimapClipType(1)
        SetMinimapComponentPosition("minimap", "L", "B", 0.025, -0.03, 0.153, 0.24)
        SetMinimapComponentPosition("minimap_mask", "L", "B", 0.135, 0.12, 0.093, 0.164)
        SetMinimapComponentPosition("minimap_blur", "L", "B", 0.012, 0.022, 0.256, 0.337)

        local minimap = RequestScaleformMovie("minimap")

        SetRadarBigmapEnabled(true, false)
        Citizen.Wait(100)
        SetRadarBigmapEnabled(false, false)
        Citizen.Wait(1000)

        while true do
            Wait(0)
            BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
            ScaleformMovieMethodAddParamInt(3)
            EndScaleformMovieMethod()
        end
    end
)


Citizen.CreateThread(
    function()
        while true do

            Citizen.Wait(500)
            
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped)
            local serverid = GetPlayerServerId(PlayerId())
            local pauseMenu = IsPauseMenuActive()
           if pauseMenu and not UIHidden then
                 SendNUIMessage(
                        {
                            type = "hideUI"
                        }
                    )
                 UIHidden = true
            elseif UIHidden and not pauseMenu then
                 SendNUIMessage(
                        {
                            type = "showUI"
                        }
                    )
                UIHidden = false
            end
            if vehicle ~= 0 and UIRadar then
                SendNUIMessage(
                    {
                        type = "openMapUI"
                    }
                )
                DisplayRadar(true)
                UIRadar = false
            elseif not UIRadar and vehicle == 0 then
                SendNUIMessage(
                    {
                        type = "closeMapUI"
                    }
                )
                UIRadar = true
                DisplayRadar(false)
            end
        end
    end
)