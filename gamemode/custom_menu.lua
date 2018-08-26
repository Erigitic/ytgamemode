local menu
local ply

local function openF4Menu()
	ply = LocalPlayer()

	if IsValid(menu) then
		menu:Show()
		menu:InvalidateLayout()
	else
		menu = vgui.Create("F4Menu")

		local shopPanel = vgui.Create("ShopPanel", menu)

		menu:AddSheet("Shop Panel", shopPanel)
	end
end
concommand.Add("open_game_menu", openF4Menu)

local PANEL = {}

function PANEL:Init()
	self:StretchToParent(100, 100, 100, 100) -- Stretches to screen with an offset of 100 all around
	self:Center()
	self:MakePopup()
	self:SetupCloseButton(function() 
		self:Close() 
	end)
	self:ParentToHUD() -- Hides the panel when in the escape menu
end

function PANEL:SetupCloseButton(func)
	self.CloseButton = self.tabScroller:Add("DButton")
    self.CloseButton:SetText("")
    self.CloseButton.DoClick = func
	self.CloseButton.Paint = function(panel, w, h)
		derma.SkinHook("Paint", "WindowCloseButton", panel, w, h)
	end
    self.CloseButton:Dock(RIGHT)
    self.CloseButton:DockMargin(0, 0, 0, 8)
    self.CloseButton:SetSize(32, 32)
end

function PANEL:Show()
	self:SetVisible(true)
end

function PANEL:Hide()
	self:SetVisible(false)
end

-- Overwrite what happens when the panel is closed
function PANEL:Close()
	self:Hide()
end
derma.DefineControl("F4PropertySheet", "", vgui.GetControlTable("DPropertySheet"), "EditablePanel")
derma.DefineControl("F4Menu", "", PANEL, "F4PropertySheet")

-- Shop Panel

PANEL = {} -- Create an empty panel

function PANEL:Init() -- Initialize the panel
	self:StretchToParent(0, 0, 0, 0)
	
	local categoryList = vgui.Create("DPanelList", self)
	categoryList:StretchToParent(0, 0, 0, 0)
	categoryList:SetSpacing(5)
	categoryList:EnableHorizontal(false)
	categoryList:EnableVerticalScrollbar(true)

	local entityCategory = vgui.Create("DCollapsibleCategory", categoryList)
	entityCategory:SetPos(0, 0)
	entityCategory:SetSize(self:GetWide(), 50)
	entityCategory:SetLabel("Entities")
	
	local weaponCategory = vgui.Create("DCollapsibleCategory", categoryList)
	weaponCategory:SetPos(0, 50)
	weaponCategory:SetSize(self:GetWide(), 50)
	weaponCategory:SetLabel("Weapons")

	local entityList = vgui.Create("DPanelList", entityCategory)
	entityList:EnableVerticalScrollbar(true)
	entityList:EnableHorizontal(true)
	entityList:SetAutoSize(true)
	entityList:SetSpacing(5)
	entityList:SetPadding(5)
	entityCategory:SetContents(entityList)

	local weaponList = vgui.Create("DPanelList", weaponCategory)
	weaponList:EnableVerticalScrollbar(true)
	weaponList:EnableHorizontal(true)
	weaponList:SetAutoSize(true)
	weaponList:SetSpacing(5)
	weaponList:SetPadding(5)
	weaponCategory:SetContents(weaponList)

	categoryList:AddItem(entityCategory)
	categoryList:AddItem(weaponCategory)
	
	local entsArr = {}
	entsArr[1] = scripted_ents.Get("ammo_dispenser")
	entsArr[2] = scripted_ents.Get("barricade")
	
	for k, v in pairs(entsArr) do
		local icon = vgui.Create("SpawnIcon", entityList)
		icon:SetModel(v["Model"])
		icon:SetToolTip(v["PrintName"].."\nCost: "..v["Cost"])
		icon:InvalidateLayout(true)
		entityList:AddItem(icon)
		icon.DoClick = function(icon)
			ply:ConCommand("buy_entity "..v["ClassName"])
		end
	end
	
	local weaponsArr = {}
	weaponsArr[1] = {"models/weapons/w_pist_deagle.mdl", "bb_deagle", "Desert Eagle", "100", "1"}
	
	for k, v in pairs(weaponsArr) do
		local icon = vgui.Create("SpawnIcon", weaponList)
		icon:SetModel(v[1])
		icon:SetToolTip(v[3].."\nCost: "..v[4].."\nLevel Req: "..v[5])
		icon:InvalidateLayout(true)
		weaponList:AddItem(icon)
		icon.DoClick = function(icon)
			ply:ConCommand("buy_gun "..v[2])
		end
	end
end
vgui.Register("ShopPanel", PANEL, "DPanel")

-- End Shop Panel