local TTT = gmod.GetGamemode().Name == "Trouble in Terrorist Town"

hook.Add("PlayerSpawn", "OldColor", function(ply)
    ply:SetColor(ply.OldColor)
    ply:SetMaterial("")
    ply.OldMaterial = ply:GetMaterial()
end)

hook.Add("PlayerDeath", "On player death", function(ply, wep, k)
    if ply:GetNWBool("UsingInvisibilityCloak") == true then
        ply:SetNWBool("UsingInvisibilityCloak", false)
    end
end)

hook.Add("EntityTakeDamage", "Damage type while cloaked", function(t, dmg)
    if t:GetNWBool("UsingInvisibilityCloak") == true then
        dmg:SetDamageType(DMG_DISSOLVE)
    end
end)

hook.Add("PlayerSwitchWeapon", "Un-cloak on weapon switch", function(ply, old, new)
    if IsValid(old) and IsValid(ply) and old:GetClass() == "invisibility_cloak" and ply:GetNWBool("UsingInvisibilityCloak") == true then
        ply:SetNWBool("UsingInvisibilityCloak", false)
        ply:GetActiveWeapon():EmitSound("ced/cloak/ced_cloak_disabled.mp3")
        ply:SetNoTarget(false)
        ply:SetMaterial("")

        ply:SetColor(ply.OldColor)
    end
end)

hook.Add("Think", "Disable cloak if the player doesn't have the SWEP", function()
    for i, v in pairs(player.GetAll()) do
        if not IsValid(v:GetActiveWeapon()) or v:GetActiveWeapon():GetClass() != "invisibility_cloak" then
            v:SetNWBool("UsingInvisibilityCloak", false)
        end

        if v:GetNWBool("UsingInvisibilityCloak") == false then
            v:SetMaterial(v.OldMaterial)
            v:SetNoTarget(false)
        end
    end
end)

if TTT then
    hook.Add("TTTPrepareRound", "Un-cloak in preperation",function()
        for k, v in pairs(player.GetAll()) do
            v:SetNWBool("UsingInvisibilityCloak", false)
        end
    end)
end