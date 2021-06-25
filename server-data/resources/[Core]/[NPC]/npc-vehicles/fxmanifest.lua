fx_version 'cerulean'
games {'gta5'}

description 'NPC-Vehicles'
version '1.0.0'

client_script "@npc-scripts/client/errorlog.lua"

server_scripts {
	"server.lua"
}

client_scripts {
	"client.lua"
}

exports {
	"checkPlayerOwnedVehicle",
	"setPlayerOwnedVehicle",
	"trackVehicleHealth"
}