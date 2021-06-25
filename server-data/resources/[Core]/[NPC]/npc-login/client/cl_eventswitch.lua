function Login.playerLoaded() end

function Login.characterLoaded()
  -- Main events leave alone 
  TriggerEvent("npc-base:playerSpawned")
  TriggerEvent("loadedinafk")
  TriggerEvent("playerSpawned")
  TriggerServerEvent('character:loadspawns')
  TriggerServerEvent("kGetWeather")

  -- Main events leave alone 
  TriggerEvent("resetinhouse")
  TriggerEvent("fx:clear")
  TriggerServerEvent('tattoos:retrieve')
  TriggerServerEvent('Blemishes:retrieve')
  TriggerServerEvent("currentconvictions")
  TriggerServerEvent("GarageData")
  TriggerEvent("banking:viewBalance")
  TriggerServerEvent('npc-doors:requestlatest')
  TriggerServerEvent("npc-weapons:getAmmo")
  Wait(3000)
  TriggerServerEvent("bones:server:requestServer")

  	-- Events
	TriggerServerEvent("police:SetMeta")
	TriggerServerEvent("server:currentpasses")
	TriggerServerEvent("commands:player:login")
	TriggerServerEvent("retreive:licenes:server")
	TriggerServerEvent("npc-inventory:RetreiveSettings")
	--Licenses for hunting / fishing
	
	TriggerServerEvent('npc-fish:retreive:license')
	TriggerServerEvent('npc-hunting:retreive:license')

  -- Gang shit
  TriggerServerEvent('npc-territories:approvedgang')
  TriggerServerEvent('npc-territories:leader')
  TriggerServerEvent('npc-territories:grove')

  -- Jail/Bank Logs
	TriggerServerEvent("retreive:jail",exports["isPed"]:isPed("cid"))	
	TriggerServerEvent("bank:getLogs")
end

function Login.characterSpawned()

  isNear = false
  TriggerServerEvent('npc-base:sv:player_control')
  TriggerServerEvent('npc-base:sv:player_settings')

  TriggerServerEvent("TokoVoip:clientHasSelecterCharacter")
  TriggerEvent("spawning", false)
  TriggerEvent("attachWeapons")
  TriggerEvent("tokovoip:onPlayerLoggedIn", true)

  TriggerServerEvent("request-dropped-items")
  TriggerServerEvent("server-request-update", exports["isPed"]:isPed("cid"))
  TriggerServerEvent("stocks:retrieveclientstocks")

  if Spawn.isNew then
    Wait(1000)
    if not exports["npc-inventory"]:hasEnoughOfItem("mobilephone", 1, false) then
        TriggerEvent("player:receiveItem", "mobilephone", 1)
    end

    -- commands to make sure player is alive and full food/water/health/no injuries
    local src = GetPlayerServerId(PlayerId())
    TriggerServerEvent("reviveGranted", src)
    TriggerEvent("Hospital:HealInjuries", src, true)
    TriggerServerEvent("ems:healplayer", src)
    TriggerEvent("heal", src)
    TriggerEvent("status:needs:restore", src)
    TriggerServerEvent("npc-login:newPlayerFullySpawned")
  end
  SetPedMaxHealth(PlayerPedId(), 200)
  SetPlayerMaxArmour(PlayerId(), 60)
  runGameplay() -- moved from npc-base 
  Spawn.isNew = false
end
RegisterNetEvent("npc-login:characterSpawned");
AddEventHandler("npc-login:characterSpawned", Login.characterSpawned);
