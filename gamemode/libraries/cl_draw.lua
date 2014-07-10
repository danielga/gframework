gframework.draw = gframework.draw or {}

function gframework.draw:CreateCircle(centerx, centery, radius, detail, texture, color)
	detail = detail and math.Clamp(detail, 25, 250) or 50
	local data = {polygon = {}, color = color or Color(255, 255, 255, 255), texture = texture, type = CIRCLE}
	local smallest_angle = (2 * math.pi) / detail

	for i = 1, detail do
		local common_angle = smallest_angle * i
		local cos = math.cos(common_angle)
		local sin = math.sin(common_angle)
		data.polygon[i] = {x = centerx + cos * radius, y = centerx + sin * radius, u = (cos + 1) / 2, v = (sin + 1) / 2}
	end

	return data
end

function gframework.draw:CreateCircumference(centerx, centery, radius, detail, thickness, texture, color)
	detail = detail and math.Clamp(detail, 25, 250) or 50
	local data = {polygon = {}, color = color or Color(255, 255, 255, 255), texture = texture, detail = detail, type = CIRCUMFERENCE}
	thickness = thickness or 1
	local smallest_angle = (2 * math.pi) / detail

	for i = 1, detail do
		data.polygon[i] = {}

		local common_angle = smallest_angle * i

		local cos = math.cos(common_angle)
		local sin = math.sin(common_angle)
		data.polygon[i][1] = {x = centerx + cos * (radius + thickness), y = centery + sin * (radius + thickness), u = (cos + 1) / 2, v = (sin + 1) / 2}
		data.polygon[i][2] = {x = centerx + cos * radius, y = centery + sin * radius, u = (cos + 1) / 2, v = (sin + 1) / 2}

		cos = math.cos(common_angle + smallest_angle)
		sin = math.sin(common_angle + smallest_angle)
		data.polygon[i][3] = {x = centerx + cos * radius, y = centery + sin * radius, u = (cos + 1) / 2, v = (sin + 1) / 2}
		data.polygon[i][4] = {x = centerx + cos * (radius + thickness), y = centery + sin * (radius + thickness), u = (cos + 1) / 2, v = (sin + 1) / 2}
	end

	return data
end