local K, C, L = unpack(select(2, ...))
if C["DataText"].Time ~= true then
	return
end

local module = K:GetModule("Infobar")
local info = module:RegisterInfobar("KkthnxUITime", {"BOTTOM", Minimap, "BOTTOM", 0, 2})

local date = date
local format, floor = string.format, math.floor
local mod, tonumber, pairs, select = mod, tonumber, pairs, select
local C_Map_GetMapInfo = C_Map.GetMapInfo
local C_AreaPoiInfo_GetAreaPOISecondsLeft = C_AreaPoiInfo.GetAreaPOISecondsLeft
local TIMEMANAGER_TICKER_24HOUR, TIMEMANAGER_TICKER_12HOUR = TIMEMANAGER_TICKER_24HOUR, TIMEMANAGER_TICKER_12HOUR
local FULLDATE, CALENDAR_WEEKDAY_NAMES, CALENDAR_FULLDATE_MONTH_NAMES = FULLDATE, CALENDAR_WEEKDAY_NAMES, CALENDAR_FULLDATE_MONTH_NAMES
local PLAYER_DIFFICULTY_TIMEWALKER, RAID_INFO_WORLD_BOSS, DUNGEON_DIFFICULTY3 = PLAYER_DIFFICULTY_TIMEWALKER, RAID_INFO_WORLD_BOSS, DUNGEON_DIFFICULTY3
local DUNGEONS, RAID_INFO, QUESTS_LABEL, ISLANDS_HEADER, QUEST_COMPLETE, LFG_LIST_LOADING, QUEUE_TIME_UNAVAILABLE = DUNGEONS, RAID_INFO, QUESTS_LABEL, ISLANDS_HEADER, QUEST_COMPLETE, LFG_LIST_LOADING, QUEUE_TIME_UNAVAILABLE
local RequestRaidInfo, UnitLevel, GetNumSavedWorldBosses, GetSavedWorldBossInfo = RequestRaidInfo, UnitLevel, GetNumSavedWorldBosses, GetSavedWorldBossInfo
local GetCVarBool, GetGameTime, GameTime_GetLocalTime, GameTime_GetGameTime, SecondsToTime = GetCVarBool, GetGameTime, GameTime_GetLocalTime, GameTime_GetGameTime, SecondsToTime
local GetNumSavedInstances, GetSavedInstanceInfo, IsQuestFlaggedCompleted, GetQuestObjectiveInfo = GetNumSavedInstances, GetSavedInstanceInfo, IsQuestFlaggedCompleted, GetQuestObjectiveInfo

local function updateTimerFormat(color, hour, minute)
	if GetCVarBool("timeMgrUseMilitaryTime") then
		return format(color..TIMEMANAGER_TICKER_24HOUR, hour, minute)
	else
		local timerUnit = K.MyClassColor..(hour < 12 and "am" or "pm")
		if hour > 12 then hour = hour - 12 end
		return format(color..TIMEMANAGER_TICKER_12HOUR..timerUnit, hour, minute)
	end
end

info.onUpdate = function(self, elapsed)
	self.timer = (self.timer or 3) + elapsed
	if self.timer > 5 then
		local color = ""

		local hour, minute
		if GetCVarBool("timeMgrUseLocalTime") then
			hour, minute = tonumber(date("%H")), tonumber(date("%M"))
		else
			hour, minute = GetGameTime()
		end
		self.text:SetText(updateTimerFormat(color, hour, minute))

		self.timer = 0
	end
end

local title
local function addTitle(text)
	if not title then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(text..":")
		title = true
	end
end

info.onEnter = function(self)
	RequestRaidInfo()

	local r,g,b
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint(K.GetAnchors(self))
	GameTooltip:ClearLines()
	local today = C_DateAndTime.GetTodaysDate()
	local w, m, d, y = today.weekDay, today.month, today.day, today.year
	GameTooltip:AddLine(format(FULLDATE, CALENDAR_WEEKDAY_NAMES[w], CALENDAR_FULLDATE_MONTH_NAMES[m], d, y), 0,.6,1)
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine("Local Time", GameTime_GetLocalTime(true), nil, nil, nil ,1,1,1)
	GameTooltip:AddDoubleLine("Realm Time", GameTime_GetGameTime(true), nil, nil, nil ,1,1,1)

	-- Mythic Dungeons
	title = false
	for i = 1, GetNumSavedInstances() do
		local name, _, reset, diff, locked, extended = GetSavedInstanceInfo(i)
		if diff == 23 and (locked or extended) then
			addTitle(DUNGEON_DIFFICULTY3..DUNGEONS)
			if extended then r,g,b = .3,1,.3 else r,g,b = 1,1,1 end
			GameTooltip:AddDoubleLine(name, SecondsToTime(reset, true, nil, 3), 1,1,1, r,g,b)
		end
	end

	-- Raids
	title = false
	for i = 1, GetNumSavedInstances() do
		local name, _, reset, _, locked, extended, _, isRaid, _, diffName = GetSavedInstanceInfo(i)
		if isRaid and (locked or extended) then
			addTitle(RAID_INFO)
			if extended then r,g,b = .3,1,.3 else r,g,b = 1,1,1 end
			GameTooltip:AddDoubleLine(name.." - "..diffName, SecondsToTime(reset, true, nil, 3), 1,1,1, r,g,b)
		end
	end

	-- Help Info
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t ".."Toggle Clock".." ", 1,1,1)
	GameTooltip:Show()
end

info.onLeave = K.HideTooltip

info.onMouseUp = function(_, btn)
	if btn == "RightButton" then
		ToggleFrame(TimeManagerFrame)
	end
end