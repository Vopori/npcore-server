fx_version "adamant"
games {"gta5"}

description 'FiveM Queue System'
version '1.0.0'
version "1.0.0"

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

--dependency "connectqueue"
dependency "ghmattimysql"

--server_script "@connectqueue/connectqueue.lua"
server_script "sv_whitelist.lua"