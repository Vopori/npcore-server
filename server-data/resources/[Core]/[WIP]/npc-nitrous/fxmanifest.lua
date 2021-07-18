fx_version "bodacious"

games { "gta5" }

description "NoPixel Vehicles"

version "0.1.0"

server_scripts {
	'config.lua',
	'source/fuel_server.lua',
    'server/main.lua',
}

client_scripts {
    'client/main.lua',
    'client/purge.lua',
    'client/ptfx.lua',
    'config.lua',
	'client/functions_client.lua',
	'client/fuel_client.lua',
}

exports {
	'GetFuel',
	'SetFuel',
}
