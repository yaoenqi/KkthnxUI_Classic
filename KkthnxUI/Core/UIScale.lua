local K, C = unpack(select(2,...))

local _G = _G

local math_max = _G.math.max
local math_min = _G.math.min
local string_format = _G.string.format

local UIParent = _G.UIParent

local function clipScale(scale)
	return tonumber(string_format('%.5f', scale))
end

local function GetPerfectScale()
	local scale = C["General"].UIScale
	local bestScale = math_max(.4, math_min(1.15, 768 / K.ScreenHeight))
	local pixelScale = 768 / K.ScreenHeight

	if C["General"].AutoScale then
		if K.is4KRes then
			scale = clipScale(bestScale * 1.5)
			--elseif K.is2KRes then
			--	scale = clipScale(bestScale * 1.2)
		else
			scale = clipScale(bestScale)
		end
	end

	K.Mult = (bestScale / scale) - ((bestScale - pixelScale) / scale)

	return scale
end
GetPerfectScale()

local isScaling = false
function K:SetupUIScale()
	if isScaling then return end
	isScaling = true

	local scale = GetPerfectScale()
	local parentScale = UIParent:GetScale()
	if scale ~= parentScale then
		UIParent:SetScale(scale)
	end

	C["General"].UIScale = clipScale(scale)

	isScaling = false
end