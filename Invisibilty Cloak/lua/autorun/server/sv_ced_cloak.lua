local TTT = gmod.GetGamemode().Name == "Trouble in Terrorist Town"

hook.Add("PlayerSpawn", "Player Variables", function(ply)
    ply:SetColor(ply.InviCloakOldColor)
    ply:SetMaterial("")
    ply.InviCloakOldMaterial = ply:GetMaterial()
end)

hook.Add("PlayerDeath", "Disable cloak on player death", function(ply, wep, k)
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
    if IsValid(old) and old:GetClass() == "invisibility_cloak" and ply:GetNWBool("UsingInvisibilityCloak") == true then
        ply:EmitSound("ced/cloak/ced_cloak_disabled.mp3")
        ply:SetNWBool("UsingInvisibilityCloak", false)
        ply:SetNoTarget(false)
        ply:SetMaterial("")

        ply:SetColor(Color(255, 255, 255, 255))
    end
end)

hook.Add("Think", "Disable cloak if the player doesn't have the SWEP", function()
    for i, v in pairs(player.GetAll()) do
        if not v:HasWeapon("invisibility_cloak") then
            v:SetNWBool("UsingInvisibilityCloak", false)
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
