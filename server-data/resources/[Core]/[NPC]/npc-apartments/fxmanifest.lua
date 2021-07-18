fx_version 'cerulean'
game 'gta5'

description 'NPC-Apartments'
version '1.0.0'

ui_page 'index.html'

files {
    "index.html",
    "scripts.js",
    "css/style.css",
}

server_scripts {
    "server/apart_server.lua",
    "server/hotel_server.lua",
	"@mysql-async/lib/MySQL.lua"
}

client_scripts {
    "client/apart_client.lua",
	"client/hotel_client.lua"
}

client_script 'GUI.lua'