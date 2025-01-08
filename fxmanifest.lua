fx_version 'cerulean'
game 'gta5'

author 'Clasam'
description 'Add to database'
version '1.0.0'

lua54 'yes'  -- Activer Lua 5.4

shared_scripts {
  '@ox_lib/init.lua',
    'shared/*.lua'
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua', 
}


