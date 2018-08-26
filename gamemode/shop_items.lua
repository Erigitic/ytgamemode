YTG.ShopItems = {}

function YTG.RegisterShopItem(name, shopItem)
	YTG.ShopItems[name] = shopItem
end

-- Ammo Dispenser
local ITEM = {}

ITEM.Name = "Ammo Dispenser"
ITEM.Description = "Dispenses ammo."
ITEM.Price = 100
ITEM.LvlReq = 1
function ITEM.OnUnlock(ply)
	ply:ConCommand("buy_entity "..ITEM)
end

YTG.RegisterShopItem("Ammo_Dispenser", ITEM)

ITEM = {}

ITEM.Name = "Barricade"
ITEM.Description = "Protective barrier."
ITEM.Price = 100
ITEM.LvlReq = 1
function ITEM.OnUnlock(ply)

end

YTG.RegisterShopItem("Barricade", ITEM)