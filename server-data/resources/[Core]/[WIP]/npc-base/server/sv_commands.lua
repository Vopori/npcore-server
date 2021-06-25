NPC.Commands = NPC.Commands or {}
NPC.Commands.Registered = NPC.Commands.Registered or {}

AddEventHandler("npc-base:exportsReady", function()
    addModule("Commands", NPC.Commands)
end)
