fx_version 'bodacious'
games { 'gta5' }
description 'NPC-Doors'
version '1.0.0'
author 'whitewingz'

-- dependency "npc-base"
dependency "ghmattimysql"

shared_script "shared/sh_doors.lua"
client_script "@npc-scripts/client/errorlog.lua"
server_script "server/sv_doors.lua"
client_script "client/cl_doors.lua"

server_export 'isDoorLocked'