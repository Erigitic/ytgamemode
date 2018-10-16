local menu
local ply

local function openF4Menu()
	ply = LocalPlayer()

	if (IsValid(menu)) then
		menu:Show()
	else
		menu = vgui.Create("F4Menu")

		local shopPanel = vgui.Create("ShopPanel", menu)

		menu:AddSheet("Shop", shopPanel)
	end
end
concommand.Add("open_game_menu", openF4Menu)

local PANEL = {}

function PANEL:Init()
	self:StretchToParent(100, 100, 100, 100) -- Stretches to screen with an offset of 100 all around
	self:Center()
	self:MakePopup()
	self:SetupCloseButton(function() 
		self:Close() -- On click, close the panel
	end)
	self:ParentToHUD() -- Hides the panel when in the escape menu
end

function PANEL:SetupCloseButton(func)
	-- Since we're basing this control off of a DPropertySheet we are able to edit something called the tabScroller.
	-- The tabScroller is a horizontal scrollbar that allows tabs to be scrolled left and right when needed.
	-- We can add to it in order to create a close button on the far right hand side.
	-- The only problem, the close button will overlap tabs if there are too many of them.
	-- This will most likely not be an issue for us.
	self.CloseButton = self.tabScroller:Add("DButton")
	self.CloseButton:SetText("")
	self.CloseButton.DoClick = func
	self.CloseButton.Paint = function(panel, w, h)
		derma.SkinHook("Paint", "WindowCloseButton", panel, w, h)
	end
    self.CloseButton:Dock(RIGHT) -- Align it to the far right side
    self.CloseButton:DockMargin(0, 0, 0, 8) -- Bottom margin of 8
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
-- Register our custom panel and set its base to DPropertySheet
vgui.Register("F4Menu", PANEL, "DPropertySheet")

PANEL = {}

function PANEL:Init()
	local categoryList = vgui.Create("DCategoryList", self)
	categoryList:Dock(FILL) -- Fill parent

	-- Loop through each category in alphabetical order
	for categoryName, categoryTbl in SortedPairs(YTG.ShopItems) do
		local collapsibleCategory = vgui.Create("DCollapsibleCategory", categoryList)
		collapsibleCategory:SetLabel(categoryName)

		local iconLayout = vgui.Create("DIconLayout", collapsibleCategory)
		collapsibleCategory:SetContents(iconLayout)

		-- Loop through each item, sorted by price from high to low, in the current category table
		for itemName, itemTbl in SortedPairsByMemberValue(categoryTbl, "Price") do
			local model = itemTbl.Model
			local price = itemTbl.Price
			local lvlReq = itemTbl.LvlReq

			local icon = vgui.Create("SpawnIcon", iconLayout)
			icon:SetModel(model)
			icon:SetToolTip(
				itemName..
				"\nPrice: "..price..
				"\nLevel: "..lvlReq
			)
			icon.DoClick = function()
				RunConsoleCommand("buy_item", categoryName, itemName)
			end
		end
	end
end
vgui.Register("ShopPanel", PANEL, "DPanel")