fx_version 'cerulean'
games {'gta5'}

description 'NPC-Keybinds'
version '1.0.0'

client_scripts {
	'client/cl_*.lua',
}

client_exports {
	'registerKeyMapping',
}

export "registerKeyMapping"