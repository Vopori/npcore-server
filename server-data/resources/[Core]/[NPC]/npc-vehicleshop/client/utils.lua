local NumberCharset = {}
local Charset = {}
local Platetakencheck = false
local isPlateTaken = nil

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

RegisterNetEvent('npc-vehicleshop.isPlateTaken')
AddEventHandler('npc-vehicleshop.isPlateTaken', function(bool)
	isPlateTaken = bool
	Platetakencheck = true
end)

function GeneratePlate()
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		if Cfg.PlateUseSpace then
			generatedPlate = string.upper(GetRandomLetter(Cfg.PlateLetters) .. '-' ..  GetRandomNumber(Cfg.PlateNumbers))
		else
			generatedPlate = string.upper(GetRandomLetter(Cfg.PlateLetters) .. GetRandomNumber(Cfg.PlateNumbers))
		end
		
		TriggerServerEvent('npc-vehicleshop.isPlateTaken', generatedPlate)
		
		while not Platetakencheck do
			Citizen.Wait(0)
		end
			
		if not isPlateTaken then			
			doBreak = true
			Platetakencheck = false
		end

		if doBreak then
			break
		end
	end

	return generatedPlate
end

--function IsPlateTaken(plate)
--	local callback = 'waiting'
--
--	QBCore.Functions.TriggerCallback('qb-vehicleshop.isPlateTaken', function(isPlateTaken)
--		callback = isPlateTaken
--	end, plate)
--
--	while type(callback) == 'string' do
--		Citizen.Wait(0)
--	end
--
--	return callback
--end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

function Round(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

function Trim(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

function GetVehicleProperties(vehicle)
	if DoesEntityExist(vehicle) then		
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		local extras = {}

		for extraId=0, 12 do
			if DoesExtraExist(vehicle, extraId) then
				local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
				extras[tostring(extraId)] = state
			end
		end

		return {
			model             = GetEntityModel(vehicle),

			plate             = Trim(GetVehicleNumberPlateText(vehicle)),
			plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),
			
			bodyHealth        = Round(GetVehicleBodyHealth(vehicle), 1),
			engineHealth      = Round(GetVehicleEngineHealth(vehicle), 1),
			tankHealth        = Round(GetVehiclePetrolTankHealth(vehicle), 1),

			fuelLevel         = Round(GetVehicleFuelLevel(vehicle), 1),
			dirtLevel         = Round(GetVehicleDirtLevel(vehicle), 1),
			
			color1            = colorPrimary,
			color2            = colorSecondary,

			pearlescentColor  = pearlescentColor,
			wheelColor        = wheelColor,

			wheels            = GetVehicleWheelType(vehicle),
			windowTint        = GetVehicleWindowTint(vehicle),
			xenonColor        = GetVehicleXenonLightsColour(vehicle),

			neonEnabled       = {
				IsVehicleNeonLightEnabled(vehicle, 0),
				IsVehicleNeonLightEnabled(vehicle, 1),
				IsVehicleNeonLightEnabled(vehicle, 2),
				IsVehicleNeonLightEnabled(vehicle, 3)
			},

			neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
			extras            = extras,
			tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

			modSpoilers       = GetVehicleMod(vehicle, 0),
			modFrontBumper    = GetVehicleMod(vehicle, 1),
			modRearBumper     = GetVehicleMod(vehicle, 2),
			modSideSkirt      = GetVehicleMod(vehicle, 3),
			modExhaust        = GetVehicleMod(vehicle, 4),
			modFrame          = GetVehicleMod(vehicle, 5),
			modGrille         = GetVehicleMod(vehicle, 6),
			modHood           = GetVehicleMod(vehicle, 7),
			modFender         = GetVehicleMod(vehicle, 8),
			modRightFender    = GetVehicleMod(vehicle, 9),
			modRoof           = GetVehicleMod(vehicle, 10),

			modEngine         = GetVehicleMod(vehicle, 11),
			modBrakes         = GetVehicleMod(vehicle, 12),
			modTransmission   = GetVehicleMod(vehicle, 13),
			modHorns          = GetVehicleMod(vehicle, 14),
			modSuspension     = GetVehicleMod(vehicle, 15),
			modArmor          = GetVehicleMod(vehicle, 16),

			modTurbo          = IsToggleModOn(vehicle, 18),
			modSmokeEnabled   = IsToggleModOn(vehicle, 20),
			modXenon          = IsToggleModOn(vehicle, 22),

			modFrontWheels    = GetVehicleMod(vehicle, 23),
			modBackWheels     = GetVehicleMod(vehicle, 24),

			modPlateHolder    = GetVehicleMod(vehicle, 25),
			modVanityPlate    = GetVehicleMod(vehicle, 26),
			modTrimA          = GetVehicleMod(vehicle, 27),
			modOrnaments      = GetVehicleMod(vehicle, 28),
			modDashboard      = GetVehicleMod(vehicle, 29),
			modDial           = GetVehicleMod(vehicle, 30),
			modDoorSpeaker    = GetVehicleMod(vehicle, 31),
			modSeats          = GetVehicleMod(vehicle, 32),
			modSteeringWheel  = GetVehicleMod(vehicle, 33),
			modShifterLeavers = GetVehicleMod(vehicle, 34),
			modAPlate         = GetVehicleMod(vehicle, 35),
			modSpeakers       = GetVehicleMod(vehicle, 36),
			modTrunk          = GetVehicleMod(vehicle, 37),
			modHydrolic       = GetVehicleMod(vehicle, 38),
			modEngineBlock    = GetVehicleMod(vehicle, 39),
			modAirFilter      = GetVehicleMod(vehicle, 40),
			modStruts         = GetVehicleMod(vehicle, 41),
			modArchCover      = GetVehicleMod(vehicle, 42),
			modAerials        = GetVehicleMod(vehicle, 43),
			modTrimB          = GetVehicleMod(vehicle, 44),
			modTank           = GetVehicleMod(vehicle, 45),
			modWindows        = GetVehicleMod(vehicle, 46),
			modLivery         = GetVehicleMod(vehicle, 48),
		}
	else
		return
	end
end

function SetVehicleProperties(vehicle, props)
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleModKit(vehicle, 0)

		if props.plate ~= nil then
			SetVehicleNumberPlateText(vehicle, props.plate)
		end

		if props.plateIndex ~= nil then
			SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
		end

		if props.bodyHealth ~= nil then
			SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
		end

		if props.engineHealth ~= nil then
			SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
		end

		if props.fuelLevel ~= nil then
			SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0)
		end

		if props.dirtLevel ~= nil then
			SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
		end

		if props.color1 ~= nil then
            SetVehicleColours(vehicle, props.color1, colorSecondary)
		end

		if props.color2 ~= nil then
            SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2)
		end

		if props.pearlescentColor ~= nil then
            SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
		end

		if props.wheelColor ~= nil then
            SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor)
		end

		if props.wheels ~= nil then
			SetVehicleWheelType(vehicle, props.wheels)
		end

		if props.windowTint ~= nil then
			SetVehicleWindowTint(vehicle, props.windowTint)
		end

		if props.neonEnabled ~= nil then
			SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
			SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
			SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
			SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
		end

		if props.extras ~= nil then
			for id,enabled in pairs(props.extras) do
				if enabled then
					SetVehicleExtra(vehicle, tonumber(id), 0)
				else
					SetVehicleExtra(vehicle, tonumber(id), 1)
				end
			end
		end

		if props.neonColor ~= nil then
			SetVehicleNeonLightsColour(vehicle, props.neonColor["1"], props.neonColor["2"], props.neonColor["3"])
		end

		if props.modSmokeEnabled ~= nil then
			ToggleVehicleMod(vehicle, 20, true)
		end

		if props.tyreSmokeColor ~= nil then
			SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor["1"], props.tyreSmokeColor["2"], props.tyreSmokeColor["3"])
		end

		if props.modSpoilers ~= nil then
			SetVehicleMod(vehicle, 0, props.modSpoilers, false)
		end

		if props.modFrontBumper ~= nil then
			SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
		end

		if props.modRearBumper ~= nil then
			SetVehicleMod(vehicle, 2, props.modRearBumper, false)
		end

		if props.modSideSkirt ~= nil then
			SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
		end

		if props.modExhaust ~= nil then
			SetVehicleMod(vehicle, 4, props.modExhaust, false)
		end

		if props.modFrame ~= nil then
			SetVehicleMod(vehicle, 5, props.modFrame, false)
		end

		if props.modGrille ~= nil then
			SetVehicleMod(vehicle, 6, props.modGrille, false)
		end

		if props.modHood ~= nil then
			SetVehicleMod(vehicle, 7, props.modHood, false)
		end

		if props.modFender ~= nil then
			SetVehicleMod(vehicle, 8, props.modFender, false)
		end

		if props.modRightFender ~= nil then
			SetVehicleMod(vehicle, 9, props.modRightFender, false)
		end

		if props.modRoof ~= nil then
			SetVehicleMod(vehicle, 10, props.modRoof, false)
		end

		if props.modEngine ~= nil then
			SetVehicleMod(vehicle, 11, props.modEngine, false)
		end

		if props.modBrakes ~= nil then
			SetVehicleMod(vehicle, 12, props.modBrakes, false)
		end

		if props.modTransmission ~= nil then
			SetVehicleMod(vehicle, 13, props.modTransmission, false)
		end

		if props.modHorns ~= nil then
			SetVehicleMod(vehicle, 14, props.modHorns, false)
		end

		if props.modSuspension ~= nil then
			SetVehicleMod(vehicle, 15, props.modSuspension, false)
		end

		if props.modArmor ~= nil then
			SetVehicleMod(vehicle, 16, props.modArmor, false)
		end

		if props.modTurbo ~= nil then
			ToggleVehicleMod(vehicle,  18, props.modTurbo)
		end

		if props.modXenon ~= nil then
			ToggleVehicleMod(vehicle,  22, props.modXenon)
		end

		if props.xenonColor ~= nil then
			SetVehicleXenonLightsColor(vehicle, props.xenonColor)
		end

		if props.modFrontWheels ~= nil then
			SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
		end

		if props.modBackWheels ~= nil then
			SetVehicleMod(vehicle, 24, props.modBackWheels, false)
		end

		if props.modPlateHolder ~= nil then
			SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
		end

		if props.modVanityPlate ~= nil then
			SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
		end

		if props.modTrimA ~= nil then
			SetVehicleMod(vehicle, 27, props.modTrimA, false)
		end

		if props.modOrnaments ~= nil then
			SetVehicleMod(vehicle, 28, props.modOrnaments, false)
		end

		if props.modDashboard ~= nil then
			SetVehicleMod(vehicle, 29, props.modDashboard, false)
		end

		if props.modDial ~= nil then
			SetVehicleMod(vehicle, 30, props.modDial, false)
		end

		if props.modDoorSpeaker ~= nil then
			SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
		end

		if props.modSeats ~= nil then
			SetVehicleMod(vehicle, 32, props.modSeats, false)
		end

		if props.modSteeringWheel ~= nil then
			SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
		end

		if props.modShifterLeavers ~= nil then
			SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
		end

		if props.modAPlate ~= nil then
			SetVehicleMod(vehicle, 35, props.modAPlate, false)
		end

		if props.modSpeakers ~= nil then
			SetVehicleMod(vehicle, 36, props.modSpeakers, false)
		end

		if props.modTrunk ~= nil then
			SetVehicleMod(vehicle, 37, props.modTrunk, false)
		end

		if props.modHydrolic ~= nil then
			SetVehicleMod(vehicle, 38, props.modHydrolic, false)
		end

		if props.modEngineBlock ~= nil then
			SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
		end

		if props.modAirFilter ~= nil then
			SetVehicleMod(vehicle, 40, props.modAirFilter, false)
		end

		if props.modStruts ~= nil then
			SetVehicleMod(vehicle, 41, props.modStruts, false)
		end

		if props.modArchCover ~= nil then
			SetVehicleMod(vehicle, 42, props.modArchCover, false)
		end

		if props.modAerials ~= nil then
			SetVehicleMod(vehicle, 43, props.modAerials, false)
		end

		if props.modTrimB ~= nil then
			SetVehicleMod(vehicle, 44, props.modTrimB, false)
		end

		if props.modTank ~= nil then
			SetVehicleMod(vehicle, 45, props.modTank, false)
		end

		if props.modWindows ~= nil then
			SetVehicleMod(vehicle, 46, props.modWindows, false)
		end

		if props.modLivery ~= nil then
			SetVehicleMod(vehicle, 48, props.modLivery, false)
			SetVehicleLivery(vehicle, props.modLivery)
		end
	end
end