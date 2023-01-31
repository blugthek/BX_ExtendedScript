fx_version 'cerulean'
games { 'gta5' }
version '1.1a'
author 'BLUGTHEK'
description 'Utility By BLUGTHEK'

client_script {
    '@es_extended/locale.lua',
    'client.lua',
    'config.lua'
}

server_scripts {
    '@es_extended/locale.lua',
    'server.lua',
    'config.lua'
}

files {
    'peds.xml'
}

data_file "PED_METADATA_FILE" "peds.xml"