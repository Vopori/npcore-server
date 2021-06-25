fx_version 'bodacious'
games {'gta5'}

description 'NPC-MDT-CIV'
version '1.0.0'
--resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_script "@npc-scripts/client/errorlog.lua"

-- General
client_scripts {
  'client.lua',
  'client_trunk.lua',
  'evidence.lua',
  'cl_spikes.lua'
}

server_scripts {
  'server.lua'
}

exports {
	'getIsInService',
	'getIsCop',
	'getIsCuffed'
} 
