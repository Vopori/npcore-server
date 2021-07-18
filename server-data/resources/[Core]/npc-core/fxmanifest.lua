fx_version 'cerulean'
games { 'gta5' }

description 'NPC-Framework-Core'
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
