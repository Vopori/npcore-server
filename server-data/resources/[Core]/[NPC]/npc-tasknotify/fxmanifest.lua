fx_version 'cerulean'
games {'gta5'}

description 'NPC-Tasknotify'
version '1.0.0'

client_script "@npc-scripts/client/errorlog.lua"

ui_page 'index.html'

files {
  "index.html",
  "scripts.js",
  "css/style.css"
}
client_script {
  "client.lua",
}
