local K, C = unpack(select(2, ...))
local Module = K:GetModule("Unitframes")

if C["Unitframe"].Enable ~= true then
	return
end

local _G = _G

local ClassPowerTexture = K.GetTexture(C["UITextures"].UnitframeTextures)
local ComboColor = K.Colors.power["COMBO_POINTS"]
local CreateFrame = _G.CreateFrame

-- Post Update ClassPower
local function PostUpdateClassPower(element, _, max, diff)
	-- Update Layout On Change In Total Visible
	if (diff) then
		local maxWidth = 156
		local gap = 6

		for index = 1, max do
			local Bar = element[index]
			Bar:SetWidth(((maxWidth / max) - (((max - 1) * gap) / max)))

			if (index > 1) then
				Bar:ClearAllPoints()
				Bar:SetPoint("LEFT", element[index - 1], "RIGHT", gap, 0)
			end
		end
	end
	-- Update Color If This Is Combo Points
	if (max) then
		if (K.Class == "ROGUE" or K.Class == "DRUID") then
			local numColors = #ComboColor
			for index = 1, max do
				local Bar = element[index]
				local colorIndex
				if (max > numColors) then
					local exactIndex = index/max * numColors
					colorIndex = math.ceil(exactIndex)
				else
					colorIndex = index
				end
				Bar:SetStatusBarColor(ComboColor[colorIndex][1], ComboColor[colorIndex][2], ComboColor[colorIndex][3], ComboColor[colorIndex][4])
			end
		end
	end
end

-- Post Update Nameplate Classpower
local function PostUpdateNameplateClassPower(element, _, max, diff)
	-- Update Layout On Change In Total Visible
	if (diff) then
		local maxWidth = C["Nameplates"].Width
		local gap = 4

		for index = 1, max do
			local Bar = element[index]
			Bar:SetWidth(((maxWidth / max) - (((max - 1) * gap) / max)))

			if (index > 1) then
				Bar:ClearAllPoints()
				Bar:SetPoint("LEFT", element[index - 1], "RIGHT", gap, 0)
			end
		end
	end
	-- Update Color If This Is Combo Points
	if (max) then
		if (K.Class == "ROGUE" or K.Class == "DRUID") then
			local numColors = #ComboColor
			for index = 1, max do
				local Bar = element[index]
				local colorIndex
				if (max > numColors) then
					local exactIndex = index/max * numColors
					colorIndex = math.ceil(exactIndex)
				else
					colorIndex = index
				end
				Bar:SetStatusBarColor(ComboColor[colorIndex][1], ComboColor[colorIndex][2], ComboColor[colorIndex][3], ComboColor[colorIndex][4])
			end
		end
	end
end

-- Post Update Classpower Texture
local function UpdateClassPowerColor(element)
	local r, g, b = 195/255, 202/255, 217/255

	for index = 1, #element do
		local Bar = element[index]
		Bar:SetStatusBarColor(r, g, b)
	end
end

-- Create Class Power Bars (Combo Points...)
function Module:CreateClassPower()
	local ClassPower = {}
	ClassPower.UpdateColor = UpdateClassPowerColor
	ClassPower.PostUpdate = PostUpdateClassPower

	for index = 1, 11 do
		local Bar = CreateFrame("StatusBar", "oUF_KkthnxClassPower", self)
		Bar:SetSize(156, 14)
		Bar:SetStatusBarTexture(ClassPowerTexture)
		Bar:CreateBorder()

		if (index > 1) then
			Bar:SetPoint("LEFT", ClassPower[index - 1], "RIGHT", 6, 0)
		else
			Bar:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -6)
		end

		if (index > 5) then
			Bar:SetFrameLevel(Bar:GetFrameLevel() + 1)
		end

		ClassPower[index] = Bar
	end

	self.ClassPower = ClassPower
end

-- Create Class Power Bars For Nameplates (Combo Points...)
function Module:CreateNamePlateClassPower()
	local ClassPower = CreateFrame("Frame", nil, self)
	ClassPower:SetSize(C["Nameplates"].Width, C["Nameplates"].Height - 2)
	ClassPower.UpdateColor = UpdateClassPowerColor
	ClassPower.PostUpdate = PostUpdateNameplateClassPower

	for index = 1, 11 do
		local Bar = CreateFrame("StatusBar", nil, ClassPower)
		Bar:SetSize(C["Nameplates"].Width, 10)
		Bar:SetStatusBarTexture(ClassPowerTexture)
		Bar:CreateShadow(true)

		if (index > 1) then
			Bar:SetPoint("LEFT", ClassPower[index - 1], "RIGHT", 6, 0)
		else
			Bar:SetPoint("TOPLEFT", ClassPower, "BOTTOMLEFT", 0, 0)
		end

		if (index > 5) then
			Bar:SetFrameLevel(Bar:GetFrameLevel() + 1)
		end

		ClassPower[index] = Bar
	end

	self.ClassPower = ClassPower
end