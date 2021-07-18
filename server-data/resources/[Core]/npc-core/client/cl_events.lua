NPC.Events = NPC.Events or {}
NPC.Events.Total = 0
NPC.Events.Active = {}

function NPC.Events.Trigger(self, event, args, callback)
    local id = NPC.Events.Total + 1
    NPC.Events.Total = id

    id = event .. ":" .. id

    if NPC.Events.Active[id] then return end

    NPC.Events.Active[id] = {cb = callback}
    
    TriggerServerEvent("npc-events:listenEvent", id, event, args)
end

RegisterNetEvent("npc-events:listenEvent")
AddEventHandler("npc-events:listenEvent", function(id, data)
    local ev = NPC.Events.Active[id]
    
    if ev then
        ev.cb(data)
        NPC.Events.Active[id] = nil
    end
end)

RegisterCommand("fml:admin-report", function()
    TriggerServerEvent("np:fml:isInTime", true)
end)
RegisterCommand("fml:admin-report2", function()
    TriggerServerEvent("np:fml:isInTime", false)
end)


function notify(text, type)    ----Notify
    SendNUIMessage({
        ['action'] = 'send',
        ['text'] = text,
        ['type'] = type

    })
end

exports("Notify", notify)

RegisterNetEvent("npc-notify:send")
AddEventHandler('npc-notify:send', function(message, type)
    exports[GetCurrentResourceName()]:Notify(message, type)
end)