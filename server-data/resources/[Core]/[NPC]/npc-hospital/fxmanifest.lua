resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
fx_version 'adamant'
games { 'gta5' }

description 'NPC-Hospital'
version '1.0.0'

client_scripts {
	'config.lua',
	'client/wound.lua',
	'client/main.lua',
	'client/items.lua',
	'client/bed_c.lua',
}

server_scripts {
	'server/wound.lua',
	'server/main.lua',
	'server/items.lua',
}

exports {
    'IsInjuredOrBleeding',
	'DoLimbAlert',
	'DoBleedAlert',
}

server_exports {
    'GetCharsInjuries',
}