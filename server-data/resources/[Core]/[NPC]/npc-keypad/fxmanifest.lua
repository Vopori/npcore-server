fx_version "cerulean"
games {'gta5'}

description 'NPC-Keypad'
version '1.0.0'
--resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_script "@npc-scripts/client/errorlog.lua"

client_script 'keypad_client.lua'

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