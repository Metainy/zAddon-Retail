-- Addon's namespace
local zAddon, nameSpace = ...

-- Adding tables to addon's namespace
nameSpace.Skins = {}

-- Creating namespace tables
local Skins = nameSpace.Skins

-- Enable skins functionality based on saved variables
-- This function runs once on addon's startup
function Skins.initSkins()

	-- =====================================================
	-- Buffs and Auras Functions
	-- =====================================================

		if zAddonDB.Skins.Buffs.StyleBuffs 		then Skins.applyBuffsStyle(zAddonDB.Skins.Buffs.StyleBuffs) 		end
		if zAddonDB.Skins.Auras.StyleAuras 		then Skins.applyAuraStyle(zAddonDB.Skins.Auras.StyleAuras) 			end
		if zAddonDB.Skins.AuraCast.StyleAuras 	then Skins.applyAuraCastStyle(zAddonDB.Skins.AuraCast.StyleAuras) 	end

	-- =====================================================
	-- Buttons Functions
	-- =====================================================

		local event = CreateFrame("Frame")
		event:RegisterEvent("PLAYER_LOGIN")
		event:SetScript("OnEvent", function() 

			if zAddonDB.Skins.ActionButtons.StyleActionButtons then Skins.applyActionButtonStyle(zAddonDB.Skins.ActionButtons.StyleActionButtons) end

			-- Unregister the event
			if event == "PLAYER_LOGIN" then self:UnregisterEvent("PLAYER_LOGIN") end
		end)
		if zAddonDB.Skins.ExtraButton.StyleExtraButton then Skins.applyExtraButtonStyle(zAddonDB.Skins.ExtraButton.StyleExtraButton) end
		if zAddonDB.Skins.Bags.StyleBags then Skins.applyBagsStyle(zAddonDB.Skins.Bags.StyleBags) end
		if zAddonDB.Skins.PetButtons.StylePetButtons then Skins.applyPetButtonsStyle(zAddonDB.Skins.PetButtons.StylePetButtons) end
		if zAddonDB.Skins.StanceButtons.StyleStanceButtons then Skins.applyStanceButtonsStyle(zAddonDB.Skins.StanceButtons.StyleStanceButtons) end
		if zAddonDB.Skins.PossessButtons.StylePossessButtons then Skins.applyPossessButtonsStyle(zAddonDB.Skins.PossessButtons.StylePossessButtons) end
		if zAddonDB.Skins.LeaveButton.StyleLeaveButton then Skins.applyLeaveButtonStyle(zAddonDB.Skins.LeaveButton.StyleLeaveButton) end

	-- =====================================================
	-- Misc Functions
	-- =====================================================

		if zAddonDB.Skins.MainBar.StyleMainBar then Skins.applyMainBarStyle(zAddonDB.Skins.MainBar.StyleMainBar) end
		if zAddonDB.Skins.ChatFrame.StyleChatFrame then Skins.applyChatStyle(zAddonDB.Skins.ChatFrame.StyleChatFrame) end
		if zAddonDB.Skins.Tooltip.StyleTooltip then Skins.applyTooltipStyle(zAddonDB.Skins.Tooltip.StyleTooltip) end
end

-- ==================================================================================================
-- Buffs and Auras Functions
-- ==================================================================================================

	-- Apply a dark border and font style for buffs and debuffs
	-- Require reload when disabled
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Skins.applyBuffsStyle(state)

		if state then 

			-- Loading buff style DB
			local buffsDB = buffsDB or zAddonDB.Skins.Buffs

			-- Function resposible of applying styles to individual buttons
			local function styleBuffIcon(button)

				-- Return if not button or button is already styled
				if not button or (button and button.styled) then return end

				-- Getting button name
				local name = button:GetName()

				-- Checking button type
				local tempenchant, consolidated, isDebuff, isBuff= false, false, false, false

				if (name:match("TempEnchant")) then
					tempenchant = true
				elseif (name:match("Consolidated")) then
					consolidated = true
				elseif (name:match("Debuff")) then
			    	isDebuff = true
			    else
			     	isBuff = true
			    end

			    -- Button size
			    -- button:SetSize(40, 40)

			    -- Removing default borders
			    local icon = _G[name.."Icon"]
			    icon:SetTexCoord(.07, .95, .07, .95)
				icon:SetDrawLayer("BACKGROUND", -8)
				button.icon = icon

				-- Styling button border
				local border = _G[name.."Border"] or button:CreateTexture(name.."Border", "BACKGROUND", nil, -7)
				border:SetTexture(buffsDB.BuffBorderTexture)
				border:SetTexCoord(0, 1, 0, 1)
				border:SetDrawLayer("BACKGROUND", -7)
				border:ClearAllPoints()
				border:SetPoint("TOPLEFT", button, -buffsDB.BuffBorderPadding, buffsDB.BuffBorderPadding)
				border:SetPoint("BOTTOMRIGHT", button, buffsDB.BuffBorderPadding, -buffsDB.BuffBorderPadding)

				if not isDebuff then
					border:SetGradientAlpha("VERTICAL", 
						buffsDB.BuffBorderColor.br, buffsDB.BuffBorderColor.bg, buffsDB.BuffBorderColor.bb, buffsDB.BuffBorderColor.ba, 
						buffsDB.BuffBorderColor.tr, buffsDB.BuffBorderColor.tg, buffsDB.BuffBorderColor.tb, buffsDB.BuffBorderColor.ta
					)
				else
					-- Debuff border color
					border:SetVertexColor(1, 0, 0)
				end

				button.border = border

				-- Styling buff duration
				button.duration:SetFont(buffsDB.BuffFont, buffsDB.BuffDurationFontSize, "THINOUTLINE")
			    button.duration:ClearAllPoints()
			    button.duration:SetPoint("BOTTOM", 0, -14)

			    -- Styling buff count
			    button.count:SetFont(buffsDB.BuffFont, buffsDB.BuffStackFontSize, "THINOUTLINE")
			    -- button.count:ClearAllPoints()
			    -- button.count:SetPoint("BOTTOM", 0, -11)

			    -- Set button as styled
				button.styled = true
			end

			-- Hooking functions
			hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", function(self)

				for i = 1, BUFF_ACTUAL_DISPLAY do

					local buff = _G["BuffButton"..i]
					styleBuffIcon(buff)
				end
			end)

			hooksecurefunc("DebuffButton_UpdateAnchors", function(self)

				for i = 1, BUFF_ACTUAL_DISPLAY do

					local buff = _G["DebuffButton"..i]
					styleBuffIcon(buff)
				end
			end)

			for i = 1, BUFF_ACTUAL_DISPLAY do

				local buff = _G["BuffButton"..i]
				styleBuffIcon(buff)
			end

			for i = 1, NUM_TEMP_ENCHANT_FRAMES do

				local buff = _G["TempEnchant"..i]
				styleBuffIcon(buff)
			end

			-- Set local saved variables version
			nameSpace.UI.Reloads["StyleBuffs"] = true 
		end

		-- Toggle reload button and show a reload UI message
		nameSpace.UI.reloadCheck()
	end

	-- Apply a dark border and font style for target and focus auras
	-- Require reload when disabled
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Skins.applyAuraStyle(state)

		if state then 

			-- Loading aura style DB
			local auraDB = auraDB or zAddonDB.Skins.Auras

			-- Styling target and focus auras
			local function styleAura(button)

				-- Return if not button or button is already styled
				if not button or (button and button.styled) then return end

				-- Getting button name
				local name = button:GetName()

				-- Checking button type
				local buff, debuff = false, false

				if (name:match("Buff")) then
					buff = true
			   	else
			   		debuff = true
				end

			    -- Button size
			    -- button:SetSize(40, 40)

			    -- Removing default borders
			    local icon = _G[name.."Icon"]
			    icon:SetTexCoord(.05, .95, .05, .95)
				icon:SetDrawLayer("BACKGROUND", -8)
				button.icon = icon

				-- Styling button border
				local border = _G[name.."Border"] or button:CreateTexture(name.."Border", "BACKGROUND", nil, -7)
				border:SetTexture(auraDB.AuraBorderTexture)
				border:SetTexCoord(0, 1, 0, 1)
				border:SetDrawLayer("BACKGROUND", -7)
				border:ClearAllPoints()
				border:SetPoint("TOPLEFT", button, -auraDB.AuraBorderPadding, auraDB.AuraBorderPadding)
				border:SetPoint("BOTTOMRIGHT", button, auraDB.AuraBorderPadding, -auraDB.AuraBorderPadding)

				if buff then
					border:SetGradientAlpha("VERTICAL", 
						auraDB.AuraBorderColor.br, auraDB.AuraBorderColor.bg, auraDB.AuraBorderColor.bb, auraDB.AuraBorderColor.ba, 
						auraDB.AuraBorderColor.tr, auraDB.AuraBorderColor.tg, auraDB.AuraBorderColor.tb, auraDB.AuraBorderColor.ta
					)
				else
					-- Debuff border color
					border:SetVertexColor(1, 0, 0)
				end

				button.border = border

				-- Styling buff count
				button.Count:SetFont(auraDB.AuraFont, auraDB.AuraStackFontSize, "THINOUTLINE")

				-- Set Button As Styled
				button.styled = true
			end

			-- Hooking Target Frame Auras Function
			hooksecurefunc("TargetFrame_UpdateAuras", function(self)

				for i = 1, MAX_TARGET_BUFFS do

					local auraIcon = _G["TargetFrameBuff"..i]
					styleAura(auraIcon)
				end

				for i = 1, MAX_TARGET_DEBUFFS do

					local auraIcon = _G["TargetFrameDebuff"..i]
					styleAura(auraIcon)
				end

				for i = 1, MAX_TARGET_BUFFS do

					local auraIcon = _G["FocusFrameBuff"..i]
					styleAura(auraIcon)
				end

				for i = 1, MAX_TARGET_DEBUFFS do

					local auraIcon = _G["FocusFrameDebuff"..i]
					styleAura(auraIcon)
				end
			end)

			-- For first run before any updates on auras
			for i = 1, MAX_TARGET_BUFFS do

				local auraIcon = _G["TargetFrameBuff"..i]
				styleAura(auraIcon)
			end

			for i = 1, MAX_TARGET_DEBUFFS do

				local auraIcon = _G["TargetFrameDebuff"..i]
				styleAura(auraIcon)
			end

			for i = 1, MAX_TARGET_BUFFS do

				local auraIcon = _G["FocusFrameBuff"..i]
				styleAura(auraIcon)
			end

			for i = 1, MAX_TARGET_DEBUFFS do

				local auraIcon = _G["FocusFrameDebuff"..i]
				styleAura(auraIcon)
			end

			-- Set local saved variables version
			nameSpace.UI.Reloads["StyleAuras"] = true 
		end

		-- Toggle reload button and show a reload UI message
		nameSpace.UI.reloadCheck()
	end

	-- Apply a dark border for target and focus cast bar icon
	-- Require reload when disabled
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Skins.applyAuraCastStyle(state)

		if state then

			-- Loading aura cast style DB
			local auraCastDB = auraCastDB or zAddonDB.Skins.AuraCast

			-- Styling target and focus cast bars aura
			local function styleAuraCastBar(button)

				-- Return if not button or button is already styled
				if not button or (button and button.styled) then return end

				-- Getting button source
				if button == TargetFrameSpellBar.Icon then
					button.parent = TargetFrameSpellBar
				else
					button.parent = FocusFrameSpellBar
				end

				frame = CreateFrame("Frame", nil, button.parent)

				-- Styling Button
				button:SetSize(20, 20)

				-- Removing default borders
				button:SetTexCoord(.07, .93, .07, .93)

				-- Styling button border
				local border = frame:CreateTexture(nil, "BACKGROUND")
				border:SetTexture(auraCastDB.AuraCastBorderTexture)
				border:SetTexCoord(0, 1, 0, 1)
				border:SetDrawLayer("BACKGROUND", -7)
				border:ClearAllPoints()
				border:SetPoint("TOPLEFT", button, -auraCastDB.AuraCastBorderPadding, auraCastDB.AuraCastBorderPadding)
				border:SetPoint("BOTTOMRIGHT", button, auraCastDB.AuraCastBorderPadding, -auraCastDB.AuraCastBorderPadding)
				border:SetGradientAlpha("VERTICAL", 
					auraCastDB.AuraCastBorderColor.br, auraCastDB.AuraCastBorderColor.bg, auraCastDB.AuraCastBorderColor.bb, auraCastDB.AuraCastBorderColor.ba, 
					auraCastDB.AuraCastBorderColor.tr, auraCastDB.AuraCastBorderColor.tg, auraCastDB.AuraCastBorderColor.tb, auraCastDB.AuraCastBorderColor.ta
				)
				button.border = border

				-- Set button as styled
				button.styled = true
			end

			-- Hooking functions
			local frame = CreateFrame("Frame")
			frame:SetScript("OnUpdate", function(self)

				if TargetFrameSpellBar.Icon then 
					styleAuraCastBar(TargetFrameSpellBar.Icon)
				end

				if FocusFrameSpellBar.Icon then
					styleAuraCastBar(FocusFrameSpellBar.Icon)
				end

				if TargetFrameSpellBar.Icon.styled and FocusFrameSpellBar.Icon.styled then
					frame:SetScript("OnUpdate", nil)
				end
			end)

			-- Set local saved variables version
			nameSpace.UI.Reloads["StyleAuraCast"] = true 
		end

		-- Toggle reload button and show a reload UI message
		nameSpace.UI.reloadCheck()
	end

-- ==================================================================================================
-- Buttons Functions
-- ==================================================================================================

	-- Utility function to apply a background for a button
	-- 
	-- @param Frame button: Button to add a background to
	local function applyButtonBackground(button)

		-- Checking if button has background already
		if not button or (button and button.bg) then return end

		-- Loading button background style from DB
		local backgroundDB = backgroundDB or zAddonDB.Skins.ButtonBG

		if button:GetFrameLevel() < 1 then button:SetFrameLevel(1) end

		-- Applying background and shadow
		button.bg = CreateFrame("Frame", nil, button, "BackdropTemplate")
		button.bg:SetPoint("TOPLEFT", button, "TOPLEFT", -backgroundDB.BtnBGPadding, backgroundDB.BtnBGPadding)
		button.bg:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", backgroundDB.BtnBGPadding, -backgroundDB.BtnBGPadding)
		button.bg:SetFrameLevel(button:GetFrameLevel() - 1)
		button.bg:SetBackdrop(backgroundDB.BtnBGBackdrop)
		button.bg:SetBackdropColor(unpack(backgroundDB.BtnBGColor))
		button.bg:SetBackdropBorderColor(unpack(backgroundDB.BtnBGBorderColor))
	end

	-- Apply extra action button style
	-- Require reload when disabled
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Skins.applyActionButtonStyle(state)

		if state then

			-- Loading action buttons style from DB
			local actionDB = actionDB or zAddonDB.Skins.ActionButtons

			-- Style action bar buttons and vehicle buttons
			local function styleActionButton(button)

				-- Return if not button or button is already styled
			    if not button or (button and button.styled) then return end

			    -- Get button info
			    local name = button:GetName()
			    local buttonAction = button.action
			    local icon  = _G[name.."Icon"]
			    local border  = _G[name.."Border"]
			    local normalTexture  = _G[name.."NormalTexture"]
			    local hotKey  = _G[name.."HotKey"]
			    local coolDown  = _G[name.."Cooldown"]
			    local buttonFlash  = _G[name.."Flash"]
				local flyoutBG  = _G[name.."FloatingBG"]
			    local flyoutBorder = _G[name.."FlyoutBorder"]
			    local flyoutBorderShadow = _G[name.."FlyoutBorderShadow"]

			    -- Checking if button is equippable item or a set
				if buttonAction and HasAction(buttonAction) then

					local actionType, id = GetActionInfo(buttonAction)

					if actionType == "item" and  IsEquippableItem(id) then
						button.equippableItem = true
					end
					
					if actionType == "equipmentset" then
						button.itemSet = true
					end
				end
				
			    -- Hide flyout button background
				if flyoutBG then flyoutBG:Hide() end

			    -- Hide flyout button border
			    if flyoutBorder then flyoutBorder:SetTexture(nil) end
			    if flyoutBorderShadow then flyoutBorderShadow:SetTexture(nil) end

			    -- Remove borders
				border:SetTexture(nil)

				-- Applying Textures
				button:SetNormalTexture(actionDB.ActionBtnNormalTexture)
				-- button:SetPushedTexture(nil)
				-- button:SetCheckedTexture()
				-- button:SetHighlightTexture()
				-- buttonFlash:SetTexture()

			    -- Style hot keys
			    hotKey:SetFont("STANDARD_TEXT_FONT", 12, "OUTLINE")
			    hotKey:ClearAllPoints()
			    hotKey:SetPoint("TOPRIGHT", button, 0, -5)
			    hotKey:SetPoint("TOPRIGHT", button, 0, -5)

				-- Style cooldown
				if (name:match("OverrideActionBarButton")) then

				    -- Style cooldown
			        coolDown:ClearAllPoints()
			        coolDown:SetPoint("TOPRIGHT", button, -3.5, -4)
			        coolDown:SetPoint('BOTTOMLEFT', button, 3.5, 3.5)
				else

				    -- Style cooldown
			        coolDown:ClearAllPoints()
			        coolDown:SetPoint("TOPRIGHT", button, -2, -2)
			        coolDown:SetPoint("BOTTOMLEFT", button, 2, 2)
				end

			    if not normalTexture then

			    	normalTexture = button:GetNormalTexture()
			    end

			    -- Cut icon's default borders
			    icon:SetTexCoord(.05, .95, .05, .95)
			    icon:SetPoint("TOPLEFT", button, 1.5, -1.5)
			    icon:SetPoint("BOTTOMRIGHT", button, -1.5, 1.5)

			    -- Editting checked texture
			    local checkedTexture = button:GetCheckedTexture()
			    checkedTexture:ClearAllPoints()
				checkedTexture:SetPoint("TOPLEFT", button, 2, -2)
				checkedTexture:SetPoint("BOTTOMRIGHT", button, -2, 2)

			    -- Positioning textures
				normalTexture:ClearAllPoints()
				normalTexture:SetPoint("TOPLEFT", button, -actionDB.ActionBtnBorderPadding, actionDB.ActionBtnBorderPadding)
				normalTexture:SetPoint("BOTTOMRIGHT", button, actionDB.ActionBtnBorderPadding, -actionDB.ActionBtnBorderPadding)

				-- Set texture
			    if buttonAction and button.equippableItem then

			    	button:SetNormalTexture(actionDB.ActionBtnEquippedTexture)
			    elseif buttonAction and button.itemSet then

					button:SetNormalTexture(actionDB.ActionBtnSetTexture)
			    else

					button:SetNormalTexture(actionDB.ActionBtnNormalTexture)
			    end

				normalTexture:SetGradientAlpha("VERTICAL", 
					actionDB.ActionBtnNormalColor.br, actionDB.ActionBtnNormalColor.bg, actionDB.ActionBtnNormalColor.bb, actionDB.ActionBtnNormalColor.ba, 
					actionDB.ActionBtnNormalColor.tr, actionDB.ActionBtnNormalColor.tg, actionDB.ActionBtnNormalColor.tb, actionDB.ActionBtnNormalColor.ta
				)

				button:GetNormalTexture():SetGradientAlpha("VERTICAL", 
					actionDB.ActionBtnNormalColor.br, actionDB.ActionBtnNormalColor.bg, actionDB.ActionBtnNormalColor.bb, actionDB.ActionBtnNormalColor.ba, 
					actionDB.ActionBtnNormalColor.tr, actionDB.ActionBtnNormalColor.tg, actionDB.ActionBtnNormalColor.tb, actionDB.ActionBtnNormalColor.ta
				)

			    -- Hooking to prevent blizzard from reseting colors
			    hooksecurefunc(normalTexture, "SetVertexColor", function(normalTexture, r, g, b, a)

					normalTexture:SetGradientAlpha("VERTICAL", 
						actionDB.ActionBtnNormalColor.br, actionDB.ActionBtnNormalColor.bg, actionDB.ActionBtnNormalColor.bb, actionDB.ActionBtnNormalColor.ba, 
						actionDB.ActionBtnNormalColor.tr, actionDB.ActionBtnNormalColor.tg, actionDB.ActionBtnNormalColor.tb, actionDB.ActionBtnNormalColor.ta
					)
			    end)

			    -- Apply background
			    if not button.bg then
			    	applyButtonBackground(button)
			    end

		    	-- Avoid hooking on fly out buttons
		    	if not name:match("SpellFlyoutButton") then
		    		
					-- Hook on button update function
					hooksecurefunc(button, "Update", function(self)

						local buttonAction = self.action

					    -- Checking if button is equippable item or a set
						if buttonAction and HasAction(buttonAction) then

							local actionType, id = GetActionInfo(buttonAction)

							if actionType == "item" and IsEquippableItem(id) then
								
								self:SetNormalTexture(actionDB.ActionBtnEquippedTexture)
							elseif actionType == "equipmentset" then
									
								self:SetNormalTexture(actionDB.ActionBtnSetTexture)
							else
								self:SetNormalTexture(actionDB.ActionBtnNormalTexture)
							end
					    end
					end)

					-- Hook on empty button slot update function
					hooksecurefunc(button, "ShowGrid", function(self)

						local normalTexture = _G[self:GetName().."NormalTexture"]

					    if normalTexture then

							self:SetNormalTexture(actionDB.ActionBtnNormalTexture)
							normalTexture:SetGradientAlpha("VERTICAL", 
								actionDB.ActionBtnNormalColor.br, actionDB.ActionBtnNormalColor.bg, actionDB.ActionBtnNormalColor.bb, actionDB.ActionBtnNormalColor.ba, 
								actionDB.ActionBtnNormalColor.tr, actionDB.ActionBtnNormalColor.tg, actionDB.ActionBtnNormalColor.tb, actionDB.ActionBtnNormalColor.ta
							)
					    end
					end)
		    	end

			    -- Set button as styled
			    button.styled = true
			end

			-- Applying style on all action bars
			for i = 1, NUM_ACTIONBAR_BUTTONS do

				styleActionButton(_G["ActionButton"..i])
				styleActionButton(_G["MultiBarBottomLeftButton"..i])
				styleActionButton(_G["MultiBarBottomRightButton"..i])
				styleActionButton(_G["MultiBarRightButton"..i])
				styleActionButton(_G["MultiBarLeftButton"..i])
			end

			-- Style vehicle buttons
		    for i = 1, 6 do

		      styleActionButton(_G["OverrideActionBarButton"..i])
		    end

			-- Styling flyout buttons
		    SpellFlyoutBackgroundEnd:SetTexture(nil)
		    SpellFlyoutHorizontalBackground:SetTexture(nil)
		    SpellFlyoutVerticalBackground:SetTexture(nil)

		    -- Check for any flyout buttons
		    local function checkForFlyoutButtons(self)

				local NUM_FLYOUT_BUTTONS = 10

				for i = 1, NUM_FLYOUT_BUTTONS do

					styleActionButton(_G["SpellFlyoutButton"..i])
				end
		    end

		    SpellFlyout:HookScript("OnShow",checkForFlyoutButtons)

			-- Check if Dominos or Bartender are loaded
			if IsAddOnLoaded("dominos") then

				for i = 1, 60 do
		        	styleActionButton(_G["DominosActionButton"..i])
				end
			end

			if IsAddOnLoaded("bartender4") then
				for i = 1, 120 do
					styleActionButton(_G["BT4Button"..i])
					styleActionButton(_G["BT4PetButton"..i])
				end
			end

			-- Set local saved variables version
			nameSpace.UI.Reloads["StyleActionButtons"] = true 
		end

		-- Toggle reload button and show a reload UI message
		nameSpace.UI.reloadCheck()
	end
	
	-- Apply extra action button style
	-- Require reload when disabled
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Skins.applyExtraButtonStyle(state)

		if state then

			-- Loading extra action button style from DB
			local extraDB = extraDB or zAddonDB.Skins.ExtraButton	

			-- Style extra action button and zone ability button
			local function styleExtraActionButton(button)

				-- Return if not button or button is already styled
				if not button or (button and button.styled) then return end

				-- Get button info
				local name = button:GetName() or button:GetParent():GetName()
				local style = button.style or button.Style
				local icon = button.icon or button.Icon
				local cooldown = button.cooldown or button.Cooldown

				-- Remove button background frame
				style:SetTexture(nil)

				hooksecurefunc(style, "SetTexture", function(self, texture)

				  if texture then
				    self:SetTexture(nil)
				  end
				end)

				-- Cut icon's default borders
			    icon:SetTexCoord(.05, .95, .05, .95)
				icon:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
				icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)

				-- Adjust cooldown
				cooldown:SetPoint("TOPLEFT", icon, "TOPLEFT", 2, -2)
				cooldown:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -2, 2)

				-- Applying textures
				button:SetNormalTexture(extraDB.ExtraBtnNormalTexture)
				local normalTexture = button:GetNormalTexture()
				normalTexture:SetGradientAlpha("VERTICAL", 
					extraDB.ExtraBtnNormalColor.br, extraDB.ExtraBtnNormalColor.bg, extraDB.ExtraBtnNormalColor.bb, extraDB.ExtraBtnNormalColor.ba, 
					extraDB.ExtraBtnNormalColor.tr, extraDB.ExtraBtnNormalColor.tg, extraDB.ExtraBtnNormalColor.tb, extraDB.ExtraBtnNormalColor.ta
				)
				normalTexture:SetAllPoints(button)

			    -- Hooking to prevent blizzard from reseting colors
			    hooksecurefunc(normalTexture, "SetVertexColor", function(normalTexture, r, g, b, a)

			    	normalTexture:SetGradientAlpha("VERTICAL", 
			    		extraDB.ExtraBtnNormalColor.br, extraDB.ExtraBtnNormalColor.bg, extraDB.ExtraBtnNormalColor.bb, extraDB.ExtraBtnNormalColor.ba, 
			    		extraDB.ExtraBtnNormalColor.tr, extraDB.ExtraBtnNormalColor.tg, extraDB.ExtraBtnNormalColor.tb, extraDB.ExtraBtnNormalColor.ta
			    	)
			    end)

			    -- Apply background
			    if not button.bg then
			    	applyButtonBackground(button)
			    end

			    -- Set button as styled
			    button.styled = true
			end

			styleExtraActionButton(ExtraActionButton1)
			styleExtraActionButton(ZoneAbilityFrame.SpellButton)

			-- Set local saved variables version
			nameSpace.UI.Reloads["StyleExtraButton"] = true 
		end

		-- Toggle reload button and show a reload UI message
		nameSpace.UI.reloadCheck()
	end

	-- Apply bag buttons style
	-- Require reload when disabled
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Skins.applyBagsStyle(state)

		if state then

			-- Loading bag buttons style from DB
			local bagDB = bagDB or zAddonDB.Skins.Bags	

			-- Style bag buttons
			local function styleBagButton(button)

				-- Return if not button or button is already styled
				if not button or (button and button.styled) then return end

				-- Getting button info
				local name = button:GetName()
				local icon = _G[name.."IconTexture"]
				local normalTexture  = _G[name.."NormalTexture"]
				local border = button.IconBorder

				normalTexture:SetTexCoord(0, 1, 0, 1)
				normalTexture:SetDrawLayer("BACKGROUND", -7)
				normalTexture:SetAllPoints(button)

				-- Hide bags border
				border:Hide()
				border.Show = function() end

				--Cut icon's curves and add padding
				icon:SetTexCoord(.08, .92, .08, .92)
			    icon:SetPoint("TOPLEFT", button, "TOPLEFT", bagDB.BagBorderPadding, -bagDB.BagBorderPadding)
			    icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -bagDB.BagBorderPadding, bagDB.BagBorderPadding)

				-- Applying textures
			  	button:SetNormalTexture(bagDB.BagNormalTexture)
			  	-- button:SetPushedTexture()
				-- button:SetCheckedTexture()
				-- button:SetHighlightTexture()

				-- Setting color
				normalTexture:SetGradientAlpha("VERTICAL", 
					bagDB.BagNormalColor.br, bagDB.BagNormalColor.bg, bagDB.BagNormalColor.bb, bagDB.BagNormalColor.ba, 
					bagDB.BagNormalColor.tr, bagDB.BagNormalColor.tg, bagDB.BagNormalColor.tb, bagDB.BagNormalColor.ta
				)

			    -- Hook button's normal texture
				hooksecurefunc(button, "SetNormalTexture", function(self, texture)

					if texture and texture ~= bagDB.BagNormalTexture  then

						self:SetNormalTexture(bagDB.BagNormalTexture)
					end
			   	end)

			    -- Hooking to prevent Blizzard from reseting colors
			    hooksecurefunc(normalTexture, "SetVertexColor", function(normalTexture, r, g, b, a)

					normalTexture:SetGradientAlpha("VERTICAL", 
						bagDB.BagNormalColor.br, bagDB.BagNormalColor.bg, bagDB.BagNormalColor.bb, bagDB.BagNormalColor.ba, 
						bagDB.BagNormalColor.tr, bagDB.BagNormalColor.tg, bagDB.BagNormalColor.tb, bagDB.BagNormalColor.ta
					)
			    end)

			    -- Apply background
			    if not button.bg then
			    	applyButtonBackground(button)
			    end

			    -- Set button as styled
			    button.styled = true
			end

			-- Apply the bag style
		    for i = 0, 3 do
				styleBagButton(_G["CharacterBag"..i.."Slot"])
		    end

			styleBagButton(MainMenuBarBackpackButton)


			-- Set local saved variables version
			nameSpace.UI.Reloads["StyleBags"] = true
		end

		-- Toggle reload button and show a reload UI message
		nameSpace.UI.reloadCheck()
	end

	-- Apply pet bar buttons style
	-- Require reload when disabled
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Skins.applyPetButtonsStyle(state)

		if state then

			-- Loading pat bar buttons style from DB
			local petDB = petDB or zAddonDB.Skins.PetButtons	

			-- Style pet bar buttons
			local function stylePetButton(button)

				-- Return if not button or button is already styled
				if not button or (button and button.styled) then return end
				
				-- Get button info
			    local name = button:GetName()
			    local icon  = _G[name.."Icon"]
			    local normalTexture  = _G[name.."NormalTexture2"]
			    local buttonFlash  = _G[name.."Flash"]

			    -- Positioning textures
			    normalTexture:SetAllPoints(button)

			    -- Applying textures
			  	button:SetNormalTexture(petDB.PetBtnNormalTexture)
			  	-- button:SetPushedTexture()
				-- button:SetCheckedTexture()
				-- button:SetHighlightTexture()
				-- buttonFlash:SetTexture()

			    -- Setting color
			    normalTexture:SetGradientAlpha("VERTICAL", 
			    	petDB.PetBtnNormalColor.br, petDB.PetBtnNormalColor.bg, petDB.PetBtnNormalColor.bb, petDB.PetBtnNormalColor.ba, 
			    	petDB.PetBtnNormalColor.tr, petDB.PetBtnNormalColor.tg, petDB.PetBtnNormalColor.tb, petDB.PetBtnNormalColor.ta
			    )

			    -- Cut icon's default borders
			    icon:SetTexCoord(.07, .93, .07, .93)
			    icon:SetPoint("TOPLEFT", button, "TOPLEFT", petDB.PetBtnBorderPadding, -petDB.PetBtnBorderPadding)
			    icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -petDB.PetBtnBorderPadding, petDB.PetBtnBorderPadding)

			    hooksecurefunc(button, "SetNormalTexture", function(self, texture)

			      if texture and texture ~= petDB.PetBtnNormalTexture then

			        self:SetNormalTexture(petDB.PetBtnNormalTexture)
			      end
			    end)

			    -- Apply background
			    if not button.bg then
			    	applyButtonBackground(button)
			    end

			    -- Set button as styled
			    button.styled = true
			end

			-- Apply pet bar button style
		    for i = 1, NUM_PET_ACTION_SLOTS do
		      stylePetButton(_G["PetActionButton"..i])
		    end

		    -- Hide pet bar borders (Border only visible if top multi bar action is not shown)
			SlidingActionBarTexture0:SetTexture("")
			SlidingActionBarTexture1:SetTexture("")

			-- Set local saved variables version
			nameSpace.UI.Reloads["StylePetButtons"] = true
		end

		-- Toggle reload button and show a reload UI message
		nameSpace.UI.reloadCheck()
	end

	-- Apply stance bar buttons style
	-- Require reload when disabled
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Skins.applyStanceButtonsStyle(state)

		if state then

			-- Loading stance bar buttons style from DB
			local stanceDB = stanceDB or zAddonDB.Skins.StanceButtons	

			-- Style stance buttons
			local function styleStanceButton(button)

				-- Return if not button or button is already styled
				if not button or (button and button.styled) then return end

				-- Get button info
			    local name = button:GetName()
			    local icon  = _G[name.."Icon"]
				local normalTexture  = _G[name.."NormalTexture2"]
			    local buttonFlash  = _G[name.."Flash"]

			    -- Positioning textures
			    normalTexture:SetAllPoints(button)

			    -- Set color
			    normalTexture:SetGradientAlpha("VERTICAL", 
			    	stanceDB.StanceBtnNormalColor.br, stanceDB.StanceBtnNormalColor.bg, stanceDB.StanceBtnNormalColor.bb, stanceDB.StanceBtnNormalColor.ba, 
			    	stanceDB.StanceBtnNormalColor.tr, stanceDB.StanceBtnNormalColor.tg, stanceDB.StanceBtnNormalColor.tb, stanceDB.StanceBtnNormalColor.ta
			    )

			    -- Applying textures
			  	button:SetNormalTexture(stanceDB.StanceBtnNormalTexture)
			  	-- button:SetPushedTexture()
				-- button:SetCheckedTexture()
				-- button:SetHighlightTexture()
				-- buttonFlash:SetTexture()

				-- Cut icon's default borders
			    icon:SetTexCoord(.07, .93, .07, .93)
			    icon:SetPoint("TOPLEFT", button, "TOPLEFT", stanceDB.StanceBtnBorderPadding, -stanceDB.StanceBtnBorderPadding)
			    icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -stanceDB.StanceBtnBorderPadding, stanceDB.StanceBtnBorderPadding)

			    -- Apply background
			    if not button.bg then
			    	applyButtonBackground(button)
			    end

			    -- Set button as styled
			    button.styled = true
			end

			-- Apply stance buttons style
		    for i=1, NUM_STANCE_SLOTS do
		      styleStanceButton(_G["StanceButton"..i])
		    end

		    -- Hide stance bar borders
			StanceBarLeft:SetAlpha(0)
			StanceBarRight:SetAlpha(0)
			StanceBarMiddle:SetAlpha(0)

			-- Set local saved variables version
			nameSpace.UI.Reloads["StyleStanceButtons"] = true
		end

		-- Toggle reload button and show a reload UI message
		nameSpace.UI.reloadCheck()
	end

	-- Apply posses bar buttons style
	-- Require reload when disabled
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Skins.applyPossessButtonsStyle(state)

		if state then

			-- Loading posses bar buttons style from DB
			local possessDB = possessDB or zAddonDB.Skins.PossessButtons	

			-- Style possess bar buttons
			local function stylePossessButton(button)

				-- Return if not button or button is already styled
				if not button or (button and button.styled) then return end

				-- Get button info
			    local name = button:GetName()
			    local icon = _G[name.."Icon"]
				local normalTexture = _G[name.."NormalTexture"]
			    local buttonFlash = _G[name.."Flash"]

			    -- Positioning textures
			    normalTexture:SetAllPoints(button)

			    -- Set color
			    normalTexture:SetGradientAlpha("VERTICAL", 
			    	possessDB.PossessBtnNormalColor.br, possessDB.PossessBtnNormalColor.bg, possessDB.PossessBtnNormalColor.bb, possessDB.PossessBtnNormalColor.ba, 
			    	possessDB.PossessBtnNormalColor.tr, possessDB.PossessBtnNormalColor.tg, possessDB.PossessBtnNormalColor.tb, possessDB.PossessBtnNormalColor.ta
			    )

			    -- Applying textures
			  	button:SetNormalTexture(possessDB.PossessBtnNormalTexture)
			  	-- button:SetPushedTexture()
				-- button:SetCheckedTexture()
				-- button:SetHighlightTexture()
				-- buttonFlash:SetTexture()

			    -- Cut icon's default borders
			    icon:SetTexCoord(.07, .93, .07, .93)
			    icon:SetPoint("TOPLEFT", button, "TOPLEFT", possessDB.PossessBtnBorderPadding, -possessDB.PossessBtnBorderPadding)
			    icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -possessDB.PossessBtnBorderPadding, possessDB.PossessBtnBorderPadding)

			    -- Apply background
			    if not button.bg then
			    	applyButtonBackground(button)
			    end

			    -- Set button as styled
			    button.styled = true
			end

			-- Apply posses button style
			for i = 1, NUM_POSSESS_SLOTS do

		      stylePossessButton(_G["PossessButton"..i])
		      _G["PossessBackground"..i]:SetTexture("")
		    end

			-- Set local saved variables version
			nameSpace.UI.Reloads["StylePossessButtons"] = true
		end

		-- Toggle reload button and show a reload UI message
		nameSpace.UI.reloadCheck()
	end

	-- Apply vehicle leave buttons style
	-- Require reload when disabled
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Skins.applyLeaveButtonStyle(state)

		if state then

			-- Loading leave button style from DB
			local leaveDB = bagDB or zAddonDB.Skins.LeaveButton

			-- Style leave button
			local function styleLeaveButton(button)

				-- Return if not button or button is already styled
				if not button or (button and button.styled) then return end

				-- Get button info
			    local name = button:GetName()
			    local normalTexture  = button:GetNormalTexture()
				local border = button:CreateTexture(name.."Border", "BACKGROUND", nil, -7)
				
				-- Cut icon's default borders
				normalTexture:SetTexCoord(.20, .80, .20, .80)
				normalTexture:SetPoint("TOPLEFT", button, "TOPLEFT", leaveDB.LeaveBtnBorderPadding, -leaveDB.LeaveBtnBorderPadding)
			    normalTexture:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -leaveDB.LeaveBtnBorderPadding, leaveDB.LeaveBtnBorderPadding)

			    -- Apply texture
				border:SetTexture(leaveDB.LeaveBtnNormalTexture)
				border:SetTexCoord(0, 1, 0, 1)
				border:SetDrawLayer("BACKGROUND", -7)
				border:SetGradientAlpha("VERTICAL", 
					leaveDB.LeaveBtnNormalColor.br, leaveDB.LeaveBtnNormalColor.bg, leaveDB.LeaveBtnNormalColor.bb, leaveDB.LeaveBtnNormalColor.ba, 
					leaveDB.LeaveBtnNormalColor.tr, leaveDB.LeaveBtnNormalColor.tg, leaveDB.LeaveBtnNormalColor.tb, leaveDB.LeaveBtnNormalColor.ta
				)
				border:ClearAllPoints()
				border:SetAllPoints(button)

			    -- Apply background
			    if not button.bg then
			    	applyButtonBackground(button)
			    end

			    -- Set button as styled
			    button.styled = true
			end

			-- Apply leave button style
			styleLeaveButton(MainMenuBarVehicleLeaveButton)
	    	styleLeaveButton(rABS_LeaveVehicleButton)

	    	-- Set local saved variables version
			nameSpace.UI.Reloads["StyleLeaveButton"] = true
		end

		-- Toggle reload button and show a reload UI message
		nameSpace.UI.reloadCheck()
	end

-- ==================================================================================================
-- Misc Functions
-- ==================================================================================================

	-- Apply a dark color to main action bar and micro buttons style
	-- Require reload when disabled
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Skins.applyMainBarStyle(state)

		if state then

			-- Loading main bar style from DB
			local mainBarDB = mainBarDB or zAddonDB.Skins.MainBar

			for i, v in pairs({

				MainMenuBarArtFrame.LeftEndCap,
				MainMenuBarArtFrame.RightEndCap,
				StanceBarLeft,
				StanceBarMiddle,
				StanceBarRight,
				MainMenuBarArtFrameBackground.BackgroundLarge,
				MainMenuBarArtFrameBackground.BackgroundSmall,
				StatusTrackingBarManager.SingleBarLargeUpper,
				StatusTrackingBarManager.SingleBarSmallUpper,
				StatusTrackingBarManager.SingleBarSmall,
				MicroButtonAndBagsBar.MicroBagBar,
			}) do

				v:SetVertexColor(unpack(mainBarDB.MainBarColor))
			end

			-- Action buttons scroll up and down buttons
			ActionBarUpButton:GetNormalTexture():SetVertexColor(unpack(mainBarDB.MainBarColor))
			ActionBarDownButton:GetNormalTexture():SetVertexColor(unpack(mainBarDB.MainBarColor))

			-- Minimap and clock
			-- MinimapBorder:SetVertexColor(0.5, 0.5, 0.5, 1)
			-- select(1, TimeManagerClockButton:GetRegions()):SetVertexColor(0.5, 0.5, 0.5, 1)

	    	-- Set local saved variables version
			nameSpace.UI.Reloads["StyleMainBar"] = true
		end

		-- Toggle reload button and show a reload UI message
		nameSpace.UI.reloadCheck()
	end

	-- Apply a dark border around chat frame tabs
	-- Require reload when disabled
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Skins.applyChatStyle(state)

		if state then

			-- Loading chat frame style from DB
			local chatDB = chatDB or zAddonDB.Skins.ChatFrame

			for i = 1, NUM_CHAT_WINDOWS do

				local name = _G["ChatFrame" .. i]:GetName()

				for i, v in pairs({

					_G[name .. "TabLeft"],
					_G[name .. "TabMiddle"],
					_G[name .. "TabRight"],
					_G[name .. "TabHighlightLeft"],
					_G[name .. "TabHighlightMiddle"],
					_G[name .. "TabHighlightRight"],
					_G[name .. "TabSelectedLeft"],
					_G[name .. "TabSelectedMiddle"],
					_G[name .. "TabSelectedRight"],
					-- _G[name .. "EditBoxLeft"],
					-- _G[name .. "EditBoxMid"],
					-- _G[name .. "EditBoxRight"],
					}) do

				    v:SetVertexColor(unpack(chatDB.ChatFrameColor))
				end
			end

	    	-- Set local saved variables version
			nameSpace.UI.Reloads["StyleChatFrame"] = true
		end

		-- Toggle reload button and show a reload UI message
		nameSpace.UI.reloadCheck()
	end

	-- Apply a darker tooltip style, color the information and add target of target functionality
	-- Require reload when disabled
	-- 
	-- @param Boolean state: Boolean to toggle the functionality
	function Skins.applyTooltipStyle(state)

		if state then

			-- Loading tooltip style from DB
			local tooltipDB = tooltipDB or zAddonDB.Skins.Tooltip

			-- Tooltip colors
			local classHexColors, factionHexColors = {}, {}
			local statusBarColor, targetTextHexColor, AfkHexColor

			-- Return a hex color
			local function getHexColor(color)

				if color.r then
					return ("%.2x%.2x%.2x"):format(color.r * 255, color.g * 255, color.b * 255)
				else
					local r,g,b,a = unpack(color)
					return ("%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255)
				end
			end

			-- Fixing status bar color
			local function fixStatusBarColor(self, r, g, b)

				if not statusBarColor then return end
				
				if r == statusBarColor.r and g == statusBarColor.g and b == statusBarColor.b then return end

				self:SetStatusBarColor(statusBarColor.r, statusBarColor.g, statusBarColor.b)
			end

			-- Tooltip coloring hook function
			local function tooltipBase(self)

			  self:SetBackdropColor(unpack(tooltipDB.TooltipBGColor))
			  self:SetBackdropBorderColor(unpack(tooltipDB.TooltipBorderColor))
			end

			-- Get player's target
			local function getPlayerTarget(unit)

				if UnitIsUnit(unit, "player") then

					return ("|cffff0000%s|r"):format("<YOU>")
				elseif UnitIsPlayer(unit, "player") then

					local _, class = UnitClass(unit)
					return ("|cff%s%s|r"):format(classHexColors[class], UnitName(unit))
				elseif UnitReaction(unit, "player") then

					return ("|cff%s%s|r"):format(factionHexColors[UnitReaction(unit, "player")], UnitName(unit))
				else

					return ("|cffffffff%s|r"):format(UnitName(unit))
				end
			end

			-- Handle tooltip set unit event
			local function tooltipOnSetUnit(self)

				-- Get unit info
				local unitName, unit = self:GetUnit()

				if not unit then return end

				-- Change All Unit Text Color
				-- GameTooltipTextLeft2:SetTextColor(unpack(tooltipDB.BodyTextColor))
				-- GameTooltipTextLeft3:SetTextColor(unpack(tooltipDB.BodyTextColor))
				-- GameTooltipTextLeft4:SetTextColor(unpack(tooltipDB.BodyTextColor))
				-- GameTooltipTextLeft5:SetTextColor(unpack(tooltipDB.BodyTextColor))
				-- GameTooltipTextLeft6:SetTextColor(unpack(tooltipDB.BodyTextColor))
				-- GameTooltipTextLeft7:SetTextColor(unpack(tooltipDB.BodyTextColor))
				-- GameTooltipTextLeft8:SetTextColor(unpack(tooltipDB.BodyTextColor))

				-- Unit is not a player
				if not UnitIsPlayer(unit) then

					-- Color header and status bar by faction color
				    local reaction = UnitReaction(unit, "player")

				    if reaction then

				      local color = FACTION_BAR_COLORS[reaction]

				      if color then

						statusBarColor = color
				        GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
				        GameTooltipTextLeft1:SetTextColor(color.r, color.g, color.b)
				      end
				    end

				    -- Check if unit has description
				    local unitClassification = UnitClassification(unit)
				    local levelLine

				    if string.find(GameTooltipTextLeft2:GetText() or "empty", "%a%s%d") then

						levelLine = GameTooltipTextLeft2
				    elseif string.find(GameTooltipTextLeft3:GetText() or "empty", "%a%s%d") then

				    	-- NPC Description Text
						-- GameTooltipTextLeft2:SetTextColor(unpack(tooltipDB.GuildTextColor))
						levelLine = GameTooltipTextLeft3
				    end

				    -- Color unit level line
				    if levelLine then

						local level = UnitLevel(unit)
						local color = GetCreatureDifficultyColor((level > 0) and level or 999)
						levelLine:SetTextColor(color.r, color.g, color.b)
				    end

				    -- Show unit type icon
				    if unitClassification == "worldboss" or UnitLevel(unit) == -1 then

						self:AppendText(" |TInterface\\TargetingFrame\\UI-TargetingFrame-Skull:14:14|t")
						GameTooltipTextLeft2:SetTextColor(unpack(tooltipDB.TooltipBossTextColor))
					end
				else

					-- Get player class
					local _, unitClass = UnitClass(unit)

					-- Color header and status bar by class color
					local color = RAID_CLASS_COLORS[unitClass]
					statusBarColor = color
					GameTooltipTextLeft1:SetTextColor(color.r, color.g, color.b)
					GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)

					-- Color player guild text
			    	local unitGuild = GetGuildInfo(unit)

			    	if unitGuild then
						GameTooltipTextLeft2:SetText("<"..unitGuild..">")
						GameTooltipTextLeft2:SetTextColor(unpack(tooltipDB.ToolTipGuildTextColor))
			    	end

			    	-- Color player level line
					local levelLine = unitGuild and GameTooltipTextLeft3 or GameTooltipTextLeft2
					local level = UnitLevel(unit)
			    	local color = GetCreatureDifficultyColor((level > 0) and level or 999)
			    	levelLine:SetTextColor(color.r, color.g, color.b)

			    	-- Player is AFK
			    	if UnitIsAFK(unit) then
						self:AppendText((" |cff%s<AFK>|r"):format(AfkHexColor))
			    	end
				end

				-- Unit is dead
				if UnitIsDeadOrGhost(unit) then
				    GameTooltipTextLeft1:SetTextColor(unpack(tooltipDB.TooltipDeadTextColor))
				end

				-- Unit's target
				if (UnitExists(unit.."target")) then
					GameTooltip:AddDoubleLine(("|cff%s%s|r"):format(targetTextHexColor, "Target"),getPlayerTarget(unit.."target") or "Unknown")
				end
			end

			-- Hooking status bar color
			hooksecurefunc(GameTooltipStatusBar,"SetStatusBarColor", fixStatusBarColor)

			-- Set classes hex colors
			for class, color in next, RAID_CLASS_COLORS do
				classHexColors[class] = getHexColor(color)
			end

			-- Set factions hex colors
			for i = 1, #FACTION_BAR_COLORS do
				factionHexColors[i] = getHexColor(FACTION_BAR_COLORS[i])
			end

			-- Set target and AFK hex colors
			targetTextHexColor = getHexColor(tooltipDB.TooltipTargetTextColor)
			AfkHexColor = getHexColor(tooltipDB.TooltipAfkTextColor)

			-- Style tooltip header text
			GameTooltipHeaderText:SetFont(tooltipDB.FontFamily, 14, "NONE")
			GameTooltipHeaderText:SetShadowOffset(1, -1)
			GameTooltipHeaderText:SetShadowColor(0, 0, 0, 0.9)

			-- Style tooltip body text
			GameTooltipText:SetFont(tooltipDB.FontFamily, 12, "NONE")
			GameTooltipText:SetShadowOffset(1, -1)
			GameTooltipText:SetShadowColor(0, 0, 0, 0.9)

			-- Style tooltip small text
			Tooltip_Small:SetFont(tooltipDB.FontFamily, 19, "NONE")
			Tooltip_Small:SetShadowOffset(1, -1)
			Tooltip_Small:SetShadowColor(0, 0, 0, 0.9)

			-- Game tooltip status bar
			GameTooltipStatusBar:ClearAllPoints()
			GameTooltipStatusBar:SetPoint("LEFT", 5, 0)
			GameTooltipStatusBar:SetPoint("RIGHT", -5, 0)
			GameTooltipStatusBar:SetPoint("TOP", 0, -2.5)
			GameTooltipStatusBar:SetHeight(tooltipDB.TooltipStatusBarHeight)

			-- Game tooltip status bar background
			GameTooltipStatusBar.bg = GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND", nil, -8)
			GameTooltipStatusBar.bg:SetAllPoints()
			GameTooltipStatusBar.bg:SetColorTexture(1, 1, 1)
			GameTooltipStatusBar.bg:SetVertexColor(0, 0, 0, 0.7)

			-- Tooltip on unit event
			GameTooltip:HookScript("OnTooltipSetUnit", tooltipOnSetUnit)

			-- Loop over all tooltips
			local tooltips = {GameTooltip, ItemRefTooltip, ShoppingTooltip1, ShoppingTooltip2, ShoppingTooltip3, WorldMapTooltip, SmallTextTooltip}

			for i, tooltip in pairs(tooltips) do

				tooltip:SetBackdrop(tooltipDB.TooltipBackdrop)
				tooltip:SetScale(tooltipDB.TooltipScale)
				tooltip:HookScript("OnShow", tooltipBase)
				tooltip:HookScript("OnUpdate", tooltipBase)
				tooltip:HookScript("OnHide", tooltipBase)
			end

			-- Loop over all menus
			local menus = {DropDownList1MenuBackdrop, DropDownList2MenuBackdrop}

			for i, menu in pairs(menus) do

			  menu:SetScale(tooltipDB.TooltipScale)
			end

	    	-- Set local saved variables version
			nameSpace.UI.Reloads["StyleTooltip"] = true
		end

		-- Toggle reload button and show a reload UI message
		nameSpace.UI.reloadCheck()
	end
