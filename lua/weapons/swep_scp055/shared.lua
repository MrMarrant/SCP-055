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
SWEP.ViewModel = Model( "models/weapons/v_scp055/v_scp055.mdl" )
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
SWEP.AutoSwitch = true
SWEP.Automatic = false

-- Variables Personnal to this weapon --
-- [[ STATS WEAPON ]]
SWEP.PrimaryCooldown = 1.5

-- Animation SWEP CONST --
local check = "check"
local open = "open"
local idle = "idle"

function SWEP:Initialize()
	self:InitVar()
	self:SetWeaponHoldType( self.HoldType )
	self:SetHoldType( self.HoldType )
	self:SetPlaybackRate( GetConVarNumber( "sv_defaultdeployspeed" ) )
	self:GetOwner().SCP055_IsOpenBC = self:GetIsOpen()
end

function SWEP:Deploy()
	local ply = self:GetOwner()

	self:SendWeaponAnim( ACT_VM_IDLE )

	if (ply:IsPlayer()) then
		local VMAnim = ply:GetViewModel()
		local NexIdle = VMAnim:SequenceDuration() / VMAnim:GetPlaybackRate() 
		self:SetNextPrimaryFire( CurTime() + NexIdle + 0.1 ) --? We add 0.1s for avoid to cancel primary animation
		self:SetNextSecondaryFire( CurTime() + NexIdle )
	end

	return true
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + self.PrimaryCooldown )
	if CLIENT then return end

	local ply = self:GetOwner()
	local VMAnim = ply:GetViewModel()
	local StateOpen = self:GetIsOpen()
	local StateCheck = self:GetIsCheck()

	if (StateCheck) then
		scp_055.UnCheckBriefcase(ply, self)
	else
		if (not scp_055.HasSecurityCard(ply)) then
			ply:EmitSound(Sound("scp_055/error.mp3"))
		else
			scp_055.SetViewModel(VMAnim, check)
			local NexIdle = VMAnim:SequenceDuration() / VMAnim:GetPlaybackRate()
		
			timer.Simple(NexIdle, function()
				if(not self:IsValid() or not ply:IsValid()) then return end

				if (StateOpen) then
					if (scp_055.IsValid(ply) or ply.SCP055_01) then -- If it is affect by 055 or was affect by it
						scp_055.UnCheckBriefcase(ply, self)
						return 
					end
					scp_055.SetViewModel(VMAnim, open)
					local NexIdle = VMAnim:SequenceDuration() / VMAnim:GetPlaybackRate()
		
					timer.Simple(NexIdle - 1, function()
						scp_055.SetViewModel(VMAnim, idle)
						scp_055.StartSCP055Effect(ply)
					end)
				else
					self:SetIsCheck(true)
					scp_055.OpenPanelPassword(ply)
				end
			end)
		end
	end
end

function SWEP:SecondaryAttack()
	if CLIENT then return end

	self:SetNextSecondaryFire( CurTime() + self.PrimaryCooldown )
	local ent = scp_055.Drop(self:GetOwner(), "scp_055")
	if (IsValid(ent)) then
		ent:SetIsOpen(self:GetIsOpen())
		self:GetOwner().SCP055_IsOpenBC = nil
		self:Remove()
	end
end

-- Close the entitie
function SWEP:Reload()
	if CLIENT then return end

	local ply = self:GetOwner()
	if (self:GetIsOpen() and scp_055.HasSecurityCard(ply)) then
		self:SetIsOpen(false)
		ply.SCP055_IsOpenBC = false
		ply:EmitSound(Sound("scp_055/close_briefcase.mp3"))
	end
end

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", 0, "IsOpen")
    self:NetworkVar("Bool", 1, "IsCheck")
end

-- Intialise every var related to the entity
function SWEP:InitVar( )
	self:SetIsOpen(false)
	self:SetIsCheck(false)
end