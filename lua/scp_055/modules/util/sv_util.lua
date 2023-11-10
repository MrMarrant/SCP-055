function scp_055.Drop(ply, name)
	if (!IsValid(ply)) then return end

	local LookForward = ply:EyeAngles():Forward()
	local LookUp = ply:EyeAngles():Up()
	local ent = ents.Create( name )
	local DistanceToPos = 50
	local PosObject = ply:GetShootPos() + LookForward * DistanceToPos + LookUp
    PosObject.z = ply:GetPos().z

	ent:SetPos( PosObject )
	ent:SetAngles( ply:EyeAngles() )
	ent:Spawn()
	ent:Activate()

	return ent
end

-- Return true if the player has the security card or if is not needed
function scp_055.HasSecurityCard(ply)
	return (ply:HasWeapon("swep_cardscp055") or (not SCP_055_CONFIG.NeedCard and not ply:HasWeapon("swep_cardscp055")))
end