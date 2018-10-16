include("shared.lua")
include("testhud.lua")
include("custom_menu.lua")
include("custom_scoreboard.lua")
include("player/sh_player.lua")
include("shop/sh_shop.lua")

function GM:ContextMenuOpen()
	return false
end