--####################################
--##### TRIP'S WARLOCK PROFILEUI #####
--####################################


local TMW											= TMW 
local CNDT											= TMW.CNDT
local Env											= CNDT.Env

local A												= Action
local GetToggle										= A.GetToggle
local InterruptIsValid								= A.InterruptIsValid

local UnitCooldown									= A.UnitCooldown
local Unit											= A.Unit 
local Player										= A.Player 
local Pet											= A.Pet
local LoC											= A.LossOfControl
local MultiUnits									= A.MultiUnits
local EnemyTeam										= A.EnemyTeam
local FriendlyTeam									= A.FriendlyTeam
local TeamCache										= A.TeamCache
local InstanceInfo									= A.InstanceInfo
local select, setmetatable							= select, setmetatable


A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {    
    DateTime = "v1.1.0 (18 Nov 2020)",
    -- Class settings
    [2] = {        
        [ACTION_CONST_WARLOCK_AFFLICTION] = {  
            { -- General -- Header
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< GENERAL ><><><l ",
                    },
                },
            },		
            { -- General -- Content
                { -- Mouseover
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
                    L = { 
                        enUS = "Use @mouseover", 
                        ruRU = "Использовать @mouseover", 
                        frFR = "Utiliser les fonctions @mouseover",
                    }, 
                    TT = { 
                        enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing", 
                        ruRU = "Разблокирует использование действий для @mouseover юнитов\nНапример: Воскрешение, Хилинг", 
                        frFR = "Activera les actions via @mouseover\n Exemple: Ressusciter, Soigner",
                    }, 
                    M = {},
                },
                { -- AoE
                    E = "Checkbox", 
                    DB = "AoE",
                    DBV = true,
                    L = { 
                        enUS = "Use AoE", 
                        ruRU = "Использовать AoE", 
                        frFR = "Utiliser l'AoE",
                    }, 
                    TT = { 
                        enUS = "Enable multiunits actions", 
                        ruRU = "Включает действия для нескольких целей", 
                        frFR = "Activer les actions multi-unités",
                    }, 
                    M = {
					    Custom = "/run Action.AoEToggleMode()",
						-- It does call func CraftMacro(L[CL], macro above, 1) -- 1 means perCharacter tab in MacroUI, if nil then will be used allCharacters tab in MacroUI
						Value = value or nil, 
						-- Very Very Optional, no idea why it will be need however.. 
						TabN = '@number' or nil,								
						Print = '@string' or nil,
					},
                },
			},
			{
				{ -- Auto Multi Dot
                    E = "Checkbox", 
                    DB = "AutoMultiDot",
                    DBV = true,
                    L = { 
                        ANY = "Auto Multi DoT (BETA)"
                    }, 
                    TT = { 
                        ANY = "Switch through enemies to apply DoTs automatically! Limited to five total targets per combat."
                    }, 
                    M = {},
                },			
				{ -- ForceAoE
                    E = "Checkbox", 
                    DB = "ForceAoE",
                    DBV = true,
                    L = { 
                        ANY = "Force AoE Opener"
                    }, 
                    TT = { 
                        ANY = "Force Seed of Corruption as first spell if using Sow The Seeds talent - this is to help with AoE detection!"
                    }, 
                    M = {},
                },				
            }, 								
            { -- Spacer

                {
                    E = "LayoutSpace",                                                                        
                },
            },
            { -- Pet Stuff -- Header
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< PET STUFF ><><><l ",
                    },
                },
            },
            { -- Pet Stuff - Content
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = A.GetSpellInfo(688), value = "IMP" },
                        { text = A.GetSpellInfo(697), value = "VOIDWALKER" },                    
                        { text = A.GetSpellInfo(691), value = "FELHUNTER" },
                        { text = A.GetSpellInfo(712), value = "SUCCUBUS" },
                    },
                    DB = "PetChoice",
                    DBV = "IMP",
                    L = { 
                        enUS = "Pet Selection", 
                        ruRU = "Выбор питомца", 
                        frFR = "Sélection du familier",
                    }, 
                    TT = { 
                        enUS = "Choose the pet to summon", 
                        ruRU = "Выберите питомца для призыва", 
                        frFR = "Choisir le familier à invoquer",
					},
                    M = {},
                },
                { -- Health Funnel
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "HealthFunnelHP",
                    DBV = 10, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Health Funnel HP (%)",
                    }, 
                    TT = { 
                        ANY = "Will use Health Funnel when pet reaches percent HP. Won't use if own HP is critical."
					},					
                    M = {},
                },					
            }, 
            { -- Spacer
                {
                    E = "LayoutSpace",                                                                         
                },
            },			
			{ -- Defensives -- Header
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< DEFENSIVES ><><><l ",
                    },
                },
            },			
            { -- Defensives -- Content
                { -- UnendingResolve
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "UnendingResolve",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(104773) .. " HP (%)",
                    }, 
                    M = {},
                },
                { -- DrainLife
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "DrainLifeHP",
                    DBV = 10, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Drain Life HP (%)",
                    }, 
                    TT = { 
                        ANY = "Will use Drain Life at this percent HP."
					},					
                    M = {},
                },				
            },
            { -- Spacer

                {
                    E = "LayoutSpace",                                                                         
                },
            },
        },
        [ACTION_CONST_WARLOCK_DESTRUCTION] = {  
            { -- General -- Header
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< GENERAL ><><><l ",
                    },
                },
            },	
            { -- General -- Content
                { -- Mouseover
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
                    L = { 
                        enUS = "Use @mouseover", 
                        ruRU = "Использовать @mouseover", 
                        frFR = "Utiliser les fonctions @mouseover",
                    }, 
                    TT = { 
                        enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing", 
                        ruRU = "Разблокирует использование действий для @mouseover юнитов\nНапример: Воскрешение, Хилинг", 
                        frFR = "Activera les actions via @mouseover\n Exemple: Ressusciter, Soigner",
                    }, 
                    M = {},
                },
                { -- AoE
                    E = "Checkbox", 
                    DB = "AoE",
                    DBV = true,
                    L = { 
                        enUS = "Use AoE", 
                        ruRU = "Использовать AoE", 
                        frFR = "Utiliser l'AoE",
                    }, 
                    TT = { 
                        enUS = "Enable multiunits actions", 
                        ruRU = "Включает действия для нескольких целей", 
                        frFR = "Activer les actions multi-unités",
                    }, 
                    M = {
					    Custom = "/run Action.AoEToggleMode()",
						-- It does call func CraftMacro(L[CL], macro above, 1) -- 1 means perCharacter tab in MacroUI, if nil then will be used allCharacters tab in MacroUI
						Value = value or nil, 
						-- Very Very Optional, no idea why it will be need however.. 
						TabN = '@number' or nil,								
						Print = '@string' or nil,
					},
                },
				{ -- Auto Multi Dot
                    E = "Checkbox", 
                    DB = "AutoHavoc",
                    DBV = true,
                    L = { 
                        ANY = "Auto Havoc"
                    }, 
                    TT = { 
                        ANY = "Automatically switch targets when Havoc is used!"
                    }, 
                    M = {},
                },							
            }, 
            { -- Spacer

                {
                    E = "LayoutSpace",                                                                        
                },
            },
            { -- Pet Stuff -- Header
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< PET STUFF ><><><l ",
                    },
                },
            },
            { -- Pet Stuff - Content
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = A.GetSpellInfo(688), value = "IMP" },
                        { text = A.GetSpellInfo(697), value = "VOIDWALKER" },                    
                        { text = A.GetSpellInfo(691), value = "FELHUNTER" },
                        { text = A.GetSpellInfo(712), value = "SUCCUBUS" },
                    },
                    DB = "PetChoice",
                    DBV = "IMP",
                    L = { 
                        enUS = "Pet Selection", 
                        ruRU = "Выбор питомца", 
                        frFR = "Sélection du familier",
                    }, 
                    TT = { 
                        enUS = "Choose the pet to summon", 
                        ruRU = "Выберите питомца для призыва", 
                        frFR = "Choisir le familier à invoquer",
					},
                    M = {},
                },
                { -- Health Funnel
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "HealthFunnelHP",
                    DBV = 10, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Health Funnel HP (%)",
                    }, 
                    TT = { 
                        ANY = "Will use Health Funnel when pet reaches percent HP. Won't use if own HP is critical."
					},					
                    M = {},
                },					
            }, 				
            { -- LayoutSpace

                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { --Defensives Header
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< DEFENSIVES ><><><l ",
                    },
                },
            },			
            { -- Unending Resolve Slider
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "UnendingResolve",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(104773) .. " HP (%)",
                    }, 
                    M = {},
                },
            },
            { -- Healing Potion Slider
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "SpectralHealingPotionHP",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Spectral Healing Potion HP (%)",
                    }, 
                    M = {},
                },
			},
		},
		{
            { -- Mortal Coil HP
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "MortalCoilHP",
                    DBV = 30, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(6789) .. " HP(%)",
                    }, 
                    M = {},
                },
			},
            { -- DrainLife HP
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "DrainLifeHP",
                    DBV = 10, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Drain Life HP(%)",
                    }, 
                    M = {},
                },
			},				
        },
        [ACTION_CONST_WARLOCK_DEMONOLOGY] = {  
            { -- General -- Header
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< GENERAL ><><><l ",
                    },
                },
            },		
            { -- General -- Content
                { -- Mouseover
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
                    L = { 
                        enUS = "Use @mouseover", 
                        ruRU = "Использовать @mouseover", 
                        frFR = "Utiliser les fonctions @mouseover",
                    }, 
                    TT = { 
                        enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing", 
                        ruRU = "Разблокирует использование действий для @mouseover юнитов\nНапример: Воскрешение, Хилинг", 
                        frFR = "Activera les actions via @mouseover\n Exemple: Ressusciter, Soigner",
                    }, 
                    M = {},
                },
                { -- AoE
                    E = "Checkbox", 
                    DB = "AoE",
                    DBV = true,
                    L = { 
                        enUS = "Use AoE", 
                        ruRU = "Использовать AoE", 
                        frFR = "Utiliser l'AoE",
                    }, 
                    TT = { 
                        enUS = "Enable multiunits actions", 
                        ruRU = "Включает действия для нескольких целей", 
                        frFR = "Activer les actions multi-unités",
                    }, 
                    M = {
					    Custom = "/run Action.AoEToggleMode()",
						-- It does call func CraftMacro(L[CL], macro above, 1) -- 1 means perCharacter tab in MacroUI, if nil then will be used allCharacters tab in MacroUI
						Value = value or nil, 
						-- Very Very Optional, no idea why it will be need however.. 
						TabN = '@number' or nil,								
						Print = '@string' or nil,
					},
                },
			},
            { -- Layout Space
                {
                    E = "LayoutSpace",                                                                         
                },
            }, 
			{ -- Defensives -- Header
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< DEFENSIVES ><><><l ",
                    },
                },
            },			
            { -- Defensives -- Content
                { -- UnendingResolve
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "UnendingResolve",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(104773) .. " HP (%)",
                    }, 
                    M = {},
                },
                { -- DrainLife
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "DrainLifeHP",
                    DBV = 10, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Drain Life HP (%)",
                    }, 
                    TT = { 
                        ANY = "Will use Drain Life at this percent HP."
					},					
                    M = {},
                },				
            },
			{
                { -- Health Funnel
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "HealthFunnelHP",
                    DBV = 10, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Health Funnel HP (%)",
                    }, 
                    TT = { 
                        ANY = "Will use Health Funnel when pet reaches percent HP. Won't use if own HP is critical."
					},					
                    M = {},
                },
			},
		},
    },
    -- MSG Actions UI
    [7] = {
        [ACTION_CONST_WARLOCK_AFFLICTION] = { 
            ["dispel"] = { Enabled = true, Key = "SingeMagic", LUAVER = 5, LUA = [[
                return     DispelIsReady(thisunit, true, true)
            ]] },
            ["reflect"] = { Enabled = true, Key = "NetherWard", LUAVER = 5, LUA = [[
                return     ReflectIsReady(thisunit, true, true)
            ]] },
        },
        [ACTION_CONST_WARLOCK_DESTRUCTION] = { 
            ["dispel"] = { Enabled = true, Key = "SingeMagic", LUAVER = 5, LUA = [[
                return     DispelIsReady(thisunit, true, true)
            ]] },
            ["reflect"] = { Enabled = true, Key = "NetherWard", LUAVER = 5, LUA = [[
                return     ReflectIsReady(thisunit, true, true)
            ]] },

        },
        [ACTION_CONST_WARLOCK_DEMONOLOGY] = { 
            ["dispel"] = { Enabled = true, Key = "SingeMagic", LUAVER = 5, LUA = [[
                return     DispelIsReady(thisunit, true, true)
            ]] },
            ["reflect"] = { Enabled = true, Key = "NetherWard", LUAVER = 5, LUA = [[
                return     ReflectIsReady(thisunit, true, true)
            ]] },

        },
    },
}


-----------------------------------------
--                   PvP  
-----------------------------------------
-- SingeMagic
function A.DispelIsReady(unit, isMsg, skipShouldStop)
	if Unit(unit):IsPlayer() then 
        if not isMsg then		
            return not Unit(unit):IsEnemy() and not Unit(unit):InLOS() and A[A.PlayerSpec].SingeMagic:IsReady(unit, nil, nil, true) and A.AuraIsValid(unit, "UseDispel", "Dispel")
		else
		    -- Notification			
			-- Mate in raid need to create a macro with their Index by doing this in game : /script print(UnitInRaid("player"))	
            -- 	
            A.SendNotification("Dispel requested by : " .. UnitName(unit), 119905)
		    return A[A.PlayerSpec].SingeMagic:IsReadyM(unit) 
		end
    end 
end 

-- NetherWard spell Reflect
function A.ReflectIsReady(unit, isMsg, skipShouldStop)
    if A[A.PlayerSpec].NetherWard then 
        local unitID = A.GetToggle(2, "ReflectPvPunits")
        return     (
            (unit == "arena1" and unitID[1]) or 
            (unit == "arena2" and unitID[2]) or
            (unit == "arena3" and unitID[3]) or
            (not unit:match("arena") and unitID[4]) 
        ) and 
        A.IsInPvP and
        Unit(unit):IsEnemy() and  
        (
            (
                not isMsg and 
                A.GetToggle(2, "ReflectPvP") ~= "OFF" and 
                A[A.PlayerSpec].NetherWard:IsReady(unit, nil, nil, skipShouldStop) and
                (
                    A.GetToggle(2, "ReflectPvP") == "ON COOLDOWN" or 
                    (A.GetToggle(2, "ReflectPvP") == "DANGEROUS CAST" and EnemyTeam():IsCastingBreakAble(0.25))
                )
            ) or 
            (
                isMsg and 
                A[A.PlayerSpec].NetherWard:IsReadyM(unit)                     
            )
        ) and 
        Unit(unit):IsPlayer()
    end 
end 

function A.Main_CastBars(unit, list)
    if not A.IsInitialized or A.IamHealer or (A.Zone ~= "arena" and A.Zone ~= "pvp") then 
        return false 
    end 
    
    if A[A.PlayerSpec] and A[A.PlayerSpec].PetKick and A[A.PlayerSpec].PetKick:IsReadyP(unit, nil, true) and A[A.PlayerSpec].PetKick:AbsentImun(unit, {"KickImun", "TotalImun", "TotalAndMag"}, true) and A.InterruptIsValid(unit, list) then 
        return true         
    end 
end 

function A.Second_CastBars(unit)
    if not A.IsInitialized or (A.Zone ~= "arena" and A.Zone ~= "pvp")  then 
        return false 
    end 
    
    local Toggle = A.GetToggle(2, "FearPvP")    
    if Toggle and Toggle ~= "OFF" and A[A.PlayerSpec] and A[A.PlayerSpec].Fear and A[A.PlayerSpec].Fear:IsReadyP(unit, nil, true) and A[A.PlayerSpec].Fear:AbsentImun(unit, {"CCTotalImun", "TotalImun", "TotalAndMag"}, true) and Unit(unit):IsControlAble("disorient", 0) then 
        if Toggle == "BOTH" then 
            return select(2, A.InterruptIsValid(unit, "Heal", true)) or select(2, A.InterruptIsValid(unit, "PvP", true)) 
        else
            return select(2, A.InterruptIsValid(unit, Toggle, true))         
        end 
    end 
end 