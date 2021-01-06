-- Addon's namespace
local zAddon, nameSpace = ...

-- Adding tables to addon's namespace
nameSpace.HealthBar = {}

-- Creating namespace tables
local HealthBar = nameSpace.HealthBar

-- Creating local tables
local zHealth

-- Health bar DB
local healthDB

-- Local variables
local playerClass, classColor
local HP, maxHP

-- ==================================================================================================
-- Health Bar Helper Functions
-- ==================================================================================================

	-- Get health bar color based on enabled options.
	-- If class colored or low health color are enabled this function return the right color to be used
	--
	-- @param Number HP : 			Current player HP
	-- @param Number maxHP: 		Current player max HP
	-- @param Number incPrediction: Incoming heal prediction
	-- 
	-- @return Array barColor: The status bar color
	local function getHealthBarColor(HP, maxHP, incPrediction)

		-- No incoming healing
		if (not incPrediction) then incPrediction = 0 end

		-- Get the custom color from the DB
		local barColor = healthDB.HPBarColor

		-- Check if class colored bar is enabled
		if healthDB.HPClassColored then

			barColor = classColor
		end

		-- Check if low health color is enabled
		if healthDB.HPLowColor and (( (HP + incPrediction) / maxHP) <= healthDB.HPLowThreshold) then

			barColor = healthDB.HPBarColorLow
		end

		return barColor
	end

	-- Create the health bar text.
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

		-- Create health bar text
		local text = fontFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		text:ClearAllPoints()
		text:SetJustifyH("CENTER")
		text:SetPoint("CENTER", mainBar, "CENTER", healthDB.HPFontPos.HPFontX, healthDB.HPFontPos.HPFontY)
		text:SetFont(healthDB.HPFontFamily, healthDB.HPFontSize, healthDB.HPFontStyle)
		text:SetTextColor(unpack(healthDB.HPFontColor))
		text:SetShadowOffset(0, 0)
		text:Show()
		
		-- Return bar text
		return text
	end

	-- Create incoming heals bar.
	--
	-- @param Frame mainBar The health bar main frame
	--
	-- @return Frame incomingHealsBar: The newely created incoming heal frame
	local function createIncomingHealsBar(mainBar)

		-- Create incoming heal bar
		local incomingHealsBar = CreateFrame("StatusBar", nil, mainBar)
		incomingHealsBar:SetAllPoints(mainBar)
		incomingHealsBar:SetStatusBarTexture(healthDB.IncomingHealsTexture)
		incomingHealsBar:SetMinMaxValues(0, 1)
		incomingHealsBar:SetValue(0)
		incomingHealsBar:SetFrameLevel(mainBar:GetFrameLevel())
		incomingHealsBar:Hide()

		-- Create over heal bar spark
		mainBar.spark = mainBar.spark or nameSpace.Resources.createBarSpark(mainBar)

		-- Return incoming heals bar
		return incomingHealsBar
	end

	-- Create absorb bar.
	--
	-- @param Frame mainBar: The health bar main frame
	--
	-- @return Frame absorbBar: The newely created absorb bar frame
	local function createAbsorbBar(mainBar)

		-- Create absorb bar
		local absorbBar = CreateFrame("StatusBar", nil, mainBar)
		absorbBar:SetStatusBarTexture(healthDB.AbsorbTexture)
		absorbBar:SetStatusBarColor(unpack(healthDB.AbsorbBarColor))
		absorbBar:SetMinMaxValues(0, 1)
		absorbBar:SetValue(1)
		absorbBar:SetFrameLevel(mainBar:GetFrameLevel() + 2)
		absorbBar:SetSize(0, mainBar:GetHeight())

		-- Return incoming heals bar
		return absorbBar
	end

	-- Update incoming heals.
	-- Check for incoming healing prediction and update the bar accordingly
	local function updateIncomingHeals()

		local newPrediction = UnitGetIncomingHeals("player") or 0
		
		if (newPrediction ~= 0) and (not UnitIsDeadOrGhost("player") ) then

			-- Set bar color
			local barColor = getHealthBarColor(HP, maxHP, newPrediction)
			zHealth.incomingHealsBar:SetStatusBarColor(barColor[1] - .4, barColor[2] - .4, barColor[3] - .4, 1)

			zHealth.incomingHealsBar:SetMinMaxValues(0, maxHP)

			if (HP == maxHP) then

				zHealth.spark:Show()
				zHealth.incomingHealsBar:SetValue(newPrediction + HP)
			else

				zHealth.spark:Hide()
				zHealth.incomingHealsBar:SetValue(newPrediction + HP)
			end

			zHealth.incomingHealsBar:Show()
		else

			zHealth.incomingHealsBar:Hide()
			zHealth.spark:Hide()
		end
	end

	-- Update absorb bar.
	-- Check for incoming abosrbed damage and update the bar accordingly
	local function updateAbsorbs()

		local absorbAmount = UnitGetTotalAbsorbs("player") or 0

		if (absorbAmount ~= 0) and (not UnitIsDeadOrGhost("player") ) then

			zHealth.absorbBar:SetSize(((zHealth:GetWidth() / maxHP) * absorbAmount), ceil(zHealth:GetHeight() / 3))
			zHealth.absorbBar:ClearAllPoints()

			if (HP + absorbAmount) >= maxHP then

				zHealth.absorbBar:SetPoint("TOPRIGHT", zHealth, "TOPRIGHT", 0, 0)
			else

				zHealth.absorbBar:SetHeight(zHealth:GetHeight())
				zHealth.absorbBar:SetPoint("TOPLEFT", zHealth, "TOPLEFT", 
					zHealth:GetWidth() / (select(2, zHealth.healthBar:GetMinMaxValues() ) / zHealth.healthBar:GetValue()), 
					0
				)
			end

			zHealth.absorbBar:Show()
		else

			zHealth.absorbBar:Hide()
		end
	end

-- ==================================================================================================
-- Main Health Bar Components
-- ==================================================================================================

	-- Create and show pet bar and percentage.
	-- Show either one of the choices or both, and handle the bar update
	--
	-- @param Frame healthFrame: Health bar frame which pet bar will be associated with
	local function setupPetBar(healthFrame)

		-- Initial pet health values
		local petHP = UnitHealth("pet")
		local petMaxHP = UnitHealthMax("pet")

		-- Create event frame
		local petFrame = healthFrame.petFrame or CreateFrame("StatusBar", nil, healthFrame)
		healthFrame.petFrame = petFrame

		-- Show event
		petFrame:Show()

		-- Pet bar
		if healthDB.PetBar then

			-- Create pet frame
			local petHealthBar = healthFrame.petHealthBar or CreateFrame("StatusBar", nil, healthFrame)
			healthFrame.petHealthBar = petHealthBar
			petHealthBar:SetParent(healthFrame)
			petHealthBar:ClearAllPoints()
			petHealthBar:SetStatusBarTexture(healthDB.PetBarTexture)
			petHealthBar:SetMinMaxValues(0, (petMaxHP > 0) and petMaxHP or 100)
			petHealthBar:SetStatusBarColor(unpack(healthDB.PetBarColor))
			petHealthBar:SetSize(healthFrame:GetWidth(), (ceil(healthFrame:GetHeight() / 5)))
			petHealthBar:SetPoint("BOTTOMLEFT", healthFrame, "BOTTOMLEFT", 0, 0)
			petHealthBar:SetValue(petHP or 0)
			petHealthBar:SetFrameLevel(healthFrame:GetFrameLevel() + 1)

			-- Handle any changes to the pet
			petHealthBar:RegisterUnitEvent("UNIT_PET", "player")
			petHealthBar:SetScript("OnEvent", function(self, event, ...)

				-- Update pet's max health on any change
				if (event == "UNIT_PET") then

					self:SetMinMaxValues(0, UnitHealthMax("pet"))
				end
			end)

			-- Show pet frame
			petHealthBar:Show()
		else

			-- Hide pet bar if it exist
			if healthFrame.petHealthBar then 

				healthFrame.petHealthBar:Hide()
				healthFrame.petHealthBar:SetScript("OnEvent", nil)
				healthFrame.petHealthBar:UnregisterAllEvents()
			end
		end

		-- Pet health percentage
		if healthDB.PetBarText then

			-- Create health percentage frame
			local petHealthText = healthFrame.petHealthText or healthFrame:CreateFontString(nil, "OVERLAY")
			healthFrame.petHealthText = petHealthText
			petHealthText:ClearAllPoints()
			petHealthText:SetJustifyH("LEFT")

			if healthDB.PetBar then
				petHealthText:SetPoint("BOTTOMLEFT", healthFrame.petHealthBar, "TOPLEFT", healthDB.PetFontPos.PetFontX, healthDB.PetFontPos.PetFontY)
			else
				petHealthText:SetPoint("LEFT", healthFrame, "LEFT", healthDB.PetFontPos.PetFontX, healthDB.PetFontPos.PetFontY)
			end

			petHealthText:SetFont(healthDB.PetFontFamily, healthDB.PetFontSize, healthDB.PetFontStyle)
			petHealthText:SetTextColor(unpack(healthDB.PetFontColor))

			-- Show health percentage frame
			petHealthText:Show()

		else

			-- Hide health percentage if it exist
			if healthFrame.petHealthText then

				healthFrame.petHealthText:Hide()
			end
		end

		-- Set on update function if pet bar or per health percentage are enabled
		if healthDB.PetBar or healthDB.PetBarText then

			-- Handling pet frame update
			petFrame.updateTimer = 0
			petFrame:SetScript("OnUpdate", function(self, elapsed)

				self.updateTimer = self.updateTimer + elapsed

				-- Control how often the pet bar gets updated
				if self.updateTimer < healthDB.HPUpdateInterval then return else self.updateTimer = 0 end

				local petHP = UnitHealth("pet")
				local petMaxHP = UnitHealthMax("pet")

				-- Update pet bar value
				if healthFrame.petHealthBar then

					healthFrame.petHealthBar:SetValue(petHP)
				end

				-- Update pet health percentage
				if healthFrame.petHealthText then

					if (not UnitExists("pet")) or (UnitIsDeadOrGhost("pet")) then

						healthFrame.petHealthText:SetText("")
					else
						if ((petHP / UnitHealthMax("pet")) >= .9) then
							healthFrame.petHealthText:SetFormattedText("|cffffff00%d%%|r", (petHP / petMaxHP ) * 100)
						elseif ((petHP / UnitHealthMax("pet")) >= .35) then
							healthFrame.petHealthText:SetFormattedText("|cffffffff%d%%|r", (petHP / petMaxHP ) * 100)
						else
							healthFrame.petHealthText:SetFormattedText("|cffff0000%d%%|r", (petHP / petMaxHP ) * 100)
						end
					end
				end
			end)
		else
			
			-- Hide and unregister all pet frame events
			healthFrame.petFrame:Hide()
			healthFrame.petFrame:SetScript("OnUpdate", nil)
			healthFrame.petFrame:SetScript("OnEvent", nil)
			healthFrame.petFrame:UnregisterAllEvents()
		end
	end

	-- Create the main health bar frame with all it's components.
	-- The main function resposible for putting the health bar together and handling all the events
	local function setupHealthBar()

		-- Create main bar frame
		local mainBar = zHealth or CreateFrame("Frame", nil, UIParent)
		zHealth = mainBar
		mainBar:SetSize(healthDB.HPWidth, healthDB.HPHeight)
		mainBar:SetPoint("CENTER", nil, "CENTER", healthDB.Pos.HPX, healthDB.Pos.HPY)
		mainBar:SetAlpha(healthDB.HPInactiveOpacity)

		-- Main bar background
		mainBar.BG = zHealth.BG or mainBar:CreateTexture(nil, "BACKGROUND", nil, -7)
		mainBar.BG:SetAllPoints(mainBar)
		mainBar.BG:SetTexture(healthDB.HPBGTexture)
		mainBar.BG:SetVertexColor(unpack(healthDB.HPBGColor))

		-- Main bar background shadow
		mainBar.shadow = zHealth.shadow or nameSpace.Resources.createBarBGShadow(mainBar)

		-- Create health bar frame
		mainBar.healthBar = mainBar.healthBar or CreateFrame("StatusBar", nil, mainBar)
		mainBar.healthBar:SetAllPoints(mainBar)
		mainBar.healthBar:SetFrameLevel(mainBar:GetFrameLevel() + 1)
		mainBar.healthBar:SetStatusBarTexture(healthDB.HPBarTexture)
		mainBar.healthBar:SetMinMaxValues(0, (maxHP > 0) and maxHP or 100)
		mainBar.healthBar:SetValue(HP)

		-- Health bar color
		if healthDB.HPClassColored then

			mainBar.healthBar:SetStatusBarColor(unpack(classColor))
		else

			mainBar.healthBar:SetStatusBarColor(unpack(healthDB.HPBarColor))
		end

		-- Create incoming heals bar
		if healthDB.IncomingHeals then

			mainBar.incomingHealsBar = zHealth.incomingHealsBar or createIncomingHealsBar(mainBar)
		end

		-- Create abosrb bar
		if healthDB.AbsorbBar then

			mainBar.absorbBar = zHealth.absorbBar or createAbsorbBar(mainBar)
		end

		-- Health bar text
		if healthDB.HPShowText then

			mainBar.text = zHealth.text or createBarText(mainBar)
		end

		-- Pet bar
		if healthDB.PetBar or healthDB.PetBarText then

			-- setupPetBar(healthBar)
		end

		-- Smooth bars
		if healthDB.HPSmoothBar then

			nameSpace.Resources.smoothBars(mainBar.healthBar)
			nameSpace.Resources.smoothBars(mainBar.incomingHealsBar or nil)
			nameSpace.Resources.smoothBars(mainBar.absorbBar or nil)
		end

		-- Handle health events
		mainBar:RegisterUnitEvent("UNIT_MAXHEALTH", "player")
		mainBar:RegisterUnitEvent("UNIT_HEALTH", "player")
		mainBar:RegisterUnitEvent("UNIT_HEAL_PREDICTION", "player")
		mainBar:RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", "player")
		mainBar:SetScript("OnEvent", function(self, event, ...)

			-- Update player's max health on any change
			if (event == "UNIT_MAXHEALTH") then

				-- Update health values
				maxHP = UnitHealthMax("player")

				self.healthBar:SetValue(HP)
				self.healthBar:SetMinMaxValues(0, maxHP)
			elseif (event == "UNIT_HEALTH") then
				
				-- Update health values
				HP = UnitHealth("player")

				-- Update Incoming Heals
				if healthDB.IncomingHeals then updateIncomingHeals() end

				-- Update abosrb bar
				if healthDB.AbsorbBar then updateAbsorbs() end

			elseif (event == "UNIT_HEAL_PREDICTION") and (healthDB.IncomingHeals) then

				-- Update Incoming Heals
				updateIncomingHeals()

			elseif (event == "UNIT_ABSORB_AMOUNT_CHANGED") and (healthDB.AbsorbBar) then

				-- Update abosrb bar
				updateAbsorbs()
			end
		end)

		-- Handle bar on update event
		mainBar.updateTimer = 0
		mainBar:SetScript("OnUpdate", function(self, elapsed)

			self.updateTimer = self.updateTimer + elapsed

			-- Control how often the health bar gets updated
			if self.updateTimer < healthDB.HPUpdateInterval then return else self.updateTimer = 0 end

			-- Refresh health values
			HP = UnitHealth("player")
			maxHP = UnitHealthMax("player")

			-- Control bar visiblity in different states
			if UnitIsDeadOrGhost("player") then

				self:SetAlpha(healthDB.HPDeadOpacity)

			elseif (HP ~= maxHP) and (not InCombatLockdown()) then

				self:SetAlpha(healthDB.HPLossOpacity)

			elseif InCombatLockdown() then

				self:SetAlpha(healthDB.HPActiveOpacity)
				
			else

				self:SetAlpha(healthDB.HPInactiveOpacity)
			end

			-- Update health bar value
			self.healthBar:SetValue(HP)

			-- Update health bar color
			self.healthBar:SetStatusBarColor(unpack(getHealthBarColor(HP, maxHP)))

			-- Update health text
			if (healthDB.HPShowText and self.text) then

				if healthDB.HPShortNumber then
					self.text:SetText(nameSpace.Resources.shortenNumbers(HP))
				else
					self.text:SetText(HP)
				end
			end

			-- Update incoming heals
			if healthDB.IncomingHeals then updateIncomingHeals() end

			-- Update absorb bar
			if healthDB.AbsorbBar then updateAbsorbs() end
		end)

		-- Show health frame
		mainBar:Show()
	end

-- ==================================================================================================
-- Health Bar Functions
-- ==================================================================================================

	-- =====================================================
	-- Functionality
	-- =====================================================

		-- Toggle health bar smoothing.
		-- 
		-- @param Boolean state: Boolean to toggle the functionality
		function HealthBar.smoothHealthBar(state)

			if state then
				
				nameSpace.Resources.smoothBars(zHealth.healthBar)
				nameSpace.Resources.smoothBars(zHealth.incomingHealsBar or nil)
				nameSpace.Resources.smoothBars(zHealth.absorbBar or nil)
			else

				nameSpace.Resources.removeSmooth(zHealth.healthBar)
				nameSpace.Resources.removeSmooth(zHealth.incomingHealsBar or nil)
				nameSpace.Resources.removeSmooth(zHealth.absorbBar or nil)
			end
		end

		-- Toggle incoming heals bar.
		-- 
		-- @param Boolean state: Boolean to toggle the functionality
		function HealthBar.enableIncomingHeals(state)

			if state then

				zHealth.incomingHealsBar = zHealth.incomingHealsBar or createIncomingHealsBar(zHealth)
			else

				zHealth.incomingHealsBar:Hide()
				zHealth.spark:Hide()
			end
		end

		-- Toggle absorb bar.
		-- 
		-- @param Boolean state: Boolean to toggle the functionality
		function HealthBar.enableAbsorbBar(state)

			if state then

				zHealth.absorbBar = zHealth.absorbBar or createAbsorbBar(zHealth)
			else

				zHealth.absorbBar:Hide()
			end
		end

	-- =====================================================
	-- Appearance
	-- =====================================================

		-- Toggle class colored health bar.
		-- 
		-- @param Boolean state: Boolean to toggle the functionality
		function HealthBar.classColoredHealthBar(state)
			
			if state then

				zHealth.healthBar:SetStatusBarColor(unpack(classColor))
			else

				zHealth.healthBar:SetStatusBarColor(unpack(healthDB.HPBarColor))
			end
		end

		-- Change the health bar color.
		-- 
		-- @param Color value: Array of RGB colors from color picker
		function HealthBar.changeHealthBarColor(value)

			if value then

				zHealth.healthBar:SetStatusBarColor(unpack(value))
			end
		end

		-- Change health bar texture.
		-- 
		-- @param String value: String value
		function HealthBar.setHPTexture(value)
			
			if value then

				zHealth.healthBar:SetStatusBarTexture(value)
			end
		end

		-- Enable low health bar color.
		-- Empty function because values are written directly to saved variables
		--
		-- @param String value: String value
		function HealthBar.enableLowHPColor(state)

		end

		-- Change low health threshold.
		-- Empty function because values are written directly to saved variables
		--
		-- @param String value: String value
		function HealthBar.setLowHPThreshold(value)

		end

		-- Change low health color.
		-- Empty function because values are written directly to saved variables
		--
		-- @param Color value: Array of RGB colors from color picker
		function HealthBar.setLowHPColor(value)

		end

	-- =====================================================
	-- Positioning
	-- =====================================================

		-- Set health bar width.
		--
		-- @param Number value: Value passed from edit box
		function HealthBar.setHPBarWidth(value)

			if value then

				zHealth:SetWidth(value)
			end
		end

		-- Set health bar height.
		--
		-- @param Number value: Value passed from edit box
		function HealthBar.setHPBarHeight(value)

			if value then

				zHealth:SetHeight(value)
			end
		end

		-- Set health bar horizontal position.
		--
		-- @param Number value: Value passed from edit box
		function HealthBar.setHPFrameX(value)

			if value then

				zHealth:SetPoint("CENTER", nil, "CENTER", value, healthDB.Pos.HPY)
			end
		end

		-- Set health bar vertical position.
		--
		-- @param Number value: Value passed from edit box
		function HealthBar.setHPFrameY(value)

			if value then

				zHealth:SetPoint("CENTER", nil, "CENTER", healthDB.Pos.HPX, value)
			end
		end

	-- =====================================================
	-- Health Status
	-- =====================================================

		-- Toggle health bar numbers.
		-- 
		-- @param Boolean state: Boolean to toggle the functionality
		function HealthBar.displayHealthStatus(state)

			if state then

				zHealth.text = zHealth.text or createBarText(zHealth)
				zHealth.text:Show()
			else

				zHealth.text:Hide()
			end
		end

		-- Toggle health bar numbers.
		-- We just need an empty function since the bar opacity is being handled in the bar on update event
		-- 
		-- @param Boolean state: Boolean to toggle the functionality
		function HealthBar.shortenHealthStatus(state)

		end

		-- Set health font type.
		-- 
		-- @param String value: String value passed from dropdown
		function HealthBar.healthFontFamily(value)

			if value then

				zHealth.text:SetFont(value, healthDB.HPFontSize, healthDB.HPFontStyle)
				zHealth.text:Hide()
				zHealth.text:Show()
			end
		end

		-- Set health font size.
		-- 
		-- @param String value: String value passed from dropdown
		function HealthBar.healthFontSize(value)

			if value then

				zHealth.text:SetFont(healthDB.HPFontFamily, value, healthDB.HPFontStyle)
			end
		end

		-- Set health font horizontal position.
		-- 
		-- @param String value: String value passed from editbox
		function HealthBar.setHPFontX(value)

			if value then

				zHealth.text:SetPoint("CENTER", zHealth, "CENTER", value, healthDB.HPFontPos.HPFontY)
			end
		end

		-- Set health font vertical position.
		-- 
		-- @param String value: String value passed from editbox
		function HealthBar.setHPFontY(value)

			if value then

				zHealth.text:SetPoint("CENTER", zHealth, "CENTER", healthDB.HPFontPos.HPFontX, value)
			end
		end

		-- Set health font color.
		--
		-- @param Color value: Array of RGB colors from color picker
		function HealthBar.setHPFontColor(value)

			if value then

				zHealth.text:SetTextColor(unpack(value))
			end
		end

	-- =====================================================
	-- Pet Bar
	-- =====================================================

		--  Toggle pet health bar.
		-- 
		-- @param Boolean state: Boolean to toggle the functionality
		function HealthBar.enablePetBar(state)
			
			setupPetBar(zHealth)
		end

		-- Change the pet bar color.
		--
		-- @param Color value: Array of RGB colors from color picker
		function HealthBar.changePetBarColor(value)

			if value then

				zHealth.petHealthBar:SetStatusBarColor(unpack(value))
			end
		end

		-- Toggle pet health percentage.
		-- 
		-- @param Boolean state: Boolean to toggle the functionality
		function HealthBar.enablePetHPPercentage(state)
			
			setupPetBar(zHealth)
		end
	
	-- =====================================================
	-- Visibility
	-- =====================================================

		-- Set health bar frame opacity on different states.
		-- We just need an empty function since the bar opacity is being handled in the bar on update event
		-- 
		-- @param Float value: Incoming slider value
		function HealthBar.setHealthBarOpacity(value)

		end

-- ==================================================================================================
-- Health Bar Initialization
-- ==================================================================================================

	-- Initialize health bar.
	-- Initialize the health bar variables and toggle it
	-- The function being called on addon startup and on health bar check button
	-- 
	-- @param Boolean state: A boolean indicating if the health bar should be enabled or disabled
	function HealthBar.initHealthBar(state)

		if state then

			-- Loading health bar DB
			healthDB = healthDB or zAddonCharDB.HealthBar

			-- Getting player class
			playerClass = playerClass or select(2, UnitClass("player"))

			-- Get player's class color
			classColor = classColor or {RAID_CLASS_COLORS[playerClass].r, RAID_CLASS_COLORS[playerClass].g, RAID_CLASS_COLORS[playerClass].b, 1}

			-- Initial health values
			HP = UnitHealth("player")
			maxHP = UnitHealthMax("player")
			HP = (HP < 0) and 0 or HP

			-- Setup the health bar
			setupHealthBar()
		else

			-- Destroy the health bar if it already exist
			if zHealth then

				zHealth:Hide()
				zHealth:SetScript("OnUpdate", nil)
				zHealth:SetScript("OnEvent", nil)
				zHealth:UnregisterAllEvents()
			end
		end
	end
