fx_version 'cerulean'
games { 'gta5' }

description 'NPC-Fuel-Stations'
version '1.0.0'
--resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_script "@npc-scripts/client/errorlog.lua"
ui_page 'html/ui.html'

files {
	'html/*',
}

client_script 'client/client.lua'