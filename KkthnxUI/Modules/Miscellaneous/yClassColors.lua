local K, C = unpack(select(2, ...))
if C["Misc"].EnhancedFriends ~= true then return end

-- Sourced: yClassColors (yleaf)
-- Edited: KkthnxUI (Kkthnx)

local _G = _G
local string_format = _G.string.format
local table_insert = _G.table.insert
local table_wipe = _G.table.wipe

local BNGetFriendInfo = _G.BNGetFriendInfo
local BNGetGameAccountInfo = _G.BNGetGameAccountInfo
local GetGuildInfo = _G.GetGuildInfo
local GetGuildRosterInfo = _G.GetGuildRosterInfo
local GetQuestDifficultyColor = _G.GetQuestDifficultyColor
local GetRealZoneText = _G.GetRealZoneText
local UnitFactionGroup = _G.UnitFactionGroup
local UnitRace = _G.UnitRace
local hooksecurefunc = _G.hooksecurefunc

-- Colors
local function classColor(class, showRGB)
	local color = K.ClassColors[K.ClassList[class] or class]
	if not color then
		color = K.ClassColors["PRIEST"]
	end

	if showRGB then
		return color.r, color.g, color.b
	else
		return "|c"..color.colorStr
	end
end

local function diffColor(level)
	return K.RGBToHex(GetQuestDifficultyColor(level))
end

local rankColor = {
	1, 0, 0,
	1, 1, 0,
	0, 1, 0
}

local repColor = {
	1, 0, 0,
	1, 1, 0,
	0, 1, 0,
	0, 1, 1,
	0, 0, 1,
}

local function smoothColor(cur, max, color)
	local r, g, b = oUF:RGBColorGradient(cur, max, unpack(color))
	return K.RGBToHex(r, g, b)
end

-- Guild
hooksecurefunc("GuildStatus_Update", function()
	local guildIndex
	local playerArea = GetRealZoneText()
	local guildOffset = FauxScrollFrame_GetOffset(GuildListScrollFrame)
	if FriendsFrame.playerStatusFrame then
		for i = 1, GUILDMEMBERS_TO_DISPLAY, 1 do
			guildIndex = guildOffset + i
			local fullName, _, _, level, class, zone, _, _, online = GetGuildRosterInfo(guildIndex)
			if fullName and online then
				local r, g, b = classColor(class, true)
				_G["GuildFrameButton"..i.."Name"]:SetTextColor(r, g, b)
				if zone == playerArea then
					_G["GuildFrameButton"..i.."Zone"]:SetTextColor(0, 1, 0)
				end
				local color = GetQuestDifficultyColor(level)
				_G["GuildFrameButton"..i.."Level"]:SetTextColor(color.r, color.g, color.b)
				_G["GuildFrameButton"..i.."Class"]:SetTextColor(r, g, b)
			end
		end
	else
		for i = 1, GUILDMEMBERS_TO_DISPLAY, 1 do
			guildIndex = guildOffset + i
			local fullName, _, rankIndex, _, class, zone, _, _, online = GetGuildRosterInfo(guildIndex)
			if fullName and online then
				local r, g, b = classColor(class, true)
				_G["GuildFrameGuildStatusButton"..i.."Name"]:SetTextColor(r, g, b)
				local lr, lg, lb = oUF:RGBColorGradient(rankIndex, 10, unpack(rankColor))
				if lr then
					_G["GuildFrameGuildStatusButton"..i.."Rank"]:SetTextColor(lr, lg, lb)
				end
			end
		end
	end
end)

-- Friends
local FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub("%%d", "%%s")
FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub("%$d", "%$s")

local function friendsFrame()
	local scrollFrame = FriendsFrameFriendsScrollFrame
	local buttons = scrollFrame.buttons
	local playerArea = GetRealZoneText()

	for i = 1, #buttons do
		local nameText, infoText
		local button = buttons[i]
		if button:IsShown() then
			if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
				local info = C_FriendList.GetFriendInfoByIndex(button.id)
				if info and info.connected then
					nameText = classColor(info.className)..info.name.."|r, "..format(FRIENDS_LEVEL_TEMPLATE, diffColor(info.level)..info.level.."|r", info.className)
					if info.area == playerArea then
						infoText = format("|cff00ff00%s|r", info.area)
					end
				end
			elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET then
				local _, presenceName, _, _, _, gameID, client, isOnline = BNGetFriendInfo(button.id)
				if isOnline and client == BNET_CLIENT_WOW then
					local _, charName, _, _, _, faction, _, class, _, zoneName = BNGetGameAccountInfo(gameID)
					if presenceName and charName and class and faction == UnitFactionGroup("player") then
						nameText = presenceName.." "..FRIENDS_WOW_NAME_COLOR_CODE.."("..classColor(class)..charName..FRIENDS_WOW_NAME_COLOR_CODE..")"
						if zoneName == playerArea then
							infoText = format("|cff00ff00%s|r", zoneName)
						end
					end
				end
			end
		end

		if nameText then button.name:SetText(nameText) end
		if infoText then button.info:SetText(infoText) end
	end
end
hooksecurefunc(FriendsFrameFriendsScrollFrame, "update", friendsFrame)
hooksecurefunc("FriendsFrame_UpdateFriends", friendsFrame)

-- Whoframe
local columnTable = {}
local function updateWhoList()
	local whoOffset = FauxScrollFrame_GetOffset(WhoListScrollFrame)
	local playerZone = GetRealZoneText()
	local playerGuild = GetGuildInfo("player")
	local playerRace = UnitRace("player")

	for i = 1, WHOS_TO_DISPLAY, 1 do
		local index = whoOffset + i
		local nameText = _G["WhoFrameButton"..i.."Name"]
		local levelText = _G["WhoFrameButton"..i.."Level"]
		local variableText = _G["WhoFrameButton"..i.."Variable"]
		local info = C_FriendList.GetWhoInfo(index)
		if info then
			local guild, level, race, zone, class = info.fullGuildName, info.level, info.raceStr, info.area, info.filename
			if zone == playerZone then zone = "|cff00ff00"..zone end
			if guild == playerGuild then guild = "|cff00ff00"..guild end
			if race == playerRace then race = "|cff00ff00"..race end

			wipe(columnTable)
			tinsert(columnTable, zone)
			tinsert(columnTable, guild)
			tinsert(columnTable, race)

			nameText:SetTextColor(classColor(class, true))
			levelText:SetText(diffColor(level)..level)
			variableText:SetText(columnTable[UIDropDownMenu_GetSelectedID(WhoFrameDropDown)])
		end
	end
end
hooksecurefunc("WhoList_Update", updateWhoList)