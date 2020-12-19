--#############################
--##### TRIP'S PRIEST UI ######
--#############################


local TMW                                            = TMW 
local CNDT                                            = TMW.CNDT
local Env                                            = CNDT.Env
local A                                                = Action
local GetToggle                                        = A.GetToggle
local InterruptIsValid                                = A.InterruptIsValid
local UnitCooldown                                    = A.UnitCooldown
local Unit                                            = A.Unit 
local Player                                        = A.Player 
local Pet                                            = A.Pet
local LoC                                            = A.LossOfControl
local MultiUnits                                    = A.MultiUnits
local EnemyTeam                                        = A.EnemyTeam
local FriendlyTeam                                    = A.FriendlyTeam
local TeamCache                                        = A.TeamCache
local InstanceInfo                                    = A.InstanceInfo
local TR                                            = Action.TasteRotation
local select, setmetatable                            = select, setmetatable

-- Shadowlands Spell Info fix for empty spells
local GetSpellInfo_original                                = _G.GetSpellInfo
local function GetSpellInfo(...)
    return GetSpellInfo_original(...) or ""
end

A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI                                     = {    
    DateTime = "v1.6.0 (17 Dec 2020)",
    [2] = {        
        [ACTION_CONST_PRIEST_SHADOW] = {             
            { -- GENERAL HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< GENERAL ><><><l ",
                    },
                },
            }, 
			{
                {
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
                    L = { 
                        enUS = "Use @mouseover", 
                    }, 
                    TT = { 
                        enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing", 
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "AoE",
                    DBV = true,
                    L = { 
                        enUS = "Use AoE", 
                    }, 
                    TT = { 
                        enUS = "Enable multiunits actions", 
                    }, 
                    M = {},
                }, 
				{ -- Auto Multi Dot
                    E = "Checkbox", 
                    DB = "AutoMultiDot",
                    DBV = false,
                    L = { 
                        ANY = "Auto Multi DoT (BETA)"
                    }, 
                    TT = { 
                        ANY = "Switch through enemies to apply DoTs automatically! Limited to five total targets per combat."
                    }, 
                    M = {},
                },	                    
            },
            { -- LAYOUT SPACE
                
                {
                    E = "LayoutSpace",                                                                         
                },
            }, 				
            { -- [2]  
                {
                    E = "Checkbox", 
                    DB = "UsePWS",
                    DBV = false,
                    L = { 
                        enUS = "Use Power Word: Shield for movement.",
                    }, 
                    TT = { 
                        enUS = "Use Power Word: Shield for movement.",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 7,                            
                    DB = "PWSMove",
                    DBV = 3, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "PW:S if moving for",
                    }, 
                    TT = { 
                        enUS = "If " .. GetSpellInfo(17) .. " is talented and ready, will use it if moving for set value.", 
                        ruRU = "Если " .. GetSpellInfo(17) .. " изучен и готов, будет использовать его при переходе на заданное значение.", 
                        frFR = "Si " .. GetSpellInfo(17) .. " est prêt, l'utilisera s'il se déplace pour la valeur définie.", 
                    }, 
                    M = {},
                },				
            },
            { -- LAYOUT SPACE
                
                {
                    E = "LayoutSpace",                                                                         
                },
            }, 			
            { -- ROTATION CHANGES
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< ROTATION CHANGES ><><><l ",
                    },
                },
            },
			{
                {
                    E = "Checkbox", 
                    DB = "PWSAlways",
                    DBV = false,
                    L = { 
                        ANY = "PW:S Always",
                    }, 
                    TT = { 
                        ANY = "Use Power Word: Shield whenever it's available.",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "CombatMeditation",
                    DBV = false,
                    L = { 
                        ANY = "Combat Meditation Conduit",
                    }, 
                    TT = { 
                        ANY = "Tick this box if you have the Combat Meditation conduit active.",
                    }, 
                    M = {},
                },
			},
			{
                {
                    E = "Checkbox", 
                    DB = "ShadowflamePrism",
                    DBV = false,
                    L = { 
                        ANY = "Shadowflame Prism",
                    }, 
                    TT = { 
                        ANY = "Check this box if you have the Shadowflame Prism legendary.",
                    }, 
                    M = {},
                },	
                {
                    E = "Checkbox", 
                    DB = "Painbreaker",
                    DBV = false,
                    L = { 
                        ANY = "Painbreaker",
                    }, 
                    TT = { 
                        ANY = "Check this box if you have the Painbreaker legendary.",
                    }, 
                    M = {},
                },				
			},
            { -- LAYOUT SPACE
                
                {
                    E = "LayoutSpace",                                                                         
                },
            }, 			
            { -- ROTATION CHANGES
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< DEFENSIVES ><><><l ",
                    },
                },
            },			
			{ -- [4]     
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "VampiricEmbrace",
                    DBV = 60, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(15286) .. " (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "FadeHP",
                    DBV = 80, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Fade HP (%)",
                    }, 
                    M = {},
                },	
			},
			{
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "PWSHP",
                    DBV = 90, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Power Word: Shield HP (%)",
                    }, 
                    M = {},
                },	
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "ShadowMendHP",
                    DBV = 40, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Shadow Mend HP (%)",
                    }, 
                    M = {},
                },	
			},
			{
			    {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "DispersionHP",
                    DBV = 20, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Dispersion HP (%)",
                    }, 
                    M = {},
                },			
			    {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "SpiritualHealingPotionHP",
                    DBV = 30, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Healing Potion HP (%)",
                    }, 
                    M = {},
                },
            },                    
        },
        
        [ACTION_CONST_PRIEST_DISCIPLINE] = {          
            LayoutOptions = { gutter = 5, padding = { left = 10, right = 10 } },    
            { -- General Header
                {
                    E = "Header",
                    L = {
                        ANY = " -- General -- ",
                    },
                },
            },
            { -- General Content			
                { -- Mouseover Checkbox
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
                    L = { 
                        enUS = "Use\n@mouseover", 
                        ruRU = "Использовать\n@mouseover", 
                    }, 
                    TT = { 
                        enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing", 
                        ruRU = "Разблокирует использование действий для @mouseover юнитов\nНапример: Воскрешение, Хилинг", 
                    }, 
                    M = {},
                },
                { -- TargetTarget Checkbox
                    E = "Checkbox", 
                    DB = "targettarget",
                    DBV = true,
                    L = { 
                        enUS = "Use\n@targettarget", 
                        ruRU = "Использовать\n@targettarget", 
                    }, 
                    TT = { 
                        enUS = "Will unlock use actions\nfor enemy @targettarget units", 
                        ruRU = "Разблокирует использование\nдействий для вражеских @targettarget юнитов", 
                    }, 
                    M = {},
                },
                { -- AoE Checkbox
                    E = "Checkbox", 
                    DB = "AoE",
                    DBV = true,
                    L = { 
                        enUS = "Use\nAoE", 
                        ruRU = "Использовать\nAoE", 
                    }, 
                    TT = { 
                        enUS = "Enable multiunits actions", 
                        ruRU = "Включает действия для нескольких целей", 
                    }, 
                    M = {},
                },  
                {
                    E = "Checkbox", 
                    DB = "UseRotationPassive",
                    DBV = true,
                    L = { 
                        enUS = "Use\nPassive\nRotation",
                        ruRU = "Включить\nПассивную\nРотацию" 
                    },
                    M = {},
                },                                  
            },     
            { -- Header - Healing Engine
                {
                    E = "Header",
                    L = {
                        ANY = " -- Healing Engine -- ",
                    },
                },
            },
				{
					E = "LayoutSpace",
				},			
			{ -- Healing Engine Options
                { -- PW:S Tank
                    E = "Checkbox", 
                    DB = "ShieldTank",
                    DBV = true,
                    L = { 
                        ANY = "PW:S Tank On Cooldown"
                    },
                    TT = { 
						ANY = "Always keep Power Word: Shield active on tank, whenever available.",
                    },
                    M = {},
                },
                { -- PW:S Dropdown
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "TANK", value = "TANK" },    
                        { text = "SELF", value = "SELF" },   
                        { text = "ALL", value = "ALL" },
                    },					
                    DB = "PWSWorkMode",
					DBV = "TANK",
                    L = { 
                        ANY = "Power Word: Shield targets",
                    }, 
                    TT = { 
                        ANY = "Choose what targets to use Power Word: Shield on. This is ignored when using Rapture or atonement ramps.",
                    },                    
                    M = {},
                },				
                { -- Power Word: Shield Slider
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "PowerWordShieldHP",              
                    DBV = 90,
                    ONOFF = false,
                    L = { 
                        ANY = "Power Word: Shield HP %",                        
                    },   
                    TT = { 
                        ANY = "HP % to use Power Word: Shield on group member.",
                    },                    
                    M = {},
                },
			},
				{
					E = "LayoutSpace",
				},
			{
                { -- Shadow Mend, No Atonement Slider
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "ShadowMendHPNoAtone",              
                    DBV = 80,
                    ONOFF = false,
                    L = { 
                        ANY = "Shadow Mend HP Without Atonement",                        
                    },   
                    TT = { 
                        ANY = "Shadow Mend when target HP % AND they don't currently have atonement.",
                    },                    
                    M = {},
                },
                { -- Shadow Mend, Atonement Slider
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "ShadowMendHPWithAtone",              
                    DBV = 70,
                    ONOFF = false,
                    L = { 
                        ANY = "Shadow Mend HP With Atonement",                        
                    },   
                    TT = { 
                        ANY = "Shadow Mend when target HP % AND they currently have atonement.",
                    },                    
                    M = {},
                },
			},
				{
					E = "LayoutSpace",
				},
			{	
                { -- Penance Heal Slider
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "PenanceHeal",              
                    DBV = 60,
                    ONOFF = false,
                    L = { 
                        ANY = "Friendly Penance HP %",                        
                    },   
                    TT = { 
                        ANY = "Friendly target HP % to use Penance as a healing spell.",
                    },                    
                    M = {},
                },
			},
				{
					E = "LayoutSpace",
				},
			{
                { -- Power Word: Radiance HP Slider
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "RadianceHP",              
                    DBV = 90,
                    ONOFF = false,
                    L = { 
                        ANY = "Power Word: Radiance HP",                        
                    },   
                    TT = { 
                        ANY = "HP % to use Power Word: Radiance.",
                    },                    
                    M = {},
                },
                { -- Power Word: Radiance Members Slider
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 5,                            
                    DB = "RadianceMembers",              
                    DBV = 4,
                    ONOFF = false,
                    L = { 
                        ANY = "Power Word: Radiance Targets",                        
                    },   
                    TT = { 
                        ANY = "Amount of party members to be hurt to use Power Word: Radiance.",
                    },                    
                    M = {},
                },							
			},
				{
					E = "LayoutSpace",
				},
			{
                { -- Shadow Covenant HP
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "ShadowCovHP",              
                    DBV = 80,
                    ONOFF = false,
                    L = { 
                        ANY = "Shadow Covenant HP",                        
                    },   
                    TT = { 
                        ANY = "HP % to use Shadow Covenant",
                    },                    
                    M = {},
                },
                { -- Shadow Covenant Members
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 5,                            
                    DB = "ShadowCovMembers",              
                    DBV = 4,
                    ONOFF = false,
                    L = { 
                        ANY = "Shadow Covenant Targets",                        
                    },   
                    TT = { 
                        ANY = "Amount of party members to be hurt to use Shadow Covenant.",
                    },                    
                    M = {},
                },	
                { -- Shadow Covenant Members
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 5,                            
                    DB = "ShadowCovAtone",              
                    DBV = 4,
                    ONOFF = false,
                    L = { 
                        ANY = "Shadow Covenant Atonements",                        
                    },   
                    TT = { 
                        ANY = "Amount of party members to have the atonement buff before using Shadow Covenant.",
                    },                    
                    M = {},
                },					
			},
				{
					E = "LayoutSpace",
				},
			{			
                { -- Purify Checkbox
                    E = "Checkbox", 
                    DB = "UsePurify",
                    DBV = true,
                    L = { 
                        ANY = "Auto Purify"
                    },
                    TT = { 
						ANY = "Uses Purify to cleanse auras listed in the Auras tab.",
                    },
                    M = {},
                },			
            },   
            { -- Header - Trinkets
                {
                    E = "Header",
                    L = {
                        ANY = " -- Trinkets -- ",
                    },
                },
            },    
            { -- Trinket Options                
                { -- How to use trinkets
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "Always", value = "Always" },
                        { text = "Burst Synchronized", value = "BurstSync" },                    
                    },
                    DB = "TrinketBurstSyncUP",
                    DBV = "Always",
                    L = { 
                        enUS = "Damager: How to use trinkets",
                        ruRU = "Урон: Как использовать аксессуары", 
                    },
                    TT = { 
                        enUS = "Always: On cooldown\nBurst Synchronized: By Burst Mode in 'General' tab",
                        ruRU = "Always: По доступности\nBurst Synchronized: От Режима Бурстов во вкладке 'Общее'", 
                    }, 
                    M = {},
                },
                { -- Trinket Mana
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 100,                            
                    DB = "TrinketMana",
                    DBV = 85,
                    ONLYOFF = false,
                    L = { 
                        enUS = "Trinket: Mana(%)",
                        ruRU = "Trinket: Mana(%)",
                    },
                    M = {},
                },
                { -- Trinket Healing
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 100,                            
                    DB = "TrinketBurstHealing",
                    DBV = 75,
                    ONLYOFF = false,
                    L = { 
                        enUS = "Healer: Target Health (%)",
                        ruRU = "Лекарь: Здоровье Цели (%)", 
                    },
                    M = {},
                },        
            },
            { -- Header - Mythic+
                {
                    E = "Header",
                    L = {
                        ANY = " -- Mythic + -- ",
                    },
                },
            },    
            { -- Mythic+ Options
                { -- MythicPlusLogic
                    E = "Checkbox", 
                    DB = "MythicPlusLogic",
                    DBV = true,
                    L = { 
                        enUS = "Smart Mythic+",
                        ruRU = "Smart Mythic+",
                    },
                    TT = { 
                        enUS = "Enable this option to activate critical healing logic depending of the current dungeon.\nExample:Fulminating Zap in Junkyard",
                        ruRU = "Enable this option to activate critical healing logic depending of the current dungeon.\nExample:Fulminating Zap in Junkyard",
                    },
                    M = {},
                },    
                { -- GrievousWoundsLogic
                    E = "Checkbox", 
                    DB = "GrievousWoundsLogic",
                    DBV = true,
                    L = { 
                        enUS = "Grievous Wounds\nlogic",
                        ruRU = "Grievous Wounds\nlogic",
                    },
                    TT = { 
                        enUS = "Enable this option to activate critical healing logic for friendly units that got Grievous Wounds debuff.",
                        ruRU = "Enable this option to activate critical healing logic for friendly units that got Grievous Wounds debuff.",
                    },
                    M = {},
                },
                { -- GrievousWoundsMinStacks
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 5,                            
                    DB = "GrievousWoundsMinStacks",                    
                    DBV = 2,
                    ONOFF = false,
                    L = { 
                        ANY = "Grievous Wounds\nmin stacks",                        
                    },   
                    TT = { 
                        enUS = "How many stacks of Grievous Wounds should be up on friendly unit before force targetting on this unit.\nExample: 2 means friendly unit will be urgently targetted if he got 2 stacks.", 
                        ruRU = "How many stacks of Grievous Wounds should be up on friendly unit before force targetting on this unit.\nExample: 2 means friendly unit will be urgently targetted if he got 2 stacks.", 
                    },                    
                    M = {},
                },                
                { -- StopCastQuake
                    E = "Checkbox", 
                    DB = "StopCastQuake",
                    DBV = true,
                    L = { 
                        enUS = "Stop Cast\nquaking",
                        ruRU = "Stop Cast\nquaking",
                    },
                    TT = { 
                        enUS = "Enable this option to automatically stop your current cast before Quake.",
                        ruRU = "Enable this option to automatically stop your current cast before Quake.",
                    },
                    M = {},
                },    
                { -- StopCastQuakeSec
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 3,                            
                    DB = "StopCastQuakeSec",                    
                    DBV = 1,
                    Precision = 1,
                    ONOFF = false,
                    L = { 
                        ANY = "Stop Cast\nquaking seconds",                      
                    },
                    TT = { 
                        enUS = "Define the value you want to stop your cast before next Quake hit.\nValue is in seconds.\nExample: 1 means you will stop cast at 1sec remaining on Quaking.",            
                        ruRU = "Define the value you want to stop your cast before next Quake hit.\nValue is in seconds.\nExample: 1 means you will stop cast at 1sec remaining on Quaking.",            
                    },                    
                    M = {},
                },
            },
            { -- Penance Header
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(47540) .. " -- ",
                    },
                }, 
            },
            { -- Penance Options
                { -- Penance Dropdown
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "BOTH", value = "BOTH" },
                        { text = "HEAL", value = "HEAL" },    
                        { text = "DMG", value = "DMG" },                    
                    },
                    DB = "PenanceWorkMode",
                    DBV = "BOTH",
                    L = { 
                        ANY = GetSpellInfo(47540) .. " Work Mode",
                    }, 
                    TT = { 
                        enUS = "These conditions will be skiped if unit will dying in emergency (critical) situation", 
                        ruRU = "Эти условия будут пропущены если юнит будет умирать в чрезвычайной (критической) ситуациии", 
                    },                    
                    M = {},
                },
            },
            { -- Defensives Header
                {
                    E = "Header",
                    L = {
                        ANY = " -- Defensives -- ",
                    },
                }, 
            },
            { -- Defensives Options
				{ -- Desperate Prayer
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "DesperatePrayer",                    
                    DBV = 50,
                    ONOFF = false,
                    L = { 
                        ANY = "Desperate Prayer HP %",                        
                    },   
                    TT = { 
                        ANY = "% HP to use Desperate Prayer."
                    },                    
                    M = {},
                }				
			}
        },
        [ACTION_CONST_PRIEST_HOLY] = {          
            LayoutOptions = { gutter = 5, padding = { left = 10, right = 10 } },    
            { -- GENERAL HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< GENERAL ><><><l ",
                    },
                },
            },
            { -- GENERAL SETTINGS                            
                { -- MOUSEOVER
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
                    L = { 
                        enUS = "Use\n@mouseover", 
                        ruRU = "Использовать\n@mouseover", 
                    }, 
                    TT = { 
                        enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing", 
                        ruRU = "Разблокирует использование действий для @mouseover юнитов\nНапример: Воскрешение, Хилинг", 
                    }, 
                    M = {},
                },
                { -- TARGETTARGET
                    E = "Checkbox", 
                    DB = "targettarget",
                    DBV = true,
                    L = { 
                        enUS = "Use\n@targettarget", 
                        ruRU = "Использовать\n@targettarget", 
                    }, 
                    TT = { 
                        enUS = "Will unlock use actions\nfor enemy @targettarget units", 
                        ruRU = "Разблокирует использование\nдействий для вражеских @targettarget юнитов", 
                    }, 
                    M = {},
                },
                { -- AOE
                    E = "Checkbox", 
                    DB = "AoE",
                    DBV = true,
                    L = { 
                        enUS = "Use\nAoE", 
                        ruRU = "Использовать\nAoE", 
                    }, 
                    TT = { 
                        enUS = "Enable multiunits actions", 
                        ruRU = "Включает действия для нескольких целей", 
                    }, 
                    M = {},
                },                                    
            },
            { -- LAYOUT SPACE
                
                {
                    E = "LayoutSpace",                                                                         
                },
            },  			
            { -- DAMAGE STUFF HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< DAMAGE STUFF ><><><l ",
                    },
                },
            },
			{
			    { -- DPS MANA
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "DPSMana",
                    DBV = 30,
                    ONLYOFF = true,
                    L = { 
                        ANY = "DPS while above mana(%)"
                    },
					TT = {
						ANY = "Amount of mana (%) to have before using DPS abilities."
					},
                    M = {},
                },			
				{ -- Holy Nova Targets
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "HolyNovaTargets",
                    DBV = 5,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Holy Nova enemy targets ",
                    },
                    TT = { 
                        ANY = "How many targets to be in range of you to use Holy Nova. Only takes enemies into account."
                    }, 					
                    M = {},
                },
			},
            { -- LAYOUT SPACE
                
                {
                    E = "LayoutSpace",                                                                         
                },
            },  			
            { -- HEALING ENGINE HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< HEALING ENGINE ><><><l ",
                    },
                },
            },    
            { 
                { -- MANA MANAGEMENT
                    E = "Checkbox", 
                    DB = "ManaManagement",
                    DBV = true,
                    L = { 
                        enUS = "Boss Fight\nManaSave\n(PvE)", 
                        ruRU = "Бой с Боссом\nУправление Маной\n(PvE)",
                    }, 
                    TT = { 
                        enUS = "Enable to keep small mana save tricks during boss fight\nMana will keep going to save phase if Boss HP >= our Mana", 
                        ruRU = "Включает сохранение малого количества маны с помощью некоторых манипуляций в течении боя против Босса\nМана будет переходить в фазу сохранения если ХП Босса >= нашей Маны", 
                    }, 
                    M = {},
                },             
                { -- MANA POTION
                    E = "Checkbox", 
                    DB = "ManaPotion",
                    DBV = true,
                    L = { 
                        enUS = "Use\nMana Potion",
                        ruRU = "Использовать\nЗелье Маны",
                    },
                    M = {},
                },        
            },
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            }, 				
			{
			    { -- HOLY WORD SERENITY
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "HolyWordSerenity",
                    DBV = 75,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Holy Word: Serenity HP (%)"
                    },
					TT = {
						ANY = "Target HP % to use Holy Word: Serenity."
					},
                    M = {},
                },
			},
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            }, 			
			{
			    { -- SANCTIFY ON @PLAYER
                    E = "Checkbox", 
                    DB = "UseSanctifyOnSelf",
                    DBV = true,
                    L = { 
                        ANY = "Holy Word: Sanctify on yourself"
                    },
					TT = {
						ANY = "Use Holy Word: Sanctify on yourself. Requires you to macro Holy Word: Sanctify to /cast [@player] Holy Word: Sanctify"
					},
                    M = {},
                },
			    { -- SANCTIFY TARGETS
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 6,                            
                    DB = "SanctifyTargets",
                    DBV = 3,
                    ONLYOFF = true,
                    L = { 
                        ANY = "HW: Sanctify Targets"
                    },
					TT = {
						ANY = "Amount of targets before using Holy Word: Sanctify."
					},
                    M = {},
                },
			    { -- SANCTIFY HP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "SanctifyHP",
                    DBV = 85,
                    ONLYOFF = true,
                    L = { 
                        ANY = "HW: Sanctify HP (%)"
                    },
					TT = {
						ANY = "Target HP % to use Holy Word: Sanctify."
					},
                    M = {},
                },
			},
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            }, 				
			{
			    { -- HEAL HP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "HealHP",
                    DBV = 90,
                    ONLYOFF = true,
                    L = { 
                        ANY = "(Binding)Heal HP (%)"
                    },
					TT = {
						ANY = "Target HP % to use Heal or Binding Heal. Binding Heal will be prioritised over Heal if talented."
					},
                    M = {},
                },
                { -- RENEW MODE
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "TANK", value = "TANK" },
                        { text = "EVERYONE", value = "EVERYONE" }, 						
                        { text = "OFF", value = "OFF" },                    
                    },
                    DB = "RenewMode",
                    DBV = "TANK",
                    L = { 
                        ANY = "Renew Setting",
                    }, 
                    TT = { 
                        ANY = "Choose how to use Renew." 
                    },                    
                    M = {},
                },
			    { -- BLANKET RENEW OOC
                    E = "Checkbox", 
                    DB = "BlanketRenewOOC",
                    DBV = true,
                    L = { 
                        ANY = "Blanket Renew OOC"
                    },
					TT = {
						ANY = "Use Renew to top up allies while out of combat (dungeon only)."
					},
                    M = {},
                },				
			},			
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            }, 				
			{
			    { -- FLASH HEAL HP (NO SOL)
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "FlashHealHP",
                    DBV = 70,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Flash Heal (no SoL) HP (%)"
                    },
					TT = {
						ANY = "Target HP % to use Flash Heal (excludes Surge of Light procs)."
					},
                    M = {},
                },
			    { -- FLASH HEAL HP (SOL)
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "FlashHealSOLHP",
                    DBV = 90,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Flash Heal (with SoL) HP (%)"
                    },
					TT = {
						ANY = "Target HP % to use Flash Heal when you have a Surge of Light proc."
					},
                    M = {},
                },				
			},
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            }, 				
			{
			    { -- CIRCLE OF HEALING TARGETS
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 5,                            
                    DB = "CircleofHealingTargets",
                    DBV = 3,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Circle of Healing Targets"
                    },
					TT = {
						ANY = "Amount of targets before using Circle of Healing. NOTE, I RECOMMEND TO BIND THIS AS A MACRO TO CAST ON YOURSELF DUE TO AWKWARD 30 YARD RANGE CHECK: /cast [@player] Circle of Healing"
					},
                    M = {},
                },
			    { -- CIRCLE OF HEALING HP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "CircleofHealingHP",
                    DBV = 90,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Circle of Healing HP (%)"
                    },
					TT = {
						ANY = "Target HP % to use Circle of Healing"
					},
                    M = {},
                },
			},
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            }, 				
			{
			    { -- PRAYER OF HEALING TARGETS
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 5,                            
                    DB = "PrayerofHealingTargets",
                    DBV = 3,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Prayer of Healing Targets"
                    },
					TT = {
						ANY = "Amount of targets before using Prayer of Healing. "
					},
                    M = {},
                },
			    { -- PRAYER OF HEALING HP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "PrayerofHealingHP",
                    DBV = 80,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Prayer of Healing HP (%)"
                    },
					TT = {
						ANY = "Target HP % to use Prayer of Healing"
					},
                    M = {},
                },				
			},
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },
			{
			    { -- HALO TARGETS
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 40,                            
                    DB = "HaloTargets",
                    DBV = 10,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Halo Targets"
                    },
					TT = {
						ANY = "Amount of targets before using Halo. "
					},
                    M = {},
                },
			    { -- HALO HP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "HaloHP",
                    DBV = 80,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Halo HP (%)"
                    },
					TT = {
						ANY = "Target HP % to use Halo"
					},
                    M = {},
                },				
			},
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },			
			{
			    { -- SALVATION TARGETS
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 40,                            
                    DB = "SalvationTargets",
                    DBV = 10,
                    ONLYOFF = true,
                    L = { 
                        ANY = "HW: Salvation Targets"
                    },
					TT = {
						ANY = "Amount of targets before using Holy Word: Salvation. "
					},
                    M = {},
                },
			    { -- SALVATION HP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "SalvationHP",
                    DBV = 70,
                    ONLYOFF = true,
                    L = { 
                        ANY = "HW: Salvation HP (%)"
                    },
					TT = {
						ANY = "Target HP % to use Holy Word: Salvation."
					},
                    M = {},
                },				
			},			
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            }, 				
			{
			    { -- DIVINE HYMN TARGETS
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 40,                            
                    DB = "DivineHymnTargets",
                    DBV = 12,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Divine Hymn Targets"
                    },
					TT = {
						ANY = "Amount of targets before using Divine Hymn. Set at 6 or higher to not use while in a dungeon group."
					},
                    M = {},
                },
			    { -- DIVINE HYMN HP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "DivineHymnHP",
                    DBV = 50,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Divine Hymn HP (%)"
                    },
					TT = {
						ANY = "Group HP % to use Divine Hymn"
					},
                    M = {},
                },
			},
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            }, 				
			{
			    { -- GUARDIAN SPIRIT HP
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "GuardianSpiritHP",
                    DBV = 30,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Guardian Spirit HP (%)"
                    },
					TT = {
						ANY = "Target HP % to use Guardian Spirit"
					},
                    M = {},
                },
			},			
            { -- LAYOUT SPACE              
                {
                    E = "LayoutSpace",                                                                         
                },
            },  			
            { -- TRINKETS
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< TRINKETS ><><><l ",
                    },
                },
            },    
            {                 
                { -- TRINKET MANA
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 100,                            
                    DB = "TrinketMana",
                    DBV = 85,
                    ONLYOFF = false,
                    L = { 
                        enUS = "Trinket: Mana(%)",
                        ruRU = "Trinket: Mana(%)",
                    },
                    M = {},
                },
                { -- TRINKET HEALING
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 100,                            
                    DB = "TrinketHP",
                    DBV = 75,
                    ONLYOFF = false,
                    L = { 
                        enUS = "Trinket: Target Health (%)",
                        ruRU = "Лекарь: Здоровье Цели (%)", 
                    },
                    M = {},
                },        
            },
            { -- LAYOUT SPACE
                
                {
                    E = "LayoutSpace",                                                                         
                },
            },  			
            { -- MYTHIC + HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< MYTHIC PLUS ><><><l ",
                    },
                },
            },    
            { -- MYTHIC + SETTINGS    
                { -- GREVIOUS WOUNDS LOGIC
                    E = "Checkbox", 
                    DB = "GrievousWoundsLogic",
                    DBV = true,
                    L = { 
                        enUS = "Grievous Wounds\nlogic",
                        ruRU = "Grievous Wounds\nlogic",
                    },
                    TT = { 
                        enUS = "Enable this option to activate critical healing logic for friendly units that got Grievous Wounds debuff.",
                        ruRU = "Enable this option to activate critical healing logic for friendly units that got Grievous Wounds debuff.",
                    },
                    M = {},
                },
                { -- GREVIOUS WOUNDS MINIMUM STACKS
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 5,                            
                    DB = "GrievousWoundsMinStacks",                    
                    DBV = 2,
                    ONOFF = false,
                    L = { 
                        ANY = "Grievous Wounds\nmin stacks",                        
                    },   
                    TT = { 
                        enUS = "How many stacks of Grievous Wounds should be up on friendly unit before force targetting on this unit.\nExample: 2 means friendly unit will be urgently targetted if he got 2 stacks.", 
                        ruRU = "How many stacks of Grievous Wounds should be up on friendly unit before force targetting on this unit.\nExample: 2 means friendly unit will be urgently targetted if he got 2 stacks.", 
                    },                    
                    M = {},
                },
			},
			{
                { -- STOPCAST QUAKING
                    E = "Checkbox", 
                    DB = "StopCastQuake",
                    DBV = true,
                    L = { 
                        enUS = "Stop Cast\nquaking",
                        ruRU = "Stop Cast\nquaking",
                    },
                    TT = { 
                        enUS = "Enable this option to automatically stop your current cast before Quake.",
                        ruRU = "Enable this option to automatically stop your current cast before Quake.",
                    },
                    M = {},
                },    
                { -- STOPCAST QUAKING TIMER
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 3,                            
                    DB = "StopCastQuakeSec",                    
                    DBV = 1,
                    Precision = 1,
                    ONOFF = false,
                    L = { 
                        ANY = "Stop Cast\nquaking seconds",                      
                    },
                    TT = { 
                        enUS = "Define the value you want to stop your cast before next Quake hit.\nValue is in seconds.\nExample: 1 means you will stop cast at 1sec remaining on Quaking.",            
                        ruRU = "Define the value you want to stop your cast before next Quake hit.\nValue is in seconds.\nExample: 1 means you will stop cast at 1sec remaining on Quaking.",            
                    },                    
                    M = {},
                },
            },
            { -- LAYOUT SPACE               
                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- UTILITIES
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< UTILITIES ><><><l ",
                    },
                }, 
            },
            {
                {
                    E = "Checkbox", 
                    DB = "AngelicFeather",
                    DBV = true,
                    L = { 
                        enUS = "Auto\n" .. GetSpellInfo(121536),
                        ruRU = "Auto\n" .. GetSpellInfo(121536),
                    },
                    TT = { 
                        enUS = "Enable this option to automatically use " .. GetSpellInfo(121536),
                        ruRU = "Enable this option to automatically use " .. GetSpellInfo(121536),
                    },
                    M = {},
                },    
                {
                    E = "Checkbox", 
                    DB = "LeapofFaith",
                    DBV = true,
                    L = { 
                        enUS = "Auto\n" .. GetSpellInfo(73325),
                        ruRU = "Auto\n" .. GetSpellInfo(73325),
                    },
                    TT = { 
                        enUS = "Enable this option to automatically use " .. GetSpellInfo(73325),
                        ruRU = "Enable this option to automatically use " .. GetSpellInfo(73325),
                    },
                    M = {},
                },    
            },
            { -- LAYOUT SPACE               
                {
                    E = "LayoutSpace",                                                                         
                },
            },  			
            { -- DEFENSIVES
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< DEFENSIVES ><><><l ",
                    },
                }, 
            },
            {
                { -- DESPERATE PRAYER
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "DesperatePrayer",
                    DBV = 40,
                    ONLYOFF = true,
                    L = { 
                        ANY = "Desperate Prayer HP (%)"
                    },
                    M = {},
                },      
            },                                   
        },        
    },
}

function A.Main_CastBars(unit, list)
    if not A.IsInitialized or A.IamHealer or (A.Zone ~= "arena" and A.Zone ~= "pvp") then 
        return false 
    end 
    
    if A[A.PlayerSpec] and A[A.PlayerSpec].SpearHandStrike and A[A.PlayerSpec].SpearHandStrike:IsReadyP(unit, nil, true) and A[A.PlayerSpec].SpearHandStrike:AbsentImun(unit, {"KickImun", "TotalImun", "DamagePhysImun"}, true) and A.InterruptIsValid(unit, list) then 
        return true         
    end 
end 

function A.Second_CastBars(unit)
    if not A.IsInitialized or (A.Zone ~= "arena" and A.Zone ~= "pvp")  then 
        return false 
    end 
    
    local Toggle = A.GetToggle(2, "ParalysisPvP")    
    if Toggle and Toggle ~= "OFF" and A[A.PlayerSpec] and A[A.PlayerSpec].Paralysis and A[A.PlayerSpec].Paralysis:IsReadyP(unit, nil, true) and A[A.PlayerSpec].Paralysis:AbsentImun(unit, {"CCTotalImun", "TotalImun", "DamagePhysImun"}, true) and Unit(unit):IsControlAble("incapacitate", 0) then 
        if Toggle == "BOTH" then 
            return select(2, A.InterruptIsValid(unit, "Heal", true)) or select(2, A.InterruptIsValid(unit, "PvP", true)) 
        else
            return select(2, A.InterruptIsValid(unit, Toggle, true))         
        end 
    end 
end 

