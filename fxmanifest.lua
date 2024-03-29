fx_version "cerulean"
game 'gta5'

lua54 'yes'
use_experimental_fxv2_oal "yes"

author 'CaptainExorY'
description 'Advanced NUI Based Admin Menu.'
ui_page 'web/dist/index.html'

shared_scripts {
	"config.lua",
	"shared/locale.lua",
	"locales/en.lua",
	'shared/utils.lua',
	'@es_extended/locale.lua',
}

client_scripts {
	"client/cl_utils.lua",
	"client/modules/**/*",
	"client/core.lua",
	"client/events.lua",
	"client/nui_callbacks.lua",
	"client/playerNames.lua",
	"client/spectate.lua",
	"client/commands.lua",
}

server_scripts {
	"sv_config.lua",
	"server/webhooks.lua",
	'server/sv_utils.lua',
	"server/modules/**/*",
	'server/Classes/**/*',
	"server/events.lua",
	"server/core.lua",
	"server/commands.lua",
	'@es_extended/locale.lua',
}

files {
	'web/dist/index.html',
	'web/dist/**/*',
}

escrow_ignore {
    'sv_config.lua',
	'config.lua',
	'locales/**';
}