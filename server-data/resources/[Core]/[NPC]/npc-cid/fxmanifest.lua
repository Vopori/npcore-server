fx_version 'adamant'
games { 'gta5' }

description 'NPC-CID'
version '1.0.0'

client_script "@npc-scripts/client/errorlog.lua"

client_script 'cid_client.lua'
server_script 'cid_server.lua'

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/pricedown.ttf',
	'html/button.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js',
	'html/background2.png'
}