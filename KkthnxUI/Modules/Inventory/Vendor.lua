local K, C, L = unpack(select(2, ...))
local AutoVendor = K:NewModule("AutoVendor")
local AutoRepair = K:NewModule("AutoRepair")

-- Sourced: ElvUI

local _G = _G
local select = _G.select
local string_format = _G.string.format
local table_wipe = _G.table.wipe

local CanMerchantRepair = _G.CanMerchantRepair
local GetContainerItemInfo = _G.GetContainerItemInfo
local GetContainerItemLink = _G.GetContainerItemLink
local GetContainerNumSlots = _G.GetContainerNumSlots
local GetItemInfo = _G.GetItemInfo
local GetMoney = _G.GetMoney
local GetRepairAllCost = _G.GetRepairAllCost
local IsShiftKeyDown = _G.IsShiftKeyDown

AutoVendor.Filter = {
	[6196] = true,
}

function AutoVendor:CreateAutoVendor()
	local Profit = 0
	local TotalCount = 0

	for Bag = 0, 4 do
		for Slot = 1, GetContainerNumSlots(Bag) do
			local Link, ID = GetContainerItemLink(Bag, Slot), GetContainerItemID(Bag, Slot)

			if (Link and ID and not AutoVendor.Filter[ID]) then
				local TotalPrice = 0
				local Quality = select(3, GetItemInfo(Link))
				local SellPrice = select(11, GetItemInfo(Link))
				local Count = select(2, GetContainerItemInfo(Bag, Slot))

				if ((SellPrice and (SellPrice > 0)) and Count) then
					TotalPrice = SellPrice * Count
				end

				if ((Quality and Quality <= 0) and TotalPrice > 0) then
					UseContainerItem(Bag, Slot)
					PickupMerchantItem()
					Profit = Profit + TotalPrice
					TotalCount = TotalCount + Count
				end
			end
		end
	end

	if (Profit > 0) then
		K.Print(string_format("You sold %d items for a total of %s", TotalCount, K.FormatMoney(Profit)))
	end
end

function AutoVendor:OnEnable()
	if C["Inventory"].AutoSell and not IsShiftKeyDown() then
		K:RegisterEvent("MERCHANT_SHOW", self.CreateAutoVendor)
	else
		K:UnregisterEvent("MERCHANT_SHOW", self.CreateAutoVendor)
	end
end

function AutoRepair:CreateAutoRepair()
	local Money = GetMoney()

	if CanMerchantRepair() then
		local Cost = GetRepairAllCost()
		local CostString = K.FormatMoney(Cost)

		if (Cost > 0) then
			if (Money > Cost) then
				RepairAllItems()

				K.Print(string_format("Your equipped items have been repaired for %s", CostString))
			else
				local Required = Cost - Money
				local RequiredString = K.FormatMoney(Required)

				K.Print(string_format("You require %s to repair all equipped items (costs %s total)", RequiredString, CostString))
			end
		end
	end
end

function AutoRepair:OnEnable()
	if C["Inventory"].AutoRepair and not IsShiftKeyDown() then
		K:RegisterEvent("MERCHANT_SHOW", self.CreateAutoRepair)
	else
		K:UnregisterEvent("MERCHANT_SHOW", self.CreateAutoRepair)
	end
end