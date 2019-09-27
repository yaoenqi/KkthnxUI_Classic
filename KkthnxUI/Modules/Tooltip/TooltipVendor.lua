local K, C = unpack(select(2, ...))
if C["Tooltip"].Enable ~= true then
	return
end

if IsAddOnLoaded("Leatrix_Plus")
or IsAddOnLoaded("BetterVendorPrice")
or IsAddOnLoaded("VendorPrice") then
	return
end

local _G = _G

local GetMouseFocus = _G.GetMouseFocus
local GetItemInfo = _G.GetItemInfo
local hooksecurefunc = _G.hooksecurefunc
local SetTooltipMoney = _G.SetTooltipMoney
local SELL_PRICE = _G.SELL_PRICE

-- Function to show vendor price
local function SetGameToolTipPrice(tooltip, tooltipObject)
	if tooltip.shownMoneyFrames then
		return
	end

	tooltipObject = tooltipObject or GameTooltip

	local container = GetMouseFocus()
	if not container then
		return
	end

	local _, itemlink = tooltipObject:GetItem()
	if not itemlink then
		return
	end

	local _, _, _, _, _, _, _, _, _, _, sellPrice = GetItemInfo(itemlink)
	if sellPrice and sellPrice > 0 then
		local count = container and type(container.count) == "number" and container.count or 1
		if sellPrice and count > 0 then
			SetTooltipMoney(tooltip, sellPrice * count, "STATIC", SELL_PRICE..":")
		end
	end

	if tooltipObject == ItemRefTooltip then
		ItemRefTooltip:Show()
	end
end

-- Show vendor price when tooltips are shown
GameTooltip:HookScript("OnTooltipSetItem", SetGameToolTipPrice)
hooksecurefunc(GameTooltip, "SetHyperlink", function(tooltip)
	SetGameToolTipPrice(tooltip, GameTooltip)
end)

hooksecurefunc(ItemRefTooltip, "SetHyperlink", function(tooltip)
	SetGameToolTipPrice(tooltip, ItemRefTooltip)
end)