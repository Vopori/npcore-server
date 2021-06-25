fx_version 'cerulean'
games { 'gta5' }

description 'NPC-Discord-Permissions'
version '1.0.0'

server_scripts {
	"config.lua",
	"server.lua"
}

server_export "IsRolePresent"
server_export "GetRoles"
