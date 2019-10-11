local K, C = unpack(select(2, ...))
local Module = K:GetModule("Miscellaneous")

local _G = _G

local IsAddOnLoaded = _G.IsAddOnLoaded

function Module:SetupImprovedProfessionWindow(frame)
	-- Make the quest log frame double-wide
	UIPanelWindows[frame.."Frame"] = {
		area = "override",
		pushable = 1,
		xoffset = -16,
		yoffset = 12,
		bottomClampOverride = 140 + 12,
		width = 714,
		height = 487,
		whileDead = 1
	}

	-- Size the tradeskill frame
	_G[frame.."Frame"]:SetWidth(714)
	_G[frame.."Frame"]:SetHeight(487)

	-- Adjust quest log title text
	_G[frame.."FrameTitleText"]:ClearAllPoints()
	_G[frame.."FrameTitleText"]:SetPoint("TOP", _G[frame.."Frame"], "TOP", 0, -18)

	-- Expand the tradeskill list to full height
	_G[frame.."ListScrollFrame"]:ClearAllPoints()
	_G[frame.."ListScrollFrame"]:SetPoint("TOPLEFT", _G[frame.."Frame"], "TOPLEFT", 25, -75)
	_G[frame.."ListScrollFrame"]:SetSize(295, 336)

	-- Create additional list rows
	if frame == "TradeSkill" then
		local oldTradeSkillsDisplayed = TRADE_SKILLS_DISPLAYED

		-- Position existing buttons
		for i = 1 + 1, TRADE_SKILLS_DISPLAYED do
			_G["TradeSkillSkill"..i]:ClearAllPoints()
			_G["TradeSkillSkill"..i]:SetPoint("TOPLEFT", _G["TradeSkillSkill"..(i-1)], "BOTTOMLEFT", 0, 1)
		end

		-- Create and position new buttons
		_G.TRADE_SKILLS_DISPLAYED = _G.TRADE_SKILLS_DISPLAYED + 14
		for i = oldTradeSkillsDisplayed + 1, TRADE_SKILLS_DISPLAYED do
			local button = CreateFrame("Button", "TradeSkillSkill"..i, TradeSkillFrame, "TradeSkillSkillButtonTemplate")
			button:SetID(i)
			button:Hide()
			button:ClearAllPoints()
			button:SetPoint("TOPLEFT", _G["TradeSkillSkill"..(i-1)], "BOTTOMLEFT", 0, 1)
		end
	else
		local oldCraftsDisplayed = CRAFTS_DISPLAYED

		-- Position existing buttons
		_G["Craft1Cost"]:ClearAllPoints()
		_G["Craft1Cost"]:SetPoint("RIGHT", _G["Craft1"], "RIGHT", -30, 0)

		for i = 1 + 1, CRAFTS_DISPLAYED do
			_G["Craft"..i]:ClearAllPoints()
			_G["Craft"..i]:SetPoint("TOPLEFT", _G["Craft"..(i-1)], "BOTTOMLEFT", 0, 1)
			_G["Craft"..i.."Cost"]:ClearAllPoints()
			_G["Craft"..i.."Cost"]:SetPoint("RIGHT", _G["Craft"..i], "RIGHT", -30, 0)
		end

		-- Create and position new buttons
		_G.CRAFTS_DISPLAYED = _G.CRAFTS_DISPLAYED + 14
		for i = oldCraftsDisplayed + 1, CRAFTS_DISPLAYED do
			local button = CreateFrame("Button", "Craft"..i, CraftFrame, "CraftButtonTemplate")
			button:SetID(i)
			button:Hide()
			button:ClearAllPoints()
			button:SetPoint("TOPLEFT", _G["Craft"..(i-1)], "BOTTOMLEFT", 0, 1)

			_G["Craft"..i.."Cost"]:ClearAllPoints()
			_G["Craft"..i.."Cost"]:SetPoint("RIGHT", _G["Craft"..i], "RIGHT", -30, 0)

		end

		-- Move craft frame points (such as Beast Training)
		CraftFramePointsLabel:ClearAllPoints()
		CraftFramePointsLabel:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 100, -50)
		CraftFramePointsText:ClearAllPoints()
		CraftFramePointsText:SetPoint("LEFT", CraftFramePointsLabel, "RIGHT", 3, 0)
	end

	-- Set highlight bar width when shown
	hooksecurefunc(_G[frame.."HighlightFrame"], "Show", function()
		_G[frame.."HighlightFrame"]:SetWidth(290)
	end)

	-- Move the tradeskill detail frame to the right and stretch it to full height
	_G[frame.."DetailScrollFrame"]:ClearAllPoints()
	_G[frame.."DetailScrollFrame"]:SetPoint("TOPLEFT", _G[frame.."Frame"], "TOPLEFT", 352, -74)
	_G[frame.."DetailScrollFrame"]:SetSize(298, 336)

	-- Hide detail scroll frame textures
	_G[frame.."DetailScrollFrameTop"]:SetAlpha(0)
	_G[frame.."DetailScrollFrameBottom"]:SetAlpha(0)

	-- Create texture for skills list
	local RecipeInset = _G[frame.."Frame"]:CreateTexture(nil, "ARTWORK")
	RecipeInset:SetSize(304, 361)
	RecipeInset:SetPoint("TOPLEFT", _G[frame.."Frame"], "TOPLEFT", 16, -72)
	RecipeInset:SetTexture("Interface\\RAIDFRAME\\UI-RaidFrame-GroupBg")

	-- Set detail frame backdrop
	local DetailsInset = _G[frame.."Frame"]:CreateTexture(nil, "ARTWORK")
	DetailsInset:SetSize(302, 339)
	DetailsInset:SetPoint("TOPLEFT", _G[frame.."Frame"], "TOPLEFT", 348, -72)
	DetailsInset:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated")

	-- Hide expand tab (left of All button)
	_G[frame.."ExpandTabLeft"]:Hide()

	-- Get tradeskill frame textures
	local regions = {_G[frame.."Frame"]:GetRegions()}

	-- Set top left texture
	regions[2]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Left")
	regions[2]:SetSize(512, 512)

	-- Set top right texture
	regions[3]:ClearAllPoints()
	regions[3]:SetPoint("TOPLEFT", regions[2], "TOPRIGHT", 0, 0)
	regions[3]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Right")
	regions[3]:SetSize(256, 512)

	-- Hide bottom left and bottom right textures
	regions[4]:Hide()
	regions[5]:Hide()

	-- Hide skills list dividing bar
	regions[9]:Hide()
	regions[10]:Hide()

	-- Move create button row
	_G[frame.."CreateButton"]:ClearAllPoints()
	_G[frame.."CreateButton"]:SetPoint("RIGHT", _G[frame.."CancelButton"], "LEFT", -1, 0)

	-- Position and size close button
	_G[frame.."CancelButton"]:SetSize(80, 22)
	_G[frame.."CancelButton"]:SetText(CLOSE)
	_G[frame.."CancelButton"]:ClearAllPoints()
	_G[frame.."CancelButton"]:SetPoint("BOTTOMRIGHT", _G[frame.."Frame"], "BOTTOMRIGHT", -42, 54)

	-- Position close box
	_G[frame.."FrameCloseButton"]:ClearAllPoints()
	_G[frame.."FrameCloseButton"]:SetPoint("TOPRIGHT", _G[frame.."Frame"], "TOPRIGHT", -30, -8)

	-- Position dropdown menus
	if frame == "TradeSkill" then
		TradeSkillInvSlotDropDown:ClearAllPoints()
		TradeSkillInvSlotDropDown:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 510, -40)
		TradeSkillSubClassDropDown:ClearAllPoints()
		TradeSkillSubClassDropDown:SetPoint("RIGHT", TradeSkillInvSlotDropDown, "LEFT", 0, 0)
	end

	-- Position rank frame to default location
	_G[frame.."RankFrame"]:ClearAllPoints()
	_G[frame.."RankFrame"]:SetPoint("TOPLEFT", _G[frame.."Frame"], "TOPLEFT", 73, -37)
end

function Module:CreateImprovedProfessionWindow()
	if IsAddOnLoaded("Leatrix_Plus") or C["Misc"].ImprovedProfessionWindow ~= true then
		return
	end

	local loadCount = 0
	if IsAddOnLoaded("Blizzard_TradeSkillUI") or IsAddOnLoaded("Blizzard_CraftUI") then
		if IsAddOnLoaded("Blizzard_TradeSkillUI") then
			Module:SetupImprovedProfessionWindow("TradeSkill")
			loadCount = loadCount + 1
		elseif IsAddOnLoaded("Blizzard_CraftUI") then
			Module:SetupImprovedProfessionWindow("Craft")
			loadCount = loadCount + 1
		end
	else
		local waitFrame = CreateFrame("FRAME")
		waitFrame:RegisterEvent("ADDON_LOADED")
		waitFrame:SetScript("OnEvent", function(_, _, arg1)
			if arg1 == "Blizzard_TradeSkillUI" then
				Module:SetupImprovedProfessionWindow("TradeSkill")
				loadCount = loadCount + 1
			elseif arg1 == "Blizzard_CraftUI" then
				Module:SetupImprovedProfessionWindow("Craft")
				loadCount = loadCount + 1
			end

			if loadCount == 2 then
				waitFrame:UnregisterAllEvents()
			end
		end)
	end
end