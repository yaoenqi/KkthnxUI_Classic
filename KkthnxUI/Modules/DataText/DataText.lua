local K, C, L = unpack(select(2, ...))
local module = K:NewModule("Infobar")

function module:RegisterInfobar(name, point)
	if not self.modules then self.modules = {} end

	local info = CreateFrame("Frame", name, UIParent)
	--info:SetHitRectInsets(0, 0, -10, -10)
	info.text = info:CreateFontString(nil, "OVERLAY")
	info.text:SetFontObject(K.GetFont(C["UIFonts"].DataTextFonts))
	info.text:SetFont(select(1, info.text:GetFont()), 13, select(3, info.text:GetFont()))
	info.text:SetPoint(unpack(point))

	info.text.glow = info:CreateTexture(nil, "BACKGROUND", nil, -1)
	info.text.glow:SetHeight(12)
	info.text.glow:SetPoint("TOPLEFT", info.text, "TOPLEFT", -6, 6)
	info.text.glow:SetPoint("BOTTOMRIGHT", info.text, "BOTTOMRIGHT", 6, -6)
	info.text.glow:SetTexture("Interface\\AddOns\\KkthnxUI\\Media\\Textures\\Shader")
	info.text.glow:SetVertexColor(0, 0, 0, 0.5)

	info:SetAllPoints(info.text)


	info.name = name
	tinsert(self.modules, info)

	return info
end

function module:LoadInfobar(info)
	if info.eventList then
		for _, event in pairs(info.eventList) do
			info:RegisterEvent(event)
		end
		info:SetScript("OnEvent", info.onEvent)
	end
	if info.onEnter then
		info:SetScript("OnEnter", info.onEnter)
	end
	if info.onLeave then
		info:SetScript("OnLeave", info.onLeave)
	end
	if info.onMouseUp then
		info:SetScript("OnMouseUp", info.onMouseUp)
	end
	if info.onUpdate then
		info:SetScript("OnUpdate", info.onUpdate)
	end
end

function module:OnEnable()
	if not self.modules then return end
	for _, info in pairs(self.modules) do
		self:LoadInfobar(info)
	end

	self.loginTime = GetTime()
end