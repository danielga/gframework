gframework.draw = {}

local Tex_Corner8 = surface.GetTextureID("gui/corner8")
local Tex_Corner16 = surface.GetTextureID("gui/corner16")

function gframework.draw:DrawRect(x, y, width, height, color)
	surface.SetDrawColor(color or Color(255, 255, 255, 255))
	surface.DrawRect(x, y, width, height)
end

function gframework.draw:DrawLine(startx, starty, endx, endy, color)
	surface.SetDrawColor(color or Color(255, 255, 255, 255))
	surface.DrawLine(startx, starty, endx, endy)
end

function gframework.draw:DrawOutlinedRect(x, y, width, height, color)
	surface.SetDrawColor(color or Color(255, 255, 255, 255))
	surface.DrawOutlinedRect(x, y, width, height)
end

function gframework.draw:DrawPoly(tab, texture, color)
	surface.SetTexture(texture)
	surface.SetDrawColor(color or Color(255, 255, 255, 255))
	surface.DrawPoly(tab)
end

function gframework.draw:DrawTexturedRectRotated(x, y, width, height, rotation, texture, color)
	surface.SetTexture(texture)
	surface.SetDrawColor(color or Color(255, 255, 255, 255))
	surface.DrawTexturedRectRotated(x, y, width, height, rotation)
end

function gframework.draw:DrawTexturedRectUV(x, y, width, height, texwidth, texheight, texture, color)
	surface.SetTexture(texture)
	surface.SetDrawColor(color or Color(255, 255, 255, 255))
	surface.DrawTexturedRectUV(x, y, width, height, texwidth, texheight)
end

function gframework.draw:DrawTexturedRect(x, y, width, height, texture, color)
	surface.SetTexture(texture)
	surface.SetDrawColor(color or Color(255, 255, 255, 255))
	surface.DrawTexturedRect(x, y, width, height)
end

function gframework.draw:DrawDottedCircle(x, y, radius, color)
	surface.DrawCircle(x, y, radius, color or Color(255, 255, 255, 255))
end

local function emptyTable(tab)
	for k, v in pairs(tab) do
		tab[k] = nil
	end
end

local CIRCLE = 1
local CIRCUMFERENCE = 2

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

function gframework.draw:DrawCircle(data)
	if data.type ~= CIRCLE then
		return
	end

	surface.SetTexture(data.texture)
	surface.SetDrawColor(data.color)
	surface.DrawPoly(data.polygon)
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

function gframework.draw:DrawCircumference(data)
	if data.type ~= CIRCUMFERENCE then
		return
	end

	for i = 1, data.detail do
		surface.SetTexture(data.texture)
		surface.SetDrawColor(data.color)
		surface.DrawPoly(data.polygon[i])
	end
end

function gframework.draw:RoundedBoxEx(bordersize, x, y, w, h, color, a, b, c, d)
	x = math.Round(x)
	y = math.Round(y)
	w = math.Round(w)
	h = math.Round(h)

	surface.SetDrawColor(color)
	
	surface.DrawRect(x + bordersize, y, w - bordersize * 2, h)
	surface.DrawRect(x, y + bordersize, bordersize, h - bordersize * 2)
	surface.DrawRect(x + w - bordersize, y + bordersize, bordersize, h - bordersize * 2)
	
	local tex = Tex_Corner8
	if bordersize > 8 then
		tex = Tex_Corner16
	end
	
	surface.SetTexture(tex)
	
	if a then
		surface.DrawTexturedRectRotated(x + bordersize / 2 , y + bordersize / 2, bordersize, bordersize, 0) 
	else
		surface.DrawRect(x, y, bordersize, bordersize)
	end
	
	if b then
		surface.DrawTexturedRectRotated(x + w - bordersize / 2 , y + bordersize / 2, bordersize, bordersize, 270) 
	else
		surface.DrawRect(x + w - bordersize, y, bordersize, bordersize)
	end
 
	if c then
		surface.DrawTexturedRectRotated(x + bordersize / 2 , y + h - bordersize / 2, bordersize, bordersize, 90)
	else
		surface.DrawRect(x, y + h - bordersize, bordersize, bordersize)
	end
 
	if d then
		surface.DrawTexturedRectRotated(x + w - bordersize / 2 , y + h - bordersize / 2, bordersize, bordersize, 180)
	else
		surface.DrawRect(x + w - bordersize, y + h - bordersize, bordersize, bordersize)
	end
end

function gframework.draw:RoundedBox(bordersize, x, y, w, h, color)
	return self:RoundedBoxEx(bordersize, x, y, w, h, color, true, true, true, true)
end

function gframework.draw:SetNoTexture()
	surface.SetTexture()
end

function gframework.draw:DrawText(text, font, x, y, color, xalign, yalign)
	font = font or "Default"
	x = x or 0
	y = y or 0
	color = color or Color(255, 255, 255, 255)
	xalign = xalign or TEXT_ALIGN_LEFT
	yalign = yalign or TEXT_ALIGN_TOP

	surface.SetFont(font)
	local w, h = surface.GetTextSize(text)
	
	if xalign == TEXT_ALIGN_CENTER then
		x = x - w / 2
	elseif xalign == TEXT_ALIGN_RIGHT then
		x = x - w
	end

	if yalign == TEXT_ALIGN_CENTER then
		y = y - h / 2
	elseif yalign == TEXT_ALIGN_BOTTOM then
		y = y - h
	end
	
	surface.SetTextPos(math.ceil(x), math.ceil(y))
	surface.SetTextColor(color)
	surface.DrawText(text)
	return w, h
end

function gframework.draw:TextShadow(text, font, x, y, color, distance, xalign, yalign)
	self:DrawText(text, font, x + distance, y + distance, Color(0, 0, 0, color.a), xalign, yalign)
	return self:DrawText(text, font, x, y, color, xalign, yalign)
end

function gframework.draw:WordBox(bordersize, x, y, text, font, color, fontcolor)
	surface.SetFont(font)
	local w, h = surface.GetTextSize(text)
	
	self:RoundedBox(bordersize, x, y, w + bordersize * 2, h + bordersize * 2, color)
	
	surface.SetTextColor(fontcolor)
	surface.SetTextPos(x + bordersize, y + bordersize)
	surface.DrawText(text)
	
	return w + bordersize * 2, h + bordersize * 2
end

function gframework.draw:DrawTextSpecial(text, font, x, y, color, xalign)
	font = font or "Default"
	x = x or 0
	y = y or 0
	
	local curX = x
	local curY = y
	local curString = ""
	
	surface.SetFont(font)
	local sizeX, lineHeight = surface.GetTextSize("\n")
	
	for i = 1, string.len(text) do
		local ch = string.sub(text, i, i)
		if ch == "\n" then
			if string.len(curString) > 0 then
				self:DrawText(curString, font, curX, curY, color, xalign)
			end
			
			curY = curY + (lineHeight / 2)
			curX = x
			curString = ""
		elseif ch == "\t" then
			if string.len(curString) > 0 then
				self:DrawText(curString, font, curX, curY, color, xalign)
			end

			local tmpSizeX,tmpSizeY =  surface.GetTextSize(curString)
			curX = math.ceil((curX + tmpSizeX) / 50) * 50
			curString = ""
		else
			curString = curString .. ch
		end
	end	
	if string.len(curString) > 0 then
		self:DrawText(curString, font, curX, curY, color, xalign)
	end
end

function gframework.draw:DrawTextOutlined(text, font, x, y, color, outlinewidth, outlinecolor, xalign, yalign)
	local steps = (outlinewidth * 2) / 3
	if steps < 1 then
		steps = 1
	end
	
	for _x = -outlinewidth, outlinewidth, steps do
		for _y = -outlinewidth, outlinewidth, steps do
			self:DrawText(text, font, x + _x, y + _y, outlinecolor, xalign, yalign)
		end
	end
	
	self:DrawText(text, font, x, y, color, xalign, yalign)
end

function gframework.draw:ScreenHeight()
	return surface.ScreenHeight()
end

function gframework.draw:ScreenWidth()
	return surface.ScreenWidth()
end

function gframework.draw:GetTextSize(text, font, x, y, color)
	surface.SetTextPos(x, y)
	surface.SetFont(font)
	surface.SetTextColor(color or Color(255, 255, 255, 255))
	return surface.GetTextSize(text)
end

function gframework.draw:GetTextureID(texture)
	return surface.GetTextureID(texture)
end

function gframework.draw:GetHUDTexture(texture)
	return surface.GetHUDTexture(texture)
end

function gframework.draw:GetTextureSize(texture)
	return surface.GetTextureSize(texture)
end

function gframework.draw:PlaySound(filepath)
	return surface.PlaySound(filepath)
end