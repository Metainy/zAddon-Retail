-- Addon's namespace
local zAddon, nameSpace = ...

-- Adding tables to addon's namespace
nameSpace.UI		= {}
nameSpace.Widgets	= {
	Button 		= {},
	CheckBox 	= {},
	Slider 		= {},
	EditBox 	= {},
	DropDown 	= {},
	ColorPicker = {},
	Text 		= {}
}

-- Creating namespace tables
local UI 		= nameSpace.UI
local Widgets 	= nameSpace.Widgets

-- Creating local tables
local zPanel = {}
local zMenus = {}
local zPages = {}

-- Loading library and default UI configuration
local UIConfig 	= nameSpace.Config.UI
local UIContent = nameSpace.Config.Content

-- ==================================================================================================
-- Components Reload
-- ==================================================================================================

	-- Load a local version of saved variables that require UI reload.
	-- Used to compare local version with the DB version to check if any changes has been made
	-- Should be called before adding components to the UI
	local function reloadSavedVariables()

		-- Will contain saved variables field which require UI reload
		UI.Reloads = {}

		-- Chat
		UI.Reloads["HideChatButtons"] = zAddonDB.Chat.HideChatButtons
		UI.Reloads["ChatTopBox"] = zAddonDB.Chat.ChatTopBox
		UI.Reloads["ChatURLCopy"] = zAddonDB.Chat.ChatURLCopy

		-- Skins
		UI.Reloads["StyleBuffs"] = zAddonDB.Skins.Buffs.StyleBuffs
		UI.Reloads["StyleAuras"] = zAddonDB.Skins.Auras.StyleAuras
		UI.Reloads["StyleAuraCast"] = zAddonDB.Skins.AuraCast.StyleAuraCast
		UI.Reloads["StyleActionButtons"] = zAddonDB.Skins.ActionButtons.StyleActionButtons
		UI.Reloads["StyleExtraButton"] = zAddonDB.Skins.ExtraButton.StyleExtraButton
		UI.Reloads["StyleBags"] = zAddonDB.Skins.Bags.StyleBags
		UI.Reloads["StylePetButtons"] = zAddonDB.Skins.PetButtons.StylePetButtons
		UI.Reloads["StyleStanceButtons"] = zAddonDB.Skins.StanceButtons.StyleStanceButtons
		UI.Reloads["StylePossessButtons"] = zAddonDB.Skins.PossessButtons.StylePossessButtons
		UI.Reloads["StyleLeaveButton"] = zAddonDB.Skins.LeaveButton.StyleLeaveButton
		UI.Reloads["StyleMainBar"] = zAddonDB.Skins.MainBar.StyleMainBar
		UI.Reloads["StyleChatFrame"] = zAddonDB.Skins.ChatFrame.StyleChatFrame
		UI.Reloads["StyleTooltip"] = zAddonDB.Skins.Tooltip.StyleTooltip

		-- Extra
		UI.Reloads["HideOrderHallBar"] = zAddonDB.Extra.HideOrderHallBar
		UI.Reloads["NoMapEmote"] = zAddonDB.Extra.NoMapEmote
		UI.Reloads["CharAddonsList"] = zAddonDB.Extra.CharAddonsList
	end

	-- Check for options that require UI reload.
	-- Toggle reload button and show a reload UI message
	-- Compare the local version of some options with the DB version to check if any changes have been made
	-- Being used in option function enabled or disabled state, depending on when the reload is required
	function UI:reloadCheck()

		-- Setting condition for fields that require reload on both enabled and disabled state, or just the disabled state
		if (UI.Reloads["ChatTopBox"] ~= zAddonDB.Chat.ChatTopBox and zAddonDB.Chat.ChatTopBox == false)
		or (UI.Reloads["ChatURLCopy"] ~= zAddonDB.Chat.ChatURLCopy and zAddonDB.Chat.ChatURLCopy == false)
		or (UI.Reloads["HideChatButtons"] ~= zAddonDB.Chat.HideChatButtons and zAddonDB.Chat.HideChatButtons == false)

		or (UI.Reloads["StyleBuffs"] ~= zAddonDB.Skins.Buffs.StyleBuffs and zAddonDB.Skins.Buffs.StyleBuffs == false)
		or (UI.Reloads["StyleAuras"] ~= zAddonDB.Skins.Auras.StyleAuras and zAddonDB.Skins.Auras.StyleAuras == false)
		or (UI.Reloads["StyleAuraCast"] ~= zAddonDB.Skins.AuraCast.StyleAuraCast and zAddonDB.Skins.AuraCast.StyleAuraCast == false)
		or (UI.Reloads["StyleActionButtons"] ~= zAddonDB.Skins.ActionButtons.StyleActionButtons and zAddonDB.Skins.ActionButtons.StyleActionButtons == false)
		or (UI.Reloads["StyleExtraButton"] ~= zAddonDB.Skins.ExtraButton.StyleExtraButton and zAddonDB.Skins.ExtraButton.StyleExtraButton == false)
		or (UI.Reloads["StyleBags"] ~= zAddonDB.Skins.Bags.StyleBags and zAddonDB.Skins.Bags.StyleBags == false)
		or (UI.Reloads["StylePetButtons"] ~= zAddonDB.Skins.PetButtons.StylePetButtons and zAddonDB.Skins.PetButtons.StylePetButtons == false)
		or (UI.Reloads["StyleStanceButtons"] ~= zAddonDB.Skins.StanceButtons.StyleStanceButtons and zAddonDB.Skins.StanceButtons.StyleStanceButtons == false)
		or (UI.Reloads["StylePossessButtons"] ~= zAddonDB.Skins.PossessButtons.StylePossessButtons and zAddonDB.Skins.PossessButtons.StylePossessButtons == false)
		or (UI.Reloads["StyleLeaveButton"] ~= zAddonDB.Skins.LeaveButton.StyleLeaveButton and zAddonDB.Skins.LeaveButton.StyleLeaveButton == false)
		or (UI.Reloads["StyleMainBar"] ~= zAddonDB.Skins.MainBar.StyleMainBar and zAddonDB.Skins.MainBar.StyleMainBar == false)
		or (UI.Reloads["StyleChatFrame"] ~= zAddonDB.Skins.ChatFrame.StyleChatFrame and zAddonDB.Skins.ChatFrame.StyleChatFrame == false)
		or (UI.Reloads["StyleTooltip"] ~= zAddonDB.Skins.Tooltip.StyleTooltip and zAddonDB.Skins.Tooltip.StyleTooltip == false)

		or (UI.Reloads["HideOrderHallBar"] ~= zAddonDB.Extra.HideOrderHallBar)
		or (UI.Reloads["NoMapEmote"] ~= zAddonDB.Extra.NoMapEmote and zAddonDB.Extra.NoMapEmote == false)
		or (UI.Reloads["CharAddonsList"] ~= zAddonDB.Extra.CharAddonsList and zAddonDB.Extra.CharAddonsList == false)
		then

			-- Enable reload button
			Widgets.Button["reloadUIBtn"]:Enable()

			-- Show reload UI warning
			Widgets.Text["reloadText"]:Show()
		else
			
			-- Disable reload button
			Widgets.Button["reloadUIBtn"]:Disable()

			-- Hide reload UI warning
			Widgets.Text["reloadText"]:Hide()
		end
	end

-- ==================================================================================================
-- Components Locks
-- ==================================================================================================

	-- Lock widgets based on other widgets state or options.
	-- Filter widget types and enable or disable them based on their dependency state
	--
	-- @param Boolean 	condition:		The condition which other items depends on
	-- @param Array 	items:			Array of widget's names which require option to be enabled
	-- @param Boolean 	requireReload:	Boolean indicating if this option needs a reload to be active
	local function lockOption(condition, items, requireReload)

		-- Check if the parent button that child widgets depend on is checked
		if condition then

			-- Loop through and enable all childs
			for i = 1, #items do

				if Widgets.CheckBox[items[i]] then

					Widgets.CheckBox[items[i]]:Enable()
					Widgets.CheckBox[items[i]]:SetAlpha(1)
				elseif Widgets.Slider[items[i]] then

					Widgets.Slider[items[i]]:Enable()
					Widgets.Slider[items[i]]:SetAlpha(1)
				elseif Widgets.EditBox[items[i]] then

					Widgets.EditBox[items[i]]:Enable()
					Widgets.EditBox[items[i]]:SetAlpha(1)
				elseif Widgets.DropDown[items[i]] then

					Widgets.DropDown[items[i]].dropDownBtn:Enable()
					Widgets.DropDown[items[i]]:SetAlpha(1)
				elseif Widgets.ColorPicker[items[i]] then

					Widgets.ColorPicker[items[i]]:Enable()
					Widgets.ColorPicker[items[i]]:SetAlpha(1)
				end
			end
		else

			-- Loop through and disable all childs
			for i = 1, #items do

				if Widgets.CheckBox[items[i]] then

					Widgets.CheckBox[items[i]]:Disable()
					Widgets.CheckBox[items[i]]:SetAlpha(.5)
				elseif Widgets.Slider[items[i]] then

					Widgets.Slider[items[i]]:Disable()
					Widgets.Slider[items[i]]:SetAlpha(.5)
				elseif Widgets.EditBox[items[i]] then

					Widgets.EditBox[items[i]]:Disable()
					Widgets.EditBox[items[i]]:SetAlpha(.5)
				elseif Widgets.DropDown[items[i]] then

					Widgets.DropDown[items[i]].dropDownBtn:Disable()
					Widgets.DropDown[items[i]]:SetAlpha(.5)
				elseif Widgets.ColorPicker[items[i]] then

					Widgets.ColorPicker[items[i]]:Disable()
					Widgets.ColorPicker[items[i]]:SetAlpha(.5)
				end
			end
		end
	end

	-- Set widgets which require othet widgets or options to be on.
	-- Some widgets are only available when another widgets is turned on
	function UI:setWidgetLocks()

		-- Frames
		lockOption(Widgets.CheckBox["MoveFramesMode"]:GetChecked(), {"FramesGrid", "FramesScale"}, false)
		lockOption(Widgets.CheckBox["FramesGrid"]:GetChecked(), {"FramesScale"}, false)
		print("Health ", Widgets.CheckBox["HealthBar"]:GetChecked())
		-- Health bar
		lockOption(Widgets.CheckBox["HealthBar"]:GetChecked(), 
			{
				"HPSmoothBar", "IncomingHeals", "AbsorbBar",
				"HPClassColored", "HPBarColor", "HPBarTexture", "HPLowColor",
 				"HPWidth", "HPHeight", "HPX", "HPY",
 				"HPShowText",
 				"PetBar", "PetBarText",
 				"HPInactiveOpacity", "HPActiveOpacity", "HPDeadOpacity", "HPLossOpacity"
			}, 
			false
		)

		-- Health bar: Appearance
		lockOption(not Widgets.CheckBox["HPClassColored"]:GetChecked() and Widgets.CheckBox["HPClassColored"]:IsEnabled() , {"HPBarColor"}, false)
		lockOption(Widgets.CheckBox["HPLowColor"]:GetChecked() and Widgets.CheckBox["HPLowColor"]:IsEnabled(), {"HPLowThreshold", "HPBarColorLow"}, false)

		-- Health bar: Health Status
		lockOption(Widgets.CheckBox["HPShowText"]:GetChecked() and Widgets.CheckBox["HPShowText"]:IsEnabled(), 
			{"HPShortNumber", "HPFontFamily", "HPFontSize", "HPFontX", "HPFontY", "HPFontColor"}, 
			false
		)

		-- Health bar: Pet Bar
		-- lockOption(nameSpace.Resources.playerHavePet(), {"PetBar", "PetBarText"}, false)
		-- lockOption(Widgets.CheckBox["PetBar"]:GetChecked() and Widgets.CheckBox["PetBar"]:IsEnabled(), {"PetBarColor"}, false)
 
		-- Power bar
		lockOption(Widgets.CheckBox["PowerBar"]:GetChecked(), 
			{
				"BPSmooth", "PBPrediction", "AutoAttackBar",
				"PBCustomColor", "PBTexture", "EnablePBLowColor", "EnablePBHighColor",
				"PBWidth", "PBHeight", "PBX", "PBY",
				"PBShowText",
 				"PBInactiveOpacity", "PBActiveOpacity", "PBDeadOpacity", "PBLossOpacity"
			}, 
			false
		)

		-- Power bar: Functionality 
		lockOption(nameSpace.Resources.predictionAllowed() and Widgets.CheckBox["PowerBar"]:GetChecked(), {"PBPrediction"}, false)

		-- Power bar: Appearance
		lockOption(Widgets.CheckBox["PBCustomColor"]:GetChecked() and Widgets.CheckBox["PBCustomColor"]:IsEnabled() , {"PBBarColor"}, false)
		lockOption(Widgets.CheckBox["EnablePBLowColor"]:GetChecked() and Widgets.CheckBox["EnablePBLowColor"]:IsEnabled(), {"PBLowThreshold", "PBLowColor"}, false)
		lockOption(Widgets.CheckBox["EnablePBHighColor"]:GetChecked() and Widgets.CheckBox["EnablePBHighColor"]:IsEnabled(), {"PBHighThreshold", "PBHighColor"}, false)

		-- Power bar: Power Status
		lockOption(Widgets.CheckBox["PBShowText"]:GetChecked() and Widgets.CheckBox["PBShowText"]:IsEnabled(), 
			{"PowerShortNumber", "PBFontFamily", "PBFontSize", "BPFontX", "BPFontY", "PBFontColor"}, 
			false
		)
	end

-- ==================================================================================================
-- Saved Variables Utility Functions
-- ==================================================================================================

	-- Get saved variable value.
	-- Retrieve saved variables which are located in categories and sub-categories
	-- Also check if this group is a part of global saved variables or character saved variables
	--
	-- @param String 	name:		Saved variable field name
	-- @param Array 	category:	Array containing saved variable categories
	--
	-- @return Object value: Saved variable current value
	local function getSavedVariableState(name, category)

		-- Temporary value to hold DB type
		local DB = zAddonDB

		-- Check DB type, if it's a category which being saved in character DB
		if category[1] == "HealthBar" or category[1] == "PowerBar" or category[1] == "AltPowerBar" then

			DB = zAddonCharDB
		end

		-- Retrieve saved variable value
		local value

		-- Get the value from nested saved variables
		if #category == 1 then
			value = DB[category[1]][name]
		elseif #category == 2 then
			value = DB[category[1]][category[2]][name]
		elseif #category == 3 then
			value = DB[category[1]][category[2]][category[3]][name]
		elseif #category == 4 then
			value = DB[category[1]][category[2]][category[3]][category[4]][name]
		end

		-- Clear DB value
		DB = nil

		-- Return found value
		return value
	end

	-- Set saved variable value.
	-- Save the new saved variables value which are located in categories and sub-categories
	-- Also check if this group is a part of global saved variables or character saved variables
	--
	-- @param String 	name:		Saved variable field name
	-- @param Array 	category:	Array containing saved variable categories
	-- @param Object 	value:		New value to be saved
	local function setSavedVariableState(name, category, value)

		-- Temporary value to hold DB type
		local DB = zAddonDB

		-- Check DB type, if it's a category which being saved in character DB
		if category[1] == "HealthBar" or category[1] == "PowerBar" or category[1] == "AltPowerBar" then

			DB = zAddonCharDB
		end

		-- Set new value in nested saved variables
		if #category == 1 then
			DB[category[1]][name] = value
		elseif #category == 2 then
			DB[category[1]][category[2]][name] = value
		elseif #category == 3 then
			DB[category[1]][category[2]][category[3]][name] = value
		elseif #category == 4 then
			DB[category[1]][category[2]][category[3]][category[4]][name] = value
		end

		-- Clear DB value
		DB = nil
	end

-- ==================================================================================================
-- UI Utility Functions
-- ==================================================================================================

	-- Toggle addon frame visibility.
	-- Show addon frame if hidden or hide it if it's already visible
	-- Navigate to last opened page
	function UI.toggleAddonFrame()

		-- Show addon frame if hidden or hide it if it's already visible
		zPanel:SetShown(not zPanel:IsShown())

		-- Show recent page
		zPages[zAddonDB.UI.StartPage]:Show()
	end

	-- Hides addon's pages.
	-- Hides scroll frame pages
	local function hidePages()

		-- Hide all menu pages
		for i = 0, UIContent.Addon.PagesNumber do

			if zPages["Page"..i] then

				zPages["Page"..i]:Hide()
			end
		end
	end

	-- Refresh addon's pages.
	-- Show and hide all pages, to invoke widget's onShow event
	local function refreshPages()

		zPanel:Show()

		-- Go through all pages
		for i = 0, UIContent.Addon.PagesNumber do

			-- if zPages["Page"..i] ~= zPages[zAddonDB.UI.StartPage] then
				
				if zPages["Page"..i] then 
					zPages["Page" .. i]:Show()
					zPages["Page" .. i]:Hide()
				-- end
			end
		end

		zPanel:Hide()
	end

	-- Shows addon's memory usage
	--
	-- @param FontString fontString: A FontString object to write the usage into on each update
	local function getMemoryUsage(fontString) 

		-- Create frame
		local memoryFrame = CreateFrame("FRAME")

		local usage = 0

		-- Create update script
		local memoryTime = -1

		memoryFrame:SetScript("OnUpdate", function(self, elapsed)

			if memoryTime > 2 or memoryTime == -1 then

				UpdateAddOnMemoryUsage()
				usage = GetAddOnMemoryUsage("zAddon")
				usage = math.floor(usage + .5) .. " KB"
				fontString:SetText(usage)
				memoryTime = 0
			end

			memoryTime = memoryTime + elapsed
		end)
	end

	-- Show a custom tooltip.
	-- Shows a custom tooltip for created components
	-- 
	-- @param Frame self: Refrence for the component
	local function showTooltip(self)

		-- Disable tooltip if the component is disabled
		if not self:IsEnabled() then return end

		GameTooltip:SetOwner(self, "ANCHOR_NONE")

		local parent = zPanel
		local pScale = parent:GetEffectiveScale()
		local gScale = UIParent:GetEffectiveScale()
		local tScale = GameTooltip:GetEffectiveScale()
		local gap = ((UIParent:GetRight() * gScale) - (parent:GetRight() * pScale))

		if gap < (250 * tScale) then
			GameTooltip:SetPoint("BOTTOMRIGHT", parent, "BOTTOMLEFT", 0, 0)
		else
			GameTooltip:SetPoint("BOTTOMLEFT", parent, "BOTTOMRIGHT", 0, 0)
		end

		GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true)
	end

	-- Show addon's minimap button
	-- This function gets called if the user has turned this option on
	function UI.showMinimapButton()
		
		-- Create minimap button
		local minimapBtn = CreateFrame("Button", nil, Minimap)
		UI.minimapBtn = minimapBtn
		minimapBtn:SetFrameStrata("MEDIUM")
		minimapBtn:SetSize(31, 31)
		minimapBtn:RegisterForClicks("AnyUp")
		minimapBtn:SetMovable(true)
		minimapBtn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

		-- Create button border overlay
		local btnOverlay = minimapBtn:CreateTexture(nil, "OVERLAY")
		btnOverlay:SetSize(53, 53)
		btnOverlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
		btnOverlay:SetPoint("TOPLEFT")

		-- Create button background
		local btnBG = minimapBtn:CreateTexture(nil, "BACKGROUND")
		btnBG:SetSize(20, 20)
		btnBG:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
		btnBG:SetPoint("TOPLEFT", 6, -5)

		-- Create button icon
		local btnIcon = minimapBtn:CreateTexture(nil, "ARTWORK")
		btnIcon:SetSize(17, 17)
		btnIcon:SetTexture(UIConfig.MinimapButton.Icon)
		btnIcon:SetPoint("CENTER", 0, 0)

		-- Add mouse click effect
		minimapBtn:HookScript("OnMouseDown", function()

			btnIcon:SetSize(15, 15)
		end)

		minimapBtn:HookScript("OnMouseUp", function()

			btnIcon:SetSize(17, 17)
		end)

		minimapBtn:HookScript("OnReceiveDrag", function()

			btnIcon:SetSize(17, 17)
		end)
		
		minimapBtn:HookScript("OnLeave", function()

			btnIcon:SetSize(17, 17)
		end)
		
		-- Set button position
		minimapBtn:ClearAllPoints()
		minimapBtn:SetPoint("TOPLEFT", Minimap,"TOPLEFT", 55 - (77 * cos(zAddonDB.UI.MinimapIconPos)), (77 * sin(zAddonDB.UI.MinimapIconPos)) - 55)

		-- Show custom minimap button tooltip
		minimapBtn:SetScript("OnEnter", function()

			GameTooltip:SetOwner(minimapBtn, "ANCHOR_NONE")

			-- Position the tooltip
			local x, y = minimapBtn:GetCenter()
			local hHalf = (x > UIParent:GetWidth() * 2 / 3) and "RIGHT" or (x < UIParent:GetWidth()/3) and "LEFT" or ""
			local vHalf = (y > UIParent:GetHeight() / 2) and "TOP" or "BOTTOM"
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint(vHalf .. hHalf, minimapBtn, (vHalf == "TOP" and "BOTTOM" or "TOP") .. hHalf)

			-- Add tooltip lines
			GameTooltip:SetText("zBars", nil, nil, nil, nil, true)
			GameTooltip:AddLine("Toggle Options Panel.", 1, 1, 1, 1)

			-- Show the tooltip
			GameTooltip:Show()
		end)

		minimapBtn:SetScript("OnLeave", GameTooltip_Hide)

		-- Update minimap button position and save the new position
		local function updatePosition()

			local Xpoa, Ypoa = GetCursorPosition()
			local Xmin, Ymin = Minimap:GetLeft(), Minimap:GetBottom()

			Xpoa = Xmin - Xpoa / Minimap:GetEffectiveScale() + 70
			Ypoa = Ypoa / Minimap:GetEffectiveScale() - Ymin - 70

			zAddonDB.UI.MinimapIconPos = math.deg(math.atan2(Ypoa, Xpoa))

			minimapBtn:ClearAllPoints()
			minimapBtn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 55 - (77 * cos(zAddonDB.UI.MinimapIconPos)), (77 * sin(zAddonDB.UI.MinimapIconPos)) - 55)
		end

		-- Handle minimap button drag event
		minimapBtn:RegisterForDrag("LeftButton")
		minimapBtn:SetScript("OnDragStart", function()

			-- Move minimap button on drag start
			minimapBtn:StartMoving()
			minimapBtn:SetScript("OnUpdate", updatePosition)
		end)

		minimapBtn:SetScript("OnDragStop", function()

			-- Stop the drag and update the button position
			minimapBtn:StopMovingOrSizing()
			minimapBtn:SetUserPlaced(true)
			minimapBtn:SetScript("OnUpdate", nil)
			updatePosition()
		end)

		-- Handle minimap button click event
		minimapBtn:SetScript("OnClick", function(self, button)

			-- Prevent options panel from showing if blizzard options panel is active
			-- if InterfaceOptionsFrame:IsShown() or VideoOptionsFrame:IsShown() or ChatConfigFrame:IsShown() then return end

			-- Left mouse button
			if button == "LeftButton" then

				-- Toggle addon's frame
				UI.toggleAddonFrame()
			end
		end)
	end

	-- Hide scroll bar button.
	-- Hides the up and down button for scroll bar
	local function hideScrollButtons()

		-- Hide up button
		UIParentScrollBarScrollUpButton:GetNormalTexture():ClearAllPoints()
		UIParentScrollBarScrollUpButton:GetDisabledTexture():ClearAllPoints()
		UIParentScrollBarScrollUpButton:GetHighlightTexture():ClearAllPoints()
		UIParentScrollBarScrollUpButton:GetPushedTexture():ClearAllPoints()
		UIParentScrollBarScrollUpButton:GetNormalTexture():Hide()
		UIParentScrollBarScrollUpButton:GetDisabledTexture():Hide()
		UIParentScrollBarScrollUpButton:GetHighlightTexture():Hide()
		UIParentScrollBarScrollUpButton:GetPushedTexture():Hide()

		-- Hide down button
		UIParentScrollBarScrollDownButton:GetNormalTexture():ClearAllPoints()
		UIParentScrollBarScrollDownButton:GetDisabledTexture():ClearAllPoints()
		UIParentScrollBarScrollDownButton:GetHighlightTexture():ClearAllPoints()
		UIParentScrollBarScrollDownButton:GetPushedTexture():ClearAllPoints()
		UIParentScrollBarScrollDownButton:GetNormalTexture():Hide()
		UIParentScrollBarScrollDownButton:GetDisabledTexture():Hide()
		UIParentScrollBarScrollDownButton:GetHighlightTexture():Hide()
		UIParentScrollBarScrollDownButton:GetPushedTexture():Hide()
	end

	-- Handle mouse scrolling.
	-- Used in scroll frame OnMouseWheel event to handle mouse scrolling
	-- 
	-- @param Frame 	self:	Self
	-- @param Number 	delta: 	Number indicating the direction of the wheel spinning
	local function scrollHandler(self, delta)

		local newValue = self:GetVerticalScroll() - (delta * 20)

		if (newValue < 0) then

			newValue = 0
		elseif (newValue > self:GetVerticalScrollRange()) then

			newValue = self:GetVerticalScrollRange()
		end

		self:SetVerticalScroll(newValue)

		-- Hide scroll bar up and down buttons
		hideScrollButtons()
	end

-- ==================================================================================================
-- Components Helper Functions
-- ==================================================================================================

	-- Create textures.
	-- Create custom textures and attach them to a frame
	-- 
	-- @param Frame 	parent: The parent frame which texture should be attached to
	-- @param String 	art: 	Texture art
	-- @param Array 	color: 	An array of RGBA color
	-- 
	-- @return Texture texture: The newely created texture
	local function createTexture(parent, art, color)

		local texture = parent:CreateTexture(nil, "BACKGROUND")
		texture:SetTexture(art)
		texture:SetVertexColor(unpack(color))
		texture:SetAllPoints(parent)

		return texture
	end

	-- Create textures.
	-- Create a color textures and attach them to a frame
	-- 
	-- @param Frame 	parent: The parent frame which texture should be attached to
	-- @param Array 	color: 	An array of RGBA color
	-- 
	-- @return Texture texture: The newely created texture
	local function createColorTexture(parent, color)

		local texture = parent:CreateTexture(nil, "ARTWORK")
		texture:SetColorTexture(unpack(color))
		texture:SetAllPoints(parent)

		return texture
	end

	-- Create a font string.
	-- Create custom font string attached on a parent frame
	-- 
	-- @param Frame 	parent: 	The parent frame which font string should be attached to
	-- @param Array 	point: 		Array containing frame's anchor points
	-- @param Array 	pointAlt: 	Optional alternative anchor point. Can be null
	-- @param String 	font: 		Font type
	-- @param Number 	fontSize:	Font size
	-- @param Array 	fontColor: 	An array of RGBA color
	-- @param String 	label:		The font string label
	-- 
	-- @return FontString text: The newely created font string
	local function createText(parent, point, pointAlt, font, fontSize, fontColor, label)

		local text = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		text:SetPoint(unpack(point))

		-- Check for a secondary anchor points
		if(pointAlt) then
			text:SetPoint(unpack(pointAlt))
		end

		text:SetFont(font, fontSize)
		text:SetTextColor(unpack(fontColor))
		text:SetJustifyH("LEFT")
		text:SetText(label)

		-- Return the text
		return text
	end

	-- Create a line divider.
	-- Create a simple line divider that separate page sections
	--
	-- @param Frame 	parent:	The parent frame which the divider should be attached to
	-- @param Number 	label:	Divider width
	-- @param Number 	x:		Divider X pos
	-- @param Number 	y:		Divider Y pos
	local function createDivider(parent, width, x, y)

		local texture = parent:CreateTexture(nil, "ARTWORK")
		texture:SetTexture(UIConfig.Divider.Texture)
		texture:SetSize(width, 12)
		texture:SetPoint("TOP", parent, "TOP", x, y)
		-- texture:SetVertexColor(0.08, 0.08, 0.08, 1)
		texture:SetVertexColor(0.0, 0.0, 0.0, .3)
	end

	-- Create sub-heading.
	-- Create a heading for page categories
	--
	-- @param Frame 	parent:	The parent frame which text should be attached to
	-- @param Number 	x:		Text X pos
	-- @param Number 	y:		Text Y pos
	-- @param String 	label:	Sub-heading text
	local function createSubHeading(parent, x, y, label)

		local subHeading = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		subHeading:SetFont(UIConfig.Style.PrimaryFont, 12)
		subHeading:SetPoint("TOPLEFT", x, y)
		subHeading:SetText(label)
	end

	-- Create button.
	-- Create a custom button and reskin it
	-- 
	-- @param Frame 	parent:		The parent frame which the button should be attached to
	-- @param String 	name:		Button unique name
	-- @param Number 	width:		Button width, if set to 0 button will have dynamic width
	-- @param Number 	height: 	Button height
	-- @param Array 	point:		Array containing buttons's anchor points
	-- @param Boolean 	reskin:		A boolean indicating if the button should be reskinned
	-- @param String 	label: 		Button title
	-- @param String 	tipText: 	Text that should appear on tooltip when hovering the button
	-- 
	-- @return Frame button: The newely created button
	function UI:createButton(parent, name, width, height, point, reskin, label, onClick, tipText)

		-- Create button frame and setting attributes
		local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
		Widgets.Button[name] = button
		button:SetSize(width, height)
		button:SetPoint(unpack(point))
		button:SetHitRectInsets(0, 0, 0, 0)
		button:SetText(label)

		-- Button label
		button.font = button:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		button.font:SetText(label)

		-- Handle button width
		if width > 0 then
			button:SetWidth(width)
		else
			button:SetWidth(button.font:GetStringWidth() + 20)
		end

		-- Display tooltip text
		button.tooltip = tipText
		button:SetScript("OnEnter", showTooltip)
		button:SetScript("OnLeave", GameTooltip_Hide)

		-- Handle button skinning
		if reskin then

			-- Hides button's default textures
			local function hideButtonTextures()

				button.Left:SetTexture(nil)
				button.Middle:SetTexture(nil)
				button.Right:SetTexture(nil)
				button.Left:Hide()
				button.Middle:Hide()
				button.Right:Hide()
			end

			-- Show custom font instead of default
			button.font:SetPoint("CENTER")
			button.font:SetFont(UIConfig.Style.PrimaryFont, 12)

			-- Hide original text
			button:SetText(nil)

			-- Hide button textures
			button:HookScript("OnShow", hideButtonTextures)

			-- Hide button textures and set default font color
			button:HookScript("OnEnable", function()

				hideButtonTextures()
				button.font:SetTextColor(unpack(UIConfig.Style.AccentColor))
			end)

			-- Hide button textures and set disabled font color
			button:HookScript("OnDisable", function()

				hideButtonTextures()
				button.font:SetTextColor(.5, .5, .5, 1)
			end)

			-- Hide texture and add pressed effect
			button:HookScript("OnMouseDown", function()

				if button:IsEnabled() then
					button.font:SetPoint("CENTER", button, 1, -1)
				end
			end)

			-- Hide texture and remove pressed effect
			button:HookScript("OnMouseUp", function()

				if button:IsEnabled() then
					button.font:SetPoint("CENTER")
				end
			end)
			
			-- Handle hover on enter and leave events
			button:HookScript("OnEnter", function()

				button.font:SetTextColor(unpack(UIConfig.Style.PrimaryColor))
			end)

			button:HookScript("OnLeave", function()

				button.font:SetTextColor(unpack(UIConfig.Style.AccentColor))
			end)

			-- Set custom button textures
			button:SetNormalTexture(UIConfig.Button.Texture)
			button:GetNormalTexture():SetTexCoord(0.5, 1, 0, 1)
			button:GetNormalTexture():SetVertexColor(.75, .75, .75, 1)
			button:SetHighlightTexture(UIConfig.Button.Texture)
			button:GetHighlightTexture():SetTexCoord(0, 0.5, 0, 1)
			button:GetHighlightTexture():SetAlpha(.2)
		end

		-- If on click function is passed
		if onClick then

			button:SetScript("OnClick", function()

				onClick()
			end)
		end

		-- Return the created button
		return button
	end

	-- Create a check button.
	-- Create a custom check button and reskin it
	-- Also sync saved variable state with check buttons and execute associated functions on click
	-- 
	-- @param Frame 	parent:		The page which the check button should be attached to
	-- @param String 	name:		Check button name and also saved variable field name
	-- @param Array 	category: 	Array with saved variable category and sub-categories if they exist
	-- @param Number 	x:			Check button X pos
	-- @param Number 	y:			Check button Y pos
	-- @param String 	label:		Check button title
	-- @param Function 	func:		Function associated with the check button click
	-- @param Boolean 	reload:		A boolean indicating if this function require reload
	-- @param String 	tipText:	Text that should appear on tooltip when hovering the check button
	local function createCheckButton(parent, name, category, x, y, label, reload, func, tipText)

		-- Create check button frame
		local checkBtn = CreateFrame("CheckButton", nil, parent, "ChatConfigCheckButtonTemplate")
		Widgets.CheckBox[name] = checkBtn
		checkBtn:SetPoint("TOPLEFT", x - 3, y)
		checkBtn:SetSize(22, 22)

		-- Create check button text
		checkBtn.text = checkBtn:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		checkBtn.text:SetPoint("LEFT", 25, 0)
		checkBtn.text:SetFont(UIConfig.Style.PrimaryFont, 11)
		checkBtn.text:SetTextColor(unpack(UIConfig.Style.PrimaryColor))
		checkBtn.text:SetJustifyH("LEFT")
		checkBtn.text:SetWordWrap(false)

		-- Display tooltip text
		checkBtn:SetScript("OnEnter", showTooltip)
		checkBtn:SetScript("OnLeave", GameTooltip_Hide)

		-- Add check button font and tooltip based on reload status
		if reload then

			-- Checkbox requires UI reload
			checkBtn.text:SetText(label .. "*")
			checkBtn.tooltip = tipText .. "|n|n* " .. "Requires UI reload."
		else

			-- Checkbox does not require UI reload
			checkBtn.text:SetText(label)
			checkBtn.tooltip = tipText
		end

		-- Check button click radius
		checkBtn:SetHitRectInsets(0, -checkBtn.text:GetStringWidth() + 2, 0, 0);

		-- Darken the check button
		checkBtn:GetNormalTexture():SetVertexColor(.8, .8, .8, 1)
		checkBtn:GetHighlightTexture():SetVertexColor(.8, .8, .8, .9)
		checkBtn:GetPushedTexture():SetVertexColor(.8, .8, .8, 1)
		checkBtn:GetCheckedTexture():SetVertexColor(.8, .8, .8, 1)

		-- Sync check button state with saved variable state
		checkBtn:SetScript("OnShow", function(self)

			if getSavedVariableState(name, category) == true then

				self:SetChecked(true)
			else

				self:SetChecked(false)
			end
		end)

		-- Process check button click
		checkBtn:SetScript("OnClick", function()

			-- Set saved variables state based on the check button state
			if checkBtn:GetChecked() then

				setSavedVariableState(name, category, true)
			else
				setSavedVariableState(name, category, false)
			end

			-- Toggle widgets which are dependant on other widgets state
			UI.setWidgetLocks()

			-- Run the function associated with button click
			func(checkBtn:GetChecked())

			-- Perform a full garbage collection cycle
			collectgarbage("collect")
		end)
	end

	-- Create a slider.
	-- Create a custom slider and execute associated function on value changes
	-- 
	-- @param Frame 	parent:			The page which the slider should be attached to
	-- @param String 	name:			Slider name and also saved variable field name
	-- @param Array 	category:		Array with saved variable category and sub-categories if they exist
	-- @param Number 	x:				Slider X pos
	-- @param Number 	y:				Slider Y pos
	-- @param String 	label:			Slider title
	-- @param Number 	lowValue:		Slider minimum value
	-- @param Number 	highValue:		Slider maximum value
	-- @param Number 	step:			How much the mouse wheel scroll gonna move forward or backward
	-- @param String 	format:			How slider value is displayed
	-- @param Boolean 	isPercentage: 	A boolean indicating if the value should be displayed as a percentage
	-- @param Function 	func:			Function associated with the slider value changes
	-- @param String 	tipText:		Text that should appear on tooltip when hovering the slider
	local function createSlider(parent, name, category, x, y, label, lowValue, highValue, step, format, isPercentage, func, tipText)

		-- Create slider frame
		local slider = CreateFrame("Slider", nil, parent, "OptionsSliderTemplate")
		Widgets.Slider[name] = slider
		slider:SetPoint("TOPLEFT", x, y - 14)
		slider:SetSize(100, 18)
		slider:SetMinMaxValues(lowValue, highValue)
		slider:SetValueStep(step)
		slider:EnableMouseWheel(true)
		slider:SetHitRectInsets(0, 0, 0, 0)

		-- Remove slider low and high text
		slider.Low:SetText("")
		slider.High:SetText("")

		-- Skin the slider
		slider:SetBackdropColor(1, 1, 1, 0.8)
		slider:SetBackdropBorderColor(0.6, 0.6, 0.6, 0.8)
		slider:GetThumbTexture():SetVertexColor(0.7, 0.7, 0.7, 1)

		-- Create slider value text
		slider.value = slider:CreateFontString(nil, "BACKGROUND")
		slider.value:SetPoint("LEFT", slider, "RIGHT", 6, 0)
		slider.value:SetFont(UIConfig.Style.PrimaryFont, 11)
		slider.value:SetTextColor(unpack(UIConfig.Style.PrimaryColor))

		-- Create slider label
		slider.text = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		slider.text:SetPoint("TOPLEFT", parent, x, y)
		slider.text:SetFont(UIConfig.Style.PrimaryFont, 11)
		slider.text:SetTextColor(unpack(UIConfig.Style.AccentColor))
		slider.text:SetText(label)

		-- Display tooltip text
		slider:SetScript("OnEnter", showTooltip)
		slider:SetScript("OnLeave", GameTooltip_Hide)
		slider.tooltip = tipText

		-- Set initial slider value
		slider:SetScript("OnShow", function(self)

			-- Get slider value from saved variables
			self:SetValue(getSavedVariableState(name, category))
		end)

		-- Process value changes
		slider:SetScript("OnValueChanged", function(self, value)

			-- Get the new value
			local value = floor((value - lowValue) / step + 0.5) * step + lowValue

			-- Display the new value
			if isPercentage then
				slider.value:SetFormattedText(format, slider:GetValue() * 100)
			else
				slider.value:SetFormattedText(format, slider:GetValue())
			end

			-- Save the new value to saved variables
			setSavedVariableState(name, category, value)

			-- Run the function associated with slider change
			func(value)
		end)

		-- Process mouse wheel scrolling
		slider:SetScript("OnMouseWheel", function(self, delta)

			if slider:IsEnabled() then

				local step = step * delta
				local value = self:GetValue()

				if step > 0 then
					self:SetValue(min(value + step, highValue))
				else
					self:SetValue(max(value + step, lowValue))
				end
			end
		end)
	end

	-- Create an edit box.
	-- Create a custom edit box and retrieve saved variable values corresponding with the field name and save new ones
	-- Only accept positive integers but can be set to accept negative float numbers
	-- 
	-- @param Frame 	parent:		The page which the edit box should be attached to
	-- @param String 	name:		Edit box name and also saved variable field name
	-- @param Array 	category:	Array with saved variable category and sub-categories if they exist
	-- @param Number 	width:		Edit box width
	-- @param Number 	x:			Edit box X pos
	-- @param Number 	y:			Edit box Y pos
	-- @param String 	label:		Edit box title
	-- @param Boolean 	isNumeric 	Boolean indicating if the edit box can only accept positive numbers
	-- @param Number 	maxChars:	Max characters allowed in the edit box
	-- @param String 	tabField:	The name of the edit box that should be switched to when tab key is pressed
	-- @param Function 	func:		Function associated with the edit box value change
	-- @param String 	tipText:	Text that should appear on tooltip when hovering the edit box
	local function createEditBox(parent, name, category, width, x, y, label, isNumeric, maxChars, tabField, func, tipText)
		
		-- Local storage for the original value of the edit box
		local orgValue

		-- Create edit box frame
		local editBox = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
		Widgets.EditBox[name] = editBox
		editBox:SetSize(width, 22)
		editBox:SetPoint("TOPLEFT", x, y)
		editBox:SetFont(UIConfig.Style.PrimaryFont, 11)
		editBox:SetTextInsets(6, 3, 0, 0)
		editBox:SetTextColor(unpack(UIConfig.Style.PrimaryColor))
		editBox:SetAutoFocus(false)
		editBox:SetMaxLetters(maxChars)
		editBox:SetNumeric(isNumeric)

		-- Remove edit box default textures
		editBox.Left:ClearAllPoints()
		editBox.Right:ClearAllPoints()
		editBox.Middle:ClearAllPoints()

		-- Add editbox border and backdrop
		editBox.texture = CreateFrame("FRAME", nil, editBox, "BackdropTemplate")
		editBox.texture:SetPoint("LEFT", 0, 0)
		editBox.texture:SetSize(editBox:GetWidth(), editBox:GetHeight())
		editBox.texture:SetFrameLevel(editBox:GetFrameLevel() - 1)
		editBox.texture:SetBackdrop(UIConfig.EditBox.Backdrop)
		editBox.texture:SetBackdropColor(unpack(UIConfig.EditBox.BackdropColor))
		editBox.texture:SetBackdropBorderColor(unpack(UIConfig.EditBox.BackdropBorderColor))

		-- Create edit box label
		editBox.text = editBox:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		editBox.text:SetPoint("LEFT", 1, 20)
		editBox.text:SetFont(UIConfig.Style.PrimaryFont, 11)
		editBox.text:SetTextColor(unpack(UIConfig.Style.AccentColor))
		editBox.text:SetText(label)

		editBox:SetScript("OnEnter", showTooltip)
		editBox:SetScript("OnLeave", GameTooltip_Hide)
		editBox.tooltip = tipText

		-- Get saved value and set them when frame is shown
		editBox:SetScript("OnShow", function()
			
			-- Get saved value
			orgValue = getSavedVariableState(name, category)

			-- Display the value
			editBox:SetNumber(orgValue)
		end)

		-- Clear foxus on escape key
		editBox:SetScript("OnEscapePressed", editBox.ClearFocus)

		-- Handle value changes on enter key press
		editBox:SetScript("OnEnterPressed", function(self)

			-- Check if the value is a number
			if tonumber(self:GetText()) then

				local newValue = tonumber(self:GetText())

				-- Set the local storage to the new value
				orgValue = newValue

				-- Save the new value to saved variables
				setSavedVariableState(name, category, newValue)

				-- Run the function associated with the edit box submit
				func(newValue)

				-- Clear focus on valid value
				self:ClearFocus()
			else

				-- Show an error
				self.texture:SetBackdropBorderColor(1, 0, 0, .5)
			end
		end)

		-- Restore original value when focus is lost
		editBox:SetScript("OnEditFocusLost", function(self) 

			-- Remove the error borders
			editBox.texture:SetBackdropBorderColor(unpack(UIConfig.EditBox.BackdropBorderColor))

			-- Display last valid value
			editBox:SetNumber(orgValue)
		end)

		-- Move to next editbox when tab key is pressed
		editBox:SetScript("OnTabPressed", function(self)

			-- Make sure a tab field exist
			if Widgets.EditBox[tabField] then

				self:ClearFocus()
				Widgets.EditBox[tabField]:SetFocus()
			end
		end)
	end

	-- Create a dropdown.
	-- Create a custom dropdown and retrieve saved variable values corresponding with the field name and save new ones
	-- Dropdown list items are populated from a table corresponding with the field name
	-- 
	-- @param Frame 	parent:		The page which the dropdown should be attached to
	-- @param String 	name:		Dropdown name and also saved variable field name
	-- @param Array 	category:	Array with saved variable category and sub-categories if they exist
	-- @param Number 	width:		Dropdown width
	-- @param Number 	x:			Dropdown X pos
	-- @param Number 	y:			Dropdown Y pos
	-- @param String 	label:		Dropdown title
	-- @param Table 	listItems 	A table with the same dropdown name, containing all the dropdown list items
	-- @param Function 	func:		Function associated with the dropdown item selection
	-- @param String 	tipText:	Text that should appear on tooltip when hovering the dropdown
	local function createDropDown(parent, name, category, width, x, y, label, listItems, func, tipText)

		-- Contain the selected item in the list
		local selectedTitle

		-- Local table to contain dropdown items
		local dropDownItems ={}

		-- Create drop down container frame
		local dropDown = CreateFrame("Button", nil, parent)
		Widgets.DropDown[name] = dropDown
		dropDown:SetSize(width, 42)
		dropDown:SetPoint("TOPLEFT", x, y)
		
		-- Create dropdown inner frame
		local innerFrame = CreateFrame("Frame", nil, dropDown)
		innerFrame:ClearAllPoints()
		innerFrame:SetPoint("TOPLEFT", 0, -20)
		innerFrame:SetSize(width, 30)

		-- Create dropdown textures
		local leftTexture = innerFrame:CreateTexture(nil, "ARTWORK")
		leftTexture:SetTexture(UIConfig.DropDown.Texture)
		leftTexture:SetTexCoord(0.01171875, 0.1953125, 0, 1)
		leftTexture:SetPoint("TOPLEFT", innerFrame, 0, 17)
		leftTexture:SetSize(25, 45)
		leftTexture:SetVertexColor(unpack(UIConfig.DropDown.DropDownColor))

		local rightTexture = innerFrame:CreateTexture(nil, "BORDER")
		rightTexture:SetTexture(UIConfig.DropDown.Texture)
		rightTexture:SetTexCoord(0.3671875, 0.5625, 0, 1)
		rightTexture:SetPoint("TOPRIGHT", innerFrame, 0, 17)
		rightTexture:SetSize(25, 45)
		rightTexture:SetVertexColor(unpack(UIConfig.DropDown.DropDownColor))

		local middleTexture = innerFrame:CreateTexture(nil, "BORDER")
		middleTexture:SetTexture(UIConfig.DropDown.Texture)
		middleTexture:SetTexCoord(0.1953125, 0.3671875, 0, 1)
		middleTexture:SetPoint("LEFT", leftTexture, "RIGHT")
		middleTexture:SetPoint("RIGHT", rightTexture, "LEFT")
		middleTexture:SetHeight(45)
		middleTexture:SetVertexColor(unpack(UIConfig.DropDown.DropDownColor))

		-- Create dropdown label
		dropDown.label = dropDown:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		dropDown.label:SetPoint("TOPLEFT", dropDown, 1, 1)
		dropDown.label:SetFont(UIConfig.Style.PrimaryFont, 11)
		dropDown.label:SetTextColor(unpack(UIConfig.Style.AccentColor))
		dropDown.label:SetJustifyH("LEFT")
		dropDown.label:SetText(label)

		-- Create dropdown button
		local dropDownBtn = CreateFrame("Button", nil, innerFrame)
		dropDown.dropDownBtn = dropDownBtn
		dropDownBtn:SetSize(20, 45)
		dropDownBtn:SetPoint("LEFT", rightTexture, "RIGHT", 0, 0)

		-- Expand the clickable area of the button to include the entire menu width
		dropDownBtn:SetHitRectInsets(-width, 0, 0, 0)

		-- Dropdown button texture
		dropDownBtn:SetNormalTexture(UIConfig.DropDown.Texture)
		dropDownBtn:GetNormalTexture():SetTexCoord(0.5605, 0.68359375, 0, 1)
		dropDownBtn:GetNormalTexture():SetVertexColor(unpack(UIConfig.DropDown.DropDownColor))
		dropDownBtn:SetHighlightTexture(UIConfig.DropDown.Texture)
		dropDownBtn:GetHighlightTexture():SetTexCoord(0.6953125, 0.8203125, 0, 1)
		dropDownBtn:GetHighlightTexture():SetBlendMode("Add")

		-- Display tooltip text
		dropDownBtn.tooltip = tipText
		dropDownBtn:SetScript("OnEnter", showTooltip)
		dropDownBtn:SetScript("OnLeave", GameTooltip_Hide)

		-- Display selected item title
		local listTitle = innerFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		listTitle:SetPoint("LEFT", leftTexture, 10, 0)
		listTitle:SetFont(UIConfig.Style.PrimaryFont, 11)
		listTitle:SetTextColor(unpack(UIConfig.Style.PrimaryColor))
		listTitle:SetJustifyH("LEFT")

		-- Get selected item title from saved variable
		innerFrame:SetScript("OnShow", function()

			-- Get selected value from saved variables
			local selectedValue = getSavedVariableState(name, category)

			-- Match selected value with a value from the list of items and retrieve it's title
			for k, v in pairs(listItems) do

				if v.Value == selectedValue then

					-- Save selected title in a local variable
					selectedTitle = v.Title

					-- Set selected item title
					listTitle:SetText(selectedTitle)

					return
				end
			end
		end)

		-- Create dropdown scroll frame
		local dropDownScrollFrame = CreateFrame("ScrollFrame", nil, dropDown, "UIPanelScrollFrameTemplate")
		dropDown.list = dropDownScrollFrame
		dropDownScrollFrame:SetPoint("TOPLEFT", 0, -38)
		dropDownScrollFrame:SetSize(dropDown:GetWidth() + 20, 150)
		dropDownScrollFrame:SetFrameStrata("FULLSCREEN_DIALOG")
		dropDownScrollFrame:SetFrameLevel(12)
		dropDownScrollFrame:Hide()

		-- Create dropdown list
		local dropDownList =  CreateFrame("Frame", nil, dropDownScrollFrame, "BackdropTemplate")
		dropDownList:SetAllPoints(dropDownScrollFrame)
		dropDownList:SetSize(dropDownScrollFrame:GetWidth() + 20, (#listItems * 20) + 20)
		dropDownList:SetBackdrop(UIConfig.DropDown.Backdrop)
		dropDownList:SetBackdropColor(unpack(UIConfig.DropDown.BackdropColor))
		dropDownList:SetBackdropBorderColor(unpack(UIConfig.DropDown.BackdropBorderColor))
		
		-- Set drop down list as a scroll child
		dropDownScrollFrame:SetScrollChild(dropDownList)

		-- Hide scroll bar if content is less than the scroll frame height
		if(dropDownList:GetHeight() < dropDownScrollFrame:GetHeight()) then

			dropDownScrollFrame.ScrollBar:ClearAllPoints()
			dropDownScrollFrame.ScrollBar:Hide()
		end

		-- Hide dropdown list if page is hidden
		parent:HookScript("OnHide", function() dropDownScrollFrame:Hide() end)

		-- Create selected item checkmark
		local itemCheckMark = CreateFrame("FRAME", nil, dropDownList)
		itemCheckMark:SetSize(14, 14)
		itemCheckMark.texture = itemCheckMark:CreateTexture(nil, "ARTWORK")
		itemCheckMark.texture:SetAllPoints()
		itemCheckMark.texture:SetTexture("Interface\\Common\\UI-DropDownRadioChecks")
		itemCheckMark.texture:SetTexCoord(0, 0.5, 0.5, 1.0)
		itemCheckMark.texture:SetVertexColor(0.8, 0.8, 0.8, 1)

		-- Handle dropdown button click
		dropDownBtn:SetScript("OnClick", function()

			-- Toggle the dropdown list on button click
			if dropDownScrollFrame:IsShown() then 

				dropDownScrollFrame:Hide() 
			else

				dropDownScrollFrame:Show()

				-- Set check mark position
				itemCheckMark:SetPoint("TOPLEFT", 6, select(5, dropDownItems[selectedTitle]:GetPoint()) - 2)
			end

			-- Hide all other dropdowns except the current OnEnter
			for key, value in pairs(Widgets.DropDown) do

				if key ~= name then

					Widgets.DropDown[key].list:Hide()
				end
			end
		end)

		-- Create dropdown list items
		for k, v in pairs(listItems) do

			-- Create dropdown list item
			local listItem = CreateFrame("Button", nil, dropDownList)
			dropDownItems[v.Title] = listItem
			listItem:SetSize(dropDownList:GetWidth() - 8, 20)
			listItem:SetPoint("TOPLEFT", 4, -k * 20 + 10)
			listItem:Show()

			-- Create dropdown list item label
			listItem.title = listItem:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
			listItem.title:SetPoint("LEFT", 20, 0)
			listItem.title:SetFont(UIConfig.Style.PrimaryFont, 11)
			listItem.title:SetTextColor(unpack(UIConfig.Style.PrimaryColor))
			listItem.title:SetJustifyH("LEFT")
			listItem.title:SetText(v.Title)

			-- Create dropdown list item hover effect
			listItem.hover = listItem:CreateTexture(nil, "BACKGROUND")
			listItem.hover:SetSize(dropDownList:GetWidth() - 4, 20)
			listItem.hover:SetPoint("CENTER", 0, 0)
			listItem.hover:SetColorTexture(unpack(UIConfig.MenuItem.SelectedColor))
			listItem.hover:Hide()

			-- Apply hover effect
			listItem:SetScript("OnEnter", function() listItem.hover:Show() end)
			listItem:SetScript("OnLeave", function() listItem.hover:Hide() end)

			-- Handling list item click event
			listItem:SetScript("OnClick", function(self)

				-- Update selected item title
				selectedTitle = v.Title
				listTitle:SetText(selectedTitle)

				-- Save the new value to saved variables
				setSavedVariableState(name, category, v.Value)

				-- Run the function associated item selection and pass the selected value
				func(v.Value)

				-- Hide the dropdown list on selection
				dropDownScrollFrame:Hide()
			end)
		end
	end

	-- Create color picker frame.
	-- Create a custom color picker, so user can change colors on the fly and save the newly selected color
	--
	-- @param Frame 	parent:		The page which the color button should be attached to
	-- @param String 	name:		Color button name and also saved variable field name
	-- @param Arrau 	category:	Array with saved variable category and sub-categories if they exist
	-- @param Number 	x:			Color button X pos
	-- @param Number 	y:			Color button Y pos
	-- @param String 	label:		Color button title
	-- @param Function 	func:		Function associated with color changes
	-- @param String 	tipText:	Text that should appear on tooltip when hovering the color picker button
	local function createColorPicker(parent, name, category, x, y, label, func, tipText)

		-- Storage for current color value
		local colorValue

		-- Create color picker button
		local colorButton = CreateFrame("Button", nil, parent)
		Widgets.ColorPicker[name] = colorButton
		colorButton:SetPoint("TOPLEFT", x + 1, y)
		colorButton:SetSize(15, 15)

		-- Create button texture
		colorButton.texture = colorButton:CreateTexture(nil, "BACKGROUND")
		colorButton.texture:SetAllPoints()

		-- Create button highlight
		colorButton.highlight = colorButton:CreateTexture(nil, "BACKGROUND")
		colorButton.highlight:SetAllPoints()
		colorButton.highlight:SetColorTexture(0.2, 0.2, 0.2, 1)

		-- Set button highlight effect
		colorButton:SetHighlightTexture(colorButton.highlight)

		-- Create button border
		colorButton.border = colorButton:CreateTexture(nil, "BACKGROUND", nil, -7)
		colorButton.border:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
		colorButton.border:SetPoint("TOPLEFT", -1.5, 1.5)
		colorButton.border:SetPoint("BOTTOMRIGHT", 1, -1.5)
		colorButton.border:SetVertexColor(0.1, 0.1, 0.1, 1)

		-- Create color picker label
		colorButton.text = colorButton:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		colorButton.text:SetPoint("LEFT", colorButton, "RIGHT", 10, -.5)
		colorButton.text:SetFont(UIConfig.Style.PrimaryFont, 11)
		colorButton.text:SetTextColor(unpack(UIConfig.Style.AccentColor))
		colorButton.text:SetJustifyH("LEFT")
		colorButton.text:SetWordWrap(false)
		colorButton.text:SetText(label)

		-- Display tooltip text
		colorButton.tooltip = tipText
		colorButton:SetScript("OnEnter", showTooltip)
		colorButton:SetScript("OnLeave", GameTooltip_Hide)

		-- Get saved color value and set button texture initial color
		colorButton:SetScript("OnShow", function(self)

			-- Get color value from saved variables
			colorValue = getSavedVariableState(name, category)

			-- Set button color to match saved color
			colorButton.texture:SetColorTexture(unpack(colorValue))
		end)

		-- Color picker frame callback
		local function colorCallback(restore)

			local newR, newG, newB, newA

			if restore then

				-- Check if previous color value is empty
				if next(restore) == nil then

					-- Use the saved color if restore is empty
					newR, newG, newB, newA = unpack(colorValue)
				else

					-- Use previous color if restore is not empty
					newR, newG, newB, newA = unpack(restore)
				end
			else

				-- User selected a color but didn't confirm it yet
				newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB()
			end

			-- Check for changes
			if newR ~= colorValue[1] or newG ~= colorValue[2] or newB ~= colorValue[3] then
				
				-- Update internal colors
				r, g, b, a = newR, newG, newB, newA

				-- Update the local color value
				colorValue = {r, g, b, a}

				-- Update the color button texture color
				colorButton.texture:SetColorTexture(unpack(colorValue))

				-- Save the new value to saved variables
				setSavedVariableState(name, category, {r, g, b, a})

				-- Run the function associated with color change
				func({r, g, b, a})
			end

			-- Perform a full garbage collection cycle
			collectgarbage("collect")
		end

		-- Handle color button click
		colorButton:SetScript("OnClick", function(self)

			-- Set current color
			ColorPickerFrame:SetColorRGB(unpack(colorValue))

			-- Set the opacity slider
 			-- ColorPickerFrame.hasOpacity = (a ~= nil)
 			ColorPickerFrame.hasOpacity = false
 			ColorPickerFrame.opacity = a

 			-- Set previous color as saved variable color
 			ColorPickerFrame.previousValues = colorValue

 			-- Assign callback function to color picker variables
 			ColorPickerFrame.func, ColorPickerFrame.cancelFunc = colorCallback, colorCallback

 			-- Show color picker frame
			ColorPickerFrame:Show()
		end)
	end

-- ==================================================================================================
-- Populating UI
-- ==================================================================================================

	-- Create side menu item.
	-- Create the side menu items with all the effects and handle on item click
	-- Hide all pages on click and show only the page with the same name as the menu item
	--
	-- @param Frame 	parent:		The parent frame which the item should be attached to
	-- @param String	pageName: 	A unique identifier for each page. Should be the same name of the associated page
	-- @param Array 	point:		Button relevant position
	-- @param String 	title:		Item title
	local function createMenuItem(parent, pageName, point, title)

		-- Create menu item frame
		local menuItem = CreateFrame("Button", nil, parent)
		zMenus[pageName] = menuItem
		menuItem:SetSize(UIConfig.MenuItem.Width, UIConfig.MenuItem.Height)
		menuItem:SetPoint(unpack(point))

		-- Creating menu item hover effect
		menuItem.hover = createColorTexture(menuItem, UIConfig.MenuItem.HoverColor)
		menuItem.hover:Hide()

		-- Creating menu item selected effect
		menuItem.selected = createColorTexture(menuItem, UIConfig.MenuItem.SelectedColor)
		menuItem.selected:Hide()

		-- Creating menu item title
		menuItem.font = createText(menuItem, {"LEFT", 20, 0}, nil, UIConfig.Style.PrimaryFont, 13, UIConfig.Style.AccentColor, title)

		-- Apply hover effect
		menuItem:SetScript("OnEnter", function() menuItem.hover:Show() end)
		menuItem:SetScript("OnLeave", function() menuItem.hover:Hide() end)

		-- Menu item on click event
		menuItem:SetScript("OnClick", function()

			-- Hide all pages
			hidePages()

			-- Show requested page
			zPages[pageName]:Show()

			-- Save last opened page in DB
			zAddonDB.UI.StartPage = pageName
		end)
	end

	-- Create individual child page.
	-- Create page as a child to the scroll frame and attach it
	-- A generated page can be scrollable or fixed
	-- 
	-- @param Frame 	parent:			The parent frame which the item should be attached to
	-- @param String 	pageName:		A unique identifier for each page
	-- @param Boolean 	scrollable: 	A boolean indicating if this page should be scrollable
	-- @param String 	label: 			Page header title
	local function createMenuPage(parent, pageName, scrollable, title)

		-- Create scroll frame content frame
		local child = CreateFrame("ScrollFrame", nil, parent)
		zPages[pageName] = child
		child:SetSize(UIConfig.ScrollFrame.Width, UIConfig.ScrollFrame.Height)
		child:Hide()

		-- Skin scroll bar knob
		parent.ScrollBar:SetThumbTexture(UIConfig.ScrollBar.KnobTexture)
		UIParentScrollBarThumbTexture:SetVertexColor(unpack(UIConfig.ScrollBar.KnobColor))

		-- Handle page events
		child:SetScript("OnShow", function()


			-- Set content frame as a scroll child for scroll frame
			parent:SetScrollChild(child)

			-- Set menu item as selected
			zMenus[pageName].selected:Show() 

			-- Change header title accordingly
			zPanel.header.title:SetText(title)

			-- Reset scroll bar position
			parent:SetVerticalScroll(0)

			-- Enable scroll bar if this current page is scrollable
			if scrollable then

				-- Show scroll bar
				parent.ScrollBar:Show()

				-- Adjust scroll bar position
				parent.ScrollBar:ClearAllPoints()
				parent.ScrollBar:SetPoint("TOPLEFT", parent, "TOPRIGHT", 8, -20)
				parent.ScrollBar:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 8, 20)

				-- Enable OnMouseWheel scrolling
				parent:SetScript("OnMouseWheel", scrollHandler)

				-- Hide scroll bar up and down buttons
				hideScrollButtons()
			else
				
				-- Hide scroll bar
				parent.ScrollBar:Hide()

				-- Disable mouse wheel scrolling
				parent:SetScript("OnMouseWheel", nil)
			end
		end)

		child:SetScript("OnHide", function() 

			-- Hide menu item selected effect
			zMenus[pageName].selected:Hide() 
		end)
	end
	
	-- Build UI menus and pages.
	-- Setup the side menu items and the corresponding pages
	local function setupPages()

		-- Loop through number of menus
		for i = 1, UIContent.Addon.PagesNumber do

			-- Check for setting page to add a divider and extra padding
			if UIContent.Pages["Page" .. i].Title == "Setting" then

				createDivider(zPanel.sideMenu, 130, 0, -45 - (i * UIConfig.MenuItem.Height))

				-- Create menu items from config file
				createMenuItem(
					zPanel.sideMenu, 
					"Page" .. i, 
					{"TOPLEFT", 0, -50 - (i  * UIConfig.MenuItem.Height)}, 
					UIContent.Pages["Page" .. i].Title
				)

			else

				-- Create menu items from config file
				createMenuItem(
					zPanel.sideMenu, 
					"Page" .. i, 
					{"TOPLEFT", 0, -30 - (i * UIConfig.MenuItem.Height)}, 
					UIContent.Pages["Page" .. i].Title
				)
			end

			-- Create corresponding pages
			createMenuPage(
				zPanel.body.scrollFrame,
				"Page" .. i,
				UIContent.Pages["Page" .. i].Scroll,
				UIContent.Pages["Page" .. i].Title
			)
		end
	end


	-- Add elements to the pages
	-- Call the component functions to populate the pages with elements
	local function addComponents()

		-- Contain page name so it would be easier to move components around
		local page

		-- =====================================================
		-- Page 1: Chat
		-- =====================================================

			page = "Page1"

			createSubHeading(zPages[page], 0, 0, "Visibility")
			createCheckButton(zPages[page], "HideCombatLog", {"Chat"}, 10, -20, "Hide combat log", false,
				nameSpace.Options.hideCombatLog, 
				"If checked, the combat log will be hidden.\nMight cause issues if the combat log tab is not docked."
			)
			createCheckButton(zPages[page], "HideChatButtons", {"Chat"}, 10, -40, "Hide chat button", true,
				nameSpace.Options.hideChatButtons, 
				"If checked, side chat buttons will be hidden."
			)
			createCheckButton(zPages[page], "HideSocialButton", {"Chat"}, 10, -60, "Hide social button", false,
				nameSpace.Options.hideSocialButton, 
				"If checked, the social button and quick join notification will be hidden."
			)
			createCheckButton(zPages[page], "StopChatFade", {"Chat"}, 10, -80, "Disable chat fade", false,
				nameSpace.Options.disableChatFade, 
				"If checked, stops chat from fading after time."
			)

			createSubHeading(zPages[page], 0, -120, "Customization")
			createCheckButton(zPages[page], "ChatClassColors", {"Chat"}, 10, -140, "Enable chat class colors", false, 
				nameSpace.Options.chatClassColors, 
				"If checked, class colors will be used in the chat frame."
			)
			createCheckButton(zPages[page], "ClampChat", {"Chat"}, 10, -160, "Clamp chat frame to the screen", false, 
				nameSpace.Options.clampChatFrame, 
				"If checked, you will be able to drag the chat frame to the edge of the screen."
			)
			createCheckButton(zPages[page], "ChatTopBox", {"Chat"}, 10, -180, "Move chat editbox to the top", true, 
				nameSpace.Options.moveChatEditbox, 
				"This will move the chat editbox to the top."
			)

			createSubHeading(zPages[page], 0, -220, "Functionality")
			createCheckButton(zPages[page], "ChatURLCopy", {"Chat"}, 10, -240, "Enable chat hyperlinks copying", true, 
				nameSpace.Options.enableURLCopy, 
				"Clicking a URL will open a chatbox and you will be able to copy the URL."
			)
			createCheckButton(zPages[page], "ArrowKeysInChat", {"Chat"}, 10, -260, "Use arrow keys in chat", false, 
				nameSpace.Options.enableChatArrowKeys, 
				"If checked, you can press the arrow keys to move the insertion point left and right in the chat box."
			)
			-- createCheckButton(zPages[page], "ChatMouseScroll", {"Chat"}, 0, -280, "Use mouse scroll in chat", true, 
			-- 	nameSpace.Options.enableChatMouseScroll, 
			-- 	"If checked, you can use the mouse wheel to scroll through chat.If checked, you can use the mouse wheel to scroll through chat."
			-- )

		-- =====================================================
		-- Page 2: Minimap
		-- =====================================================

			page = "Page2"

			createSubHeading(zPages[page], 0, 0, "Visibility")
			createCheckButton(zPages[page], "HideMinimapZoneBorder", {"Minimap"}, 10, -20, "Hide zone information background", false,
				nameSpace.Options.hideMinimapZoneBorder, 
				"Hides zone information border shown above the minimap, as well as the world map button.\n\nTo show the world map, press the map bind key (M by default)."
			)
			createCheckButton(zPages[page], "HideZoomButtons", {"Minimap"}, 10, -40, "Hide minimap zoom buttons", false,
				nameSpace.Options.hideMinimapZoomButtons, 
				"If checked, minimap zoom buttons will be hidden.\n\nYou can choose to enable zoom buttons shortcut."
			)
			createCheckButton(zPages[page], "HideMinimapCalendar", {"Minimap"}, 10, -60, "Hide calendar button", false,
				nameSpace.Options.hideMinimapCalendar, 
				"If checked, minimap calendar button will be hidden.\n\nYou can choose to enable calendar button shortcut."
			)
			createCheckButton(zPages[page], "HideMinimapTracking", {"Minimap"}, 10, -80, "Hide tracking button", false,
				nameSpace.Options.hideMinimapTracking, 
				"If checked, minimap tracking button will be hidden.\n\nYou can choose to enable tracking button shortcut."
			)
			createCheckButton(zPages[page], "HideMinimapClock", {"Minimap"}, 10, -100, "Hide minimap clock", false,
				nameSpace.Options.hideMinimapClock, 
				"If checked, the clock will be hidden."
			)

			createSubHeading(zPages[page], 0, -140, "Functionality")
			createCheckButton(zPages[page], "MinimapZoomShortcut", {"Minimap"}, 10, -160, "Use the mousewheel to zoom in and out", false,
				nameSpace.Options.minimapZoomShortcut, 
				'If checked, you will be able to use the "Mouse Wheel" to zoom in and out of the minimap.\n\nYou can choose to hide minimap zoom buttons.'
			)
			createCheckButton(zPages[page], "MinimapCalendarShortcut", {"Minimap"}, 10, -180, "Use right click to open calendar", false,
				nameSpace.Options.minimapCalendarShortcut, 
				'If checked, you will be able to use "Right Click" to open calendar.\n\nYou can choose to hide minimap calendar button.'
			)
			createCheckButton(zPages[page], "MinimapTrackingShortcut", {"Minimap"}, 10, -200, "Use middle mouse button to open tracking", false,
				nameSpace.Options.minimapTrackingShortcut, 
				'If checked, you will be able to use "Middle Mouse Button" to open tracking menu.\n\nYou can choose to hide minimap tracking button.'
			)

			createSlider(zPages[page], "MinimapScale", {"Minimap"}, 0, -240 , "Minimap Scale", .5, 2, 0.1, "%.0f%%", true, 
				nameSpace.Options.setMinimapScale, 
				"Control minimap scale."
			)

		-- =====================================================
		-- Page 3: Inventory
		-- =====================================================

			page = "Page3"

			createSubHeading(zPages[page], 0, 0, "Backpack")
			createCheckButton(zPages[page], "FastLooting", {"Inventory"}, 10, -20, "Faster auto loot", false,
				nameSpace.Options.enableFastLooting, 
				"If checked, reduces the time of auto looting by significant amount."
			)
			createCheckButton(zPages[page], "InsertItemsLeftToRight", {"Inventory"}, 10, -40, "Set inserted items in bags from left to right", false,
				nameSpace.Options.setInsertedItemsDirection, 
				"If checked, inserted items will go on the leftmost side of the bags, and rightmost side if unchecked."
			)
			createCheckButton(zPages[page], "SortBagsLeftToRight", {"Inventory"}, 10, -60, "Sort bags from left to right", false,
				nameSpace.Options.setSortBagsDirection, 
				"If checked, sort bags button will sort items from left to right, and from right to left if unchecked."
			)

			createSubHeading(zPages[page], 0, -100, "Vendor")
			createCheckButton(zPages[page], "SellAllJunk", {"Inventory"}, 10, -120, "Show sell junk button", false,
				nameSpace.Options.sellJunk, 
				"Add a sell junk button to merchant window that auto sell all junk in inventory."
			)
			createCheckButton(zPages[page], "AutoRepair", {"Inventory"}, 10, -140, "Automatically repair gear", false,
				nameSpace.Options.addAutoRepair, 
				'If checked, gear will be automatically repaired when you visit a merchant.\n\nYou can override this by holding "Shift" when talking to a merchant.'
			)
			
			createSubHeading(zPages[page], 0, -180, "Misc")
			createCheckButton(zPages[page], "HideCraftedNames", {"Inventory"}, 10, -200, "Hide crafted items names", false,
				nameSpace.Options.hideCraftedItemName, 
				"If checked, crafted items will no longer show the name of the crafter."
			)

		-- =====================================================
		-- Page 4: Frames
		-- =====================================================

			page = "Page4"

			createSubHeading(zPages[page], 0, 0, "Dress Up")
			createCheckButton(zPages[page], "EnhanceDressUp", {"Frames"}, 10, -20, "Enhance dressup frame", false,
				nameSpace.Options.enhanceDressUp, 
				"If checked, a nude button will be added to the dressup frame which will allow you test items individually."
			)
			createSlider(zPages[page], "DressUpScale", {"Frames"}, 10, -50 , "DressUp Scale", .5, 2, 0.1, "%.0f%%", true, 
				nameSpace.Options.setDressUpScale, 
				"Control dress up frame scale."
			)

			createSubHeading(zPages[page], 0, -100, "Unit Frames")
			createCheckButton(zPages[page], "ColorPlayerFrame", {"Frames"}, 10, -120, "Class colored player frame", false,
				nameSpace.Options.colorPlayerFrame, 
				"If checked, will show class color in the player frame background."
			)
			createCheckButton(zPages[page], "ColorTargetFrame", {"Frames"}, 10, -140, "Class colored target frame", false,
				nameSpace.Options.colorTargetFrame, 
				"If checked, will show class color in the target frame background."
			)
			createCheckButton(zPages[page], "ColorFocusFrame", {"Frames"}, 10, -160, "Class colored focus frame", false,
				nameSpace.Options.colorFocusFrame, 
				"If checked, will show class color in the target frame background."
			)

			createSubHeading(zPages[page], 0, -200, "Positioning")
			createCheckButton(zPages[page], "AligningGrid", {"Frames"}, 10, -220, "Toggle aligning grid", false,
				nameSpace.Options.showAligningGrid, 
				"Toggle an aligning grid on screen to help with frame aligning."
			)
			createCheckButton(zPages[page], "MoveFramesMode", {"Frames"}, 10, -240, "Unlock frame edit mode", false,
				nameSpace.Options.enableFramesMode, 
				"If checked, you will enable the frame edit mode.\nAll changes are account wide.\n\nUnchecking this option will restore your frames to their default state.\n\nNote: Disables UI built-in dragging function for player frame, target frame, and focus frame."
			)
			createCheckButton(zPages[page], "FramesGrid", {"Frames"}, 10, -260, "Toggle frames dragging", false,
				nameSpace.Options.showDragFrames, 
				"If checked, a dragging frame will be shown and you will be able to change the position of some frames, also unlocks the frame scale slider for a choosen frame.\n\nIt's safe to uncheck this option after you finish repositioning the frames."
			)
			createSlider(zPages[page], "FramesScale", {"Frames"}, 10, -290 , "Frame Scale", .5, 2, 0.1, "%.0f%%", true, 
				nameSpace.Options.framesScaleFunc, 
				"Control selected frame scale."
			)
			UI:createButton(zPages[page], "FramePosReset", 0, 25, {"TOPLEFT", 10, -330}, true, "Reset", nil, "Reset frames position and scale to their default state.")

		-- =====================================================
		-- Page 5: Skins
		-- =====================================================

			page = "Page5"

			createSubHeading(zPages[page], 0, 0, "Buffs & Auras")
			createCheckButton(zPages[page], "StyleBuffs", {"Skins", "Buffs"}, 10, -20, "Style buff and debuff icons", true,
					nameSpace.Skins.applyBuffsStyle, 
					"Apply a dark border and font style on the buff and debuff icons."
			)
			createCheckButton(zPages[page], "StyleAuras", {"Skins", "Auras"}, 10, -40, "Style target's aura icons", true,
					nameSpace.Skins.applyAuraStyle, 
					"Apply a dark border and font style on target's aura icons."
			)
			createCheckButton(zPages[page], "StyleAuraCast", {"Skins", "AuraCast"}, 10, -60, "Style target's cast bar icon", true,
					nameSpace.Skins.applyAuraCastStyle, 
					"Apply a dark border and enlarge target's cast bar icon."
			)

			createSubHeading(zPages[page], 0, -100, "Buttons")
			createCheckButton(zPages[page], "StyleActionButtons", {"Skins", "ActionButtons"}, 10, -120, "Skin action buttons", true,
					nameSpace.Skins.applyActionButtonStyle, 
					"Apply a dark border on all action buttons."
			)
			createCheckButton(zPages[page], "StyleExtraButton", {"Skins", "ExtraButton"}, 10, -140, "Skin extra action buttons", true,
					nameSpace.Skins.applyExtraButtonStyle, 
					"Apply a dark border on extra action button."
			)
			createCheckButton(zPages[page], "StyleBags", {"Skins", "Bags"}, 10, -160, "Skin bag buttons", true,
					nameSpace.Skins.applyBagsStyle, 
					"Apply a dark border on bag buttons."
			)
			createCheckButton(zPages[page], "StylePetButtons", {"Skins", "PetButtons"}, 10, -180, "Skin pet bar buttons", true,
					nameSpace.Skins.applyPetButtonsStyle, 
					"Apply a dark border on bag buttons."
			)
			createCheckButton(zPages[page], "StyleStanceButtons", {"Skins", "StanceButtons"}, 10, -200, "Skin stance bar buttons", true,
					nameSpace.Skins.applyStanceButtonsStyle, 
					"Apply a dark border on stance bar buttons."
			)
			createCheckButton(zPages[page], "StylePossessButtons", {"Skins", "PossessButtons"}, 10, -220, "Skin possess bar buttons", true,
					nameSpace.Skins.applyPossessButtonsStyle, 
					"Apply a dark border on possess bar buttons."
			)
			createCheckButton(zPages[page], "StyleLeaveButton", {"Skins", "LeaveButton"}, 10, -240, "Skin vehicle leave button", true,
					nameSpace.Skins.applyLeaveButtonStyle, 
					"Apply a dark border on vehicle leave button."
			)

			createSubHeading(zPages[page], 0, -280, "Misc")
			createCheckButton(zPages[page], "StyleMainBar", {"Skins", "MainBar"}, 10, -300, "Darken main menu bar", true,
					nameSpace.Skins.applyMainBarStyle, 
					"Apply a dark border on vehicle leave button."
			)
			createCheckButton(zPages[page], "StyleChatFrame", {"Skins", "ChatFrame"}, 10, -320, "Darken chat frames", true,
					nameSpace.Skins.applyChatStyle, 
					"Apply a dark border on vehicle leave button."
			)
			createCheckButton(zPages[page], "StyleTooltip", {"Skins", "Tooltip"}, 10, -340, "Customized game tooltip", true,
					nameSpace.Skins.applyTooltipStyle, 
					"Darken game tooltip, color the information displayed, color unit level based on difficulty and add target of target functionality."
			)

		-- =====================================================
		-- Page 6: Extras
		-- =====================================================
		
			page = "Page6"

			createSubHeading(zPages[page], 0, 0, "Visibility")
			createCheckButton(zPages[page], "HideGryphons", {"Extra"}, 10, -20, "Hide action bar gryphons", false,
					nameSpace.Options.hideGryphons, 
					"If checked, the action bar gryphons will not be shown."
			)
			createCheckButton(zPages[page], "HideOrderHallBar", {"Extra"}, 10, -40, "Hide order hall bar (Legion)", true,
					nameSpace.Options.hideOrderHallBar, 
					"If checked, Legion's order hall command bar will not be shown."
			)
			createCheckButton(zPages[page], "CollapseObjectives", {"Extra"}, 10, -60, "Always collapse objectives menu", true,
					nameSpace.Options.collapseObjectives, 
					"If checked, your side objectives menu will always be collapsed unless you specifically expand it."
			)

			createSubHeading(zPages[page], 0, -100, "Misc")
			createCheckButton(zPages[page], "NoMapEmote", {"Extra"}, 10, -120, "Disable map reading emote", true,
					nameSpace.Options.disableMapEmote, 
					"If checked, your character will not perform the reading emote when you open the map."
			)
			createCheckButton(zPages[page], "CharAddonsList", {"Extra"}, 10, -140, "Show individual character addons", true,
					nameSpace.Options.charAddonsList, 
					"If checked, the addon list will show character based addons by default."
			)

		-- =====================================================
		-- Page 7: Health Bar
		-- =====================================================

			page = "Page7"

			createCheckButton(zPages[page], "HealthBar", {"HealthBar"}, 0, 0, "Enable health bar", false, 
				nameSpace.HealthBar.initHealthBar, 
				"Shows a customizable health bar on the screen."
			)

			createSubHeading(zPages[page], 0, -40, "Functionality")
			createCheckButton(zPages[page], "HPSmoothBar", {"HealthBar"}, 10, -60, "Smoother health bar", false, 
				nameSpace.HealthBar.smoothHealthBar, 
				"Make the health bar animation smoother."
			)
			createCheckButton(zPages[page], "IncomingHeals", {"HealthBar"}, 10, -80, "Show incoming heals prediction", false, 
				nameSpace.HealthBar.enableIncomingHeals, 
				"Shows incoming healing on the health bar."
			)
			createCheckButton(zPages[page], "AbsorbBar", {"HealthBar"}, 10, -100, "Show absorbed damage", false, 
				nameSpace.HealthBar.enableAbsorbBar, 
				"Shows absorbed damage on the health bar."
			)

			createSubHeading(zPages[page], 0, -140, "Appearance")
			createCheckButton(zPages[page], "HPClassColored", {"HealthBar"}, 10,  -160, "Class colored health bar", false, 
				nameSpace.HealthBar.classColoredHealthBar, 
				"Changes the health bar color to player's current class color."
			)
			createColorPicker(zPages[page], "HPBarColor", {"HealthBar"}, 10, -190, "Bar Color", 
				nameSpace.HealthBar.changeHealthBarColor, 
				"Pick a custom color for the health bar frame."
			)
			createDropDown(zPages[page], "HPBarTexture", {"HealthBar"}, 100, 10, -220, "Health Bar Texture", UIContent.DropDown.BarTexture,
				nameSpace.HealthBar.setHPTexture, 
				"Change health bar texture."
			)
			createCheckButton(zPages[page], "HPLowColor", {"HealthBar"}, 10, -265, "Enable low health color", false, 
				nameSpace.HealthBar.enableLowHPColor, 
				"Change health bar color when health drops below 25% by default, you can change the threshold and low health color."
			)
			createEditBox(zPages[page], "HPLowThreshold", {"HealthBar"}, 100, 10, -310, "Low HP Threshold", false, 5, nil, 
				nameSpace.HealthBar.setLowHPThreshold, 
				"Set the percentage of health which the low health color should be activated at.\nAccepted values should be between 0 and 1."
			)
			createColorPicker(zPages[page], "HPBarColorLow", {"HealthBar"}, 160, -314, "Low HP Color", 
				nameSpace.HealthBar.setLowHPColor, 
				"Pick the custom color that should be visible when player's health is low."
			)

			createSubHeading(zPages[page], 0, -355, "Positioning")
			createEditBox(zPages[page], "HPWidth", {"HealthBar"}, 100, 10, -395, "Width", true, 4, "HPHeight", 
				nameSpace.HealthBar.setHPBarWidth, 
				"Control the health bar frame width."
			)
			createEditBox(zPages[page], "HPHeight", {"HealthBar"}, 100, 160, -395, "Height", true, 4, "HPX", 
				nameSpace.HealthBar.setHPBarHeight, 
				"Control the health bar frame height."
			)
			createEditBox(zPages[page], "HPX", {"HealthBar", "Pos"}, 100, 10, -445, "X Offset", false, 5, "HPY", 
				nameSpace.HealthBar.setHPFrameX, 
				"Move the health frame horizontally.\nA positive value will move the bar to the right, while a negative value will move it to the left."
			)
			createEditBox(zPages[page], "HPY", {"HealthBar", "Pos"}, 100, 160, -445, "Y Offset", false, 5, "HPHeight", 
				nameSpace.HealthBar.setHPFrameY, 
				"Move the health frame vertically.\nA positive value will move the bar to the top, while a negative value will move it to the bottom."
			)

			createSubHeading(zPages[page], 0, -490, "Health Status")
			createCheckButton(zPages[page], "HPShowText", {"HealthBar"}, 10, -510, "Display health status", false, 
				nameSpace.HealthBar.displayHealthStatus, 
				"Display health information on health bar."
			)
			createCheckButton(zPages[page], "HPShortNumber", {"HealthBar"}, 10, -530, "Abbreviate health number", false, 
				nameSpace.HealthBar.shortenHealthStatus, 
				"Display a shorten version of health number."
			)
			createDropDown(zPages[page], "HPFontFamily", {"HealthBar"}, 100, 10, -565, "Font Family", UIContent.DropDown.FontFamily, 
				nameSpace.HealthBar.healthFontFamily,  
				"Change health font family."
			)
			createDropDown(zPages[page], "HPFontSize", {"HealthBar"}, 100, 170, -565, "Font Size", UIContent.DropDown.FontSize, 
				nameSpace.HealthBar.healthFontSize,  
				"Change health font size."
			)
			createEditBox(zPages[page], "HPFontX", {"HealthBar", "HPFontPos"}, 120, 10, -635, "Font X Offset", false, 5, "HPFontY", 
				nameSpace.HealthBar.setHPFontX, 
				"Control health status horizontal offset.\nA positive number will move the text to the right, while a negative number will move it to the left."
			)
			createEditBox(zPages[page], "HPFontY", {"HealthBar", "HPFontPos"}, 120, 170, -635, "Font Y Offset", false, 5, "HPFontX", 
				nameSpace.HealthBar.setHPFontY, 
				"Control health status vertical offset.\nA positive number will move the text to the top, while a negative number will move it to the bottom."
			)
			createColorPicker(zPages[page], "HPFontColor", {"HealthBar"}, 10, -675, "Font Color", 
				nameSpace.HealthBar.setHPFontColor, 
				"Changes the default text color."
			)

			createSubHeading(zPages[page], 0, -715, "Visibility")
			createSlider(zPages[page], "HPInactiveOpacity", {"HealthBar"}, 10, -740, "Idle Opacity", 0, 1, 0.05, "%.0f%%", true, 
				nameSpace.HealthBar.setHealthBarOpacity, 
				"Health bar opacity on idle state."
			)
			createSlider(zPages[page], "HPActiveOpacity", {"HealthBar"}, 170, -740, "Combat Opacity", 0, 1, 0.05, "%.0f%%", true, 
				nameSpace.HealthBar.setHealthBarOpacity, 
				"Health bar opacity when player is engaged in comabt."
			)
			createSlider(zPages[page], "HPDeadOpacity", {"HealthBar"}, 10, -785 , "Dead Opacity", 0, 1, 0.05, "%.0f%%", true, 
				nameSpace.HealthBar.setHealthBarOpacity, 
				"Health bar opacity when player is dead."
			)
			createSlider(zPages[page], "HPLossOpacity", {"HealthBar"}, 170, -785, "HP Loss Opacity", 0, 1, 0.05, "%.0f%%", true, 
				nameSpace.HealthBar.setHealthBarOpacity, 
				"Health bar opacity when player is not in combat but health is not completely full."
			)

			-- local pet = -710
			-- createSubHeading(zPages[page], 0, pet, "Pet Bar")

			-- createCheckButton(zPages[page], "PetBar", {"HealthBar"}, 10, pet - 20, "Enable pet bar", false, 
			-- 	nameSpace.HealthBar.enablePetBar, 
			-- 	"Display a small pet bar attached to the main health bar frame.\n\nDoesn't work with temporary pets."
			-- )
			-- createColorPicker(zPages[page], "PetBarColor", {"HealthBar"}, 20, pet - 48, "Pet Bar Color", 
			-- 	nameSpace.HealthBar.changePetBarColor, 
			-- 	"Change the color of the pet health bar."
			-- )
			-- createCheckButton(zPages[page], "PetBarText", {"HealthBar"}, 10, pet - 70, "Show pet health percentage", false, 
			-- 	nameSpace.HealthBar.enablePetHPPercentage, 
			-- 	"Display pet health percentage on the main health bar frame."
			-- )

		-- =====================================================
		-- Page 8: Power Bar	
		-- =====================================================

			page = "Page8"

			createCheckButton(zPages[page], "PowerBar", {"PowerBar"}, 0, 0, "Enable power bar", false, 
				nameSpace.PowerBar.initPowerBar, 
				"Shows a customizable power bar on the screen."
			)

			createSubHeading(zPages[page], 0, -40, "Functionality")
			createCheckButton(zPages[page], "BPSmooth", {"PowerBar"}, 10, -60, "Smoother power bar", false, 
				nameSpace.PowerBar.smoothPowerBar, 
				"Make the power bar animation smoother."
			)
			createCheckButton(zPages[page], "PBPrediction", {"PowerBar"}, 10, -80, "Enable power gains prediction", false, 
				nameSpace.PowerBar.enablePowerPrediction, 
				"Shows power gains prediction on the power bar."
			)
			createCheckButton(zPages[page], "AutoAttackBar", {"PowerBar"}, 10, -100, "Show attack speed bar", false, 
				nameSpace.PowerBar.enableAutoAttackBar, 
				"Shows a timer bar for auto attack swings on the power bar frame."
			)

			createSubHeading(zPages[page], 0, -140, "Appearance")
			createCheckButton(zPages[page], "PBCustomColor", {"PowerBar"}, 10,  -160, "Override power bar color", false, 
				nameSpace.PowerBar.overridePowerBarColor, 
				"Enable the option to pick a custom color for the power bar."
			)
			createColorPicker(zPages[page], "PBBarColor", {"PowerBar"}, 10, -190, "Bar Color", 
				nameSpace.PowerBar.changePowerBarColor, 
				"Pick a custom color for the power bar frame."
			)
			createDropDown(zPages[page], "PBTexture", {"PowerBar"}, 100, 10, -220, "Power Bar Texture", UIContent.DropDown.BarTexture,
				nameSpace.PowerBar.setPowerTexture, 
				"Change power bar texture."
			)
			createCheckButton(zPages[page], "EnablePBLowColor", {"PowerBar"}, 10, -265, "Enable low power color", false, 
				nameSpace.PowerBar.enableLowPowerColor, 
				"Change power bar color when resources drops below 25% by default, you can change the threshold and low power color."
			)
			createEditBox(zPages[page], "PBLowThreshold", {"PowerBar"}, 100, 10, -310, "Low Power Threshold", false, 5, nil, 
				nameSpace.PowerBar.setLowPowerThreshold, 
				"Set the percentage of power which the low power color should be activated at.\nAccepted values should be between 0 and 1."
			)
			createColorPicker(zPages[page], "PBLowColor", {"PowerBar"}, 160, -314, "Low HP Color", 
				nameSpace.PowerBar.setLowPowerColor, 
				"Pick the custom color that should be visible when player's power is lower than the threshold."
			)
			createCheckButton(zPages[page], "EnablePBHighColor", {"PowerBar"}, 10, -340, "Enable high power color", false, 
				nameSpace.PowerBar.enableHighPowerColor, 
				"Change power bar color when resources is at 80% or higher by default, you can change the threshold and high power color."
			)
			createEditBox(zPages[page], "PBHighThreshold", {"PowerBar"}, 100, 10, -385, "High Power Threshold", false, 5, nil, 
				nameSpace.PowerBar.setHighPowerThreshold, 
				"Set the percentage of power which the high power color should be activated at.\nAccepted values should be between 0 and 1."
			)
			createColorPicker(zPages[page], "PBHighColor", {"PowerBar"}, 160, -389, "Low HP Color", 
				nameSpace.PowerBar.setHighPowerColor, 
				"Pick the custom color that should be visible when player's power is higher than the threshold."
			)

			createSubHeading(zPages[page], 0, -430, "Positioning")
			createEditBox(zPages[page], "PBWidth", {"PowerBar"}, 100, 10, -470, "Width", true, 4, "PBHeight", 
				nameSpace.PowerBar.setPowerBarWidth, 
				"Control the power bar frame width."
			)
			createEditBox(zPages[page], "PBHeight", {"PowerBar"}, 100, 160, -470, "Height", true, 4, "HPX", 
				nameSpace.PowerBar.setPowerBarHeight, 
				"Control the power bar frame height."
			)
			createEditBox(zPages[page], "PBX", {"PowerBar", "Pos"}, 100, 10, -520, "X Offset", false, 5, "HPY", 
				nameSpace.PowerBar.setPowerFrameX, 
				"Move the power frame horizontally.\nA positive value will move the bar to the right, while a negative value will move it to the left."
			)
			createEditBox(zPages[page], "PBY", {"PowerBar", "Pos"}, 100, 160, -520, "Y Offset", false, 5, "HPHeight", 
				nameSpace.PowerBar.setPowerFrameY, 
				"Move the power frame vertically.\nA positive value will move the bar to the top, while a negative value will move it to the bottom."
			)

			createSubHeading(zPages[page], 0, -565, "Power Status")
			createCheckButton(zPages[page], "PBShowText", {"PowerBar"}, 10, -585, "Display power status", false, 
				nameSpace.PowerBar.displayPowerStatus, 
				"Display power information on power bar."
			)
			createCheckButton(zPages[page], "PowerShortNumber", {"PowerBar"}, 10, -605, "Abbreviate power number", false, 
				nameSpace.PowerBar.shortenPowerStatus, 
				"Display a shorten version of health number."
			)
			createDropDown(zPages[page], "PBFontFamily", {"PowerBar"}, 100, 10, -640, "Font Family", UIContent.DropDown.FontFamily, 
				nameSpace.PowerBar.powerFontFamily,  
				"Change power font family."
			)
			createDropDown(zPages[page], "PBFontSize", {"PowerBar"}, 100, 170, -640, "Font Size", UIContent.DropDown.FontSize, 
				nameSpace.PowerBar.powerFontSize,  
				"Change power font size."
			)
			createEditBox(zPages[page], "BPFontX", {"PowerBar", "PBFontPos"}, 120, 10, -710, "Font X Offset", false, 5, "BPFontY", 
				nameSpace.PowerBar.setPowerFontX, 
				"Control power status horizontal offset.\nA positive number will move the text to the right, while a negative number will move it to the left."
			)
			createEditBox(zPages[page], "BPFontY", {"PowerBar", "PBFontPos"}, 120, 170, -710, "Font Y Offset", false, 5, "BPFontX", 
				nameSpace.PowerBar.setPowerFontY, 
				"Control power status vertical offset.\nA positive number will move the text to the top, while a negative number will move it to the bottom."
			)
			createColorPicker(zPages[page], "PBFontColor", {"PowerBar"}, 10, -750, "Font Color", 
				nameSpace.PowerBar.setPowerFontColor, 
				"Changes the default text color."
			)

			createSubHeading(zPages[page], 0, -790, "Visibility")
			createSlider(zPages[page], "PBInactiveOpacity", {"PowerBar"}, 10, -815, "Idle Opacity", 0, 1, 0.05, "%.0f%%", true, 
				nameSpace.PowerBar.setPowerBarOpacity, 
				"Power bar opacity on idle state."
			)
			createSlider(zPages[page], "PBActiveOpacity", {"PowerBar"}, 170, -815, "Combat Opacity", 0, 1, 0.05, "%.0f%%", true, 
				nameSpace.PowerBar.setPowerBarOpacity, 
				"Power bar opacity when player is engaged in comabt."
			)
			createSlider(zPages[page], "PBDeadOpacity", {"PowerBar"}, 10, -860, "Dead Opacity", 0, 1, 0.05, "%.0f%%", true, 
				nameSpace.PowerBar.setPowerBarOpacity, 
				"Power bar opacity when player is dead."
			)
			createSlider(zPages[page], "PBLossOpacity", {"PowerBar"}, 170, -860, "HP Loss Opacity", 0, 1, 0.05, "%.0f%%", true, 
				nameSpace.PowerBar.setPowerBarOpacity, 
				"Power bar opacity when player is not in combat but health is not completely full."
			)

		-- =====================================================
		-- Page 9: Alt.Power Bar	
		-- =====================================================

			page = "Page9"
			createSubHeading(zPages[page], 0, 0, "Soon")
			-- createSubHeading(zPanel[page], "Customization", 150, -80)
			-- createCheckButtons("AltPowerBar", 			{"AltPowerBar"}, zPanel[page], "Enable alt. power bar.", 				155, -100, nameSpace.Resources.initAltPowerBar, 			"If checked, will show player alternative resource power on screen.")

			-- createCheckButtons("APBShowText", 			{"AltPowerBar"}, zPanel[page], "Show alternative power number.", 		155, -130, nameSpace.Resources.showAltPowerNumbers, 		"If checked, will show monk stagger number on the bar.")
			-- createCheckButtons("APBAbbreviateNumber",	{"AltPowerBar"}, zPanel[page], "Abbreviate alternative power number.", 	155, -150, nameSpace.Resources.abbreviateAltPowerNumbers, 	"If checked, shorten the current stagger number.\n\nYou have to enable alternative power numbers to enable this option.")

			-- createSlider("APBWidth", 	{"AltPowerBar"},		zPanel[page], 10, 						GetScreenWidth(), 		1, 150, -190, false, "%.0f", nameSpace.Resources.setAltPowerFrameWidth, 	"Alt. Power Width")
			-- createSlider("APBHeight", 	{"AltPowerBar"},		zPanel[page], 10, 						GetScreenHeight(), 		1, 350, -190, false, "%.0f", nameSpace.Resources.setAltPowerFrameHeight, 	"Alt. Power Height")
			-- createSlider("APBX", 		{"AltPowerBar", "Pos"},	zPanel[page], -(GetScreenWidth()/2), 	(GetScreenWidth()/2) , 	1, 150, -240, false, "%.0f", nameSpace.Resources.setAltPowerFrameX, 		"Alt. Power X")
			-- createSlider("APBY", 		{"AltPowerBar", "Pos"},	zPanel[page], -(GetScreenHeight()/2), 	(GetScreenHeight()/2), 	1, 350, -240, false, "%.0f", nameSpace.Resources.setAltPowerFrameY, 		"Alt. Power Y")
			-- createSlider("APBSpacing", 	{"AltPowerBar"},		zPanel[page], 0, 	40, 										1, 250, -290, false, "%.0f", nameSpace.Resources.setAltIconsSpacing, 		"Alt. Power Spacing")

		-- =====================================================
		-- Page 10: Setting	
		-- =====================================================

			page = "Page10"

			createSubHeading(zPages[page], 0, 0, "Addon")
			createCheckButton(zPages[page], "ShowMinimapButton", {"Setting"}, 10, -20, "Show minimap button", false, 
				nameSpace.Options.toggleMinimapButton, 
				'Toggle addon\'s minimap button.\n\nYou can toggle addon frame using the "|cffCC3333/za|r" command in chat.'
			)
			createSlider(zPages[page], "UIScale", {"Setting"}, 10, -55 , "Scale", .8, 1.5, 0.05, "%.0f%%", true, 
				nameSpace.Options.setAddonScale, 
				"Control addon's UI scale."
			)
			createSlider(zPages[page], "UIOpacity", {"Setting"}, 10, -100 , "Opacity", 0, 1, 0.05, "%.0f%%", true, 
				nameSpace.Options.setAddonOpacity, 
				"Control addon's UI opacity."
			)
			UI:createButton(zPages[page], "AddonReset", 0, 25, {"TOPLEFT", 10, -145}, true, "Reset Addon", 
				nameSpace.Options.resetAddon, 
				"Reset addon to the default state.\nThat include account wide setting and character specific setting."
			)

			createSubHeading(zPages[page], 0, -200, "Memory Usage")
			local memoryTxt = createText(zPages[page], {"TOPLEFT", 90, -200.5}, nil, UIConfig.Style.PrimaryFont, 12, UIConfig.Style.PrimaryColor, nil)
			getMemoryUsage(memoryTxt)

			createSubHeading(zPages[page], 0, -230, "Version")
			createText(zPages[page], {"TOPLEFT", 50, -230.5}, nil, UIConfig.Style.PrimaryFont, 12, UIConfig.Style.PrimaryColor, UIContent.Addon.Version)

			createSubHeading(zPages[page], 0, -260, "About")
			createText(zPages[page], {"TOPLEFT", 0, -280}, nil, UIConfig.Style.PrimaryFont, 12, UIConfig.Style.PrimaryColor, 
				"Simple utility addon to improve Blizzard's default UI.\n" .. 
				"This addon is highly influenced by Leatrix Plus.\n" .. 
				"The goal was to collect all the functionalities I needed in\none addon and leave out the rest."
			)

			createSubHeading(zPages[page], 0, -350, "Credit")
			createText(zPages[page], {"TOPLEFT", 0, -370}, nil, UIConfig.Style.PrimaryFont, 12, UIConfig.Style.PrimaryColor, 
				"Leatrix - Leatrix Plus"
			)
			createText(zPages[page], {"TOPLEFT", 0, -390}, nil, UIConfig.Style.PrimaryFont, 12, UIConfig.Style.PrimaryColor, 
				"Zork - Zork UI"
			)
			createText(zPages[page], {"TOPLEFT", 0, -410}, nil, UIConfig.Style.PrimaryFont, 12, UIConfig.Style.PrimaryColor, 
				"pHishr - pHishr's Media Pack"
			)
			createText(zPages[page], {"TOPLEFT", 0, -430}, nil, UIConfig.Style.PrimaryFont, 12, UIConfig.Style.PrimaryColor, 
				"Ferous - Ferous Media Pack"
			)
	end

-- ==================================================================================================
-- Building UI Frames
-- ==================================================================================================

	-- Create UI main panel.
	-- Create addon's parent frame, and the backdrop
	-- It will contain all the individual partial frames and the components
	--
	-- @return Frame mainPanel:	The newely created main panel frame
	local function createMainPanel()

		-- Create main panel frame
		local mainPanel = CreateFrame("Frame", nil, UIParent)

		-- Setting panel attributes
		mainPanel:SetSize(UIConfig.MainPanel.Width, UIConfig.MainPanel.Height)
		mainPanel:SetPoint("CENTER", 500, 10)
		mainPanel:Hide()
		mainPanel:SetScale(zAddonDB.Setting.UIScale)
		mainPanel:SetFrameStrata("FULLSCREEN_DIALOG")
		mainPanel:SetClampedToScreen(true)

		-- Making panel moveable
		mainPanel:EnableMouse(true)
		mainPanel:SetMovable(true)
		mainPanel:RegisterForDrag("LeftButton")

		mainPanel:SetScript("OnDragStart", function ()

			mainPanel:StartMoving()
		end)

		mainPanel:SetScript("OnDragStop", function ()

			mainPanel:StopMovingOrSizing()
			mainPanel:SetUserPlaced(false)
		end)

		-- Add main panel backdrop
		mainPanel.BG = CreateFrame("Frame", nil, mainPanel, "BackdropTemplate")
		mainPanel.BG:SetPoint("TOPLEFT", mainPanel, "TOPLEFT", -4, 4)
		mainPanel.BG:SetPoint("BOTTOMRIGHT", mainPanel, "BOTTOMRIGHT", 4, -4)
		mainPanel.BG:SetFrameLevel(mainPanel:GetFrameLevel() - 1)
		mainPanel.BG:SetBackdrop(UIConfig.MainPanel.Backdrop)
		mainPanel.BG:SetBackdropColor(unpack(UIConfig.MainPanel.BackdropColor))
		mainPanel.BG:SetBackdropBorderColor(unpack(UIConfig.MainPanel.BackdropBorderColor))

		-- Adding addon close button
		local closeBtn = CreateFrame("Button", nil, mainPanel, "UIPanelCloseButton")
		closeBtn:SetSize(30, 30)
		closeBtn:SetPoint("TOPRIGHT", 0, 0)

		-- Return the main panel
		return mainPanel
	end

	-- Create side menu frame.
	-- Create the side menu panel with all the menu UI components
	--
	-- @return Frame sideMenu: The newely created side menu frame
	local function createSideMenu()

		-- Create side menu frame
		local sideMenu = CreateFrame("Frame", nil, zPanel)
		sideMenu:SetSize(UIConfig.SideMenu.Width, UIConfig.SideMenu.Height)
		sideMenu:SetPoint("LEFT")

		-- Create side menu texture
		sideMenu.texture = createTexture(sideMenu, UIConfig.SideMenu.Texture, UIConfig.SideMenu.Color)
		sideMenu.texture:SetAlpha(zAddonDB.Setting.UIOpacity)

		-- Addon title
		sideMenu.mainTitle = createText(
			sideMenu, 
			{"TOPLEFT", 18, -16}, nil, 
			UIConfig.Style.PrimaryFont, 18, UIConfig.Style.AccentColor, "zAddon"
		)

		-- Addon sub-title
		sideMenu.subTitle = createText(
			sideMenu, 
			{"BOTTOMLEFT", sideMenu.mainTitle, "BOTTOMRIGHT", 5, 1}, nil, 
			UIConfig.Style.PrimaryFont, 12, UIConfig.Style.SecondaryColor, "Retail"
		)

		-- Addon version text
		sideMenu.subTitle = createText(
			sideMenu, 
			{"CENTER", sideMenu, "TOP", 0, -42}, nil, 
			UIConfig.Style.PrimaryFont, 11, UIConfig.Style.SecondaryColor, "Version " .. UIContent.Addon.Version
		)

		-- Addon reload button
		local reloadBtn = UI:createButton(
			sideMenu, "reloadUIBtn",
			0, 25,
			{"BOTTOM", 0, 10},
			true,
			"Reload UI",
			nil,
			"Reload UI for some of the changes to take effect."
		)

		reloadBtn:SetScript("OnClick", ReloadUI)
		reloadBtn:Disable()

		-- Create UI reload text warning
		Widgets.Text["reloadText"] = createText(
			sideMenu, 
			{"CENTER", sideMenu, "BOTTOM", 0, 50}, nil, 
			UIConfig.Style.PrimaryFont, 12, UIConfig.Style.AccentColor, "UI reload required."
		)

		Widgets.Text["reloadText"]:SetAlpha(.8)
		Widgets.Text["reloadText"]:Hide()

		-- Return the side menu
		return sideMenu
	end

	-- Create header frame.
	-- Create the header frame and page title then attach them to the main panel
	--
	-- @return Frame header: The newely created header frame
	local function createHeader()

		-- Create header frame
		local header = CreateFrame("Frame", nil, zPanel)
		header:SetSize(UIConfig.Header.Width, UIConfig.Header.Height)
		header:SetPoint("TOPRIGHT")

		-- Create header texture
		header.texture = createTexture(header, UIConfig.Header.Texture, UIConfig.Header.Color)
		header.texture:SetAlpha(zAddonDB.Setting.UIOpacity)

		-- Create page title
		header.title = createText(
			header, 
			{"CENTER", 0, 0}, {"LEFT", 20, 0}, 
			UIConfig.Style.PrimaryFont, 15, UIConfig.Style.AccentColor, nil
		)

		-- Return the header
		return header
	end

	-- Create body frame.
	-- Create the body frame where all pages reside and attach it to the main panel
	--
	-- @return Frame body: The newely created body frame
	local function createBody()

		-- Create body frame
		local body = CreateFrame("Frame", nil, zPanel)
		body:SetSize(UIConfig.Body.Width, UIConfig.Body.Height)
		body:SetPoint("BOTTOMRIGHT")

		-- Create body texture
		body.texture = createTexture(body, UIConfig.Body.Texture, UIConfig.Body.Color)
		body.texture:SetAlpha(zAddonDB.Setting.UIOpacity)

		-- Return the body
		return body
	end

	-- Create scroll frame.
	-- Create a scroll frame inside the body frame, so dynamically created pages will be attached to it
	--
	-- @return Frame scrollFrame: The newely created scroll frame
	local function createScrollFrame()

		-- Create scroll frame
		local scrollFrame = CreateFrame("ScrollFrame", nil, zPanel.body, "UIPanelScrollFrameTemplate")
		scrollFrame:SetSize(UIConfig.ScrollFrame.Width, UIConfig.ScrollFrame.Height)
		scrollFrame:SetPoint("CENTER")

		-- Completely hide scroll bar by default
		scrollFrame.ScrollBar:ClearAllPoints()
		scrollFrame.ScrollBar:Hide()

		-- Return the scroll frame
		return scrollFrame
	end

	-- Builds all the UI frames.
	-- Call the functions responsible for building individual UI parts
	local function buildUIFrames()

		-- Create the main panel of the UI
		zPanel = createMainPanel()
		_G["zAddonGlobalPanel"] = zPanel

		-- Create and attach the side menu to the main panel
		zPanel.sideMenu = createSideMenu()

		-- Create and attach the header to the main panel
		zPanel.header = createHeader()

		-- Create and attach the body to the main panel
		zPanel.body = createBody()

		-- Create scroll frame inside body frame
		zPanel.body.scrollFrame = createScrollFrame()
	end

-- ==================================================================================================
-- UI Initialization
-- ==================================================================================================

	-- UI initialization.
	-- Main function that create the whole UI and the entry point to the file
	-- Gets called once in Core.lua file
	function UI:initUI()

		-- Load a local version of saved variables fields that require UI reload
		reloadSavedVariables()

		-- Show addon's minimap button if it's enabled
		if zAddonDB.Setting.ShowMinimapButton then

			UI.showMinimapButton()
		end

		-- Build all the UI frames
		buildUIFrames()

		-- Setup menu items and pages
		setupPages()

		-- Adding components to pages
		addComponents()

		-- Refresh pages after components have been added, to get the state of some widgets
		refreshPages()		

		-- zPages["Page1"]:Show()		

		local events = CreateFrame("Frame")
		events:RegisterEvent("PLAYER_ENTERING_WORLD")
		events:SetScript("OnEvent", function(self, event)

			-- Toggle widgets which are dependant on other widgets state
			UI.setWidgetLocks()

			-- Unregister events
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end)

		-- Some components that should start disabled
		zAddonDB.Frames.FramesGrid = false
		zAddonDB.Frames.AligningGrid = false
	end
