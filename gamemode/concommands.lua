local function handleLimitChange(ent, itemName, ply)
	ply:SetVar("amount_"..itemName, ply:GetVar("amount_"..itemName, 0) + 1)

	ent:CallOnRemove("DecrementLimit", function()
		ply:SetVar("amount_"..itemName, ply:GetVar("amount_"..itemName) - 1)
	end)
end

-- The underscore in the function arguments just indicates we won't be using it within the function.
local function buyItem(ply, _, args)
	local categoryName = args[1]
	local itemName = args[2]

	local itemTbl = YTG.ShopItems[categoryName][itemName]

	local isGun = itemTbl.IsGun or false
	local price = itemTbl.Price
	local lvlReq = itemTbl.LvlReq
	local limit = itemTbl.Limit
	local model = itemTbl.Model
	local className = itemTbl.ClassName

	if not ply:CanAfford(price) then
		ply:ChatPrint("You can't afford this item.")
		return
	end

	if ply:GetLevel() < lvlReq then
		ply:ChatPrint("You must be level "..lvlReq.." to purchase this item.")
		return
	end

	if (isGun) then
		ply:Give(className)
		ply:GiveAmmo(20, ply:GetWeapon(className):GetPrimaryAmmoType(), false)
	else -- Scripted entity
		if limit then
			local plyCurSpawnAmount = ply:GetVar("amount_"..itemName, 0) -- We don't need this value clientside, so just grab it from the player table, default to 0 if doesn't exist
	
			if plyCurSpawnAmount >= limit then
				ply:ChatPrint("You've reached the spawn limit for this item.")
				return
			end
		end

		local tr = {}
		tr.start = ply:EyePos()
		tr.endpos = tr.start + ply:GetAimVector() * 85 -- Only allow the trace to travel 85 units forward
		tr.filter = ply -- Filter out the player so the trace doesn't hit them

		-- Perform the trace with the trace data created above. Returns the result of the trace.
		tr = util.TraceLine(tr)

		local SpawnPos = tr.HitPos + Vector(0, 0, 40)
		local SpawnAng = ply:EyeAngles()
		SpawnAng.pitch = 0 -- Set pitch to 0
		SpawnAng.yaw = SpawnAng.y + 180 -- Increment yaw by 180. In simpler terms, rotate 180 degrees around the vertical axis. This makes the entity face the player.

		local ent = ents.Create(className)
		ent.Owner = ply
		ent:SetModel(model)
		ent:SetPos(SpawnPos)
		ent:SetAngles(SpawnAng)
		ent:Spawn()
		ent:Activate()

		if limit then
			handleLimitChange(ent, itemName, ply)
		end
	end

	ply:RemoveFromBalance(price)
end
concommand.Add("buy_item", buyItem)
