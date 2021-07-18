fx_version 'adamant'
games {'gta5'}

description 'NPC-Admin-Menu'
version '1.0.0'
--resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

dependency "ghmattimysql"

client_script "@npc-scripts/client/errorlog.lua"
client_script "@npc-warmenu/warmenu.lua"

client_script "@npc-infinity/client/cl_lib.lua"
server_script "@npc-infinity/server/sv_lib.lua"

ui_page "html/index.html"

files({
    "html/index.html",
    "html/script.js",
    "html/styles.css"
})

server_script "shared/sh_admin.lua"
server_script "shared/sh_commands.lua"
server_script "shared/sh_ranks.lua"

client_script "shared/sh_admin.lua"

client_script "client/cl_menu.lua"
client_script "client/cl_noclip.lua"
client_script "client/cl_debug.lua"

client_script "shared/sh_commands.lua"
client_script "shared/sh_ranks.lua"

server_script "server/server.lua"
server_script "server/sv_db.lua"
server_script "server/sv_admin.lua"
client_script "client/cl_admin.lua"