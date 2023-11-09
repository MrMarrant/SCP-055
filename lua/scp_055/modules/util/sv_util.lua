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