fx_version 'adamant'
games { 'gta5' }

description 'NPC-eBlips'
version '1.0.0'

client_script 'config.lua'
client_script 'blips_client.lua'

server_script 'config.lua'
server_script 'blips_server.lua'


client_script "@npc-infinity/client/cl_lib.lua"
server_script "@npc-infinity/server/sv_lib.lua"