fx_version 'cerulean'
games {'gta5'}

description 'NPC-Interact-Sound'
version '1.0.0'
author 'Scott'

client_script "@npc-scripts/client/errorlog.lua"

-- Manifest Version
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

client_script "@npc-infinity/client/cl_lib.lua"
server_script "@npc-infinity/server/sv_lib.lua"

-- Client Scripts
client_script 'client/main.lua'

-- Server Scripts
server_script 'server/main.lua'

-- NUI Default Page
ui_page('client/html/index.html')

-- Files needed for NUI
-- DON'T FORGET TO ADD THE SOUND FILES TO THIS!
files({
    'client/html/index.html',
    -- Begin Sound Files Here...
    'client/html/sounds/*.ogg'
})