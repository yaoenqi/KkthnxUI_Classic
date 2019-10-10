local _G = _G
local K, C = _G.unpack(_G.select(2, ...))
local Module = K:GetModule("Automation")

local AcceptGroup = _G.AcceptGroup
local BNGetGameAccountInfoByGUID = _G.BNGetGameAccountInfoByGUID
local IsCharacterFriend = _G.C_FriendList.IsFriend
local IsGuildMember = _G.IsGuildMember

function Module.AutoInvite(event, _, _, _, _, _, _, inviterGUID)
	if event == "PARTY_INVITE_REQUEST" then
		if BNGetGameAccountInfoByGUID(inviterGUID) or IsCharacterFriend(inviterGUID) or IsGuildMember(inviterGUID) then
			AcceptGroup()
			StaticPopupDialogs["PARTY_INVITE"].inviteAccepted = 1
			StaticPopup_Hide("PARTY_INVITE")
		end
	end
end

function Module:CreateAutoInvite()
	if C["Automation"].AutoInvite ~= true then
		return
	end

	K:RegisterEvent("PARTY_INVITE_REQUEST", self.AutoInvite)
	K:RegisterEvent("GROUP_ROSTER_UPDATE", self.AutoInvite)
end