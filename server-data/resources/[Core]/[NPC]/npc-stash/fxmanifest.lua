fx_version 'adamant'
game {'gta5'}

description 'NPC-Stash'
version '1.0.0'
this_is_a_map 'yes'

dependency "ghmattimysql"

files {
      'shellpropsv15.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'shellpropsv15.ytyp'

client_script 'client/stashhouse_client.lua'

server_scripts {
	'server/stashhouse_server.lua',
	'server/svstashes.lua',
}

export "stash"

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/pricedown.ttf',
	'html/cursor.png',
	'html/background.png',
	'html/Drill.png',
	'html/LockFace.png',
	'html/DestroyPin.png',
	'html/HoldingPin.png',
	'html/HoldingBreak.png',
	'html/sounds/pinbreak.ogg',
	'html/sounds/lockUnlocked.ogg',
	'html/sounds/lockpick.ogg',
	'html/Drill2.png',
	'html/button.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js',
	'html/background2.png'
}