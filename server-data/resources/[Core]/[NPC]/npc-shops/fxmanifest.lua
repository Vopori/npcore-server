fx_version 'bodacious'
games {'gta5'}

description 'NPC-Shops'
version '1.0.0'

client_script{
	'client/client.lua',
	'gui.lua',
	"@npc-scripts/client/errorlog.lua"
}

server_script 'server/server.lua'
