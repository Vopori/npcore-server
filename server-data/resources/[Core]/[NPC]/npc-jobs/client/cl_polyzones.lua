NearHunting, NearHuntingSelling, NearScubaBoatRental, NearReturnBoat, IronSellSpot, SellUnknown, ProcessFish, NearWeazelNews = false, false, false, false, false, false, false
CutFish,SellSpotF = false, false
Citizen.CreateThread(function()
	exports["npc-polyzone"]:AddBoxZone("start_hunting", vector3(-773.43, 5598.26, 33.61), 1.6, 2, {
        name="hunting",
        heading=346,
        --debugPoly=true,
        minZ=30.81,
        maxZ=34.81
    }) 
    exports["npc-polyzone"]:AddBoxZone("hunting_sell", vector3(960.75, -2111.42, 31.95), 2.5, 2.5, {
        name="hunting_sell",
        heading=265,
        --debugPoly=true,
        minZ=30.95,
        maxZ=32.95
    })    


    --Scuba
    exports["npc-polyzone"]:AddBoxZone("scuba_get_boat", vector3(-1612.81, 5261.71, 3.97), 2.3, 1.5, {
        name="scuba_get_boat",
        heading=115,
        --debugPoly=true,
        minZ=2.97,
        maxZ=4.97
    })  
    exports["npc-polyzone"]:AddBoxZone("scuba_return_boat", vector3(-1602.02, 5260.31, 2.09), 7.4, 5, {
        name="scuba_return_boat",
        heading=25,
        --debugPoly=true,
        minZ=-1.11,
        maxZ=3.89
    })  
    exports["npc-polyzone"]:AddBoxZone("sell_iron_bars", vector3(2341.04, 3128.18, 48.21), 1.8, 1, {
        name="sell_iron_bars",
        heading=260,
        --debugPoly=true,
        minZ=47.21,
        maxZ=49.21
    }) 
    exports["npc-polyzone"]:AddBoxZone("sell_unknown_material", vector3(-1459.32, -413.59, 35.75), 1.8, 1, {
        name="sell_unknown_material",
        heading=75,
        --debugPoly=true,
        minZ=34.55,
        maxZ=36.95
    }) 


    -- Fishing 
    exports["npc-polyzone"]:AddBoxZone("fishing_sushi", vector3(-3248.21, 992.68, 12.49), 8.4, 5, {
        name="fishing_sushi",
        heading=85,
        --debugPoly=true,
        minZ=11.49,
        maxZ=13.44
    }) 

    exports["npc-polyzone"]:AddBoxZone("fishing_cut", vector3(-3426.17, 974.33, 8.35), 9.4, 4, {
        name="fishing_cut",
        heading=0,
        --debugPoly=true,
        minZ=7.35,
        maxZ=9.2
    }) 

    exports["npc-polyzone"]:AddBoxZone("fishing_sell", vector3(-1039.5, -1396.63, 5.42), 4.8, 4, {
        name="fishing_sell",
        heading=345,
        --debugPoly=true,
        minZ=4.42,
        maxZ=6.42
    }) 

    exports["npc-polyzone"]:AddBoxZone("idcard", vector3(256.27, -369.48, -44.14), 2.4, 1, {
        name="idcard",
        heading=70,
        --debugPoly=true,
        minZ=-45.14,
        maxZ=-43.54
    }) 

    -- Weazel News Job
    exports["npc-polyzone"]:AddBoxZone("Weazel", vector3(-598.17, -929.75, 25.34), 2.9, 5, {
        name="Weazel",
        heading=91,
        --debugPoly=true,
        minZ=22.14,
        maxZ=24.74
      })
end)

RegisterNetEvent('npc-polyzone:enter')
AddEventHandler('npc-polyzone:enter', function(name)
    if name == "start_hunting" then
        NearHunting = true
        AtHuntingSpot()
        if OnGoingHuntSession == true then
            TriggerEvent('npc-ui:ShowUI', 'show', ("[E] %s"):format("Return Vehicle"))
        else
            TriggerEvent('npc-ui:ShowUI', 'show', ("[E] %s"):format("Hunting ($500 deposit)"))
        end
    elseif name == "hunting_sell" then
        NearHuntingSelling = true
        AtSellingSpotHunting()
        TriggerEvent('npc-ui:ShowUI', 'show', ("[E] %s"):format("Hunting (Sell Meat)"))
    elseif name == "scuba_get_boat" then
        NearScubaBoatRental = true
        NearScubaBoat()
        if not canSpawn then
            TriggerEvent('npc-ui:ShowUI', 'show', ("%s"):format("Boat rented already")) 
        else
            TriggerEvent('npc-ui:ShowUI', 'show', ("[E] %s"):format("Rent Boat ($400)")) 
        end
    elseif name == 'scuba_return_boat' then
        if veh ~= 0 then
            TriggerEvent('npc-ui:ShowUI', 'show', ("[E] %s"):format("Return Boat")) 
            NearReturnBoat = true
            AtReturnSpot()
        end
    elseif name == "sell_iron_bars" then
        IronSellSpot = true
        TriggerEvent('npc-ui:ShowUI', 'show', ("[E] %s"):format("Sell Items")) 
        IronSell()
    elseif name == "sell_unknown_material" then
        SellUnknown = true
        TriggerEvent('npc-ui:ShowUI', 'show', ("[E] %s"):format("Sell Items")) 
        SellUnknownSpot()
    elseif name == "fishing_sushi" then
        ProcessFish = true
        TriggerEvent('npc-ui:ShowUI', 'show', ("[E] %s"):format("Process Cut Fish")) 
        ProcessFishSpot()
    elseif name == "fishing_cut" then
        CutFish = true
        TriggerEvent('npc-ui:ShowUI', 'show', ("[E] %s"):format("Cut Fish")) 
        CutFishSpot()
    elseif name == "fishing_sell" then
        SellSpotF = true
        TriggerEvent('npc-ui:ShowUI', 'show', ("[E] %s"):format("Sell Sushi")) 
        SellSpotFish()
    elseif name == "Weazel" then
        NearWeazelNews = true
        NearWeazelNews2()
        TriggerEvent('npc-ui:ShowUI', 'show', ("[E] %s"):format("Record The News!"))
    elseif name == "idcard" then
        NearCourthouse = true
        NearCourthouse2()
        TriggerEvent('npc-ui:ShowUI', 'show', ("[E] %s"):format("To purchase an ID ($50)"))
    end
end)

RegisterNetEvent('npc-polyzone:exit')
AddEventHandler('npc-polyzone:exit', function(name)
    if name == "start_hunting" then
        NearHunting = false
    elseif name == "hunting_sell" then
        NearHuntingSelling = false
    elseif name == "scuba_get_boat" then
        NearScubaBoatRental = false
    elseif name == 'scuba_return_boat' then
        NearReturnBoat = false
    elseif name == "sell_iron_bars" then
        IronSellSpot = false
    elseif name == "sell_unknown_material" then
        SellUnknown = false
    elseif name == "fishing_sushi" then
        ProcessFish = false
    elseif name == "fishing_cut" then
        CutFish = false
    elseif name == "fishing_sell" then
        SellSpotF = false
    elseif name == "Weazel" then
        NearWeazelNews = false
    elseif name == "idcard" then
        NearCourthouse = false
    end
    TriggerEvent('npc-ui:HideUI')
end)

function AtHuntingSpot()
    Citizen.CreateThread(function()
        while NearHunting do
            Citizen.Wait(5)
            if IsControlJustReleased(0, 38) then
                if CanHunt then
                    if OnGoingHuntSession == true then
                        StartHuntingSession()
                    else
                        if allowedHunting == true then
                            TriggerServerEvent('npc:huntingdeposit')
                        else
                            TriggerEvent("DoLongHudText", "You need to wait a little bit to do another run!", 2)
                        end
                    end
                else
                    TriggerEvent("DoLongHudText", "You need a hunting license, contact the police", 2)
                end
            end
        end
    end)
end

function AtSellingSpotHunting()
    Citizen.CreateThread(function()
        while NearHuntingSelling do
            Citizen.Wait(5)
            if IsControlJustReleased(0, 38) then
                if exports["npc-inventory"]:getQuantity("deer") >= 2 then
                    playerAnim()
                    TriggerEvent('inventory:removeItem', 'deer', 2)
                    local finished = exports["npc-taskbar"]:taskBar(4000,"Selling Goods",true,false,playerVeh)
                    if finished == 100 then
                        ClearPedTasksImmediately(PlayerPedId())
                        Citizen.Wait(1000)
                        TriggerServerEvent('npc-hunting:sell')
                    end
                end
            end
        end
    end)
end

function NearScubaBoat()
    Citizen.CreateThread(function()
        while NearScubaBoatRental do
            Citizen.Wait(5)
            if IsControlJustReleased(0, 38) then
                if exports["npc-inventory"]:hasEnoughOfItem('oxygentank',1,false) or oxyOn then
                    if canSpawn then
                        TriggerEvent("fuckoffdinghyomfgwhyisntitspawning")
                        TriggerServerEvent('npc-scuba:checkAndTakeDepo')
                        Citizen.Wait(500)
                        canSpawn = false
                        SetEntityAsMissionEntity(vehicle, true, true)
                        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                        local plate = GetVehicleNumberPlateText(vehicle)
                        TriggerEvent("keys:addNew",vehicle,plate)
                        StartDive()
                    end
                else
                    TriggerEvent('DoLongHudText', 'Sorry Man, You Wont Be Able To Breath Down There, Come Back With A Scuba Tank!.', 1)
                end
            end
        end
    end)
end

function AtReturnSpot()
    Citizen.CreateThread(function()
        while NearReturnBoat do
            Citizen.Wait(5)
            if IsControlJustReleased(0, 38) then
                DeleteVehicle(veh)
                veh = 0
                TriggerEvent('DoLongHudText', 'Thanks For Returning The Vehicles, Heres some of the Money Back!.', 1)
                RemoveBlip(allBlips)
                RemoveBlip(allBlipsSprite)
                TriggerServerEvent('npc-scuba:returnDepo')
                SetEntityCoords(GetPlayerPed(-1), -1605.7166748047, 5259.1162109375, 2.0883903503418)
                SetEntityHeading(GetPlayerPed(-1), 23.752769470215)
                Citizen.Wait(2000)
                canSpawn = true
            end
        end
    end)
end


function IronSell()
    Citizen.CreateThread(function()
        while IronSellSpot do
            Citizen.Wait(5)
            if IsControlJustReleased(0, 38) then
                if exports["npc-inventory"]:hasEnoughOfItem('ironbar',10,false) then
                    local finished = exports["npc-taskbar"]:taskBar(2000,"Selling Iron")
                    if (finished == 100) then
                        SellItems()
                    end
                else
                    TriggerEvent('DoLongHudText', 'Your missing something.', 2)
                end
            end
        end
    end)
end

function SellUnknownSpot()
    Citizen.CreateThread(function()
        while SellUnknown do
            Citizen.Wait(5)
            if IsControlJustReleased(0, 38) then
                if exports["npc-inventory"]:hasEnoughOfItem('umetal',10,false) then
                    local finished = exports["npc-taskbar"]:taskBar(5000,"Trading")
                    if (finished == 100 and payed == false) then
                        payed = true
                        TriggerServerEvent('npc-scuba:makeGold')
                        Citizen.Wait(500)
                        payed = false
                    end
                else
                    TriggerEvent('DoLongHudText', 'Your missing something.', 2)
                end
            end 
        end
    end)
end

local DoingTask = false
function ProcessFishSpot()
    Citizen.CreateThread(function()
        while ProcessFish do
            Citizen.Wait(5)
            if IsControlJustReleased(0, 38) then
                if not DoingTask then
                    if exports["npc-inventory"]:getQuantity("cutfish") >= 1 then
                        playerAnim()
                        DoingTask = true
                        TriggerEvent('inventory:removeItem', 'cutfish', 1)
                        local finished = exports["npc-taskbar"]:taskBar(4000,"Processing")
                        if finished == 100 then
                            ClearPedTasksImmediately(PlayerPedId())
                            Citizen.Wait(1000)
                            TriggerServerEvent('npc-fish:process')
                            DoingTask = false
                        else
                            DoingTask = false
                            TriggerEvent('player:receiveItem', 'cutfish', 1)
                        end
                    end
                end
            end
        end
    end)
end

local DoingTask2 = false
function CutFishSpot()
    Citizen.CreateThread(function()
        while CutFish do
            Citizen.Wait(5)
            if IsControlJustReleased(0, 38) then
                if exports["npc-inventory"]:getQuantity("fish") >= 1 then
                    playerAnim()
                    TriggerEvent('inventory:removeItem', 'fish', 1)
                    DoingTask2 = true 
                    local finished = exports["npc-taskbar"]:taskBar(4000,"Cutting")
                    if finished == 100 then
                        DoingTask2 = false
                        ClearPedTasksImmediately(PlayerPedId())
                        Citizen.Wait(1000)
                        TriggerServerEvent('npc-fish:cut')
                    else
                        DoingTask2 = false
                    end
                end
            end
        end
    end)
end


function NearWeazelNews2()
    Citizen.CreateThread(function()
        local myJob = exports["isPed"]:isPed("myJob")
        while NearWeazelNews do
            Citizen.Wait(5)
            if IsControlJustReleased(0, 38) then
                if canSpawn then
                    TriggerEvent("spawnvan")
                    Citizen.Wait(500)
                    canSpawn = false
                    SetEntityAsMissionEntity(vehicle, true, true)
                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                    local plate = GetVehicleNumberPlateText(vehicle)
                    TriggerEvent("keys:addNew",vehicle,plate)
                    TriggerEvent("makenews")
                end
            else
                TriggerEvent('DoLongHudText', "You Are Not Qualified For This Job", 1)
            end
        end
    end)
end

 function SellSpotFish()
    Citizen.CreateThread(function()
        while SellSpotF do
            Citizen.Wait(5)
            if IsControlJustReleased(0, 38) then
                TriggerEvent("sellfish")
            end
        end
    end)
end

function NearCourthouse2()
    Citizen.CreateThread(function()
        while NearCourthouse do
            Citizen.Wait(5)
            if IsControlJustReleased(0, 38) then
                TriggerServerEvent("npc:idcard")
            end
        end
    end)
end