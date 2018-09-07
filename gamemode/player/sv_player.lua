local meta = FindMetaTable("Player")

function meta:AddToBalance(amount)
	local curBalance = self:GetBalance()

	self:SetBalance(curBalance + amount)
end

function meta:RemoveFromBalance(amount)
	local curBalance = self:GetBalance()

	self:SetBalance(curBalance - amount)
end

function meta:SetBalance(balance)
	self:SetNWInt("playerMoney", balance)
end

function meta:SetLevel(level)
	self:SetNWInt("playerLvl", level)
end

function meta:AddExp(amount)
	local curExp = self:GetExp()

	self:SetExp(curExp + amount)
end

function meta:SetExp(exp)
	self:SetNWInt("playerExp", exp)
end