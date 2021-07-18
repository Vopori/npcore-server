-- Written with <3 by blurryrox.
function CreateTaxiPed(vehicle)
	local model = GetHashKey("a_m_y_stlat_01")

	if DoesEntityExist(vehicle) then
		if IsModelValid(model) then
			RequestModel(model)
			while not HasModelLoaded(model) do
				Wait(1)
			end

			local ped = CreatePedInsideVehicle(vehicle, 26, model, -1, true, false)
			SetAmbientVoiceName(ped, "A_M_M_EASTSA_02_LATINO_FULL_01")	
			SetBlockingOfNonTemporaryEvents(ped, true)
			SetEntityAsMissionEntity(ped, true, true)
			SetModelAsNoLongerNeeded(model)
			return ped
		end
	end
end

function CreateTaxi(x, y, z)
	local taxiModel = GetHashKey("taxi")

	if IsModelValid(taxiModel) then
		if IsThisModelACar(taxiModel) then
			RequestModel(taxiModel)
			while not HasModelLoaded(taxiModel) do
				Wait(1)
			end

			if not DoesEntityExist(taxiVeh) then
				local _, vector = GetNthClosestVehicleNode(x, y, z, math.random(5, 10), 0, 0, 0)
				-- GetClosestVehicleNodeWithHeading(x, y, z, outPosition, outHeading, nodeType, p6, p7)
				local sX, sY, sZ = table.unpack(vector)

				--DisplayNotify(i18n.translate("taxi_contact"), i18n.translate("taxi_dispatch"))
				TriggerEvent("DoLongHudText","The taxi cab is on his way.",2)
				PlaySoundFrontend(-1, "Text_Arrive_Tone", "Phone_SoundSet_Default", 1)
				Wait(2000)

				taxiVeh = CreateVehicle(taxiModel, sX, sY, sZ, 0, true, false)

				SetEntityAsMissionEntity(taxiVeh, true, true)
				SetVehicleEngineOn(taxiVeh, true, true, false)

				local blip = AddBlipForEntity(taxiVeh)
				SetBlipSprite(blip, 198)
				SetBlipFlashes(blip, true)
				SetBlipFlashTimer(blip, 5000)

				SetModelAsNoLongerNeeded(taxiModel)

				SetHornEnabled(taxiVeh, true)
				StartVehicleHorn(taxiVeh, 1000, GetHashKey("NORMAL"), false)

				return taxiVeh
			else
				--DisplayNotify(i18n.translate("taxi_contact"), i18n.translate("drivers_busy"))
				TriggerEvent("DoLongHudText","All our drivers are currently occupied.",2)
			end
		end
	end	
end

function DeleteTaxi(vehicle, driver)
	if DoesEntityExist(vehicle) then
		if IsPedInVehicle(PlayerPedId(), vehicle, false) then
			TaskLeaveVehicle(PlayerPedId(), vehicle, 0)
			Wait(2000)			
		end

		local blip = GetBlipFromEntity(vehicle)

		if DoesBlipExist(blip) then
			RemoveBlip(blip)
		end

		DeleteEntity(driver)
		DeleteEntity(vehicle)
	end

	if not DoesEntityExist(vehicle) and DoesEntityExist(driver) then
		DeleteEntity(driver)
	end
end

RegisterNetEvent("aiTaxi:payment-status")
AddEventHandler("aiTaxi:payment-status", function(state, fare)
	local player = PlayerId()
	Wait(1200)
	
	if state then
		PlayAmbientSpeech1(taxiPed, "THANKS", "SPEECH_PARAMS_FORCE_NORMAL")
		TriggerEvent("DoLongHudText","You have been charged $" .. fare,2)
	else
		PlayAmbientSpeech1(taxiPed, "TAXID_NO_MONEY", "SPEECH_PARAMS_FORCE_NORMAL")
		Wait(1000)
		if not IsPlayerWantedLevelGreater(player, 0) then
			SetPlayerWantedLevel(player, 3, false)
			SetPlayerWantedLevelNow(player, true)
			SetDispatchCopsForPlayer(player, true)
		end
	end

	TaskVehicleDriveWander(taxiPed, taxiVeh, 20.0, 319)
	Wait(20000)
	DeleteTaxi(taxiVeh, taxiPed)
	parking = false
	PlayerEntersTaxi = false
end)