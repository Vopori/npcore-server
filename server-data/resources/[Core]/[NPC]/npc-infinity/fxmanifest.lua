fx_version "adamant"
games {"gta5"}

description 'NPC-Infinity'
version '1.0.0'

client_scripts {
    "client/cl_*.lua"
}

server_scripts {
    "server/sv_*.lua"
}

server_script "tests/sv_*.lua"
client_script "tests/cl_*.lua"
