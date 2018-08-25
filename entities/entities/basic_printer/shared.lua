function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "Buyer")
    self:NetworkVar("Int", 0, "Storage")
    self:NetworkVar("Int", 1, "PrintAmount")
end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Basic Printer"
ENT.Author = "Erigitic"
ENT.Contact = ""
ENT.Purpose = "Print money"
ENT.Instructions = "Place and print"
ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.BaseHealth = 20
ENT.PrintRate = 1 -- In seconds

ENT.Model = "models/props_lab/reciever01a.mdl"
