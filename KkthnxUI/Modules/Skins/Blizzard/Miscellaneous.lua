local K = unpack(select(2, ...))
local Module = K:GetModule("Skins")

local _G = _G

local table_insert = _G.table.insert

local function SkinMiscStuff()
	if K.CheckAddOnState("Skinner") or K.CheckAddOnState("Aurora") then
		return
	end
end

table_insert(Module.NewSkin["KkthnxUI"], SkinMiscStuff)