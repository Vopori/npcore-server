fx_version 'cerulean'
games {'gta5'}

description 'NPC-Inventory'
version '1.0.0'

dependencies {
    "PolyZone"
}

client_script "@npc-errorlog/client/cl_errorlog.lua"
client_script "@PolyZone/client.lua"

ui_page 'nui/ui.html'

files {
	"nui/ui.html",
	"nui/pricedown.ttf",
	"nui/default.png",
	"nui/background.png",
	"nui/weight-hanging-solid.png",
	"nui/hand-holding-solid.png",
	"nui/search-solid.png",
	"nui/invbg.png",
	"nui/styles.css",
	"nui/scripts.js",
	"nui/debounce.min.js",
	"nui/loading.gif",
	"nui/loading.svg",
	"nui/icons/*"
  }

shared_script 'shared_list.js'

client_scripts {
  'client.js',
  'functions.lua'
}

server_scripts {
  'sv_functions.lua',
  --'server_degradation.js',
  'server_shops.js',
  'server.js'
}

exports{
	'hasEnoughOfItem',
	'getQuantity',
	'GetCurrentWeapons',
	'GetItemInfo'
}
