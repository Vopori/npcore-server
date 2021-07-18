local lastSelectedVehicleEntity
local startCountDown
local testDriveEntity
local lastPlayerCoords
local hashListLoadedOnMemory = {}
local vehcategory
local cameracoords
local pointcamera
local spawnvehicle
local buyspawn
local blip
local inTheShop = false
local profileName
local profileMoney
local vehiclesTable = {}
local provisoryObject = {}
local rgbColorSelected = {255,255,255,}
local rgbSecondaryColorSelected = {255,255,255,}
local npcSpawned = false
local npcList = {}

RegisterNetEvent('npc-vehicleshop:openmenu')
AddEventHandler('npc-vehicleshop:openmenu', function(data)
	local ped = PlayerPedId()
	for k,v in ipairs(Cfg.Shops) do
		local dist = #(v.coords - GetEntityCoords(ped))
		if dist <= 5 then
			vehcategory = v.category
			cameracoords = v.cameracoords
			pointcamera = v.pointcamera
			spawnvehicle = v.spawnvehicle
			buyspawn = v.buyspawn
			testdrive = v.testdrive
			OpenVehicleShop()
		end
    end
end)

function createNPC()
	for k, v in pairs(Cfg.Npc) do
		local model = v.Model
		local pedType = v.PType
		local hash = GetHashKey(model)
		
		if not HasModelLoaded(hash) then
			RequestModel(hash)
			Citizen.Wait(100)
		end
		
		while not HasModelLoaded(hash) do
			Citizen.Wait(0)
		end
		
		if not npcSpawned then
			npcSpawned = true
			local npc = CreatePed(pedType, hash, v.Pos.x, v.Pos.y, v.Pos.z, v.Pos.h, false, false)
			SetEntityInvincible(npc, true)
			FreezeEntityPosition(npc, true)
			SetPedDiesWhenInjured(npc, false)
			SetPedCanRagdollFromPlayerImpact(npc, false)
			SetPedCanRagdoll(npc, false)
			SetEntityAsMissionEntity(npc, true, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			TaskStartScenarioInPlace(npc, "WORLD_HUMAN_CLIPBOARD", 0, true)
			table.insert(npcList, npc)
		end
	end
end

RegisterNetEvent('npc-vehicleshop:npcCreate')
AddEventHandler('npc-vehicleshop:npcCreate', function()  
	for k, existingNPC in pairs(npcList) do
		DeleteEntity(existingNPC)
	end
	
	npcList = {}
	npcSpawned = false
	
	createNPC()	
end)

RegisterNetEvent('npc-vehicleshop.receiveInfo')
AddEventHandler('npc-vehicleshop.receiveInfo', function(bank, name)
    if name then
        profileName = name
    end
    profileMoney = bank
end)


RegisterNetEvent('npc-vehicleshop.successfulbuy')
AddEventHandler('npc-vehicleshop.successfulbuy', function(vehicleName,vehiclePlate,value)    
    SendNUIMessage(
        {
            type = "successful-buy",
            vehicleName = vehicleName,
            vehiclePlate = vehiclePlate,
            value = value
        }
    )       
    CloseNui()
end)

RegisterNetEvent('npc-vehicleshop.notify')
AddEventHandler('npc-vehicleshop.notify', function(type, message)    
    SendNUIMessage(
        {
            type = "notify",
            typenotify = type,
            message = message,
        }
    ) 
end)

RegisterNetEvent('npc-vehicleshop.vehiclesInfos')
AddEventHandler('npc-vehicleshop.vehiclesInfos', function() 
    for k,v in pairs(VehDB.Vehicles) do 
        if v.shop == vehcategory then
            vehiclesTable[v.category] = {}   
        end
    end 

    for k,v in pairs(VehDB.Vehicles) do
        if v.shop == vehcategory then
            provisoryObject = {
                brand = v.brand,
                name = v.name,
                price = v.price,
                model = v.model,
                qtd = 5000,
            }
            table.insert(vehiclesTable[v.category], provisoryObject)
        end
    end
end)

function OpenVehicleShop()
    inTheShop = true
    TriggerServerEvent("npc-vehicleshop.requestInfo")
    TriggerEvent('npc-vehicleshop.vehiclesInfos')
    Citizen.Wait(1000)
    SendNUIMessage(
        {
            data = vehiclesTable,
            type = "display",
            playerName = profileName,
            playerMoney = profileMoney,
            testDrive = Cfg.TestDrive
        }
    )
    SetNuiFocus(true, true)
    RequestCollisionAtCoord(x, y, z)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", cameracoords.x, cameracoords.y, cameracoords.z, 0.00, 0.00, 0.00, 50.00, false, 0)
    PointCamAtCoord(cam, pointcamera.x, pointcamera.y, pointcamera.z)
    SetFocusPosAndVel(cameracoords.x, cameracoords.y, cameracoords.z, 0.0, 0.0, 0.0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1, true, true)
    DisplayHud(false)
    DisplayRadar(false)

    if lastSelectedVehicleEntity ~= nil then
        DeleteEntity(lastSelectedVehicleEntity)
    end
end

function updateSelectedVehicle(model)
    local hash = GetHashKey(model)

    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(10)
        end
    end

    if lastSelectedVehicleEntity ~= nil then
        DeleteEntity(lastSelectedVehicleEntity)
    end

    lastSelectedVehicleEntity = CreateVehicle(hash, spawnvehicle.x, spawnvehicle.y, spawnvehicle.z, spawnvehicle.w, 0, 1)

    local vehicleData = {}

    
    vehicleData.traction = GetVehicleMaxTraction(lastSelectedVehicleEntity)


    vehicleData.breaking = GetVehicleMaxBraking(lastSelectedVehicleEntity) * 0.9650553    
    if vehicleData.breaking >= 1.0 then
        vehicleData.breaking = 1.0
    end

    vehicleData.maxSpeed = GetVehicleEstimatedMaxSpeed(lastSelectedVehicleEntity) * 0.9650553
    if vehicleData.maxSpeed >= 50.0 then
        vehicleData.maxSpeed = 50.0
    end

    vehicleData.acceleration = GetVehicleAcceleration(lastSelectedVehicleEntity) * 2.6
    if  vehicleData.acceleration >= 1.0 then
        vehicleData.acceleration = 1.0
    end


    SendNUIMessage(
        {
            data = vehicleData,
            type = "updateVehicleInfos",        
        }
    )

    SetVehicleCustomPrimaryColour(lastSelectedVehicleEntity,  rgbColorSelected[1], rgbColorSelected[2], rgbColorSelected[3])
    SetVehicleCustomSecondaryColour(lastSelectedVehicleEntity,  rgbSecondaryColorSelected[1], rgbSecondaryColorSelected[2], rgbSecondaryColorSelected[3])
    SetEntityHeading(lastSelectedVehicleEntity, 89.5)
end


function rotation(dir)
    local entityRot = GetEntityHeading(lastSelectedVehicleEntity) + dir
    SetEntityHeading(lastSelectedVehicleEntity, entityRot % 360)
end

RegisterNUICallback(
    "rotate",
    function(data, cb)
        if (data["key"] == "left") then
            rotation(2)
        else
            rotation(-2)
        end
        cb("ok")
    end
)


RegisterNUICallback(
    "SpawnVehicle",
    function(data, cb)
        updateSelectedVehicle(data.modelcar)
    end
)



RegisterNUICallback(
    "RGBVehicle",
    function(data, cb)
        if data.primary then
            rgbColorSelected = data.color
            SetVehicleCustomPrimaryColour(lastSelectedVehicleEntity, math.ceil(data.color[1]), math.ceil(data.color[2]), math.ceil(data.color[3]) )
        else
            rgbSecondaryColorSelected = data.color
            SetVehicleCustomSecondaryColour(lastSelectedVehicleEntity, math.ceil(data.color[1]), math.ceil(data.color[2]), math.ceil(data.color[3]))
        end
    end
)

RegisterNUICallback(
    "Buy",
    function(data, cb)
        local newPlate     = GeneratePlate()
        local vehicleProps = GetVehicleProperties(lastSelectedVehicleEntity)
        vehicleProps.plate = newPlate
        TriggerServerEvent('npc-vehicleshop.CheckMoneyForVeh',data.modelcar, data.sale, data.name, vehicleProps)
        Wait(1500)        
    end
)


RegisterNetEvent('npc-vehicleshop.spawnVehicle')
AddEventHandler('npc-vehicleshop.spawnVehicle', function(model, plate)    
    local hash = GetHashKey(model)

    lastPlayerCoords = GetEntityCoords(PlayerPedId())
    
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(10)
        end
    end
    local vehicleBuy = CreateVehicle(hash, buyspawn.x, buyspawn.y, buyspawn.z, buyspawn.w, 1, 1)
    SetPedIntoVehicle(PlayerPedId(), vehicleBuy, -1)
    SetVehicleNumberPlateText(vehicleBuy, plate)
    TriggerEvent("keys:addNew", vehicleBuy, GetVehicleNumberPlateText(vehicleBuy))
    
    SetVehicleCustomPrimaryColour(vehicleBuy,  math.ceil(rgbColorSelected[1]), math.ceil(rgbColorSelected[2]), math.ceil(rgbColorSelected[3]))
    SetVehicleCustomSecondaryColour(vehicleBuy,  math.ceil(rgbSecondaryColorSelected[1]), math.ceil(rgbSecondaryColorSelected[2]), math.ceil(rgbSecondaryColorSelected[3]))
end)




RegisterNUICallback(
    "TestDrive",
    function(data, cb)        
        if Cfg.TestDrive then
            startCountDown = true
			local postestd = nil

            local hash = GetHashKey(data.vehicleModel)

            lastPlayerCoords = GetEntityCoords(PlayerPedId())

            if not HasModelLoaded(hash) then
                RequestModel(hash)
                while not HasModelLoaded(hash) do
                    Citizen.Wait(10)
                end
            end
        
            if testDriveEntity ~= nil then
                DeleteEntity(testDriveEntity)
            end
			
			--while postestd == nil do
			--	Citizen.Wait(0)
			--	for k,v in ipairs(testdrive) do
			--		local isthereveh = GetClosestVehicle(v.x, v.y, v.z, 3.0, 0, 70)					
			--		if isthereveh == 0 then
			--			postestd = v
			--			break
			--		end
			--	end
			--end			
			
			testDriveEntity = CreateVehicle(hash, testdrive.x, testdrive.y, testdrive.z, testdrive.w, 1, 1)
            SetPedIntoVehicle(PlayerPedId(), testDriveEntity, -1)
            TriggerEvent("keys:addNew",testDriveEntity, GetVehicleNumberPlateText(testDriveEntity))
			SetVehicleDoorsLocked(testDriveEntity, 4)
			local timeGG = GetGameTimer()

            
            SetVehicleCustomPrimaryColour(testDriveEntity,  math.ceil(rgbColorSelected[1]), math.ceil(rgbColorSelected[2]), math.ceil(rgbColorSelected[3]))
            SetVehicleCustomSecondaryColour(testDriveEntity,  math.ceil(rgbSecondaryColorSelected[1]), math.ceil(rgbSecondaryColorSelected[2]), math.ceil(rgbSecondaryColorSelected[3]))

            CloseNui()

            while startCountDown do
                local countTime
                Citizen.Wait(1)
                if GetGameTimer() < timeGG+tonumber(1000*Cfg.TestDriveTime) then
                    local secondsLeft = GetGameTimer() - timeGG
                    drawTxt('Test Drive Time Remaining: ' .. math.ceil(Cfg.TestDriveTime - secondsLeft/1000),4,0.5,0.93,0.50,255,255,255,180)
                else
                    DeleteEntity(testDriveEntity)
                    SetEntityCoords(PlayerPedId(), lastPlayerCoords)
                    startCountDown = false
                end
            end
        end
    end
)


RegisterNUICallback(
    "menuSelected",
    function(data, cb)
        local categoryVehicles

        local playerIdx = GetPlayerFromServerId(source)
        local ped = GetPlayerPed(playerIdx)
        
        if data.menuId ~= 'all' then
            categoryVehicles = vehiclesTable[data.menuId]
        else
            SendNUIMessage(
                {
                    data = vehiclesTable,
                    type = "display",
                    playerName = GetPlayerName(ped)
                }
            )
            return
        end

        SendNUIMessage(
            {
                data = categoryVehicles,
                type = "menu"
            }
        )
    end
)


RegisterNUICallback(
    "Close",
    function(data, cb)
        CloseNui()       
    end
)

function CloseNui()
    SendNUIMessage(
        {
            type = "hide"
        }
    )
    SetNuiFocus(false, false)
    if inTheShop then
        if lastSelectedVehicleEntity ~= nil then
            DeleteVehicle(lastSelectedVehicleEntity)
        end
        RenderScriptCams(false)
        DestroyAllCams(true)
        SetFocusEntity(GetPlayerPed(PlayerId())) 
        DisplayHud(true)
        DisplayRadar(true)
    end
    inTheShop = false
    vehiclesTable = {}
    provisoryObject = {}
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(1)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

-- Create Blips
Citizen.CreateThread(function ()
    for i = 1, #Cfg.Blips do    
        local actualShop = Cfg.Blips[i].blip
        if actualShop ~= nil then
            blip = AddBlipForCoord(actualShop.x, actualShop.y, actualShop.z)
            SetBlipSprite(blip, Cfg.Blips[i].blipsprite)
            SetBlipColour(blip, Cfg.Blips[i].blipcolor)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.8)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Cfg.Blips[i].blipname)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

AddEventHandler(
    "onResourceStop",
    function(resourceName)
        if resourceName == GetCurrentResourceName() then
           CloseNui()
           RemoveBlip(blip)
        end
    end
)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
	if not npcSpawned then		
		TriggerServerEvent('npc-vehicleshop:npcCreate')
	end
	
    for i = 1, #Cfg.ShowroomVehicles, 1 do
        local oldVehicle = GetClosestVehicle(Cfg.ShowroomVehicles[i].coords.x, Cfg.ShowroomVehicles[i].coords.y, Cfg.ShowroomVehicles[i].coords.z, 3.0, 0, 70)
        if oldVehicle ~= 0 then
            DeleteVehicle(oldVehicle)
        end

		local model = GetHashKey(Cfg.ShowroomVehicles[i].chosenVehicle)
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local veh = CreateVehicle(model, Cfg.ShowroomVehicles[i].coords.x, Cfg.ShowroomVehicles[i].coords.y, Cfg.ShowroomVehicles[i].coords.z, false, false)
		SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(veh)
		SetEntityInvincible(veh,true)
        SetEntityHeading(veh, Cfg.ShowroomVehicles[i].coords.w)
        SetVehicleDoorsLocked(veh, 3)

		FreezeEntityPosition(veh,true)
		SetVehicleNumberPlateText(veh, i .. "CARSALE")
    end
end)

Citizen.CreateThread(function()
	exports['npc-target']:AddBoxZone("vehshopmenu", vector3(-33.57, -1099.53, 25.42), 1.0, 1.0, {
			name="vehshopmenu",
			heading=96.2,
			debugPoly=false,
			minZ=25,
			maxZ=27.5
			}, {
				options = {
					{
						event = "npc-vehicleshop:openmenu",
						icon = "fas fa-car",
						label = "Browse Vehicle Shop",
					}
				},
				job = {"all"},
				distance = 2.0
		})
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if inTheShop then
			local light = vector3(990.42, -3002.08, -33.5)
			local dest = vector3(990.42, -3002.08, -40.0)
			local dirVector = dest - light
			DrawSpotLight(light.x, light.y, light.z, dirVector.x, dirVector.y, dirVector.z, 244, 253, 255, 100.0, 1.0, 1.0, 25.0, 1.0)
		end
	end
end)
