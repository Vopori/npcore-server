fx_version 'cerulean'
games {'gta5'}

description 'NPC-Postal-Map'
version '1.0.0'

this_is_a_map 'yes'

client_script "@npc-scripts/client/errorlog.lua"

client_script "client.lua"
client_script "carmap.lua"
client_script "postal_client.lua"

--data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxies.meta'
data_file 'HANDLING_FILE' 'handling.meta'

ui_page "carhud.html"

files {
--	"interiorproxies.meta",
	"handling.meta",
	"carhud.html"
}
