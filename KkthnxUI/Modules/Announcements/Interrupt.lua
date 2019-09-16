local K, C = unpack(select(2, ...))
local Module = K:GetModule("Announcements")

local _G = _G
local string_format = string.format

local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo
local InterruptMessage = _G.INTERRUPTED.." %s's [%s]!"
local IsInGroup = _G.IsInGroup
local IsInRaid = _G.IsInRaid
local SendChatMessage = _G.SendChatMessage
local UnitGUID = _G.UnitGUID

function Module:SetupInterruptAnnounce()
	local inGroup, inRaid = IsInGroup(), IsInRaid()
	if not inGroup then return end -- not in group, exit.

	local _, event, _, sourceGUID, _, _, _, _, destName, _, _, _, _, _, _, spellName = CombatLogGetCurrentEventInfo()
	if not (event == "SPELL_INTERRUPT" and (sourceGUID == K.GUID or sourceGUID == UnitGUID('pet'))) then return end -- No announce-able interrupt from player or pet, exit.

	local interruptAnnounce, msg = C["Announcements"].Interrupt.Value, string_format(InterruptMessage, destName or UNKNOWN, spellName or UNKNOWN)
	if interruptAnnounce == "PARTY" then
		SendChatMessage(msg, "PARTY")
	elseif interruptAnnounce == "RAID" then
		SendChatMessage(msg, (inRaid and "RAID" or "PARTY"))
	elseif interruptAnnounce == "RAID_ONLY" and inRaid then
		SendChatMessage(msg, "RAID")
	elseif interruptAnnounce == "SAY" then
		SendChatMessage(msg, "SAY")
	elseif interruptAnnounce == "EMOTE" then
		SendChatMessage(msg, "EMOTE")
	end
end

function Module:CreateInterruptAnnounce()
	self:SetupInterruptAnnounce()
end