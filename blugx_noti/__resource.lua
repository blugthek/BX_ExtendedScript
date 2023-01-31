resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Alert : NC Bridge'

ui_page {
	'html/main.html',
}

files {
	'html/main.html',
	'html/alert.wav',
	'html/main.mp3',
}

client_scripts {
	'config.lua',
	'client.lua',
}

server_scripts {
	'config.lua',
	'server.lua'
}