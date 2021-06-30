![image](https://cdn.discordapp.com/attachments/851633925624168479/856870904906252298/NPCore_V.1.0.png)
# Welcome to the NPCore-Server Wiki!
# ![](https://cdn.discordapp.com/attachments/851633925624168479/854424619049156669/NPC.png)Base Manifest
```lua
fx_version 'cerulean'
games { 'gta5' }

description 'NPC-Framework-Base'
version '1.0.0'

client_script "@npc-scripts/client/errorlog.lua"

--[[=====NPC INIT=====]]--
server_script "core/npc_init.lua"
client_script "core/npc_init.lua"

--[[=====EVENTS=====]]--
server_script "server/sv_events.lua"
client_script "client/cl_events.lua"

--[[=====CORE=====]]--
server_script "core/sh_core.lua"
server_script "core/sh_enums.lua"
-- Utility
server_script "core/sh_util.lua"
-- Database
server_script "core/sv_db.lua"
server_script "core/sv_core.lua"
server_script "core/sv_characters.lua"
client_script "core/sh_core.lua"
client_script "core/sh_enums.lua"
-- Utility
client_script "core/sh_util.lua"
client_script "core/cl_util.lua"
client_script "core/cl_core.lua"

--[[=====SPAWNMANAGER=====]]--
client_script "client/cl_spawnmanager.lua"
server_script "server/sv_spawnmanager.lua"

--[[=====PLAYER=====]]--
server_script "player/sv_player.lua"
server_script "player/sv_controls.lua"
server_script "player/sv_settings.lua"
client_script "player/cl_player.lua"
client_script "player/cl_controls.lua"
client_script "player/cl_settings.lua"

--[[=====BLIPMANAGER=====]]--
client_script "client/cl_blipmanager.lua"
client_script "client/cl_blips.lua"

--[[=====GAMEPLAY=====]]--
client_script "client/cl_gameplay.lua"

--[[=====COMMANDS=====]]--
client_script "client/cl_commands.lua"
server_script "server/sv_commands.lua"

--[[=====Logs=====]]--
server_script "server/sv_logs.lua"

export "getModule"
export "addModule"
export "FetchVehProps"
export "SetVehProps"

server_export "getModule"
server_export "addModule"
server_export "AddLog"
```
# ![](https://cdn.discordapp.com/attachments/851633925624168479/854424619049156669/NPC.png)Server.CFG
```lua
#---------------------------------------------------------#
#        Custom NoPixel Inspired Framework V.1.0     	  #
#---------------------------------------------------------#

# Enable OneSync (required for server-side state awareness)!
set onesync on
set onesync_enabled 1
set sv_enforceGameBuild 2189
set onesync_forceMigration true
set onesync_workaround763185 true
set onesync_distanceCullVehicles true

# Only change the IP if you're using a server with multiple network interfaces, otherwise change the port only. #
endpoint_add_tcp "0.0.0.0:30120"
endpoint_add_udp "0.0.0.0:30120"

# Server player slot limit (See https://fivem.net/server-hosting for limits).
sv_maxclients 48
sv_licenseKey ""

# Steam Web API key, if you want to use Steam authentication (https://steamcommunity.com/dev/apikey).
# -> Replace "" with the key.
set steam_webApiKey ""

#[Add System Admins]#
add_ace group.admin command allow # allow all commands
add_ace group.admin command.quit deny # but don't allow quit
add_principal identifier.fivem:Your_Steam_ID group.admin #Administration

# Required Config #
exec resources.cfg

# PMA Voice Convars (Onesync Infinity Only) # -- https://github.com/AvarianKnight/pma-voice
#ensure pma-voice
#setr voice_useNativeAudio 1
#setr voice_useSendingRangeOnly 1
#setr voice_zoneRadius 16
#setr voice_enableProximityCycle 1
#setr voice_enableRadios 1
#setr voice_enablePhones 1
#setr voice_enableSubmix 1
#setr voice_defaultCycle "N"
#setr voice_defaultVolume "0.5"

# Default Resources #
ensure hardcap -- Optional: Uncomment If not using ConnectQueue.
ensure mapmanager
ensure spawnmanager
ensure sessionmanager
ensure webpack
ensure rconlog
ensure chat
ensure yarn
ensure cron
ensure isPed

# Dependencies #
ensure ghmattimysql	# -- https://github.com/GHMatti/ghmattimysql
#ensure connectqueue	# -- https://github.com/Nick78111/ConnectQueue
ensure dlciplloader     # -- https://forum.cfx.re/t/cayo-perico-casino-dlc-ipl-loader/2099391
ensure bob74_ipl	# -- https://github.com/Bob74/bob74_ipl
ensure PolyZone		# -- https://github.com/mkafrin/PolyZone
#ensure wk_wars2x	# -- https://github.com/WolfKnight98/wk_wars2x

# This allows players to use scripthook-based plugins such as the legacy Lambda Menu.
# Set this to 1 to allow scripthook. Do note that this does _not_ guarantee players won't be able to use external plugins.
sv_scriptHookAllowed 0

# Uncomment this and set a password to enable RCON. Make sure to change the password - it should look like rcon_password "YOURPASSWORD"
#rcon_password ""

# A comma-separated list of tags for your server.
# For example:
# - sets tags "drifting, cars, racing"
# Or:
# - sets tags "roleplay, military, tanks"
sets tags "og, np, rp, new, npc, alpha, beta, roam, tune, gang, chill, city, chips, fivem, jobs, ems, lspd, taxi, mechanics, cars, race, races, racing, drifting, tuner, tuners, tunerchip, tunerchips, sales, drugs, admin, police, serious, hiring, quality, lifetime, roleplay, freeroam, dawn, summit, spring, summer, winter, solstace, impulse, eclipse, nopixel, notpixel, custom cars, custom peds, custom scripts, custom framework, powered by: NPCore."

# A valid locale identifier for your server's primary language.
# For example "en-US", "fr-CA", "nl-NL", "de-DE", "en-GB", "pt-BR"
sets locale "en-US" 
# please DO replace root-AQ on the line ABOVE with a real language! :)

# Set an optional server info and connecting banner image url.
# Size doesn't matter, any banner sized image will be fine.
sets Microphone "Required"
sets Roleplay "Serious Roleplay"
sets Age Limit "Rated Mature"
sets banner_detail "https://cdn.discordapp.com/attachments/832068126111432716/836571288440012821/OGN_5M_Detail_Banner.png"
sets banner_connecting "https://cdn.discordapp.com/attachments/832068126111432716/840661181723181076/5M_Connecting_Banner_copy.png"
sets Discord "https://discord.gg/ahbEjHTfRm"
sets Website "https://github.com/np-core-framework"

# Set your server's hostname
sv_hostname "^7• ^5NPCore Framework ^9| ^5https://discord.gg/ahbEjHTfRm ^7•"

# Set your server's Project Name
sets sv_projectName "[NPCore]: Mature roleplay server, backed up by a seriously dedicated team looking to take the FiveM community by storm! Join us today and make memories."

# Set your server's Project Description
sets sv_projectDesc "Created by roleplayers for roleplayers. We aim to provide the best roleplay possible, by offering a unique experience for new or experienced roleplayers alike. We hope you enjoy your time with us, and look forward to seeing you in city!"

# Loading a server icon (96x96 PNG file)
load_server_icon NPCore.png

# convars which can be used in scripts
set temp_convar "Hey world!"

# Remove the `#` from the below line if you do not want your server to be listed in the server browser.
# Do not edit it if you *do* want your server listed.
#sv_master1 ""

#---------------------------------------------------------#
#    ***[Please do not make unneccessary changes.]***	  #
#---------------------------------------------------------#
```
# ![](https://cdn.discordapp.com/attachments/851633925624168479/854424619049156669/NPC.png)Resources.CFG
```lua
#-----------------------------#
#	       NPC Start	          #
#-----------------------------#
#ensure npc-discord-whitelist
#ensure npc-discord-perms
#ensure npc-whitelist
ensure npc-mapdata
ensure npc-loading-screen
ensure npc-infinity
ensure npc-core
ensure npc-login
ensure npc-scripts
ensure npc-polyzone
ensure npc-outfits
ensure npc-apartments
ensure npc-banking
ensure npc-phone
ensure npc-radio
ensure npc-log
ensure npc-jobmanager
ensure npc-admin
ensure npc-assets
ensure npc-menu
ensure npc-commands
ensure npc-bennys
ensure npc-interior
ensure npc-drugdeliveries
ensure npc-inventory
ensure npc-burglary
ensure npc-furniture
ensure npc-actionbar
ensure npc-taskbar
ensure npc-thermite
ensure npc-doors
ensure npc-fx
ensure npc-evidence
ensure npc-notepad
ensure npc-jewelrob
ensure npc-keypad
ensure npc-lockpicking
ensure npc-cid
ensure npc-news
ensure npc-tunershop
ensure npc-tuner
ensure npc-recoil
ensure npc-fuel-stations
ensure npc-keys
ensure npc-taskbarskill
ensure npc-taskbarthreat
ensure npc-tasknotify
ensure npc-stash
ensure npc-securityheists
ensure npc-secondaryjobs
ensure npc-gangs
ensure npc-dispatch
ensure npc-robbery
ensure npc-spawnveh
ensure npc-mdt
ensure npc-mdt-civ
ensure npc-ui
ensure npc-applications
ensure npc-target
ensure npc-keybinds
ensure npc-tacoshop
ensure npc-voice
ensure npc-eblips
ensure npc-context
ensure npc-warmenu
ensure npc-emergencyjobs
ensure npc-jobsystem
ensure npc-mechanic
ensure npc-police
ensure npc-ems
ensure npc-shops
ensure npc-garages
ensure npc-vehicles
ensure npc-vehicleshop		  [#-- Work-In-Progress! --#]
ensure npc-jobs			        [#-- Work-In-Progress! --#]
ensure npc-drugs		        [#-- Work-In-Progress! --#]
ensure npc-jewelrobbery		  [#-- Work-In-Progress! --#]
#-----------------------------#
#	         NPC END	          #
#-----------------------------#

#-----------------------------#
#	        MISC START	        #
#-----------------------------#
#ensure wk_wrs2x
ensure npc-emotes
ensure npc-ovalmap
ensure npc-mhacking
ensure npc-playerhud
ensure npc-blindfold
ensure npc-vehiclecontrol
ensure npc-raid-car-menu
ensure npc-interact-sound
ensure npc-weather-seasons
ensure npc-weather-sync
restart npc-ovalmap
#-----------------------------#
#	        MISC END	          #
#-----------------------------#

#-----------------------------#
#	       ASSETS START         #
#-----------------------------#
ensure npc-maps
ensure npc-mlo-a
ensure npc-mlo-b
ensure npc-mlo-c
#ensure npc-clothes
#ensure npc-raid-cars
#ensure npc-tow-trucks
#-----------------------------#
#	        ASSETS END 	        #
#-----------------------------#
```
