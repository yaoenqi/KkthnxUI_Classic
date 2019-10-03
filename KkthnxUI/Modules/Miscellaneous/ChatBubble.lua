local K, C = unpack(select(2, ...))
-- local Module = K:GetModule("Miscellaneous")

local function getBackdrop(scale)
	return {
		bgFile = C["Media"].Blank,
		edgeFile = C["Media"].Glow,
		edgeSize = 4 * scale,
		insets = {
			left = 4 * scale,
			right = 4 * scale,
			top = 4 * scale,
			bottom = 4 * scale
		}
	}
end

local bubblesFrameUpdate = CreateFrame("Frame")
bubblesFrameUpdate:RegisterEvent("PLAYER_ENTERING_WORLD")

local function styleBubble(frame)
	if frame:IsForbidden() then
		return
	end

	for i = 1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())
		if region:IsObjectType("Texture") then
			region:SetTexture(nil)
		end
	end

	--frame:CreateShadow(true)
	frame.Backdrop = CreateFrame("Frame", nil, frame)
	frame.Backdrop:SetFrameLevel(frame:GetFrameLevel()) -- this works?
	frame.Backdrop:SetPoint("TOPLEFT", 8, -8)
	frame.Backdrop:SetPoint("BOTTOMRIGHT", -8, 8)
	frame.Backdrop:SetScale(UIParent:GetScale())
	frame.Backdrop:SetBackdrop(getBackdrop(1))
	frame.Backdrop:SetBackdropColor(C["Media"].BackdropColor[1], C["Media"].BackdropColor[2], C["Media"].BackdropColor[3], C["Media"].BackdropColor[4])
	frame.Backdrop:SetBackdropBorderColor(0, 0, 0, 0.8)

	frame:SetClampedToScreen(false)
	frame:SetFrameStrata("BACKGROUND")
end

local function onUpdate(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed < 0.1 then
		return
	end

	self.elapsed = 0

	for _, frame in pairs(C_ChatBubbles.GetAllChatBubbles()) do
		if not frame.Backdrop then
			styleBubble(frame)
		end
	end
end

bubblesFrameUpdate:SetScript("OnEvent", function()
	local _, instanceType = IsInInstance()
	if instanceType == "party" or instanceType == "raid" then
		bubblesFrameUpdate:SetScript("OnUpdate", nil)
	else
		bubblesFrameUpdate:SetScript("OnUpdate", onUpdate)
	end
end)