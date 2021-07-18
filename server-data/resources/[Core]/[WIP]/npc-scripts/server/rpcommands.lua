-- RP Commands Discord Webhook
rpcommandswebhook = 'WEBHOOK_HERE' -- Change this webhook to where you want the RPCommands logging to be

-- Twitter Command
if Config.rpcommands then
if Config.twitter then
    RegisterCommand("twt", function(source, args, raw)
            if #args <= 0 then
            TriggerClientEvent('chatMessage', source, Config.missingargs)
            else
            local message = table.concat(args, " ")
            local steam = GetPlayerName(source)
            args = table.concat(args, ' ')
            TriggerClientEvent('chatMessage', -1, "TWITTER | ".. GetPlayerName(source) .."", { 30, 144, 255 }, message)
            PerformHttpRequest(rpcommandswebhook, function(err, text, headers) end, 'POST', json.encode({username = steam, content = "**TWITTER:** ".. message .."", avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
        end
    end)
    end
end
    
    -- Dispatch Command
    if Config.rpcommands then
    if Config.dispatch then
    RegisterCommand("dispatch", function(source, args, raw)
            if #args <= 0 then
            TriggerClientEvent('chatMessage', source, Config.missingargs)
            else
            local message = table.concat(args, " ")
            TriggerClientEvent('chatMessage', -1, "Dispatch | ".. GetPlayerName(source) .."", { 30, 144, 255 }, message)
            PerformHttpRequest(rpcommandswebhook, function(err, text, headers) end, 'POST', json.encode({username = steam, content = "**DISPATCH:** ".. message .."", avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
        end
    end)
    end
end
    
    -- Darkweb Command
    if Config.rpcommands then
    if Config.darkweb then
    RegisterCommand("darkweb", function(source, args, raw)
            if #args <= 0 then
            TriggerClientEvent('chatMessage', source, Config.missingargs)
            else
            local message = table.concat(args, " ")
            local steam = GetPlayerName(source)
            args = table.concat(args, ' ')
            TriggerClientEvent('chatMessage', -1, "Dark Web", { 33, 33, 38 }, message)
            PerformHttpRequest(rpcommandswebhook, function(err, text, headers) end, 'POST', json.encode({username = steam, content = "**DARKWEB:** ".. message .."", avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
        end
    end)
    end
end
    
    -- News Command
    if Config.rpcommands then
    if Config.news then
    RegisterCommand("news", function(source, args, raw)
            if #args <= 0 then
            TriggerClientEvent('chatMessage', source, Config.missingargs)
            else
            local message = table.concat(args, " ")
            local steam = GetPlayerName(source)
            args = table.concat(args, ' ')
            TriggerClientEvent('chatMessage', -1, "NEWS | ".. GetPlayerName(source) .."", { 194, 255, 51 }, message)
            PerformHttpRequest(rpcommandswebhook, function(err, text, headers) end, 'POST', json.encode({username = steam, content = "**NEWS:** ".. message .."", avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
        end
    end)
    end
end
    -- Do Command
    if Config.rpcommands then
    if Config.doo then
    RegisterCommand("do", function(source, args, raw)
            if #args <= 0 then
            TriggerClientEvent('chatMessage', source, Config.missingargs)
            else
            local message = table.concat(args, " ")
            TriggerClientEvent('chatMessage', -1, "Do | ".. GetPlayerName(source) .."", { 51, 153, 255 }, message)
            PerformHttpRequest(rpcommandswebhook, function(err, text, headers) end, 'POST', json.encode({username = steam, content = "**DO:** ".. message .."", avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
        end
    end)
    end
end
    
    -- OOC Command
    if Config.rpcommands then
    if Config.ooc then
    RegisterCommand("ooc", function(source, args, raw)
            if #args <= 0 then
            TriggerClientEvent('chatMessage', source, Config.missingargs)
            else
            local message = table.concat(args, " ")
            local steam = GetPlayerName(source)
            args = table.concat(args, ' ')
            TriggerClientEvent('chatMessage', -1, "OOC | ".. GetPlayerName(source) .."", { 128, 128, 128 }, message)
            PerformHttpRequest(rpcommandswebhook, function(err, text, headers) end, 'POST', json.encode({username = steam, content = "**OOC:** ".. message .."", avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
        end
    end)
    end
end
    -- Me Command
    if Config.rpcommands then
    if Config.me then
    RegisterCommand("me", function(source, args, raw)
            if #args <= 0 then
            TriggerClientEvent('chatMessage', source, Config.missingargs)
            else
            local message = table.concat(args, " ")
            local steam = GetPlayerName(source)
            args = table.concat(args, ' ')
            TriggerClientEvent('chatMessage', -1, "Me | ".. GetPlayerName(source) .."", { 255, 0, 0 }, message)
            PerformHttpRequest(rpcommandswebhook, function(err, text, headers) end, 'POST', json.encode({username = steam, content = "**ME:** ".. message .."", avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
        end
    end)
    end
end
    
    -- ShowID Command
    if Config.rpcommands then
    if Config.showid then
    RegisterCommand("showid", function(source, color, msg)
        cm = stringsplit(msg, " ")
            CancelEvent()
            if tablelength(cm) == 3 then
                local firstname = tostring(cm[2])
                local lastname = tostring(cm[3])
                local steam = GetPlayerName(source)
                TriggerClientEvent("RPCore:sendMessageShowID", -1, source, firstname, lastname)
                PerformHttpRequest(rpcommandswebhook, function(err, text, headers) end, 'POST', json.encode({username = steam, content = '**ShowID** | **First Name:** ' .. firstname .. ' **Last Name:** ' .. lastname .. '', avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
                
            else
                TriggerClientEvent('chatMessage', source, "Use the following format:", {255, 0, 0}, "/showid [First Name] [Last Name]")
            end
        end)
    end
end
    
    
      
    function stringsplit(inputstr, sep)
        if sep == nil then
            sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
        end
        return t
    end
    
    
    
    function tablelength(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end

-- 3D Me Command
RegisterServerEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text)
	TriggerClientEvent('3dme:triggerDisplay', -1, text, source)
end)

-- Carry Command
RegisterServerEvent('CarryPeople:sync')
AddEventHandler('CarryPeople:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('CarryPeople:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('CarryPeople:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('CarryPeople:stop')
AddEventHandler('CarryPeople:stop', function(targetSrc)
	TriggerClientEvent('CarryPeople:cl_stop', targetSrc)
end)

-- Take Hostage Command
RegisterServerEvent('cmg3_animations:sync')
AddEventHandler('cmg3_animations:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget,attachFlag, emote)
	TriggerClientEvent('cmg3_animations:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget,attachFlag, emote)
	TriggerClientEvent('cmg3_animations:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('cmg3_animations:stop')
AddEventHandler('cmg3_animations:stop', function(targetSrc)
	TriggerClientEvent('cmg3_animations:cl_stop', targetSrc)
end)

-- Piggyback Command
local piggybacking = {}
--piggybacking[source] = targetSource, source is piggybacking targetSource
local beingPiggybacked = {}
--beingPiggybacked[targetSource] = source, targetSource is beingPiggybacked by source

RegisterServerEvent("Piggyback:sync")
AddEventHandler("Piggyback:sync", function(targetSrc)
	local source = source
	local sourcePed = GetPlayerPed(source)
    	local sourceCoords = GetEntityCoords(sourcePed)
	local targetPed = GetPlayerPed(targetSrc)
    	local targetCoords = GetEntityCoords(targetPed)
	if #(sourceCoords - targetCoords) <= 3.0 then 
		TriggerClientEvent("Piggyback:syncTarget", targetSrc, source)
		piggybacking[source] = targetSrc
		beingPiggybacked[targetSrc] = source
	end
end)

RegisterServerEvent("Piggyback:stop")
AddEventHandler("Piggyback:stop", function(targetSrc)
	local source = source

	if piggybacking[source] then
		TriggerClientEvent("Piggyback:cl_stop", targetSrc)
		piggybacking[source] = nil
		beingPiggybacked[targetSrc] = nil
	elseif beingPiggybacked[source] then
		TriggerClientEvent("Piggyback:cl_stop", beingPiggybacked[source])
		beingPiggybacked[source] = nil
		piggybacking[beingPiggybacked[source]] = nil
	end
end)

AddEventHandler('playerDropped', function(reason)
	local source = source
	
	if piggybacking[source] then
		TriggerClientEvent("Piggyback:cl_stop", piggybacking[source])
		beingPiggybacked[piggybacking[source]] = nil
		piggybacking[source] = nil
	end

	if beingPiggybacked[source] then
		TriggerClientEvent("Piggyback:cl_stop", beingPiggybacked[source])
		piggybacking[beingPiggybacked[source]] = nil
		beingPiggybacked[source] = nil
	end
end)

-- Take Hostage Command
local takingHostage = {}
--takingHostage[source] = targetSource, source is takingHostage targetSource
local takenHostage = {}
--takenHostage[targetSource] = source, targetSource is being takenHostage by source

RegisterServerEvent("TakeHostage:sync")
AddEventHandler("TakeHostage:sync", function(targetSrc)
	local source = source

	TriggerClientEvent("TakeHostage:syncTarget", targetSrc, source)
	takingHostage[source] = targetSrc
	takenHostage[targetSrc] = source
end)

RegisterServerEvent("TakeHostage:releaseHostage")
AddEventHandler("TakeHostage:releaseHostage", function(targetSrc)
	local source = source
	if takenHostage[targetSrc] then 
		TriggerClientEvent("TakeHostage:releaseHostage", targetSrc, source)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	end
end)

RegisterServerEvent("TakeHostage:killHostage")
AddEventHandler("TakeHostage:killHostage", function(targetSrc)
	local source = source
	if takenHostage[targetSrc] then 
		TriggerClientEvent("TakeHostage:killHostage", targetSrc, source)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	end
end)

RegisterServerEvent("TakeHostage:stop")
AddEventHandler("TakeHostage:stop", function(targetSrc)
	local source = source

	if takingHostage[source] then
		TriggerClientEvent("TakeHostage:cl_stop", targetSrc)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	elseif takenHostage[source] then
		TriggerClientEvent("TakeHostage:cl_stop", targetSrc)
		takenHostage[source] = nil
		takingHostage[targetSrc] = nil
	end
end)

AddEventHandler('playerDropped', function(reason)
	local source = source
	
	if takingHostage[source] then
		TriggerClientEvent("TakeHostage:cl_stop", takingHostage[source])
		takenHostage[takingHostage[source]] = nil
		takingHostage[source] = nil
	end

	if takenHostage[source] then
		TriggerClientEvent("TakeHostage:cl_stop", takenHostage[source])
		takingHostage[takenHostage[source]] = nil
		takenHostage[source] = nil
	end
end)
