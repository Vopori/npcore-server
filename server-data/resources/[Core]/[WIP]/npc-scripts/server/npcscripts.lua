-- Carwash Script
RegisterServerEvent('carwash:checkmoney')
AddEventHandler('carwash:checkmoney', function()
	local src = source
	local player = exports["npc-core"]:getModule("Player"):GetUser(src)
	local costs = 70

	if player:getCash() >= costs then
		TriggerClientEvent("carwash:success", src)
		player:removeMoney(costs)
	else
		moneyleft = costs - player:getCash()
		TriggerClientEvent('notenoughmoney', src, moneyleft)
	end
end)

-- Debug Script
local RecentLogs = {}

local function LogClientError(resource, err)
    local src = source
    if not src or not resource or not err then return end

    if #err > 3000 then return end

    local recent = RecentLogs[src]
    if recent and GetGameTimer() - recent < 2000 then return end
    RecentLogs[src] = GetGameTimer()

    local tmp = {
        time = os.date("%x - %I:%M:%S"),
        error = err,
        ownersrc = src,
        ownername = GetPlayerName(src),
        identifier = GetPlayerEndpoint(src),
        resource = resource
    }

    local formattedString = "%s: [%d]%s - %s - %s \n%s\n\n"
    formattedString = string.format(formattedString, tmp.time, tmp.ownersrc, tmp.ownername, tmp.identifier, tmp.resource, tmp.error)

    local dir = "errorlogs"
    local _file = string.format("%s/%s.txt", dir, tmp.identifier)
    local file = io.open(_file, "a")
    local cmd = string.format( "mkdir %s", dir)

    if not file then
        os.execute(cmd)
        file = io.open(_file, "a")
    end

    if file then
        file:write(formattedString)
        file:close()
    end
end

RegisterNetEvent("MG:LogClientError")
AddEventHandler("MG:LogClientError", LogClientError)

-- Density Script
RegisterNetEvent('npc:peds:rogue')
AddEventHandler('npc:peds:rogue', function(toDelete)
  if toDelete == nil then return end

  TriggerClientEvent("npc:peds:rogue:delete",-1, toDelete)
end)

-- Portals Script
RegisterServerEvent("npc-portals:get:coords")
AddEventHandler("npc-portals:get:coords", function()
    local hiddenmeth = vector3(1000.7489013672, -2011.9045410156, 31.77735710144) 
    -- local leavecoords = vector3(1088.1312255859, -3187.5009765625 + 0.3, -38.993473052979)
    local enterrecycle = vector3(580.54571533203, -422.21768188477, 24.73034286499)
    local leaverecycle = vector3(997.51324462891, -3091.9892578125, -38.999923706055)
    local hiddenCraft = vector3(474.93255615234, -1308.3104248047, 29.206659317017)
    -- local hiddenmeth = vector3(150.52998352051, 322.67651367188, 112.33367919922)
    local hiddenmethleave = vector3(997.06408691406, -3200.4626464844, -36.393661499023)
    TriggerClientEvent("npc-portals:recieve:coords", source, entercoords, leavecoords, enterrecycle, leaverecycle, hiddenCraft, hiddenmeth, hiddenmethleave)
end)

-- Rehab Script
RegisterCommand('rehab', function(source, args)
    local src = source
	local user = exports["npc-core"]:getModule("Player"):GetUser(src)

    if user:getVar("job") == 'therapist' or user:getVar("job") == 'doctor' then
        if args[1] then
            if args[2] == tryue then
                TriggerClientEvent("beginJailRehab", args[1], true)
            else
                TriggerClientEvent("beginJailRehab", args[1], false)
            end
        else
            TriggerClientEvent("DoLongHudText", src, 'There are no player with this ID.', 2)
        end
    end
end)

-- Particles Script
RegisterServerEvent('particle:StartParticleAtLocation')
AddEventHandler('particle:StartParticleAtLocation', function(x,y,z,particle,id,rx,ry,rz)
TriggerClientEvent('particle:StartClientParticle', -1, x,y,z,particle,id,rx,ry,rz)
end)

RegisterServerEvent('particle:StopParticle')
AddEventHandler('particle:StopParticle', function(x,y,z,particle,id,rx,ry,rz)
TriggerClientEvent('particle:StopParticleClient', -1, id)
end)