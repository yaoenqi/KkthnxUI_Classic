local K, C = unpack(select(2, ...))

local _G = _G
local string_format = _G.string.format
local math_max = _G.math.max
local math_min = _G.math.min

local GetPhysicalScreenSize = _G.GetPhysicalScreenSize

-- UI scale
local function clipScale(scale)
	return tonumber(string_format("%.5f", scale))
end

local function GetPerfectScale()
	local _, height = GetPhysicalScreenSize()
	local scale = C["General"].UIScale
	local bestScale = math_max(0.4, math_min(1.15, 768 / height))
	local pixelScale = 768 / height

    if C["General"].AutoScale then
        scale = clipScale(bestScale)
    end

	K.Mult = (bestScale / scale) - ((bestScale - pixelScale) / scale)

	return scale
end
GetPerfectScale()

local isScaling = false
function K:SetupUIScale()
    if isScaling then
        return
    end

	isScaling = true

	local scale = GetPerfectScale()
	local parentScale = UIParent:GetScale()
	if scale ~= parentScale then
		UIParent:SetScale(scale)
	end

	C["General"].UIScale = clipScale(scale)

	isScaling = false
end