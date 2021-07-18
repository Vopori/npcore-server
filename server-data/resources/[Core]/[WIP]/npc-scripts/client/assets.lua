-- Sirens
Citizen.CreateThread(function()
    while true do
        DistantCopCarSirens(false)
        Citizen.Wait(400)
    end
end)

-- Map Zoom Sens
Citizen.CreateThread(function()
    SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0)
end)

--[[ Static Discord Rich Presence
local onlinePlayers = 0
RegisterNetEvent('rich:TakePlayers')
AddEventHandler('rich:TakePlayers', function(count)
    onlinePlayers = count
    if SetDiscordRichPresenceAction then
        SetDiscordRichPresenceAction(0, 'Click To Apply', 'https://discord.gg/ahbEjHTfRm')
    end
end)

Citizen.CreateThread(function()
    TriggerServerEvent('rich:GetPlayers')
    SetDiscordAppId(tonumber(GetConvar("RichAppId", "856842647032168458")))
    SetDiscordRichPresenceAsset(GetConvar("RichAssetId", "npcore"))
    while true do
        Citizen.Wait(2000)
        SetDiscordRichPresenceAssetText("discord.gg/ahbEjHTfRm")
        SetRichPresence(onlinePlayers.."/10 Players")
    end
end)
]]--

-- Statistic Discord Rich Presence
local WaitTime = 30000 -- How often do you want to update the status (In MS)?
    local appid = '856842647032168458' -- Make an application @ https://discordapp.com/developers/applications/ ID can be found there.
    local asset = 'npcore' -- Go to https://discordapp.com/developers/applications/APPID/rich-presence/assets
    
    function ZetaRP()
        local name = GetPlayerName(PlayerId())
        local id = GetPlayerServerId(PlayerId())
    
        SetDiscordAppId(appid)
        SetDiscordRichPresenceAsset(asset)
        SetDiscordRichPresenceAsset("npcore")
        SetDiscordRichPresenceAssetText(name)
        SetDiscordRichPresenceAssetSmall("npcore")
        SetDiscordRichPresenceAssetSmallText("Health: "..GetEntityHealth(GetPlayerPed(-1)))
    end
    
    Citizen.CreateThread(function()
        
        --ZetaRP()
        while true do
            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
            local StreetHash = GetStreetNameAtCoord(x, y, z)
            Citizen.Wait(WaitTime)	
    
            ZetaRP()
            if StreetHash ~= nil then
                StreetName = GetStreetNameFromHashKey(StreetHash)
                if IsPedOnFoot(PlayerPedId()) and not IsEntityInWater(PlayerPedId()) then
                    if IsPedSprinting(PlayerPedId()) then
                        SetRichPresence("Ducking down ops @ "..StreetName)
                    elseif IsPedRunning(PlayerPedId()) then
                        SetRichPresence("Shooting down ops @ "..StreetName)
                    elseif IsPedWalking(PlayerPedId()) then
                        SetRichPresence("Walking down "..StreetName)
                    elseif IsPedStill(PlayerPedId()) then
                        SetRichPresence("Standing on "..StreetName)
                    end
                elseif GetVehiclePedIsUsing(PlayerPedId()) ~= nil and not IsPedInAnyHeli(PlayerPedId()) and not IsPedInAnyPlane(PlayerPedId()) and not IsPedOnFoot(PlayerPedId()) and not IsPedInAnySub(PlayerPedId()) and not IsPedInAnyBoat(PlayerPedId()) then
                    local MPH = math.ceil(GetEntitySpeed(GetVehiclePedIsUsing(PlayerPedId())) * 2.236936)
                    local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
                    if MPH > 50 then
                        SetRichPresence("Speeding down "..StreetName.." In a "..VehName)
                    elseif MPH <= 50 and MPH > 0 then
                        SetRichPresence("Whipping down "..StreetName.." In a "..VehName)
                    elseif MPH == 0 then
                        SetRichPresence("Parked on "..StreetName.." In a "..VehName)
                    end
                elseif IsPedInAnyHeli(PlayerPedId()) or IsPedInAnyPlane(PlayerPedId()) then
                    local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
                    if IsEntityInAir(GetVehiclePedIsUsing(PlayerPedId())) or GetEntityHeightAboveGround(GetVehiclePedIsUsing(PlayerPedId())) > 5.0 then
                        SetRichPresence("Flying over "..StreetName.." in a "..VehName)
                    else
                        SetRichPresence("Landed at "..StreetName.." in a "..VehName)
                    end
                elseif IsEntityInWater(PlayerPedId()) then
                    SetRichPresence("Swimming around")
                elseif IsPedInAnyBoat(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
                    local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
                    SetRichPresence("Sailing around in a "..VehName)
                elseif IsPedInAnySub(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
                    SetRichPresence("In a yellow submarine")
                end
            end
        end
    end)

--[[ Disable Pistol Whip
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
]]--

-- Blind Fire
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local ped = PlayerPedId()
		if IsPedInCover(ped, 1) and not IsPedAimingFromCover(ped, 1) then 
			DisableControlAction(2, 24, true) 
			DisableControlAction(2, 142, true)
			DisableControlAction(2, 257, true)
		end		
	end
end)

-- Tazer Effect
    if Config.tazereffect then
local isTaz = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		ped = PlayerPedId()
		
		if IsPedBeingStunned(ped) then
			
			SetPedToRagdoll(ped, 5000, 5000, 0, 0, 0, 0)
			
		end
		
		if IsPedBeingStunned(ped) and not isTaz then
			
			isTaz = true
			SetTimecycleModifier("REDMIST_blend")
			ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 1.0)
			
		elseif not IsPedBeingStunned(ped) and isTaz then
			isTaz = false
			Wait(5000)
			
			SetTimecycleModifier("hud_def_desat_Trevor")
			
			Wait(10000)
			
      		SetTimecycleModifier("")
			SetTransitionTimecycleModifier("")
			StopGameplayCamShaking()
		end
	end
end)
end

-- Weapon Drops
Citizen.CreateThread(function()
	while true do    
		RemoveWeaponDrops()
		Citizen.Wait(1000)
	end
end)

function RemoveWeaponDrops()
	local pickupList = {`PICKUP_AMMO_BULLET_MP`,`PICKUP_AMMO_FIREWORK`,`PICKUP_AMMO_FLAREGUN`,`PICKUP_AMMO_GRENADELAUNCHER`,`PICKUP_AMMO_GRENADELAUNCHER_MP`,`PICKUP_AMMO_HOMINGLAUNCHER`,`PICKUP_AMMO_MG`,`PICKUP_AMMO_MINIGUN`,`PICKUP_AMMO_MISSILE_MP`,`PICKUP_AMMO_PISTOL`,`PICKUP_AMMO_RIFLE`,`PICKUP_AMMO_RPG`,`PICKUP_AMMO_SHOTGUN`,`PICKUP_AMMO_SMG`,`PICKUP_AMMO_SNIPER`,`PICKUP_ARMOUR_STANDARD`,`PICKUP_CAMERA`,`PICKUP_CUSTOM_SCRIPT`,`PICKUP_GANG_ATTACK_MONEY`,`PICKUP_HEALTH_SNACK`,`PICKUP_HEALTH_STANDARD`,`PICKUP_MONEY_CASE`,`PICKUP_MONEY_DEP_BAG`,`PICKUP_MONEY_MED_BAG`,`PICKUP_MONEY_PAPER_BAG`,`PICKUP_MONEY_PURSE`,`PICKUP_MONEY_SECURITY_CASE`,`PICKUP_MONEY_VARIABLE`,`PICKUP_MONEY_WALLET`,`PICKUP_PARACHUTE`,`PICKUP_PORTABLE_CRATE_FIXED_INCAR`,`PICKUP_PORTABLE_CRATE_UNFIXED`,`PICKUP_PORTABLE_CRATE_UNFIXED_INCAR`,`PICKUP_PORTABLE_CRATE_UNFIXED_INCAR_SMALL`,`PICKUP_PORTABLE_CRATE_UNFIXED_LOW_GLOW`,`PICKUP_PORTABLE_DLC_VEHICLE_PACKAGE`,`PICKUP_PORTABLE_PACKAGE`,`PICKUP_SUBMARINE`,`PICKUP_VEHICLE_ARMOUR_STANDARD`,`PICKUP_VEHICLE_CUSTOM_SCRIPT`,`PICKUP_VEHICLE_CUSTOM_SCRIPT_LOW_GLOW`,`PICKUP_VEHICLE_HEALTH_STANDARD`,`PICKUP_VEHICLE_HEALTH_STANDARD_LOW_GLOW`,`PICKUP_VEHICLE_MONEY_VARIABLE`,`PICKUP_VEHICLE_WEAPON_APPISTOL`,`PICKUP_VEHICLE_WEAPON_ASSAULTSMG`,`PICKUP_VEHICLE_WEAPON_COMBATPISTOL`,`PICKUP_VEHICLE_WEAPON_GRENADE`,`PICKUP_VEHICLE_WEAPON_MICROSMG`,`PICKUP_VEHICLE_WEAPON_MOLOTOV`,`PICKUP_VEHICLE_WEAPON_PISTOL`,`PICKUP_VEHICLE_WEAPON_PISTOL50`,`PICKUP_VEHICLE_WEAPON_SAWNOFF`,`PICKUP_VEHICLE_WEAPON_SMG`,`PICKUP_VEHICLE_WEAPON_SMOKEGRENADE`,`PICKUP_VEHICLE_WEAPON_STICKYBOMB`,`PICKUP_WEAPON_ADVANCEDRIFLE`,`PICKUP_WEAPON_APPISTOL`,`PICKUP_WEAPON_ASSAULTRIFLE`,`PICKUP_WEAPON_ASSAULTSHOTGUN`,`PICKUP_WEAPON_ASSAULTSMG`,`PICKUP_WEAPON_AUTOSHOTGUN`,`PICKUP_WEAPON_BAT`,`PICKUP_WEAPON_BATTLEAXE`,`PICKUP_WEAPON_BOTTLE`,`PICKUP_WEAPON_BULLPUPRIFLE`,`PICKUP_WEAPON_BULLPUPSHOTGUN`,`PICKUP_WEAPON_CARBINERIFLE`,`PICKUP_WEAPON_COMBATMG`,`PICKUP_WEAPON_COMBATPDW`,`PICKUP_WEAPON_COMBATPISTOL`,`PICKUP_WEAPON_COMPACTLAUNCHER`,`PICKUP_WEAPON_COMPACTRIFLE`,`PICKUP_WEAPON_CROWBAR`,`PICKUP_WEAPON_DAGGER`,`PICKUP_WEAPON_DBSHOTGUN`,`PICKUP_WEAPON_FIREWORK`,`PICKUP_WEAPON_FLAREGUN`,`PICKUP_WEAPON_FLASHLIGHT`,`PICKUP_WEAPON_GRENADE`,`PICKUP_WEAPON_GRENADELAUNCHER`,`PICKUP_WEAPON_GUSENBERG`,`PICKUP_WEAPON_GOLFCLUB`,`PICKUP_WEAPON_HAMMER`,`PICKUP_WEAPON_HATCHET`,`PICKUP_WEAPON_HEAVYPISTOL`,`PICKUP_WEAPON_HEAVYSHOTGUN`,`PICKUP_WEAPON_HEAVYSNIPER`,`PICKUP_WEAPON_HOMINGLAUNCHER`,`PICKUP_WEAPON_KNIFE`,`PICKUP_WEAPON_KNUCKLE`,`PICKUP_WEAPON_MACHETE`,`PICKUP_WEAPON_MACHINEPISTOL`,`PICKUP_WEAPON_MARKSMANPISTOL`,`PICKUP_WEAPON_MARKSMANRIFLE`,`PICKUP_WEAPON_MG`,`PICKUP_WEAPON_MICROSMG`,`PICKUP_WEAPON_MINIGUN`,`PICKUP_WEAPON_MINISMG`,`PICKUP_WEAPON_MOLOTOV`,`PICKUP_WEAPON_MUSKET`,`PICKUP_WEAPON_NIGHTSTICK`,`PICKUP_WEAPON_PETROLCAN`,`PICKUP_WEAPON_PIPEBOMB`,`PICKUP_WEAPON_PISTOL`,`PICKUP_WEAPON_PISTOL50`,`PICKUP_WEAPON_POOLCUE`,`PICKUP_WEAPON_PROXMINE`,`PICKUP_WEAPON_PUMPSHOTGUN`,`PICKUP_WEAPON_RAILGUN`,`PICKUP_WEAPON_REVOLVER`,`PICKUP_WEAPON_RPG`,`PICKUP_WEAPON_SAWNOFFSHOTGUN`,`PICKUP_WEAPON_SMG`,`PICKUP_WEAPON_SMOKEGRENADE`,`PICKUP_WEAPON_SNIPERRIFLE`,`PICKUP_WEAPON_SNSPISTOL`,`PICKUP_WEAPON_SPECIALCARBINE`,`PICKUP_WEAPON_STICKYBOMB`,`PICKUP_WEAPON_STUNGUN`,`PICKUP_WEAPON_SWITCHBLADE`,`PICKUP_WEAPON_VINTAGEPISTOL`,`PICKUP_WEAPON_WRENCH`}
	local PlayerPed = PlayerPedId()
	local pedPos = GetEntityCoords(PlayerPed, false)

	for a = 1, #pickupList do
		if IsPickupWithinRadius(pickupList[a], pedPos.x, pedPos.y, pedPos.z, 200.0) then
			RemoveAllPickupsOfType(pickupList[a])
		end
	end
end

-- Basic Weapon Damage
Citizen.CreateThread(function()
    while true do
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.2)
    	Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_KNIFE"), 0.4)
    	Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BAT"), 0.4)
    	Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_KNIGHTSTICK"), 0.4)
    	Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_CROWBAR"), 0.4)
    	Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HEAVYPISTOL"), 0.85)
    	Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_COMBATPISTOL"), 0.83)
    	Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PISTOL_MK2"), 0.84)
    	Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SNSPISTOL"), 0.80)
    	Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PISTOl"), 0.81)
    	Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_CARBINERIFLE_MK2"), 0.83)
    	Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSAULTRIFLE"), 0.83)
    	Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSAULTRIFLE_MK2"), 0.83)
    	Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MACHINEPISTOL"), 0.82)
    	Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_APPISTOl"), 0.83)
    	Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SMG"), 0.83)
    	Wait(0)
    end
end)

--[[ No Driver Shooting
local passengerDriveBy = true

Citizen.CreateThread(function()
	while true do
		Wait(1)

		playerPed = GetPlayerPed(-1)
		car = GetVehiclePedIsIn(playerPed, false)
		if car then
			if GetPedInVehicleSeat(car, -1) == playerPed then
				SetPlayerCanDoDriveBy(PlayerId(), false)
			elseif passengerDriveBy then
				SetPlayerCanDoDriveBy(PlayerId(), true)
			else
				SetPlayerCanDoDriveBy(PlayerId(), false)
			end
		end
	end
end)
]]--

-- Crosshair
local plyPed = PlayerPedId()
local xhairActive = false
local disableXhair = false

RegisterCommand("togglexhair", function()
    disableXhair = not disableXhair
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        plyPed = PlayerPedId()
        isArmed = IsPedArmed(plyPed, 7)

        if isArmed then
            if IsPlayerFreeAiming(PlayerId()) then
                if not xhairActive then
                    SendNUIMessage("xhairShow")
                    xhairActive = true
                end
            elseif xhairActive then
                SendNUIMessage("xhairHide")
                xhairActive = false
            end
        elseif IsPedInAnyVehicle(plyPed, false) then
            if xhairActive then
                SendNUIMessage("xhairHide")
                xhairActive = false
            end
        else
            if xhairActive then
                SendNUIMessage("xhairHide")
                xhairActive = false
            end
        end
    end
end)

-- Disables weird run after shooting
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        ped = PlayerPedId()
        if not IsPedInAnyVehicle(ped, false) then
            if IsPedUsingActionMode(ped) then
                SetPedUsingActionMode(ped, -1, -1, 1)
            end
        else
            Citizen.Wait(3000)
        end
    end
end)

-- Gets rid of barriers 
local gates = {
	'p_barier_test_s',
	'prop_sec_barier_01a',
	'prop_sec_barier_02a',
	'prop_sec_barier_02b',
	'prop_sec_barier_03a',
	'prop_sec_barier_03b',
	'prop_sec_barier_04a',
	'prop_sec_barier_04b',
	'prop_sec_barier_base_01',
	'prop_sec_barrier_ld_01a',
	'prop_sec_barrier_ld_02a',
	'prop_gate_airport_01',
	'prop_facgate_01',
	'prop_facgate_03_l',
	'prop_facgate_03_r',
	'prop_gate_docks_ld'
}

Citizen.CreateThread(function()
   while true do
		for i=1, #gates do
			local coords = GetEntityCoords(PlayerPedId(), false)
			local gate = GetClosestObjectOfType(coords.x, coords.y, coords.z, 100.0, GetHashKey(gates[i]), 0, 0, 0)
			if gate ~= 0 then
				SetEntityAsMissionEntity(gate, 1, 1)
				DeleteObject(gate)
				SetEntityAsNoLongerNeeded(gate)
			end
		end
	   Citizen.Wait(2500)
   end
end)

-- Delete Props When Hitting Them With a Vehicle
local Props = {
    [729253480] = true,
    [-655644382] = true,
    [589548997] = true,
    [793482617] = true,
    [1502931467] = true,
    [1803721002] = true,
    [-1651641860] = true,
    [-156356737] = true,
    [1043035044] = true,
    [862871082] = true,
    [-1798594116] = true,
    [865627822] = true,
    [840050250] = true,
    [1821241621] = true,
    [-797331153] = true,
    [-949234773] = true,
    [1191039009] = true,
    [-463994753] = true,
    [-276539604] = true,
    [1021745343] = true,
    [-1063472968] = true,
    [1441261609] = true,
    [-667908451] = true,
    [-365135956] = true,
    [-157127644] = true,
    [-1057375813] = true,
    [-639994124] = true,
    [173177608] = true,
    [-879318991] = true,
    [-1529663453] = true,
    [267702115] = true,
    [1847069612] = true,
    [1452666705] = true,
    [681787797] = true,
    [1868764591] = true,
    [-1648525921] = true,
    [-1114695146] = true,
    [-943634842] = true,
    [-331378834] = true,
    [431612653] = true,
    [-97646180] = true,
    [1437508529] = true,
    [-2007495856] = true,
    [-16208233304] = true,
    [2122387284] = true,
    [1411103374] = true,
    [-216200273] = true,
    [1322893877] = true,
    [93794225] = true,
    [373936410] = true,
    [-872399736] = true,
    [-1178167275] = true,
    [1327054116] = true,
}

Citizen.CreateThread(function()
    while true do
        local PropsToDelete = {}
        local ped = PlayerPedId()
        local idle, success = 1000
        local handle, prop = FindFirstObject()
        repeat               
            if Props[GetEntityModel(prop)] then
                if GetObjectFragmentDamageHealth(prop,true) < 1.0 or (GetObjectFragmentDamageHealth(prop,true) ~= nil and GetEntityHealth(prop) < GetEntityMaxHealth(prop)) then
                    PropsToDelete[#PropsToDelete+1] = prop
                end
            end
            
            success, prop = FindNextObject(handle)
        until not success
        EndFindObject(handle)
        Citizen.Wait(1500)
        for i = 1, #PropsToDelete do
            SetEntityCoords(PropsToDelete[i],0,0,0)
        end
        Citizen.Wait(500)
    end
end)

--[[ AFK Kicker
 local afkTimeout = 1200
 local timer = 0
 local currentPosition  = nil
 local previousPosition = nil
 local currentHeading   = nil
 local previousHeading  = nil
 local disabled = false
 Citizen.CreateThread(function()
 	while true do
 		Citizen.Wait(1000)
         if not disabled then
            playerPed = PlayerPedId()
             if playerPed then
                 currentPosition = GetEntityCoords(playerPed, true)
                 currentHeading  = GetEntityHeading(playerPed)

                 if currentPosition == previousPosition and currentHeading == previousHeading then
                     if timer > 0 then
                         if timer == math.ceil(afkTimeout / 4) then
                             TriggerEvent("DoLongHudText", "Move around or else you'll be kicked for being AFK!")
                         end

                         timer = timer - 1
                     else
                         TriggerServerEvent('afk:kick')
                     end
                 else
                     timer = afkTimeout
                 end

                 previousPosition = currentPosition
                 previousHeading  = currentHeading
             end
         end
 	end
 end)

 RegisterNetEvent("npc:afk:update")
 AddEventHandler("npc:afk:update", function(status)
     disabled = status
 end)
]]--

-- No NPC Drops
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		RemoveAllPickupsOfType(GetHashKey('PICKUP_WEAPON_CARBINERIFLE'))
		RemoveAllPickupsOfType(GetHashKey('PICKUP_WEAPON_PISTOL'))
		RemoveAllPickupsOfType(GetHashKey('PICKUP_WEAPON_PUMPSHOTGUN'))
	end
end)

HudStage = 1
RegisterNetEvent('DoLongHudText')
AddEventHandler('DoLongHudText', function(text,color,length)
    if HudStage > 2 then return end
    if not color then color = 1 end
    if not length then length = 12000 end
    TriggerEvent("tasknotify:guiupdate",color, text, 12000)
end)

RegisterNetEvent('DoShortHudText')
AddEventHandler('DoShortHudText', function(text,color,length)
    if not color then color = 1 end
    if not length then length = 10000 end
    if HudStage > 2 then return end
    TriggerEvent("tasknotify:guiupdate",color, text, 10000)
end)

local waitKeys = false
RegisterNetEvent('car:engineHasKeys')
AddEventHandler('car:engineHasKeys', function(targetVehicle, allow)
    if IsVehicleEngineOn(targetVehicle) then
        if not waitKeys then
            waitKeys = true
            SetVehicleEngineOn(targetVehicle,0,1,1)
            SetVehicleUndriveable(targetVehicle,true)
            TriggerEvent("DoShortHudText", "Engine Halted",1)
            Citizen.Wait(300)
            waitKeys = false
        end
    else
        if not waitKeys then
            waitKeys = true
            TriggerEvent("keys:startvehicle")
            TriggerEvent("DoShortHudText", "Engine Started",1)
            Citizen.Wait(300)
            waitKeys = false
        end
    end
end)

RegisterNetEvent('car:engine')
AddEventHandler('car:engine', function()
    local targetVehicle = GetVehiclePedIsUsing(PlayerPedId())
    TriggerEvent("keys:hasKeys", 'engine', targetVehicle)
end)

-- Pop Tires If To High
local highestZ = 0
Citizen.CreateThread(function()
        local waittime = 100
        while true do
            Citizen.Wait(waittime)
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            if DoesEntityExist(veh) and not IsEntityDead(veh) then
                local model = GetEntityModel(veh)
                if not IsThisModelABoat(model) and not IsThisModelAHeli(model) and not IsThisModelAPlane(model) then
                    local vehpos = GetEntityCoords(veh)
					if IsEntityInAir(veh) then
						--print(vehpos.z)
                        waittime = 0
                        if vehpos.z > highestZ then
							highestZ = vehpos.z
							--print(highestZ)
                        end
                        DisableControlAction(0, 59)
                        DisableControlAction(0, 60)
					else						
						if highestZ - vehpos.z >= 16 then
						--	print(highestZ-vehpos.z)
                            local wheels = {0,1,4,5}
                            for i=1, math.random(2) do
								local wheel = math.random(#wheels)
								--print('pop')
                                SetVehicleTyreBurst(veh, wheels[wheel], false, 1000.0)
                                table.remove(wheels, wheel)
                            end
                            highestZ = 0
							waittime = 100
						end
						if highestZ - vehpos.z >= 16 then
						--	print(highestZ-vehpos.z)
                            for i = 0, 5 do
								if not IsVehicleTyreBurst(veh, i, true) or IsVehicleTyreBurst(veh, i, false) then
								--	print('popall')
                                    SetVehicleTyreBurst(veh, i, false, 1000.0)
                                end 
                            end
                            highestZ = 0
                            waittime = 100                           
                        else
                            highestZ = 0
                            waittime = 100
                        end
                    end
                end
            end
        end
	end)

    -- Ai Agression
    local relationshipTypes = {
        "PLAYER",
        "COP",
        "MISSION2",
        "MISSION3",
        "MISSION4",
        "MISSION5",
        "MISSION6",
        "MISSION7",
        "MISSION8",
      }
      
      Citizen.CreateThread(function()
        while true do
        Wait(600)
            for _, group in ipairs(relationshipTypes) do
              if group == "COP" then
                SetRelationshipBetweenGroups(3, `PLAYER`,GetHashKey(group))
                SetRelationshipBetweenGroups(3, GetHashKey(group), `PLAYER`)
                SetRelationshipBetweenGroups(0, `MISSION2`,GetHashKey(group))
                SetRelationshipBetweenGroups(0, GetHashKey(group), `MISSION2`)
      
              else
                SetRelationshipBetweenGroups(0, `PLAYER`,GetHashKey(group))
                SetRelationshipBetweenGroups(0, GetHashKey(group), `PLAYER`)
                SetRelationshipBetweenGroups(0, `MISSION2`,GetHashKey(group))
                SetRelationshipBetweenGroups(0, GetHashKey(group), `MISSION2`)
              end  
            SetRelationshipBetweenGroups(5, GetHashKey(group), `MISSION8`)
          end

          SetRelationshipBetweenGroups(1, `PLAYER`, `AMBIENT_GANG_WEICHENG`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_WEICHENG`, `PLAYER`)
          SetRelationshipBetweenGroups(1, `PLAYER`, `AMBIENT_GANG_FAMILY`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_FAMILY`, `PLAYER`)
          SetRelationshipBetweenGroups(1, `PLAYER`, `AMBIENT_GANG_BALLAS`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_BALLAS`, `PLAYER`)
          SetRelationshipBetweenGroups(1, `PLAYER`, `AMBIENT_GANG_SALVA`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_SALVA`, `PLAYER`)
          SetRelationshipBetweenGroups(1, `PLAYER`, `AMBIENT_GANG_MEXICAN`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_MEXICAN`, `PLAYER`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_LOST`, `AMBIENT_GANG_WEICHENG`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_WEICHENG`, `AMBIENT_GANG_LOST`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_LOST`, `AMBIENT_GANG_FAMILY`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_FAMILY`, `AMBIENT_GANG_LOST`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_LOST`, `AMBIENT_GANG_BALLAS`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_BALLAS`, `AMBIENT_GANG_LOST`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_LOST`, `AMBIENT_GANG_SALVA`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_SALVA`, `AMBIENT_GANG_LOST`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_LOST`, `AMBIENT_GANG_MEXICAN`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_MEXICAN`, `AMBIENT_GANG_LOST`)
      
      --WEST SIDE
          SetRelationshipBetweenGroups(1, `MISSION4`, `AMBIENT_GANG_WEICHENG`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_WEICHENG`, `MISSION4`)
      
      -- MEDIC / POLICE WEST SIDE
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_WEICHENG`, `MISSION2`)
          SetRelationshipBetweenGroups(1, `MISSION2`, `AMBIENT_GANG_WEICHENG`)

      --CENTRAL
          SetRelationshipBetweenGroups(1, `MISSION5`, `AMBIENT_GANG_FAMILY`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_FAMILY`, `MISSION5`)
          SetRelationshipBetweenGroups(1, `MISSION5`, `AMBIENT_GANG_BALLAS`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_BALLAS`, `MISSION5`)
      
      -- MEDIC / POLICE CENTRAL
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_BALLAS`, `MISSION2`)
          SetRelationshipBetweenGroups(1, `MISSION2`, `AMBIENT_GANG_BALLAS`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_FAMILY`, `MISSION2`)
          SetRelationshipBetweenGroups(1, `MISSION2`, `AMBIENT_GANG_FAMILY`)

      --EAST SIDE
          SetRelationshipBetweenGroups(1, `MISSION6`, `AMBIENT_GANG_SALVA`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_SALVA`, `MISSION6`)
          SetRelationshipBetweenGroups(1, `MISSION6`, `AMBIENT_GANG_MEXICAN`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_MEXICAN`, `MISSION6`)
      
      -- MEDIC / POLICE EAST SIDE
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_SALVA`, `MISSION2`)
          SetRelationshipBetweenGroups(1, `MISSION2`, `AMBIENT_GANG_SALVA`)
          SetRelationshipBetweenGroups(1, `MISSION2`, `AMBIENT_GANG_MEXICAN`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_MEXICAN`, `MISSION2`)
          SetRelationshipBetweenGroups(1, -86095805, `MISSION2`)
          SetRelationshipBetweenGroups(1, `MISSION2`, -86095805)
          SetRelationshipBetweenGroups(1,1191392768, `MISSION2`)
          SetRelationshipBetweenGroups(1, `MISSION2`,1191392768)
          SetRelationshipBetweenGroups(1, `MISSION2`, 45677184)
          SetRelationshipBetweenGroups(1, 45677184, `MISSION2`)
          SetRelationshipBetweenGroups(3, `PLAYER`, `MISSION7`)
          SetRelationshipBetweenGroups(3, `MISSION7`, `PLAYER`)
          SetRelationshipBetweenGroups(0, `MISSION7`, `COP`)
          SetRelationshipBetweenGroups(0, `COP`, `MISSION7`)
          SetRelationshipBetweenGroups(0, `MISSION2`, `MISSION7`)
          SetRelationshipBetweenGroups(0, `MISSION7`, `MISSION2`)
          SetRelationshipBetweenGroups(0, `MISSION7`, `MISSION7`)
          SetRelationshipBetweenGroups(3, `COP`,`PLAYER`)
          SetRelationshipBetweenGroups(3, `PLAYER`, `COP`)
          SetRelationshipBetweenGroups(0, `PLAYER`, `MISSION3`)
          SetRelationshipBetweenGroups(0, `MISSION3`,`PLAYER`)
      
      -- LOST MC
          SetRelationshipBetweenGroups(1, `PLAYER`, `AMBIENT_GANG_LOST`)
          SetRelationshipBetweenGroups(1, `AMBIENT_GANG_LOST`, `PLAYER`)
          SetRelationshipBetweenGroups(1,  `COP`, `AMBIENT_GANG_LOST`)
          SetRelationshipBetweenGroups(1,  `AMBIENT_GANG_LOST`, `COP`)
        end
      end)

      RegisterNetEvent('gangs:setDefaultRelations')
      AddEventHandler("gangs:setDefaultRelations",function() 
          Citizen.Wait(1000)
          for _, group in ipairs(relationshipTypes) do
            SetRelationshipBetweenGroups(0, `PLAYER`,GetHashKey(group))
            SetRelationshipBetweenGroups(0, GetHashKey(group), `PLAYER`)
            SetRelationshipBetweenGroups(0, `MISSION2`,GetHashKey(group))
            SetRelationshipBetweenGroups(0, GetHashKey(group), `MISSION2`)
            
            SetRelationshipBetweenGroups(5, GetHashKey(group), `MISSION8`)
          end
          -- mission 7 is guards at vinewood and security guards
          SetRelationshipBetweenGroups(3, `PLAYER`, `MISSION7`)
          SetRelationshipBetweenGroups(3, `MISSION7`, `PLAYER`)
          SetRelationshipBetweenGroups(0, `MISSION7`, `COP`)
          SetRelationshipBetweenGroups(0, `COP`, `MISSION7`)
          SetRelationshipBetweenGroups(0, `MISSION2`, `MISSION7`)
          SetRelationshipBetweenGroups(0, `MISSION7`, `MISSION2`)
          SetRelationshipBetweenGroups(0, `MISSION7`, `MISSION7`)

          -- players love each other even if full hatred
          SetRelationshipBetweenGroups(0, `PLAYER`, `MISSION8`)
      
          -- cops from scenarios love cops and ems logged in
          SetRelationshipBetweenGroups(0, `COP`, `MISSION2`)
      
          -- players love cops and ems
          SetRelationshipBetweenGroups(0, `PLAYER`, `MISSION2`)
          SetRelationshipBetweenGroups(0, `PLAYER`, `MISSION3`)
          SetRelationshipBetweenGroups(0, `MISSION3`,`PLAYER`)
      end)

-- Roll Up And Down Windows
RegisterNetEvent("RollUpWindow")
AddEventHandler('RollUpWindow', function()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        local playerCar = GetVehiclePedIsIn(playerPed, false)
        SetEntityAsMissionEntity(playerCar, true, true)
		if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then 
				RollUpWindow(playerCar, 0)
            else if (GetPedInVehicleSeat(playerCar, 0) == playerPed) then 
                RollUpWindow(playerCar, 1)
                else if (GetPedInVehicleSeat(playerCar, 1) == playerPed) then 
                    RollUpWindow(playerCar, 2)
                    else if (GetPedInVehicleSeat(playerCar, 2) == playerPed) then 
                        RollUpWindow(playerCar, 3)
                    end
                end
            end
		end
	end
end)

RegisterNetEvent("RollDownWindow")
AddEventHandler('RollDownWindow', function()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        local playerCar = GetVehiclePedIsIn(playerPed, false)
        SetEntityAsMissionEntity(playerCar, true, true)
		if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then 
				RollDownWindow(playerCar, 0)
            else if (GetPedInVehicleSeat(playerCar, 0) == playerPed) then 
                RollDownWindow(playerCar, 1)
                else if (GetPedInVehicleSeat(playerCar, 1) == playerPed) then 
                    RollDownWindow(playerCar, 2)
                    else if (GetPedInVehicleSeat(playerCar, 2) == playerPed) then 
                        RollDownWindow(playerCar, 3)
                    end
                end
            end
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not isHancuffed and not isDead and IsControlJustPressed(0, 27) then
            TriggerEvent("RollUpWindow")
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not isHancuffed and not isDead and IsControlJustPressed(0, 173) then
            TriggerEvent("RollDownWindow")
        end
    end
end)

-- Display CID Command
RegisterCommand("cid", function(source, args)
    local cid = exports["isPed"]:isPed("cid")
    TriggerEvent("DoLongHudText", "Your CID: "..cid)
end)


-- HUD Components
--[[
	HUD = 0;
	HUD_WANTED_STARS = 1;
	HUD_WEAPON_ICON = 2;
	HUD_CASH = 3;
	HUD_MP_CASH = 4;
	HUD_MP_MESSAGE = 5;
	HUD_VEHICLE_NAME = 6;
	HUD_AREA_NAME = 7;
	HUD_VEHICLE_CLASS = 8;
	HUD_STREET_NAME = 9;
	HUD_HELP_TEXT = 10;
	HUD_FLOATING_HELP_TEXT_1 = 11;
	HUD_FLOATING_HELP_TEXT_2 = 12;
	HUD_CASH_CHANGE = 13;
	HUD_RETICLE = 14;
	HUD_SUBTITLE_TEXT = 15;
	HUD_RADIO_STATIONS = 16;
	HUD_SAVING_GAME = 17;
	HUD_GAME_STREAM = 18;
	HUD_WEAPON_WHEEL = 19;
	HUD_WEAPON_WHEEL_STATS = 20;
	MAX_HUD_COMPONENTS = 21;
	MAX_HUD_WEAPONS = 22;
	MAX_SCRIPTED_HUD_COMPONENTS = 141;
]]--

Citizen.CreateThread(function()
	while true do
		HideHudComponentThisFrame(1)
		HideHudComponentThisFrame(2)
		HideHudComponentThisFrame(3)
		HideHudComponentThisFrame(4)
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(9)
		HideHudComponentThisFrame(13)
		HideHudComponentThisFrame(14)
		HideHudComponentThisFrame(17)
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
        HideHudComponentThisFrame(21)
		HideHudComponentThisFrame(22)
		
		DisplayAmmoThisFrame(true)

		Citizen.Wait(4)
	end
end)