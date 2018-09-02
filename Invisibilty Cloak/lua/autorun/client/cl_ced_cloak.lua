
local CedCloakLerp = 0

hook.Add("HUDPaint", "Screen Effect", function()
    if LocalPlayer():Alive() then
        if LocalPlayer():GetNWBool("UsingInvisibilityCloak") == true then
            CedCloakLerp = Lerp(5 * FrameTime(), CedCloakLerp, ScrH())
            surface.SetMaterial(Material("vgui/gradient_down"))
            surface.SetDrawColor(Color(50, 50, 100, 50))
            surface.DrawTexturedRect(0, 0, ScrW(), CedCloakLerp)
            
            DrawMotionBlur(0.4, 0.8, 0.01)
        else
            CedCloakLerp = Lerp(5 * FrameTime(), CedCloakLerp, 0)
            surface.SetMaterial(Material("vgui/gradient_down"))
            surface.SetDrawColor(Color(50, 50, 100, 50))
            surface.DrawTexturedRect(0, 0, ScrW(), CedCloakLerp)
        end
    end
end)