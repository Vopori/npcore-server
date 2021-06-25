fx_version 'adamant'
games {'gta5'}

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
    '@mysql-async/lib/MySQL.lua',
    "sv_mdt.lua",
    "sv_vehcolors.lua"
}

client_script "cl_mdt.lua"
client_script "@npc-errorlog/client/cl_errorlog.lua"
