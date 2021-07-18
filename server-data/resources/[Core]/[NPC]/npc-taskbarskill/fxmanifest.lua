fx_version 'cerulean'
games {'gta5'}

description 'NPC-Taskbar-Skill'
version '1.0.0'

ui_page 'index.html'

files {
  "index.html",
  "js/scripts.js",
  "js/jquery.js",
  "css/style.css"
}
client_script {
  "client.lua",
}

export "taskBar"
export "closeGuiFail"