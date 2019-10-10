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
	{
        text = MAINMENU_BUTTON,
        isTitle = true,
        notCheckable = true,
	},
	{
        text = " ",
		notCheckable = true,
		notClickable = true,
    },
    {
        text = CHARACTER_BUTTON,
        icon = "Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle",
        func = function()
            ToggleCharacter("PaperDollFrame")
        end,
        notCheckable = true,
    },
    {
        text = SPELLBOOK_ABILITIES_BUTTON,
        icon = "Interface\\MINIMAP\\TRACKING\\Class",
        func = function()
			ToggleFrame(SpellBookFrame)
        end,
        tooltipTitle = securecall(MicroButtonTooltipText, SPELLBOOK_ABILITIES_BUTTON, "TOGGLESPELLBOOK"),
        tooltipText = NEWBIE_TOOLTIP_SPELLBOOK,
        notCheckable = true,
    },
    {
        text = TALENTS_BUTTON,
        icon = "Interface\\PVPFrame\\Icon-Combat",
		func = function()
			ToggleTalentFrame()
		end,
        tooltipTitle = securecall(MicroButtonTooltipText, TALENTS_BUTTON, "TOGGLETALENTS"),
        tooltipText = NEWBIE_TOOLTIP_TALENTS,
        notCheckable = true,
    },
    {
        text = QUESTLOG_BUTTON,
        icon = "Interface\\GossipFrame\\ActiveQuestIcon",
        func = function()
			ShowUIPanel(QuestLogFrame)
        end,
        tooltipTitle = securecall(MicroButtonTooltipText, QUESTLOG_BUTTON, "TOGGLEQUESTLOG"),
        tooltipText = NEWBIE_TOOLTIP_QUESTLOG,
        notCheckable = true,
	},
	{
		text = WORLD_MAP,
		icon = "Interface\\WorldMap\\UI-World-Icon",
		func = function()
			ShowUIPanel(WorldMapFrame)
			MaximizeUIPanel(WorldMapFrame)
		end,
		notCheckable = true
	},
    {
        text = GUILD,
        icon = "Interface\\GossipFrame\\TabardGossipIcon",
        arg1 = IsInGuild("player"),
        func = function()
			if IsInGuild() then
				ToggleFriendsFrame(3)
			else
				ToggleGuildFrame()
			end
		end,
        notCheckable = true,
    },
    {
        text = SOCIAL_BUTTON,
        icon = "Interface\\FriendsFrame\\PlusManz-BattleNet",
        func = function()
            ToggleFriendsFrame(1)
        end,
        notCheckable = true,
	},
	{
		text = "Communities",
		icon = "Interface\\CHATFRAME\\UI-ChatConversationIcon",
		func = function()
			ToggleCommunitiesFrame()
		end,
		notCheckable = true
	},
    {
        text = RAID,
        icon = "Interface\\TARGETINGFRAME\\UI-TargetingFrame-Skull",
        func = function()
            ToggleFriendsFrame(4)
        end,
        notCheckable = true,
	},
	{
		text = VOICE,
		icon = "Interface\\CHATFRAME\\UI-ChatIcon-ArmoryChat",
		func = function()
			ToggleChannelFrame()
		end,
		notCheckable = true
	},
    {
        text = GM_EMAIL_NAME,
        icon = "Interface\\CHATFRAME\\UI-ChatIcon-Blizz",
        func = function()
            ToggleHelpFrame()
        end,
        tooltipTitle = HELP_BUTTON,
        tooltipText = NEWBIE_TOOLTIP_HELP,
        notCheckable = true,
	},
	{
		text = "",
		notClickable = true,
		notCheckable = true
	},
	{
		text = CLOSE,
		func = function()
		end,
		notCheckable = true
	},
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