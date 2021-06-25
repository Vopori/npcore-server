fx_version 'adamant'
games {'gta5'}

description 'NPC-Banking'
version '1.0.0'

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/pricedown.ttf',
	'html/bank-icon.png',
	'html/logo.png',
	'html/cursor.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js'
}


client_scripts{
    'client/*.lua',
}

server_scripts{
    'server/*.lua',
}
