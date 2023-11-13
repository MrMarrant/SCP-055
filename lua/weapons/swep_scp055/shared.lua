-- SCP-055, A representation of a paranormal object on a fictional series on the game Garry's Mod.
-- Copyright (C) 2023  MrMarrant aka BIBI.

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

AddCSLuaFile()
AddCSLuaFile( "cl_init.lua" )

SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.Category = "SCP"
SWEP.ViewModel = Model( "" ) -- TODO : Model
SWEP.WorldModel = Model( "models/weapons/w_scp055/w_scp055.mdl" )

SWEP.ViewModelFOV = 65
SWEP.HoldType = "normal"
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.DrawAmmo = false

-- Variables Personnal to this weapon --
-- [[ STATS WEAPON ]]
SWEP.PrimaryCooldown = 3.5

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	self:SetHoldType( self.HoldType )
end

function SWEP:Deploy()
	local ply = self:GetOwner()
	local speedAnimation = GetConVarNumber( "sv_defaultdeployspeed" )

	self:SendWeaponAnim( ACT_VM_IDLE )
	self:SetPlaybackRate( speedAnimation )

	local VMAnim = ply:GetViewModel()
	local NexIdle = VMAnim:SequenceDuration() / VMAnim:GetPlaybackRate() 

	self:SetNextPrimaryFire( CurTime() + NexIdle + 0.1 ) --? We add 0.1s for avoid to cancel primary animation
	self:SetNextSecondaryFire( CurTime() + NexIdle )

	return true
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + self.PrimaryCooldown )
	if CLIENT then return end

	local ply = self:GetOwner()

	if (not self.IsOpen and scp_055.HasSecurityCard(ply)) then
		-- TODO : Afficher la demande du mot de passe
	elseif (self.IsOpen) then
		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		local VMAnim = ply:GetViewModel()
		local NexIdle = VMAnim:SequenceDuration() / VMAnim:GetPlaybackRate()
	
		timer.Simple(NexIdle, function()
			if(!self:IsValid() or !ply:IsValid()) then return end
	
			-- TODO : Primary Function
			-- TODO : jouer un son / animation
		end)
	else
		-- TODO : jouer un son d'erreur
	end
end

function SWEP:SecondaryAttack()
	if CLIENT then return end

	self:SetNextSecondaryFire( CurTime() + self.PrimaryCooldown )
	local ent = scp_055.Drop(self:GetOwner(), "scp_055")
	if (IsValid(ent)) then
		ent:SetIsOpen(self.IsOpen)
		self:Remove()
	end
end

-- Close the entitie
function SWEP:Reload()
	local ply = self:GetOwner()
	if (self.IsOpen and scp_055.HasSecurityCard(ply)) then
		self.ISOpen = false
		-- TODO : jouer un son / animation
	end
end