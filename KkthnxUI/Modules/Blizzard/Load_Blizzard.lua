local _G = _G
local K = _G.unpack(_G.select(2, ...))
local Module = K:NewModule("Blizzard")

if not Module then
    return
end

local HideUIPanel = _G.HideUIPanel
local ShowUIPanel = _G.ShowUIPanel
local SpellBookFrame = _G.SpellBookFrame

function Module:OnEnable()
    -- self:CreateUIWidgets() -- Do we still need to fix this? Or do they not longer exsit?

    ShowUIPanel(SpellBookFrame)
    HideUIPanel(SpellBookFrame)

    self:CreateAlertFrames()
    self:CreateBlizzBugFixes()
    self:CreateColorPicker()
    self:CreateErrorFilter()
    self:CreateMirrorBars()
    self:CreateQuestTrackerMover()
    self:CreateRaidUtility()
end