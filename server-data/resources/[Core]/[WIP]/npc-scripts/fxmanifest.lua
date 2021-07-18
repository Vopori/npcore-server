fx_version 'cerulean'
games { 'gta5' }

description 'NPC-Scripts (Small Resources)'
version '1.0.0'

this_is_a_map "yes"

shared_script 'config.lua'

client_scripts {
	"client/assets.lua",
	"client/errorlog.lua",
	"client/vehicleAI.lua",
	"client/dirtymoney.lua",
	"client/drugdeliveries.lua",
	"client/rpcommands.lua",
	"client/npcscripts.lua",
	"client/drzinteriors.lua",
	"client/firedepartment.lua",
	"client/gangsweaponshop.lua",
	"client/golf.lua",
	"client/givekeys.lua",
	"client/hospitalization.lua",
	"client/outlawalerts.lua",
	"client/portals.lua",
	"client/propattach.lua",
	"client/ragdoll.lua",
	"client/secondaryjobs.lua",
	"client/scoreboard.lua",
	"client/vehiclemods.lua",
	"client/lifetraffic.net.dll",
	"client/koil-debug.lua",
	"@PolyZone/client.lua",
	"@npc-warmenu/warmenu.lua",
	"@npc-scripts/errorlog.lua",
	"@npc-infinity/client/cl_lib.lua",
	"@npc-infinity/client/classes/blip.lua"
}

server_scripts {
	"server/assets.lua",
	"server/errorlog.lua",
	--"server/discordperms.lua",
	--"server/discordwhitelist.lua",
	"server/drzinteriors.lua",
	"server/drugdeliveries.lua",
	"server/firedepartment.lua",
	"server/gangsweaponshop.lua",
	"server/givekeys.lua",
	"server/hospitalization.lua",
	"server/jailbreak.lua",
	"server/log.lua",
	"server/npcscripts.lua",
	"server/outlawalerts.lua",
	"server/ragdoll.lua",
	"server/rpcommands.lua",
	"server/scoreboard.lua",
	"server/secondaryjobs.lua",
	"server/vehiclemods.lua",
	"@npc-infinity/server/sv_lib.lua"
	--"server/whitelist.lua"
}

server_export "AddLog"
data_file 'FIVEM_LOVES_YOU_4B38E96CC036038F' 'events.meta'
data_file 'FIVEM_LOVES_YOU_341B23A2F0E0F131' 'popgroups.ymt'

files {
	'html/index.html',
	'html/jquery.js',
	'html/init.js',
	'events.meta',
	'popgroups.ymt',
	'relationships.dat'
}

exports {
	"set",
	"isPed",
	"tryGet",
	"getTax",
	"AddLog",
	"remove",
	"GroupRank",
	"GlobalObject",
	--"GetRoles",
	--"IsRolePresent",
	"particleStart",
	"GetClosestNPC",
	"IsPedNearCoords",
	"retreiveBusinesses",
	"ShowWeashopBlips",
	"getWeaponMetaData",
	"updateWeaponMetaData",
	"ResetBlipInfo",
	"SetBlipInfo",
	"SetBlipInfoTitle",
	"SetBlipInfoImage",
	"SetBlipInfoEconomy",
	"AddBlipInfoText",
	"AddBlipInfoName",
	"AddBlipInfoHeader",
	"AddBlipInfoIcon"
}

dependencies {
	"npc-core",
	"PolyZone",
	"ghmattimysql"
}