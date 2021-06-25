fx_version 'cerulean'
games {'gta5'}

description 'NPC-Loading-Screen'
version '1.0.0'

files {
    'index.html',
    'style.css',
    'images/*',
    'script.js',
	'logo.png',
	'html/logo.png',
    'vue.min.js'
}

loadscreen 'index.html'

loadscreen_manual_shutdown "yes"

client_script "client.lua"