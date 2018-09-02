--[[--------------------------------------------------------------------------------------------------------------
 _____            _  _       _____              _       _  _      _  _  _            _____  _                _    
/  __ \          | |( )     |_   _|            (_)     (_)| |    (_)| || |          /  __ \| |              | |   
| /  \/  ___   __| ||/ ___    | |  _ __ __   __ _  ___  _ | |__   _ | || |_  _   _  | /  \/| |  ___    __ _ | | __
| |     / _ \ / _` |  / __|   | | | '_ \\ \ / /| |/ __|| || '_ \ | || || __|| | | | | |    | | / _ \  / _` || |/ /
| \__/\|  __/| (_| |  \__ \  _| |_| | | |\ V / | |\__ \| || |_) || || || |_ | |_| | | \__/\| || (_) || (_| ||   < 
 \____/ \___| \__,_|  |___/  \___/|_| |_| \_/  |_||___/|_||_.__/ |_||_| \__| \__, |  \____/|_| \___/  \__,_||_|\_\
                                                                              __/ |                               
                                                                             |___/                           
--------------------------------------------------------------------------------------------------------------]]--

local TTT = gmod.GetGamemode().Name == "Trouble in Terrorist Town"

SWEP.PrintName		    = "Invisibilty Cloak"
SWEP.Author		    = "Ced"
SWEP.Instructions	    = "Use this to go invisible!"

if TTT then
    SWEP.Base               = "weapon_tttbase"

    SWEP.Icon               = "VGUI/ttt/weapon_ttt_invisibility_cloak"
    SWEP.Kind               = WEAPON_EQUIP1
    SWEP.CanBuy             = {ROLE_TRAITOR, ROLE_DETECTIVE}

    SWEP.LimitedStock       = true

    SWEP.EquipMenuData = {
        type                = "Weapon",
        desc                = "Use this to go invisible!"
    }

    SWEP.AllowDrop          = false

    SWEP.NoSights           = true

    function SWEP:PreDrop()
        self.WorldModel	    = "models/Items/combine_rifle_cartridge01.mdl"
    end
end

SWEP.Spawnable              = true
SWEP.AdminOnly              = true

SWEP.Slot		    = 1
SWEP.SlotPos		    = 2
SWEP.DrawAmmo		    = false
SWEP.DrawCrosshair	    = false

SWEP.Primary.ClipSize	    = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic	    = false
SWEP.Primary.Ammo	    = "none"

SWEP.Secondary.ClipSize	    = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo	    = "none"

SWEP.ViewModel		    = ""
SWEP.WorldModel             = ""

if CLIENT then
    SWEP.WepSelectIcon      = surface.GetTextureID("VGUI/entities/weapon_invisibility_cloak")
end

function SWEP:Initialize()
    self:SetHoldType("normal")

    --self.Charge = 100
end

function SWEP:PrimaryAttack()
    if self.Owner:GetNWBool("UsingInvisibilityCloak") == false then
        self.Owner:SetNWBool("UsingInvisibilityCloak", true)
        self:EmitSound("ced/cloak/ced_cloak_enabled.mp3")

        self.Owner.OldColor = self.Owner:GetColor()
    else
        self.Owner:SetNWBool("UsingInvisibilityCloak", false)
        self:EmitSound("ced/cloak/ced_cloak_disabled.mp3")
    end

    self:SetNextPrimaryFire(CurTime() + 1.25)
    self:SetNextSecondaryFire(CurTime() + 1.25)
end


function SWEP:SecondaryAttack()
	if self.Owner:GetNWBool("UsingInvisibilityCloak") == false then
        self.Owner:SetNWBool("UsingInvisibilityCloak", true)
        self:EmitSound("ced/cloak/ced_cloak_enabled.mp3")

        self.Owner.OldColor = self.Owner:GetColor()
    else
        self.Owner:SetNWBool("UsingInvisibilityCloak", false)
        self:EmitSound("ced/cloak/ced_cloak_disabled.mp3")
    end

    self:SetNextPrimaryFire(CurTime() + 1.25)
    self:SetNextSecondaryFire(CurTime() + 1.25)
end

function SWEP:Think()
    if self.Owner:Alive() then
        if self.Owner.OldMaterial == nil then
            self.Owner.OldMaterial = self.Owner:GetMaterial()
        end

        if self.Owner.AlphaLerp == nil then
            self.Owner.AlphaLerp = 255
        end

        if self.Owner:GetNWBool("UsingInvisibilityCloak") == true and self.Owner:GetVelocity():Length() <= 65 then
            self.Owner:SetRenderMode(RENDERMODE_TRANSALPHA)

            self.Owner.AlphaLerp = Lerp(10 * FrameTime(), self.Owner.AlphaLerp, 0)
            self.Owner:SetColor(Color(255, 255, 255, self.Owner.AlphaLerp))

            if SERVER then
                self.Owner:SetNoTarget(true)
            end
        else if self.Owner:GetNWBool("UsingInvisibilityCloak") == true and self.Owner:GetVelocity():Length() > 65 then
                self.Owner:SetMaterial("models/shadertest/shader3")

                self.Owner.AlphaLerp = Lerp(0.5 * FrameTime(), self.Owner.AlphaLerp, 50)
                self.Owner:SetColor(Color(255, 255, 255, self.Owner.AlphaLerp))
            else
                if SERVER then
                    self.Owner:SetNoTarget(false)
                end

                self.Owner:SetMaterial(self.Owner.OldMaterial)
                self.Owner:SetRenderMode(RENDERMODE_TRANSALPHA)

                self.Owner.AlphaLerp = Lerp(5 * FrameTime(), self.Owner.AlphaLerp, 350)
                self.Owner:SetColor(Color(255, 255, 255, self.Owner.AlphaLerp))
            end
        end
    end
end
