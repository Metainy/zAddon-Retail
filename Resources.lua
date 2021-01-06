-- Addon's namespace
local zAddon, nameSpace = ...

-- Adding tables to addon's namespace
nameSpace.Resources = {}

-- Creating namespace tables
local Resources = nameSpace.Resources

-- Local variables
local playerClass, playerSpec

-- ==================================================================================================
-- Events Wrappers
-- ==================================================================================================
	
	-- Register an event to be accessed everywhere
	--
	-- @param Function callback: A function to be executed on event
	function Resources:onSpecializationChange(callback)

		if not self.eventFrame then

			-- Create frame event if it doesn't exist
			self.eventFrame = CreateFrame("Frame")
		end

		-- Event handler
		function self.eventFrame:onEvent(event, ...)

			-- Loop through all callback and pass the payload
			for callback in next, self.callbacks do
		        
		        callback(...)
		     end
		end

		-- Set event handler
		self.eventFrame:SetScript("OnEvent", self.eventFrame.onEvent)

		if not self.eventFrame.callbacks then self.eventFrame.callbacks = {} end
		self.eventFrame.callbacks[callback] = callback

		self.eventFrame:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED")
	end

-- ==================================================================================================
-- Resources Helper Functions
-- ==================================================================================================

	-- Responsible for updating bar value.
	--
	-- @param Frame 	self:	Reference to the bar frame
	-- @param String 	value: 	New bar value
	local function smooth(self, value)
		
		if (value ~= self:GetValue()) or (value == 0) then

			self.smoothing = value
		else

			self.smoothing = nil
		end
	end

	-- Smoothen bar animation, making it more fluid.
	--
	-- @param Frame barFrame: The bar frame which is smoothing will be applied to
	function Resources.smoothBars(barFrame)

		if not barFrame or barFrame.orgValue then return end

		-- Bar initial setup
		barFrame.orgValue = barFrame.SetValue
		barFrame.SetValue = smooth
		barFrame.smoother = barFrame.smoother or CreateFrame("Frame", nil, barFrame)
		barFrame.smoother:SetParent(barFrame)

		-- Handling bar frame update
		barFrame.smoother:SetScript("OnUpdate", function(self)

			local rate = GetFramerate()
			local limit = 30 / rate

			if self:GetParent().smoothing then

				local current = self:GetParent():GetValue()
				local new = current + min((self:GetParent().smoothing - current) / 5, max(self:GetParent().smoothing - current, limit))

				self:GetParent():orgValue(new)

				if (current == self:GetParent().smoothing) or (abs(new - self:GetParent().smoothing) < 2) then

					self:GetParent():orgValue(self:GetParent().smoothing)
					self:GetParent().smoothing = nil
				end
			end
		end)

		barFrame.smoother:Show()
	end

	-- Remove the bar smoothing.
	--
	-- @param Frame barFrame: The bar frame which is smoothing will be removed from
	function Resources.removeSmooth(barFrame)

		if not barFrame or not barFrame.orgValue then return end

		barFrame.smoother:Hide()
		barFrame.smoother:SetScript("OnUpdate", nil)
		barFrame.smoother:SetParent(nil)
		barFrame.SetValue = barFrame.orgValue
		barFrame.orgValue = nil
	end

	-- Shorten status text numbers.
	--
	-- @param Number statusNumber: Status bar number to be shortened
	--
	-- @return Number newNumber: New shortened number
	function Resources.shortenNumbers(statusNumber)

		local newNumber

		if statusNumber > 1000000 then
			newNumber = ("%.01fM"):format(statusNumber / 1000000)
		end

		if statusNumber <= 1000000 then
			newNumber = ("%.01fK"):format(statusNumber / 1000)
		end

		if statusNumber <= 1000 then
			newNumber = statusNumber
		end

		return newNumber
	end



	-- Create a shadow for bar frame background.
	--
	-- @param Frame barFrame: The bar frame which is a shadow is being added to
	-- 
	-- @return Frame shadow: Newely created shadow frame
	function Resources.createBarBGShadow(barFrame)

		local shadow = CreateFrame("Frame", nil, barFrame, "BackdropTemplate")
		shadow:SetFrameStrata("BACKGROUND")
		shadow:SetPoint("TOPLEFT", -3, 3)
		shadow:SetPoint("BOTTOMRIGHT", 3, -3)
		shadow:SetBackdrop({
		    BgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		    edgeFile = "Interface\\Addons\\zAddon\\Assets\\Textures\\OuterShadow",
		    edgeSize = 3,
		    insets = {left = 3, right = 3, top = 3, bottom = 3}
		})
		shadow:SetBackdropColor(0.15, 0.15, 0.15, 1)
		shadow:SetBackdropBorderColor(0.1, 0.1, 0.1, .9)

		-- Return the shadow frame
		return shadow
	end

	-- Create an animated bar spark.
	--
	-- @param Frame barFrame: The bar frame which is the spark is being added to
	--
	-- @return Texture spark: Newely created spark texture
	function Resources.createBarSpark(barFrame)

		-- Create font frame on top of all bars
		local sparkFrame = CreateFrame("Frame", nil, barFrame)
		sparkFrame:SetFrameLevel(barFrame:GetFrameLevel() + 4)
		sparkFrame:SetAllPoints(barFrame)

	    local spark = sparkFrame:CreateTexture(nil, "OVERLAY")
	    spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	    spark:SetSize(15, barFrame:GetHeight() * 1.8)                                        
	    spark:SetBlendMode("ADD")
	    spark:SetPoint("CENTER", barFrame, "RIGHT", -2, 0)
	    spark:Show()

	    -- Resize according to the parent size
        barFrame:SetScript("OnSizeChanged", function(self, width, height)

        	spark:SetHeight(height * 1.8)
    	end)

    	-- Create animation group
		local animationGroup = spark:CreateAnimationGroup()
		animationGroup:SetLooping("REPEAT")

		-- Create animation and attach it to animation group
		local fadeOut = animationGroup:CreateAnimation("Alpha")
		fadeOut:SetOrder(1)
		fadeOut:SetFromAlpha(1)
		fadeOut:SetToAlpha(0.4)
		fadeOut:SetDuration(1)
		fadeOut:SetEndDelay(0)
		fadeOut:SetSmoothing("IN_OUT")

		local fadeIn = animationGroup:CreateAnimation("Alpha")
		fadeIn:SetOrder(2)
		fadeIn:SetFromAlpha(0.4)
		fadeIn:SetToAlpha(1)
		fadeIn:SetDuration(1)
		fadeIn:SetEndDelay(0)
		fadeIn:SetSmoothing("IN_OUT")

		-- Start the animation
		animationGroup:Play()

        -- Return the spark texture
	    return spark
	end

	-- Check if player's current spec can have a perfmanent combat pet.
	--
	-- @return Boolean bollean: Boolean indicating if player can have a pet
	function Resources.playerHavePet()

		playerClass = select(2, UnitClass("player"))
		playerSpec = GetSpecialization()
		local currentSpecName = playerSpec and select(2, GetSpecializationInfo(playerSpec)) or "None"

		if (playerClass == "HUNTER") 
			or (playerClass == "WARLOCK") 
			or (playerClass == "DEATHKNIGHT" and playerSpec == "Unholy")
			or (playerClass == "MAGE" and currentSpecName == "Frost")
		then

			return true
		end

		return false
	end

	-- Check if power prediction is allowed for player's current spec.
	--
	-- @return Boolean bollean: Power prediction state
	function Resources.predictionAllowed()

		playerClass = select(2, UnitClass("player"))
		playerSpec = GetSpecialization()

		return nameSpace.Config.Class[playerClass][playerSpec].PowerPrediction
	end

-- ==================================================================================================
-- Resources Initialization
-- ==================================================================================================

	-- Initialize all resource bars.
	-- Being called on addon startup only once, and responsible for enabling resources based on saved variables.
	function Resources.initResources()

		-- Initialize resource bars after event loading
		local events = CreateFrame("Frame")
		events:RegisterEvent("PLAYER_ENTERING_WORLD")
		events:SetScript("OnEvent", function(self, event) 

			-- Get basic info
			playerClass = select(2, UnitClass("player"))
			playerSpec = GetSpecialization()
			
			-- Initialize all bars
			nameSpace.HealthBar.initHealthBar(zAddonCharDB.HealthBar.HealthBar)
			nameSpace.PowerBar.initPowerBar(zAddonCharDB.PowerBar.PowerBar)

			-- Unregister events
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end)
	end

-- ==================================================================================================
-- Events
-- ==================================================================================================

	-- Handle player specialization change
	Resources:onSpecializationChange(function()

		-- Update player's spec
		playerSpec = GetSpecialization()

		-- Call widget lock to reset spec based options
		nameSpace.UI.setWidgetLocks()
	end)