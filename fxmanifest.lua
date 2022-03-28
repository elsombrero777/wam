fx_version 'cerulean'
lua54 'yes'
game 'gta5'

name "wam"
description "What A Marketplace"
author "Nfire , elsombrero"
version "1.0.0"

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua',
	'locales/*.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'server/*.lua'
}
