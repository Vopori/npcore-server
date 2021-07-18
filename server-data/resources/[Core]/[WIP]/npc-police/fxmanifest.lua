fx_version 'bodacious'
games {'gta5'}

description 'NPC-Evidence-System'
version '1.0.0'
--resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_script "@npc-scripts/client/errorlog.lua"

-- General
client_scripts {
  'client/client.lua',
  'client/client_trunk.lua',
  'client/evidence.lua',
  'client/spikes.lua'
}

server_scripts {
  'server/server.lua'
}

exports {
	'getIsInService',
	'getIsCop',
	'getIsCuffed'
} 
