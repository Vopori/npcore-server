fx_version 'cerulean'
games { 'gta5' }

description 'NPC-HUD'
version '1.0.0'

client_script "@npc-scripts/client/errorlog.lua"
client_script 'client/carhud.lua'
client_script 'client/cl_autoKick.lua'
client_script 'client/newsStands.lua'
server_script 'server/carhud_server.lua'
server_script 'server/sr_autoKick.lua'

ui_page('html/index.html')

files({
	"html/script.js",
	"html/jquery.min.js",
	"html/jquery-ui.min.js",
	"html/debounce.min.js",
	"html/styles.css",
	"html/img/*.svg",
	"html/img/*.png",
	"html/index.html",
	"html/fonts/Roboto-Bold.ttf",
	"html/fonts/Roboto-Bold.woff",
	"html/fonts/Roboto-Bold.woff2",
	"html/fonts/Roboto-Regular.ttf",
	"html/fonts/Roboto-Regular.woff",
	"html/fonts/Roboto-Regular.woff2",
	"html/fonts/upbolters.otf",
})

exports {
	"playerLocation",
	"playerZone",
	"GetStress",
	"GetFood",
	"GetThirst"
}