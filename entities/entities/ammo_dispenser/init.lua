AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if (IsValid(phys)) then
		phys:Wake()
	end
	
	self:SetHealth(self.BaseHealth)
end

function ENT:Use(activator, caller)
	local ammoType = activator:GetActiveWeapon():GetPrimaryAmmoType() -- Get primary weapons ammo type
	
	activator:GiveAmmo(5, ammoType, true)
end

function ENT:Think()
	-- Called every tick
end

function ENT:OnTakeDamage(damage)
	self:SetHealth(self:Health() - damage:GetDamage())
	
	if (self:Health() <= 0) then
		self:Remove()
	end
end