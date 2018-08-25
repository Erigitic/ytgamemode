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

    -- Setup print timer
    timer.Create("PrintTimer"..self:EntIndex(), self.PrintRate, 0, function()
        self:SetStorage(self:GetStorage() + self:GetPrintAmount())
    end)
end

function ENT:SpawnFunction(ply, tr, ClassName)
    if (!tr.Hit) then return end

    local SpawnPos = ply:GetShootPos() + ply:GetForward() * 80

    local ent = ents.Create(ClassName)

    ent:SetBuyer(ply:GetName())
    ent:SetStorage(0)
    ent:SetPrintAmount(20)

    ent:SetPos(SpawnPos)
    ent:Spawn()
    ent:Activate()

    return ent
end

function ENT:Use(activator, caller)
    activator:SetNWInt("playerMoney", activator:GetNWInt("playerMoney") + self:GetStorage())

    self:SetStorage(0)
end

function ENT:OnTakeDamage(damage)
    self:SetHealth(self:Health() - damage:GetDamage())

    if (self:Health() <= 0) then
        timer.Remove("PrintTimer"..self:EntIndex())
        self:Remove()
    end
end
