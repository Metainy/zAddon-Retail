-- Addon's namespace
local zAddon, nameSpace = ...

-- Register slash commands.
-- Register all addon's slash commands
local function loadSlashCommands()

	-- Register slash command
	SLASH_zAddon1 = "/za"

	-- Toggle addon panel on command
	SlashCmdList.zAddon = nameSpace.UI.toggleAddonFrame
end

-- Initialize Addon's entry.
-- Addon's entry point and where we call all startup functions
-- 
-- @param Frame 	self: 	Self
-- @param Event 	event: 	Registered event
-- @param String 	name: 	Addon's name
local function initAddon(self, event, name)

	-- Making sure addon is loaded
	if (name ~= "zAddon") then return end

	-- Initialize saved variables for first time use
	nameSpace.Config:initSavedVariables()
	
	-- Build the UI and all the components
	nameSpace.UI.initUI()

	-- Initialize and enable frame styles based on saved variables
	nameSpace.Skins:initSkins()

	-- Initialize and enable functions based on saved variables
	nameSpace.Options.initOptions()

	-- Initialize and load resource bars based on saved variables
	nameSpace.Resources:initResources()

	-- Load slash commands
	loadSlashCommands()

	-- Perform a full garbage collection cycle once after initializing
	collectgarbage("collect")

	-- Unregister event
	self:UnregisterEvent("ADDON_LOADED")
end

-- Registering addon's load event
local event = CreateFrame("Frame")
event:RegisterEvent("ADDON_LOADED")
event:SetScript("OnEvent", initAddon)