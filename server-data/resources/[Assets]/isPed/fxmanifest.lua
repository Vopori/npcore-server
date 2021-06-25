fx_version 'adamant'
games {'gta5'}

description 'NPC-isPed'
version '1.0.0'

client_script "@npc-scripts/client/errorlog.lua"

client_script {
  "client.lua",
}
export "GetClosestNPC"
export "IsPedNearCoords"
export "isPed"
export "GroupRank"
export "GlobalObject"
export "retreiveBusinesses"