-- Addon's namespace
local zAddon, nameSpace = ...

-- Adding tables to addon's namespace
nameSpace.Options = {}

-- Creating namespace tables
local Options = nameSpace.Options

-- Creating local tables
local zFrames = {}

-- Enable options functionality based on saved variables
-- This function runs once on addon's startup
function Options.initOptions()
	
	-- =====================================================
	-- Chat Functions
	-- =====================================================
	
		if zAddonDB.Chat.HideChatButtons 	then Options.hideChatButtons(zAddonDB.Chat.HideChatButtons) 	end
		if zAddonDB.Chat.hideSocialButton 	then Options.hideSocialButton(zAddonDB.Chat.HideSocialButton) 	end
		if zAddonDB.Chat.StopChatFade 		then Options.disableChatFade(zAddonDB.Chat.StopChatFade) 		end

		if zAddonDB.Chat.ChatClassColors 	then Options.chatClassColors(zAddonDB.Chat.ChatClassColors) 	end
		if zAddonDB.Chat.ClampChat 			then Options.clampChatFrame(zAddonDB.Chat.ClampChat) 			end
		if zAddonDB.Chat.ChatTopBox 		then Options.moveChatEditbox(zAddonDB.Chat.ChatTopBox) 			end

		if zAddonDB.Chat.ChatURLCopy 		then Options.enableURLCopy(zAddonDB.Chat.ChatURLCopy) 			end
		if zAddonDB.Chat.ArrowKeysInChat 	then Options.enableChatArrowKeys(zAddonDB.Chat.ArrowKeysInChat) end

	-- =====================================================
	-- Minimap Functions
	-- =====================================================

		if zAddonDB.Minimap.HideMinimapZoneBorder 	then Options.hideMinimapZoneBorder(zAddonDB.Minimap.HideMinimapZoneBorder) 		end
		if zAddonDB.Minimap.HideZoomButtons 		then Options.hideMinimapZoomButtons(zAddonDB.Minimap.HideZoomButtons) 			end
		if zAddonDB.Minimap.HideMinimapCalendar 	then Options.hideMinimapCalendar(zAddonDB.Minimap.HideMinimapCalendar) 			end
		if zAddonDB.Minimap.HideMinimapTracking 	then Options.hideMinimapTracking(zAddonDB.Minimap.HideMinimapTracking) 			end
		if zAddonDB.Minimap.HideMinimapClock 		then Options.hideMinimapClock(zAddonDB.Minimap.HideMinimapClock) 				end

		if zAddonDB.Minimap.MinimapZoomShortcut 	then Options.minimapZoomShortcut(zAddonDB.Minimap.MinimapZoomShortcut) 			end
		if zAddonDB.Minimap.MinimapCalendarShortcut then Options.minimapCalendarShortcut(zAddonDB.Minimap.MinimapCalendarShortcut) 	end
		if zAddonDB.Minimap.MinimapTrackingShortcut then Options.minimapTrackingShortcut(zAddonDB.Minimap.MinimapTrackingShortcut) 	end

	-- =====================================================
	-- Inventory Functions
	-- =====================================================

		if zAddonDB.Inventory.FastLooting 		then Options.enableFastLooting(zAddonDB.Inventory.FastLooting) 			end
		Options.setInsertedItemsDirection(zAddonDB.Inventory.InsertItemsLeftToRight)
		Options.setSortBagsDirection(zAddonDB.Inventory.SortBagsLeftToRight)

		if zAddonDB.Inventory.SellAllJunk 		then Options.sellJunk(zAddonDB.Inventory.SellAllJunk)					end
		if zAddonDB.Inventory.AutoRepair 		then Options.addAutoRepair(zAddonDB.Inventory.AutoRepair)				end

		if zAddonDB.Inventory.HideCraftedNames 	then Options.hideCraftedItemName(zAddonDB.Inventory.HideCraftedNames) 	end

	-- =====================================================
	-- Frames Functions
	-- =====================================================

		if zAddonDB.Frames.EnhanceDressUp 	then Options.enhanceDressUp(zAddonDB.Frames.EnhanceDressUp) 	end
		Options.setDressUpScale(zAddonDB.Frames.DressUpScale)

		if zAddonDB.Frames.ColorPlayerFrame then Options.colorPlayerFrame(zAddonDB.Frames.ColorPlayerFrame) end
		if zAddonDB.Frames.ColorTargetFrame then Options.colorTargetFrame(zAddonDB.Frames.ColorTargetFrame) end
		if zAddonDB.Frames.ColorFocusFrame 	then Options.colorFocusFrame(zAddonDB.Frames.ColorFocusFrame) 	end

		local event = CreateFrame("Frame")
		event:RegisterEvent("PLAYER_ENTERING_WORLD")
		event:SetScript("OnEvent", function() 

			if zAddonDB.Frames.MoveFramesMode then Options.enableFramesMode(zAddonDB.Frames.MoveFramesMode) end

			-- Unregister the event
			if event == "PLAYER_ENTERING_WORLD" then self:UnregisterEvent("PLAYER_ENTERING_WORLD") end
		end)

	-- =====================================================
	-- Extra Functions
	-- =====================================================

		if zAddonDB.Extra.HideGryphons 		then Options.hideGryphons(zAddonDB.Extra.HideGryphons) 			end
		if zAddonDB.Extra.HideOrderHallBar 	then Options.hideOrderHallBar(zAddonDB.Extra.HideOrderHallBar) 	end
		local collapseFrame = CreateFrame("Frame")
		collapseFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		collapseFrame:SetScript("OnEvent", function() 

			Options.collapseObjectives(zAddonDB.Extra.CollapseObjectives)

			-- Unregister the event
			if event == "PLAYER_ENTERING_WORLD" then self:UnregisterEvent("PLAYER_ENTERING_WORLD") end
		end)

		if zAddonDB.Extra.NoMapEmote 		then Options.disableMapEmote(zAddonDB.Extra.NoMapEmote) 	end
		if zAddonDB.Extra.CharAddonsList 	then Options.charAddonsList(zAddonDB.Extra.CharAddonsList) 	end
end

-- ==================================================================================================
-- Chat Functions
-- ==================================================================================================
	
	-- Hide the combat log tab
	-- Might cause some issues if the combat log tab is not docked
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.hideCombatLog(state)

		if state then

			if (ChatFrame2.isDocked or ChatFrame2:IsShown()) then
				FCF_Close(ChatFrame2)
			end
		else

			if (not ChatFrame2.isDocked and not ChatFrame2:IsShown()) then
				FCF_OpenNewWindow(COMBAT_LOG)
			end
		end
	end

	-- Hide chat side menu button and scroll bar
	-- Remove the whole right chat menu and enable scrolling to top and bottom using modifiers
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.hideChatButtons(state)

		if state then

			-- Create hidden frame to store chat buttons
			local hiddenFrame = CreateFrame("FRAME")
			hiddenFrame:Hide()
			
			-- Enable mouse scrolling in chat using modifiers
			local function enableMouseScroll(chatFrame)

				if _G[chatFrame] then

					_G[chatFrame]:SetScript("OnMouseWheel", function(self, direction)

						if direction == 1 then
							if IsControlKeyDown() then
								self:ScrollToTop()
							elseif IsShiftKeyDown() then
								self:PageUp()
							else
								self:ScrollUp()
							end
						else
							if IsControlKeyDown() then
								self:ScrollToBottom()
							elseif IsShiftKeyDown() then
								self:PageDown()
							else
								self:ScrollDown()
							end
						end
					end)

					_G[chatFrame]:EnableMouseWheel(true)
				end
			end

			-- Hide chat buttons
			local function hideButtons(chatFrame)

				_G[chatFrame .. "ButtonFrameMinimizeButton"]:SetParent(hiddenFrame)
				_G[chatFrame .. "ButtonFrameMinimizeButton"]:Hide()

				_G[chatFrame .. "ButtonFrame"]:SetSize(0.1, 0.1)

				-- Hide extra button frame textures
				_G[chatFrame .. "ButtonFrameBackground"]:Hide()
				_G[chatFrame .. "ButtonFrameTopTexture"]:Hide()
				_G[chatFrame .. "ButtonFrameBottomTexture"]:Hide()
				_G[chatFrame .. "ButtonFrameLeftTexture"]:Hide()
				_G[chatFrame .. "ButtonFrameRightTexture"]:Hide()
				_G[chatFrame .. "ButtonFrameTopLeftTexture"]:Hide()
				_G[chatFrame .. "ButtonFrameTopRightTexture"]:Hide()
				_G[chatFrame .. "ButtonFrameBottomLeftTexture"]:Hide()
				_G[chatFrame .. "ButtonFrameBottomRightTexture"]:Hide()

				_G[chatFrame].ScrollBar:SetParent(hiddenFrame)
				_G[chatFrame].ScrollBar:Hide()
			end

			-- Hide menu buttons
			ChatFrameMenuButton:SetParent(hiddenFrame)
			ChatFrameChannelButton:SetParent(hiddenFrame)
			ChatFrameToggleVoiceDeafenButton:SetParent(hiddenFrame)
			ChatFrameToggleVoiceMuteButton:SetParent(hiddenFrame)

			-- Loop through chat windows
			for i = 1, 50 do

				if _G["ChatFrame" .. i] then
					enableMouseScroll("ChatFrame" .. i)
					hideButtons("ChatFrame" .. i)

					-- Position chat editbox based on ChatTopBox option
					if(zAddonDB.Chat.ChatTopBox) then

						_G["ChatFrame" .. i .. "EditBox"]:SetPoint("TOPLEFT", _G["ChatFrame" .. i], "TOPLEFT", 0, 0)
						_G["ChatFrame" .. i .. "EditBox"]:SetPoint("RIGHT", _G["ChatFrame" .. i .. "ResizeButton"], "RIGHT", -3, 0)
					else

						_G["ChatFrame" .. i .. "EditBox"]:SetPoint("TOPLEFT", _G["ChatFrame" .. i], "BOTTOMLEFT", -5, -2)
						_G["ChatFrame" .. i .. "EditBox"]:SetPoint("RIGHT", _G["ChatFrame" .. i .. "ResizeButton"], "RIGHT", 3, 0)
					end
				end
			end

			-- Handle temporary chat frames
			hooksecurefunc("FCF_OpenTemporaryWindow", function(chatType)

				local chatFrame = FCF_GetCurrentChatFrame():GetName() or nil

				if chatFrame then

					-- Set options for temporary frame
					enableMouseScroll(chatFrame)
					hideButtons(chatFrame)

					-- Position chat editbox based on ChatTopBox option
					if(zAddonDB.Chat.ChatTopBox) then

						_G[chatFrame.. "EditBox"]:SetPoint("TOPLEFT", chatFrame, "TOPLEFT", 0, 0)
						_G[chatFrame.. "EditBox"]:SetPoint("RIGHT", _G[chatFrame .. "ResizeButton"], "RIGHT", -3, 0)
					else

						_G[chatFrame .. "EditBox"]:SetPoint("TOPLEFT", chatFrame, "BOTTOMLEFT", -5, -2)
						_G[chatFrame .. "EditBox"]:SetPoint("RIGHT", _G[chatFrame .. "ResizeButton"], "RIGHT", 3, 0)
					end
				end
			end)

			-- Set local saved variables version
			nameSpace.UI.Reloads["HideChatButtons"] = true

			-- Make sure clamping is called when changes are made to the icons
			if zAddonDB.Chat.ClampChat then Options.clampChatFrame(zAddonDB.Chat.ClampChat) end
		end
		
		-- Toggle reload button and show a reload UI message
		nameSpace.UI.reloadCheck()
	end

	-- Hide social button and quick join toast
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.hideSocialButton(state)

		if state then

			-- Create Hidden Frame To Store Social Button
			local hiddenFrame = CreateFrame("FRAME")
			hiddenFrame:Hide()
			QuickJoinToastButton:SetParent(hiddenFrame)
		else

			QuickJoinToastButton:SetParent(UIParent)
		end 
	end

	-- Disable chat fading after time
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.disableChatFade(state)

		if state then

			-- Loop through chat windows
			for i = 1, 50 do
				if _G["ChatFrame" .. i] then
					_G["ChatFrame" .. i]:SetFading(false)
				end
			end
		else

			-- Loop through chat windows
			for i = 1, 50 do
				if _G["ChatFrame" .. i] then
					_G["ChatFrame" .. i]:SetFading(true)
				end
			end
		end
	end

	-- Enable class colors in chat
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.chatClassColors(state)

		if state then

			-- Enable chat class colors
			SetCVar("chatClassColorOverride", "0")
		else

 			-- Disable chat class colors
			SetCVar("chatClassColorOverride", "1")
		end
	end

	-- Clamp chat to the edge of the screen
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.clampChatFrame(state)

		if state then

			-- Loop through chat windows
			for i = 1, NUM_CHAT_WINDOWS do

				if zAddonDB.Chat.HideChatButtons and zAddonDB.Chat.ChatTopBox then
					_G["ChatFrame" .. i]:SetClampRectInsets(-3, 52, 60, -8)
				elseif zAddonDB.Chat.HideChatButtons then
					_G["ChatFrame" .. i]:SetClampRectInsets(-3, 52, 60, -32)
				elseif zAddonDB.Chat.ChatTopBox then
					_G["ChatFrame" .. i]:SetClampRectInsets(-36, 58, 60, -8)
				else 
					_G["ChatFrame" .. i]:SetClampRectInsets(-36, 58, 60, -33)
				end

				_G["ChatFrame" .. i]:SetMaxResize(UIParent:GetWidth(), UIParent:GetHeight())
				_G["ChatFrame" .. i]:SetMinResize(350, 150)
			end

			-- Process new chat frames and combat log
			hooksecurefunc("FloatingChatFrame_UpdateBackgroundAnchors", function(self)
				self:SetClampRectInsets(-34, 34, 60, -32)
			end)

			-- Process temporary chat frames
			hooksecurefunc("FCF_OpenTemporaryWindow", function()

				local chatFrame = FCF_GetCurrentChatFrame():GetName() or nil

				if chatFrame then
					_G[chatFrame]:SetClampRectInsets(-34, 34, 60, -32)
				end
			end)
		else

			-- Loop through chat windows
			for i = 1, NUM_CHAT_WINDOWS do
				_G["ChatFrame" .. i]:SetClampRectInsets(-35, 35, 50, -50)
			end

			-- Process temporary chat frames
			hooksecurefunc("FCF_OpenTemporaryWindow", function()

				local chatFrame = FCF_GetCurrentChatFrame():GetName() or nil

				if chatFrame then
					_G[chatFrame]:SetClampRectInsets(-35, 35, 50, -50)
				end
			end)
		end
	end

	-- Moves the chat editbox to the top
	-- Require reload on diable
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.moveChatEditbox(state)

		if state then

			-- Loop through chat windows
			for i = 1, 50 do

				if _G["ChatFrame" .. i] then

					-- Position the editbox, based on HideChatButtons option
					if(nameSpace.UI.Reloads["HideChatButtons"]) then

						_G["ChatFrame" .. i .. "EditBox"]:SetPoint("TOPLEFT", _G["ChatFrame" .. i], "TOPLEFT", 0, 0)
						_G["ChatFrame" .. i .. "EditBox"]:SetPoint("RIGHT", _G["ChatFrame" .. i .. "ResizeButton"], "RIGHT", -3, 0)
					else

						_G["ChatFrame" .. i .. "EditBox"]:ClearAllPoints()
						_G["ChatFrame" .. i .. "EditBox"]:SetPoint("TOPLEFT", _G["ChatFrame" .. i], 0, 0)
					end

					_G["ChatFrame" .. i .. "EditBox"]:SetWidth(_G["ChatFrame" .. i]:GetWidth())

					-- Make sure the editbox match the chat size frame
					_G["ChatFrame" .. i]:HookScript("OnSizeChanged", function()

						_G["ChatFrame" .. i .. "EditBox"]:SetWidth(_G["ChatFrame" .. i]:GetWidth())
					end)
				end
			end

			-- Process temporary chat frames
			hooksecurefunc("FCF_OpenTemporaryWindow", function()

				local chatFrame = Fcf_GetCurrentChatFrame():GetName() or nil

				if chatFrame then

					-- Position the editbox, based on HideChatButtons option
					if(nameSpace.UI.Reloads["HideChatButtons"]) then

						_G[chatFrame .. "EditBox"]:SetPoint("TOPLEFT", chatFrame, "TOPLEFT", 0, 0)
						_G[chatFrame .. "EditBox"]:SetPoint("RIGHT", _G[chatFrame .. "ResizeButton"], "RIGHT", -3, 0)
					else

						_G["ChatFrame" .. i .. "EditBox"]:ClearAllPoints()
						_G[chatFrame .. "EditBox"]:SetPoint("TOPLEFT", chatFrame, 0, 0)
					end

					_G[chatFrame .. "EditBox"]:SetWidth(_G[chatFrame]:GetWidth())

					-- Make sure the editbox match the chat size frame
					_G[chatFrame]:HookScript("OnSizeChanged", function()

						_G[chatFrame .. "EditBox"]:SetWidth(_G[chatFrame]:GetWidth())
					end)
				end
			end)
		else

			-- Loop through chat windows
			for i = 1, 50 do

				if _G["ChatFrame" .. i] then

					-- Position the editbox, based on HideChatButtons option
					if(nameSpace.UI.Reloads["HideChatButtons"]) then

						_G["ChatFrame" .. i .. "EditBox"]:SetPoint("TOPLEFT", _G["ChatFrame" .. i], "BOTTOMLEFT", -5, -2)
						_G["ChatFrame" .. i .. "EditBox"]:SetPoint("RIGHT", _G["ChatFrame" .. i .. "ResizeButton"], "RIGHT", 3, 0)
					else

						_G["ChatFrame" .. i .. "EditBox"]:SetPoint("TOPLEFT", _G["ChatFrame" .. i], "BOTTOMLEFT", -5, -2)
						_G["ChatFrame" .. i .. "EditBox"]:SetPoint("RIGHT", _G["ChatFrame" .. i].ScrollBar, "RIGHT", 5, 0)
					end

					_G["ChatFrame" .. i .. "EditBox"]:SetWidth(_G["ChatFrame" .. i]:GetWidth())

					-- Make sure the editbox match the chat size frame
					_G["ChatFrame" .. i]:HookScript("OnSizeChanged", function()

						_G["ChatFrame" .. i .. "EditBox"]:SetWidth(_G["ChatFrame" .. i]:GetWidth())
					end)
				end
			end

			-- Process temporary chat frames
			hooksecurefunc("FCF_OpenTemporaryWindow", function()

				local chatFrame = Fcf_GetCurrentChatFrame():GetName() or nil

				if chatFrame then

					-- Position the editbox, based on HideChatButtons option
					if(nameSpace.UI.Reloads["HideChatButtons"]) then

						_G[chatFrame .. "EditBox"]:SetPoint("TOPLEFT", chatFrame, "BOTTOMLEFT", -5, -2)
						_G[chatFrame .. "EditBox"]:SetPoint("RIGHT", _G[chatFrame .. "ResizeButton"], "RIGHT", 3, 0)
					else

						_G[chatFrame .. "EditBox"]:SetPoint("TOPLEFT", chatFrame, "BOTTOMLEFT", -5, -2)
						_G[chatFrame .. "EditBox"]:SetPoint("RIGHT", chatFrame.ScrollBar, "RIGHT", 5, 0)
					end

					_G[chatFrame .. "EditBox"]:SetWidth(_G[chatFrame]:GetWidth())

					-- Make sure the editbox match the chat size frame
					_G[chatFrame]:HookScript("OnSizeChanged", function()

						_G[chatFrame .. "EditBox"]:SetWidth(_G[chatFrame]:GetWidth())
					end)
				end
			end)
		end

		-- Call clamping since the chat window size changed
		if zAddonDB.Chat.ClampChat then Options.clampChatFrame(zAddonDB.Chat.ClampChat) end

		-- Toggle reload button and show a reload UI message
		nameSpace.UI.reloadCheck()
	end

	-- Enable copying hyperlinks in chat
	-- Require reload on diable
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.enableURLCopy(state)

		if state then 

			local find = string.find
			local gsub = string.gsub
			local found = false

			-- Color the found URL
			local function colorURL(text, url)

				-- Set as found
				found = true

				return ' |H'..'url'..':'..tostring(url)..'|h'..'|cff0099FF'..tostring(url)..'|h|r '
			end

			-- Scan URL
			local function scanURL(frame, text, ...)

				found = false

				if (find(text:upper(), "%pTINTERFACE%p+")) then
					found = true
				end

				-- 192.168.2.1:1234
				if (not found) then
					text = gsub(text, '(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)(%s?)', colorURL)
				end

				-- 192.168.2.1
				if (not found) then
					text = gsub(text, '(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?)(%s?)', colorURL)
				end

				-- www.url.com:3333
				if (not found) then
					text = gsub(text, '(%s?)([%w_-]+%.?[%w_-]+%.[%w_-]+:%d%d%d?%d?%d?)(%s?)', colorURL)
				end

				-- http://www.google.com
				if (not found) then
					text = gsub(text, "(%s?)(%a+://[%w_/%.%?%%=~&-'%-]+)(%s?)", colorURL)
				end

				-- www.google.com
				if (not found) then
					text = gsub(text, "(%s?)(www%.[%w_/%.%?%%=~&-'%-]+)(%s?)", colorURL)
				end

				-- url@domain.com
				if (not found) then
					text = gsub(text, '(%s?)([_%w-%.~-]+@[_%w-]+%.[_%w-%.]+)(%s?)', colorURL)
				end

				frame.add(frame, text,...)
			end

			local function copyURL()

				for _, frame in pairs(CHAT_FRAMES) do

					local chatFrame = _G[frame]

					if (chatFrame and not chatFrame.hasURLCopy and (chatFrame ~= 'ChatFrame2')) then

						chatFrame.add = chatFrame.AddMessage
						chatFrame.AddMessage = scanURL
						chatFrame.hasURLCopy = true
					end
				end
			end

			hooksecurefunc("FCF_OpenTemporaryWindow", copyURL)

			local orig = ChatFrame_OnHyperlinkShow

			function ChatFrame_OnHyperlinkShow(frame, link, text, button)

				local type, value = link:match('(%a+):(.+)')

				if (type == "url") then

					local editBox = _G[frame:GetName().."EditBox"]

					if (editBox) then

						editBox:Show()
						editBox:SetText(value)
						editBox:SetFocus()
						editBox:HighlightText()
					end
				else

					orig(self, link, text, button)
				end
			end

			copyURL()

			-- Set local saved variables version
			nameSpace.UI.Reloads["ChatURLCopy"] = true
		end
		
		-- Toggle reload button and show a reload UI message
		nameSpace.UI.reloadCheck()
	end

	-- Enable using arrow keys in chat box
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.enableChatArrowKeys(state)

		if state then

			-- Enable arrow keys
			for i = 1, 50 do

				if _G["ChatFrame" .. i] then
					_G["ChatFrame" .. i .. "EditBox"]:SetAltArrowKeyMode(false)
				end
			end

			-- Enable arrow keys for temporary chat frames
			hooksecurefunc("FCF_OpenTemporaryWindow", function()

				local cf = FCF_GetCurrentChatFrame():GetName() or nil
				if cf then
					_G[cf .. "EditBox"]:SetAltArrowKeyMode(false)
				end
			end)
		else

			-- Disable arrow keys
			for i = 1, 50 do

				if _G["ChatFrame" .. i] then
					_G["ChatFrame" .. i .. "EditBox"]:SetAltArrowKeyMode(true)
				end
			end

			-- Disable arrow keys for temporary chat frames
			hooksecurefunc("FCF_OpenTemporaryWindow", function()

				local cf = FCF_GetCurrentChatFrame():GetName() or nil
				if cf then
					_G[cf .. "EditBox"]:SetAltArrowKeyMode(true)
				end
			end)
		end
	end

	-- Enable mouse scrolling on chat history
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.enableChatMouseScroll(state)

		if state then

			SetCVar("chatMouseScroll", "1")
		else
			
			SetCVar("chatMouseScroll", "0")
		end 
	end

-- ==================================================================================================
-- Minimap Functions
-- ==================================================================================================

	-- Hides minimap zone header and map button
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.hideMinimapZoneBorder(state)

		if state then

			MinimapBorderTop:Hide()
			MiniMapWorldMapButton:Hide()
			MinimapZoneText:SetPoint("CENTER", Minimap, 0, 80)
		else

			MinimapBorderTop:Show()
			MiniMapWorldMapButton:Show()
			MinimapZoneText:SetPoint("CENTER", MinimapZoneTextButton, 0, 0)
		end
	end

	-- Hides minimap zoom buttons
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.hideMinimapZoomButtons(state)

		if state then

			MinimapZoomIn:Hide()
			MinimapZoomOut:Hide()
		else

			MinimapZoomIn:Show()
			MinimapZoomOut:Show()
		end
	end

	-- Hides minimap calendar
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.hideMinimapCalendar(state)

		if state then

			GameTimeFrame:Hide()
			GameTimeFrame:UnregisterAllEvents()
			GameTimeFrame.Show = kill
		else

			GameTimeFrame:Show()
		end
	end

	-- Hide minimap tracking button
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.hideMinimapTracking(state)

		if state then

			MiniMapTracking:Hide()
			MiniMapTracking.Show = kill
		else

			MiniMapTracking:Show()
		end
	end

	-- Hide cinimap clock
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.hideMinimapClock(state)

		-- Toggle clock if timeManager addon is loaded
		if IsAddOnLoaded("Blizzard_TimeManager") then

			if state then

				TimeManagerClockButton:Hide()
			else

				TimeManagerClockButton:Show()
			end
		else

			-- Wait for timeManager addon to load
			local waitFrame = CreateFrame("FRAME")
			waitFrame:RegisterEvent("ADDON_LOADED")

			waitFrame:SetScript("OnEvent", function(self, event, arg1)
				if arg1 == "Blizzard_TimeManager" then
					
					if state then

						TimeManagerClockButton:Hide()
					else

						TimeManagerClockButton:Show()
					end

					-- Unregister event
					waitFrame:UnregisterAllEvents()
				end
			end)
		end
	end

	-- Enable minimap mouse wheel zoom
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.minimapZoomShortcut(state)

		if state then

			Minimap:EnableMouseWheel(true)
			Minimap:SetScript("OnMouseWheel", function(self, delta)

				if delta > 0 then
					Minimap_ZoomIn()
				else
					Minimap_ZoomOut()
				end
			end)
		else

			Minimap:EnableMouseWheel(false)
		end
	end

	-- Enable opening minimap calendar on right click
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.minimapCalendarShortcut(state)

		if state then

			Minimap:SetScript("OnMouseUp", function(self, btn)

				if btn == "MiddleButton" and zAddonDB.Minimap.MinimapTrackingShortcut == true then
					ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self)
				elseif btn == "RightButton" and zAddonDB.Minimap.MinimapCalendarShortcut == true then
					GameTimeFrame:Click()
				else
					Minimap_OnClick(self)
				end
			end)
		end
	end

	-- Enable opening minimap tracking on middle mouse click
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.minimapTrackingShortcut(state)

		if state then

			Minimap:SetScript("OnMouseUp", function(self, btn)

				if btn == "MiddleButton" and zAddonDB.Minimap.MinimapTrackingShortcut == true then
					ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self)
				elseif btn == "RightButton" and zAddonDB.Minimap.MinimapCalendarShortcut == true then
					GameTimeFrame:Click()
				else
					Minimap_OnClick(self)
				end
			end)
		end
	end

	-- Set Minimap Scale
	-- 
	-- @param Float value: Incoming slider value
	function Options.setMinimapScale(value)

		MinimapCluster:SetScale(value)
	end

-- ==================================================================================================
-- Inventory Functions
-- ==================================================================================================

	-- Enable faster auto loot
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.enableFastLooting(state)

		if state then	

			-- Time delay
			local tDelay = 0

			-- Fast loot function
			local function fastLooting()

				if GetTime() - tDelay >= 0.3 then

					tDelay = GetTime()
					if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then

						for i = GetNumLootItems(), 1, -1 do
							LootSlot(i)
						end

						tDelay = GetTime()
					end
				end
			end

			-- Event frame
			zFrames["fasterLootFrame"] = CreateFrame("Frame")
			zFrames["fasterLootFrame"]:RegisterEvent("LOOT_READY")
			zFrames["fasterLootFrame"]:SetScript("OnEvent", fastLooting)
		else

			if zFrames["fasterLootFrame"] then
				zFrames["fasterLootFrame"]:UnregisterAllEvents()
			end
		end
	end

	-- Set inserted items order in bags
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.setInsertedItemsDirection(state)

		SetInsertItemsLeftToRight(state)
	end

	-- Set sort bags direction
	-- Reverse state to make default unselected to sort from riight to left
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.setSortBagsDirection(state)

		SetSortBagsRightToLeft(not state)
	end

	-- Add sell junk button to merchant
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.sellJunk(state)

		if state then

			-- Add "Sell Junk" buttons to merchant frame
			nameSpace.UI:createButton(MerchantFrame, "SellJunkBtn", 80, 28, {"TOPLEFT", 65, -28}, false, "Sell Junk", nil, "Auto sell all junk.")
			nameSpace.Widgets.Button["SellJunkBtn"]:SetScript("OnClick", function()

				local limit = 0
				local total = 0
				local max = 12

				-- Looping through bags and items
				for bag = 0, 4 do
					for slot = 1, GetContainerNumSlots(bag) do

						local item = GetContainerItemLink(bag, slot)

	  					if item then

	  						-- Checking for grey items
	  						local greyItem = string.find(item, "|cff9d9d9d")

	  						if greyItem then

	      						-- Get price
	      						currPrice = (select(11, GetItemInfo(item)) or 0) * select(2, GetContainerItemInfo(bag, slot))

	      						-- Checking if the item can be sold to a vendor
	      						if currPrice > 0 then

									total = total + currPrice

	      							-- Sell items
						            PickupContainerItem(bag, slot)
						            PickupMerchantItem()

						            -- Print sold items info
						            print("|cff69ccf0 zAddon:|r Sold"..": "..item.."     " .. GetMoneyString(currPrice))

						            -- Set limit to sold items
						            limit = limit + 1
						            if limit == max then break end
	      						end

	  						end
	  					end
					end
				end

				-- Printing total gold made
				print("\n|cff69ccf0 zAddon:|r Total Gained"..": "..GetMoneyString(total))
			end)
		else

			if nameSpace.Widgets.Button["SellJunkBtn"] then

				-- Hide "Sell Junk" button
				nameSpace.Widgets.Button["SellJunkBtn"]:Hide()
				nameSpace.Widgets.Button["SellJunkBtn"] = nil
			end
		end
	end

	-- Auto repair gear when visiting a merchant
	-- Also override the auto repait by pressing the shift key
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.addAutoRepair(state)

		if state then

			local repairFrame = zFrames["autoRepairFrame"] or CreateFrame("FRAME")
			zFrames["autoRepairFrame"] = repairFrame
			repairFrame:RegisterEvent("MERCHANT_SHOW")
			repairFrame:SetScript("OnEvent", function (self, event, ...)

				if event == "MERCHANT_SHOW" then

					-- Return if shift key is pressed
					if IsShiftKeyDown() then return end

					-- Merchant can repair
					if CanMerchantRepair() then

						-- Get repair cost
						local repairCost, canRepair = GetRepairAllCost()

						if canRepair then

							if GetMoney() >= repairCost then

								-- Repair all items
								RepairAllItems()

								-- Show cost summary
								print("|cff69ccf0 zAddon:|r Repaired For"..": "..GetMoneyString(repairCost))
							end
						end
					end
				end
			end)
		else

			-- Unregister the event
			if zFrames["autoRepairFrame"] then

				zFrames["autoRepairFrame"]:UnregisterEvent("MERCHANT_SHOW")
			end
		end
	end

	-- Hide item's crafter name from tooltip
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.hideCraftedItemName(state)

		if state then

			_G.ITEM_CREATED_BY = ""
		else

			_G.ITEM_CREATED_BY = "|cff00ff00<Made by %s>|r"
		end
	end

-- ==================================================================================================
-- Frames Functions
-- ==================================================================================================

	-- Enhance dress up frame by adding a nude button to remove all gear
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.enhanceDressUp(state)

		if state then

			-- Add nude button to the main dress up frame
			nameSpace.UI:createButton(DressUpFrame, "DressUpNudeBtn", 80, 22, {"BOTTOMLEFT", 106, 79}, false, "Nude", nil, "")
			nameSpace.Widgets.Button["DressUpNudeBtn"]:SetFrameLevel(3)
			nameSpace.Widgets.Button["DressUpNudeBtn"]:ClearAllPoints()
			nameSpace.Widgets.Button["DressUpNudeBtn"]:SetPoint("RIGHT", DressUpFrameResetButton, "LEFT", 0, 0)
			nameSpace.Widgets.Button["DressUpNudeBtn"]:SetScript("OnClick", function()

				-- Perform a reset click
				DressUpFrameResetButton:Click()

				-- Remove all alots
				DressUpFrame.ModelScene:GetPlayerActor():Undress()
	
			end)
		else

			if nameSpace.Widgets.Button["DressUpNudeBtn"] then

				-- Hide main dress up button
				nameSpace.Widgets.Button["DressUpNudeBtn"]:Hide()
				nameSpace.Widgets.Button["DressUpNudeBtn"] = nil
			end
		end
	end

	-- Set the scale of main dress up frame
	-- 
	-- @param Floar value: Incoming slider value
	function Options.setDressUpScale(value)

		DressUpFrame:SetScale(value)
	end

	-- Class color for player unit frame background
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.colorPlayerFrame(state)

		if state then

			-- Create background frame for player frame
			local playerFrame = CreateFrame("FRAME", nil, PlayerFrame)
			zFrames["ClassColorPlayer"] = playerFrame

			playerFrame:SetWidth(TargetFrameNameBackground:GetWidth())
			playerFrame:SetHeight(TargetFrameNameBackground:GetHeight())

			local void, void, void, x, y = TargetFrameNameBackground:GetPoint()
			playerFrame:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", -x, y)

			playerFrame.texture = playerFrame:CreateTexture(nil, "BORDER")
			playerFrame.texture:SetAllPoints()
			playerFrame.texture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-LevelBackground")

			-- Set color
			local color = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
			playerFrame.texture:SetVertexColor(color.r, color.g, color.b)
		else

			if zFrames["ClassColorPlayer"] then
				zFrames["ClassColorPlayer"]:Hide()
			end
		end
	end

	-- Class Color for target unit frame background
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.colorTargetFrame(state)

		if state then

			-- Color function
			local function colorFrame()

				if UnitIsPlayer("target") then
					local color = RAID_CLASS_COLORS[select(2, UnitClass("target"))]
					TargetFrameNameBackground:SetVertexColor(color.r, color.g, color.b)
				end
			end

			-- Create target frame
			local targetFrame = CreateFrame("FRAME")
			zFrames["ClassColorTarget"] = targetFrame
			targetFrame:SetScript("OnEvent", colorFrame)

			-- Register events
			targetFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
			targetFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
			targetFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")
			targetFrame:RegisterEvent("UNIT_FACTION")

			-- Set color
			colorFrame()
		else

			-- Reset colors
			if zFrames["ClassColorTarget"] then
				zFrames["ClassColorTarget"]:UnregisterAllEvents()
			end

			TargetFrame_CheckFaction(TargetFrame)
		end
	end

	-- Class color for focus frame background
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.colorFocusFrame(state)

		if state then

			-- Color function
			local function colorFrame()

				if UnitIsPlayer("focus") then
					local color = RAID_CLASS_COLORS[select(2, UnitClass("focus"))]
					FocusFrameNameBackground:SetVertexColor(color.r, color.g, color.b)
				end
			end

			-- Create target frame
			local focusFrame = CreateFrame("FRAME")
			zFrames["ClassColorFocus"] = focusFrame
			focusFrame:SetScript("OnEvent", colorFrame)

			-- Refresh color if focus frame size changes
			hooksecurefunc("FocusFrame_SetSmallSize", function()

				if nameSpace.Widgets.CheckBox["ColorFocusFrame"]:GetChecked() then

					-- Set color
					colorFrame()
				end
			end)

			-- Register events
			focusFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
			focusFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
			focusFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")
			focusFrame:RegisterEvent("UNIT_FACTION")
						
			-- Set color
			colorFrame()
		else

			-- Reset colors
			if zFrames["ClassColorFocus"] then
				zFrames["ClassColorFocus"]:UnregisterAllEvents()
			end

			TargetFrame_CheckFaction(FocusFrame)
		end
	end

	-- Show aligning grid to help with positioning
	-- This function isn't called on addon startup and is always false
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.showAligningGrid(state)

		if state then

			zFrames["aligningGridFrame"] = CreateFrame("Frame", nil, UIParent)
			zFrames["aligningGridFrame"]:SetAllPoints(UIParent)

			local w = GetScreenWidth() / 64
			local h = GetScreenHeight() / 36

			for i = 0, 64 do
				local sub = zFrames["aligningGridFrame"]:CreateTexture(nil, "BACKGROUND")
				if i == 32 then
					sub:SetColorTexture(1, 0, 0, 0.5)
				else
					sub:SetColorTexture(0, 0, 0, 0.5)
				end
				sub:SetPoint("TOPLEFT", zFrames["aligningGridFrame"], "TOPLEFT", i * w - 1, 0)
				sub:SetPoint("BOTTOMRIGHT", zFrames["aligningGridFrame"], "BOTTOMLEFT", i * w + 1, 0)
			end

			for i = 0, 36 do
				local sub = zFrames["aligningGridFrame"]:CreateTexture(nil, "BACKGROUND")
				if i == 18 then
					sub:SetColorTexture(1, 0, 0, 0.5)
				else
					sub:SetColorTexture(0, 0, 0, 0.5)
				end
				sub:SetPoint("TOPLEFT", zFrames["aligningGridFrame"], "TOPLEFT", 0, -i * h + 1)
				sub:SetPoint("BOTTOMRIGHT", zFrames["aligningGridFrame"], "TOPRIGHT", 0, -i * h - 1)
			end
		else

			if zFrames["aligningGridFrame"] then
				zFrames["aligningGridFrame"]:Hide()
				zFrames["aligningGridFrame"] = nil
			end
		end
	end

	-- Resets frames position to default values from config file
	--
	-- @param Table frameTable: Table containing all the draggable frames
	local function resetFrames(frameTable)

		-- Loading frames default values
		local defaults = nameSpace.Config.DB.Frames.Frames

		-- Enable buff frame reset flag
		zFrames["ResetBuffFlag"] = true

		-- Replace frame movement function
		local setBuffPos = BuffFrame.SetPoint

		for k,v in pairs(frameTable) do

			local frameName = v:GetName()

			v:SetMovable(true)
			v:ClearAllPoints()

			if frameName == "BuffFrame" then

				setBuffPos(BuffFrame, defaults[frameName]["Point"], 
					UIParent, defaults[frameName]["Relative"], 
					defaults[frameName]["XOffset"], 
					defaults[frameName]["YOffset"]
				)
			else

				v:SetPoint(defaults[frameName]["Point"], UIParent, 
					defaults[frameName]["Relative"], 
					defaults[frameName]["XOffset"], 
					defaults[frameName]["YOffset"]
				)
			end

			v:SetScale(defaults[frameName]["Scale"])
		end

		-- Set combo frame scale to default
		ComboFrame:SetScale(defaults["TargetFrame"]["Scale"])

		--Set temporary enchant frame scale to default
		TemporaryEnchantFrame:SetScale(defaults["BuffFrame"]["Scale"])

		-- Disable Reset Flag
		zFrames["ResetBuffFlag"] = false
	end

	-- Create and show drag frames and handle frame dragging and scaling
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.showDragFrames(state)

		-- Create frame table
		local frameTable = {
			DragPlayerFrame = PlayerFrame, 
			DragTargetFrame = TargetFrame, 
			DragFocusFrame = FocusFrame, 
			DragBuffFrame = BuffFrame, 
			DragUIWidgetTopCenterContainerFrame = UIWidgetTopCenterContainerFrame, 
			DragGhostFrame = GhostFrame, 
			DragMirrorTimer1 = MirrorTimer1
		}

		if state then 

			-- Load frames from addon DB
			local framesDB = zAddonDB["Frames"]["Frames"]

			-- Save frames positions
			local function saveFrames()

				for k, v in pairs(frameTable) do

					local frameName = v:GetName()

					-- Stop frames from Moving
					v:StopMovingOrSizing()

					-- Save frame positions
					framesDB[frameName]["Point"], void, framesDB[frameName]["Relative"], framesDB[frameName]["XOffset"], framesDB[frameName]["YOffset"] = v:GetPoint()
					
					if frameName == "PlayerFrame" or frameName == "TargetFrame" then
						_G[frameName]:SetUserPlaced(true)
					else
						_G[frameName]:SetUserPlaced(false)
					end
				end
			end

			-- Create drag frame
			local function createDragFrame(dFrame, rFrame)

				local dragFrame = CreateFrame("Frame", nil, nil, "BackdropTemplate")
				zFrames[dFrame] = dragFrame

				-- Buff frame
				if dFrame == "DragBuffFrame" then

					dragFrame:SetPoint("TOPRIGHT", BuffFrame, "TOPRIGHT", 0, 2.5)
					rFrame:SetClampedToScreen(true)
				else

					dragFrame:SetPoint("TOP", rFrame, "TOP", 0, 2.5)
					rFrame:SetClampedToScreen(false)
				end

				dragFrame:SetBackdrop({ 
					edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
					tile = false,
					tileSize = 0,
					edgeSize = 5,
					insets = { left = 0, right = 0, top = 0, bottom = 0 }})
				dragFrame:SetBackdropColor(0.0, 0.5, 1.0)
				dragFrame:SetBackdropBorderColor(0.0, 0.0, 0)
				dragFrame:SetToplevel(true)

				-- Hide the drag frame and make real frame moveable
				dragFrame:Hide()
				rFrame:SetMovable(true)

				-- Drag frame texture
				dragFrame.texture = dragFrame:CreateTexture()
				dragFrame.texture:SetAllPoints()
				dragFrame.texture:SetColorTexture(0.0, 0.5, 1.0, 0.5)
				dragFrame.texture:SetAlpha(0.5)

				-- Drage frame font
				dragFrame.font = dragFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
				dragFrame.font:SetPoint("CENTER", 0, 0)

				-- Drag frame click handler
				dragFrame:SetScript("OnMouseDown", function(self, btn)

					-- Start dragging on left click
					if btn == "LeftButton" then
						rFrame:StartMoving()
					end

					-- Set all drag frames to blue the tint the selected frame to green
					for k, v in pairs(frameTable) do
						zFrames[k].texture:SetColorTexture(0.0, 0.5, 1.0, 0.5)
					end

					dragFrame.texture:SetColorTexture(0.0, 1.0, 0.0, 0.5)

					-- Set current frame variable to selected frame and set the scale slider value
					zFrames["currentFrame"] = rFrame:GetName()

					local currentFrame = zFrames["currentFrame"]

					nameSpace.Widgets.Slider["FramesScale"]:SetValue(framesDB[currentFrame]["Scale"])
				end)

				dragFrame:SetScript("OnMouseUp", function()

					-- Save frames position
					saveFrames()
				end)

				-- Add drag frames titles
				if rFrame:GetName() == "PlayerFrame" then dragFrame.font:SetText("Player") end
				if rFrame:GetName() == "TargetFrame" then dragFrame.font:SetText("Target") end
				if rFrame:GetName() == "FocusFrame" then dragFrame.font:SetText("Focus") end
				if rFrame:GetName() == "BuffFrame" then dragFrame.font:SetText("Buffs") end
				if rFrame:GetName() == "UIWidgetTopCenterContainerFrame" then dragFrame.font:SetText("World State") end
				if rFrame:GetName() == "MirrorTimer1" then dragFrame.font:SetText("Timer") end
				if rFrame:GetName() == "GhostFrame" then dragFrame.font:SetText("Ghost") end

				-- Return the drag frame
				return dragFrame
			end

			-- Scale slider on change event
			nameSpace.Widgets.Slider["FramesScale"]:HookScript("OnValueChanged", function(self, value)

				local currentFrame = zFrames["currentFrame"]

				-- If a frame is selected
				if zFrames["currentFrame"] then

					-- Set real frame and drag frame scale
					framesDB[currentFrame]["Scale"] = value
					_G[currentFrame]:SetScale(framesDB[currentFrame]["Scale"])
					zFrames["Drag" .. currentFrame]:SetScale(framesDB[currentFrame]["Scale"])

					-- Change combo point frame scale if target frame scale changes
					if currentFrame == "TargetFrame" then
						ComboFrame:SetScale(framesDB["TargetFrame"]["Scale"])
					end

					-- Change temporary enchant frame Scale if buff frame scale changes
					if currentFrame == "BuffFrame" then
						TemporaryEnchantFrame:SetScale(framesDB["BuffFrame"]["Scale"])
					end

					-- Set slider formatted text
					nameSpace.Widgets.Slider["FramesScale"].value:SetFormattedText("%.0f%%", nameSpace.Widgets.Slider["FramesScale"]:GetValue() * 100)
				end
			end)

			-- Set initial scale slider state and value
			nameSpace.Widgets.Slider["FramesScale"]:HookScript("OnShow", function()

				local currentFrame = zFrames["currentFrame"]

				-- No frame selected
				if not currentFrame then

					-- Select player frame
					zFrames["currentFrame"] = PlayerFrame:GetName()
					zFrames["DragPlayerFrame"].texture:SetColorTexture(0.0, 1.0, 0.0,0.5)
				end

				local currentFrame = zFrames["currentFrame"]

				-- Set scale slider value to the selected frame
				nameSpace.Widgets.Slider["FramesScale"]:SetValue(framesDB[currentFrame]["Scale"])

				-- Set slider formatted text
				nameSpace.Widgets.Slider["FramesScale"].value:SetFormattedText("%.0f%%", nameSpace.Widgets.Slider["FramesScale"]:GetValue() * 100)
			end)

			-- Create one instance of the drag frames
			for k,v in pairs(frameTable) do

				if zFrames[k]  == nil then
					zFrames[k] = createDragFrame(k,v)
				end
			end

			-- Find out the UI scale
			local gScale

			if GetCVar("useuiscale") == "1" then
				gScale = GetCVar("uiscale")
			else
				gScale = 1
			end

			-- Set drag frames size and scale
			for k,v in pairs(frameTable) do

				local frameName = v:GetName()

				zFrames[k]:SetScale(framesDB[frameName]["Scale"])
				zFrames[k]:SetWidth(v:GetWidth() * gScale)
				zFrames[k]:SetHeight(v:GetHeight() * gScale)
			end

			-- Set specific scaled sizes for some frames
			zFrames["DragBuffFrame"]:SetSize(280 * gScale, 225 * gScale)
			zFrames["DragUIWidgetTopCenterContainerFrame"]:SetSize(300 * gScale, 50 * gScale)
			zFrames["DragMirrorTimer1"]:SetSize(206 * gScale, 50 * gScale)
			zFrames["DragGhostFrame"]:SetSize(130 * gScale, 46 * gScale)

			-- Show drag frames
			for k, void in pairs(frameTable) do

				zFrames[k]:Show()
			end

			-- Hide and show slider to fire on show event
			nameSpace.Widgets.Slider["FramesScale"]:Hide()
			nameSpace.Widgets.Slider["FramesScale"]:Show()
		else
			-- Hide drag frames
			for k, void in pairs(frameTable) do
				if zFrames[k] then zFrames[k]:Hide() end
			end

			-- Reset current frame variable
			zFrames["currentFrame"] = nil

			-- Reset created drag frame
			for k, void in pairs(frameTable) do
				zFrames[k] = nil
			end

			-- Set initial slider value (Will change when a drag frame is selected)
	 		nameSpace.Widgets.Slider["FramesScale"]:SetValue(1.00)
		end 
	end

	-- Enables frame editting Mode
	-- Loads all previous values from saved variables when enabled and reset the frames when disableChatFade
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.enableFramesMode(state)

		-- Create frame table
		local frameTable = {
			DragPlayerFrame = PlayerFrame, 
			DragTargetFrame = TargetFrame, 
			DragFocusFrame = FocusFrame, 
			DragBuffFrame = BuffFrame, 
			DragUIWidgetTopCenterContainerFrame = UIWidgetTopCenterContainerFrame, 
			DragGhostFrame = GhostFrame, 
			DragMirrorTimer1 = MirrorTimer1
		}

		if state then

			-- Load frames from addon DB
			local framesDB = zAddonDB["Frames"]["Frames"]

			-- Lock player and target frame
			PlayerFrame_SetLocked(true)
			TargetFrame_SetLocked(true)

			-- Remove integrated movement functions to avoid conflicts
			_G.PlayerFrame_ResetUserPlacedPosition = function() end
			_G.TargetFrame_ResetUserPlacedPosition = function() end
			_G.PlayerFrame_SetLocked = function() end
			_G.TargetFrame_SetLocked = function() end

			-- Replace frame movement function
			local setBuffPos = BuffFrame.SetPoint

			-- Prevent changes to buff frame position
			hooksecurefunc(BuffFrame, "SetPoint", function()

				BuffFrame:ClearAllPoints()

				if zFrames["ResetBuffFlag"] then

					-- Loading buff frame frames default values
					local defaults = nameSpace.Config.DB["Frames"]["Frames"]

					setBuffPos(BuffFrame, defaults["BuffFrame"]["Point"], UIParent, 
						defaults["BuffFrame"]["Relative"], 
						defaults["BuffFrame"]["XOffset"], 
						defaults["BuffFrame"]["YOffset"]
					)
				else

					setBuffPos(BuffFrame, framesDB["BuffFrame"]["Point"], UIParent, 
						framesDB["BuffFrame"]["Relative"], 
						framesDB["BuffFrame"]["XOffset"], 
						framesDB["BuffFrame"]["YOffset"]
					)
				end
			end)

			-- Load default values
			resetFrames(frameTable)

			-- Set frame scale from saved values
			for k, v in pairs(frameTable) do

				local frameName = v:GetName()

				_G[frameName]:SetScale(framesDB[frameName]["Scale"])
			end

			-- Set combo frame scale
			ComboFrame:SetScale(framesDB["TargetFrame"]["Scale"])

			-- Set temporary enchant frame scale
			TemporaryEnchantFrame:SetScale(framesDB["BuffFrame"]["Scale"])

			-- Load saved values from saved variables
			for k, v in pairs(frameTable) do

				local frameName = v:GetName()

				if frameName == "PlayerFrame" or frameName == "TargetFrame" then
					_G[frameName]:SetUserPlaced(true)
				else
					_G[frameName]:SetUserPlaced(false)
				end

				_G[frameName]:ClearAllPoints()

				if frameName == "BuffFrame" then

					setBuffPos(BuffFrame, framesDB[frameName]["Point"], UIParent, 
						framesDB[frameName]["Relative"], 
						framesDB[frameName]["XOffset"], 
						framesDB[frameName]["YOffset"]
					)
				else

					_G[frameName]:SetPoint(framesDB[frameName]["Point"], UIParent, 
						framesDB[frameName]["Relative"], 
						framesDB[frameName]["XOffset"], 
						framesDB[frameName]["YOffset"]
					)
				end
			end

			-- Reset button on click handler
			nameSpace.Widgets.Button["FramePosReset"]:SetScript("OnClick", function()

				-- Load default values
				resetFrames(frameTable)

				-- Save the default frame data to saved variables
				for k, v in pairs(frameTable) do

					local frameName = v:GetName()

					framesDB[frameName]["Point"], void, framesDB[frameName]["Relative"], framesDB[frameName]["XOffset"], framesDB[frameName]["YOffset"] = _G[frameName]:GetPoint()
					framesDB[frameName]["Scale"] = 1.00
					
					-- Reset drag frame scales
					if zFrames[k] then
						zFrames[k]:SetScale(framesDB[frameName]["Scale"])
					end
				end

				-- Set initial slider value
				nameSpace.Widgets.Slider["FramesScale"]:SetValue(1.00)
			end)

			-- Prevent changes during combat
			local events = CreateFrame("Frame")
			events:RegisterEvent("PLAYER_REGEN_DISABLED")
			events:SetScript("OnEvent", function()

				-- Disable drag function
				Options.showDragFrames(false)

				-- Uncheck the drag frames button
				nameSpace.Widgets.CheckBox["FramesGrid"]:SetChecked(false)
			end)

			-- Variable to store currently selected frame
			local currentFrame
			zFrames["currentFrame"] = currentFrame

			-- Set initial slider value (Will changed when a drag frame is selected)
			nameSpace.Widgets.Slider["FramesScale"]:SetValue(1.00)
		else

			-- Disable drag function
			Options.showDragFrames(false)

			-- Uncheck the drag button
			nameSpace.Widgets.CheckBox["FramesGrid"]:SetChecked(false)

			-- Reset frames to default
			resetFrames(frameTable)
		end
	end

	-- Needed empty function for scale slider
	-- 
	-- @param Floar value: Incoming slider value
	function Options.framesScaleFunc(value)
	end

-- ==================================================================================================
-- Extra Functions
-- ==================================================================================================

	-- Hides action bar gryphons
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.hideGryphons(state)

		if state then

			MainMenuBarArtFrame.LeftEndCap:Hide()
			MainMenuBarArtFrame.RightEndCap:Hide()
		else

			MainMenuBarArtFrame.LeftEndCap:Show()
			MainMenuBarArtFrame.RightEndCap:Show()
		end
	end

	-- Hides Legion's top order hall bar
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.hideOrderHallBar(state)

		if state then

			-- Toggle order hall bar if Blizzard addon is loaded
			if IsAddOnLoaded("Blizzard_OrderHallUI") then

				OrderHallCommandBar:SetScript("OnShow", function()
					OrderHallCommandBar:Hide()
				end)
			else

				-- Wait for order hall addon to load
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")

				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_OrderHallUI" then
						
						OrderHallCommandBar:SetScript("OnShow", function()
							OrderHallCommandBar:Hide()
						end)

						-- Unregister Event
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

		end
		
		-- Toggle reload button and show a reload UI message
		nameSpace.UI.reloadCheck()
	end

	-- Always collapse objectives tracker
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.collapseObjectives(state)

		if state then
			
			ObjectiveTracker_Collapse()
		end
	end

	-- Disable reading emote when viewing the map
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.disableMapEmote(state)

		if state then

			hooksecurefunc("DoEmote", function(emote)

				if emote == "READ" and WorldMapFrame:IsShown() then
					CancelEmote()
				end
			end)

			-- Set local saved variables version
			nameSpace.UI.Reloads["NoMapEmote"] = true
		end
		
		-- Toggle reload button and show a reload UI message
		nameSpace.UI.reloadCheck()
	end

	-- Display character enabled addons on addons menu by default
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.charAddonsList(state)

		if state then

			if AddonCharacterDropDown and AddonCharacterDropDown.selectedValue then

				AddonCharacterDropDown.selectedValue = UnitName("player");
				AddonCharacterDropDownText:SetText(UnitName("player"))
			end

			-- Set local saved variables version
			nameSpace.UI.Reloads["CharAddonsList"] = true
		end
		
		-- Toggle reload button and show a reload UI message
		nameSpace.UI.reloadCheck()
	end

-- ==================================================================================================
-- Setting Functions
-- ==================================================================================================

	-- Toggle addon's minimap button.
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Options.toggleMinimapButton(state)

		if state then

			if nameSpace.UI.minimapBtn then

				-- Show minimap button if it exist
				nameSpace.UI.minimapBtn:Show()
			else

				-- Create it if it doesn't exist
				nameSpace.UI.showMinimapButton()
			end
		else

			-- Hide minimap button
			nameSpace.UI.minimapBtn:Hide()
		end
	end

	-- Set addon's frame scale.
	-- Doesn't need to be called on addon's startup
	--
	-- @param Number value: Addon scale value
	function Options.setAddonScale(value)
		
		_G["zAddonGlobalPanel"]:SetScale(value)
	end

	-- Set addon's frame opacity.
	-- Doesn't need to be called on addon's startup
	--
	-- @param Number value: Addon opacity value
	function Options.setAddonOpacity(value)
		
		_G["zAddonGlobalPanel"].header.texture:SetAlpha(value)
		_G["zAddonGlobalPanel"].sideMenu.texture:SetAlpha(value)
		_G["zAddonGlobalPanel"].body.texture:SetAlpha(value)
	end

	-- Completely reset addon to default.
	function Options.resetAddon()
		
		zAddonDB = nameSpace.Config.DB
		zAddonCharDB = nameSpace.Config.CharDB
	end
