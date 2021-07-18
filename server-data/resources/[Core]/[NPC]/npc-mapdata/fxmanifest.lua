fx_version 'cerulean'
games {'gta5'}

description 'NPC-Map-Data'
version '1.0.0'

this_is_a_map 'yes'

client_script {
  'gabz_entitysets_mods_1.lua',
  '@npc-errorlog/client/cl_errorlog.lua',
  'client.lua',
  'afterhours.lua'
}

files {
  'gabz_timecycle_mods_1.xml',
}

data_file 'TIMECYCLEMOD_FILE' 'gabz_timecycle_mods_1.xml'