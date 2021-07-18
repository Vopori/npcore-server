fx_version 'adamant'
game 'gta5'

description 'NPC-MDT'
version '1.0.0'

ui_page "ui/index.html"

files {
    "ui/index.html",
    "ui/vue.min.js",
    "ui/script.js",
    "ui/main.css",
    "ui/styles/police.css",
    "ui/badges/police.png",
    "ui/footer.png",
    "ui/mugshot.png"
}

server_scripts {
    "server/sv_mdt.lua",
    "server/sv_vehcolors.lua"
}

client_script "client/cl_mdt.lua"
client_script "@npc-scripts/client/errorlog.lua"