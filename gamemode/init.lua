AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("testhud.lua")
AddCSLuaFile("custom_menu.lua")
AddCSLuaFile("custom_scoreboard.lua")
AddCSLuaFile("player/sh_player.lua")

include("shared.lua")
include("concommands.lua")
include("player/sh_player.lua")
include("player/sv_player.lua")

function GM:PlayerInitialSpawn(ply)
	if (ply:GetPData("playerLvl") == nil) then
		ply:SetNWInt("playerLvl", 1)
	else
		ply:SetNWInt("playerLvl", tonumber(ply:GetPData("playerLvl")))
	end
	
	if (ply:GetPData("playerExp") == nil) then
		ply:SetNWInt("playerExp", 0)
	else
		ply:SetNWInt("playerExp", tonumber(ply:GetPData("playerExp")))
	end
	
	if (ply:GetPData("playerMoney") == nil) then
		ply:SetNWInt("playerMoney", 0)
	else
		ply:SetNWInt("playerMoney", tonumber(ply:GetPData("playerMoney")))
	end
	
	if (ply:GetPData("playerWeapon") != nil) then
		ply:SetNWString("playerWeapon", ply:GetPData("playerWeapon"))
	end
end

function GM:OnNPCKilled(npc, attacker, inflictor)
	attacker:SetNWInt("playerMoney", attacker:GetNWInt("playerMoney") + 100)
	
	attacker:SetNWInt("playerExp", attacker:GetNWInt("playerExp") + 101)
	
	checkForLevel(attacker)
end

function GM:PlayerDeath(victim, inflictor, attacker)
	if (IsValid(attacker) and attacker:IsPlayer()) then
		attacker:SetNWInt("playerMoney", attacker:GetNWInt("playerMoney") + 100)
		
		attacker:SetNWInt("playerExp", attacker:GetNWInt("playerExp") + 101)
		
		attacker:SetFrags(attacker:Frags() + 1)
		
		checkForLevel(attacker)
	end
end

function GM:PlayerLoadout(ply)
	ply:Give("weapon_pistol")
	ply:Give("weapon_physgun")
	ply:Give("weapon_physcannon")
	
	if (ply:GetNWString("playerWeapon") != nil) then
		ply:Give(ply:GetNWString("playerWeapon"))
	end
	
	ply:GiveAmmo(9999, "Pistol", true)
	
	return true
end

function GM:PhysgunPickup(ply, ent)
	if (ent.Owner == ply) then
		return true
	end
	
	return false
end

function checkForLevel(ply)
	local expToLevel = (ply:GetNWInt("playerLvl") * 100) * 2
	local curExp = ply:GetNWInt("playerExp")
	local curLvl = ply:GetNWInt("playerLvl")
	
	if (curExp >= expToLevel) then
		curExp = curExp - expToLevel
		
		ply:SetNWInt("playerExp", curExp)
		ply:SetNWInt("playerLvl", curLvl + 1)
		
		ply:PrintMessage(HUD_PRINTTALK, "Congratulations! You are now level "..(curLvl + 1)..".")
	end
end

function GM:ShowSpare2(ply)
	ply:ConCommand("open_game_menu")
end

function GM:PlayerDisconnected(ply)
	ply:SetPData("playerLvl", ply:GetNWInt("playerLvl"))
	ply:SetPData("playerExp", ply:GetNWInt("playerExp"))
	ply:SetPData("playerMoney", ply:GetNWInt("playerMoney"))
	ply:SetPData("playerWeapon", ply:GetNWString("playerWeapon"))
end

function GM:ShutDown()
	for k, v in pairs(player.GetAll()) do
		v:SetPData("playerLvl", v:GetNWInt("playerLvl"))
		v:SetPData("playerExp", v:GetNWInt("playerExp"))
		v:SetPData("playerMoney", v:GetNWInt("playerMoney"))
		v:SetPData("playerWeapon", v:GetNWString("playerWeapon"))
	end
end

function GM:GravGunPunt(player, entity)
	if (entity:GetClass() == "ammo_dispenser") then
		return false
	end
	
	return true
end