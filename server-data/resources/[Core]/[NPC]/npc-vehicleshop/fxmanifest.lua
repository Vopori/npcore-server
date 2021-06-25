fx_version 'cerulean'
games {'gta5'}

description 'NPC-Vehicle-Shop'
version '1.0.0'
--resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

server_script {
  '@mysql-async/lib/MySQL.lua',
  "server/*.lua"
} 

client_scripts {
    "@PolyZone/client.lua",
    "@npc-scripts/client/errorlog.lua",
    "client/*.lua"
  }