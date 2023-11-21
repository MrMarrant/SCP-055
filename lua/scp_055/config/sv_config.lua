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

-- Enable if it need to have the card for open SCP-055 briefcase
SCP_055_CONFIG.NeedCard = CreateConVar( "SCP055_NeedCard", 0, {FCVAR_PROTECTED, FCVAR_ARCHIVE}, "Enable if it need to have the security card for open SCP-055 briefcase", 0, 1 )
SCP_055_CONFIG.RadiusEffect = CreateConVar( "SCP055_RadiusEffect", 300, {FCVAR_PROTECTED, FCVAR_ARCHIVE}, "Radius effect of the briefcase, set it to 0 to disable it", 0, 9999 )

hook.Add( "PlayerDeath", "PlayerDeath.SCP055_Died", function( victim, inflictor, attacker )
    scp_055.DropEntitie(victim, "swep_cardscp055", "card_scp055")
    scp_055.DropEntitie(victim, "swep_scp055", "scp_055")
    scp_055.RemoveTheDark(victim)
    victim:GetRagdollEntity():Remove()
end)

util.AddNetworkString(SCP_055_CONFIG.OpenPanelPassword)
util.AddNetworkString(SCP_055_CONFIG.OpenBriefcase)
util.AddNetworkString(SCP_055_CONFIG.UnCheckBriefcase)
util.AddNetworkString(SCP_055_CONFIG.SetToTheDark)
util.AddNetworkString(SCP_055_CONFIG.RemoveTheDark)
util.AddNetworkString(SCP_055_CONFIG.SkullEvent)
util.AddNetworkString(SCP_055_CONFIG.ItSeeIt)
util.AddNetworkString(SCP_055_CONFIG.BlueScreen)