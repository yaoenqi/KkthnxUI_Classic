local K, C, L = unpack(select(2, ...))

-- Sourced: AlreadyKnown (villiv)
-- Edited: KkthnxUI (Kkthnx)

local _G = _G
local string_find = _G.string.find
local string_match = _G.string.match

local CreateFrame = _G.CreateFrame
local GetAuctionItemInfo = _G.GetAuctionItemInfo
local GetAuctionItemLink = _G.GetAuctionItemLink
local GetBuybackItemInfo = _G.GetBuybackItemInfo
local GetBuybackItemLink = _G.GetBuybackItemLink
local GetItemInfo = _G.GetItemInfo
local GetMerchantItemInfo = _G.GetMerchantItemInfo
local GetMerchantItemLink = _G.GetMerchantItemLink
local GetMerchantNumItems = _G.GetMerchantNumItems
local GetNumAuctionItems = _G.GetNumAuctionItems
local GetNumBuybackItems = _G.GetNumBuybackItems
local IsAddOnLoaded = _G.IsAddOnLoaded
local UIParent = _G.UIParent
local hooksecurefunc = _G.hooksecurefunc

local COLOR = {r = .1, g = 1, b = .1}
local knowables, knowns = {
	[_G.LE_ITEM_CLASS_CONSUMABLE] = true,
	[_G.LE_ITEM_CLASS_RECIPE] = true,
	[_G.LE_ITEM_CLASS_MISCELLANEOUS] = true,
}, {}
local tooltip = CreateFrame("GameTooltip", "AlreadyKnownTooltip", nil, "GameTooltipTemplate")

local function IsAlreadyKnown(link)
	if not link then
		return
	end

	if string_match(link, "item:") then
		local name, _, _, _, _, _, _, _, _, _, _, itemClassID = GetItemInfo(link)
		if not name then
			return
		end

		if knowns[link] then
			return true
		end

		if not knowables[itemClassID] then
			return
		end

		K.ScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
		K.ScanTooltip:SetHyperlink(link)
		for i = 1, K.ScanTooltip:NumLines() do
			local text = _G[K.ScanTooltip:GetName().."TextLeft"..i]:GetText() or ""
			if string_find(text, _G.COLLECTED) or text == _G.ITEM_SPELL_KNOWN then
				knowns[link] = true
				return true
			end
		end
	end
end

-- Merchant Frame
local function MerchantFrame_UpdateMerchantInfo()
	local numItems = GetMerchantNumItems()
	for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
		local index = (_G.MerchantFrame.page - 1) * _G.MERCHANT_ITEMS_PER_PAGE + i
		if index > numItems then
			return
		end

		local button = _G["MerchantItem"..i.."ItemButton"]
		if button and button:IsShown() then
			local _, _, _, _, numAvailable, isUsable = GetMerchantItemInfo(index)
			if isUsable and IsAlreadyKnown(GetMerchantItemLink(index)) then
				local r, g, b = COLOR.r, COLOR.g, COLOR.b
				if numAvailable == 0 then
					r, g, b = r * 0.5, g * 0.5, b * 0.5
				end

				_G.SetItemButtonTextureVertexColor(button, r, g, b)
			end
		end
	end
end
hooksecurefunc("MerchantFrame_UpdateMerchantInfo", MerchantFrame_UpdateMerchantInfo)

local function MerchantFrame_UpdateBuybackInfo()
	local numItems = GetNumBuybackItems()
	for index = 1, _G.BUYBACK_ITEMS_PER_PAGE do
		if index > numItems then
			return
		end

		local button = _G["MerchantItem"..index.."ItemButton"]
		if button and button:IsShown() then
			local _, _, _, _, _, isUsable = GetBuybackItemInfo(index)
			if isUsable and IsAlreadyKnown(GetBuybackItemLink(index)) then
				_G.SetItemButtonTextureVertexColor(button, COLOR.r, COLOR.g, COLOR.b)
			end
		end
	end
end
hooksecurefunc("MerchantFrame_UpdateBuybackInfo", MerchantFrame_UpdateBuybackInfo)

-- Auction Frame
local function AuctionFrameBrowse_Update()
	local numItems = GetNumAuctionItems("list")
	local offset = _G.FauxScrollFrame_GetOffset(_G.BrowseScrollFrame)
	for i = 1, _G.NUM_BROWSE_TO_DISPLAY do
		local index = offset + i
		if index > numItems then return end

		local texture = _G["BrowseButton"..i.."ItemIconTexture"]
		if texture and texture:IsShown() then
			local _, _, _, _, canUse = GetAuctionItemInfo("list", index)
			if canUse and IsAlreadyKnown(GetAuctionItemLink("list", index)) then
				texture:SetVertexColor(COLOR.r, COLOR.g, COLOR.b)
			end
		end
	end
end

local function AuctionFrameBid_Update()
	local numItems = GetNumAuctionItems("bidder")
	local offset = _G.FauxScrollFrame_GetOffset(_G.BidScrollFrame)
	for i = 1, _G.NUM_BIDS_TO_DISPLAY do
		local index = offset + i
		if index > numItems then
			return
		end

		local texture = _G["BidButton"..i.."ItemIconTexture"]
		if texture and texture:IsShown() then
			local _, _, _, _, canUse = GetAuctionItemInfo("bidder", index)
			if canUse and IsAlreadyKnown(GetAuctionItemLink("bidder", index)) then
				texture:SetVertexColor(COLOR.r, COLOR.g, COLOR.b)
			end
		end
	end
end

local function AuctionFrameAuctions_Update()
	local numItems = GetNumAuctionItems("owner")
	local offset = _G.FauxScrollFrame_GetOffset(_G.AuctionsScrollFrame)
	for i = 1, _G.NUM_AUCTIONS_TO_DISPLAY do
		local index = offset + i
		if index > numItems then
			return
		end

		local texture = _G["AuctionsButton"..i.."ItemIconTexture"]
		if texture and texture:IsShown() then
			local _, _, _, _, canUse, _, _, _, _, _, _, _, saleStatus = GetAuctionItemInfo("owner", index)
			if canUse and IsAlreadyKnown(GetAuctionItemLink("owner", index)) then
				local r, g, b = COLOR.r, COLOR.g, COLOR.b
				if saleStatus == 1 then
					r, g, b = r * 0.5, g * 0.5, b * 0.5
				end
				texture:SetVertexColor(r, g, b)
			end
		end
	end
end

local isBlizzard_AuctionUILoaded
if IsAddOnLoaded("Blizzard_AuctionUI") then
	isBlizzard_AuctionUILoaded = true
	hooksecurefunc("AuctionFrameBrowse_Update", AuctionFrameBrowse_Update)
	hooksecurefunc("AuctionFrameBid_Update", AuctionFrameBid_Update)
	hooksecurefunc("AuctionFrameAuctions_Update", AuctionFrameAuctions_Update)
end

-- For LoD AddOns
if not (isBlizzard_AuctionUILoaded) then
	local function OnEvent(self, event, addonName)
		if addonName == "Blizzard_AuctionUI" then
			isBlizzard_AuctionUILoaded = true
			hooksecurefunc("AuctionFrameBrowse_Update", AuctionFrameBrowse_Update)
			hooksecurefunc("AuctionFrameBid_Update", AuctionFrameBid_Update)
			hooksecurefunc("AuctionFrameAuctions_Update", AuctionFrameAuctions_Update)
		end

		if isBlizzard_AuctionUILoaded then
			self:UnregisterEvent(event)
			self:SetScript("OnEvent", nil)
			OnEvent = nil
		end
	end
	K.ScanTooltip:SetScript("OnEvent", OnEvent)
	K.ScanTooltip:RegisterEvent("ADDON_LOADED")
end