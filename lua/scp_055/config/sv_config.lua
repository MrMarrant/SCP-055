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
SCP_055_CONFIG.RadiusEffect = CreateConVar( "SCP055_RadiusEffect", 150, {FCVAR_PROTECTED, FCVAR_ARCHIVE}, "Radius effect of the briefcase, set it to 0 to disable it", 0, 9999 )
SCP_055_CONFIG.CanUseOncePerLife = CreateConVar( "SCP055_CanUseOncePerLife", 1, {FCVAR_PROTECTED, FCVAR_ARCHIVE}, "If checked, a player can only use SCP-055 once per lifetime.", 0, 1 )

hook.Add( "PlayerDeath", "PlayerDeath.SCP055_Died", function( victim, inflictor, attacker )
    scp_055.SpawnRagdoll(victim, victim:GetModel(), victim.SCP055_NPCReplace and victim.SCP055_NPCReplace:GetPos() or victim.SCP055_OriginPos, victim:GetAngles(), true)
    scp_055.DropEntitie(victim, "swep_cardscp055", "card_scp055")
    scp_055.DropEntitie(victim, "swep_scp055", "scp_055")
    scp_055.RemoveTheDark(victim)
    victim.SCP055_01 = nil
    if (victim.SCP055_IsBot and scp_055.IsValid(victim.SCP055_Owner)) then
        if (victim.SCP055_Owner:Alive()) then
            victim.SCP055_Owner:Kill()
            if(IsValid( victim.SCP055_Owner:GetRagdollEntity())) then  victim.SCP055_Owner:GetRagdollEntity():Remove() end
            victim:Kick()
        end
    end
end)

-- Players affect can't hear others players and can't be heard by others.
hook.Add( "PlayerCanHearPlayersVoice", "PlayerCanHearPlayersVoice.SCP055_Effect", function( Listener, Talker )
    if Listener.SCP055_AffectBySCP005 or Talker.SCP055_AffectBySCP005 then return false end
end )

util.AddNetworkString(SCP_055_CONFIG.OpenPanelPassword)
util.AddNetworkString(SCP_055_CONFIG.OpenBriefcase)
util.AddNetworkString(SCP_055_CONFIG.UnCheckBriefcase)
util.AddNetworkString(SCP_055_CONFIG.SetToTheDark)
util.AddNetworkString(SCP_055_CONFIG.RemoveTheDark)
util.AddNetworkString(SCP_055_CONFIG.ItEvent)
util.AddNetworkString(SCP_055_CONFIG.ItSeeIt)
util.AddNetworkString(SCP_055_CONFIG.BlueScreen)
util.AddNetworkString(SCP_055_CONFIG.BlueScreens)
util.AddNetworkString(SCP_055_CONFIG.BlurEffect)
util.AddNetworkString(SCP_055_CONFIG.TalkEvent)
util.AddNetworkString(SCP_055_CONFIG.RemoveHook)
util.AddNetworkString(SCP_055_CONFIG.GameEvent)
util.AddNetworkString(SCP_055_CONFIG.EndGameEvent)
util.AddNetworkString(SCP_055_CONFIG.SoundToServer)
util.AddNetworkString(SCP_055_CONFIG.SetConvarInt)
util.AddNetworkString(SCP_055_CONFIG.SetConvarBool)
util.AddNetworkString(SCP_055_CONFIG.SetConvarClientSide)

-- Send to player the list of actual players who wear the mask client side.
hook.Add( "PlayerInitialSpawn", "PlayerInitialSpawn.SCP055_LoadPossessor", function(ply)
    scp_055.SetConvarClientSide("ClientNeedCard", SCP_055_CONFIG.NeedCard:GetBool(), ply)
    scp_055.SetConvarClientSide("ClientRadiusEffect", SCP_055_CONFIG.RadiusEffect:GetInt(), ply)
    scp_055.SetConvarClientSide("ClientCanUseOncePerLife", SCP_055_CONFIG.CanUseOncePerLife:GetBool(), ply)
end)