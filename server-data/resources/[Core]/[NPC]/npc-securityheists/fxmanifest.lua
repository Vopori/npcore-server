fx_version 'cerulean'
games {'gta5'}

description 'NPC-Security-Heists'
version '1.0.0'
--resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_script "@npc-scripts/client/errorlog.lua"
client_script 'client/client.lua'
client_script 'client/clientTowAI.lua'
server_script "server/server.lua"