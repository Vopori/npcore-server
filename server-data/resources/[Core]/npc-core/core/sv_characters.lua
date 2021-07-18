function NPC.Core.LoginPlayer(self, args, src, callback)
    TriggerEvent("npc-core:playerAttemptLogin", src)

    local user = NPC.Player:CreatePlayer(src, false)

    if not user then
        user = NPC.Player:CreatePlayer(src, false)

        if not user then DropPlayer(src, "There was an error while creating your player object, if this persists, contact an administrator.") return end
    end

    local function fetchData(_err)
        if _err and type(_err) == "string" then
            local errmsg = _err

            _err = {
                err = true,
                msg = errmsg
            }
            
            callback(_err)
            return
        end

        NPC.DB:FetchPlayerData(src, function(data, err)
            if err then
                data = {
                    err = true,
                    msg = "Error fetching player data, there is a problem with the database."
                }
            end

            user:setRank(data.rank)

            callback(data)

            if not err then TriggerEvent("npc-core:playerLoggedIn", user) TriggerClientEvent("npc-core:playerLoggedIn", src) end
        end)
    end


	NPC.DB:PlayerExistsDB(src, function(exists, err)
		if err then
			fetchData("Error checking player existence, there is a problem with the database.")
			return
		end

		if not exists then
			NPC.DB:CreateNewPlayer(src, function(created)
				if not created then
					fetchData("Error creating new user, there is a problem with the database.")
					return
				end

				if created then fetchData() return end
			end)

			return
		end

		fetchData()
	end)
end
NPC.Events:AddEvent(NPC.Core, NPC.Core.LoginPlayer, "npc-core:loginPlayer")

function NPC.Core.FetchPlayerCharacters(self, args, src, callback)
	local user = NPC.Player:GetUser(src)

	if not user then return end

	NPC.DB:FetchCharacterData(user, function(data, err)
		if err then
			data = {
				err = true,
				msg = "Error fetching player character data, there is a problem with the database."
			}
		else
			user:setCharacters(data)
			user:setVar("charactersLoaded", true)
			TriggerEvent("npc-core:charactersLoaded", user, data)
			TriggerClientEvent("npc-core:charactersLoaded", src, data)
		end

		callback(data)
	end)
end
NPC.Events:AddEvent(NPC.Core, NPC.Core.FetchPlayerCharacters, "npc-core:fetchPlayerCharacters")

function NPC.Core.CreatePhoneNumber(self, src, callback)
	Citizen.CreateThread(function()
		while true do 
			Citizen.Wait(1000)
			math.randomseed(GetGameTimer())

			local areaCode = math.random(50) > 25 and 415 or 628
			local phonenumber = {}
			phoneNumber = math.random(0000000000, 9999999999)
			local querying = true
			local success = false
		

			if phoneNumber then 
				phoneNumber = tostring(phoneNumber)
				if phoneNumber then
					NPC.DB:PhoneNumberExists(src, phoneNumber, function(exists, err)
						if err then callback(false, true) success = true querying = false return end
						if not exists then callback(phoneNumber) success = true end
						querying = false
					end)
				end
			end

			while querying do Citizen.Wait(0) end

			if success then return end
		end 
	end)
end

function NPC.Core.CreateCharacter(self, charData, src, callback)
	local user = NPC.Player:GetUser(src)

	if not user or not user:getVar("charactersLoaded") then return end
	if user:getNumCharacters() >= 8 then return end

	local fn = charData.firstname
	local ln = charData.lastname


	exports.ghmattimysql:execute("SELECT first_name FROM characters WHERE first_name = @fn AND last_name = @ln", 
	{
	["fn"] = fn, 
	["ln"] = ln
	}, function(result)
		if result[1] ~= nil then 
			created = {
				err = true,
				msg = "This name is already in use, pick another."
			}
			callback(created)
			return
		else
			self:CreatePhoneNumber(src, function(phoneNumber, err)
				if err then
					created = {
						err = true,
						msg = "There was an error when trying to create a phone number."
					}

					callback(created)
					return
				end
				local hexId = user:getVar("hexid")
				charData.phonenumber = phoneNumber
				NPC.DB:CreateNewCharacter(user, charData, hexId, phoneNumber, function(created, err)
					if not created or err then
						created = {
							err = true,
							msg = "There was a problem creating your character, contact an administrator if this persists."
						}
					end

					callback(created)
				end)
			end)
		end
	end)
end
NPC.Events:AddEvent(NPC.Core, NPC.Core.CreateCharacter, "npc-core:createCharacter")

function NPC.Core.DeleteCharacter(self, id, src, callback)
	local user = NPC.Player:GetUser(src)

	if not user or not user:getVar("charactersLoaded") then return end

	local ownsCharacter = false
	for k,v in pairs(user:getCharacters()) do
		if v.id == id then ownsCharacter = true break end
	end

	if not ownsCharacter then return end

	NPC.DB:DeleteCharacter(user, id, function(deleted)
		callback(deleted)
	end)
end
NPC.Events:AddEvent(NPC.Core, NPC.Core.DeleteCharacter, "npc-core:deleteCharacter")

function NPC.Core.SelectCharacter(self, id, src, callback)
	local user = NPC.Player:GetUser(src)
	if not user then callback(false) return end
	if not user:getCharacters() or user:getNumCharacters() <= 0 then callback(false) return end

	if not user:ownsCharacter(id) then callback(false) return end

	local selectedCharacter = user:getCharacter(id)
	selectedCharacter.phone_number = selectedCharacter.phone_number
	user:setCharacter(selectedCharacter)
	user:setVar("characterLoaded", true)
	local cid = selectedCharacter.id
	TriggerClientEvent('updatecid', src, cid)
	TriggerClientEvent('updatecids', src, cid)
	TriggerClientEvent('updateNameClient', src, tostring(selectedCharacter.first_name), tostring(selectedCharacter.last_name))
	TriggerClientEvent('banking:updateBalance', src, selectedCharacter.bank, true)
	TriggerClientEvent('banking:updateCash', src, selectedCharacter.cash, true)
	TriggerClientEvent('npc-core:setcontrols', src)
	TriggerClientEvent('updatepasses', src)
	TriggerEvent("npc-core:characterLoaded", user, selectedCharacter)
	TriggerClientEvent("npc-core:characterLoaded", src, selectedCharacter)

	callback({loggedin = true, chardata = selectedCharacter})
end
NPC.Events:AddEvent(NPC.Core, NPC.Core.SelectCharacter, "npc-core:selectCharacter")



