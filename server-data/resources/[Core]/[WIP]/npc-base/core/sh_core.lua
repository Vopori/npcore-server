NPC.Core = NPC.Core or {}

function NPC.Core.ConsoleLog(self, msg, mod)
    if not tostring(msg) then return end
    if not tostring(mod) then mod = "No Module" end
    
    local pMsg = string.format("[NPC LOG - %s] %s", mod, msg)
    if not pMsg then return end

end

RegisterNetEvent("npc-base:consoleLog")
AddEventHandler("npc-base:consoleLog", function(msg, mod)
    NPC.Core:ConsoleLog(msg, mod)
end)

function getModule(module)
    if not NPC[module] then print("Warning: '" .. tostring(module) .. "' module doesn't exist.") return false end
    return NPC[module]
end

function addModule(module, tbl)
    if NPC[module] then print("Warning: '" .. tostring(module) .. "' module is being overridden.") end
    NPC[module] = tbl
end

NPC.Core.ExportsReady = false

function NPC.Core.WaitForExports(self)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if exports and exports["npc-base"] then
                TriggerEvent("npc-base:exportsReady")
                NPC.Core.ExportsReady = true
                return
            end
        end
    end)
end

exports("getModule", getModule)
exports("addModule", addModule)
NPC.Core:WaitForExports()

local webhook = 'https://discord.com/api/webhooks/856840221747052565/D-JvTpi2B1TV3pmTLrrevwNkrg2TzoBO3pp2SzOd0FKVzuohVDqmmvEH8OZEbpLVLEWg' -- Your Discord webhook for logs
local webhook2 = 'https://discord.com/api/webhooks/856840221747052565/D-JvTpi2B1TV3pmTLrrevwNkrg2TzoBO3pp2SzOd0FKVzuohVDqmmvEH8OZEbpLVLEWg' -- Your Discord webhook for logs
local webhook3 = 'https://discord.com/api/webhooks/856840221747052565/D-JvTpi2B1TV3pmTLrrevwNkrg2TzoBO3pp2SzOd0FKVzuohVDqmmvEH8OZEbpLVLEWg' -- Your Discord webhook for logs
local webhook4 = 'https://discord.com/api/webhooks/856840221747052565/D-JvTpi2B1TV3pmTLrrevwNkrg2TzoBO3pp2SzOd0FKVzuohVDqmmvEH8OZEbpLVLEWg' -- Your Discord webhook for logs
local webhook5 = 'https://discord.com/api/webhooks/856840221747052565/D-JvTpi2B1TV3pmTLrrevwNkrg2TzoBO3pp2SzOd0FKVzuohVDqmmvEH8OZEbpLVLEWg' -- Your Discord webhook for logs
local webhook6 = 'https://discord.com/api/webhooks/856840221747052565/D-JvTpi2B1TV3pmTLrrevwNkrg2TzoBO3pp2SzOd0FKVzuohVDqmmvEH8OZEbpLVLEWg' -- MDT - Reports Deleted
local webhook7 = 'https://discord.com/api/webhooks/856840221747052565/D-JvTpi2B1TV3pmTLrrevwNkrg2TzoBO3pp2SzOd0FKVzuohVDqmmvEH8OZEbpLVLEWg' -- MDT - Warrant Deleted
local webhook8 = 'https://discord.com/api/webhooks/856840221747052565/D-JvTpi2B1TV3pmTLrrevwNkrg2TzoBO3pp2SzOd0FKVzuohVDqmmvEH8OZEbpLVLEWg' -- Teleporters - Meth Enter / Leave
local webhook9 = 'https://discord.com/api/webhooks/856840221747052565/D-JvTpi2B1TV3pmTLrrevwNkrg2TzoBO3pp2SzOd0FKVzuohVDqmmvEH8OZEbpLVLEWg' -- Teleporters - Coke Enter / Leave
local webhook10 = 'https://discord.com/api/webhooks/856840221747052565/D-JvTpi2B1TV3pmTLrrevwNkrg2TzoBO3pp2SzOd0FKVzuohVDqmmvEH8OZEbpLVLEWg' -- Teleporters - Recycle Enter / Leave


RegisterNetEvent('convienceregister:log')
AddEventHandler('convienceregister:log', function()
    local src = source
    local user = exports["npc-base"]:getModule("Player"):GetUser(src)
    local hexId = user:getVar("hexid")
    local pName = GetPlayerName(source)
    local pDiscord = GetPlayerIdentifiers(src)[3]
    local LogData = {
        {
            ['description'] = string.format("`%s`\n\n`• Server ID: %s`\n\n━━━━━━━━━━━━━━━━━━\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━", "started to empty a Convience Store Register!", src, hexId, pDiscord),
            ['color'] = 2317994,
            ['author'] = {
                ['name'] = "Steam Name: "..pName
            },
        }
    }

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = LogData}), { ['Content-Type'] = 'application/json' })	
end)

RegisterNetEvent('conviencesafe:log')
AddEventHandler('conviencesafe:log', function()
    local src = source
    local user = exports["npc-base"]:getModule("Player"):GetUser(src)
    local hexId = user:getVar("hexid")
    local pName = GetPlayerName(source)
    local pDiscord = GetPlayerIdentifiers(src)[3]
    local LogData = {
        {
            ['description'] = string.format("`%s`\n\n`• Server ID: %s`\n\n━━━━━━━━━━━━━━━━━━\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━", "started to empty a Convience Store Safe!", src, hexId, pDiscord),
            ['color'] = 2317994,
            ['author'] = {
                ['name'] = "Steam Name: "..pName
            },
        }
    }

      PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = LogData}), { ['Content-Type'] = 'application/json' })	

end)

RegisterNetEvent('stealcommand:log')
AddEventHandler('stealcommand:log', function()
    local src = source
    local user = exports["npc-base"]:getModule("Player"):GetUser(src)
    local hexId = user:getVar("hexid")
    local pName = GetPlayerName(source)
    local pDiscord = GetPlayerIdentifiers(src)[3]
    local LogData = {
        {
            ['description'] = string.format("`%s`\n\n`• Server ID: %s`\n\n━━━━━━━━━━━━━━━━━━\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━", "/steal command used!", src, hexId, pDiscord),
            ['color'] = 2317994,
            ['author'] = {
                ['name'] = "Steam Name: "..pName
            },
        }
    }

    PerformHttpRequest(webhook2, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = LogData}), { ['Content-Type'] = 'application/json' })	
end)

RegisterNetEvent('jewelrobbery:log')
AddEventHandler('jewelrobbery:log', function()
    local src = source
    local user = exports["npc-base"]:getModule("Player"):GetUser(src)
    local hexId = user:getVar("hexid")
    local pName = GetPlayerName(source)
    local pDiscord = GetPlayerIdentifiers(src)[3]
    local LogData = {
        {
            ['description'] = string.format("`%s`\n\n`• Server ID: %s`\n\n━━━━━━━━━━━━━━━━━━\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━", "Jewelry Store Robbery!", src, hexId, pDiscord),
            ['color'] = 2317994,
            ['author'] = {
                ['name'] = "Steam Name: "..pName
            },
        }
    }

    PerformHttpRequest(webhook3, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = LogData}), { ['Content-Type'] = 'application/json' })	
end)

RegisterNetEvent('banktruckrobbery:log')
AddEventHandler('banktruckrobbery:log', function()
    local src = source
    local user = exports["npc-base"]:getModule("Player"):GetUser(src)
    local hexId = user:getVar("hexid")
    local pName = GetPlayerName(source)
    local pDiscord = GetPlayerIdentifiers(src)[3]
    local LogData = {
        {
            ['description'] = string.format("`%s`\n\n`• Server ID: %s`\n\n━━━━━━━━━━━━━━━━━━\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━", "Bank Truck Robbery!", src, hexId, pDiscord),
            ['color'] = 2317994,
            ['author'] = {
                ['name'] = "Steam Name: "..pName
            },
        }
    }

  	PerformHttpRequest(webhook4, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = LogData}), { ['Content-Type'] = 'application/json' })	
end)


RegisterNetEvent('dmg:log')
AddEventHandler('dmg:log', function()
    local src = source
    local user = exports["npc-base"]:getModule("Player"):GetUser(src)
    local hexId = user:getVar("hexid")
    local pName = GetPlayerName(source)
    local pDiscord = GetPlayerIdentifiers(src)[3]
    local LogData = {
        {
            ['description'] = string.format("`%s`\n\n`• Server ID: %s`\n\n━━━━━━━━━━━━━━━━━━\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━", "Damage Exceeded!", src, hexId, pDiscord),
            ['color'] = 2317994,
            ['author'] = {
                ['name'] = "Steam Name: "..pName
            },
        }
    }
    PerformHttpRequest(webhook5, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = LogData}), { ['Content-Type'] = 'application/json' })	
end)

RegisterNetEvent('npc-mdt:delreport')
AddEventHandler('npc-mdt:delreport', function()
    local src = source
    local user = exports["npc-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local hexId = user:getVar("hexid")
    local pCharName = char.first_name .. " " ..char.last_name
    local pName = GetPlayerName(source)
    local pDiscord = GetPlayerIdentifiers(src)[3]
    local LogData = {
        {
            ['description'] = string.format("`%s`\n\n`• Server ID: %s`\n\n━━━━━━━━━━━━━━━━━━\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━", "MDT - Report Deleted!", src, hexId, pDiscord),
            ['color'] = 2317994,
            ['fields'] = {
                {
                    ['name'] = '`Character Name`',
                    ['value'] = pCharName,
                    ['inline'] = true
                },
                {
                    ['name'] = '`Reason For Log`',
                    ['value'] = "Deleted an MDT Report",
                    ['inline'] = true
                }
            },
            ['author'] = {
                ['name'] = "Steam Name: "..pName
            },
        }
    }

  	PerformHttpRequest(webhook6, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = LogData}), { ['Content-Type'] = 'application/json' })	
end)

RegisterNetEvent('npc-mdt:delwarrant')
AddEventHandler('npc-mdt:delwarrant', function()
    local src = source
    local user = exports["npc-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local hexId = user:getVar("hexid")
    local pCharName = char.first_name .. " " ..char.last_name
    local pName = GetPlayerName(source)
    local pDiscord = GetPlayerIdentifiers(src)[3]
    local LogData = {
        {
            ['description'] = string.format("`%s`\n\n`• Server ID: %s`\n\n━━━━━━━━━━━━━━━━━━\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━", "MDT - Warrent Deleted!", src, hexId, pDiscord),
            ['color'] = 2317994,
            ['fields'] = {
                {
                    ['name'] = '`Character Name`',
                    ['value'] = pCharName,
                    ['inline'] = true
                },
                {
                    ['name'] = '`Reason For Log`',
                    ['value'] = "Deleted an MDT Warrent",
                    ['inline'] = true
                }
            },
            ['author'] = {
                ['name'] = "Steam Name: "..pName
            },
        }
    }

  	PerformHttpRequest(webhook7, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = LogData}), { ['Content-Type'] = 'application/json' })	
end)

RegisterNetEvent('meth:enter')
AddEventHandler('meth:enter', function()
    local src = source
    local user = exports["npc-base"]:getModule("Player"):GetUser(src)
    local hexId = user:getVar("hexid")
    local pName = GetPlayerName(source)
    local pDiscord = GetPlayerIdentifiers(src)[3]
    local LogData = {
        {
            ['description'] = string.format("`%s`\n\n`• Server ID: %s`\n\n━━━━━━━━━━━━━━━━━━\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━", "Entered the Meth Lab!", src, hexId, pDiscord),
            ['color'] = 2317994,
            ['author'] = {
                ['name'] = "Steam Name: "..pName
            },
        }
    }

    PerformHttpRequest(webhook8, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = LogData}), { ['Content-Type'] = 'application/json' })	
end)

RegisterNetEvent('meth:leave')
AddEventHandler('meth:leave', function()
    local src = source
    local user = exports["npc-base"]:getModule("Player"):GetUser(src)
    local hexId = user:getVar("hexid")
    local pName = GetPlayerName(source)
    local pDiscord = GetPlayerIdentifiers(src)[3]
    local LogData = {
        {
            ['description'] = string.format("`%s`\n\n`• Server ID: %s`\n\n━━━━━━━━━━━━━━━━━━\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━", "Left the Meth Lab!", src, hexId, pDiscord),
            ['color'] = 2317994,
            ['author'] = {
                ['name'] = "Steam Name: "..pName
            },
        }
    }

    PerformHttpRequest(webhook8, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = LogData}), { ['Content-Type'] = 'application/json' })	
end)

RegisterNetEvent('coke:enter')
AddEventHandler('coke:enter', function()
    local src = source
    local user = exports["npc-base"]:getModule("Player"):GetUser(src)
    local hexId = user:getVar("hexid")
    local pName = GetPlayerName(source)
    local pDiscord = GetPlayerIdentifiers(src)[3]
    local LogData = {
        {
            ['description'] = string.format("`%s`\n\n`• Server ID: %s`\n\n━━━━━━━━━━━━━━━━━━\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━", "Entered the Coke Lab!", src, hexId, pDiscord),
            ['color'] = 2317994,
            ['author'] = {
                ['name'] = "Steam Name: "..pName
            },
        }
    }

    PerformHttpRequest(webhook9, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = LogData}), { ['Content-Type'] = 'application/json' })	
end)

RegisterNetEvent('coke:leave')
AddEventHandler('coke:leave', function()
    local src = source
    local user = exports["npc-base"]:getModule("Player"):GetUser(src)
    local hexId = user:getVar("hexid")
    local pName = GetPlayerName(source)
    local pDiscord = GetPlayerIdentifiers(src)[3]
    local LogData = {
        {
            ['description'] = string.format("`%s`\n\n`• Server ID: %s`\n\n━━━━━━━━━━━━━━━━━━\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━", "Left the Coke Lab!", src, hexId, pDiscord),
            ['color'] = 2317994,
            ['author'] = {
                ['name'] = "Steam Name: "..pName
            },
        }
    }

    PerformHttpRequest(webhook9, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = LogData}), { ['Content-Type'] = 'application/json' })	
end)

RegisterNetEvent('recycle:enter')
AddEventHandler('recycle:enter', function()
    local src = source
    local user = exports["npc-base"]:getModule("Player"):GetUser(src)
    local hexId = user:getVar("hexid")
    local pName = GetPlayerName(source)
    local pDiscord = GetPlayerIdentifiers(src)[3]
    local LogData = {
        {
            ['description'] = string.format("`%s`\n\n`• Server ID: %s`\n\n━━━━━━━━━━━━━━━━━━\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━", "Entered the Recycle Plant!", src, hexId, pDiscord),
            ['color'] = 2317994,
            ['author'] = {
                ['name'] = "Steam Name: "..pName
            },
        }
    }

    PerformHttpRequest(webhook10, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = LogData}), { ['Content-Type'] = 'application/json' })	
end)

RegisterNetEvent('recycle:leave')
AddEventHandler('recycle:leave', function()
    local src = source
    local user = exports["npc-base"]:getModule("Player"):GetUser(src)
    local hexId = user:getVar("hexid")
    local pName = GetPlayerName(source)
    local pDiscord = GetPlayerIdentifiers(src)[3]
    local LogData = {
        {
            ['description'] = string.format("`%s`\n\n`• Server ID: %s`\n\n━━━━━━━━━━━━━━━━━━\n`• Steam: %s`\n\n`• Discord: %s`\n━━━━━━━━━━━━━━━━━━", "Left the Recycle Plant!", src, hexId, pDiscord),
            ['color'] = 2317994,
            ['author'] = {
                ['name'] = "Steam Name: "..pName
            },
        }
    }

    PerformHttpRequest(webhook11, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = LogData}), { ['Content-Type'] = 'application/json' })	
end)