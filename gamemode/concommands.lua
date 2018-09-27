function buyEntity(ply, cmd, args)
	if (args[1] != nil) then
		local ent = ents.Create(args[1])
		local tr = ply:GetEyeTrace()

		if (IsValid(ent)) then
			local ClassName = ent:GetClass()

			if (!tr.Hit) then return end

			local entCount = ply:GetNWInt(ClassName .. "count")

			if (!ent.Limit or entCount < ent.Limit) then
				if (ply:CanAfford(ent.Cost)) then
					local SpawnPos = ply:GetShootPos() + ply:GetForward() * 80

					ent.Owner = ply

					ent:SetPos(SpawnPos)
					ent:Spawn()
					ent:Activate()

					ply:RemoveFromBalance(ent.Cost)
					ply:SetNWInt(ClassName .. "count", entCount + 1)

					return ent
				else
					ply:PrintMessage(HUD_PRINTTALK, "You do not have enough money to purchase this item.")
				end
			else
				ply:PrintMessage(HUD_PRINTTALK, "You already have the maximum amount of this entity type. MAX = "..ent.Limit)
			end

			return
		end
	end
end
concommand.Add("buy_entity", buyEntity)

-- function buyGun(ply, cmd, args)
-- 	local weaponPrices = {}
-- 	weaponPrices[1] = {"bb_deagle", "100", "13"}

-- 	for k, v in pairs(weaponPrices) do
-- 		if (args[1] == v[1]) then
-- 			local balance = ply:GetNWInt("playerMoney")
-- 			local playerLvl = ply:GetNWInt("playerLvl")
-- 			local gunCost = tonumber(v[2])
-- 			local levelReq = tonumber(v[3])

-- 			if (playerLvl >= levelReq) then
-- 				if (balance >= gunCost) then
-- 					ply:SetNWInt("playerMoney", balance - gunCost)
-- 					ply:SetNWString("playerWeapon", args[1])
-- 					ply:Give(args[1])
-- 					ply:GiveAmmo(20, ply:GetWeapon(args[1]):GetPrimaryAmmoType(), false)
-- 				else
-- 					ply:PrintMessage(HUD_PRINTTALK, "You do not have enough money to purchase this item.")
-- 				end
-- 			else
-- 				ply:PrintMessage(HUD_PRINTTALK, "You must be level "..levelReq.." to purchase this item.")
-- 			end

-- 			return
-- 		end
-- 	end
-- end
function buyGun(ply, cmd, args)
	if not args[1] then
		return
	end
end
concommand.Add("buy_gun", buyGun)

function upgradePrintAmount(ply, cmd, args)
	Entity(args[1]):SetPrintAmount(100)
end
concommand.Add("upgrade_print_amount", upgradePrintAmount)
