fx_version 'adamant'
games {'gta5'}

description 'NPC-Tuner'
version '1.0.0'

client_script "@npc-scripts/client/errorlog.lua"

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/pricedown.ttf',
	'html/cursor.png',
	'html/background.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js'
}

client_script 'client.lua'
server_script 'server.lua'