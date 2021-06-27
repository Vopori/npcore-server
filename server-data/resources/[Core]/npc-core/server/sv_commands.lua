NPC.Commands = NPC.Commands or {}
NPC.Commands.Registered = NPC.Commands.Registered or {}

AddEventHandler("npc-core:exportsReady", function()
    addModule("Commands", NPC.Commands)
end)
