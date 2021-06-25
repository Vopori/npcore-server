fx_version 'adamant'
game 'gta5'

description 'NPC-Car-Player-Hud'
version '1.0.0'

client_script "@npc-scripts/client/errorlog.lua"
client_script "@npc-infinity/client/cl_lib.lua"
server_script "@npc-infinity/server/sv_lib.lua"

client_script 'carhud.lua'
server_script 'carhud_server.lua'
client_script 'newsStands.lua'

ui_page('html/index.html')
files({
	"html/index.html",
	"html/script.js",
	"html/styles.css",
	"html/img/*.svg",
	"html/img/*.png"
})

exports {
	"playerLocation",
	"playerZone"
}