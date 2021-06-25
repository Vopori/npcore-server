fx_version 'cerulean'
games { 'gta5' }

description 'NPC-Emergency-Jobs'
version '1.0.0'
--resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_script "@npc-scripts/client/errorlog.lua"

client_script {
  "cl_pogarage.lua"
}
server_script "sv_pogarage.lua"