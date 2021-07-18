-- Error Log Script
RegisterServerEvent('error')
AddEventHandler('error',function(resource, args)

    sendToDiscord("```Error in "..resource..'```', args)
end)

function sendToDiscord(name, args, color)
    local connect = {
          {
              ["color"] = 16711680,
              ["title"] = "".. name .."",
              ["description"] = args,
              ["footer"] = {
              ["text"] = "NPCore Framework",
              },
          }
      }
    PerformHttpRequest('https://discord.com/api/webhooks/862517383879852074/mWVNf4C5F9QXaCizy13XMKRkZUMgtbUZljE2BPERDrKwMLZOvjfrlBtqsv3pSzc9pPsp', function(err, text, headers) end, 'POST', json.encode({username = "[NPCore] Error Log:", embeds = connect, avatar_url = "https://cdn.discordapp.com/attachments/860133990580486154/862517744972988466/NPCore_Orb.png"}), { ['Content-Type'] = 'application/json' })
end
-- It must be saving into a file with io.open("test.lua", "r").