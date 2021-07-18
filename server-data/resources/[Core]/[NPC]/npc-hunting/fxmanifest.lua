fx_version 'adamant'
game 'gta5'

description 'NPC-Hunting'
version '1.0.0'

server_script '@mysql-async/lib/MySQL.lua'
server_script 'server/sv_hunting.lua'
client_script "client/warmenu.lua"
client_script "client/cl_hunting.lua"


files{
    'html/*'
}

ui_page('html/index.html')