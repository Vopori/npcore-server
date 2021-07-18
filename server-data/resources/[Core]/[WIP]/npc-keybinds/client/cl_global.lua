Citizen.CreateThread(function()
    RegisterCommand('+dispach', function() end, false)
    RegisterCommand('-dispach', function() end, false)
    exports["npc-keybinds"]:registerKeyMapping("Dispach", "Police", "Recent Dispach Alerts", "+dispach", "-dispach", "y", true) 
end)

