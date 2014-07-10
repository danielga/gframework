function GM:PhysgunPickup(client, entity)
	if client:IsAdmin() and entity:IsPlayer() then
		entity:SetMoveType(MOVETYPE_NOCLIP)
		return true
	end

	if entity.PhysgunDisable then
		return entity.PhysgunAllowAdmin and client:IsAdmin()
	end

	return client:IsAdmin() or (not entity:IsPlayer() and not entity:IsNPC())
end

function GM:PhysgunDrop(client, entity)
	if entity:IsPlayer() then
		entity:SetMoveType(MOVETYPE_WALK)
	end
end

function GM:PlayerNoClip(client)
	return client:IsAdmin()
end