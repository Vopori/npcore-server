fx_version 'adamant'
games { 'gta5' }

description 'NPC-Lux-Vehicle-Control'
version '1.0.0'
--resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

ui_page('html/index.html')
client_script "@npc-scripts/client/errorlog.lua"

client_script "@npc-infinity/client/cl_lib.lua"
server_script "@npc-infinity/server/sv_lib.lua"

files {
	"html/index.html",
	"html/sounds/panic.mp3",
	"html/sounds/metaldetected.mp3",
}

client_script 'client.lua'
server_script 'server.lua'