local _G = _G
local K = _G.unpack(_G.select(2, ...))
local Module = K:NewModule("Automation")

if not Module then
    return
end

function Module:OnEnable()
    self:CreateAutoBuffThanksAnnounce()
    self:CreateAutoDeclineDuels()
    self:CreateAutoInvite()
    self:CreateAutoRelease()
    self:CreateAutoResurrect()
    self:CreateAutoReward()
    self:CreateAutoWhisperInvite()
end