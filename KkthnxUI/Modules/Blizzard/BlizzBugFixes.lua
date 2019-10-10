local K, C = unpack(select(2, ...))
local Module = K:GetModule("Blizzard")

if not Module then
	return
end

local _G = _G

local blizzardCollectgarbage = _G.collectgarbage

function Module:CreateBlizzBugFixes()
	-- Fix blizz error
	MAIN_MENU_MICRO_ALERT_PRIORITY = MAIN_MENU_MICRO_ALERT_PRIORITY or {}

	-- Garbage Collection Is Being Overused And Misused,
	-- And It's Causing Lag And Performance Drops.
	do
		if C["General"].FixGarbageCollect then
			-- Garbage collection is being overused and misused,
			-- and it's causing lag and performance drops.
			blizzardCollectgarbage("setpause", 110)
			blizzardCollectgarbage("setstepmul", 200)

			_G.collectgarbage = function(opt, arg)
				if (opt == "collect") or (opt == nil) then
				elseif (opt == "count") then
					return blizzardCollectgarbage(opt, arg)
				elseif (opt == "setpause") then
					return blizzardCollectgarbage("setpause", 110)
				elseif opt == "setstepmul" then
					return blizzardCollectgarbage("setstepmul", 200)
				elseif (opt == "stop") then
				elseif (opt == "restart") then
				elseif (opt == "step") then
					if (arg ~= nil) then
						if (arg <= 10000) then
							return blizzardCollectgarbage(opt, arg)
						end
					else
						return blizzardCollectgarbage(opt, arg)
					end
				else
					return blizzardCollectgarbage(opt, arg)
				end
			end

			-- Memory usage is unrelated to performance, and tracking memory usage does not track "bad" addons.
			-- Developers can uncomment this line to enable the functionality when looking for memory leaks,
			-- but for the average end-user this is a completely pointless thing to track.
			_G.UpdateAddOnMemoryUsage = function() end
		end
	end

	-- Temporary taint fix
	do
		InterfaceOptionsFrameCancel:SetScript("OnClick", function()
			InterfaceOptionsFrameOkay:Click()
		end)
	end
end