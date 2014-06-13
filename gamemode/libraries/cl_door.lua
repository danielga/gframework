gframework.door = {}

function gframework.door:IsDoor(entity)
	return IsValid(entity) and string.find(entity:GetClass(), "door") or false
end

function gframework.door:GetOwner(door)
	return self:IsDoor(door) and door:GetNetworkedVar("DoorOwner") or nil
end

function gframework.door:HasOwner(door)
	return IsValid(self:GetOwner(door))
end

function gframework.door:GetTitle(door)
	return self:IsDoor(door) and door:GetNetworkedVar("DoorTitle") or nil
end

function gframework.door:HasTitle(door)
	return self:GetTitle(door) ~= nil
end

function gframework.door:SetOwner(door, owner)
	if self:IsDoor(door) then
		door:SetNetworkedVar("DoorOwner", owner)
	end
end

function gframework.door:SetTitle(door, title)
	if self:IsDoor(door) then
		door:SetNetworkedVar("DoorTitle", title)
	end
end