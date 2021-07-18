fx_version 'cerulean'
game {'gta5'}

description 'FiveM Weather System'
version '1.0.0'

client_script "@npc-scripts/client/errorlog.lua"

export "SetEnableSync"

server_scripts {
	"server/server.lua"
}

client_scripts {
	"client/client.lua"
}