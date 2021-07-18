fx_version 'cerulean'
games { 'gta5' }

description 'NPC PolyZone'
version '1.0'

dependencies {
    'PolyZone'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    '@PolyZone/EntityZone.lua',
    'client/*.lua'
}
server_scripts {'server/*.lua'}