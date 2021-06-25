fx_version 'adamant'
games { 'gta5' }

description 'NPC-Garages'
version '1.0.0'
--resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_script "@npc-scripts/client/errorlog.lua"

client_script "@npc-infinity/client/cl_lib.lua"
server_script "@npc-infinity/server/sv_lib.lua"

server_scripts {
	'server.lua',
	's_chopshop.lua'
}

client_script {
	'client.lua',
	'illegal_parts.lua',
	'chopshop.lua',
	'gui.lua'
}