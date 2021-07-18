fx_version 'cerulean'
games { 'gta5' }

description 'NPC-Gangs'
version '1.0.0'

client_script "@npc-scripts/client/cl_errorlog.lua"

server_scripts {
    "server_gangtasks.lua",
    "weed.lua"
}

client_scripts {
    "chostility.lua",
	"taskconfig.lua",
}   "client_gangtasks.lua"