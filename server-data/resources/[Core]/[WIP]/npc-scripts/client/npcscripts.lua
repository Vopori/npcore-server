-- Debug
local resource = GetCurrentResourceName()

function error(...)
    print(string.format("------------------ ERROR IN RESOURCE: %s\n%s\n------------------ END OF ERROR", resource, ...))
    TriggerServerEvent("MG:LogClientError", resource, ...)
end

-- Calm AI
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_HILLBILLY"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_BALLAS"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MEXICAN"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_FAMILY"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MARABUNTE"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_SALVA"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_1"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_2"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_9"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_10"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("FIREMAN"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("MEDIC"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("COP"), GetHashKey('PLAYER'))

-- World Blips Script
paycheck = 0
paycheckwithout = 0

Citizen.CreateThread(function()
    while not HasStreamedTextureDictLoaded("world_blips") do
    RequestStreamedTextureDict("world_blips", 1)
        Wait(0)
        RequestStreamedTextureDict("world_blips", 1)
    end
end)

RegisterNetEvent('obtainPaycheckForBlip')
AddEventHandler('obtainPaycheckForBlip', function(pay, paywi)
    local src = source
    paycheck = pay
    paycheckwithout = paywi

    RemoveBlip(blip)
    TriggerEvent('Igotitbaby')
end)

RegisterCommand('start', function() TriggerEvent('Igotitbaby') end)

RegisterNetEvent('Igotitbaby')
AddEventHandler('Igotitbaby', function()
        -- Load the textures
    -- Add the Observatory blip
    blip = AddBlipForCoord(-1082.522, -248.3022, 37.7633)
    SetBlipSprite(blip, 351)
    SetBlipColour(blip, 17)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Payments & Internet Center')
    EndTextCommandSetBlipName(blip)
    exports['blip_info']:SetBlipInfoTitle(blip, "Payments and Internet Center", false)
    -- exports['blip_info']:SetBlipInfoImage(blip, "world_blips", "observatory")
    exports['blip_info']:AddBlipInfoText(blip, "Tax", "15%")
    exports['blip_info']:AddBlipInfoName(blip, "Taxed By", "Government")
    exports['blip_info']:AddBlipInfoText(blip, "Paycheck With Tax", "$" .. paycheck)
    exports['blip_info']:AddBlipInfoText(blip, "Location", "Life Invader")
    exports['blip_info']:AddBlipInfoHeader(blip, "") -- Empty header adds the header line
    exports['blip_info']:AddBlipInfoText(blip, "Collect your Paychecks here and go on the internet!")
    -- Add all the cool info to the blip

end)

RegisterNetEvent('urp-obtainAmountP')
AddEventHandler('urp-obtainAmountP', function()
    while true do
        Citizen.Wait(60000)
        TriggerServerEvent("payslip:getamount", exports['isPed']:isPed('cid'))
    end
end)

-- Blip Information System
local BLIP_INFO_DATA = {}

--[[
    Default state for blip info
]]

function ensureBlipInfo(blip)
    if blip == nil then blip = 0 end
    SetBlipAsMissionCreatorBlip(blip, true)
    if not BLIP_INFO_DATA[blip] then BLIP_INFO_DATA[blip] = {} end
    if not BLIP_INFO_DATA[blip].title then BLIP_INFO_DATA[blip].title = "" end
    if not BLIP_INFO_DATA[blip].rockstarVerified then BLIP_INFO_DATA[blip].rockstarVerified = false end
    if not BLIP_INFO_DATA[blip].info then BLIP_INFO_DATA[blip].info = {} end
    if not BLIP_INFO_DATA[blip].money then BLIP_INFO_DATA[blip].money = "" end
    if not BLIP_INFO_DATA[blip].rp then BLIP_INFO_DATA[blip].rp = "" end
    if not BLIP_INFO_DATA[blip].dict then BLIP_INFO_DATA[blip].dict = "" end
    if not BLIP_INFO_DATA[blip].tex then BLIP_INFO_DATA[blip].tex = "" end
    return BLIP_INFO_DATA[blip]
end

--[[
    Export functions, use these via an export pls
]]

function ResetBlipInfo(blip)
    BLIP_INFO_DATA[blip] = nil
end

function SetBlipInfoTitle(blip, title, rockstarVerified)
    local data = ensureBlipInfo(blip)
    data.title = title or ""
    data.rockstarVerified = rockstarVerified or false
end

function SetBlipInfoImage(blip, dict, tex)
    local data = ensureBlipInfo(blip)
    data.dict = dict or ""
    data.tex = tex or ""
end

function SetBlipInfoEconomy(blip, rp, money)
    local data = ensureBlipInfo(blip)
    data.money = tostring(money) or ""
    data.rp = tostring(rp) or ""
end

function SetBlipInfo(blip, info)
    local data = ensureBlipInfo(blip)
    data.info = info
end

function AddBlipInfoText(blip, leftText, rightText)
    local data = ensureBlipInfo(blip)
    if rightText then
        table.insert(data.info, {1, leftText or "", rightText or ""})
    else
        table.insert(data.info, {5, leftText or "", ""})
    end
end

function AddBlipInfoName(blip, leftText, rightText)
    local data = ensureBlipInfo(blip)
    table.insert(data.info, {3, leftText or "", rightText or ""})
end

function AddBlipInfoHeader(blip, leftText, rightText)
    local data = ensureBlipInfo(blip)
    table.insert(data.info, {4, leftText or "", rightText or ""})
end

function AddBlipInfoIcon(blip, leftText, rightText, iconId, iconColor, checked)
    local data = ensureBlipInfo(blip)
    table.insert(data.info, {2, leftText or "", rightText or "", iconId or 0, iconColor or 0, checked or false})
end

--[[
    All that fancy decompiled stuff I've kinda figured out
]]

local Display = 1
function UpdateDisplay()
    if PushScaleformMovieFunctionN("DISPLAY_DATA_SLOT") then
        PushScaleformMovieFunctionParameterInt(Display)
        PopScaleformMovieFunctionVoid()
    end
end

function SetColumnState(column, state)
    if PushScaleformMovieFunctionN("SHOW_COLUMN") then
        PushScaleformMovieFunctionParameterInt(column)
        PushScaleformMovieFunctionParameterBool(state)
        PopScaleformMovieFunctionVoid()
    end
end

function ShowDisplay(show)
    SetColumnState(Display, show)
end

function func_36(fParam0)
    BeginTextCommandScaleformString(fParam0)
    EndTextCommandScaleformString()
end

function SetIcon(index, title, text, icon, iconColor, completed)
    if PushScaleformMovieFunctionN("SET_DATA_SLOT") then
        PushScaleformMovieFunctionParameterInt(Display)
        PushScaleformMovieFunctionParameterInt(index)
        PushScaleformMovieFunctionParameterInt(65)
        PushScaleformMovieFunctionParameterInt(3)
        PushScaleformMovieFunctionParameterInt(2)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(1)
        func_36(title)
        func_36(text)
        PushScaleformMovieFunctionParameterInt(icon)
        PushScaleformMovieFunctionParameterInt(iconColor)
        PushScaleformMovieFunctionParameterBool(completed)
        PopScaleformMovieFunctionVoid()
    end
end

function SetText(index, title, text, textType)
    if PushScaleformMovieFunctionN("SET_DATA_SLOT") then
        PushScaleformMovieFunctionParameterInt(Display)
        PushScaleformMovieFunctionParameterInt(index)
        PushScaleformMovieFunctionParameterInt(65)
        PushScaleformMovieFunctionParameterInt(3)
        PushScaleformMovieFunctionParameterInt(textType or 0)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(0)
        func_36(title)
        func_36(text)
        PopScaleformMovieFunctionVoid()
    end
end

local _labels = 0
local _entries = 0
function ClearDisplay()
    if PushScaleformMovieFunctionN("SET_DATA_SLOT_EMPTY") then
        PushScaleformMovieFunctionParameterInt(Display)
    end
    PopScaleformMovieFunctionVoid()
    _labels = 0
    _entries = 0
end

function _label(text)
    local lbl = "LBL" .. _labels
    AddTextEntry(lbl, text)
    _labels = _labels + 1
    return lbl
end

function SetTitle(title, rockstarVerified, rp, money, dict, tex)
    if PushScaleformMovieFunctionN("SET_COLUMN_TITLE") then
        PushScaleformMovieFunctionParameterInt(Display)
        func_36("")
        func_36(_label(title))
        PushScaleformMovieFunctionParameterInt(rockstarVerified)
        PushScaleformMovieFunctionParameterString(dict)
        PushScaleformMovieFunctionParameterString(tex)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(0)
        if rp == "" then
            PushScaleformMovieFunctionParameterBool(0)
        else
            func_36(_label(rp))
        end
        if money == "" then
            PushScaleformMovieFunctionParameterBool(0)
        else
            func_36(_label(money))
        end
    end
    PopScaleformMovieFunctionVoid()
end

function AddText(title, desc, style)
    SetText(_entries, _label(title), _label(desc), style or 1)
    _entries = _entries + 1
end

function AddIcon(title, desc, icon, color, checked)
    SetIcon(_entries, _label(title), _label(desc), icon, color, checked)
    _entries = _entries + 1
end

Citizen.CreateThread(function()
    local current_blip = nil
    while true do
        Wait(0)
        if N_0x3bab9a4e4f2ff5c7() then
            local blip = DisableBlipNameForVar()
            if N_0x4167efe0527d706e() then
                if DoesBlipExist(blip) then
                    if current_blip ~= blip then
                        current_blip = blip
                        if BLIP_INFO_DATA[blip] then
                            local data = ensureBlipInfo(blip)
                            N_0xec9264727eec0f28()
                            ClearDisplay()
                            SetTitle(data.title, data.rockstarVerified, data.rp, data.money, data.dict, data.tex)
                            for _, info in next, data.info do
                                if info[1] == 2 then
                                    AddIcon(info[2], info[3], info[4], info[5], info[6])
                                else
                                    AddText(info[2], info[3], info[1])
                                end
                            end
                            ShowDisplay(true)
                            UpdateDisplay()
                            N_0x14621bb1df14e2b2()
                        else
                            ShowDisplay(false)
                        end
                    end
                end
            else
                if current_blip then
                    current_blip = nil
                    ShowDisplay(false)
                end
            end
        end
    end
end)

-- Interactive NPCS
markets = {
    -- Markets
    {372.98,328.13,103.57,245.0,"mp_m_shopkeep_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {2676.57,3280.19,55.24,328.08,"mp_m_shopkeep_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {1959.1,3741.48,32.34,296.51,"mp_m_shopkeep_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {1392.33,3606.27,34.98,197.18,"mp_m_shopkeep_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {1697.1,4923.52,42.06,327.59,"mp_m_shopkeep_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {1728.39,6416.75,35.04,238.52,"mp_m_shopkeep_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {1165.41,2710.95,38.15,178.92,"mp_m_shopkeep_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {549.33,2669.77,42.15,111.27,"mp_m_shopkeep_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {-3243.93,1000.02,12.83,352.04,"mp_m_shopkeep_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {-3040.49,583.88,7.91,17.94,"mp_m_shopkeep_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {-2966.18,391.49,15.04,82.43,"mp_m_shopkeep_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {-1819.45,793.68,138.08,132.59,"mp_m_shopkeep_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {-1486.59,-377.41,40.16,125.62,"mp_m_shopkeep_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {-1221.37,-907.95,12.33,30.08,"mp_m_shopkeep_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {-706.04,-914.4,19.22,90.99,"mp_m_shopkeep_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {24.38,-1345.72,29.5,271.7,"mp_m_shopkeep_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {-47.24,-1758.68,29.42,54.73,"mp_m_shopkeep_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {1134.22,-983.14,46.42,279.1,"mp_m_shopkeep_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {1164,-323.63,691.21,92.28,"mp_m_shopkeep_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {2555,380.83,108.62,4.25,"mp_m_shopkeep_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    -- Ammunations
	{24.04,-1105.84,29.8,7.62,"s_m_y_ammucity_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {810.39,-2159.13,29.62,7.62,"s_m_y_ammucity_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {23.15,-1105.72,29.8,153.24,"s_m_y_ammucity_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {842.19,-1035.34,28.19,356.79,"s_m_y_ammucity_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {-661.81,-933.35,21.83,192.2,"s_m_y_ammucity_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {-1304.06,-394.9,36.7,77.25,"s_m_y_ammucity_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {2567.4,292.6,108.73,358.85,"s_m_y_ammucity_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {-3173.57,1088.71,20.84,248.39,"s_m_y_ammucity_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {-1118.99,2699.88,18.55,224.92,"s_m_y_ammucity_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {-331.4,6085.45,31.45,218.1,"s_m_y_ammucity_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {1692.51,3761.17,34.7,219.1,"s_m_y_ammucity_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    -- Dess shop
    {73.93,-1392.26,29.38,267.43,"u_f_y_hotposh_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {427.02,-806.97,29.49,75.06,"u_f_y_hotposh_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {-822.66,-1071.97,11.33,204.33,"u_f_y_hotposh_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {-1194.81,-767.6,17.32,214.21,"u_f_y_hotposh_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {-164.93,-302.71,39.73,238.74,"u_f_y_hotposh_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {127.41,-223.13,54.56,72.94,"u_f_y_hotposh_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {-708.72,-152.07,37.42,113.2,"u_f_y_hotposh_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {-1448.94,-238.19,49.81,47.67,"u_f_y_hotposh_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {-3168.91,1044.25,20.86,62.7,"u_f_y_hotposh_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {-1102.26,2711.85,19.11,221.31,"u_f_y_hotposh_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {612.98,2761.76,42.09,268.95,"u_f_y_hotposh_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {1197.04,2711.8,38.22,175.41,"u_f_y_hotposh_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {1695.5,4822.63,42.06,82.89,"u_f_y_hotposh_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    {5.59,6511.08,31.88,39.51,"u_f_y_hotposh_01","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    -- Sheriff
    {-448.49,6012.44,31.72,314.12,"csb_cop","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    -- Police
    {440.67,-978.87,30.69,180.03,"csb_prolsec","amb@world_human_hang_out_street@female_arms_crossed@base","base"},
    -- Simeon
    {-32.13,-1114.37,26.42,70.06,"cs_siemonyetarian","amb@world_human_hang_out_street@female_arms_crossed@base","base"},

}

AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    for _,location in ipairs(markets) do
        x = location[1]
        y = location[2]
        z = location[3]
        heading = location[4]

        model = location[5]

        anim = location[6]
        animbone = location[7]

        local Hash = GetHashKey(model)
        local Ped = CreatePed(1, Hash, x,y,z-0.95, 0.0, false, true)
        if not HasModelLoaded(Hash) then
            RequestModel(Hash)
            Citizen.Wait(200)
        end
        SetEntityHeading(Ped, heading)
        FreezeEntityPosition(Ped, true)
        loadAnimDict( anim )
        TaskPlayAnim(Ped, anim, animbone, 1.0,-1.0, -1, 1, 1, true, true, true)
    end
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait(5)
    end
end

-- Engine Related
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local ped = PlayerPedId()

		if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
			local veh = GetVehiclePedIsIn(ped, true)
			local engineWasRunning = GetIsVehicleEngineRunning(veh)
			if engineWasRunning then
				SetVehicleEngineOn(veh, true, true, true)
			end

			Citizen.Wait(2000)
		end
	end
end)

-- Remove Entities
local objects = {
    {x = 266.09, y = -349.35, z = 44.74, model = "prop_sec_barier_02b"}, 
    {x = 285.28, y = -355.78, z = 45.13, model = "prop_sec_barier_02a"}, 
}

Citizen.CreateThread(function()
    while true do
        for k, v in pairs(objects) do
            local ent = GetClosestObjectOfType(objects[k].x, objects[k].y, objects[k].z, 2.0, GetHashKey(objects[k].model), false, false, false)

            SetEntityAsMissionEntity(ent, 1, 1)
            DeleteObject(ent)
            SetEntityAsNoLongerNeeded(ent)
        end

        Citizen.Wait(5000)
    end
end)

-- Traffic Script
TrafficAmount = 100 
PedestrianAmount = 100
ParkedAmount = 200
EnableDispatch = true
EnableBoats = true
EnableTrains = true
EnableGarbageTrucks = true

--[[
	TrafficAmount changes how much traffic there is on the Roads, this goes from 100% to 0%, values over 100% are also supported but not recommended, under 0% will cause a game crash.
	PedestrianAmount changes how many Peds roam the Streets
	ParkedAmount changes how many Parked Cars there are in the world
	EnableDispatch is a toggle between true and false, this enables/disables various features such as:
		- Police Responses
		- Fire Department Responses
		- Swat Responses
		- Ambulance Responses
		- Roadblocks
		- Gangs
	EnableBoats is a toggle between true and false, enables/disables random boats in the ocean.
	EnableTrains is the same as above, with Trains
]]--

Citizen.CreateThread(function()
	for i = 1, 13 do
		EnableDispatchService(i, EnableDispatch)
	end
	while true do
		-- These natives has to be called every frame.
		SetVehicleDensityMultiplierThisFrame((TrafficAmount/100)+.0)
		SetPedDensityMultiplierThisFrame((PedestrianAmount/100)+.0)
		SetRandomVehicleDensityMultiplierThisFrame((TrafficAmount/100)+.0)
		SetParkedVehicleDensityMultiplierThisFrame((ParkedAmount/100)+.0)
		SetScenarioPedDensityMultiplierThisFrame((PedestrianAmount/100)+.0, (PedestrianAmount/100)+.0)
		SetRandomBoats(EnableBoats)
		SetRandomTrains(EnableTrains)
        SetGarbageTrucks(EnableGarbageTrucks)
		Citizen.Wait(0)
	end
end)

-- Density Script
DecorRegister('ScriptedPed', 2)

local density = 0.5
CreateThread(function()
  while true do
    SetParkedVehicleDensityMultiplierThisFrame(density)
    SetVehicleDensityMultiplierThisFrame(density)
    SetRandomVehicleDensityMultiplierThisFrame(density)
    SetPedDensityMultiplierThisFrame(density)
    SetScenarioPedDensityMultiplierThisFrame(density, density) -- Walking NPC Density
    Wait(0)
  end
end)

local MarkedPeds = {}

function IsModelValid(ped)
  local eType = GetPedType(ped)
  return eType ~= 0 and eType ~= 1 and eType ~= 3 and eType ~= 28 and not IsPedAPlayer(ped)
end

function IsPedValid(ped)
  local isScripted = DecorExistOn(ped, 'ScriptedPed')

  return not isScripted and not IsPedDeadOrDying(ped, 1) and IsModelValid(ped) and IsPedStill(ped) and IsEntityStatic(ped) and not IsPedInAnyVehicle(ped) and not IsPedUsingAnyScenario(ped)
end

Citizen.CreateThread(function()
    while true do
      local idle = 2000
      local success

      local handle, ped = FindFirstPed()

      repeat
          if IsPedValid(ped) then
            MarkedPeds[ped] = ped
          end

          success, ped = FindNextPed(handle)
      until not success

      EndFindPed(handle)

      Citizen.Wait(idle)
    end
end)

Citizen.CreateThread(function()
    while true do
      local idle = 3000

      local toDelete = {}
      local playerId = PlayerId()
      local playerCoords = GetEntityCoords(PlayerPedId())

      for _, ped in pairs(MarkedPeds) do
        if ped and DoesEntityExist(ped) then
          if IsPedValid(ped) then
            local entitycoords = GetEntityCoords(ped)

            if #(entitycoords - playerCoords) <= 100.0 then
              local owner = NetworkGetEntityOwner(ped)

              if owner == playerId then
                DeleteEntity(ped)
              else
                local netId = NetworkGetNetworkIdFromEntity(ped)

                toDelete[#toDelete+1] = { netId = netId, owner = GetPlayerServerId(owner)}
              end
            end
          end
        end
      end

      if #toDelete > 0 then
        TriggerServerEvent('npc:peds:rogue', toDelete)
      else
        MarkedPeds = {}
      end

      Citizen.Wait(idle)
    end
end)

RegisterNetEvent('npc:peds:rogue:delete')
AddEventHandler('npc:peds:rogue:delete', function(pNetId)
  local tNetId = 0 
  
  for k,v in ipairs(pNetId) do
	tNetId = v["netId"]
  end

  local entity = NetworkGetEntityFromNetworkId(tNetId)
  if DoesEntityExist(entity) then
    DeleteEntity(entity)
  end
end)

RegisterNetEvent('npc:peds:decor:set')
AddEventHandler('npc:peds:decor:set', function (pNetId, pType, pProperty, pValue)
  local entity = NetworkGetEntityFromNetworkId(pNetId)

  if DoesEntityExist(entity) then
    if pType == 1 then
      DecorSetFloat(entity, pProperty, pValue)
    elseif pType == 2 then
      DecorSetBool(entity, pProperty, pValue)
    elseif pType == 3 then
      DecorSetInt(entity, pProperty, pValue)
    end
  end
end)

-- Fireworks Script
local fireworkTime = 0
local fireworkLoc = nil
local FireworkList = {
    ["proj_xmas_firework"] = {
        "scr_firework_xmas_ring_burst_rgw",
        "scr_firework_xmas_burst_rgw",
        "scr_firework_xmas_repeat_burst_rgw",
        "scr_firework_xmas_spiral_burst_rgw",
        "scr_xmas_firework_sparkle_spawn",
    },
    ["scr_indep_fireworks"] = {
        "scr_indep_firework_sparkle_spawn",
        "scr_indep_firework_starburst",
        "scr_indep_firework_shotburst",
        "scr_indep_firework_trailburst",
        "scr_indep_firework_trailburst_spawn",
        "scr_indep_firework_burst_spawn",
        "scr_indep_firework_trail_spawn",
        "scr_indep_firework_fountain",
    },
    ["proj_indep_firework"] = {
        "scr_indep_firework_grd_burst",
        "scr_indep_launcher_sparkle_spawn",
        "scr_indep_firework_air_burst",
        "proj_indep_flare_trail",
    },
    ["proj_indep_firework_v2"] = {
        "scr_firework_indep_burst_rwb",
        "scr_firework_indep_spiral_burst_rwb",
        "scr_xmas_firework_sparkle_spawn",
        "scr_firework_indep_ring_burst_rwb",
        "scr_xmas_firework_burst_fizzle",
        "scr_firework_indep_repeat_burst_rwb",
    },
}
Citizen.CreateThread(function()
    local asset = "scr_indep_fireworks"
    if not HasNamedPtfxAssetLoaded(asset) then
        RequestNamedPtfxAsset(asset)
        while not HasNamedPtfxAssetLoaded(asset) do
            Citizen.Wait(1)
        end
    end
    local asset2 = "proj_xmas_firework"
    if not HasNamedPtfxAssetLoaded(asset2) then
        RequestNamedPtfxAsset(asset2)
        while not HasNamedPtfxAssetLoaded(asset2) do
            Citizen.Wait(1)
        end
    end
    local asset3 = "proj_indep_firework_v2"
    if not HasNamedPtfxAssetLoaded(asset3) then
        RequestNamedPtfxAsset(asset3)
        while not HasNamedPtfxAssetLoaded(asset3) do
            Citizen.Wait(1)
        end
    end
    local asset4 = "proj_indep_firework"
    if not HasNamedPtfxAssetLoaded(asset4) then
        RequestNamedPtfxAsset(asset4)
        while not HasNamedPtfxAssetLoaded(asset4) do
            Citizen.Wait(1)
        end
    end
    while true do
        Citizen.Wait(1)
        if fireworkTime > 0 and fireworkLoc ~= nil then
            DrawText3Ds(fireworkLoc.x, fireworkLoc.y, fireworkLoc.z, "Firework over ~r~"..fireworkTime)
        end
    end
end)

--RegisterNetEvent("fireworks:client:UseFirework")
--AddEventHandler("fireworks:client:UseFirework", function(itemName, assetName)
--    QBCore.Functions.Progressbar("spawn_object", "Placing object..", 3000, false, true, {
--        disableMovement = true,
--        disableCarMovement = true,
--        disableMouse = false,
--        disableCombat = true,
--    }, {
--        animDict = "anim@narcotics@trash",
--        anim = "drop_front",
--        flags = 16,
--    }, {}, {}, function() -- Done
--        StopAnimTask(PlayerPedId(), "anim@narcotics@trash", "drop_front", 1.0)
--        TriggerServerEvent("QBCore:Server:RemoveItem", itemName, 1)
--        TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[itemName], "remove")
--        local pos = GetEntityCoords(PlayerPedId())
--        DoFireWork(assetName, pos)
--    end, function() -- Cancel
--        StopAnimTask(PlayerPedId(), "anim@narcotics@trash", "drop_front", 1.0)
--        QBCore.Functions.Notify("Geannuleerd..", "error")
--    end)
--end)

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function DoFireWork(asset, coords)
    fireworkTime = 5
    fireworkLoc = {x = coords.x, y = coords.y, z = coords.z}
    Citizen.CreateThread(function()
        while fireworkTime > 0 do
            Citizen.Wait(1000)
            fireworkTime = fireworkTime - 1
        end
        UseParticleFxAssetNextCall("scr_indep_fireworks")
        local part = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", fireworkLoc.x, fireworkLoc.y, fireworkLoc.z + 42.5, 0.0, 0.0, 0.0, math.random() * 0.3 + 0.5, false, false, false, false)    
        for i = 1, math.random(5, 10), 1 do
            local firework = FireworkList[asset][math.random(1, #FireworkList[asset])]
            UseParticleFxAssetNextCall(asset)
            local part = StartNetworkedParticleFxNonLoopedAtCoord(firework, fireworkLoc.x, fireworkLoc.y, fireworkLoc.z + 42.5, 0.0, 0.0, 0.0, math.random() * 0.3 + 0.5, false, false, false, false)
            Citizen.Wait(math.random()*500)
        end
        fireworkLoc = nil
    end)
end

-- Recoil Script
local recoils = {
	[453432689] = 0.3, -- PISTOL
	[3219281620] = 0.5, -- PISTOL MK2
	[1593441988] = 0.2, -- COMBAT PISTOL
	[584646201] = 0.3, -- AP PISTOL
	[2578377531] = 0.6, -- PISTOL .50
	[324215364] = 0.5, -- MICRO SMG
	[736523883] = 0.4, -- SMG
	[2024373456] = 0.1, -- SMG MK2
	[4024951519] = 0.1, -- ASSAULT SMG
	[3220176749] = 0.5, -- ASSAULT RIFLE
	[961495388] = 0.2, -- ASSAULT RIFLE MK2
	[2210333304] = 0.3, -- CARBINE RIFLE
	[4208062921] = 0.1, -- CARBINE RIFLE MK2
	[2937143193] = 0.1, -- ADVANCED RIFLE
	[2634544996] = 0.1, -- MG
	[2144741730] = 0.1, -- COMBAT MG
	[3686625920] = 0.1, -- COMBAT MG MK2
	[487013001] = 0.4, -- PUMP SHOTGUN
	[1432025498] = 0.35, -- PUMP SHOTGUN MK2
	[2017895192] = 0.7, -- SAWNOFF SHOTGUN
	[3800352039] = 0.4, -- ASSAULT SHOTGUN
	[2640438543] = 0.2, -- BULLPUP SHOTGUN
	[911657153] = 0.1, -- STUN GUN
	[100416529] = 0.5, -- SNIPER RIFLE
	[205991906] = 0.7, -- HEAVY SNIPER
	[177293209] = 0.6, -- HEAVY SNIPER MK2
	[856002082] = 1.2, -- REMOTE SNIPER
	[2726580491] = 1.0, -- GRENADE LAUNCHER
	[1305664598] = 1.0, -- GRENADE LAUNCHER SMOKE
	[2982836145] = 0.0, -- RPG
	[1752584910] = 0.0, -- STINGER
	[1119849093] = 0.01, -- MINIGUN
	[3218215474] = 0.2, -- SNS PISTOL
	[1627465347] = 0.1, -- GUSENBERG
	[3231910285] = 0.2, -- SPECIAL CARBINE
	[-1768145561] = 0.15, -- SPECIAL CARBINE MK2
	[3523564046] = 0.5, -- HEAVY PISTOL
	[2132975508] = 0.2, -- BULLPUP RIFLE
	[-2066285827] = 0.15, -- BULLPUP RIFLE MK2
	[137902532] = 0.4, -- VINTAGE PISTOL
	[2828843422] = 0.7, -- MUSKET
	[984333226] = 0.2, -- HEAVY SHOTGUN
	[3342088282] = 0.3, -- MARKSMAN RIFLE
	[1785463520] = 0.25, -- MARKSMAN RIFLE MK2
	[1672152130] = 0, -- HOMING LAUNCHER
	[1198879012] = 0.9, -- FLARE GUN
	[171789620] = 0.2, -- COMBAT PDW
	[3696079510] = 0.9, -- MARKSMAN PISTOL
	[1834241177] = 2.4, -- RAILGUN
	[3675956304] = 0.3, -- MACHINE PISTOL
	[3249783761] = 0.6, -- REVOLVER
	[-879347409] = 0.6, -- REVOLVER MK2
	[4019527611] = 0.7, -- DOUBLE BARREL SHOTGUN
	[1649403952] = 0.3, -- COMPACT RIFLE
	[317205821] = 0.2, -- AUTO SHOTGUN
	[125959754] = 0.5, -- COMPACT LAUNCHER
	[3173288789] = 0.1, -- MINI SMG		
}

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if IsPedShooting(ped) and not IsPedDoingDriveby(ped) then
			local _,wep = GetCurrentPedWeapon(ped)
			_,cAmmo = GetAmmoInClip(ped, wep)
			if recoils[wep] and recoils[wep] ~= 0 then
				tv = 0
				if GetFollowPedCamViewMode() ~= 4 then
					repeat 
						Wait(0)
						p = GetGameplayCamRelativePitch()
						SetGameplayCamRelativePitch(p+0.1, 0.2)
						tv = tv+0.1
					until tv >= recoils[wep]
				else
					repeat 
						Wait(0)
						p = GetGameplayCamRelativePitch()
						if recoils[wep] > 0.1 then
							SetGameplayCamRelativePitch(p+0.6, 1.2)
							tv = tv+0.6
						else
							SetGameplayCamRelativePitch(p+0.016, 0.333)
							tv = tv+0.1
						end
					until tv >= recoils[wep]
				end
			end
		end

		Citizen.Wait(0)
	end
end)

-- /Coords Script
local coordsVisible = false

function DrawGenericText(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(7)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.40, 0.60)
end

Citizen.CreateThread(function()
    while true do
		local sleepThread = 250
		
		if coordsVisible then
			sleepThread = 5

			local playerPed = PlayerPedId()
			local playerX, playerY, playerZ = table.unpack(GetEntityCoords(playerPed))
			local playerH = GetEntityHeading(playerPed)

			DrawGenericText(("~g~X~w~: %s ~g~Y~w~: %s ~g~Z~w~: %s ~g~H~w~: %s"):format(FormatCoord(playerX), FormatCoord(playerY), FormatCoord(playerZ), FormatCoord(playerH)))
		end

		Citizen.Wait(sleepThread)
	end
end)

FormatCoord = function(coord)
	if coord == nil then
		return "unknown"
	end

	return tonumber(string.format("%.2f", coord))
end

ToggleCoords = function()
	coordsVisible = not coordsVisible
end

RegisterCommand("coords", function()
    ToggleCoords()
end)

-- Camera Script
TakePhoto = N_0xa67c35c56eb1bd9d
WasPhotoTaken = N_0x0d6ca79eeebd8ca3
SavePhoto = N_0x3dec726c25a11bac
ClearPhoto = N_0xd801cc02177fa3f1

RegisterNetEvent("selfiePhone")
AddEventHandler("selfiePhone", function()
	if phone then
		return
	end


	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		return
	end
	CreateMobilePhone(2)
	CellCamActivate(true, true)
	Citizen.InvokeNative(0x2491A93618B7D838, true)
	phone = true

	while phone do
		local dead = exports["isPed"]:isPed("dead")
		if IsControlJustPressed(0, 176) or IsControlJustPressed(0, 322) or dead then
			phone = false
		end
		Citizen.Wait(1)
	end

	DestroyMobilePhone()
	phone = false
	CellCamActivate(false, false)
	if firstTime == true then 
		firstTime = false 
		Citizen.Wait(2500)
		displayDoneMission = true
	end

end)

----local playerCoords = GetEntityCoords(PlayerPedId())
--if #(vector3(442.36, -1021.14, 28.6) - playerCoords) < 5.0 then
--	TriggerEvent("DoLongHudText","TYesef")

--	local vehicle = 0x2560B2FC
--	RequestModel(vehicle)
--	while not HasModelLoaded(vehicle) do
--		Wait(1)
--	end

--	local vehicle = CreateVehicle(vehicle, playerCoords, 0.0, true, true)
--	SetVehicleHasBeenOwnedByPlayer(vehicle2,true)
--end

-- Camera View Script
local fov_max = 40.0
local fov_min = 4 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 10.0 -- camera zoom speed
local speed_lr = 5.0 -- speed by which the camera pans left-right
local speed_ud = 5.0 -- speed by which the camera pans up-down
local currentTime = "00:00"
local camera = false
local fov = (fov_max+fov_min)*0.5

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

RegisterNetEvent("phone:setServerTime")
AddEventHandler("phone:setServerTime", function(time)
    currentTime = explode(":",time)
end)

function explode(d,p)
    local t, ll
    t={}
    ll=0
    if(#p == 1) then
       return {p}
    end
    while true do
       l = string.find(p, d, ll, true) -- find the next d in the string
       if l ~= nil then -- if "not not" found then..
          table.insert(t, string.sub(p,ll,l-1)) -- Save it in our array.
          ll = l + 1 -- save just after where we found it for searching next time.
       else
          table.insert(t, string.sub(p,ll)) -- Save what's left in our array.
          break -- Break at end, as it should be, according to the lua manual.
       end
    end
    return t
 end

local keybindEnabled = false -- When enabled, binocular are available by keybind
local binocularKey = Keys["N4"]
local storeBinoclarKey = Keys["BACKSPACE"]

--THREADS--

Citizen.CreateThread(function()
    while true do

        Citizen.Wait(1500)

        local lPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(lPed)

        if camera then
            camera = true
            if not ( IsPedSittingInAnyVehicle( lPed ) ) then
                Citizen.CreateThread(function()
                    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_PAPARAZZI", 0, 1)
                    PlayAmbientSpeech1(PlayerPedId(), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
                    TriggerEvent("evidence:trigger")
                end)
            end

            Wait(2000)

            SetTimecycleModifier("default")


            SetTimecycleModifierStrength(0.3)

            local scaleform = RequestScaleformMovie("security_cam")

            while not HasScaleformMovieLoaded(scaleform) do
                Citizen.Wait(10)
            end

            local lPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(lPed)
            local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

            local plyPos = GetEntityCoords(PlayerPedId(),  true)
            local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
            local street1 = GetStreetNameFromHashKey(s1)
            local street2 = GetStreetNameFromHashKey(s2)
            local zone = GetNameOfZone(plyPos.x, plyPos.y, plyPos.z)
            local playerZoneName = GetLabelText(zone)

            AttachCamToEntity(cam, lPed, 0.0,0.0,1.0, true)
            SetCamRot(cam, 0.0,0.0,GetEntityHeading(lPed))
            SetCamFov(cam, fov)
            RenderScriptCams(true, false, 0, 1, 0)
            PushScaleformMovieFunction(scaleform, "SET_LOCATION")
            PushScaleformMovieFunctionParameterString(playerZoneName)
            PopScaleformMovieFunctionVoid()
            PushScaleformMovieFunction(scaleform, "SET_DETAILS")
            PushScaleformMovieFunctionParameterString(street1 .. " / " .. street2)
            PopScaleformMovieFunctionVoid()
            PushScaleformMovieFunction(scaleform, "SET_TIME")
            PushScaleformMovieFunctionParameterString(currentTime[1])
            PushScaleformMovieFunctionParameterString(currentTime[2])
            PopScaleformMovieFunctionVoid()

            while camera and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == vehicle) and IsPedUsingScenario(PlayerPedId(), "WORLD_HUMAN_PAPARAZZI") and true do
                TriggerEvent("disabledWeapons",true)
                if IsControlJustPressed(0, storeBinoclarKey) then -- Toggle camera
                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                    ClearPedTasks(PlayerPedId())
                    camera = false
                end

                local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
                CheckInputRotation(cam, zoomvalue)

                HandleZoom(cam)
                HideHUDThisFrame()

                DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
                Citizen.Wait(1)
            end

            TriggerEvent("disabledWeapons",false)
            camera = false
            ClearTimecycleModifier()
            fov = (fov_max+fov_min)*0.5
            RenderScriptCams(false, false, 0, 1, 0)
            SetScaleformMovieAsNoLongerNeeded(scaleform)
            DestroyCam(cam, false)
            SetNightvision(false)
            SetSeethrough(false)
        end
    end
end)

--EVENTS--

-- Activate camera
RegisterNetEvent('camera:Activate2')
AddEventHandler('camera:Activate2', function()
    TriggerServerEvent("phone:getServerTime")
    camera = not camera
    if not camera then
        TriggerEvent("animation:c")
    end
end)

--FUNCTIONS--
function HideHUDThisFrame()
    HideHelpTextThisFrame()
    HideHudAndRadarThisFrame()
    HideHudComponentThisFrame(1) -- Wanted Stars
    HideHudComponentThisFrame(2) -- Weapon icon
    HideHudComponentThisFrame(3) -- Cash
    HideHudComponentThisFrame(4) -- MP CASH
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(8)
    HideHudComponentThisFrame(9)
    HideHudComponentThisFrame(13) -- Cash Change
    HideHudComponentThisFrame(11) -- Floating Help Text
    HideHudComponentThisFrame(12) -- more floating help text
    HideHudComponentThisFrame(15) -- Subtitle Text
    HideHudComponentThisFrame(18) -- Game Stream
    HideHudComponentThisFrame(19) -- weapon wheel
end

function CheckInputRotation(cam, zoomvalue)
    local rightAxisX = GetDisabledControlNormal(0, 220)
    local rightAxisY = GetDisabledControlNormal(0, 221)
    local rotation = GetCamRot(cam, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
        new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
        SetCamRot(cam, new_x, 0.0, new_z, 2)
        SetEntityHeading(PlayerPedId(),new_z)
    end
end

function HandleZoom(cam)
    local lPed = PlayerPedId()
    if not ( IsPedSittingInAnyVehicle( lPed ) ) then

        if IsControlJustPressed(0,241) then -- Scrollup
            fov = math.max(fov - zoomspeed, fov_min)
        end
        if IsControlJustPressed(0,242) then
            fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
        end
        local current_fov = GetCamFov(cam)
        if math.abs(fov-current_fov) < 0.1 then
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
    else
        if IsControlJustPressed(0,17) then -- Scrollup
            fov = math.max(fov - zoomspeed, fov_min)
        end
        if IsControlJustPressed(0,16) then
            fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
        end
        local current_fov = GetCamFov(cam)
        if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
    end
end

-- Heli Cam Config
local fov_max = 80.0
local fov_min = 10.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 2.0 -- camera zoom speed
local speed_lr = 3.0 -- speed by which the camera pans left-right 
local speed_ud = 3.0 -- speed by which the camera pans up-down
local toggle_helicam = 51 -- control id of the button by which to toggle the helicam mode. Default: INPUT_CONTEXT (E)
local toggle_vision = 25 -- control id to toggle vision mode. Default: INPUT_AIM (Right mouse btn)
local toggle_rappel = 154 -- control id to rappel out of the heli. Default: INPUT_DUCK (X)
local toggle_spotlight = 183 -- control id to toggle the front spotlight Default: INPUT_PhoneCameraGrid (G)
local toggle_lock_on = 22 -- control id to lock onto a vehicle with the camera. Default is INPUT_SPRINT (spacebar)

-- Script starts here
local helicam = false
local polmav_hash = GetHashKey("polhelicopter")
local fov = (fov_max+fov_min)*0.5
local vision_state = 0 -- 0 is normal, 1 is nightmode, 2 is thermal vision
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
		if IsPlayerInPolmav() then
			local lPed = GetPlayerPed(-1)
			local heli = GetVehiclePedIsIn(lPed)
			
			if IsHeliHighEnough(heli) then
				if IsControlJustPressed(0, toggle_helicam) then -- Toggle Helicam
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					helicam = true
				end
				
				if IsControlJustPressed(0, toggle_rappel) then -- Initiate rappel
					Citizen.Trace("try to rappel")
					if GetPedInVehicleSeat(heli, 1) == lPed or GetPedInVehicleSeat(heli, 2) == lPed then
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
						TaskRappelFromHeli(GetPlayerPed(-1), 1)
					else
						SetNotificationTextEntry( "STRING" )
						AddTextComponentString("~r~Can't rappel from this seat")
						DrawNotification(false, false )
						PlaySoundFrontend(-1, "5_Second_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", false) 
					end
				end
			end
			
			if IsControlJustPressed(0, toggle_spotlight)  and GetPedInVehicleSeat(heli, -1) == lPed then
				spotlight_state = not spotlight_state
				TriggerServerEvent("heli:spotlight", spotlight_state)
				PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
			end
			
		end
		
		if helicam then
			SetTimecycleModifier("heliGunCam")
			SetTimecycleModifierStrength(0.3)
			local scaleform = RequestScaleformMovie("HELI_CAM")
			while not HasScaleformMovieLoaded(scaleform) do
				Citizen.Wait(0)
			end
			local lPed = GetPlayerPed(-1)
			local heli = GetVehiclePedIsIn(lPed)
			local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
			AttachCamToEntity(cam, heli, 0.0,0.0,-1.5, true)
			SetCamRot(cam, 0.0,0.0,GetEntityHeading(heli))
			SetCamFov(cam, fov)
			RenderScriptCams(true, false, 0, 1, 0)
			PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
			PushScaleformMovieFunctionParameterInt(1) -- 0 for nothing, 1 for LSPD logo
			PopScaleformMovieFunctionVoid()
			local locked_on_vehicle = nil
			while helicam and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == heli) and IsHeliHighEnough(heli) do
				if IsControlJustPressed(0, toggle_helicam) then -- Toggle Helicam
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					helicam = false
				end
				if IsControlJustPressed(0, toggle_vision) then
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					ChangeVision()
				end

				if locked_on_vehicle then
					if DoesEntityExist(locked_on_vehicle) then
						PointCamAtEntity(cam, locked_on_vehicle, 0.0, 0.0, 0.0, true)
						RenderVehicleInfo(locked_on_vehicle)
						if IsControlJustPressed(0, toggle_lock_on) then
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							locked_on_vehicle = nil
							local rot = GetCamRot(cam, 2) -- All this because I can't seem to get the camera unlocked from the entity
							local fov = GetCamFov(cam)
							local old cam = cam
							DestroyCam(old_cam, false)
							cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
							AttachCamToEntity(cam, heli, 0.0,0.0,-1.5, true)
							SetCamRot(cam, rot, 2)
							SetCamFov(cam, fov)
							RenderScriptCams(true, false, 0, 1, 0)
						end
					else
						locked_on_vehicle = nil -- Cam will auto unlock when entity doesn't exist anyway
					end
				else
					local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
					CheckInputRotation(cam, zoomvalue)
					local vehicle_detected = GetVehicleInView(cam)
					if DoesEntityExist(vehicle_detected) then
						RenderVehicleInfo(vehicle_detected)
						if IsControlJustPressed(0, toggle_lock_on) then
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							locked_on_vehicle = vehicle_detected
						end
					end
				end
				HandleZoom(cam)
				HideHUDThisFrame()
				PushScaleformMovieFunction(scaleform, "SET_ALT_FOV_HEADING")
				PushScaleformMovieFunctionParameterFloat(GetEntityCoords(heli).z)
				PushScaleformMovieFunctionParameterFloat(zoomvalue)
				PushScaleformMovieFunctionParameterFloat(GetCamRot(cam, 2).z)
				PopScaleformMovieFunctionVoid()
				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
				Citizen.Wait(0)
			end
			helicam = false
			ClearTimecycleModifier()
			fov = (fov_max+fov_min)*0.5 -- reset to starting zoom level
			RenderScriptCams(false, false, 0, 1, 0) -- Return to gameplay camera
			SetScaleformMovieAsNoLongerNeeded(scaleform) -- Cleanly release the scaleform
			DestroyCam(cam, false)
			SetNightvision(false)
			SetSeethrough(false)
		end
	end
end)

RegisterNetEvent('heli:spotlight')
AddEventHandler('heli:spotlight', function(serverID, state)
	local heli = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(serverID)), false)
	SetVehicleSearchlight(heli, state, false)
	Citizen.Trace("Set heli light state to "..tostring(state).." for serverID: "..serverID)
end)

function IsPlayerInPolmav()
	local lPed = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(lPed)
	return IsVehicleModel(vehicle, polmav_hash)
end

function IsHeliHighEnough(heli)
	return GetEntityHeightAboveGround(heli) > 1.5
end

function ChangeVision()
	if vision_state == 0 then
		SetNightvision(true)
		vision_state = 1
	elseif vision_state == 1 then
		SetNightvision(false)
		SetSeethrough(true)
		vision_state = 2
	else
		SetSeethrough(false)
		vision_state = 0
	end
end

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(19) -- weapon wheel
	HideHudComponentThisFrame(1) -- Wanted Stars
	HideHudComponentThisFrame(2) -- Weapon icon
	HideHudComponentThisFrame(3) -- Cash
	HideHudComponentThisFrame(4) -- MP CASH
	HideHudComponentThisFrame(13) -- Cash Change
	HideHudComponentThisFrame(11) -- Floating Help Text
	HideHudComponentThisFrame(12) -- more floating help text
	HideHudComponentThisFrame(15) -- Subtitle Text
	HideHudComponentThisFrame(18) -- Game Stream
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5) -- Clamping at top (cant see top of heli) and at bottom (doesn't glitch out in -90deg)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	if IsControlJustPressed(0,241) then -- Scrollup
		fov = math.max(fov - zoomspeed, fov_min)
	end
	if IsControlJustPressed(0,242) then
		fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown		
	end
	local current_fov = GetCamFov(cam)
	if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
		fov = current_fov
	end
	SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
end

function GetVehicleInView(cam)
	local coords = GetCamCoord(cam)
	local forward_vector = RotAnglesToVec(GetCamRot(cam, 2))
	--DrawLine(coords, coords+(forward_vector*100.0), 255,0,0,255) -- debug line to show LOS of cam
	local rayhandle = CastRayPointToPoint(coords, coords+(forward_vector*200.0), 10, GetVehiclePedIsIn(GetPlayerPed(-1)), 0)
	local _, _, _, _, entityHit = GetRaycastResult(rayhandle)
	if entityHit>0 and IsEntityAVehicle(entityHit) then
		return entityHit
	else
		return nil
	end
end

function RenderVehicleInfo(vehicle)
	local model = GetEntityModel(vehicle)
	local vehname = GetLabelText(GetDisplayNameFromVehicleModel(model))
	local licenseplate = GetVehicleNumberPlateText(vehicle)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextScale(0.0, 0.55)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString("Model: "..vehname.."\nPlate: "..licenseplate)
	DrawText(0.45, 0.9)
end

-- function HandleSpotlight(cam)
-- if IsControlJustPressed(0, toggle_spotlight) then
	-- PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
	-- spotlight_state = not spotlight_state
-- end
-- if spotlight_state then
	-- local rotation = GetCamRot(cam, 2)
	-- local forward_vector = RotAnglesToVec(rotation)
	-- local camcoords = GetCamCoord(cam)
	-- DrawSpotLight(camcoords, forward_vector, 255, 255, 255, 300.0, 10.0, 0.0, 2.0, 1.0)
-- end
-- end

function RotAnglesToVec(rot) -- input vector3
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end

-- Car Wash Script
Key = 201 -- ENTER
vehicleWashStation = {
	{26.5906,  -1392.0261,  27.3634},
	{167.1034,  -1719.4704,  27.2916},
	{-74.5693,  6427.8715,  29.4400},
	{-699.6325,  -932.7043,  17.0139}
}

Citizen.CreateThread(function ()
	Citizen.Wait(0)
	for i = 1, #vehicleWashStation do
		garageCoords = vehicleWashStation[i]
		stationBlip = AddBlipForCoord(garageCoords[1], garageCoords[2], garageCoords[3])
		SetBlipSprite(stationBlip, 100) -- 100 = carwash
		SetBlipAsShortRange(stationBlip, true)
		SetBlipScale(stationBlip, 0.8)
		SetBlipColour(stationBlip, 3)
	end
    return
end)

function DrawSpecialText(m_text, showtime)
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(1)

		if IsPedSittingInAnyVehicle(PlayerPedId()) then 
			
			local dstchecked = 1000

			for i = 1, #vehicleWashStation do
				garageCoords2 = vehicleWashStation[i]

				local comparedst = #(GetEntityCoords(PlayerPedId()) - vector3( garageCoords2[1], garageCoords2[2], garageCoords2[3]))
				if comparedst < dstchecked then
					dstchecked = comparedst
				end

				
				DrawMarker(27, garageCoords2[1], garageCoords2[2], garageCoords2[3], 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
				if #(GetEntityCoords(PlayerPedId()) - vector3(garageCoords2[1], garageCoords2[2], garageCoords2[3])) < 5 then
					DrawSpecialText("Press [~g~ENTER~s~] to clean your vehicle!")
					if(IsControlJustPressed(1, Key)) then
						TriggerServerEvent('carwash:checkmoney')
					end
				end
			end

			if dstchecked > 50 then
				Citizen.Wait(math.ceil(dstchecked * 10))
			end

		else
			Wait(2000)
		end

	end
end)

RegisterNetEvent('carwash:success')
AddEventHandler('carwash:success', function(price)
	SetVehicleDirtLevel(GetVehiclePedIsUsing(PlayerPedId()))
	SetVehicleUndriveable(GetVehiclePedIsUsing(PlayerPedId()), false)
	msg = "Vehicle ~y~Clean~s~! ~g~-$" .. price .. "~s~!"
	DrawSpecialText(msg, 5000)
	Wait(5000)
end)

RegisterNetEvent('carwash:notenoughmoney')
AddEventHandler('carwash:notenoughmoney', function(moneyleft)
	msg = "~h~~r~You don't have enough money! $" .. moneyleft .. " left!"
	DrawSpecialText(msg, 5000)
	Wait(5000)
end)

RegisterNetEvent('carwash:free')
AddEventHandler('carwash:free', function()
	SetVehicleDirtLevel(GetVehiclePedIsUsing(PlayerPedId()))
	SetVehicleUndriveable(GetVehiclePedIsUsing(PlayerPedId()), false)
	msg = "Vehicle ~y~Clean~s~ for free!"
	DrawSpecialText(msg, 5000)
	Wait(5000)
end)

-- Binoculars Script
local fov_max = 70.0
local fov_min = 5.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 10.0 -- camera zoom speed
local speed_lr = 8.0 -- speed by which the camera pans left-right
local speed_ud = 8.0 -- speed by which the camera pans up-down

local binoculars = false
local fov = (fov_max+fov_min)*0.5

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local keybindEnabled = false -- When enabled, binocular are available by keybind
local binocularKey = Keys["N4"]
local storeBinoclarKey = Keys["BACKSPACE"]

--THREADS--
Citizen.CreateThread(function()
    while true do

        Citizen.Wait(1500)

        local lPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(lPed)

        if binoculars then
            binoculars = true
            if not ( IsPedSittingInAnyVehicle( lPed ) ) then
                Citizen.CreateThread(function()
                    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_BINOCULARS", 0, 1)
                    PlayAmbientSpeech1(PlayerPedId(), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
                end)
            end

            Wait(2000)

            SetTimecycleModifier("default")


            SetTimecycleModifierStrength(0.3)

            local scaleform = RequestScaleformMovie("BINOCULARS")

            while not HasScaleformMovieLoaded(scaleform) do
                Citizen.Wait(10)
            end

            local lPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(lPed)
            local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

            AttachCamToEntity(cam, lPed, 0.0,0.0,1.0, true)
            SetCamRot(cam, 0.0,0.0,GetEntityHeading(lPed))
            SetCamFov(cam, fov)
            RenderScriptCams(true, false, 0, 1, 0)
            PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
            PushScaleformMovieFunctionParameterInt(0) -- 0 for nothing, 1 for LSPD logo
            PopScaleformMovieFunctionVoid()

            while binoculars and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == vehicle) and IsPedUsingScenario(PlayerPedId(), "WORLD_HUMAN_BINOCULARS") and true do
                TriggerEvent("disabledWeapons",true)
                if IsControlJustPressed(0, storeBinoclarKey) then -- Toggle binoculars
                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                    ClearPedTasks(PlayerPedId())
                    binoculars = false
                end

                local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
                CheckInputRotation(cam, zoomvalue)

                HandleZoom(cam)
                HideHUDThisFrame()

                DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
                Citizen.Wait(1)
            end

            TriggerEvent("disabledWeapons",false)
            binoculars = false
            ClearTimecycleModifier()
            fov = (fov_max+fov_min)*0.5
            RenderScriptCams(false, false, 0, 1, 0)
            SetScaleformMovieAsNoLongerNeeded(scaleform)
            DestroyCam(cam, false)
            SetNightvision(false)
            SetSeethrough(false)
        end
    end
end)

--EVENTS--

-- Activate binoculars
RegisterNetEvent('binoculars:Activate2')
AddEventHandler('binoculars:Activate2', function()

    binoculars = not binoculars
    if not binoculars then
        TriggerEvent("animation:c")
    end
end)

--FUNCTIONS--
function HideHUDThisFrame()
    HideHelpTextThisFrame()
    HideHudAndRadarThisFrame()
    HideHudComponentThisFrame(1) -- Wanted Stars
    HideHudComponentThisFrame(2) -- Weapon icon
    HideHudComponentThisFrame(3) -- Cash
    HideHudComponentThisFrame(4) -- MP CASH
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(8)
    HideHudComponentThisFrame(9)
    HideHudComponentThisFrame(13) -- Cash Change
    HideHudComponentThisFrame(11) -- Floating Help Text
    HideHudComponentThisFrame(12) -- more floating help text
    HideHudComponentThisFrame(15) -- Subtitle Text
    HideHudComponentThisFrame(18) -- Game Stream
    HideHudComponentThisFrame(19) -- weapon wheel
end

function CheckInputRotation(cam, zoomvalue)
    local rightAxisX = GetDisabledControlNormal(0, 220)
    local rightAxisY = GetDisabledControlNormal(0, 221)
    local rotation = GetCamRot(cam, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
        new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
        SetCamRot(cam, new_x, 0.0, new_z, 2)
        SetEntityHeading(PlayerPedId(),new_z)
    end
end

function HandleZoom(cam)
    local lPed = PlayerPedId()
    if not ( IsPedSittingInAnyVehicle( lPed ) ) then

        if IsControlJustPressed(0,241) then -- Scrollup
            fov = math.max(fov - zoomspeed, fov_min)
        end
        if IsControlJustPressed(0,242) then
            fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
        end
        local current_fov = GetCamFov(cam)
        if math.abs(fov-current_fov) < 0.1 then
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
    else
        if IsControlJustPressed(0,17) then -- Scrollup
            fov = math.max(fov - zoomspeed, fov_min)
        end
        if IsControlJustPressed(0,16) then
            fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
        end
        local current_fov = GetCamFov(cam)
        if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
    end
end

-- Barriers Script
RegisterNetEvent('barriers:pickup')
RegisterNetEvent('barriers:cone')
RegisterNetEvent('barriers:sbarrier')
RegisterNetEvent('barriers:barrier')

objList = {
	[1] = "prop_mp_cone_01",
	[2] = "prop_mp_barrier_02b",
	[3] = "prop_barrier_work05",
	[4] = "prop_flare_01",
	[5] = "prop_flare_01b",
	[6] = "prop_mp_cone_01",
}

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

AddEventHandler('barriers:pickup', function()
    loadAnimDict('anim@narcotics@trash')
    TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1700, 49, 1.0, 0, 0, 0)
	local finished = exports["npc-taskbar"]:taskBar(1800,"Picking up barrier")
  	if finished == 100 then
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.25, 0.0))
		local heading = GetEntityHeading(PlayerPedId())
		local objFound = 0
		for i = 1, #objList do
			local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.25, 0.0))
			objFound = GetClosestObjectOfType(x, y, z, 5.0, GetHashKey(objList[i]), 0, 0, 0)
			DeleteObject(objFound)
			DeleteEntity(objFound)

			DeleteObject(objFound)
			DeleteEntity(objFound)
		end
		TriggerServerEvent("aidsarea",false,x,y,z, heading)
	end
end)

AddEventHandler('barriers:cone', function()
    loadAnimDict('anim@narcotics@trash')
    TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1700, 49, 3.0, 0, 0, 0)
	local finished = exports["npc-taskbar"]:taskBar(1800,"Placing Cone")
  	if finished == 100 then	
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.2, 0.0))
		local heading = GetEntityHeading(PlayerPedId())
		RequestModel('prop_mp_cone_01')
		while not HasModelLoaded('prop_mp_cone_01') do
			Citizen.Wait(1)
		end
		local cone = CreateObject('prop_mp_cone_01', x, y, z, true, false, false)
		exports["isPed"]:GlobalObject(cone)
		PlaceObjectOnGroundProperly(cone)
		SetEntityHeading(cone, heading)
	end
end)

AddEventHandler('barriers:sbarrier', function()
    loadAnimDict('anim@narcotics@trash')
    TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1700, 49, 3.0, 0, 0, 0)
	local finished = exports["npc-taskbar"]:taskBar(1800,"Placing Barrier")
  	if finished == 100 then	
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.2, 0.0))
		local heading = GetEntityHeading(PlayerPedId())
		RequestModel('prop_barrier_work05')
		while not HasModelLoaded('prop_barrier_work05') do
			Citizen.Wait(1)
		end
		local sbarrier = CreateObject('prop_barrier_work05', x, y, z, true, false, false)
		exports["isPed"]:GlobalObject(sbarrier)
		PlaceObjectOnGroundProperly(sbarrier)
		SetEntityHeading(sbarrier, heading)
	end
end)

AddEventHandler('barriers:barrier', function()
    loadAnimDict('anim@narcotics@trash')
    TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1700, 49, 3.0, 0, 0, 0)
	local finished = exports["npc-taskbar"]:taskBar(1800,"Placing Roadblock")
  	if finished == 100 then
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.2, 0.0))
		local c1x,c1y,c1z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 2.2, 0.0))
		local c2x,c2y,c2z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), -1.5, 2.2, 0.0))
		local heading = GetEntityHeading(PlayerPedId())
		RequestModel('prop_barrier_work05')
		while not HasModelLoaded('prop_barrier_work05') do
			Citizen.Wait(1)
		end
		local barrier = CreateObject('prop_barrier_work05', x, y, z, true, false, false)
		local cone = CreateObject('prop_mp_cone_01', c1x,c1y,c1z, true, false, false)
		local cone2 = CreateObject('prop_mp_cone_01', c2x,c2y,c2z, true, false, false)
		PlaceObjectOnGroundProperly(barrier)
		PlaceObjectOnGroundProperly(cone)
		PlaceObjectOnGroundProperly(cone2)
		SetEntityHeading(barrier, heading)
		exports["isPed"]:GlobalObject(barrier)
		exports["isPed"]:GlobalObject(cone)
		exports["isPed"]:GlobalObject(cone2)
		TriggerEvent("DoLongHudText","Traffic Blocked in facing direction.",1)
		TriggerServerEvent("aidsarea",true,x,y,z, heading)
	end
end)

-- Instructional Buttons
function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function setupScaleform(scaleform)

    local scaleform = RequestScaleformMovie(scaleform)

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(1)
    end

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(5)
    Button(GetControlInstructionalButton(2, config.controls.openKey, true))
    ButtonMessage("Noclip off")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(4)
    Button(GetControlInstructionalButton(2, config.controls.goUp, true))
    ButtonMessage("Up")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
    Button(GetControlInstructionalButton(2, config.controls.goDown, true))
    ButtonMessage("Down")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(1, config.controls.turnRight, true))
    Button(GetControlInstructionalButton(1, config.controls.turnLeft, true))
    ButtonMessage("Turn Right / Left")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(1, config.controls.goBackward, true))
    Button(GetControlInstructionalButton(1, config.controls.goForward, true))
    ButtonMessage("Go Forward / Back")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, config.controls.changeSpeed, true))
    ButtonMessage(""..config.speeds[index].label.." ")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(config.bgR)
    PushScaleformMovieFunctionParameterInt(config.bgG)
    PushScaleformMovieFunctionParameterInt(config.bgB)
    PushScaleformMovieFunctionParameterInt(config.bgA)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

-- Dances Script
local isHandcuffed, isSoftCuffed = false, false

local animations = {
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_flats_female^3", disabled = true},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_male^3", disabled = true},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_flats_female^5", disabled = true},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_flats_female^1", disabled = true},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_flats_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_flats_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_flats_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_flats_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_flats_female^4", disabled = true},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_flats_female^6", disabled = true},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_flats_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_flats_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_flats_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_flats_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_flats_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_flats_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_flats_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_flats_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_flats_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_flats_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_flats_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_flats_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_flats_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_flats_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_flats_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_phone^3", disabled = true},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_phone^2", disabled = true},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_flats_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_flats_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_flats_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_vape_01^3", disabled = true},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_flats_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_phone^1", disabled = true},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_flats_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_flats_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_phone", disabled = true},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_flats_female^4", disabled = true},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_flats_female^3", disabled = true},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_flats_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_flats_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_flats_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_flats_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_07_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_07_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_07_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_07_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_07_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_07_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_07_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_07_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_07_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_07_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_07_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_li_07_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_07_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_07_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_07_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_07_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_07_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_07_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_07_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_07_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_07_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_07_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_07_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_hi_07_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_07_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_07_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_07_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_07_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_07_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_07_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_07_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_07_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_07_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_07_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_07_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_li_07_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_11_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_13_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_13_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_11_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_11_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_11_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_13_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_13_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_13_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_11_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_13_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_13_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_11_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_11_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_13_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_11_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_13_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_11_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_11_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_13_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_13_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_11_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_15_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_11_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_17_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_13_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_17_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_11_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_13_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_09_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_10_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_09_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_09_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_10_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_09_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_10_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_09_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_09_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_09_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_09_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_10_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_09_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_10_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_10_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_10_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_09_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_09_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_09_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_10_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_10_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_10_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_10_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_11_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_17_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_10_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_15_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups@med_intensity", anim = "mi_dance_crowd_13_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li__07_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_07_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_07_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li__07_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_07_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_07_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li__07_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_07_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_07_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_07_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_07_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li__07_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_07_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_07_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li__07_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li__07_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li__07_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li__07_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li__07_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li__07_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_07_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_07_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li__07_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li__07_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_mi_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", anim = "trans_dance_crowd_hi_to_li_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_11_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_11_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_11_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_11_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_11_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_11_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_11_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_11_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_11_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_11_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_11_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_mi_11_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_low_intensity", anim = "trans_dance_crowd_li_to_hi_09_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_12_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_12_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_hi_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_hi_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_hi_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_09_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_hi_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_12_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_12_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_12_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_12_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_09_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_hi_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_12_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_12_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_hi_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_09_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_12_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_09_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_09_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_09_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_hi_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_09_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_12_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_hi_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_09_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_09_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_12_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_09_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_hi_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_12_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_09_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_hi_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_hi_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_li_09_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_groups_transitions@from_med_intensity", anim = "trans_dance_crowd_mi_to_hi_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_11_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_17_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_17_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_15_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_15_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_11_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_17_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_11_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_17_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_11_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_17_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_11_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_17_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_15_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_15_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_11_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_15_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_17_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_11_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_17_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_15_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_11_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_15_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_11_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_11_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_17_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_15_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_15_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_11_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_11_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_15_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_17_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_17_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_15_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_15_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_17_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", anim = "hi_dance_prop_13_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_15_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_11_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_crowd_prop_15_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_09_v1_male^3_face"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_15_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_17_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_crowd_prop_15_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_crowd_prop_15_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_15_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_11_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_11_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_17_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_15_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_11_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_15_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_15_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_crowd_prop_15_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_15_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_17_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_11_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_17_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_crowd_prop_15_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_15_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_11_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_17_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_15_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_17_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_crowd_prop_15_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_crowd_prop_15_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_15_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_17_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v2_male^5_face"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_11_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v2_male^3_face"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_crowd_prop_15_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_15_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v2_male^6_face"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_17_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_crowd_prop_15_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_11_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_crowd_prop_15_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_crowd_prop_15_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_11_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_17_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_15_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_17_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_17_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_13_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_17_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_crowd_prop_15_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_11_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_11_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@low_intensity", anim = "li_dance_prop_11_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_17_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v2_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_15_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_11_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_17_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_15_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v2_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_17_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_17_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_11_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_15_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_15_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v2_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_17_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_15_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v2_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_17_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_17_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_17_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_11_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_11_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_11_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_17_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_11_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v2_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_15_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v2_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v2_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v2_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v2_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_17_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_15_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v2_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_11_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v2_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_17_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_15_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_11_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_11_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_11_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_15_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_11_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_15_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_15_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_15_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_17_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v2_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_13_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_11_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props@med_intensity", anim = "mi_dance_prop_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_li_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_li_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_11_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "vehicleweapons_tula"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_li_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_11_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_11_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_li_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_li_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_li_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_11_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_li_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_11_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_11_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_li_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_11_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_li_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_li_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_11_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_li_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_li_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_li_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_li_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_11_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_li_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_li_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_11_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_11_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_11_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_11_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_11_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_li_09_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_11_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_09_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_11_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_li_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_09_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_09_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_li_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_11_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_11_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_11_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_09_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_li_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_11_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_11_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_11_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_li_09_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_li_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_li_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_09_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_09_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_09_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_11_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_li_09_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_dance_prop_hi_to_mi_11_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_09_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_hi_intensity", anim = "trans_crowd_prop_hi_to_mi_09_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_hi_07_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_mi_11_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_mi_11_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_hi_07_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_mi_11_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_mi_11_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_mi_11_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_mi_11_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_mi_11_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_hi_07_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_hi_07_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_mi_11_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_hi_07_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_hi_07_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_hi_07_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_mi_11_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_hi_07_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_mi_11_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_mi_11_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_hi_07_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_mi_11_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_mi_11_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_mi_11_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_hi_07_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_mi_11_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_mi_11_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_mi_11_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_hi_07_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_hi_07_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_hi_07_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_hi_07_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_hi_07_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_hi_07_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_mi_11_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_mi_11_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_mi_11_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_mi_11_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_hi_07_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_hi_07_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_hi_07_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_mi_11_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_hi_07_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_mi_11_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_hi_07_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_mi_11_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_hi_07_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_dance_prop_li_to_hi_07_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_low_intensity", anim = "trans_crowd_prop_li_to_hi_07_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_hi_11_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_li_11_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_li_11_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_li_11_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_hi_11_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_li_11_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_li_11_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_li_11_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_hi_11_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_li_11_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_hi_11_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_hi_11_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_hi_11_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_hi_11_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_hi_11_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_li_11_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_hi_11_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_li_11_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_hi_11_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_li_11_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_hi_11_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_li_11_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_li_11_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_hi_11_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_hi_11_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_li_11_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_hi_11_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_hi_11_v1_male^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_hi_11_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_hi_11_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_li_11_v1_female^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_hi_11_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_li_11_v1_male^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_hi_11_v1_female^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_li_11_v1_female^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_li_11_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_li_11_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_hi_11_v1_male^3"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_hi_11_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_li_11_v1_male^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_li_11_v1_female^2"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_li_11_v1_male^6"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_li_11_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_hi_11_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_hi_11_v1_female^5"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_crowd_prop_mi_to_hi_11_v1_female^4"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_li_11_v1_male^1"},
    { dict = "anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", anim = "trans_dance_prop_mi_to_li_11_v1_female^2"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "high_left_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "low_left_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "high_left_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "med_right_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "med_center"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "high_center_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "med_center_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "low_right"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "high_right_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "low_left_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "low_right_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "med_right"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "intro"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "med_right_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "low_right_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "med_left_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "low_center_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "high_right"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "high_center_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "high_center"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "med_center_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "low_center"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "high_right_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "low_left"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "outro", disabled = true},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "med_left_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "med_left"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "high_left"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@beach_boxing@", anim = "low_center_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "high_left_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "low_left_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "high_left_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "med_right_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "med_center"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "high_center_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "med_center_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "low_right"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "high_right_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "low_left_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "low_right_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "med_right"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "intro"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "med_right_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "low_right_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "med_left_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "low_center_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "high_right"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "high_center_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "high_center"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "med_center_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "low_center"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "high_right_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "low_left"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "outro"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "med_left_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "med_left"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "high_left"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@jumper@", anim = "low_center_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "high_left_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "low_left_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "high_left_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "med_right_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "med_center"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "high_center_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "med_center_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "low_right"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "high_right_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "low_left_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "low_right_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "med_right"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "intro", disabled = true},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "med_right_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "low_right_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "med_left_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "low_center_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "high_right"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "high_center_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "high_center"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "med_center_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "low_center"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "high_right_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "low_left"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "outro"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "med_left_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "med_left"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "high_left"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@sand_trip@", anim = "low_center_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "high_left_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "low_left_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "high_left_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "med_right_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "med_center"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "high_center_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "med_center_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "low_right"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "high_right_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "low_left_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "low_right_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "med_right"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "intro"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "med_right_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "low_right_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "med_left_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "low_center_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "high_right"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "high_center_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "high_center"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "med_center_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "low_center"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "high_right_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "low_left"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "outro"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "med_left_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "med_left"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "high_left"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "low_center_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "high_left_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "low_left_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "high_left_down", disabled = true},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "med_right_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "med_center"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "high_center_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "med_center_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "low_right"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "high_right_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "low_left_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "low_right_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "med_right"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "intro"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "med_right_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "low_right_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "med_left_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "low_center_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "high_right"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "high_center_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "high_center"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "med_center_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "low_center"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "high_right_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "low_left"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "outro"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "med_left_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "med_left"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "high_left"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_karate@", anim = "low_center_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "high_left_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "low_left_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "high_left_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "med_right_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "med_center"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "high_center_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "med_center_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "low_right"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "high_right_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "low_left_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "low_right_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "med_right"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "intro", disabled = true},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "med_right_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "low_right_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "med_left_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "low_center_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "high_right"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "high_center_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "high_center"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "med_center_down"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "low_center"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "high_right_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "low_left"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "outro"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "med_left_up"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "med_left"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "high_left"},
    { dict = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "low_center_down"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_c_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_c_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_hi_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_hi_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_a_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_a_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_li_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_li_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_li_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_li_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_c_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_d_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_d_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_d_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_d_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_c_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_c_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_c_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_c_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_c_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_c_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_c_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_c_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_mi_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_mi_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_mi_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_mi_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_d_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_li_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_mi_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_c_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_a_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_a_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_a_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_loop_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_loop_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_a_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_a_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_loop_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_loop_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_loop_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_loop_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_loop_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_loop_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_loop_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_loop_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_b_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_b_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_b_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_b_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_li_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_li_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_li_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_li_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_ti_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_ti_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_hi_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_hi_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_a_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_loop_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_b_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_b_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_b_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_b_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_li_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_b_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_a_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_b_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_loop_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_loop_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_hi_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_hi_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_loop_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_loop_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_ti_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_ti_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_d_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_b_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_b_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_ti_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_ti_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_ti_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_d_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_b_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_b_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_c_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_b_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_b_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_c_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_d_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_d_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_loop_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_loop_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_mi_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_mi_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_b_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_loop_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_ti_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_loop_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_loop_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_loop_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_loop_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_ti_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_loop_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_loop_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_li_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_li_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_li_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_li_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_hi_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_hi_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_hi_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_b_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_b_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_b_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_b_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_hi_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_hi_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_hi_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_hi_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_b_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_b_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_hi_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_hi_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_hi_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_hi_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_hi_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_hi_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_mi_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_d_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_mi_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_mi_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_mi_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_a_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_a_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_a_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_a_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_a_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_a_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_a_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_a_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_a_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_ti_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_ti_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_ti_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_c_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_idle_c_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_mi_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_mi_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_mi_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_c_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_c_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_ti_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_ti_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_a_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_a_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_a_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_mi_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_mi_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_li_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_c_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_c_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_c_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_a_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_a_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_li_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_li_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_li_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_li_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_a_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_a_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_ti_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_ti_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_mi_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_mi_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_mi_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_mi_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_to_mi_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_ti_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_ti_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_ti_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_b_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_b_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_c_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_c_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_c_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_li_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_b_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_b_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_idle_b_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_to_li_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_c_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_c_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_c_m05"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_c_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_ti_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_loop_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_loop_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_to_ti_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_hi_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "li_to_hi_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_loop_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "mi_loop_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_a_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_a_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdance@", anim = "ti_idle_a_f01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_idle_c_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_to_mi_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_loop_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_f_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_loop_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_idle_a_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_idle_c_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_idle_c_f1"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_loop_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_to_li_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_idle_a_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_idle_b_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_loop_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_to_ti_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_idle_e_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_loop_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_loop_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_idle_a_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_to_mi_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_a_f1"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_a_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_a_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_to_mi_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_b_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_idle_c_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_to_mi_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_idle_b_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_b_f1"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_to_li_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_idle_b_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_idle_a_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_idle_c_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_idle_b_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_to_mi_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_c_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_idle_a_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_c_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_idle_c_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_idle_b_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_to_mi_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_idle_a_f1"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_idle_b_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_idle_c_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_a_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_to_mi_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_to_mi_drop_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_a_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_b_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_to_li_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_loop_f1"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_loop_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_c_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_to_mi_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_loop_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_idle_d_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_loop_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_to_li_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_to_ti_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_to_ti_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_loop_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_to_ti_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_idle_b_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_to_mi_drop_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_d_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_idle_a_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_to_ti_f1"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_to_ti_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_to_li_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_idle_c_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_to_ti_f1"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_to_mi_f1", disabled = true},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_to_li_f1"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_to_mi_drop_f1"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_c_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_idle_a_f1"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_idle_b_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_idle_b_f1"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_idle_c_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_idle_a_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_idle_d_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_to_ti_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_b_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_idle_a_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_e_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_idle_c_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_loop_f1"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_idle_c_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_idle_a_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_loop_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_c_f1"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_loop_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_to_li_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_b_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_to_li_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_loop_f1"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_idle_b_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_idle_a_m02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_idle_c_f1"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_to_ti_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_loop_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_to_ti_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_c_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_loop_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_to_ti_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_to_ti_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_to_mi_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_to_li_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_b_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_idle_b_f1"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "ti_to_li_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_to_li_f1"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_to_li_m01"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_idle_a_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "li_idle_b_m03"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprop@", anim = "mi_loop_f02"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprops@male@", anim = "mi_idle_b_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprops@male@", anim = "mi_idle_c_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprops@male@", anim = "ti_to_li_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprops@male@", anim = "mi_loop_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprops@male@", anim = "mi_to_ti_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprops@male@", anim = "ti_idle_a_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprops@male@", anim = "li_idle_b_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprops@male@", anim = "li_to_mi_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprops@male@", anim = "mi_idle_a_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprops@male@", anim = "li_idle_a_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprops@male@", anim = "li_to_ti_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprops@male@", anim = "ti_to_mi_drop_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprops@male@", anim = "li_loop_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprops@male@", anim = "ti_idle_c_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprops@male@", anim = "ti_idle_b_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprops@male@", anim = "li_idle_c_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprops@male@", anim = "ti_loop_m04"},
    { dict = "anim@amb@nightclub_island@dancers@beachdanceprops@male@", anim = "mi_to_li_m04"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_idle_c_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_idle_c_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_idle_c_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_to_hi_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_to_hi_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_a_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_a_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_a_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_to_hi_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_f_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_to_li_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_to_li_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_c_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_d_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_d_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_d_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_c_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_c_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_c_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_c_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_to_mi_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_to_mi_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_to_li_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_a_f04"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_to_mi_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_e_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_c_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_idle_a_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_loop_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_loop_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_idle_a_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_idle_a_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_loop_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_loop_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_loop_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_loop_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_idle_b_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_idle_b_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_idle_b_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_to_li_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_to_li_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_to_li_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_to_ti_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_to_ti_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_to_ti_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_e_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_a_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_b_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_b_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_b_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_a_f04"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_a_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_a_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_loop_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_to_hi_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_to_hi_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_to_hi_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_loop_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_loop_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_to_ti_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_to_ti_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_d_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_b_f04"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_b_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_b_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_b_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_to_ti_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_d_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_d_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_b_f04"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_b_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_b_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_b_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_c_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_idle_b_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_idle_b_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_c_f04"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_idle_b_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_c_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_c_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_d_f04"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_d_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_loop_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_loop_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_loop_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_to_mi_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_to_mi_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_to_mi_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_b_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_to_ti_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_to_ti_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_loop_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_loop_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_loop_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_to_ti_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_loop_f04"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_loop_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_loop_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_loop_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_to_li_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_to_li_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_to_li_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_to_li_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_to_li_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_to_li_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_d_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_to_hi_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_to_hi_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_to_hi_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_b_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_b_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_to_hi_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_to_hi_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_b_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_to_hi_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_b_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_b_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_to_hi_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_to_hi_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_to_hi_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_to_mi_f04"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_to_mi_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_to_mi_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_idle_d_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_f_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_to_mi_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_to_mi_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_to_mi_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_to_mi_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_a_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_a_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_a_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_a_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_a_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_to_ti_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_to_ti_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_c_f04"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_c_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_c_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_c_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_to_mi_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_c_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_c_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_d_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_to_ti_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_a_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_to_mi_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_to_mi_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_c_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_a_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_a_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_to_li_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_to_li_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_to_li_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_a_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_a_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_a_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_to_mi_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_to_mi_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_to_mi_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_to_si_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_e_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_to_ti_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_to_ti_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_to_ti_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_to_li_f04"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_idle_c_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_idle_c_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_idle_c_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_to_li_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_to_li_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_idle_f_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_b_m03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_b_m02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_idle_b_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_to_li_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_c_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_c_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_c_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_to_ti_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_to_ti_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_loop_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_loop_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_to_ti_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_loop_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_to_hi_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_to_hi_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "li_to_hi_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_loop_f04"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_loop_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_loop_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "mi_loop_f01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_idle_e_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_a_m01"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_idle_a_f03"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_idle_a_f02"},
    { dict = "anim@amb@nightclub_island@dancers@club@", anim = "ti_idle_a_f01"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_11_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_d_11_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_11_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_11_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_17_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_13_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_11_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_13_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_17_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_d_11_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_11_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_11_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_d_11_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_11_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_d_11_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_17_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_11_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_09_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_11_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_11_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_17_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_09_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_09_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_11_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_11_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_09_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_11_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_09_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_11_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_d_11_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_13_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_09_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_d_11_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_17_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_13_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_d_11_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_17_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_17_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_11_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_11_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_17_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_11_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_13_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_d_11_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_17_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_09_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_11_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_09_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_09_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_13_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_11_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_11_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_11_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_13_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_d_11_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_d_11_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_d_11_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_11_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_11_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_09_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_13_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_11_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_17_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_17_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_11_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_17_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_d_11_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_09_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_11_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_11_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_09_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_11_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_13_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_13_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_15_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_13_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_17_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_11_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_13_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "li_dance_facedj_17_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_15_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_13_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_d_11_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_13_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_d_11_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_d_11_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_d_11_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_15_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_d_11_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_15_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_13_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_13_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_13_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_15_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_d_11_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_15_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_d_11_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_13_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_13_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_d_11_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_15_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_d_11_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_13_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_13_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_15_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_11_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_d_11_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_15_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_15_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_13_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_d_11_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_13_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_hu_15_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_17_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_15_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_d_11_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_15_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_13_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_09_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_11_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@low_intesnsity", anim = "li_dance_facedj_17_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_11_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_17_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_13_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_15_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_09_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_09_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_07_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_09_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_09_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_09_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_07_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_11_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_11_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_07_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_11_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_11_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_07_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_09_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_09_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_07_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_09_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_07_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_07_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_09_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_07_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_11_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_11_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_07_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_09_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_09_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_07_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_07_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_11_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_07_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_09_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_09_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_09_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_07_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_07_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_09_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_09_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_09_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_09_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_09_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_09_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_09_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_09_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_11_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_09_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_09_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_09_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_09_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_11_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_07_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_07_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_09_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_09_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_07_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_09_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_07_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_07_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_09_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_09_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_09_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_09_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_11_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_07_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_11_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_11_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_07_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_09_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_09_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_07_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_09_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_07_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_09_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_09_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_07_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_07_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_09_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_07_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_07_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_07_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_11_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_09_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_09_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_07_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_07_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_11_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_09_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_mi_09_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_09_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_07_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_07_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_07_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_09_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_11_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_li_09_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_li_09_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_07_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_07_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_li_to_hi_07_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_hi_to_mi_11_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@", anim = "trans_dance_facedj_mi_to_hi_09_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_hi_intensity", anim = "trans_dance_facedj_hi_to_mi_11_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_low_intensity", anim = "trans_dance_facedj_li_to_mi_11_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_mi_to_li_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_11_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_17_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "li_dance_crowd_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "hi_dance_crowd_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_mi_to_hi_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_li_to_mi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_hi_to_li_07_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_li_to_hi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_hi_to_li_07_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "hi_dance_crowd_17_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_li_to_hi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "li_dance_crowd_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_11_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "li_dance_crowd_11_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_mi_to_hi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "hi_dance_crowd_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "li_dance_crowd_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_hi_to_mi_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_mi_to_li_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "hi_dance_crowd_15_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "hi_dance_crowd_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_15_v1_prop_npc_phone^heel"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_mi_to_hi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "li_dance_crowd_11_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_15_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "li_dance_crowd_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "li_dance_crowd_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "hi_dance_crowd_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "hi_dance_crowd_17_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "hi_dance_crowd_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "hi_dance_crowd_11_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "hi_dance_crowd_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "hi_dance_crowd_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_mi_to_li_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "li_dance_crowd_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "hi_dance_crowd_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_li_to_hi_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_li_to_mi_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "li_dance_crowd_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "li_dance_crowd_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "li_dance_crowd_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "hi_dance_crowd_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_mi_to_li_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_hi_to_li_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_li_to_hi_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "hi_dance_crowd_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "li_dance_crowd_17_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "li_dance_crowd_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "hi_dance_crowd_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_hi_to_mi_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_15_v1_prop_npc_phone^flat"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "li_dance_crowd_15_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "li_dance_crowd_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_hi_to_mi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "hi_dance_crowd_15_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_mi_to_hi_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_li_to_mi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_hi_to_mi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "li_dance_crowd_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "li_dance_crowd_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_hi_to_li_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "hi_dance_crowd_11_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "trans_dance_crowd_li_to_mi_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_17_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "hi_dance_crowd_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "li_dance_crowd_15_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_15_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "li_dance_crowd_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "mi_dance_crowd_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "hi_dance_crowd_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "li_dance_crowd_17_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupa@", anim = "hi_dance_crowd_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_11_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_13_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_17_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_11_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_li_to_mi_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_li_to_mi_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_17_v1_prop_npc_phone^heel"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_li_to_mi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_li_to_hi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_hi_to_li_07_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_15_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_17_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_17_v1_prop_npc_phone^heel"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_13_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_17_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_09_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_13_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_mi_to_hi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_09_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_17_v1_prop_npc_phone^heel"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_mi_to_li_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_15_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_13_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_11_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_17_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_11_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_15_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_11_v2_ba_prop_battle_vape_01^heel", disabled = true},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_11_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_15_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_hi_to_mi_09_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_09_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_15_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_13_v2_prop_npc_phone^heel", disabled = true},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_17_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_mi_to_li_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_mi_to_li_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_hi_to_li_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_15_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_hi_to_li_07_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_13_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_17_v1_prop_npc_phone^flat"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_13_v2_prop_npc_phone^flat"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_13_v2_prop_npc_phone^heel"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_mi_to_li_09_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_li_to_hi_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_li_to_hi_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_13_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_11_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_17_v1_prop_npc_phone^flat"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_11_v2_ba_prop_battle_vape_01^flat"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_hi_to_mi_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_15_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_11_v2_prop_npc_phone^heel"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_15_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_hi_to_mi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_15_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_li_to_hi_09_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_13_v2_prop_npc_phone^flat"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_mi_to_hi_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_15_v2_prop_npc_phone^flat"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_hi_to_li_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_17_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_li_to_mi_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_17_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_15_v2_prop_npc_phone^heel"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_11_v2_prop_npc_phone^flat"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "li_dance_crowd_17_v1_prop_npc_phone^flat"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "trans_dance_crowd_hi_to_mi_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "mi_dance_crowd_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupb@", anim = "hi_dance_crowd_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_mi_to_li_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_li_to_mi_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_15_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "li_dance_crowd_15_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "li_dance_crowd_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_hi_to_li_07_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_li_to_hi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_11_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "li_dance_crowd_11_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_hi_to_mi_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_hi_to_mi_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_15_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_li_to_hi_09_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_09_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_mi_to_hi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "li_dance_crowd_11_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_hi_to_li_07_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "li_dance_crowd_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_13_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_17_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_17_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "li_dance_crowd_17_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "li_dance_crowd_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_li_to_hi_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_17_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_17_v1_prop_npc_phone"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_11_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_mi_to_li_11_v1_ba_prop_battle_vape_01"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_09_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_li_to_hi_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_17_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_15_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "li_dance_crowd_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_15_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_mi_to_hi_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "li_dance_crowd_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "li_dance_crowd_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "li_dance_crowd_15_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_mi_to_li_11_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_mi_to_li_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_hi_to_li_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_13_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_mi_to_li_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_13_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "li_dance_crowd_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_15_v1_prop_npc_phone"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_13_v1_prop_npc_phone", disabled = true},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_15_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_17_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "li_dance_crowd_09_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_hi_to_mi_09_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_li_to_mi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_11_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_hi_to_mi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_13_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_11_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_mi_to_li_11_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_17_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "li_dance_crowd_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "li_dance_crowd_15_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_mi_to_li_09_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "mi_dance_crowd_15_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "li_dance_crowd_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "li_dance_crowd_13_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "trans_dance_crowd_hi_to_li_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "li_dance_crowd_13_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupc@", anim = "hi_dance_crowd_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_hi_to_mi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_15_v2_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_17_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_mi_to_li_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_li_to_hi_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_11_v2_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_li_to_hi_09_v2_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_hi_to_li_09_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_09_v2_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_11_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_15_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_11_v2_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_15_v2_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_15_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_mi_to_li_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_li_to_mi_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_15_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_09_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_mi_to_hi_09_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_15_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_li_to_mi_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_15_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_mi_to_li_09_v2_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_hi_to_li_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_11_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_li_to_mi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_15_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_li_to_hi_09_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_mi_to_li_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_11_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_17_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_15_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_mi_to_li_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_15_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_17_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_hi_to_mi_09_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_09_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_hi_to_mi_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_15_v1ba_prop_battle_vape_01^heel"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_13_v2_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_17_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_hi_to_li_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_mi_to_li_11_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_09_v2_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_hi_to_mi_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_11_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_09_v2_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_li_to_mi_11_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_li_to_mi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_17_v2_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_15_v2_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_li_to_hi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_mi_to_hi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_17_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_13_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_mi_to_hi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_11_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_17_v2_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_13_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_li_to_hi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_11_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_11_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_15_v1ba_prop_battle_vape_01^flat"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_13_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_09_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_li_to_mi_09_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_13_v2_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_15_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_17_v1ba_prop_battle_vape_01^flat^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_hi_to_mi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_11_v2_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_13_v2_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_17_v1ba_prop_battle_vape_01^heel^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_17_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "hi_dance_crowd_11_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_hi_to_mi_09_v2_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_17_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "li_dance_crowd_11_v1_male_^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "trans_dance_crowd_li_to_hi_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_mi_to_hi_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_hi_to_mi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_17_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_mi_to_li_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_li_to_mi_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_li_to_hi_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_17_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_15_v2_prop_npc_phone^flat"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_15_v1_prop_npc_phone^flat"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_15_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_li_to_hi_09_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_13_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_15_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_15_v1_prop_npc_phone^heel"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_17_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_li_to_mi_09_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_15_v2_prop_npc_phone^heel"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_mi_to_li_09_v2_female^1", disabled = true},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_mi_to_li_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_17_v1_prop_npc_phone^flat", disabled = true},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_15_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_li_to_mi_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_15_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_11_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_hi_to_mi_09_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_17_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_15_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_li_to_hi_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_15_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_li_to_mi_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_15_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_hi_to_li_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_11_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_li_to_mi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_mi_to_li_11_v1_prop_npc_phone^heel"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_li_to_mi_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_15_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_15_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_mi_to_li_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_13_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_11_v2_prop_npc_phone^heel", disabled = true},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_mi_to_li_09_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_11_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_11_v2_prop_npc_phone^flat", disabled = true},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_mi_to_li_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_17_v1_prop_npc_phone^heel"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_15_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_hi_to_li_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_13_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_13_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_hi_to_mi_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_hi_to_li_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_11_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_hi_to_mi_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_13_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_mi_to_li_11_v1_prop_npc_phone^flat"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_li_to_mi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_li_to_hi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_mi_to_hi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_17_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_17_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_13_v1_prop_npc_phone^flat"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_mi_to_hi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_11_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_li_to_hi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_13_v1_prop_npc_phone^heel"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_11_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_11_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_li_to_mi_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_09_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_li_to_mi_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_15_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_11_v2_prop_npc_phone^flat"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_09_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_15_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_09_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_hi_to_mi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_09_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_13_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_11_v2_prop_npc_phone^heel", disabled = true},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_11_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_17_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_17_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "hi_dance_crowd_11_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_17_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_hi_to_mi_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "mi_dance_crowd_17_v1_prop_npc_phone^flat"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "li_dance_crowd_17_v1_prop_npc_phone^heel"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@groupe@", anim = "trans_dance_crowd_li_to_hi_09_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v1_vape"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v1_mobile"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v1_mobile_heel"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v1_gropub_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v1_gropub_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v1_vap_heel", disabled = true},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_groups@low_intensity", anim = "li_dance_crowd_15_v1_vape_heel"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_17_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_11_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_11_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_11_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_11_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_17_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_17_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_11_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_11_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_11_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_17_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_17_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_17_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_09_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_09_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_09_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_09_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_17_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_17_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_17_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_17_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_17_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_09_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_09_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_09_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_09_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_15_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_15_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_15_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_15_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_15_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_09_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_09_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_09_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_09_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_17_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_17_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_17_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_17_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_17_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_11_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_11_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_11_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_11_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v2_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v2_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_11_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_11_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v2_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v2_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v2_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v2_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_11_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_11_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_15_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_15_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_15_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_17_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_15_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_17_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_17_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_17_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_17_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_17_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_15_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_09_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_09_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_09_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_17_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_17_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_17_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_09_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_17_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_17_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_17_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_15_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_15_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_15_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_15_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_15_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v2_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_13_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_15_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_15_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_15_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_15_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_15_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_15_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_15_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_15_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_15_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_15_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_09_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_09_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_09_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_09_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_15_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_15_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_11_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_15_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_15_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_15_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_15_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_11_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_11_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_11_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_11_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_09_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_17_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_17_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_17_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_17_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_15_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_09_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_09_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_09_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_11_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_11_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_11_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_11_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "hi_dance_prop_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v2_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v2_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v2_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v2_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "li_dance_prop_13_v2_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_li_11_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_mi_11_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_li_11_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_li_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_11_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_11_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_li_09_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_li_09_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_mi_11_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_09_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_hi_07_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_hi_07_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_li_09_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_09_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_li_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_li_11_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_li_11_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_li_09_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_09_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_09_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_11_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_li_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_09_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_hi_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_mi_11_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_li_09_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_mi_11_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_hi_11_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_09_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_li_09_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_li_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_hi_07_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_hi_11_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_li_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_hi_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_li_09_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_mi_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_09_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_li_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_hi_11_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_hi_07_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_mi_11_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_mi_11_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_li_11_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_11_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_hi_07_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_hi_11_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_11_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_li_09_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_hi_07_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_hi_11_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_09_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_hi_11_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_hi_07_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_hi_11_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_mi_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_09_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_li_09_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_hi_11_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_mi_11_v1_male^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_hi_07_v1_male^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_11_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_mi_11_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_li_11_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_09_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_hi_07_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_11_v1_female^3"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_hi_07_v1_male^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_11_v1_male^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_li_09_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_mi_11_v1_female^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_li_11_v1_female^5"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_li_11_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_hi_07_v1_male^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_hi_07_v1_male^2"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_hi_11_v1_female^6"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_mi_to_hi_11_v1_female^1"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_hi_to_mi_11_v1_female^4"},
    { dict = "anim@amb@nightclub_island@dancers@crowddance_single_props_transitions@", anim = "trans_dance_prop_li_to_mi_11_v1_male^1"},
}

RegisterNetEvent("police:currentHandCuffedState")
AddEventHandler("police:currentHandCuffedState", function(pIsHandcuffed, pIsHandcuffedAndWalking)
    isHandcuffed = pIsHandcuffed
    isSoftCuffed = pIsHandcuffedAndWalking
end)

function LoadAnimationDic(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(0)
        end
    end
end

RegisterNetEvent('np:dances:dance')
AddEventHandler('np:dances:dance', function(pDance)
    if not isHandcuffed and not isSoftCuffed then
        local noAnimations = #animations

        if pDance == -1 then
            pDance = math.random(noAnimations)
            print(("You randomly selected dance %s"):format(pDance))
        end

        if pDance > noAnimations or pDance <= 0 then
            TriggerEvent('DoLongHudText', ("There are only %s dances, select a number inbetween or random (no input)!"):format(noAnimations))
            return
        end

        if animations[pDance] and animations[pDance].disabled then
            TriggerEvent('DoLongHudText', "This dance is disabled.")
            return
        end

        LoadAnimationDic(animations[pDance].dict)
        TaskPlayAnim(PlayerPedId(), animations[pDance].dict, animations[pDance].anim, 3.0, 3.0, -1, 1, 0, 0, 0, 0)
    end
end)

-- Add weapons to the 'compatable_weapon_hashes' table below to make them show up on a player's back (can use GetHashKey(...) if you don't know the hash) --
local SETTINGS = {
    back_bone = 24816,
    x = 0.075,
    y = -0.15,
    z = -0.02,
    x_rotation = 0.0,
    y_rotation = 165.0,
    z_rotation = 0.0,
    compatable_weapon_hashes = {
      -- melee:
      --["prop_golf_iron_01"] = 1141786504, -- positioning still needs work
      ["w_me_bat"] = -1786099057,
      ["prop_ld_jerrycan_01"] = 883325847,
      -- assault rifles:
      ["w_ar_carbinerifle"] = -2084633992,
      ["w_ar_carbineriflemk2"] = GetHashKey("WEAPON_CARBINERIFLE_MK2"),
      ["w_ar_assaultrifle"] = -1074790547,
      ["w_ar_specialcarbine"] = -1063057011,
      ["w_ar_bullpuprifle"] = 2132975508,
      ["w_ar_advancedrifle"] = -1357824103,
      -- sub machine guns:
      ["w_sb_microsmg"] = 324215364,
      ["w_sb_assaultsmg"] = -270015777,
      ["w_sb_smg"] = 736523883,
      ["w_sb_smgmk2"] = GetHashKey("WEAPON_SMG_MK2"),
      ["w_sb_gusenberg"] = 1627465347,
      -- sniper rifles:
      ["w_sr_sniperrifle"] = 100416529,
      -- shotguns:
      ["w_sg_assaultshotgun"] = -494615257,
      ["w_sg_bullpupshotgun"] = -1654528753,
      ["w_sg_pumpshotgun"] = 487013001,
      ["w_ar_musket"] = -1466123874,
      ["w_sg_heavyshotgun"] = GetHashKey("WEAPON_HEAVYSHOTGUN"),
      -- ["w_sg_sawnoff"] = 2017895192 don't show, maybe too small?
      -- launchers:
      ["w_lr_firework"] = 2138347493
    }
}

local attached_weapons = {}

Citizen.CreateThread(function()
  while true do
      local me = GetPlayerPed(-1)
      ---------------------------------------
      -- attach if player has large weapon --
      ---------------------------------------
      for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
          if HasPedGotWeapon(me, wep_hash, false) then
              if not attached_weapons[wep_name] then
                  AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation, isMeleeWeapon(wep_name))
              end
          end
      end
      --------------------------------------------
      -- remove from back if equipped / dropped --
      --------------------------------------------
      for name, attached_object in pairs(attached_weapons) do
          -- equipped? delete it from back:
          if GetSelectedPedWeapon(me) ==  attached_object.hash or not HasPedGotWeapon(me, attached_object.hash, false) then -- equipped or not in weapon wheel
            DeleteObject(attached_object.handle)
            attached_weapons[name] = nil
          end
      end
  Wait(0)
  end
end)

function AttachWeapon(attachModel,modelHash,boneNumber,x,y,z,xR,yR,zR, isMelee)
	local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumber)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Wait(100)
	end

  attached_weapons[attachModel] = {
    hash = modelHash,
    handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)
  }

  if isMelee then x = 0.11 y = -0.14 z = 0.0 xR = -75.0 yR = 185.0 zR = 92.0 end -- reposition for melee items
  if attachModel == "prop_ld_jerrycan_01" then x = x + 0.3 end
	AttachEntityToEntity(attached_weapons[attachModel].handle, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

function isMeleeWeapon(wep_name)
    if wep_name == "prop_golf_iron_01" then
        return true
    elseif wep_name == "w_me_bat" then
        return true
    elseif wep_name == "prop_ld_jerrycan_01" then
      return true
    else
        return false
    end
end

-- Teleport Script
Teleports = Teleports or {}
Teleports.Locations = {
    [1] = {
        [1] = {x = 3540.74, y = 3675.59, z = 20.99, h = 167.5, r = 1.0},
        [2] = {x = 3540.74, y = 3675.59, z = 28.11, h = 172.5, r = 1.0},
    }
}
JustTeleported = false

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while true do
        local inRange = false
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        for loc,_ in pairs(Teleports.Locations) do
            for k, v in pairs(Teleports.Locations[loc]) do
                local dist = #(pos - vector3(v.x, v.y, v.z))
                if dist < 2 then
                    inRange = true
                    DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)

                    if dist < 1 then
                        DrawText3Ds(v.x, v.y, v.z, '[E] To Teleport')
                        if IsControlJustReleased(0, 51) then
                            if k == 1 then
                                SetEntityCoords(ped, Teleports.Locations[loc][2].x, Teleports.Locations[loc][2].y, Teleports.Locations[loc][2].z)
                            elseif k == 2 then
                                SetEntityCoords(ped, Teleports.Locations[loc][1].x, Teleports.Locations[loc][1].y, Teleports.Locations[loc][1].z)
                            end
                            ResetTeleport()
                        end
                    end
                end
            end
        end

        if not inRange then
            Citizen.Wait(1000)
        end

        Citizen.Wait(3)
    end
end)

ResetTeleport = function()
    SetTimeout(1000, function()
        JustTeleported = false
    end)
end

-- oHideFrames Script
Citizen.CreateThread(function()

    while true do

        Citizen.Wait(1)

        if not IsAimCamActive() or not IsFirstPersonAimCamActive() then
            HideHudComponentThisFrame(14)
        end

        if IsHudComponentActive(1) then 
            HideHudComponentThisFrame(1)
        end

        if IsHudComponentActive(6) then 
            HideHudComponentThisFrame(6)
        end

        if IsHudComponentActive(7) then 
            HideHudComponentThisFrame(7)
        end

        if IsHudComponentActive(9) then 
            HideHudComponentThisFrame(9)
        end

        if IsHudComponentActive(0) and not IsPedInAnyVehicle(GetPlayerPed( -1 ), true) then 
            HideHudComponentThisFrame(0)
        end


        if IsControlPressed(0,44) then
            DisplayHud(1)
        else
            DisplayHud(0)
        end


        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)

        SetPedMinGroundTimeForStungun(PlayerPedId(), 6000)
    end
end)

-- oHidePlayerNumbers Script
local hidden = {}
local showPlayerBlips = false
local ignorePlayerNameDistance = false
local disPlayerNames = 50
local playerSource = 0

function DrawText3D(x,y,z, text, textColor) -- some useful function, use it if you want!
    local color = { r = 255, g = 255, b = 255, alpha = 255 } -- Color of the text 
    if textColor ~= nil then 
        color = {r = textColor[1] or 255, g = textColor[2] or 255, b = textColor[3] or 255, alpha = textColor[4] or 255}
    end
    
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.3,0.3)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(color.r, color.g, color.b, color.alpha)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function DrawText3DTalking(x,y,z, text, textColor) -- some useful function, use it if you want!
    local color = { r = 220, g = 220, b = 220, alpha = 255 } -- Color of the text 
    if textColor ~= nil then 
        color = {r = textColor[1] or 22, g = textColor[2] or 55, b = textColor[3] or 155, alpha = textColor[4] or 255}
    end

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.0*scale, 0.75*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(color.r, color.g, color.b, color.alpha)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

RegisterNetEvent("hud:HidePlayer")
AddEventHandler("hud:HidePlayer", function(player, toggle)
    if type(player) == "table" then
        for k,v in pairs(player) do
            if DoesPlayerExist(k) then
                local id = GetPlayerFromServerId(k)
                hidden[id] = k
            end
        end
        return
    end
    if DoesPlayerExist(player) then
        local id = GetPlayerFromServerId(player)
        if toggle == true then
            hidden[id] = player
        else
            for k,v in pairs(hidden) do
                if v == player then hidden[k] = nil end
            end
        end
    end
end)

Controlkey = {["generalScoreboard"] = {303,"U"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
    Controlkey["generalScoreboard"] = table["generalScoreboard"]
end)


Citizen.CreateThread(function()
    while true do
        if IsControlPressed(0, Controlkey["generalScoreboard"][1]) then

            for i=0,255 do
                N_0x31698aa80e0223f8(i)
            end

            local playerped = PlayerPedId()
            local HeadBone = 0x796e

            for id = 0, 255 do
                if NetworkIsPlayerActive(id) then
                    local ped = GetPlayerPed(id)

                    local playerCoords = GetPedBoneCoords(playerped, HeadBone)

                    if ped == playerped then
                        DrawText3DTalking(playerCoords.x, playerCoords.y, playerCoords.z+0.5, " ".. GetPlayerServerId(id) .. " ", {152, 251, 152, 255})
                    else
                        local pedCoords = GetPedBoneCoords(ped, HeadBone)

                        local distance = math.floor(#(playerCoords - pedCoords))

                        local isDucking = IsPedDucking(ped)
                        local cansee = HasEntityClearLosToEntity(playerped, ped, 17 )
                        local isReadyToShoot = IsPedWeaponReadyToShoot(ped)
                        local isStealth = GetPedStealthMovement(ped)
                        local isDriveBy = IsPedDoingDriveby(ped)
                        local isInCover = IsPedInCover(ped,true)
                        if isStealth == nil then
                            isStealth = 0
                        end

                        if isDucking or isStealth == 1 or isDriveBy or isInCover then
                            cansee = false
                        end

                        if hidden[id] then cansee = false end

                        if (distance < disPlayerNames) then
                            if(NetworkIsPlayerTalking(id)) then                            
                                if cansee then
                                    DrawText3DTalking(pedCoords.x, pedCoords.y, pedCoords.z+0.5, " ".. GetPlayerServerId(id) .. " ", {22, 55, 155, 255})
                                end
                            else
                                if cansee then
                                    DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z+0.5, " ".. GetPlayerServerId(id) .. " ", {255, 255, 255, 255})
                                end
                            end
                        end
                    end                        
                end
            end
            Citizen.Wait(1)
        else
            Citizen.Wait(2000)
        end        
    end
end)

-- oCam Script
local INPUT_AIM = 0
local INPUT_AIM = 0
local UseFPS = false
local justpressed = 0

-- this prevents certain camera modes
local disable = 0
Citizen.CreateThread( function()

  while true do    
    
    Citizen.Wait(1)


        if IsControlPressed(0, INPUT_AIM) then
          justpressed = justpressed + 1
        end

        if IsControlJustReleased(0, INPUT_AIM) then

        	if justpressed < 15 then
        		UseFPS = true
        	end
        	justpressed = 0
        end

        if GetFollowPedCamViewMode() == 1 or GetFollowVehicleCamViewMode() == 1 then
        	Citizen.Wait(1)
        	SetFollowPedCamViewMode(0)
        	SetFollowVehicleCamViewMode(0)
        end


        if UseFPS then
        	if GetFollowPedCamViewMode() == 0 or GetFollowVehicleCamViewMode() == 0 then
        		Citizen.Wait(1)
        		
        		SetFollowPedCamViewMode(4)
        		SetFollowVehicleCamViewMode(4)
        	else
        		Citizen.Wait(1)
        		
        		SetFollowPedCamViewMode(0)
        		SetFollowVehicleCamViewMode(0)
        	end
    		UseFPS = false
        end


        if IsPedArmed(ped,1) or not IsPedArmed(ped,7) then
            if IsControlJustPressed(0,24) or IsControlJustPressed(0,141) or IsControlJustPressed(0,142) or IsControlJustPressed(0,140)  then
               disable = 50
            end
        end

        if disable > 0 then
            disable = disable - 1
            DisableControlAction(0,24)
            DisableControlAction(0,140)
            DisableControlAction(0,141)
            DisableControlAction(0,142)
        end
  end

end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsPedArmed(PlayerPedId(), 6) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        else
            Citizen.Wait(1500)
        end
    end
end)

-- oStress Script
local stresslevel = 0
local isBlocked = false

RegisterNetEvent("client:updateStress")
AddEventHandler("client:updateStress",function(newStress)
    stresslevel = newStress
end)

RegisterNetEvent("client:blockShake")
AddEventHandler("client:blockShake",function(isBlockedInfo)
    isBlocked = isBlockedInfo
end)


RegisterNetEvent("npc-admin:currentDevmode")
AddEventHandler("npc-admin:currentDevmode", function(devmode)
    isBlocked = devmode
end)

Citizen.CreateThread(function()
    while true do
        if not isBlocked then
            if stresslevel > 7500 then
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
            elseif stresslevel > 4500 then
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.07)
            elseif stresslevel > 2000 then
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.02)
            end
        end 
        Citizen.Wait(2000)
    end
end)

-- oStress Script
local stresslevel = 0
local isBlocked = false

RegisterNetEvent("client:updateStress")
AddEventHandler("client:updateStress",function(newStress)
    stresslevel = newStress
end)

RegisterNetEvent("client:blockShake")
AddEventHandler("client:blockShake",function(isBlockedInfo)
    isBlocked = isBlockedInfo
end)


RegisterNetEvent("npc-admin:currentDevmode")
AddEventHandler("npc-admin:currentDevmode", function(devmode)
    isBlocked = devmode
end)

Citizen.CreateThread(function()
    while true do
        if not isBlocked then
            if stresslevel > 7500 then
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
            elseif stresslevel > 4500 then
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.07)
            elseif stresslevel > 2000 then
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.02)
            end
        end 
        Citizen.Wait(2000)
    end
end)

-- Rehab Script
local groundCoords = {
    {-1517.29,852.89,181.6}, 
    { -1564.5,775.2,189.2},
    { -1572.18,771.74,189.2},
    { -1581.47,788.57,189.2},
    { -1579.19,815.84,186.0},
}

local restrictionCoords = {
    [1] =  { ['x'] = -1512.66,['y'] = 863.0,['z'] = 181.9,['r'] = 80.0},
    [2] =  { ['x'] = -1594.4,['y'] = 765.59,['z'] = 189.2,['r'] = 36.0},
    [3] =  { ['x'] = -1576.23,['y'] = 815.9,['z'] = 185.99,['r'] = 60.0},
}

local placement = 0
local isInRehab = false
RegisterNetEvent('beginJailRehab')
AddEventHandler('beginJailRehab', function(isInRehabSent)
    isInRehab = isInRehabSent
    local rnd = math.random(1,5)
    placement = rnd
    TriggerEvent("DensityModifierEnable",false)
    TriggerEvent("DoLongHudText", "You are on a mental hold.",1)
    Citizen.Wait(1000)
    SetEntityCoords(PlayerPedId(),groundCoords[placement][1],groundCoords[placement][2],groundCoords[placement][3]) 
    TriggerEvent("falseCuffs")  
    DoScreenFadeIn(1500)
    if isInRehab then
        while isInRehab do
            Citizen.Wait(1000)
            RemoveAllPedWeapons(PlayerPedId())
            TriggerEvent("attachWeapons")
            local inside = false
            for k,v in pairs(restrictionCoords) do
                if #(GetEntityCoords(PlayerPedId()) - vector3(v.x,v.y,v.z)) < v.r then
                    inside = true
                end
            end

            if not inside then
                TriggerEvent("DoLongHudText", "The orderly have placed you back into the facility for protection.",1)
                SetEntityCoords(PlayerPedId(), groundCoords[placement][1],groundCoords[placement][2],groundCoords[placement][3]) 
            end

            if placement == 0 then break end
        end
    else
        placement = 0
    end

    TriggerEvent("DoLongHudText", "You were removed from Mental health care.",1)
    SetEntityCoords(PlayerPedId(), -1475.86,884.47,182.93)

    TriggerEvent("DensityModifierEnable",true)
end)

RegisterNetEvent('rehab:changeCharecter')
AddEventHandler('rehab:changeCharecter', function()
   isInRehab = false
end)

-- Particles Script
local particleEffects = {}

local particleList = {
    ["vehExhaust"] = {["dic"] = "core",["name"] = "veh_exhaust_truck_rig",["loopAmount"] = 25,["timeCheck"] = 12000},
    ["lavaPour"] = {["dic"] = "core",["name"] = "ent_amb_foundry_molten_pour",["loopAmount"] = 1,["timeCheck"] = 12000},
    ["lavaSteam"] = {["dic"] = "core",["name"] = "ent_amb_steam_pipe_hvy",["loopAmount"] = 1,["timeCheck"] = 12000},
    ["spark"] = {["dic"] = "core",["name"] = "ent_amb_sparking_wires",["loopAmount"] = 1,["timeCheck"] = 12000},
    ["smoke"] = {["dic"] = "core",["name"] = "exp_grd_grenade_smoke",["loopAmount"] = 1,["timeCheck"] = 12000},
    ["test"] = {["dic"] = "core",["name"] = "ent_amb_steam_pipe_hvy",["loopAmount"] = 1,["timeCheck"] = 12000}
}

RegisterNetEvent("particle:StartClientParticle")
AddEventHandler("particle:StartClientParticle", function(x,y,z,particleId,allocatedID,rX,rY,rZ)
  if #(vector3(x,y,z) - GetEntityCoords(PlayerPedId())) < 100 then

    local particleDictionary = particleList[particleId].dic
    local particleName = particleList[particleId].name
    local loopAmount = particleList[particleId].loopAmount

   if not HasNamedPtfxAssetLoaded(particleDictionary) then
        RequestNamedPtfxAsset(particleDictionary)
        while not HasNamedPtfxAssetLoaded(particleDictionary) do
            Wait(1)
        end
    end

    for i=0,loopAmount do
        --UseParticleFxAssetNextCall(particleDictionary)
        SetPtfxAssetNextCall(particleDictionary)
       local particle =  StartParticleFxLoopedAtCoord(particleName, x, y, z, rX,rY,rZ, 1.0, false, false, false, false)

        local object = {["particle"] = particle,["id"] = allocatedID}
        particleEffects[#particleEffects+1]=object
        Citizen.Wait(0)
    end
  
  end
end)

RegisterNetEvent("particle:StopParticleClient")
AddEventHandler("particle:StopParticleClient", function(allocatedID)
   for j,particle in pairs(particleEffects) do
        if allocatedID == particle.id then
            RemoveParticleFx(particle.particle, true)
        end
    end
end)

-- Gym Script
workoutAreas = {
  [1] = { ["x"] = -1196.9790039063,["y"] = -1572.8973388672,["z"] = 4.6126470565796, ["h"] = 211.11492919922, ["workType"] = "Weights", ["emote"] = "weights" },
  [2] = { ["x"] = -1199.0599365234,["y"] = -1574.4929199219,["z"] = 4.6096420288086, ["h"] = 213.6491394043, ["workType"] = "Weights", ["emote"] = "weights" },
  [3] = { ["x"] = -1200.5871582031,["y"] = -1577.504516601,["z"] = 4.6084971427918, ["h"] = 312.37738037109, ["workType"] = "Pushups", ["emote"] = "pushUps" },
  [4] = { ["x"] = -1196.0134277344,["y"] = -1567.369140625,["z"] = 4.6165833473206, ["h"] = 308.9084777832, ["workType"] = "Situps", ["emote"] = "situps" },
  [5] = { ["x"] = -1215.0224609375,["y"] = -1541.6857910156,["z"] = 4.7281851768494, ["h"] = 119.79830169678, ["workType"] = "Yoga", ["emote"] = "Yoga" },
  [6] = { ["x"] = -1217.5916748047,["y"] = -1543.162109375,["z"] = 4.7207465171814, ["h"] = 119.81834411621, ["workType"] = "Yoga", ["emote"] = "yoga" },
  [7] = { ["x"] = -1220.8453369141,["y"] = -1545.0277099609,["z"] = 4.6919565200806, ["h"] = 119.8260345459, ["workType"] = "Yoga", ["emote"] = "yoga" },
  [8] = { ["x"] = -1224.6988525391,["y"] = -1547.2470703125,["z"] = 4.6254777908325, ["h"] = 119.86821746826, ["workType"] = "Yoga", ["emote"] = "yoga" },
  [9] = { ["x"] = -1228.4945068359,["y"] = -1549.4294433594,["z"] = 4.5562300682068, ["h"] = 119.87698364258, ["workType"] = "Yoga", ["emote"] = "yoga" },
  [10] =  { ['x'] = -1253.41,['y'] = -1601.65,['z'] = 3.15,['h'] = 213.34, ['info'] = ' Chinups 1', ["workType"] = "Chinups", ["emote"] = "chinups" },
  [11] =  { ['x'] = -1252.43,['y'] = -1603.14,['z'] = 3.13,['h'] = 213.78, ['info'] = ' Chinups 2', ["workType"] = "Chinups", ["emote"] = "chinups" },
  [12] =  { ['x'] = -1251.26,['y'] = -1604.81,['z'] = 3.14,['h'] = 217.94, ['info'] = ' Chinups 3', ["workType"] = "Chinups", ["emote"] = "chinups" },

}
local inprocess = false
local returnedPass = false
local workoutType = 0

RegisterNetEvent('event:control:gym')
AddEventHandler('event:control:gym', function(useID)
  if not inprocess then
    returnedPass = false
    workoutType = useID
   -- TriggerServerEvent("server:pass","gym")
    TriggerEvent("doworkout")
  end
end)


function DrawText3DTest(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end


Citizen.CreateThread(function()
    while true do
      local playerped = PlayerPedId()
      local plyCoords = GetEntityCoords(playerped)        
      local waitCheck2 = #(GetEntityCoords( PlayerPedId() ) - vector3(-1253.41,-1601.65,4.556230068206))
      local waitCheck = #(GetEntityCoords( PlayerPedId() ) - vector3(-1228.4945068359,-1549.4294433594,4.556230068206))
      if (waitCheck > 40.0 and waitCheck2 > 40.0 ) or inprocess then
        Citizen.Wait(math.ceil(waitCheck))
      else
        Citizen.Wait(1)
        for i = 1, #workoutAreas do
          local distCheck = #(GetEntityCoords( PlayerPedId() ) - vector3(workoutAreas[i]["x"], workoutAreas[i]["y"], workoutAreas[i]["z"]))
          if distCheck < 4.0 then
            DrawText3DTest(workoutAreas[i]["x"], workoutAreas[i]["y"], workoutAreas[i]["z"], "[E] to do " .. workoutAreas[i]["workType"] .. "" )
          end
        end
      end
    end
end)

RegisterNetEvent('doworkout')
AddEventHandler('doworkout', function()
    inprocess = true
    SetEntityCoords(PlayerPedId(),workoutAreas[workoutType]["x"],workoutAreas[workoutType]["y"],workoutAreas[workoutType]["z"])
    SetEntityHeading(PlayerPedId(),workoutAreas[workoutType]["h"])
    TriggerEvent("animation:PlayAnimation",workoutAreas[workoutType]["emote"])
    Citizen.Wait(30000)
    TriggerEvent("client:newStress",false,math.ceil(450))
    TriggerEvent("animation:PlayAnimation","cancel")
    inprocess = false
end)

-- Recycle Script
local RecyclePoints = {
	{1015.4642333984,-3110.4521484375,-38.99991607666,["time"] = 0,["used"] = false},  
	{1011.2679443359,-3110.8725585938,-38.99991607666,["time"] = 0,["used"] = false},  
	{1005.8571777344,-3110.6271972656,-38.99991607666,["time"] = 0,["used"] = false},  
	{995.37841796875,-3108.6293945313,-38.99991607666,["time"] = 0,["used"] = false}, 
	{1003.0407104492,-3104.7854003906,-38.999881744385,["time"] = 0,["used"] = false}, 
	{1008.2990112305,-3106.94140625,-38.999881744385,["time"] = 0,["used"] = false},  
	{1010.9890136719,-3104.5573730469,-38.999881744385,["time"] = 0,["used"] = false},  
	{1013.3607788086,-3106.8874511719,-38.999881744385,["time"] = 0,["used"] = false},  
	{1017.8317260742,-3104.5822753906,-38.999881744385,["time"] = 0,["used"] = false}, 
	{1019.0430297852,-3098.9851074219,-38.999881744385,["time"] = 0,["used"] = false}, 
	{1013.7381591797,-3100.9680175781,-38.999881744385,["time"] = 0,["used"] = false}, 
	{1009.3251342773,-3098.8120117188,-38.999881744385,["time"] = 0,["used"] = false},  
	{1005.9111938477,-3100.9387207031,-38.999881744385,["time"] = 0,["used"] = false}, 
	{1003.2393798828,-3093.9182128906,-38.999885559082,["time"] = 0,["used"] = false}, 
	{1008.0280151367,-3093.384765625,-38.999885559082,["time"] = 0,["used"] = false}, 
	{1010.8000488281,-3093.544921875,-38.999885559082,["time"] = 0,["used"] = false}, 
	{1016.1090087891,-3095.3405761719,-38.999885559082,["time"] = 0,["used"] = false},  
	{1018.2312011719,-3093.1293945313,-38.999885559082,["time"] = 0,["used"] = false},  
	{1025.1221923828,-3091.4680175781,-38.999885559082,["time"] = 0,["used"] = false}, 
	{1024.9321289063,-3096.4670410156,-38.999885559082,["time"] = 0,["used"] = false}, 
}

local dropPoints = {
	{1001.375,-3108.3840332031,-38.999900817871},
	{997.32006835938,-3099.3923339844,-38.999900817871},
	{1022.0564575195,-3095.892578125,-38.999855041504},
	{1022.1699829102,-3106.6181640625,-38.999855041504},
}

RegisterNetEvent('missionSystem:updatePoints')
AddEventHandler('missionSystem:updatePoints', function(result)
	RecyclePoints = result
end)
-----------------------------
-- Metal Harvest
-----------------------------
isRunningCrate = false

function runRecycle()
	isRunningCrate = true
	local isHolding = false

	TriggerEvent("attachItem","crate01")
    RequestAnimDict("anim@heists@box_carry@")
    TaskPlayAnim(GetPlayerPed(-1),"anim@heists@box_carry@","idle",2.0, -8, 180, 49, 0, 0, 0, 0)
    Wait(1000)
    TaskPlayAnim(GetPlayerPed(-1),"anim@heists@box_carry@","idle",2.0, -8, 180000000, 49, 0, 0, 0, 0)
	TriggerEvent("animation:disable", true)
	TriggerEvent("AnimSet:default")
    isHolding = true
    local rnd = math.random(1,4)

    while isHolding do
    	Wait(0)
    	if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),dropPoints[rnd][1],dropPoints[rnd][2],dropPoints[rnd][3], true) <= 40 then
    		DrawText3Ds(dropPoints[rnd][1],dropPoints[rnd][2],dropPoints[rnd][3], "[E] Drop Material")
    		if IsControlJustPressed(1, 38) and IsPedInAnyVehicle(GetPlayerPed(-1), false) ~= 1 then
	    		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),dropPoints[rnd][1],dropPoints[rnd][2],dropPoints[rnd][3], true) <= 3 then
	    			isHolding = false
	    		end
			end
			if IsPedRunning(PlayerPedId()) then
				SetPedToRagdoll(PlayerPedId(),2000,2000, 3, 0, 0, 0)
				Wait(2100)
				TaskPlayAnim(GetPlayerPed(-1),"anim@heists@box_carry@","idle",2.0, -8, 180000000, 49, 0, 0, 0, 0)
			end
    	end
    end

    ClearPedTasks(GetPlayerPed(-1))
    TriggerEvent("destroyProp")
    FreezeEntityPosition(GetPlayerPed(-1),true)
    RequestAnimDict("mp_car_bomb")
    TaskPlayAnim(GetPlayerPed(-1),"mp_car_bomb","car_bomb_mechanic",2.0, -8, 180,49, 0, 0, 0, 0)
    Wait(100)
    TaskPlayAnim(GetPlayerPed(-1),"mp_car_bomb","car_bomb_mechanic",2.0, -8, 1800000,49, 0, 0, 0, 0)
    Wait(3000)
    ClearPedTasks(GetPlayerPed(-1))
    FreezeEntityPosition(GetPlayerPed(-1),false)

    if math.random(1,5) == 2 then
    	TriggerEvent('player:receiveItem',"recyclablematerial", math.random(1,3))
    else
    	TriggerEvent('player:receiveItem',"recyclablematerial", 1)
	end

	TriggerEvent("DoLongHudText","Nice work, keep it up!")
	TriggerEvent("animation:disable", false)
    isRunningCrate = false
--	end
end

isTrading = false
isFishing = false

Citizen.CreateThread(function()

	while true do
		Wait(5)
		local PlayerPos = GetEntityCoords(PlayerPedId())
		
		for k,v in pairs(RecyclePoints) do
			if GetDistanceBetweenCoords(PlayerPos, v[1],v[2],v[3], true) <= 3 and not v.used and not isRunningCrate then
				DrawText3Ds(v[1],v[2],v[3], "Material, Pickup with E")
			end
		end
		
		if IsControlJustPressed(1, 38) and IsPedInAnyVehicle(GetPlayerPed(-1), false) ~= 1 then
			for k,v in pairs(RecyclePoints) do
				if GetDistanceBetweenCoords(PlayerPos, v[1],v[2],v[3], true) <= 2 then
					if not v.used and not isRunningCrate then
						v.used = true
						TriggerServerEvent('missionSystem:UpdateClients',RecyclePoints,k)
						runRecycle()
					end
				end
			end
			
			Wait(2500)

		end

	end

end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

-- Storage Script
local stringType = type("")
local intType = math.type(1)
local floatType = math.type(1.0)
local vector2Type = type(vector2(11.11,11.11))
local vector3Type = type(vector3(11.11,11.11,11.11))
local vector4Type = type(vector4(11.11,11.11,11.11,11.11))
local tableT = {}
local tableType = type(tableT)

function getStorage(storageType,key)

    local typeUsed = type(storageType)
    local ignoreString = false
    if storageType == "vector2" or storageType == "vector3" or storageType == "vector4" or storageType == "table" then ignoreString = true end

    if typeUsed == "number" then
        -- Interger
        if math.type(storageType) == intType then
            return GetResourceKvpInt(key)

        -- Float
        elseif math.type(storageType) == floatType then
            return GetResourceKvpFloat(key)

        else
            print("[Storage] - [Error] - [Failed to find data type] - x1")
        end
    else
        -- String
        if typeUsed == stringType and not ignoreString then
            return GetResourceKvpString(key)

        -- Vector 2
        elseif typeUsed == vector2Type or storageType == "vector2" then
            local vec2 = vector2(
                GetResourceKvpFloat("Vec2_["..key.."]_X"),
                GetResourceKvpFloat("Vec2_["..key.."]_Y")
            )
            return vec2

        -- Vector 3 
        elseif typeUsed == vector3Type or storageType == "vector3" then
            local vec3 = vector3(
                GetResourceKvpFloat("Vec3_["..key.."]_X"),
                GetResourceKvpFloat("Vec3_["..key.."]_Y"),
                GetResourceKvpFloat("Vec3_["..key.."]_Z")
            )
            return 

        -- Vector 4 
        elseif typeUsed == vector4Type or storageType == "vector4" then
            local vec4 = vector4(
                GetResourceKvpFloat("Vec4_["..key.."]_X"),
                GetResourceKvpFloat("Vec4_["..key.."]_Y"),
                GetResourceKvpFloat("Vec4_["..key.."]_Z"),
                GetResourceKvpFloat("Vec4_["..key.."]_W")
            )
            return vec4

        -- Tables
        elseif typeUsed == tableType or storageType == "table" then
            local result = json.decode(GetResourceKvpString("Json_"..key))
            return result


        else
            print("[Storage] - [Error] - [Failed to find data type] - x2")
        end
    end

end


function set(value,key)

    local typeUsed = type(value)
    local ignoreString = false

    if typeUsed == "number" then
        -- Interger
        if math.type(value) == intType then
            SetResourceKvpInt("IsSet_"..key,1)
            SetResourceKvpInt(key,value)

        -- Float
        elseif math.type(value) == floatType then
            SetResourceKvpInt("IsSet_"..key,1)
            SetResourceKvpFloat(key, value)

        else
            print("[Storage] - [Error] - [Failed to find data type] - x3")
        end
    else
        -- String
        if typeUsed == stringType then
            SetResourceKvpInt("IsSet_"..key,1)
            SetResourceKvp(key, value)

        -- Vector 2
        elseif typeUsed == vector2Type then
            SetResourceKvpInt("IsSet_"..key,1)
            SetResourceKvpFloat("Vec2_["..key.."]_X", value.x)
            SetResourceKvpFloat("Vec2_["..key.."]_Y", value.y)

        -- Vector 3
        elseif typeUsed == vector3Type then
            SetResourceKvpInt("IsSet_"..key,1)
            SetResourceKvpFloat("Vec3_["..key.."]_X", value.x)
            SetResourceKvpFloat("Vec3_["..key.."]_Y", value.y)
            SetResourceKvpFloat("Vec3_["..key.."]_Z", value.z)

        -- Vector 4
        elseif typeUsed == vector4Type then
            SetResourceKvpInt("IsSet_"..key,1)
            SetResourceKvpFloat("Vec4_["..key.."]_X", value.x)
            SetResourceKvpFloat("Vec4_["..key.."]_Y", value.y)
            SetResourceKvpFloat("Vec4_["..key.."]_Z", value.z)
            SetResourceKvpFloat("Vec4_["..key.."]_W", value.w)

        -- Table
        elseif typeUsed == tableType then
            local jsonValue = json.encode(value)
            SetResourceKvpInt("IsSet_"..key,1)
            SetResourceKvp("Json_"..key, jsonValue)

        else
            print("[Storage] - [Error] - [Failed to find data type] - x4")
        end
    end

end


function remove(key)
    DeleteResourceKvp(key)
end

function tryGet(storageType,key)

    if getStorage(1,"IsSet_"..key) ~= 0 then
        return getStorage(storageType,key)
    end

    return false
end

-- Strip Sclub Script
local StripClubLocs = {
	[1] = { ["x"] = 129.55972290039, ["y"] = -1284.0889892578, ["z"] = 29.273847579956, ["h"] = 330.01126098633, ["name"] = "None", ["fnc"] = "RandomNPC" },
	[2] = { ["x"] = 110.08145141602, ["y"] = -1288.5372314453, ["z"] = 28.858728408813, ["h"] = 294.58892822266, ["name"] = "None", ["fnc"] = "RandomNPC" },
	[3] = { ["x"] = 118.07534790039, ["y"] = -1285.3544921875, ["z"] = 28.271654129028, ["h"] = 41.357799530029, ["name"] = "None", ["fnc"] = "RandomNPC" },
	[4] = { ["x"] = 118.07534790039, ["y"] = -1285.3544921875, ["z"] = 28.271654129028, ["h"] = 41.357799530029, ["name"] = "None", ["fnc"] = "RandomNPC" },
	[5] = { ["x"] = 110.87651062012, ["y"] = -1302.2821044922, ["z"] = 29.269477844238, ["h"] = 208.04776000977, ["name"] = "None", ["fnc"] = "privDance" },
	[6] = { ["x"] = 114.60884857178, ["y"] = -1304.6392822266, ["z"] = 29.269529342651, ["h"] = 26.301788330078, ["name"] = "None", ["fnc"] = "privDance" },
	[7] = { ["x"] = 112.65658569336, ["y"] = -1301.2724609375, ["z"] = 29.269222259521, ["h"] = 210.32331848145, ["name"] = "None", ["fnc"] = "privDance" },
	[8] = { ["x"] = 116.68322753906, ["y"] = -1303.419921875, ["z"] = 29.269504547119, ["h"] = 27.763551712036, ["name"] = "None", ["fnc"] = "privDance" },
	[9] = { ["x"] = 114.65414428711, ["y"] = -1300.1513671875, ["z"] = 29.268930435181, ["h"] = 202.61317443848, ["name"] = "None", ["fnc"] = "privDance" },
	[10] = { ["x"] = 118.77919006348, ["y"] = -1302.2064208984, ["z"] = 29.269376754761, ["h"] = 23.350383758545, ["name"] = "None", ["fnc"] = "privDance" },
	[11] = { ["x"] = 112.7876739502, ["y"] = -1305.6854248047, ["z"] = 29.264095306396, ["h"] = 27.397647857666, ["name"] = "None", ["fnc"] = "privDance" },
}

function DrawText3DTest(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

local StressRelief = false
RegisterNetEvent('stripclub:stressLoss');
AddEventHandler('stripclub:stressLoss', function(switchon)
	local frntDist = #(vector3(130.26553344727,-1301.1790771484,29.232746124268) - GetEntityCoords(PlayerPedId()))
	if frntDist < 50 then
	    if switchon then
	    	TriggerServerEvent("server:pass","strip_club")
	    else
	    	StressRelief = false
	    end
	end
end)
RegisterNetEvent('dostripstress');
AddEventHandler('dostripstress', function()
	StressRelief = true
	Citizen.Trace("no stress")
end)

Citizen.CreateThread( function()

	local scanned = false
	local scanwait = 0

	while true do 

		Citizen.Wait(1)
		if StressRelief then
			if math.random(1000) > 998 then
				TriggerEvent("client:newStress",false,math.random(200,1250))
			end
		end

		local frntDist = #(vector3(130.26553344727,-1301.1790771484,29.232746124268) - GetEntityCoords(PlayerPedId()))
		local bkDist = #(vector3(92.162353515625,-1282.2171630859,29.246534347534) - GetEntityCoords(PlayerPedId()))
		if frntDist > 50.0 then
			local waitTime = frntDist * 10
			Citizen.Wait(math.ceil(waitTime))
			if StressRelief then
				StressRelief = false
			end
		end

		if not scanned then
			scanned = findNPC(110.87651062012,-1302.2821044922,29.269477844238)
			if scanned then
				scanwait = 5000
			else
				if frntDist < 3 or bkDist < 3 then
					SpawnPeds(false)
			        Citizen.Wait(1)
					SpawnPeds(true)
					scanned = true
					scanwait = 5000
				end
			end
		end
	end
end)

function SpawnPeds(skipBar)
	for i = 1, 4 do
		if i == 1 and skipBar then
		else
			local pedType = randomStripClubPed()

			local x = StripClubLocs[i]["x"]
			local y = StripClubLocs[i]["y"]
			local z = StripClubLocs[i]["z"]
			local h = StripClubLocs[i]["h"]
	        RequestModel(pedType)
	        while not HasModelLoaded(pedType) do
	            Citizen.Wait(0)
	        end
	        local IsPedNearCoords = exports["isPed"]:IsPedNearCoords(x,y,z)
	        if not IsPedNearCoords then
	        	if GetPedType(pedType) ~= nil then

					local stripClubPed = CreatePed(GetPedType(pedType), pedType, x,y,z, h, 1, 1)
					DecorSetBool(stripClubPed, 'ScriptedPed', true)
					SetPedDropsWeaponsWhenDead(stripClubPed,false)

					if i == 1 then
						TaskStartScenarioAtPosition(stripClubPed, "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", x,y,z, h, 0, 0, 1)
						FreezeEntityPosition(stripClubPed,true)
					else
						TaskWanderInArea(stripClubPed, x, y, z, 4.0, 2.0, 2.0)
					end

					SetPedComponentVariation(stripClubPed, 3, 1, 1, 1)
					SetPedAlertness(stripClubPed, 0)
					SetPedCombatAbility(stripClubPed, 0)
					SetPedCombatRange(stripClubPed, 0)
					SetPedTargetLossResponse(stripClubPed, 1)

			        SetPedSeeingRange(stripClubPed, 0.0)
			        SetPedHearingRange(stripClubPed, 0.0)
			        SetPedAlertness(stripClubPed, 0.0)


					netid = NetworkGetNetworkIdFromEntity(stripClubPed)
					SetNetworkIdCanMigrate(netid, true)
				end
			end
		end
	end
end



function randomStripClubPed()
	local math = math.random(6)
	ret = 695248020
	if math == 5 then
		ret = 1544875514
	elseif math == 4 then
		ret = 1846523796
	elseif math == 3 then
		ret = 1381498905		
	end
	return ret
end

function randomStripClubPed()
	local math = math.random(6)
	ret = 695248020
	if math == 5 then
		ret = 1544875514
	elseif math == 4 then
		ret = 1846523796
	elseif math == 3 then
		ret = 1381498905		
	end
	return ret
end

function randomScenario()
	local math = math.random(10)
	ret = "WORLD_HUMAN_CLIPBOARD"
	if math == 5 then
		ret = "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT"
	elseif math < 4 then
		ret = "CODE_HUMAN_MEDIC_TIME_OF_DEATH"
	end

	return ret
end
function findNPC(x,y,z)
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    local pedfound = false
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(vector3(x,y,z) - pos)
        if distance < 20.0 and (distanceFrom == nil or distance < distanceFrom) and isStripper(GetEntityModel(ped)) then
        	if IsEntityDead(ped) then
        		DeleteEntity(ped)
        	else
        		pedfound = true
        	end
        end
        success, ped = FindNextPed(handle)
    until not success or pedfound
    EndFindPed(handle)
    return pedfound
end

function isStripper(model)
	if model == 695248020 then
		return true
	end
	if model == 1544875514 then
		return true
	end
	if model == 1846523796 then
		return true
	end
	if model == 1381498905 then	
		return true
	end	
	return false
end

function privdance(ped)

	ClearPedSecondaryTask(ped)
	SetEntityCollision(ped,false,false)

	loadAnimDict( "mini@strip_club@private_dance@part1" )
	loadAnimDict( "mini@strip_club@private_dance@part2" )
	loadAnimDict( "mini@strip_club@private_dance@part3" )
  	
	TaskPlayAnim( ped, "mini@strip_club@private_dance@part1", "priv_dance_p1", 1.0, -1.0, -1, 0, 1, 0, 0, 0) 
	length = GetAnimDuration("mini@strip_club@private_dance@part1", "priv_dance_p1")
	Citizen.Wait(length)        	
	TaskPlayAnim( ped, "mini@strip_club@private_dance@part2", "priv_dance_p2", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
	length = GetAnimDuration("mini@strip_club@private_dance@part2", "priv_dance_p2")
	Citizen.Wait(length)  
	TaskPlayAnim( ped, "mini@strip_club@private_dance@part3", "priv_dance_p3", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
	length = GetAnimDuration("mini@strip_club@private_dance@part3", "priv_dance_p3")
	Citizen.Wait(length)  
	SetEntityCollision(ped,true,true)

end

-- Stripper Girls
function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function stripdance1()

	ClearPedSecondaryTask(PlayerPedId())

	loadAnimDict( "mini@strip_club@lap_dance@ld_girl_a_song_a_p1" )
	loadAnimDict( "mini@strip_club@lap_dance@ld_girl_a_song_a_p2" )
	loadAnimDict( "mini@strip_club@lap_dance@ld_girl_a_exit" )
	TaskPlayAnim( PlayerPedId(), "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", "ld_girl_a_song_a_p1_f", 1.0, -1.0, -1, 0, 1, 0, 0, 0) 
	length = GetAnimDuration("mini@strip_club@lap_dance@ld_girl_a_song_a_p1", "ld_girl_a_song_a_p1_f")
	Citizen.Wait(length)      	
	TaskPlayAnim( PlayerPedId(), "mini@strip_club@lap_dance@ld_girl_a_song_a_p2", "ld_girl_a_song_a_p2_f", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
	length = GetAnimDuration("mini@strip_club@lap_dance@ld_girl_a_song_a_p2", "ld_girl_a_song_a_p2_f")
	Citizen.Wait(length) 
	TaskPlayAnim( PlayerPedId(), "mini@strip_club@lap_dance@ld_girl_a_exit", "ld_girl_a_exit_f", 1.0, -1.0, -1, 0, 1, 0, 0, 0)

end

function stripdance2()

	ClearPedSecondaryTask(PlayerPedId())

	loadAnimDict( "mini@strip_club@lap_dance_2g@ld_2g_p1" )
	loadAnimDict( "mini@strip_club@lap_dance_2g@ld_2g_p2" )
	loadAnimDict( "mini@strip_club@lap_dance@ld_girl_a_exit" )
       	
	TaskPlayAnim( PlayerPedId(), "mini@strip_club@lap_dance_2g@ld_2g_p1", "ld_2g_p1_s1", 1.0, -1.0, -1, 0, 1, 0, 0, 0) 
	length = GetAnimDuration("mini@strip_club@lap_dance_2g@ld_2g_p1", "ld_2g_p1_s1")
	Citizen.Wait(length)        	
	TaskPlayAnim( PlayerPedId(), "mini@strip_club@lap_dance_2g@ld_2g_p2", "ld_2g_p2_s1", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
	length = GetAnimDuration("mini@strip_club@lap_dance_2g@ld_2g_p2", "ld_2g_p2_s1")
	Citizen.Wait(length)  
	TaskPlayAnim( PlayerPedId(), "mini@strip_club@lap_dance@ld_girl_a_exit", "ld_girl_a_exit_f", 1.0, -1.0, -1, 0, 1, 0, 0, 0)

end
function poledance()

	ClearPedSecondaryTask(PlayerPedId())

	loadAnimDict( "mini@strip_club@pole_dance@pole_dance1" )
	loadAnimDict( "mini@strip_club@pole_dance@pole_dance2" )
	loadAnimDict( "mini@strip_club@pole_dance@pole_dance3" )
    loadAnimDict( "mini@strip_club@pole_dance@pole_enter" ) 	  	

	TaskPlayAnim( PlayerPedId(), "mini@strip_club@pole_dance@pole_enter", "pd_enter", 1.0, -1.0, -1, 0, 1, 0, 0, 0) 
	length = GetAnimDuration("mini@strip_club@pole_dance@pole_enter", "pd_enter")
	Citizen.Wait(length) 

	TaskPlayAnim( PlayerPedId(), "mini@strip_club@pole_dance@pole_dance1", "pd_dance_01", 1.0, -1.0, -1, 0, 1, 0, 0, 0) 
	length = GetAnimDuration("mini@strip_club@pole_dance@pole_dance1", "pd_dance_01")
	Citizen.Wait(length)    
    	
	TaskPlayAnim( PlayerPedId(), "mini@strip_club@pole_dance@pole_dance2", "pd_dance_02", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
	length = GetAnimDuration("mini@strip_club@pole_dance@pole_dance2", "pd_dance_02")
	Citizen.Wait(length)  

	TaskPlayAnim( PlayerPedId(), "mini@strip_club@pole_dance@pole_dance3", "pd_dance_03", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
	length = GetAnimDuration("mini@strip_club@pole_dance@pole_dance3", "pd_dance_03")
	Citizen.Wait(length)  

end

Dancing = false
RegisterNetEvent("attachtopole")
AddEventHandler("attachtopole", function()
		local ped = PlayerPedId()
		local chair = CreateObject( `prop_chair_01a`, 112.59926422119,-1286.5965087891,28.45867729187, true, false, false)
		SetEntityHeading(chair,GetEntityHeading(ped)+180.0)
		SetEntityCollision(chair,false,false)
		--SetEntityVisible(chair, false)
		SetEntityCoords(chair, 112.59926422119,-1286.5965087891,28.45867729187)
		Dancing = true

		AttachEntityToEntity(ped, chair, 20, 0.0, 0.0, 1.0, 180.0, 180.0, 0.0, false, false, false, false, 1, true)
		DeleteObject(chair)
end)



function privdance()

	ClearPedSecondaryTask(PlayerPedId())
	SetEntityCollision(PlayerPedId(),false,false)

	loadAnimDict( "mini@strip_club@private_dance@part1" )
	loadAnimDict( "mini@strip_club@private_dance@part2" )
	loadAnimDict( "mini@strip_club@private_dance@part3" )
  	
	TaskPlayAnim( PlayerPedId(), "mini@strip_club@private_dance@part1", "priv_dance_p1", 1.0, -1.0, -1, 0, 1, 0, 0, 0) 
	length = GetAnimDuration("mini@strip_club@private_dance@part1", "priv_dance_p1")
	Citizen.Wait(length)        	
	TaskPlayAnim( PlayerPedId(), "mini@strip_club@private_dance@part2", "priv_dance_p2", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
	length = GetAnimDuration("mini@strip_club@private_dance@part2", "priv_dance_p2")
	Citizen.Wait(length)  
	TaskPlayAnim( PlayerPedId(), "mini@strip_club@private_dance@part3", "priv_dance_p3", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
	length = GetAnimDuration("mini@strip_club@private_dance@part3", "priv_dance_p3")
	Citizen.Wait(length)  
	SetEntityCollision(PlayerPedId(),true,true)

end


RegisterNetEvent("stripper:dance")
AddEventHandler("stripper:dance", function()
	stripdance1()
end)
RegisterNetEvent("stripper:dance2")
AddEventHandler("stripper:dance2", function()
	stripdance2()
end)

RegisterNetEvent("stripper:dance3")
AddEventHandler("stripper:dance3", function()
	poledance()
end)
RegisterNetEvent("stripper:dance4")
AddEventHandler("stripper:dance4", function()
	privdance()
end)

-- Memorial Script
local customized = json.decode('{"colors":[12,70],"xenonColor":255,"neon":{"1":false,"2":false,"3":false,"0":false},"oldLiveries":-1,"mods":{"1":0,"2":-1,"3":-1,"4":1,"5":0,"6":-1,"7":4,"8":-1,"9":-1,"10":7,"11":2,"12":2,"13":2,"14":-1,"15":2,"16":2,"17":false,"18":1,"19":false,"20":false,"21":false,"22":1,"23":-1,"24":-1,"25":-1,"26":-1,"27":-1,"28":-1,"29":-1,"30":-1,"31":-1,"32":-1,"33":-1,"34":-1,"35":-1,"36":-1,"37":-1,"38":-1,"39":-1,"40":-1,"41":-1,"42":-1,"43":-1,"44":-1,"45":-1,"46":-1,"47":-1,"48":-1,"0":-1},"interColour":0,"lights":[255,0,255],"extras":[1,0,0,0,0,0,0,0,0,0,0,0],"platestyle":3,"extracolors":[107,70],"plateIndex":3,"smokecolor":[255,255,255],"tint":0,"wheeltype":7,"dashColour":0}')
local veh = 0
local blue = 0
local bluecoords = { ['x'] = 1059.67,['y'] = -386.55,['z'] = 67.85,['h'] = 131.56, ['info'] = ' blue' }

local drawable_names = {"face", "masks", "hair", "torsos", "legs", "bags", "shoes", "neck", "undershirts", "vest", "decals", "jackets"}
local prop_names = {"hats", "glasses", "earrings", "mouth", "lhand", "rhand", "watches", "braclets"}
local head_overlays = {"Blemishes","FacialHair","Eyebrows","Ageing","Makeup","Blush","Complexion","SunDamage","Lipstick","MolesFreckles","ChestHair","BodyBlemishes","AddBodyBlemishes"}
local face_features = {"Nose_Width","Nose_Peak_Hight","Nose_Peak_Lenght","Nose_Bone_High","Nose_Peak_Lowering","Nose_Bone_Twist","EyeBrown_High","EyeBrown_Forward","Cheeks_Bone_High","Cheeks_Bone_Width","Cheeks_Width","Eyes_Openning","Lips_Thickness","Jaw_Bone_Width","Jaw_Bone_Back_Lenght","Chimp_Bone_Lowering","Chimp_Bone_Lenght","Chimp_Bone_Width","Chimp_Hole","Neck_Thikness"}

local bluedrawables = '{"1":["masks",-1],"2":["hair",2],"3":["torsos",6],"4":["legs",9],"5":["bags",0],"6":["shoes",1],"7":["neck",0],"8":["undershirts",15],"9":["vest",0],"10":["decals",0],"11":["jackets",184],"0":["face",11]}'
local blueprops = '{"1":["glasses",0],"2":["earrings",-1],"3":["mouth",-1],"4":["lhand",-1],"5":["rhand",-1],"6":["watches",-1],"7":["braclets",-1],"0":["hats",139]}'
local bluedt = '[["face",0],["masks",255],["hair",2],["torsos",0],["legs",7],["bags",0],["shoes",2],["neck",0],["undershirts",0],["vest",0],["decals",0],["jackets",0]]'
local blueacc =  '[["hats",0],["glasses",0],["earrings",-1],["mouth",-1],["lhand",-1],["rhand",-1],["watches",-1],["braclets",-1]]'
local bluehair =  '[3,17]'


local bluedata = {
    drawables = json.decode(bluedrawables),
    props = json.decode(blueprops),
    drawtextures = json.decode(bluedt),
    proptextures = json.decode(blueacc),
    hairColor = json.decode(bluehair),
    headBlend = json.decode('{"skinFirst":15,"skinMix":1.0,"skinThird":0,"hasParent":false,"thirdMix":0.0,"shapeMix":0.0,"skinSecond":0,"shapeFirst":0,"shapeSecond":0,"shapeThird":0}'),
    headOverlay = json.decode('[{"firstColour":0,"overlayValue":255,"colourType":0,"secondColour":0,"overlayOpacity":1.0,"name":"Blemishes"},{"firstColour":18,"overlayValue":10,"colourType":1,"secondColour":18,"overlayOpacity":0.75,"name":"FacialHair"},{"firstColour":6,"overlayValue":1,"colourType":1,"secondColour":6,"overlayOpacity":1.0,"name":"Eyebrows"},{"firstColour":5,"overlayValue":255,"colourType":0,"secondColour":5,"overlayOpacity":1.0,"name":"Ageing"},{"firstColour":0,"overlayValue":255,"colourType":2,"secondColour":0,"overlayOpacity":1.0,"name":"Makeup"},{"firstColour":0,"overlayValue":255,"colourType":2,"secondColour":0,"overlayOpacity":1.0,"name":"Blush"},{"firstColour":0,"overlayValue":255,"colourType":0,"secondColour":0,"overlayOpacity":1.0,"name":"Complexion"},{"firstColour":0,"overlayValue":255,"colourType":0,"secondColour":0,"overlayOpacity":1.0,"name":"SunDamage"},{"firstColour":0,"overlayValue":255,"colourType":2,"secondColour":0,"overlayOpacity":1.0,"name":"Lipstick"},{"firstColour":0,"overlayValue":255,"colourType":0,"secondColour":0,"overlayOpacity":1.0,"name":"MolesFreckles"},{"firstColour":0,"overlayValue":255,"colourType":1,"secondColour":0,"overlayOpacity":1.0,"name":"ChestHair"},{"firstColour":0,"overlayValue":255,"colourType":0,"secondColour":0,"overlayOpacity":1.0,"name":"BodyBlemishes"},{"firstColour":0,"overlayValue":255,"colourType":0,"secondColour":0,"overlayOpacity":1.0,"name":"AddBodyBlemishes"}]'),
    headStructure = json.decode('[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]'),
}

 --       "MP_Buis_M_Neck_000",
  --      "MP_Buis_M_Neck_001",
   --     "MP_Buis_M_Neck_002",
    --    "MP_Buis_M_Neck_003",

function penis()    

    local car = `rmodmustang`
    RequestModel(car)
    while not HasModelLoaded(car) do
        Citizen.Wait(0)
    end

    veh = CreateVehicle(car, 1056.84, -387.26, 67.86, 218.59, false, false)

    SetModelAsNoLongerNeeded(car)
    SetVehicleOnGroundProperly(veh)
    SetEntityInvincible(veh, true) 
    SetVehicleModKit(veh, 0)
    SetVehicleNumberPlateText(veh, "BLUE622")
    SetVehicleWheelType(veh, customized.wheeltype)
    SetVehicleNumberPlateTextIndex(veh, 3)

    for i = 0, 16 do
        SetVehicleMod(veh, i, customized.mods[tostring(i)])
    end

    for i = 17, 22 do
        ToggleVehicleMod(veh, i, customized.mods[tostring(i)])
    end

    for i = 23, 24 do
        local isCustom = customized.mods[tostring(i)]
        if (isCustom == nil or isCustom == "-1" or isCustom == false or isCustom == 0) then
            isSet = false
        else
            isSet = true
        end
        SetVehicleMod(veh, i, customized.mods[tostring(i)], isCustom)
    end

    for i = 23, 48 do
        SetVehicleMod(veh, i, customized.mods[tostring(i)])
    end

    for i = 0, 3 do
        SetVehicleNeonLightEnabled(veh, i, customized.neon[tostring(i)])
    end

    if customized.extras ~= nil then
        for i = 1, 12 do
            local onoff = tonumber(customized.extras[i])
            if onoff == 1 then
                SetVehicleExtra(veh, i, 0)
            else
                SetVehicleExtra(veh, i, 1)
            end
        end
    end

    if customized.oldLiveries ~= nil and customized.oldLiveries ~= 24  then
        SetVehicleLivery(veh, customized.oldLiveries)
    end

    if customized.plateIndex ~= nil and customized.plateIndex ~= 4 then
        SetVehicleNumberPlateTextIndex(veh, customized.plateIndex)
    end

    -- Xenon Colors
    SetVehicleXenonLightsColour(veh, (customized.xenonColor or -1))
    SetVehicleColours(veh, customized.colors[1], customized.colors[2])
    SetVehicleExtraColours(veh, customized.extracolors[1], customized.extracolors[2])
    SetVehicleNeonLightsColour(veh, customized.lights[1], customized.lights[2], customized.lights[3])
    SetVehicleTyreSmokeColor(veh, customized.smokecolor[1], customized.smokecolor[2], customized.smokecolor[3])
    SetVehicleWindowTint(veh, customized.tint)
    SetVehicleInteriorColour(veh, customized.dashColour)
    SetVehicleDashboardColour(veh, customized.interColour)
    SetEntityInvincible(veh,true)
    SetVehicleHandbrake(veh,true)
    FreezeEntityPosition(veh, true)
    SetEntityInvincible(veh, true)
    SetVehicleFuelLevel(veh, 0)
    SetVehicleDoorsLocked(veh, 3)
    SetVehicleLights(veh,2)
end

function balls(data)
    local hashKey = 1885233650
    RequestModel(hashKey)
    while not HasModelLoaded(hashKey) do
        RequestModel(hashKey)
        Citizen.Wait(100)
    end
    blue = CreatePed(27, hashKey, 1059.67, -386.55, 66.85, 131.56, 0, 0)
    DecorSetBool(blue, 'ScriptedPed', true)
    SetPedKeepTask(blue, false)
    TaskSetBlockingOfNonTemporaryEvents(blue, false)
    ClearPedTasks(blue)
    LoadPed(data)
    ApplyPedOverlay(blue, `mpbeach_overlays` , `MP_Bea_M_Neck_000`)
end

function LoadPed(data)
    SetClothing(data.drawables, data.props, data.drawtextures, data.proptextures)
    Citizen.Wait(500)
    
    SetPedHeadBlend(data.headBlend)
    SetHeadStructure(data.headStructure)
    SetHeadOverlayData(data.headOverlay)
    SetPedHairColor(blue, 3, 17)
    TaskStartScenarioInPlace(blue, "WORLD_HUMAN_SMOKING_POT", 0, true)
    SetEntityInvincible(blue,true)
    FreezeEntityPosition(blue,true)
    SetPedKeepTask(blue, true)
    SetPedDropsWeaponsWhenDead(blue,false)
    SetPedFleeAttributes(blue, 0, 0)
    SetPedCombatAttributes(blue, 17, 1)
    SetPedSeeingRange(blue, 0.0)
    SetPedHearingRange(blue, 0.0)
    SetPedAlertness(blue, 0.0)

    SetIgnoreLowPriorityShockingEvents(blue,true)
    SetBlockingOfNonTemporaryEvents(blue,true)

end

function SetPedHeadBlend(data)
    SetPedHeadBlendData(blue,
        tonumber(data['shapeFirst']),
        tonumber(data['shapeSecond']),
        tonumber(data['shapeThird']),
        tonumber(data['skinFirst']),
        tonumber(data['skinSecond']),
        tonumber(data['skinThird']),
        tonumber(data['shapeMix']),
        tonumber(data['skinMix']),
        tonumber(data['thirdMix']),
    false)
end

function SetHeadOverlayData(data)
    if json.encode(data) ~= "[]" then
        for i = 1, #head_overlays do
            SetPedHeadOverlay(blue,  i-1, tonumber(data[i].overlayValue),  tonumber(data[i].overlayOpacity))
            -- SetPedHeadOverlayColor(player, i-1, data[i].colourType, data[i].firstColour, data[i].secondColour)
        end

        SetPedHeadOverlayColor(blue, 0, 0, tonumber(data[1].firstColour), tonumber(data[1].secondColour))
        SetPedHeadOverlayColor(blue, 1, 1, tonumber(data[2].firstColour), tonumber(data[2].secondColour))
        SetPedHeadOverlayColor(blue, 2, 1, tonumber(data[3].firstColour), tonumber(data[3].secondColour))
        SetPedHeadOverlayColor(blue, 3, 0, tonumber(data[4].firstColour), tonumber(data[4].secondColour))
        SetPedHeadOverlayColor(blue, 4, 2, tonumber(data[5].firstColour), tonumber(data[5].secondColour))
        SetPedHeadOverlayColor(blue, 5, 2, tonumber(data[6].firstColour), tonumber(data[6].secondColour))
        SetPedHeadOverlayColor(blue, 6, 0, tonumber(data[7].firstColour), tonumber(data[7].secondColour))
        SetPedHeadOverlayColor(blue, 7, 0, tonumber(data[8].firstColour), tonumber(data[8].secondColour))
        SetPedHeadOverlayColor(blue, 8, 2, tonumber(data[9].firstColour), tonumber(data[9].secondColour))
        SetPedHeadOverlayColor(blue, 9, 0, tonumber(data[10].firstColour), tonumber(data[10].secondColour))
        SetPedHeadOverlayColor(blue, 10, 1, tonumber(data[11].firstColour), tonumber(data[11].secondColour))
        SetPedHeadOverlayColor(blue, 11, 0, tonumber(data[12].firstColour), tonumber(data[12].secondColour))
    end
end

function SetHeadStructure(data)
    for i = 1, #face_features do
        SetPedFaceFeature(blue, i-1, data[i])
    end
end

function SetClothing(drawables, props, drawTextures, propTextures)
    for i = 1, #drawable_names do
        if drawables[0] == nil then
            if drawable_names[i] == "undershirts" and drawables[tostring(i-1)][2] == -1 then
                SetPedComponentVariation(blue, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(blue, i-1, drawables[tostring(i-1)][2], drawTextures[i][2], 2)
            end
        else
            if drawable_names[i] == "undershirts" and drawables[i-1][2] == -1 then
                SetPedComponentVariation(blue, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(blue, i-1, drawables[i-1][2], drawTextures[i][2], 2)
            end
        end
    end

    for i = 1, #prop_names do
        local propZ = (drawables[0] == nil and props[tostring(i-1)][2] or props[i-1][2])
        ClearPedProp(blue, i-1)
        SetPedPropIndex(
            blue,
            i-1,
            propZ,
            propTextures[i][2], true)
    end
end


function SetSkin(model, setDefault)
    -- TODO: If not isCop and model not in copModellist, do below.
    -- Model is a hash, GetHashKey(modelName)
    
    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while (not HasModelLoaded(model)) do
            Citizen.Wait(0)
        end
        SetPlayerModel(blue, model)
        SetModelAsNoLongerNeeded(model)
        FreezePedCameraRotation(blue, true)
        if setDefault and model ~= nil and not isCustomSkin(model) then
            if (model ~= `mp_f_freemode_01` and model ~= `mp_m_freemode_01`) then
                SetPedRandomComponentVariation(blue, true)
            else
                SetPedHeadBlendData(blue, 0, 0, 0, 15, 0, 0, 0, 1.0, 0, false)
                SetPedComponentVariation(blue, 11, 0, 11, 0)
                SetPedComponentVariation(blue, 8, 0, 1, 0)
                SetPedComponentVariation(blue, 6, 1, 2, 0)
                SetPedHeadOverlayColor(blue, 1, 1, 0, 0)
                SetPedHeadOverlayColor(blue, 2, 1, 0, 0)
                SetPedHeadOverlayColor(blue, 4, 2, 0, 0)
                SetPedHeadOverlayColor(blue, 5, 2, 0, 0)
                SetPedHeadOverlayColor(blue, 8, 2, 0, 0)
                SetPedHeadOverlayColor(blue, 10, 1, 0, 0)
                SetPedHeadOverlay(blue, 1, 0, 0.0)
                SetPedHairColor(blue, 1, 1)
            end
        end
    end

end

local memorialCoords =  vector3(1066.84, -387.26, 66.86)

local spawned = false

Citizen.CreateThread(function ()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())

        if not spawned and #(memorialCoords - playerCoords) <= 200.0 then
            penis()
            balls(bluedata)
            spawned = true
        elseif spawned and #(memorialCoords - playerCoords) > 200.0 then
            DeleteEntity(veh)
            DeleteEntity(blue)
            spawned = false
        end

        if spawned and not IsPedActiveInScenario(blue) then
            TaskStartScenarioInPlace(blue, "WORLD_HUMAN_SMOKING_POT", 0, true)
        end

        Citizen.Wait(3000)
    end
end)

AddEventHandler('onResourceStopped', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        DeleteEntity(veh)
        DeleteEntity(blue)
        spawned = false
    end
end)