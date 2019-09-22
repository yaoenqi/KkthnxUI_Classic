local K, C, L = unpack(select(2, ...))
if C["Minimap"].Enable ~= true then
	return
end

local _G = _G

local CreateFrame = _G.CreateFrame
local EasyMenu = _G.EasyMenu
local HideUIPanel = _G.HideUIPanel
local IsInGuild = _G.IsInGuild
local PlaySound = _G.PlaySound
local ShowUIPanel = _G.ShowUIPanel

-- Create the minimap micro menu
local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", UIParent)
local menuList = {
	{text = _G.CHARACTER_BUTTON,
	func = function() ToggleCharacter("PaperDollFrame") end},
	{text = _G.SPELLBOOK_ABILITIES_BUTTON,
	func = function()
		if not _G.SpellBookFrame:IsShown() then
			ShowUIPanel(_G.SpellBookFrame)
		else
			HideUIPanel(_G.SpellBookFrame)
		end
	end},
	{text = _G.TALENTS_BUTTON,
	func = function()
		if not _G.TalentFrame then
			_G.TalentFrame_LoadUI()
		end

		if not TalentFrame:IsShown() then
			ShowUIPanel(TalentFrame)
		else
			HideUIPanel(TalentFrame)
		end
	end},
	{text = _G.CHAT_CHANNELS,
	func = _G.ToggleChannelFrame},
	{text = _G.TIMEMANAGER_TITLE,
	func = function() ToggleFrame(_G.TimeManagerFrame) end},
	{text = _G.SOCIAL_LABEL,
	func = ToggleFriendsFrame},
	{text = _G.GUILD,
	func = function()
		if IsInGuild() then
			ToggleFriendsFrame(3)
		else
			ToggleGuildFrame()
		end
	end},
	{text = _G.MAINMENU_BUTTON,
	func = function()
		if not _G.GameMenuFrame:IsShown() then
			if _G.VideoOptionsFrame:IsShown() then
				_G.VideoOptionsFrameCancel:Click();
			elseif _G.AudioOptionsFrame:IsShown() then
				_G.AudioOptionsFrameCancel:Click();
			elseif _G.InterfaceOptionsFrame:IsShown() then
				_G.InterfaceOptionsFrameCancel:Click();
			end

			CloseMenus();
			CloseAllWindows()
			PlaySound(850) --IG_MAINMENU_OPEN
			ShowUIPanel(_G.GameMenuFrame);
		else
			PlaySound(854) --IG_MAINMENU_QUIT
			HideUIPanel(_G.GameMenuFrame);
			MainMenuMicroButton_SetNormal();
		end
	end},
	{text = _G.HELP_BUTTON, func = ToggleHelpFrame}
}

Minimap:SetScript("OnMouseUp", function(self, btn)
	menuFrame:Hide()

	local position = self:GetPoint()
	if btn == "MiddleButton" or (btn == "RightButton") then
		if InCombatLockdown() then
			_G.UIErrorsFrame:AddMessage(K.InfoColor.._G.ERR_NOT_IN_COMBAT)
			return
		end

		if position:match("LEFT") then
			EasyMenu(menuList, menuFrame, "cursor")
		else
			EasyMenu(menuList, menuFrame, "cursor", -160, 0)
		end
	else
		Minimap_OnClick(self)
    end
end)