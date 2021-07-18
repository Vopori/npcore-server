function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

RegisterNetEvent("npc-hospital:items:gauze")
AddEventHandler("npc-hospital:items:gauze", function(item)
    loadAnimDict("missheistdockssetup1clipboard@idle_a")
    TaskPlayAnim( PlayerPedId(), "missheistdockssetup1clipboard@idle_a", "idle_a", 3.0, 1.0, -1, 49, 0, 0, 0, 0 ) 
--    exports["urp_taskbar"]:StartDelayedFunction('Packing Wounds', 1500, function()
        local finished = exports["npc-taskbar"]:taskBar(1500,"Packing Wounds")
        if finished == 100 then
        TriggerEvent('npc-hospital:client:FieldTreatBleed')
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent("npc-hospital:items:bandage")
AddEventHandler("npc-hospital:items:bandage", function(item)
    loadAnimDict("missheistdockssetup1clipboard@idle_a")
    TaskPlayAnim( PlayerPedId(), "missheistdockssetup1clipboard@idle_a", "idle_a", 3.0, 1.0, -1, 49, 0, 0, 0, 0 ) 
--    exports["urp_taskbar"]:StartDelayedFunction('Using Bandage', 5000, function()
        local finished = exports["npc-taskbar"]:taskBar(5000,"Using Bandage")
        if finished == 100 then
        local maxHealth = GetEntityMaxHealth(PlayerPedId())
		local health = GetEntityHealth(PlayerPedId())
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 16))
        SetEntityHealth(PlayerPedId(), newHealth)
        TriggerEvent('npc-hospital:client:RemoveBleed')
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent("npc-hospital:items:healplayer")
AddEventHandler("npc-hospital:items:healplayer", function(item)
--    exports["urp_taskbar"]:StartDelayedFunction('Using Bandage', 5000, function()
    local maxHealth = GetEntityMaxHealth(PlayerPedId())
	local health = GetEntityHealth(PlayerPedId())
	local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 16))
    SetEntityHealth(PlayerPedId(), newHealth)
    TriggerEvent('npc-hospital:client:RemoveBleed')
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("npc-hospital:items:firstaid")
AddEventHandler("npc-hospital:items:firstaid", function(item)
    loadAnimDict("missheistdockssetup1clipboard@idle_a")
    TaskPlayAnim( PlayerPedId(), "missheistdockssetup1clipboard@idle_a", "idle_a", 3.0, 1.0, -1, 49, 0, 0, 0, 0 ) 
--    exports["urp_taskbar"]:StartDelayedFunction('Using First Aid', 10000, function()
        local finished = exports["npc-taskbar"]:taskBar(10000,"Using First Aid")
        if finished == 100 then
        local maxHealth = GetEntityMaxHealth(PlayerPedId())
		local health = GetEntityHealth(PlayerPedId())
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
        SetEntityHealth(PlayerPedId(), newHealth)
        TriggerEvent('npc-hospital:client:RemoveBleed')
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent("npc-hospital:items:medkit")
AddEventHandler("npc-hospital:items:medkit", function(item)
    loadAnimDict("missheistdockssetup1clipboard@idle_a")
    TaskPlayAnim( PlayerPedId(), "missheistdockssetup1clipboard@idle_a", "idle_a", 3.0, 1.0, -1, 49, 0, 0, 0, 0 ) 
--    exports["urp_taskbar"]:StartDelayedFunction('Using Medkit', 20000, function()
        local finished = exports["npc-taskbar"]:taskBar(20000,"Using Medkit")
        if finished == 100 then
        SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
        TriggerEvent('npc-hospital:client:FieldTreatLimbs')
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent("npc-hospital:items:vicodin")
AddEventHandler("npc-hospital:items:vicodin", function(item)
    loadAnimDict("mp_suicide")
    TaskPlayAnim( PlayerPedId(), "mp_suicide", "pill", 3.0, 1.0, -1, 49, 0, 0, 0, 0 ) 
--    exports["urp_taskbar"]:StartDelayedFunction('Taking Oxycodone', 1000, function()

        local finished = exports["npc-taskbar"]:taskBar(10000,"Taking Oxycodone")
        if finished == 100 then


        TriggerEvent('npc-hospital:client:UsePainKiller', 1)
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent("npc-hospital:items:ifak")
AddEventHandler("npc-hospital:items:ifak", function(item)
    loadAnimDict("mp_suicide")
    TaskPlayAnim( PlayerPedId(), "amb@world_human_clipboard@male@idle_a", "idle_c", 3.0, 1.0, 10000, 49, 0, 0, 0, 0 ) 
--    exports["urp_taskbar"]:StartDelayedFunction('Using IFAK', 10000, function()

        local finished = exports["npc-taskbar"]:taskBar(10000,"Using IFAK")
        if finished == 100 then

            
        TriggerEvent('npc-hospital:client:UsePainKiller', 1)
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent("npc-hospital:items:hydrocodone")
AddEventHandler("npc-hospital:items:hydrocodone", function(item)
    loadAnimDict("mp_suicide")
    TaskPlayAnim( PlayerPedId(), "mp_suicide", "pill", 3.0, 1.0, -1, 49, 0, 0, 0, 0 ) 
--    exports["urp_taskbar"]:StartDelayedFunction('Taking Hydrocodone', 1000, function()

        local finished = exports["npc-taskbar"]:taskBar(1000,"Taking Hydrocodone")
        if finished == 100 then


        TriggerEvent('npc-hospital:client:UsePainKiller', 2)
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent("npc-hospital:items:morphine")
AddEventHandler("npc-hospital:items:morphine", function(item)
    loadAnimDict("mp_suicide")
    TaskPlayAnim( PlayerPedId(), "mp_suicide", "pill", 3.0, 1.0, -1, 49, 0, 0, 0, 0 ) 
--    exports["urp_taskbar"]:StartDelayedFunction('Taking Morphine', 2000, function()

        local finished = exports["npc-taskbar"]:taskBar(2000,"Taking Morphine")
        if finished == 100 then

        
        TriggerEvent('npc-hospital:client:UsePainKiller', 6)
        ClearPedTasks(PlayerPedId())
    end
end)