fx_version 'cerulean'
games {'gta5'}

description 'NPC-Mobile-Hacking'
version '1.0.0'
--resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page 'hack.html'

client_scripts {
  'mhacking.lua',
  'sequentialhack.lua'
}

files {
  'phone.png',
  'pepe_hack.gif',
  'snd/beep.ogg',
  'snd/correct.ogg',
  'snd/fail.ogg', 
  'snd/start.ogg',
  'snd/finish.ogg',
  'snd/wrong.ogg',
  'hack.html'
}