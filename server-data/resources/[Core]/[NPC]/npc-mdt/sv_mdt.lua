RegisterServerEvent("npc-mdt:Open")
AddEventHandler("npc-mdt:Open", function(type)
	local usource = source
	local user = exports["npc-base"]:getModule("Player"):GetUser(usource)
    local characterId = user:getVar("character").id
	if type == "police" then
		exports.ghmattimysql:execute("SELECT * FROM character_passes WHERE cid = @cid", {['cid'] = characterId}, function(result)
			if result[1].pass_type == 'police' then
				exports.ghmattimysql:execute("SELECT * FROM (SELECT * FROM `mdt_reports` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(reports)
					for r = 1, #reports do
						reports[r].charges = json.decode(reports[r].charges)
					end
					exports.ghmattimysql:execute("SELECT * FROM (SELECT * FROM `mdt_warrants` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(warrants)
						for w = 1, #warrants do
							warrants[w].charges = json.decode(warrants[w].charges)
						end

						local officer = GetCharacterName(usource)
						TriggerClientEvent('npc-mdt:toggleVisibilty', usource, reports, warrants, officer, "Police")
					end)
				end)
			end
		end)
	elseif type == "DOJ" then
		exports.ghmattimysql:execute("SELECT * FROM character_passes WHERE cid = @cid", {['cid'] = characterId}, function(result2)
			if result2[1].pass_type == 'DOJ' and result2[1].rank >= 3 then
				exports.ghmattimysql:execute("SELECT * FROM (SELECT * FROM `mdt_reports` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(reports)
					for r = 1, #reports do
						reports[r].charges = json.decode(reports[r].charges)
					end
					exports.ghmattimysql:execute("SELECT * FROM (SELECT * FROM `mdt_warrants` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(warrants)
						for w = 1, #warrants do
							warrants[w].charges = json.decode(warrants[w].charges)
						end

						local officer = GetCharacterName(usource)
						TriggerClientEvent('npc-mdt:toggleVisibilty', usource, reports, warrants, officer, "Police")
					end)
				end)
			end
		end)
	end
end)

RegisterServerEvent("npc-mdt:getOffensesAndOfficer")
AddEventHandler("npc-mdt:getOffensesAndOfficer", function()
	local usource = source
	local charges = {}
	exports.ghmattimysql:execute('SELECT * FROM fine_types', {
	}, function(fines)
		for j = 1, #fines do
			if fines[j].category == 0 or fines[j].category == 1 or fines[j].category == 2 or fines[j].category == 3 then
				table.insert(charges, fines[j])
			end
		end

		local officer = GetCharacterName(usource)

		TriggerClientEvent("npc-mdt:returnOffensesAndOfficer", usource, charges, officer)
	end)
end)

RegisterServerEvent("npc-mdt:performOffenderSearch")
AddEventHandler("npc-mdt:performOffenderSearch", function(query)
	local usource = source
	local matches = {}
	exports.ghmattimysql:execute("SELECT * FROM `characters` WHERE LOWER(`first_name`) LIKE @query OR LOWER(`last_name`) LIKE @query OR CONCAT(LOWER(`first_name`), ' ', LOWER(`last_name`)) LIKE @query", {
		['@query'] = string.lower('%'..query..'%') -- % wildcard, needed to search for all alike results
	}, function(result)

		for index, data in ipairs(result) do
			table.insert(matches, data)
		end

		TriggerClientEvent("npc-mdt:returnOffenderSearchResults", usource, matches)
	end)
end)

RegisterServerEvent("npc-mdt:getOffenderDetails")
AddEventHandler("npc-mdt:getOffenderDetails", function(offender)
	local usource = source
	local result = exports.ghmattimysql:executeSync('SELECT * FROM `user_mdt` WHERE `char_id` = @id', {
		['@id'] = offender.id
	})
	offender.notes = ""
	offender.mugshot_url = ""
	offender.bail = false
	if result[1] then
		offender.notes = result[1].notes
		offender.mugshot_url = result[1].mugshot_url
		offender.bail = result[1].bail
	end

	local convictions = exports.ghmattimysql:executeSync('SELECT * FROM `user_convictions` WHERE `char_id` = @id', {
		['@id'] = offender.id
	})
	if convictions[1] then
		offender.convictions = {}
		for i = 1, #convictions do
			local conviction = convictions[i]
			offender.convictions[conviction.offense] = conviction.count
		end
	end

	local warrants = exports.ghmattimysql:executeSync('SELECT * FROM `mdt_warrants` WHERE `char_id` = @id', {
		['@id'] = offender.id
	})
	if warrants[1] then
		offender.haswarrant = true
	end

	local phone_number = exports.ghmattimysql:executeSync('SELECT `phone_number` FROM `characters` WHERE `id` = @id', {
		['@id'] = offender.id
	})
	offender.phone_number = phone_number[1].phone_number

	-- local vehicles = exports.ghmattimysql:executeSync('SELECT * FROM `characters_cars` WHERE `cid` = @cid', {
	-- 	['@cid'] = offender.id
	-- })
	-- for i = 1, #vehicles do
	-- 	vehicles[i].state, vehicles[i].stored, vehicles[i].job, vehicles[i].fourrieremecano, vehicles[i].vehiclename, vehicles[i].ownerName = nil
	-- 	vehicles[i].vehicle = json.decode(vehicles[i].vehicle)
	-- 	vehicles[i].model = vehicles[i].vehicle.model
	-- 	if vehicles[i].vehicle.color1 then
	-- 		if colors[tostring(vehicles[i].vehicle.color2)] and colors[tostring(vehicles[i].vehicle.color1)] then
	-- 			vehicles[i].color = colors[tostring(vehicles[i].vehicle.color2)] .. " on " .. colors[tostring(vehicles[i].vehicle.color1)]
	-- 		elseif colors[tostring(vehicles[i].vehicle.color1)] then
	-- 			vehicles[i].color = colors[tostring(vehicles[i].vehicle.color1)]
	-- 		elseif colors[tostring(vehicles[i].vehicle.color2)] then
	-- 			vehicles[i].color = colors[tostring(vehicles[i].vehicle.color2)]
	-- 		else
	-- 			vehicles[i].color = "Unknown"
	-- 		end
	-- 	end
	-- 	vehicles[i].vehicle = nil
	-- end
	-- offender.vehicles = vehicles

	TriggerClientEvent("npc-mdt:returnOffenderDetails", usource, offender)
end)

RegisterServerEvent("npc-mdt:getOffenderDetailsById")
AddEventHandler("npc-mdt:getOffenderDetailsById", function(char_id)
	local usource = source

	local result = exports.ghmattimysql:executeSync('SELECT * FROM `characters` WHERE `id` = @id', {
		['@id'] = char_id
	})
	local offender = result[1]

	if not offender then
		TriggerClientEvent("npc-mdt:closeModal", usource)
		TriggerClientEvent("npc-mdt:sendNotification", usource, "This person no longer exists.")
		return
	end

	local result = exports.ghmattimysql:executeSync('SELECT * FROM `user_mdt` WHERE `char_id` = @id', {
		['@id'] = offender.id
	})
	offender.notes = ""
	offender.mugshot_url = ""
	offender.bail = false
	if result[1] then
		offender.notes = result[1].notes
		offender.mugshot_url = result[1].mugshot_url
		offender.bail = result[1].bail
	end

	local convictions = exports.ghmattimysql:executeSync('SELECT * FROM `user_convictions` WHERE `char_id` = @id', {
		['@id'] = offender.id
	}) 
	if convictions[1] then
		offender.convictions = {}
		for i = 1, #convictions do
			local conviction = convictions[i]
			offender.convictions[conviction.offense] = conviction.count
		end
	end

	local warrants = exports.ghmattimysql:executeSync('SELECT * FROM `mdt_warrants` WHERE `char_id` = @id', {
		['@id'] = offender.id
	})
	if warrants[1] then
		offender.haswarrant = true
	end

	local phone_number = exports.ghmattimysql:executeSync('SELECT `phone_number` FROM `characters` WHERE `id` = @id', {
		['@id'] = offender.id
	})
	offender.phone_number = phone_number[1].phone_number

	-- local vehicles = exports.ghmattimysql:executeSync('SELECT * FROM `characters_cars` WHERE `cid` = @cid', {
	-- 	['@cid'] = offender.id
	-- })
	-- for i = 1, #vehicles do
	-- 	vehicles[i].state, vehicles[i].stored, vehicles[i].job, vehicles[i].fourrieremecano, vehicles[i].vehiclename, vehicles[i].ownerName = nil
	-- 	vehicles[i].vehicle = json.decode(vehicles[i].vehicle)
	-- 	vehicles[i].model = vehicles[i].vehicle.model
	-- 	if vehicles[i].vehicle.color1 then
	-- 		if colors[tostring(vehicles[i].vehicle.color2)] and colors[tostring(vehicles[i].vehicle.color1)] then
	-- 			vehicles[i].color = colors[tostring(vehicles[i].vehicle.color2)] .. " on " .. colors[tostring(vehicles[i].vehicle.color1)]
	-- 		elseif colors[tostring(vehicles[i].vehicle.color1)] then
	-- 			vehicles[i].color = colors[tostring(vehicles[i].vehicle.color1)]
	-- 		elseif colors[tostring(vehicles[i].vehicle.color2)] then
	-- 			vehicles[i].color = colors[tostring(vehicles[i].vehicle.color2)]
	-- 		else
	-- 			vehicles[i].color = "Unknown"
	-- 		end
	-- 	end
	-- 	vehicles[i].vehicle = nil
	-- end
	-- offender.vehicles = vehicles

	TriggerClientEvent("npc-mdt:returnOffenderDetails", usource, offender)
end)

RegisterServerEvent("npc-mdt:saveOffenderChanges")
AddEventHandler("npc-mdt:saveOffenderChanges", function(id, changes, identifier)
	local usource = source
	exports.ghmattimysql:execute('SELECT * FROM `user_mdt` WHERE `char_id` = @id', {
		['@id']  = id
	}, function(result)
		if result[1] then
			exports.ghmattimysql:execute('UPDATE `user_mdt` SET `notes` = @notes, `mugshot_url` = @mugshot_url, `bail` = @bail WHERE `char_id` = @id', {
				['@id'] = id,
				['@notes'] = changes.notes,
				['@mugshot_url'] = changes.mugshot_url,
				['@bail'] = changes.bail
			})
		else
			exports.ghmattimysql:execute('INSERT INTO `user_mdt` (`char_id`, `notes`, `mugshot_url`, `bail`) VALUES (@id, @notes, @mugshot_url, @bail)', {
				['@id'] = id,
				['@notes'] = changes.notes,
				['@mugshot_url'] = changes.mugshot_url,
				['@bail'] = changes.bail
			})
		end

		if changes.convictions ~= nil then
			for conviction, amount in pairs(changes.convictions) do	
				exports.ghmattimysql:execute('UPDATE `user_convictions` SET `count` = @count WHERE `char_id` = @id AND `offense` = @offense', {
					['@id'] = id,
					['@count'] = amount,
					['@offense'] = conviction
				})
			end
		end

		for i = 1, #changes.convictions_removed do
			exports.ghmattimysql:execute('DELETE FROM `user_convictions` WHERE `char_id` = @id AND `offense` = @offense', {
				['@id'] = id,
				['offense'] = changes.convictions_removed[i]
			})
		end

		TriggerClientEvent("npc-mdt:sendNotification", usource, "Offender changes have been saved.")
	end)
end)

RegisterServerEvent("npc-mdt:saveReportChanges")
AddEventHandler("npc-mdt:saveReportChanges", function(data)
	exports.ghmattimysql:execute('UPDATE `mdt_reports` SET `title` = @title, `incident` = @incident WHERE `id` = @id', {
		['@id'] = data.id,
		['@title'] = data.title,
		['@incident'] = data.incident
	})
	TriggerClientEvent("npc-mdt:sendNotification", source, "Report changes have been saved.")
end)

RegisterServerEvent("npc-mdt:deleteReport")
AddEventHandler("npc-mdt:deleteReport", function(id)
	exports.ghmattimysql:execute('DELETE FROM `mdt_reports` WHERE `id` = @id', {
		['@id']  = id
	})
	TriggerClientEvent("npc-mdt:sendNotification", source, "Report has been successfully deleted.")
end)

RegisterServerEvent("npc-mdt:submitNewReport")
AddEventHandler("npc-mdt:submitNewReport", function(data)
	local usource = source
	local author = GetCharacterName(source)
	if tonumber(data.sentence) and tonumber(data.sentence) > 0 then
		data.sentence = tonumber(data.sentence)
	else 
		data.sentence = nil
	end
	charges = json.encode(data.charges)
	data.date = os.date('%m-%d-%Y %H:%M:%S', os.time())
	exports.ghmattimysql:execute('INSERT INTO `mdt_reports` (`char_id`, `title`, `incident`, `charges`, `author`, `name`, `date`, `jailtime`) VALUES (@id, @title, @incident, @charges, @author, @name, @date, @sentence)', {
		['@id']  = data.char_id,
		['@title'] = data.title,
		['@incident'] = data.incident,
		['@charges'] = charges,
		['@author'] = author,
		['@name'] = data.name,
		['@date'] = data.date,
		['@sentence'] = data.sentence
	}, function(id)
		TriggerEvent("npc-mdt:getReportDetailsById", id, usource)
		TriggerClientEvent("npc-mdt:sendNotification", usource, "A new report has been submitted.")
	end)

	for offense, count in pairs(data.charges) do
		exports.ghmattimysql:execute('SELECT * FROM `user_convictions` WHERE `offense` = @offense AND `char_id` = @id', {
			['@offense'] = offense,
			['@id'] = data.char_id
		}, function(result)
			if result[1] then
				exports.ghmattimysql:execute('UPDATE `user_convictions` SET `count` = @count WHERE `offense` = @offense AND `char_id` = @id', {
					['@id']  = data.char_id,
					['@offense'] = offense,
					['@count'] = count + 1
				})
			else
				exports.ghmattimysql:execute('INSERT INTO `user_convictions` (`char_id`, `offense`, `count`) VALUES (@id, @offense, @count)', {
					['@id']  = data.char_id,
					['@offense'] = offense,
					['@count'] = count
				})
			end
		end)
	end
end)

RegisterServerEvent("npc-mdt:performReportSearch")
AddEventHandler("npc-mdt:performReportSearch", function(query)
	local usource = source
	local matches = {}
	exports.ghmattimysql:execute("SELECT * FROM `mdt_reports` WHERE `id` LIKE @query OR LOWER(`title`) LIKE @query OR LOWER(`name`) LIKE @query OR LOWER(`author`) LIKE @query or LOWER(`charges`) LIKE @query", {
		['@query'] = string.lower('%'..query..'%') -- % wildcard, needed to search for all alike results
	}, function(result)

		for index, data in ipairs(result) do
			data.charges = json.decode(data.charges)
			table.insert(matches, data)
		end

		TriggerClientEvent("npc-mdt:returnReportSearchResults", usource, matches)
	end)
end)

-- RegisterServerEvent("npc-mdt:performVehicleSearch")
-- AddEventHandler("npc-mdt:performVehicleSearch", function(query)
-- 	local usource = source
-- 	local matches = {}
-- 	exports.ghmattimysql:execute("SELECT * FROM `characters_cars` WHERE LOWER(`license_plate`) LIKE @query", {
-- 		['@query'] = string.lower('%'..query..'%') -- % wildcard, needed to search for all alike results
-- 	}, function(result)

-- 		for index, data in ipairs(result) do
-- 			local data_decoded = json.decode(data.vehicle)
-- 			data.model = data_decoded.model
-- 			if data_decoded.color1 then
-- 				data.color = colors[tostring(data_decoded.color1)]
-- 				if colors[tostring(data_decoded.color2)] then
-- 					data.color = colors[tostring(data_decoded.color2)] .. " on " .. colors[tostring(data_decoded.color1)]
-- 				end
-- 			end
-- 			table.insert(matches, data)
-- 		end

-- 		TriggerClientEvent("npc-mdt:returnVehicleSearchResults", usource, matches)
-- 	end)
-- end)

-- RegisterServerEvent("npc-mdt:performVehicleSearchInFront")
-- AddEventHandler("npc-mdt:performVehicleSearchInFront", function(query)
-- 	local usource = source
-- 	local user = exports["npc-base"]:getModule("Player"):GetUser(usource)
--     local characterId = user:getVar("character").id
-- 	exports.ghmattimysql:execute("SELECT * FROM character_passes WHERE cid = @cid", {['cid'] = characterId}, function(result)
-- 		if result[1].pass_type == 'police' or result[1].pass_type == 'DOJ' then
-- 			exports.ghmattimysql:execute("SELECT * FROM (SELECT * FROM `mdt_reports` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(reports)
-- 				for r = 1, #reports do
-- 					reports[r].charges = json.decode(reports[r].charges)
-- 				end
-- 				exports.ghmattimysql:execute("SELECT * FROM (SELECT * FROM `mdt_warrants` ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(warrants)
-- 					for w = 1, #warrants do
-- 						warrants[w].charges = json.decode(warrants[w].charges)
-- 					end
-- 					exports.ghmattimysql:execute("SELECT * FROM `characters_cars` WHERE `license_plate` = @query", {
-- 						['@query'] = query
-- 					}, function(result)
-- 						local officer = GetCharacterName(usource)
-- 						TriggerClientEvent('npc-mdt:toggleVisibilty', usource, reports, warrants, officer, "Police")
-- 						TriggerClientEvent("npc-mdt:returnVehicleSearchInFront", usource, result, query)
-- 					end)
-- 				end)
-- 			end)
-- 		end
-- 	end)
-- end)

-- RegisterServerEvent("npc-mdt:getVehicle")
-- AddEventHandler("npc-mdt:getVehicle", function(vehicle)
-- 	local usource = source
-- 	local result = exports.ghmattimysql:executeSync("SELECT * FROM `characters` WHERE `id` = @query", {
-- 		['@query'] = vehicle.cid
-- 	})
-- 	if result[1] then
-- 		vehicle.cid = result[1].first_name .. ' ' .. result[1].last_name
-- 		vehicle.owner_id = result[1].id
-- 	end

-- 	local data = exports.ghmattimysql:executeSync('SELECT * FROM `vehicle_mdt` WHERE `plate` = @plate', {
-- 		['@plate'] = vehicle.plate
-- 	})
-- 	if data[1] then
-- 		if data[1].stolen == 1 then vehicle.stolen = true else vehicle.stolen = false end
-- 		if data[1].notes ~= null then vehicle.notes = data[1].notes else vehicle.notes = '' end
-- 	else
-- 		vehicle.stolen = false
-- 		vehicle.notes = ''
-- 	end

-- 	local warrants = exports.ghmattimysql:executeSync('SELECT * FROM `mdt_warrants` WHERE `char_id` = @id', {
-- 		['@id'] = vehicle.owner_id
-- 	})
-- 	if warrants[1] then
-- 		vehicle.haswarrant = true
-- 	end

-- 	local bail = exports.ghmattimysql:executeSync('SELECT `bail` FROM user_mdt WHERE `char_id` = @id', {
-- 		['@id'] = vehicle.owner_id
-- 	})
-- 	if bail and bail[1] and bail[1].bail == 1 then vehicle.bail = true else vehicle.bail = false end

-- 	vehicle.type = types[vehicle.type]
-- 	TriggerClientEvent("npc-mdt:returnVehicleDetails", usource, vehicle)
-- end)

RegisterServerEvent("npc-mdt:getWarrants")
AddEventHandler("npc-mdt:getWarrants", function()
	local usource = source
	exports.ghmattimysql:execute("SELECT * FROM `mdt_warrants`", {}, function(warrants)
		for i = 1, #warrants do
			warrants[i].expire_time = ""
			warrants[i].charges = json.decode(warrants[i].charges)
		end
		TriggerClientEvent("npc-mdt:returnWarrants", usource, warrants)
	end)
end)

RegisterServerEvent("npc-mdt:submitNewWarrant")
AddEventHandler("npc-mdt:submitNewWarrant", function(data)
	local usource = source
	data.charges = json.encode(data.charges)
	data.author = GetCharacterName(source)
	data.date = os.date('%m-%d-%Y %H:%M:%S', os.time())
	exports.ghmattimysql:execute('INSERT INTO `mdt_warrants` (`name`, `char_id`, `report_id`, `report_title`, `charges`, `date`, `expire`, `notes`, `author`) VALUES (@name, @char_id, @report_id, @report_title, @charges, @date, @expire, @notes, @author)', {
		['@name']  = data.name,
		['@char_id'] = data.char_id,
		['@report_id'] = data.report_id,
		['@report_title'] = data.report_title,
		['@charges'] = data.charges,
		['@date'] = data.date,
		['@expire'] = data.expire,
		['@notes'] = data.notes,
		['@author'] = data.author
	}, function()
		TriggerClientEvent("npc-mdt:completedWarrantAction", usource)
		TriggerClientEvent("npc-mdt:sendNotification", usource, "A new warrant has been created.")
	end)
end)

RegisterServerEvent("npc-mdt:deleteWarrant")
AddEventHandler("npc-mdt:deleteWarrant", function(id)
	local usource = source
	exports.ghmattimysql:execute('DELETE FROM `mdt_warrants` WHERE `id` = @id', {
		['@id']  = id
	}, function()
		TriggerClientEvent("npc-mdt:completedWarrantAction", usource)
	end)
	TriggerClientEvent("npc-mdt:sendNotification", usource, "Warrant has been successfully deleted.")
end)

RegisterServerEvent("npc-mdt:getReportDetailsById")
AddEventHandler("npc-mdt:getReportDetailsById", function(query, _source)
	if _source then source = _source end
	local usource = source
	exports.ghmattimysql:execute("SELECT * FROM `mdt_reports` WHERE `id` = @query", {
		['@query'] = query
	}, function(result)
		if result and result[1] then
			result[1].charges = json.decode(result[1].charges)
			TriggerClientEvent("npc-mdt:returnReportDetails", usource, result[1])
		else
			TriggerClientEvent("npc-mdt:closeModal", usource)
			TriggerClientEvent("npc-mdt:sendNotification", usource, "This report cannot be found.")
		end
	end)
end)

-- RegisterServerEvent("npc-mdt:saveVehicleChanges")
-- AddEventHandler("npc-mdt:saveVehicleChanges", function(data)
-- 	if data.stolen then data.stolen = 1 else data.stolen = 0 end
-- 	local usource = source
-- 	exports.ghmattimysql:execute('SELECT * FROM `vehicle_mdt` WHERE `plate` = @plate', {
-- 		['@plate'] = plate
-- 	}, function(result)
-- 		if result[1] then
-- 			exports.ghmattimysql:execute('UPDATE `vehicle_mdt` SET `stolen` = @stolen, `notes` = @notes WHERE `plate` = @plate', {
-- 				['@plate'] = data.plate,
-- 				['@stolen'] = data.stolen,
-- 				['@notes'] = data.notes
-- 			})
-- 		else
-- 			exports.ghmattimysql:execute('INSERT INTO `vehicle_mdt` (`plate`, `stolen`, `notes`) VALUES (@plate, @stolen, @notes)', {
-- 				['@plate'] = data.plate,
-- 				['@stolen'] = data.stolen,
-- 				['@notes'] = data.notes
-- 			})
-- 		end
		
-- 		TriggerClientEvent("npc-mdt:sendNotification", usource, "Vehicle changes have been saved.")
-- 	end)
-- end)

function GetCharacterName(source)
	local user = exports["npc-base"]:getModule("Player"):GetUser(source)
	if user ~= false then
		local characterId = user:getVar("character").id
		local result = exports.ghmattimysql:executeSync('SELECT first_name, last_name FROM characters WHERE id = @id', {
			['@id'] = characterId
		})

		if result[1] and result[1].first_name and result[1].last_name then
			return ('%s %s'):format(result[1].first_name, result[1].last_name)
		end
	end
end

function tprint (tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "{\r\n"
  indent = indent + 2 
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint  .. k ..  "= "   
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. ",\r\n"
    elseif (type(v) == "string") then
      toprint = toprint .. "\"" .. v .. "\",\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent-2) .. "}"
  return toprint
end
