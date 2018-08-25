include("shared.lua")

function ENT:Draw()
    self:DrawModel()

    local Pos = self:GetPos()
    local Ang = self:GetAngles()

    Ang:RotateAroundAxis(Ang:Up(), 90)

    local EntityName = "Basic Printer"
    local PrinterOwner = self:GetBuyer()
    local MoneyAmount = self:GetStorage()

    surface.SetFont("HudHintTextLarge")
    local EntityNameWidth = surface.GetTextSize(EntityName)

    surface.SetFont("HudHintTextSmall")
    local PrinterOwnerWidth = surface.GetTextSize(PrinterOwner)
    local MoneyAmountWidth = surface.GetTextSize(MoneyAmount)

    cam.Start3D2D(Pos + Ang:Up() * 5, Ang, 0.2)
        draw.WordBox(0, -EntityNameWidth * 0.5, -30, EntityName, "HudHintTextLarge", Color(0, 0, 0, 100), Color(255, 255, 255, 255))
        draw.WordBox(0, -PrinterOwnerWidth * 0.5, -10, PrinterOwner, "HudHintTextSmall", Color(0, 0, 0, 100), Color(255, 255, 255, 255))
        draw.WordBox(0, -MoneyAmountWidth * 0.5, 1, MoneyAmount, "HudHintTextSmall", Color(0, 0, 0, 100), Color(255, 255, 255, 255))
    cam.End3D2D()

    surface.SetFont("HudHintTextLarge")

    local ButtonName = "Print Amount"
    local ButtonNameWidth = surface.GetTextSize(ButtonName)

    local UpgradeAng = self:GetAngles()

    UpgradeAng:RotateAroundAxis(UpgradeAng:Forward(), 90)
    UpgradeAng:RotateAroundAxis(UpgradeAng:Right(), 270)

    cam.Start3D2D(Pos + UpgradeAng:Up() * 8, UpgradeAng, 0.2)
        draw.WordBox(0, -ButtonNameWidth * 0.5, -10, ButtonName, "HudHintTextLarge", Color(55, 55, 55, 100), Color(255, 255, 255, 255))

        if LocalPlayer():GetEyeTrace().Entity then
            if LocalPlayer():GetEyeTrace().Entity == self then
                local tr = self:WorldToLocal(LocalPlayer():GetEyeTrace().HitPos)

                if ((tr.x > 7 and tr.x < 7.1) and (tr.y > -5.9 and tr.y < 6.1)) then
                    draw.WordBox(0, -ButtonNameWidth * 0.5, -10, ButtonName, "HudHintTextLarge", Color(55, 55, 55, 200), Color(255, 255, 255, 255))

                    if (LocalPlayer():KeyDown(IN_USE)) then
                        LocalPlayer():ConCommand("upgrade_print_amount "..self:EntIndex())
                    end
                end
            end
        end
    cam.End3D2D()
end
