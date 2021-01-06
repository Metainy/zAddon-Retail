-- Addon's namespace
local zAddon, nameSpace = ...

-- Adding tables to addon's namespace
nameSpace.PowerBar = {}

-- Creating namespace tables
local PowerBar = nameSpace.PowerBar

-- Creating local tables
local zPower

-- Power bar DB
local powerDB

-- Local variables
local playerClass, playerSpec
local powerType, powerColor, currentPower, maxPower
local attackSpeed
local spellCost = 0

-- ==================================================================================================
-- Power Bar Helper Functions
-- ==================================================================================================

	-- Check if the player spec allow for power prediction and also if user enabled predictionز
	--
	-- @return Boolean boolean: Power prediction state
	local function predictionEnabled()

		return powerDB.PBPrediction and nameSpace.Config.Class[playerClass][playerSpec].PowerPrediction
	end

	-- Get power bar color based on enabled options.
	-- If class colored or low health color are enabled this function return the right color to be used
	--
	-- @param Number currentPower : Player's current power
	-- 
	-- @return Array barColor: The status bar color
	local function getPowerBarColor(currentPower)

		-- Set default power color
		local barColor = powerColor

		-- Check if power color is overriden
		if (powerDB.PBCustomColor) then

			barColor = powerDB.PBBarColor
		end

		-- Check if high resources color enabled
		if powerDB.EnablePBHighColor and ((currentPower / maxPower) >= powerDB.PBHighThreshold) then

			barColor = powerDB.PBHighColor
		end

		-- Check if low resources color enabled
		if powerDB.EnablePBLowColor and ((currentPower / maxPower) < powerDB.PBLowThreshold) then

			barColor = powerDB.PBLowColor
		end

		return barColor
	end

	-- Create the power bar text.
	-- Will attach the text to the bar and can be toggled from options
	--
	-- @param Frame mainBar: The main bar frame which string will be attached to
	--
	-- @return FontString text: The status bar text
	local function createBarText(mainBar)

		-- Create font frame on top of all bars
		local fontFrame = CreateFrame("Frame", nil, mainBar)
		fontFrame:SetFrameLevel(mainBar:GetFrameLevel() + 5)
		fontFrame:SetAllPoints(mainBar)

		-- Create power bar text
		local text = fontFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		text:ClearAllPoints()
		text:SetJustifyH("CENTER")
		text:SetPoint("CENTER", mainBar, "CENTER", powerDB.PBFontPos.BPFontX, powerDB.PBFontPos.BPFontY)
		text:SetFont(powerDB.PBFontFamily, powerDB.PBFontSize, powerDB.PBFontStyle)
		text:SetTextColor(unpack(powerDB.PBFontColor))
		text:SetShadowOffset(0, 0)
		text:Show()

		-- Return bar text
		return text
	end

	-- Create power prediction bar.
	--
	-- @param Frame mainBar The power bar main frame
	--
	-- @return Frame predictionBar: The newely created prediction bar frame
	local function createPredictionBar(mainBar)

		-- Create incoming heal bar
		local predictionBar = CreateFrame("StatusBar", nil, mainBar)
		-- predictionBar:ClearAllPoints()
		-- predictionBar:SetAllPoints(mainBar)
		predictionBar:SetStatusBarTexture(powerDB.PBPredictionTexture)
		predictionBar:SetMinMaxValues(0, 1)
		predictionBar:SetValue(1)
		predictionBar:SetFrameLevel(mainBar:GetFrameLevel() + 1)
		predictionBar:Hide()

		-- Return prediction bar
		return predictionBar
	end

	-- Update prediction bar.
	-- Check for predicted power loss and update the bar accordingly
	local function updatePrediction()

		if (spellCost > 0) and (not UnitIsDeadOrGhost("player") ) then

			-- Set bar color
			local barColor = getPowerBarColor(currentPower)
			zPower.predictionBar:SetStatusBarColor(barColor[1] + .25, barColor[2] + .25, barColor[3] + .25, 1)

			local width = ((zPower:GetWidth() / maxPower) * spellCost)

			if (width < zPower:GetWidth()) and spellCost < zPower:GetValue() then


				zPower.predictionBar:SetSize(width, zPower:GetHeight())
				zPower.predictionBar:SetPoint("TOPRIGHT", zPower, "TOPLEFT", 
					zPower:GetWidth() / (select(2, zPower:GetMinMaxValues()) / zPower:GetValue()), 
					0
				)

				zPower.predictionBar:Show()
			end
		else

			zPower.predictionBar:Hide()
		end
	end

-- ==================================================================================================
-- Main Power Bar Components
-- ==================================================================================================

	-- Create auto attack bar and handle all the events.
	--
	-- @param Frame mainBar The power bar main frame
	--
	-- @return Frame autoAttackBar: The newely created auto attack bar
	local function setupAutoAttackBar(mainBar)

		-- Get initial attack speed
		attackSpeed = select(1, UnitAttackSpeed("player"))

		-- Create auto attack bar
		local autoAttackBar = CreateFrame("StatusBar", nil, mainBar)
		autoAttackBar:SetPoint("BOTTOMLEFT", mainBar, "BOTTOMLEFT", 0, 0)
		autoAttackBar:SetSize(mainBar:GetWidth(), 1 + (ceil(mainBar:GetHeight() / 21)))
		autoAttackBar:SetStatusBarTexture(powerDB.AutoAttackBarTexture)
		autoAttackBar:SetFrameLevel(mainBar:GetFrameLevel() + 1)
		autoAttackBar:SetStatusBarColor(unpack(powerDB.AutoAttackBarColor))
		autoAttackBar:SetMinMaxValues(0, attackSpeed * 100)
		autoAttackBar:SetValue(attackSpeed)

		-- Auto attack timers
		autoAttackBar.autoAttackStartTime = 0
		autoAttackBar.autoAttackEndTime = 0

		-- Handle attack bar events
		autoAttackBar:RegisterEvent("UNIT_ATTACK_SPEED")
		autoAttackBar:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		autoAttackBar:RegisterEvent("PLAYER_ENTER_COMBAT")
		autoAttackBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		autoAttackBar:SetScript("OnEvent", function(self, event, ...)

			local timestamp, eventType, _, sourceGUID, sourceName = CombatLogGetCurrentEventInfo()
			local _, _, spellID = ...

			-- Update attack speed
			attackSpeed = select(1, UnitAttackSpeed("player"))

			-- Attack speed changed
			if(event == "UNIT_ATTACK_SPEED") then

				-- Update attack speed maximum value
				self:SetMinMaxValues(0, attackSpeed * 100)
			end

			if (event == "UNIT_SPELLCAST_SUCCEEDED") and (spellID == 75) and (powerDB.AutoAttackBar) then

				-- For hunter auto attack
				self.autoAttackStartTime = GetTime()
				self.autoAttackEndTime = self.autoAttackStartTime + select(1, UnitAttackSpeed("player"))
				self:Show()

			elseif (event == "PLAYER_ENTER_COMBAT") and (powerDB.AutoAttackBar) then

				self.autoAttackStartTime = GetTime()
				self.autoAttackEndTime = self.autoAttackStartTime + attackSpeed
				self:Show()
			
			elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") and (powerDB.AutoAttackBar) then

				if ((eventType == "SWING_DAMAGE") or (eventType == "SWING_MISSED")) and (sourceGUID == UnitGUID("player")) then

					self.autoAttackStartTime = GetTime()
					self.autoAttackEndTime = self.autoAttackStartTime + attackSpeed
					self:Show()
				end
			end
		end)

		-- Handle bar on update event
		autoAttackBar.updateTimer = 0
		autoAttackBar:SetScript("OnUpdate", function(self, elapsed)

			-- Update attack speed
			attackSpeed = select(1, UnitAttackSpeed("player"))

			self.updateTimer = self.updateTimer + elapsed

			-- Control how often the health bar gets updated
			if self.updateTimer <= 0.015 then return else self.updateTimer = 0 end

			-- Update auto attack bar
			if (GetTime() < self.autoAttackEndTime) then

				self:SetValue((attackSpeed * 100) - ((self.autoAttackEndTime * 100) - (GetTime() * 100)))
			else
				self:SetValue(0)
				self:Hide()
			end
		end)

	    -- Resize according to the parent size
        mainBar:SetScript("OnSizeChanged", function(self, width, height)

        	autoAttackBar:SetSize(mainBar:GetWidth(), 1 + (ceil(mainBar:GetHeight() / 21)))
    	end)

        -- Return auto attack bar
    	return autoAttackBar
	end

	-- Create the main power bar frame with all it's components.
	-- The main function resposible for putting the power bar together and handling all the events
	local function setupPowerBar()

		-- Create power bar frame
		local powerBar = zPower or CreateFrame("StatusBar", nil, UIParent)
		zPower = powerBar
		powerBar:SetStatusBarTexture(powerDB.PBTexture)
		powerBar:SetMinMaxValues(0, (maxPower > 0) and maxPower or 100)
		powerBar:SetSize(powerDB.PBWidth, powerDB.PBHeight)
		powerBar:SetPoint("CENTER", nil, "CENTER", powerDB.Pos.PBX, powerDB.Pos.PBY)
		powerBar:SetAlpha(powerDB.PBInactiveOpacity)
		powerBar:SetValue(currentPower)

		-- Power bar background
		powerBar.BG = zPower.BG or powerBar:CreateTexture(nil, "BACKGROUND", nil, -7)
		powerBar.BG:SetAllPoints(powerBar)
		powerBar.BG:SetTexture(powerDB.PBBGTexture)
		powerBar.BG:SetVertexColor(unpack(powerDB.PBBGColor))

		-- Main bar background shadow
		powerBar.shadow = zPower.shadow or nameSpace.Resources.createBarBGShadow(powerBar)

		-- Power bar color
		if powerDB.PBCustomColor then

			powerBar:SetStatusBarColor(unpack(powerDB.PBBarColor))
		else

			powerBar:SetStatusBarColor(unpack({PowerBarColor[powerType].r, PowerBarColor[powerType].g, PowerBarColor[powerType].b, 1}))
		end

		-- Create prediction bar
		if powerDB.PBPrediction then

			powerBar.predictionBar = zPower.predictionBar or createPredictionBar(powerBar)
		end

		-- Power bar text
		if powerDB.PBShowText then

			powerBar.text = zPower.text or createBarText(powerBar)
		end

		-- Auto attack bar
		if powerDB.AutoAttackBar then

			powerBar.autoAttackBar = zPower.autoAttackBar or setupAutoAttackBar(powerBar)
		end

		-- Smooth bars
		if powerDB.BPSmooth then

			nameSpace.Resources.smoothBars(powerBar)
			nameSpace.Resources.smoothBars(powerBar.autoAttackBar or nil)
		end

		-- Handle power events
		powerBar:RegisterEvent("UNIT_SPELLCAST_START")
		powerBar:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		powerBar:RegisterEvent("UNIT_SPELLCAST_STOP")
		powerBar:RegisterEvent("UNIT_SPELLCAST_FAILED")
		powerBar:RegisterEvent("UNIT_MAXPOWER")
		powerBar:RegisterEvent("UNIT_DISPLAYPOWER")
		powerBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		powerBar:SetScript("OnEvent", function(self, event, ...)

			local sourceUnit, timestamp, spellID = ...

			if event == "UNIT_DISPLAYPOWER" then

				-- Power type changed
				powerType = UnitPowerType("player")
				powerColor = {PowerBarColor[powerType].r, PowerBarColor[powerType].g, PowerBarColor[powerType].b, 1}
				currentPower = UnitPower("player", powerType)
				maxPower = UnitPowerMax("player", powerType)

				-- Update health bar
				self:SetMinMaxValues(0, maxPower)
				self:SetValue(currentPower)

			elseif (event == "UNIT_SPELLCAST_START") and predictionEnabled() then

				if (sourceUnit == "player") then

					-- Get spell info
					local spellInfo = GetSpellPowerCost(spellID)[1]

					-- Get spell cost if spell info exist
					spellCost = spellInfo and spellInfo.cost or 0

					updatePrediction()
				end

			elseif ((event == "UNIT_SPELLCAST_SUCCEEDED") or (event == "UNIT_SPELLCAST_STOP") or (event == "UNIT_SPELLCAST_FAILED")) and predictionEnabled() then

				spellCost = 0
				updatePrediction()
			end

			if (event == "UNIT_MAXPOWER") then

				self:SetMinMaxValues(0, maxPower)
			end
		end)

		-- Handling The Bars
		powerBar.updateTimer = 0
		powerBar.doPrediction = powerDB.PBPrediction 
		powerBar:SetScript("OnUpdate", function(self, elapsed)

			self.updateTimer = self.updateTimer + elapsed

			-- Control how often the power bar gets updated
			if self.updateTimer < powerDB.PBUpdateInterval then return else self.updateTimer = 0 end

			-- Refresh power values
			powerType = UnitPowerType("player")
			currentPower = UnitPower("player", powerType)
			maxPower = UnitPowerMax("player", powerType)
			local HP = UnitHealth("player")
			local maxHP = UnitHealthMax("player")

			-- Control bar visiblity in different states
			if UnitIsDeadOrGhost("player") then

				self:SetAlpha(powerDB.PBDeadOpacity)

			elseif (HP ~= maxHP) and (not InCombatLockdown()) then

				self:SetAlpha(powerDB.PBLossOpacity)

			elseif InCombatLockdown() then

				self:SetAlpha(powerDB.PBActiveOpacity)

			else

				self:SetAlpha(powerDB.PBInactiveOpacity)
			end

			-- Update power bar value
			self:SetValue(currentPower)

			-- Update power bar color
			self:SetStatusBarColor(unpack(getPowerBarColor(currentPower)))

			-- Update power bar text
			if (powerDB.PBShowText and self.text) then

				if powerDB.PowerShortNumber then
					self.text:SetText(nameSpace.Resources.shortenNumbers(currentPower))
				else
					self.text:SetText(currentPower)
				end
			end

			-- Update Prediction Bar
			if predictionEnabled() then updatePrediction() end
		end)

		-- Show power frame
		powerBar:Show()
	end

-- ==================================================================================================
-- Power Bar Functions
-- ==================================================================================================

	-- =====================================================
	-- Functionality
	-- =====================================================

		-- Toggle power bar smoothing.
		-- 
		-- @param Boolean state: Boolean to toggle the functionality
		function PowerBar.smoothPowerBar(state)

			if state then
				
				nameSpace.Resources.smoothBars(zPower)
				nameSpace.Resources.smoothBars(zPower.autoAttackBar or nil)
			else

				nameSpace.Resources.removeSmooth(zPower)
				nameSpace.Resources.removeSmooth(zPower.autoAttackBar or nil)
			end
		end

		-- Toggle power prediction.
		-- 
		-- @param Boolean state: Boolean to toggle the functionality
		function PowerBar.enablePowerPrediction(state)

			if state then
				
				zPower.predictionBar = zPower.predictionBar or createPredictionBar(zPower)
			else

				zPower.predictionBar:Hide()
			end
		end

		-- Toggle auto attack bar.
		-- 
		-- @param Boolean state: Boolean to toggle the functionality
		function PowerBar.enableAutoAttackBar(state)

			if state then
				
				zPower.autoAttackBar = zPower.autoAttackBar or setupAutoAttackBar(zPower)
			else

				zPower.autoAttackBar:Hide()
			end
		end

	-- =====================================================
	-- Appearance
	-- =====================================================

		-- Toggle custom power bar color.
		-- Empty function because values are written directly to saved variables
		--
		-- @param Boolean state: Boolean to toggle the functionality
		function PowerBar.overridePowerBarColor(state)
			
		end

		-- Change the power bar color.
		-- 
		-- @param Color value: Array of RGB colors from color picker
		function PowerBar.changePowerBarColor(value)

			if value then

				zPower:SetStatusBarColor(unpack(value))
			end
		end

		-- Change power bar texture.
		-- 
		-- @param String value: String value
		function PowerBar.setPowerTexture(value)
			
			if value then

				zPower:SetStatusBarTexture(value)
			end
		end

		-- Enable low health bar color.
		-- Empty function because values are written directly to saved variables
		--
		-- @param String value: String value
		function PowerBar.enableLowPowerColor(state)

		end

		-- Change low health threshold.
		-- Empty function because values are written directly to saved variables
		--
		-- @param String value: String value
		function PowerBar.setLowPowerThreshold(value)

		end

		-- Change low health color.
		-- Empty function because values are written directly to saved variables
		--
		-- @param Color value: Array of RGB colors from color picker
		function PowerBar.setLowPowerColor(value)

		end

		-- Enable low health bar color.
		-- Empty function because values are written directly to saved variables
		--
		-- @param String value: String value
		function PowerBar.enableHighPowerColor(state)

		end

		-- Change low health threshold.
		-- Empty function because values are written directly to saved variables
		--
		-- @param String value: String value
		function PowerBar.setHighPowerThreshold(value)

		end

		-- Change low health color.
		-- Empty function because values are written directly to saved variables
		--
		-- @param Color value: Array of RGB colors from color picker
		function PowerBar.setHighPowerColor(value)

		end

	-- =====================================================
	-- Positioning
	-- =====================================================

		-- Set power bar width.
		--
		-- @param Number value: Value passed from edit box
		function PowerBar.setPowerBarWidth(value)

			if value then

				zPower:SetWidth(value)
			end
		end

		-- Set power bar height.
		--
		-- @param Number value: Value passed from edit box
		function PowerBar.setPowerBarHeight(value)

			if value then

				zPower:SetHeight(value)
			end
		end

		-- Set power bar horizontal position.
		--
		-- @param Number value: Value passed from edit box
		function PowerBar.setPowerFrameX(value)

			if value then

				zPower:SetPoint("CENTER", nil, "CENTER", value, powerDB.Pos.PBY)
			end
		end

		-- Set power bar vertical position.
		--
		-- @param Number value: Value passed from edit box
		function PowerBar.setPowerFrameY(value)

			if value then

				zPower:SetPoint("CENTER", nil, "CENTER", powerDB.Pos.PBX, value)
			end
		end

	-- =====================================================
	-- Health Status
	-- =====================================================

		-- Toggle power bar numbers.
		-- 
		-- @param Boolean state: Boolean to toggle the functionality
		function PowerBar.displayPowerStatus(state)

			if state then

				zPower.text = zPower.text or createBarText(zPower)
				zPower.text:Show()
			else

				zPower.text:Hide()
			end
		end

		-- Toggle power bar numbers.
		-- We just need an empty function since the bar opacity is being handled in the bar on update event
		-- 
		-- @param Boolean state: Boolean to toggle the functionality
		function PowerBar.shortenPowerStatus(state)

		end

		-- Set power font type.
		-- 
		-- @param String value: String value passed from dropdown
		function PowerBar.powerFontFamily(value)

			if value then

				zPower.text:SetFont(value, powerDB.PBFontSize, powerDB.PBFontStyle)
			end
		end

		-- Set power font size.
		-- 
		-- @param String value: String value passed from dropdown
		function PowerBar.powerFontSize(value)

			if value then

				zPower.text:SetFont(powerDB.PBFontFamily, value, powerDB.PBFontStyle)
			end
		end

		-- Set power font horizontal position.
		-- 
		-- @param String value: String value passed from editbox
		function PowerBar.setPowerFontX(value)

			if value then

				zPower.text:SetPoint("CENTER", zPower, "CENTER", value, powerDB.PBFontPos.BPFontY)
			end
		end

		-- Set power font vertical position.
		-- 
		-- @param String value: String value passed from editbox
		function PowerBar.setPowerFontY(value)

			if value then

				zPower.text:SetPoint("CENTER", zPower, "CENTER", powerDB.PBFontPos.BPFontX, value)
			end
		end

		-- Set power font color.
		--
		-- @param Color value: Array of RGB colors from color picker
		function PowerBar.setPowerFontColor(value)

			if value then

				zPower.text:SetTextColor(unpack(value))
			end
		end

	-- =====================================================
	-- Visibility
	-- =====================================================

		-- Set power bar frame opacity on different states.
		-- We just need an empty function since the bar opacity is being handled in the bar on update event
		-- 
		-- @param Float value: Incoming slider value
		function PowerBar.setPowerBarOpacity(value)

		end

-- ==================================================================================================
-- Power Bar Initialization
-- ==================================================================================================

	-- Initialize power bar.
	-- Initialize the power bar variables and toggle it
	-- The function being called on addon startup and on power bar check button
	-- 
	-- @param Boolean state: A boolean indicating if the power bar should be enabled or disabled
	function PowerBar.initPowerBar(state)

		if state then

			-- Loading power bar DB
			powerDB = powerDB or zAddonCharDB.PowerBar

			-- Getting player class
			playerClass = playerClass or select(2, UnitClass("player"))

			-- Getting player spec
			playerSpec = GetSpecialization()

			-- Initial power values
			powerType = UnitPowerType("player")
			powerColor = {PowerBarColor[powerType].r, PowerBarColor[powerType].g, PowerBarColor[powerType].b, 1}
			currentPower = UnitPower("player", powerType)
			maxPower = UnitPowerMax("player", powerType)

			-- Setup the power bar
			setupPowerBar()
		else

			-- Destroy the power bar if it already exist
			if zPower then

				zPower:Hide()
				zPower:SetScript("OnUpdate", nil)
				zPower:SetScript("OnEvent", nil)
				zPower:UnregisterAllEvents()
			end
		end
	end

-- ==================================================================================================
-- Events
-- ==================================================================================================
	
	-- Handle player specialization change
	nameSpace.Resources:onSpecializationChange(function()

		-- Update player's spec
		playerSpec = GetSpecialization()
	end)
