fx_version 'adamant'
games {'gta5'}

description 'NPC-Thermite'
version '1.0.0'

client_script "@npc-scripts/client/errorlog.lua"

client_script 'thermite_client.lua'
server_script 'thermite_server.lua'

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/pricedown.ttf',
	'html/button.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js',
	'html/backgroundwhite.png',
	'html/sounds/failure.ogg',
	'html/sounds/hit.ogg',
	'html/sounds/success.ogg',
	'html/sounds/Thermite.ogg'
}

exports{
	'startFireAtLocation',
	'startGame'
}