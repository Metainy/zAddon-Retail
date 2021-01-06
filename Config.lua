-- Addon's namespace
local zAddon, nameSpace = ...

-- Adding tables to addon's namespace
nameSpace.Config = {}

-- Creating local tables
local Config = nameSpace.Config

-- Assets path
local fontsPath = "Interface\\AddOns\\zAddon\\Assets\\Fonts\\"
local texturesPath = "Interface\\AddOns\\zAddon\\Assets\\Textures\\"
local statusBarsPath = "Interface\\AddOns\\zAddon\\Assets\\Textures\\StatusBars\\"

-- ==================================================================================================
-- Addon UI Configuration
-- ==================================================================================================

	Config.UI = {
		Style = {
			PrimaryFont 	= fontsPath .. "Roboto-Regular.ttf",
			PrimaryColor 	= {.85, .85, .85, 1},
			SecondaryColor 	= {.6, .6, .6, .9},
			AccentColor 	= {1, .82, 0, 1}
		},
		MainPanel = {
			Width	= 500,
			Height	= 540,
			Backdrop = {
				bgFile 		= texturesPath .. "PanelBG",
				edgeFile 	= texturesPath .. "OuterShadow",
				tile 		= false,
				tileSize 	= 32,
				edgeSize 	= 5,
				insets = {
					left 	= 4,
					right 	= 4,
					top 	= 4,
					bottom 	= 4
				},
			},
			BackdropColor 		= {.05, .05, .05, .6},
			BackdropBorderColor = {.05, .05, .05, .8}
		},
		SideMenu = {
			Width	= 130,
			Height	= 540,
			Color	= {.7, .7, .7, .95},
			Texture = texturesPath .. "PanelBG"
		},
		Header = {
			Width	= 370,
			Height	= 50,
			Color	= {.6, .6, .6, .95},
			Texture = texturesPath .. "PanelHeader"
		},
		Body = {
			Width	= 370,
			Height	= 490,
			Color	= {.8, .8, .8, .95},
			Texture = texturesPath .. "PanelBG"
		},
		MenuItem = {
			Width 			= 130,
			Height 			= 37,
			HoverColor		= {.29, .31, .33, .3},
			SelectedColor 	= {.29, .31, .33, .7}
		},
		ScrollFrame = {
			Width	= 330,
			Height	= 450
		},
		ScrollBar = {
			KnobTexture = texturesPath .. "ScrollKnob",
			KnobColor 	= {.9, .9, .9, 1},
		},
		Button = {
			Texture = texturesPath .. "DefaultButton"
		},
		DropDown = {
			Texture 		= texturesPath .. "Dropdown",
			DropDownColor 	= {.1, .1, .1, .9},
			Backdrop = {
				bgFile 		= texturesPath .. "PanelBG",
				edgeFile 	= texturesPath .. "UIBorder",
				tile 		= false,
				tileSize 	= 0,
				edgeSize 	= 5, 
				insets = {
					left 	= 1,
					right 	= 1,
					top 	= 0,
					bottom 	= 1
				}
			},
			BackdropColor 		= {.6, .6, .6, 1},
			BackdropBorderColor = {.4, .4, .4, .8}
		},
		EditBox = {
			Backdrop = {
				bgFile 		= "Interface\\Tooltips\\UI-Tooltip-Background",
				edgeFile 	= texturesPath .. "LineBorder",
				tile 		= false,
				tileSize 	= 16,
				edgeSize 	= 5, 
				insets = {
					left 	= 1,
					right 	= 1,
					top 	= 1,
					bottom 	= 1
				}
			},
			BackdropColor 		= {.1, .1, .1, .5},
			BackdropBorderColor = {.3, .3, .3, 1}
		},
		Divider = {
			Texture = texturesPath .. "Line"
		},
		MinimapButton = {
			Icon = texturesPath .. "zAddonIcon"
		},
	}

-- ==================================================================================================
-- Addon UI Content
-- ==================================================================================================

	Config.Content = {
		Addon = {
			Version 	= "0.1 Beta",
			PagesNumber = 10
		},
		Pages = {
			Page1 = {
				Title	= "Chat",
				Scroll 	= false
			},
			Page2 = {
				Title	= "Minimap",
				Scroll 	= false
			},
			Page3 = {
				Title	= "Inventory",
				Scroll 	= false
			},
			Page4 = {
				Title	= "Frames",
				Scroll 	= false
			},
			Page5 = {
				Title	= "Skins",
				Scroll 	= false
			},
			Page6 = {
				Title	= "Extra",
				Scroll 	= false
			},
			Page7 = {
				Title = "Health Bar",
				Scroll 	= true
			},
			Page8 = {
				Title = "Power Bar",
				Scroll 	= true
			},
			Page9 = {
				Title = "Alt. Power Bar",
				Scroll 	= false
			},
			Page10 = {
				Title = "Setting",
				Scroll 	= false
			}
		},
		DropDown = {
			FontFamily = {
				{
					Title = "Arialn",
					Value = "Fonts\\ARIALN.ttf"
				},
				{
					Title = "Presidency",
					Value = fontsPath .. "Accidental-Presidency.ttf"
				},
				{
					Title = "Roboto Regular",
					Value = fontsPath .. "Roboto-Regular.ttf"
				},
				{
					Title = "Aldo",
					Value = fontsPath .. "Aldo.ttf"
				},
				{
					Title = "Emblem",
					Value = fontsPath .. "Emblem.ttf"
				}
			},
			FontSize = {
				{
					Title = "12",
					Value = 12
				},
				{
					Title = "13",
					Value = 13
				},
				{
					Title = "14",
					Value = 14
				},
				{
					Title = "15",
					Value = 15
				},
				{
					Title = "16",
					Value = 16
				},
				{
					Title = "17",
					Value = 17
				},
				{
					Title = "18",
					Value = 18
				},	
			},
			BarTexture = {
				{
					Title = "Raid Frames",
					Value = "Interface\\RAIDFRAME\\Raid-Bar-Hp-Fill"
				},
				{
					Title = "CrossHatch",
					Value = statusBarsPath .. "CrossHatch"
				},
				{
					Title = "Subtle",
					Value = statusBarsPath .. "Subtle"
				},
				{
					Title = "Deco",
					Value = statusBarsPath .. "Deco"
				},
				{
					Title = "Glossy",
					Value = statusBarsPath .. "Glossy"
				},
				{
					Title = "Dark Glossy",
					Value = statusBarsPath .. "DarkGlossy"
				},
				{
					Title = "Minimal",
					Value = statusBarsPath .. "Minimal"
				},
				{
					Title = "Flat 1",
					Value = statusBarsPath .. "Flat1"
				},
				{
					Title = "Flat 2",
					Value = statusBarsPath .. "Flat2"
				},
				{
					Title = "Art",
					Value = statusBarsPath .. "Art"
				},
				{
					Title = "Flower 1",
					Value = statusBarsPath .. "Flower1"
				},
				{
					Title = "Flower 2",
					Value = statusBarsPath .. "Flower2"
				},
				{
					Title = "Gradient 1",
					Value = statusBarsPath .. "Gradient1"
				},
				{
					Title = "Gradient 2",
					Value = statusBarsPath .. "Gradient2"
				},
				{
					Title = "Gradient 3",
					Value = statusBarsPath .. "Gradient3"
				},
				{
					Title = "Tainted",
					Value = statusBarsPath .. "Tainted"
				},
				{
					Title = "Dark",
					Value = statusBarsPath .. "Dark"
				},
			},
		}
	}

-- ==================================================================================================
-- Addon Saved Variables
-- ==================================================================================================

	Config.DB = {
		UI = {
			StartPage = "Page1",
			MinimapIconPos = -20
		},
		Chat = {
			HideCombatLog = false,
			HideChatButtons = false,
			HideSocialButton = false,
			StopChatFade  = false,
			ChatClassColors = false,
			ClampChat = false,
			ChatTopBox = false,
			ChatURLCopy = false,
			ChatArrowKeys = false,
		},
		Minimap = {
			HideMinimapZoneBorder = false,
			HideZoomButtons = false,
			HideMinimapCalendar = false,
			HideMinimapTracking = false,
			HideMinimapClock = false,
			MinimapZoomShortcut = false,
			MinimapCalendarShortcut = false,
			MinimapTrackingShortcut = false,
			MinimapScale = 1,
		},
		Inventory = {
			FastLooting = false,
			InsertItemsLeftToRight = false,
			SortBagsLeftToRight = false,
			SellAllJunk = false,
			AutoRepair = false,
			HideCraftedNames = false,
		},
		Frames = {
			EnhanceDressUp = false,
			DressUpScale = 1,
			ColorPlayerFrame = false,
			ColorTargetFrame = false,	
			ColorFocusFrame = false,
			MoveFramesMode = false,
			FramesScale = 1,
			Frames = {
				PlayerFrame = {
					Point = "TOPLEFT",
					Relative = "TOPLEFT",
					XOffset = -19,
					YOffset = -4,
					Scale = 1,
				},
				TargetFrame = {
					Point = "TOPLEFT",
					Relative = "TOPLEFT",
					XOffset = 250,
					YOffset = -4,
					Scale = 1,
				},
				FocusFrame = {
					Point = "TOPLEFT",
					Relative = "TOPLEFT",
					XOffset = 250,
					YOffset = -240,
					Scale = 1,
				},
				BuffFrame = {
					Point = "TOPRIGHT",
					Relative = "TOPRIGHT",
					XOffset = -202,
					YOffset = -13,
					Scale = 1,
				},
				UIWidgetTopCenterContainerFrame = {
					Point = "TOP",
					Relative = "TOP",
					XOffset = 0,
					YOffset = -15,
					Scale = 1,
				},
				GhostFrame = {
					Point = "TOP",
					Relative = "TOP",
					XOffset = 0,
					YOffset = -67,
					Scale = 1,
				},
				MirrorTimer1 = {
					Point = "TOP",
					Relative = "TOP",
					XOffset = 0,
					YOffset = -96,
					Scale = 1,
				}
			}
		},
		Skins = {
			ButtonBG = {
				BtnBGBackdrop = {
					bgFile 		= texturesPath .. "BackgroundFlat",
					edgeFile 	= texturesPath .. "OuterShadow",
					tile 		= false,
					tileSize 	= 32,
					edgeSize 	= 5,
					insets 		= {left = 5, right = 5, top = 5, bottom = 5}
				},
				BtnBGColor 			= {0.2, 0.2, 0.2, 0.4},
				BtnBGBorderColor 	= {0, 0, 0, 0.9},
				BtnBGPadding 		= 2.5,
			},
			Buffs = {
				StyleBuffs 				= false,
				BuffBorderTexture 		= "Interface\\Buttons\\UI-Quickslot2",
				BuffBorderColor 		= {tr = .7, tg = .7, tb = .7, ta = 1, br = .5, bg = .5, bb = .5, ba = 1},
				BuffBorderPadding 		= 12,
				BuffFont 				= fontsPath .. "Roboto-Regular.ttf",
				BuffDurationFontSize 	= 12,
				BuffStackFontSize 		= 14
			},
			Auras = {
				StyleAuras 				= false,
				AuraBorderTexture 		= "Interface\\Buttons\\UI-Quickslot2",
				AuraBorderColor 		= {tr = .7, tg = .7, tb = .7, ta = 1, br = .5, bg = .5, bb = .5, ba = 1},
				AuraBorderPadding 		= 8,
				AuraFont 				= fontsPath .. "Roboto-Regular.ttf",
				AuraDurationFontSize 	= 12,
				AuraStackFontSize 		= 15
			},
			AuraCast = {
				StyleAuraCast 			= false,
				AuraCastBorderTexture 	= "Interface\\Buttons\\UI-Quickslot2",
				AuraCastBorderColor 	= {tr = .7, tg = .7, tb = .7, ta = 1, br = .5, bg = .5, bb = .5, ba = 1},
				AuraCastBorderPadding 	= 8,
			},
			ActionButtons = {
				StyleActionButtons 			= false,
				ActionBtnNormalTexture 		= texturesPath .. "TextureNormalGloss",
				ActionBtnEquippedTexture 	= texturesPath .. "TextureEquippedGloss",
				ActionBtnSetTexture			= texturesPath .. "TextureSetGloss",
				ActionBtnNormalColor 		= {tr = .6, tg = .6, tb = .6, ta = 1, br = .4, bg = .4, bb = .4, ba = 1},
				ActionBtnEquippedColor 		= {tr = 0, tg = 1, tb = 0, ta = 1, br = 0, bg = .5, bb = 0, ba = 1},
				ActionBtnSetColor 			= {tr = 0, tg = 1, tb = 0, ta = 1, br = 0, bg = .5, bb = 0, ba = 1},
				ActionBtnBorderPadding 		= 1,
			},
			ExtraButton = {
				StyleExtraButton 		= false,
				ExtraBtnNormalTexture 	= texturesPath .. "TextureNormalGloss",
				ExtraBtnNormalColor 	= {tr = .6, tg = .6, tb = .6, ta = 1, br = .4, bg = .4, bb = .4, ba = 1},
			},
			Bags = {
				StyleBags 			= false,
				BagNormalTexture 	= texturesPath .. "TextureNormalGloss",
				BagNormalColor 		= {tr = .6, tg = .6, tb = .6, ta = 1, br = .4, bg = .4, bb = .4, ba = 1},
				BagBorderPadding 	= 3,
			},
			PetButtons = {
				StylePetButtons 	= false,
				PetBtnNormalTexture = texturesPath .. "TextureNormalGloss",
				PetBtnNormalColor 	= {tr = .6, tg = .6, tb = .6, ta = 1, br = .4, bg = .4, bb = .4, ba = 1},
				PetBtnBorderPadding = 2,
			},
			StanceButtons = {
				StyleStanceButtons 		= false,
				StanceBtnNormalTexture 	= texturesPath .. "TextureNormalGloss",
				StanceBtnNormalColor 	= {tr = .6, tg = .6, tb = .6, ta = 1, br = .4, bg = .4, bb = .4, ba = 1},
				StanceBtnBorderPadding 	= 2,
			},
			PossessButtons = {
				StylePossessButtons 	= false,
				PossessBtnNormalTexture = texturesPath .. "TextureNormalGloss",
				PossessBtnNormalColor 	= {tr = .6, tg = .6, tb = .6, ta = 1, br = .4, bg = .4, bb = .4, ba = 1},
				PossessBtnBorderPadding = 2,
			},
			LeaveButton = {
				StyleLeaveButton 		= false,
				LeaveBtnNormalTexture 	= texturesPath .. "TextureNormalGloss",
				LeaveBtnNormalColor 	= {tr = .6, tg = .6, tb = .6, ta = 1, br = .4, bg = .4, bb = .4, ba = 1},
				LeaveBtnBorderPadding 	= 2.5,
			},
			MainBar = {
				StyleMainBar = false,
				MainBarColor = {.5, .5, .5},
			},
			ChatFrame = {
				StyleChatFrame = false,
				ChatFrameColor = {0, 0, 0, .7},
			},
			Tooltip = {
				StyleTooltip 	= false,
				TooltipBackdrop = {
					bgFile 		= "Interface\\Buttons\\WHITE8x8",
					edgeFile 	= "Interface\\Tooltips\\UI-Tooltip-Border",
					tiled 		= false,
					edgeSize 	= 16,
					insets 		= {left = 3.3, right = 3.3, top = 3.3, bottom = 3.3}
				},
				TooltipBGColor 			= {.08, .08, .1, .92},
				TooltipBorderColor 		= {.3, .3, .3, 1},
				TooltipStatusBarHeight 	= 4,
				FontFamily 				= STANDARD_TEXT_FONT,
				TooltipBodyTextColor 	= {.4, .4, .4},
				TooltipDeadTextColor 	= {.5, .5, .5},
				TooltipAfkTextColor 	= {0, 1, 1},
				TooltipTargetTextColor 	= {1, .5 , .5},
				ToolTipGuildTextColor 	= {1, 0, 1},
				TooltipBossTextColor 	= {1, 0, 0},
				TooltipScale 			= 1,
			}
		},
		Extra = {
			HideGryphons = false,
			HideOrderHallBar = false,
			CollapseObjectives = false,
			NoMapEmote = false,
			CharAddonsList = false,
		},
		Setting = {
			ShowMinimapButton = true,
			UIScale = 1.05,
			UIOpacity = 0.95,
		},
	}

-- ==================================================================================================
-- Addon Character Saved Variables
-- ==================================================================================================

	Config.CharDB = {
		HealthBar = {
			HealthBar = false,
			HPUpdateInterval = 0.08,

			HPBGColor = {0.2, 0.2, 0.2, 0.9},
			HPBGTexture = statusBarsPath .. "Gradient2",

			HPSmoothBar = true,

			IncomingHeals = true,
			IncomingHealsTexture = statusBarsPath .. "Gradient2",

			AbsorbBar = true,
			AbsorbBarColor = {1, 1, 1, 1},
			AbsorbTexture = statusBarsPath .. "CrossHatch",

			HPClassColored = false,
			HPBarColor = {0, 1, 0, 1},

			HPBarTexture = statusBarsPath .. "Subtle",

			HPLowColor = false,
			HPLowThreshold = 0.25,
			HPBarColorLow = {1, 0, 0, 1},

			HPWidth = 200,
			HPHeight = 16,
			Pos = {
				HPX = 0,
				HPY = -115,
			},

			HPShowText = false,
			HPShortNumber = false,
			HPFontPos = {
				HPFontX = 0,
				HPFontY = 0,
			},
			HPFontFamily = "Fonts\\ARIALN.ttf",
			HPFontSize = 16,
			HPFontStyle = "THINOUTLINE",
			HPFontColor = {1, 1, 1, 1},

			HPInactiveOpacity = 0.5,
			HPActiveOpacity = 1.0,
			HPDeadOpacity = 0.2,
			HPLossOpacity = 0.5,

			PetBar = false,
			PetBarColor = {1, 1, 1, 1},
			PetBarTexture = statusBarsPath .. "CrossHatch",
			PetBarText = false,
			PetFontPos = {
				PetFontX = 1,
				PetFontY = 0,
			},
			PetFontFamily = "Fonts\\ARIALN.ttf",
			PetFontSize = 16,
			PetFontStyle = "THINOUTLINE",
			PetFontColor = {1, 1, 1, 1},
		},
		PowerBar = {
			PowerBar = false,
			PBUpdateInterval = 0.08,

			PBBGColor = {0.2, 0.2, 0.2, 0.9},
			PBBGTexture = statusBarsPath .. "Gradient2",

			BPSmooth = true,

			PBPrediction = true,
			PBPredictionTexture = statusBarsPath .. "CrossHatch",

			AutoAttackBar = false,
			AutoAttackBarTexture = statusBarsPath .. "CrossHatch",
			AutoAttackBarColor = { 1, 1, 1, 1},

			PBCustomColor = false,
			PBBarColor = {0.6, 0.6, 0.6, 1},

			PBTexture = statusBarsPath .. "Subtle",

			EnablePBLowColor = false,
			PBLowThreshold = 0.25,
			PBLowColor = { 1, 0, 0, 1},
			EnablePBHighColor = false,
			PBHighThreshold = 0.80,
			PBHighColor = { 1, 0.55, 0, 1},

			PBWidth = 200,
			PBHeight = 16,
			Pos = {
				PBX = 0,
				PBY = -133,
			},

			PBShowText = false,
			PowerShortNumber = false,
			PBFontPos = {
				BPFontX = 0,
				BPFontY = 0,
			},
			PBFontFamily = "Fonts\\ARIALN.ttf",
			PBFontSize = 16,
			PBFontStyle = "THINOUTLINE",
			PBFontColor = {1, 1, 1, 1},

			PBInactiveOpacity = 0.5,
			PBActiveOpacity = 1.0,
			PBDeadOpacity = 0.2,
			PBLossOpacity = 0.5,
		},
		AltPowerBar = {
			AltPowerBar = false,
			APBUpdateInterval = 0.08,

			APInactiveOpacity = 1.0,
			APActiveOpacity = 1.0,
			APDeadOpacity = 0.2,
			APLossOpacity = 0.5,
		}
	}

-- ==================================================================================================
-- Class Specific Configuration
-- ==================================================================================================

	Config.Class = {
		DEATHKNIGHT = {
			[1] = {
				PowerPrediction = false,
			},
			[2] = {
				PowerPrediction = false,
			},
			[3] = {
				PowerPrediction = false,
			}
		},
		DEMONHUNTER = {
			[1] = {
				PowerPrediction = false,
			},
			[2] = {
				PowerPrediction = false,
			}
		},
		DRUID = {
			[1] = {
				PowerPrediction = true,
			},
			[2] = {
				PowerPrediction = true,
			},
			[3] = {
				PowerPrediction = true,
			},
			[4] = {
				PowerPrediction = true,
			}
		},
		HUNTER = {
			[1] = {
				PowerPrediction = false,
			},
			[2] = {
				PowerPrediction = false,
			},
			[3] = {
				PowerPrediction = false,
			}
		},
		MAGE = {
			[1] = {
				PowerPrediction = true,
			},
			[2] = {
				PowerPrediction = true,
			},
			[3] = {
				PowerPrediction = true,
			}
		},
		MONK = {
			[1] = {
				PowerPrediction = false,
			},
			[2] = {
				PowerPrediction = true,
			},
			[3] = {
				PowerPrediction = false,
			}
		},
		PALADIN = {
			[1] = {
				PowerPrediction = true,
			},
			[2] = {
				PowerPrediction = true,
			},
			[3] = {
				PowerPrediction = true,
			}
		},
		PRIEST = {
			[1] = {
				PowerPrediction = true,
			},
			[2] = {
				PowerPrediction = true,
			},
			[3] = {
				PowerPrediction = true,
			}
		},
		ROGUE = {
			[1] = {
				PowerPrediction = false,
			},
			[2] = {
				PowerPrediction = false,
			},
			[3] = {
				PowerPrediction = false,
			}
		},
		SHAMAN = {
			[1] = {
				PowerPrediction = true,
			},
			[2] = {
				PowerPrediction = true,
			},
			[3] = {
				PowerPrediction = true,
			}
		},
		WARLOCK = {
			[1] = {
				PowerPrediction = true,
			},
			[2] = {
				PowerPrediction = true,
			},
			[3] = {
				PowerPrediction = true,
			}
		},
		WARRIOR = {
			[1] = {
				PowerPrediction = false,
			},
			[2] = {
				PowerPrediction = false,
			},
			[3] = {
				PowerPrediction = false,
			}
		}
	}

-- ==================================================================================================
-- Config Initialization
-- ==================================================================================================

	-- Initialize saved variables.
	-- Initialize both general saved variables and character specific saved variables
	function Config.initSavedVariables()

		if type(zAddonDB) ~= "table" then
			
	     	zAddonDB = Config.DB
	    end

	    if type(zAddonCharDB) ~= "table" then

	     	zAddonCharDB = Config.CharDB
	    end
	end
