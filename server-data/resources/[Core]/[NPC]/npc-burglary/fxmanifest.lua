fx_version 'adamant'
games { 'gta5' }

description 'NPC-Burglary'
version '1.0.0'

this_is_a_map 'yes'

client_script 'client/client.lua'
server_script 'server/server.lua'
client_script 'client/safeCracking.lua'
client_script "@npc-scripts/client/errorlog.lua"

data_file 'DLC_ITYP_REQUEST' 'stream/v_int_shop.ytyp'

files {
 'stream/v_int_shop.ytyp'
}