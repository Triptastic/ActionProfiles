-------------------------------
-- Taste TMW Action Rotation --
-------------------------------
local _G, setmetatable							= _G, setmetatable
local A                         			    = _G.Action
local Listener									= Action.Listener
local Create									= Action.Create
local GetToggle									= Action.GetToggle
local SetToggle									= Action.SetToggle
local GetGCD									= Action.GetGCD
local GetCurrentGCD								= Action.GetCurrentGCD
local GetPing									= Action.GetPing
local ShouldStop								= Action.ShouldStop
local BurstIsON									= Action.BurstIsON
local AuraIsValid								= Action.AuraIsValid
local InterruptIsValid							= Action.InterruptIsValid
local FrameHasSpell								= Action.FrameHasSpell
local Azerite									= LibStub("AzeriteTraits")
local Utils										= Action.Utils
local TeamCache									= Action.TeamCache
local EnemyTeam									= Action.EnemyTeam
local FriendlyTeam								= Action.FriendlyTeam
local LoC										= Action.LossOfControl
local Player									= Action.Player 
local MultiUnits								= Action.MultiUnits
local UnitCooldown								= Action.UnitCooldown
local Unit										= Action.Unit 
local IsUnitEnemy								= Action.IsUnitEnemy
local IsUnitFriendly							= Action.IsUnitFriendly
local ActiveUnitPlates							= MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
local TR                                        = Action.TasteRotation
local pairs                                     = pairs
local Pet                                       = LibStub("PetLibrary")
local next, pairs, type, print                  = next, pairs, type, print
local wipe                                      = wipe 
local math_floor                                = math.floor
local math_ceil                                 = math.ceil
local tinsert                                   = table.insert 
local TMW                                       = TMW
local _G, setmetatable                          = _G, setmetatable
local select, unpack, table, pairs              = select, unpack, table, pairs 
local CombatLogGetCurrentEventInfo              = _G.CombatLogGetCurrentEventInfo
local UnitGUID, UnitIsUnit, UnitDamage, UnitAttackSpeed, UnitAttackPower = UnitGUID, UnitIsUnit, UnitDamage, UnitAttackSpeed, UnitAttackPower

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

Action[ACTION_CONST_DRUID_FERAL] = {
    -- Racial
    ArcaneTorrent                           = Create({ Type = "Spell", ID = 50613      }),
    BloodFury                               = Create({ Type = "Spell", ID = 20572       }),
    Fireblood                               = Create({ Type = "Spell", ID = 265221      }),
    AncestralCall                           = Create({ Type = "Spell", ID = 274738      }),
    Berserking                              = Create({ Type = "Spell", ID = 26297     }),
    ArcanePulse                             = Create({ Type = "Spell", ID = 260364     }),
    QuakingPalm                             = Create({ Type = "Spell", ID = 107079      }),
    Haymaker                                = Create({ Type = "Spell", ID = 287712      }), 
    WarStomp                                = Create({ Type = "Spell", ID = 20549      }),
    BullRush                                = Create({ Type = "Spell", ID = 255654      }),  
    GiftofNaaru                             = Create({ Type = "Spell", ID = 59544     }),
    Shadowmeld                              = Create({ Type = "Spell", ID = 58984     }), -- usable in Action Core 
    Stoneform                               = Create({ Type = "Spell", ID = 20594     }), 
    BagofTricks                             = Create({ Type = "Spell", ID = 312411     }),
    WilloftheForsaken                       = Create({ Type = "Spell", ID = 7744         }), -- not usable in APL but user can Queue it   
    EscapeArtist                            = Create({ Type = "Spell", ID = 20589     }), -- not usable in APL but user can Queue it
    EveryManforHimself                      = Create({ Type = "Spell", ID = 59752     }), -- not usable in APL but user can Queue it
    -- Generics
    Prowl                                   = Create({ Type = "Spell", ID = 5215     }),
    Berserk                                 = Create({ Type = "Spell", ID = 106951     }),
    Rake                                    = Create({ Type = "Spell", ID = 1822     }),
    ThrashCat                              	= Create({ Type = "Spell", ID = 106830     }),
    SwipeCat                                = Create({ Type = "Spell", ID = 106785     }),
    MoonfireCat                             = Create({ Type = "Spell", ID = 155625     }),
    Shred                                   = Create({ Type = "Spell", ID = 5221     }),
    Rip                                     = Create({ Type = "Spell", ID = 1079     }),
    TigersFury                              = Create({ Type = "Spell", ID = 5217     }),
    FerociousBiteMaxEnergy                  = Create({ Type = "Spell", ID = 22568, Hidden = true    }), -- Used to check special conditions on FerociousBite
    FerociousBite                           = Create({ Type = "Spell", ID = 22568    }),
    Maim                                    = Create({ Type = "Spell", ID = 22570     }),  
    Incarnation                             = Create({ Type = "Spell", ID = 102543 }),	
    SavageRoar                              = Create({ Type = "Spell", ID = 52610 }),
	WildFleshrending						= Create({ Type = "Spell", ID = 279527, Hidden = true     }),
    -- Shapeshift
    TravelForm                              = Create({ Type = "Spell", ID = 783      }), 
    BearForm                                = Create({ Type = "Spell", ID = 5487      }), 
    CatForm                                 = Create({ Type = "Spell", ID = 768      }), 
	CatFormBuff                             = Create({ Type = "Spell", ID = 768, Hidden = true     }),
    AquaticForm                             = Create({ Type = "Spell", ID = 276012      }), 
    -- Balance Affinity
    Moonfire                                = Create({ Type = "Spell", ID = 8921      }), 
	MoonfireDebuff                          = Create({ Type = "Spell", ID = 164812, Hidden = true     }),
	Sunfire                                 = Create({ Type = "Spell", ID = 197630      }), 
	SunfireDebuff                           = Create({ Type = "Spell", ID = 164815, Hidden = true     }),
	Wrath                             		= Create({ Type = "Spell", ID = 5176      }), 
	Starfire                             	= Create({ Type = "Spell", ID = 197628      }), 
	Starsurge                               = Create({ Type = "Spell", ID = 197626      }), 
	LunarEmpowermentBuff                    = Create({ Type = "Spell", ID = 164547, Hidden = true     }),
	SolarEmpowermentBuff                    = Create({ Type = "Spell", ID = 164545, Hidden = true     }),
    -- Utilities
    EntanglingRoots                         = Create({ Type = "Spell", ID = 339     }),
    SkullBash                               = Create({ Type = "Spell", ID = 106839     }),
    MightyBashGreen                         = Create({ Type = "SpellSingleColor", ID = 5211, Color = "GREEN", Desc = "[1] CC Focus", isTalent = true     }), 
    AntiFakeCCFocusCyclone                  = Create({ Type = "Spell", ID = 33786, }), 
    SkullBashGreen                          = Create({ Type = "SpellSingleColor", ID = 106839, Color = "GREEN", Desc = "[2] Kick", QueueForbidden = true     }),
    UrsolVortex                             = Create({ Type = "Spell", ID = 102793      }),
    NaturesCure                             = Create({ Type = "Spell", ID = 88423      }),  
    Dash                                    = Create({ Type = "Spell", ID = 1850      }), 
    Rebirth                                 = Create({ Type = "Spell", ID = 20484      }),  -- Combat Rez
    Revive                                  = Create({ Type = "Spell", ID = 50769      }), 
    Hibernate                               = Create({ Type = "Spell", ID = 2637      }), 
    Revitalize                              = Create({ Type = "Spell", ID = 212040      }), 
    Regrowth                                = Create({ Type = "Spell", ID = 8936     }),
    Soothe                                  = Create({ Type = "Spell", ID = 2908     }),
    RemoveCorruption                        = Create({ Type = "Spell", ID = 2782     }),
    SurvivalInstincts                       = Create({ Type = "Spell", ID = 61336     }),
	StampedingRoar                          = Create({ Type = "Spell", ID = 106898     }),
	WildChargeCat							= Create({ Type = "Spell", ID = 49376, Hidden = true     }),    -- Charge + 3sec Stun
	--WildChargeTravel                        = Create({ Type = "Spell", ID = 49376, Hidden = true     }),   
	WildChargeBear                          = Create({ Type = "Spell", ID = 16979, Hidden = true     }),	-- Charge + 4sec Stun	
    -- Buffs
    PredatorySwiftnessBuff                  = Create({ Type = "Spell", ID = 69369, Hidden = true     }),
    BloodtalonsBuff                         = Create({ Type = "Spell", ID = 145152, Hidden = true     }),
    ScentofBloodBuff                        = Create({ Type = "Spell", ID = 285646, Hidden = true     }),
    TigersFuryBuff                          = Create({ Type = "Spell", ID = 5217, Hidden = true     }),
    IncarnationBuff                         = Create({ Type = "Spell", ID = 102543, Hidden = true     }),
    BerserkBuff                             = Create({ Type = "Spell", ID = 106951, Hidden = true     }),
    ClearcastingBuff                        = Create({ Type = "Spell", ID = 135700, Hidden = true     }),
    ProwlBuff                               = Create({ Type = "Spell", ID = 5215, Hidden = true     }),
	ShadowmeldBuff                          = Create({ Type = "Spell", ID = 58984 , Hidden = true     }),
	SavageRoarBuff                          = Create({ Type = "Spell", ID = 52610 , Hidden = true     }),
	IronJawsBuff                            = Create({ Type = "Spell", ID = 276026, Hidden = true     }),
    -- Debuffs
    RakeDebuff                              = Create({ Type = "Spell", ID = 155722, Hidden = true     }), -- Duration Base//Max [155722] = {15000, 19500},
    ThrashCatDebuff                         = Create({ Type = "Spell", ID = 106830, Hidden = true     }),
    MoonfireCatDebuff                       = Create({ Type = "Spell", ID = 164812, Hidden = true     }),
    RipDebuff                               = Create({ Type = "Spell", ID = 1079, Hidden = true     }), -- Duration Base//Max [1079] = {4000, 5200},
    ConcentratedFlameDebuff                 = Create({ Type = "Spell", ID = 295368, Hidden = true     }),
    AshvanesRazorCoralDebuff                = Create({ Type = "Spell", ID = 303568, Hidden = true     }),
    ConductiveInkDebuff                     = Create({ Type = "Spell", ID = 302565, Hidden = true     }),
    BloodoftheEnemyDebuff                   = Create({ Type = "Spell", ID = 297108, Hidden = true     }),
    -- Potions
    PotionofUnbridledFury                  = Action.Create({ Type = "Potion", ID = 169299, QueueForbidden = true }), 
    BattlePotionOfAgility                  = Action.Create({ Type = "Potion", ID = 163223, QueueForbidden = true }),  
    SuperiorPotionofUnbridledFury          = Action.Create({ Type = "Potion", ID = 168489, QueueForbidden = true }), 
	SuperiorSteelskinPotion                = Action.Create({ Type = "Potion", ID = 168501, QueueForbidden = true }), 
	AbyssalHealingPotion                   = Action.Create({ Type = "Potion", ID = 169451, QueueForbidden = true }),     
	PotionofFocusedResolve                 = Action.Create({ Type = "Potion", ID = 168506 }),
	SuperiorBattlePotionofStrength         = Action.Create({ Type = "Potion", ID = 168500 }),
	PotionofEmpoweredProximity             = Action.Create({ Type = "Potion", ID = 168529 }),
    -- Trinkets
    AzsharasFontofPower                    = Action.Create({ Type = "Trinket", ID = 169314 }),
    PocketsizedComputationDevice           = Action.Create({ Type = "Trinket", ID = 167555 }),
    RotcrustedVoodooDoll                   = Action.Create({ Type = "Trinket", ID = 159624 }),
    ShiverVenomRelic                       = Action.Create({ Type = "Trinket", ID = 168905 }),
    AquipotentNautilus                     = Action.Create({ Type = "Trinket", ID = 169305 }),
    TidestormCodex                         = Action.Create({ Type = "Trinket", ID = 165576 }),
    VialofStorms                           = Action.Create({ Type = "Trinket", ID = 158224 }),
    GalecallersBoon                        = Action.Create({ Type = "Trinket", ID = 159614 }),
    InvocationOfYulon                      = Action.Create({ Type = "Trinket", ID = 165568 }),
    LustrousGoldenPlumage                  = Action.Create({ Type = "Trinket", ID = 159617 }),
    LurkersInsidiousGift                   = Action.Create({ Type = "Trinket", ID = 167866 }),
    VigorTrinket                           = Action.Create({ Type = "Trinket", ID = 165572 }),
    AshvanesRazorCoral                     = Action.Create({ Type = "Trinket", ID = 169311 }),
    MalformedHeraldsLegwraps               = Action.Create({ Type = "Trinket", ID = 167835 }),
    HyperthreadWristwraps                  = Action.Create({ Type = "Trinket", ID = 168989 }),
    NotoriousAspirantsBadge                = Action.Create({ Type = "Trinket", ID = 167528 }),
    NotoriousGladiatorsBadge               = Action.Create({ Type = "Trinket", ID = 167380 }),
    SinisterGladiatorsBadge                = Action.Create({ Type = "Trinket", ID = 165058 }),
    SinisterAspirantsBadge                 = Action.Create({ Type = "Trinket", ID = 165223 }),
    DreadGladiatorsBadge                   = Action.Create({ Type = "Trinket", ID = 161902 }),
    DreadAspirantsBadge                    = Action.Create({ Type = "Trinket", ID = 162966 }),
    DreadCombatantsInsignia                = Action.Create({ Type = "Trinket", ID = 161676 }),
    NotoriousAspirantsMedallion            = Action.Create({ Type = "Trinket", ID = 167525 }),
    NotoriousGladiatorsMedallion           = Action.Create({ Type = "Trinket", ID = 167377 }),
    SinisterGladiatorsMedallion            = Action.Create({ Type = "Trinket", ID = 165055 }),
    SinisterAspirantsMedallion             = Action.Create({ Type = "Trinket", ID = 165220 }),
    DreadGladiatorsMedallion               = Action.Create({ Type = "Trinket", ID = 161674 }),
    DreadAspirantsMedallion                = Action.Create({ Type = "Trinket", ID = 162897 }),
    DreadCombatantsMedallion               = Action.Create({ Type = "Trinket", ID = 161811 }),
    IgnitionMagesFuse                      = Action.Create({ Type = "Trinket", ID = 159615 }),
    TzanesBarkspines                       = Action.Create({ Type = "Trinket", ID = 161411 }),
    AzurethosSingedPlumage                = Action.Create({ Type = "Trinket", ID = 161377 }),
    AncientKnotofWisdomAlliance            = Action.Create({ Type = "Trinket", ID = 161417 }),
    AncientKnotofWisdomHorde               = Action.Create({ Type = "Trinket", ID = 166793 }),
    ShockbitersFang                        = Action.Create({ Type = "Trinket", ID = 169318 }),
    NeuralSynapseEnhancer                  = Action.Create({ Type = "Trinket", ID = 168973 }),
    BalefireBranch                         = Action.Create({ Type = "Trinket", ID = 159630 }),
	GrongsPrimalRage                       = Action.Create({ Type = "Trinket", ID = 165574 }),
	BygoneBeeAlmanac                       = Action.Create({ Type = "Trinket", ID = 163936 }),
	RampingAmplitudeGigavoltEngine         = Action.Create({ Type = "Trinket", ID = 165580 }),
	VisionofDemise                         = Action.Create({ Type = "Trinket", ID = 169307 }),
	JesHowler                              = Action.Create({ Type = "Trinket", ID = 159627 }),
	GalecallersBeak                        = Action.Create({ Type = "Trinket", ID = 161379 }),
    DribblingInkpod                        = Action.Create({ Type = "Trinket", ID = 169319 }),
    MerekthasFang                          = Action.Create({ Type = "Trinket", ID = 158367 }),	
	GrongsPrimalRage                       = Action.Create({ Type = "Trinket", ID = 165574 }),
	BygoneBeeAlmanac                       = Action.Create({ Type = "Trinket", ID = 163936 }),
	RampingAmplitudeGigavoltEngine         = Action.Create({ Type = "Trinket", ID = 165580 }),
	VisionofDemise                         = Action.Create({ Type = "Trinket", ID = 169307 }),
	JesHowler                              = Action.Create({ Type = "Trinket", ID = 159627 }),
	GalecallersBeak                        = Action.Create({ Type = "Trinket", ID = 161379 }),
    DribblingInkpod                        = Action.Create({ Type = "Trinket", ID = 169319 }),
    RazdunksBigRedButton                   = Action.Create({ Type = "Trinket", ID = 159611 }),
    MerekthasFang                          = Action.Create({ Type = "Trinket", ID = 158367 }),
    KnotofAncientFuryAlliance              = Action.Create({ Type = "Trinket", ID = 161413 }),
    KnotofAncientFuryHorde                 = Action.Create({ Type = "Trinket", ID = 166795 }),
    FirstMatesSpyglass                     = Action.Create({ Type = "Trinket", ID = 158163 }),
    VialofAnimatedBlood                    = Action.Create({ Type = "Trinket", ID = 159625 }),
    --Talents
	MassEntanglement                        = Create({ Type = "Spell", ID = 102359, isTalent = true, Hidden = true     }),
    Predator                                = Create({ Type = "Spell", ID = 202021, isTalent = true, Hidden = true     }),
    Sabertooth                              = Create({ Type = "Spell", ID = 202031, isTalent = true, Hidden = true     }),
    LunarInspiration                        = Create({ Type = "Spell", ID = 155580, isTalent = true, Hidden = true     }),
    WildCharge                              = Create({ Type = "Spell", ID = 102401, isTalent = true, Hidden = true     }),
    BalanceAffinity                         = Create({ Type = "Spell", ID = 197488, isTalent = true, Hidden = true     }),
    MightyBash                              = Create({ Type = "Spell", ID = 5211, isTalent = true, Hidden = true     }),
    Typhoon                                 = Create({ Type = "Spell", ID = 132469, isTalent = true, Hidden = true     }),
    ScentofBlood                            = Create({ Type = "Spell", ID = 285564, isTalent = true, Hidden = true     }),
    BrutalSlash                             = Create({ Type = "Spell", ID = 202028, isTalent = true, Hidden = true     }),
    PrimalWrath                             = Create({ Type = "Spell", ID = 285381, isTalent = true, Hidden = true     }),
    Bloodtalons                             = Create({ Type = "Spell", ID = 319439, isTalent = true, Hidden = true     }),
    FeralFrenzy                             = Create({ Type = "Spell", ID = 274837, isTalent = true, Hidden = true     }),
    Thorns                                  = Create({ Type = "Spell", ID = 236696, isTalent = true, Hidden = true     }), -- PvP
    -- Misc
    Channeling                             = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),	-- Show an icon during channeling
    TargetEnemy                            = Action.Create({ Type = "Spell", ID = 44603, Hidden = true     }),	-- Change Target (Tab button)
    StopCast                               = Action.Create({ Type = "Spell", ID = 61721, Hidden = true     }),		-- spell_magic_polymorphrabbit
    CyclotronicBlast                       = Action.Create({ Type = "Spell", ID = 293491, Hidden = true}),
    ConcentratedFlameBurn                  = Action.Create({ Type = "Spell", ID = 295368, Hidden = true}),
    RazorCoralDebuff                       = Action.Create({ Type = "Spell", ID = 303568, Hidden = true     }),
    ConductiveInkDebuff                    = Action.Create({ Type = "Spell", ID = 302565, Hidden = true     }),
    PoolResource                           = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),
    DummyTest                              = Action.Create({ Type = "Spell", ID = 159999, Hidden = true     }), -- Dummy stop dps icon   
    GrandDelusionsDebuff                   = Action.Create({ Type = "Spell", ID = 319695, Hidden = true     }), -- Corruption pet chasing you	
}

-- To create essences use next code:
Action:CreateEssencesFor(ACTION_CONST_DRUID_FERAL)  -- where PLAYERSPEC is Constance (example: ACTION_CONST_MONK_BM)
local A = setmetatable(Action[ACTION_CONST_DRUID_FERAL], { __index = Action })

------------------------------------------
---------------- VARIABLES ---------------
------------------------------------------
local VarUseThrash = 0
local VarReapingDelay = 0
local VarOpenerDone = 0
local LastRakeAP = 0

A.Listener:Add("ROTATION_VARS", "PLAYER_REGEN_ENABLED", function()
  VarUseThrash = 0
  VarReapingDelay = 0
  VarOpenerDone = 0
  LastRakeAP = 0
end)

local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end

------------------------------------------
-------------- COMMON PREAPL -------------
------------------------------------------
local Temp = {
    TotalAndPhys                            = {"TotalImun", "DamagePhysImun"},
    TotalAndCC                              = {"TotalImun", "CCTotalImun"},
    TotalAndPhysKick                        = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                       = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun                     = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun                = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMag                             = {"TotalImun", "DamageMagicImun"},
    TotalAndMagKick                         = {"TotalImun", "DamageMagicImun", "KickImun"},
    DisablePhys                             = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    DisableMag                              = {"TotalImun", "DamageMagicImun", "Freedom", "CCTotalImun"},
}

local IsIndoors, UnitIsUnit, UnitName = IsIndoors, UnitIsUnit, UnitName
local player = "player"

local function IsSchoolFree()
    return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "NATURE") == 0
end 

local function InMelee(unit)
    -- @return boolean 
    return A.Rake:IsInRange(unit)
end 

local function GetByRange(count, range, isCheckEqual, isCheckCombat)
    -- @return boolean 
    local c = 0 
    for unit in pairs(ActiveUnitPlates) do 
        if (not isCheckEqual or not UnitIsUnit(target, unit)) and (not isCheckCombat or Unit(unit):CombatTime() > 0) then 
            if InMelee(unit) then 
                c = c + 1
            elseif range then 
                local r = Unit(unit):GetRange()
                if r > 0 and r <= range then 
                    c = c + 1
                end 
            end 
            
            if c >= count then 
                return true 
            end 
        end 
    end
end 

-- Return the lowest Unit TTD value
-- Used as snipping function 
local function LowestTTD()
    local lowTTD = 0
    for activeunits in pairs(ActiveUnitPlates) do
        if (lowTTD == 0 or Unit(activeunits):TimeToDie() < lowTTD) then
            lowTTD = Unit(activeunits):TimeToDie()
        end
    end
    return lowTTD
end

local function SwipeBleedMult()
    return (Unit(unit):HasDeBuffs(A.RipDebuff.ID, true) > 0 or Unit(unit):HasDeBuffs(A.RakeDebuff.ID, true) > 0 or Unit(unit):HasDeBuffs(A.ThrashCatDebuff.ID, true) > 0) and 1.2 or 1
end

local function RakeBleedTick()
    return LastRakeAP * 0.15561 * (1 + Player:VersatilityDmgPct() / 100)
end

-- [1] CC AntiFake Rotation
local function AntiFakeStun(unit) 
    return A.IsUnitEnemy(unit)    
end 
A[1] = function(icon)    

	-- Cyclone
    if     A.AntiFakeCCFocusCyclone:IsReady(nil, nil, nil, true) and Unit("target"):GetRange() <= 20 and 
    (
        AntiFakeStun("mouseover") 
		or 
        AntiFakeStun("target") 
    )
    then 
        return A.AntiFakeCCFocusCyclone:Show(icon)         
    end 
	
	-- MightyBash
    if     A.MightyBashGreen:IsReady(nil, nil, nil, true) and Unit("target"):GetRange() <= 8 and 
    (
        AntiFakeStun("mouseover") 
		or 
        AntiFakeStun("target") 
    )
    then 
        return A.MightyBashGreen:Show(icon)         
    end 	                                                                  
end

-- [2] Kick AntiFake Rotation
A[2] = function(icon)        
    local unit
    if A.IsUnitEnemy("mouseover") then 
        unit = "mouseover"
    elseif A.IsUnitEnemy("target") then 
        unit = "target"
    end 
    
    if unit then         
        local castLeft, _, _, _, notKickAble = Unit(unit):IsCastingRemains()
        if castLeft > 0 then             
            if not notKickAble and A.SkullBashGreen:IsReady(unit, nil, nil, true) and A.SkullBashGreen:AbsentImun(unit, Temp.TotalAndMag, true) then
                return A.SkullBashGreen:Show(icon)                                                  
            end 
            
            -- Racials 
            if A.QuakingPalm:IsRacialReadyP(unit, nil, nil, true) then 
                return A.QuakingPalm:Show(icon)
            end 
            
            if A.Haymaker:IsRacialReadyP(unit, nil, nil, true) then 
                return A.Haymaker:Show(icon)
            end 
            
            if A.WarStomp:IsRacialReadyP(unit, nil, nil, true) then 
                return A.WarStomp:Show(icon)
            end 
            
            if A.BullRush:IsRacialReadyP(unit, nil, nil, true) then 
                return A.BullRush:Show(icon)
            end                         
        end 
    end                                                                                 
end

local function SelfDefensives()
    if Unit(player):CombatTime() == 0 then 
        return 
    end 
    
    local unit
    if A.IsUnitEnemy("mouseover") then 
        unit = "mouseover"
    elseif A.IsUnitEnemy("target") then 
        unit = "target"
    end  
    
    -- SurvivalInstincts
    local SurvivalInstincts = A.GetToggle(2, "SurvivalInstincts")
    if     SurvivalInstincts >= 0 and A.SurvivalInstincts:IsReady("player", nil, nil, true) and
    (
        (     -- Auto 
            SurvivalInstincts >= 100 and 
            (
                Unit(player):HealthPercent() <= 50 or
                (                        
                    Unit(player):HealthPercent() < 70 
                )
            )
        ) 
        or 
        (    -- Custom
            SurvivalInstincts < 100 and 
            Unit(player):HealthPercent() <= SurvivalInstincts
        )
    ) 
    then 
        return A.SurvivalInstincts
    end 
 
    -- Bear Form
 --[[   local BearForm = A.GetToggle(2, "BearForm")
    if     BearForm >= 0 and not IsInBearForm and A.BearForm:IsReady("player") and
    (
        (     -- Auto 
            BearForm >= 100 and Unit(player):HealthPercent() < 20 and
            (
			    EnemyTeam():IsReshiftAble() 
				or 
				(Unit(player):HasDeBuffs(78675) > 0 and Unit(player):HasDeBuffs("Rooted") > 0)
			)
        ) 
        or 
        (    -- Custom
            BearForm < 100 and 
            Unit(player):HealthPercent() <= BearForm
        )
    ) 
    then 
        return A.BearForm
    end
 ]]--
    -- Stoneform on self dispel (only PvE)
    if A.Stoneform:IsRacialReady(player, true) and not A.IsInPvP and A.AuraIsValid(player, "UseDispel", "Dispel") then 
        return A.Stoneform
    end 
end 
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

-- Non GCD spell check
local function countInterruptGCD(unit)
    if not A.SkullBash:IsReadyByPassCastGCD(unit) or not A.SkullBash:AbsentImun(unit, Temp.TotalAndMagKick) then
	    return true
	end
end

-- Interrupts spells
local function Interrupts(unit)
    if A.GetToggle(2, "TasteInterruptList") and (IsInRaid() or A.InstanceInfo.KeyStone > 1) then
	    useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, "TasteBFAContent", true, countInterruptGCD(unit))
	else
        useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))
    end
    
	if castRemainsTime >= A.GetLatency() then
        if useKick and A.SkullBash:IsReady(unit) and A.SkullBash:AbsentImun(unit, Temp.TotalAndPhysKick, true) then 
            -- Notification                    
            Action.SendNotification("Skull Bash interrupting on " .. unit, A.SkullBash.ID)
            return A.SkullBash
        end         

        if useCC and A.MightyBash:IsReady(unit) and A.MightyBash:IsSpellLearned() and A.MightyBash:AbsentImun(unit, Temp.TotalAndPhysKick, true) then 
            -- Notification                    
            Action.SendNotification("Mighty Bash interrupting on " .. unit, A.MightyBash.ID)
            return A.MightyBash
        end  
		    
   	    if useRacial and A.QuakingPalm:AutoRacial(unit) then 
   	        return A.QuakingPalm
   	    end 
    
   	    if useRacial and A.Haymaker:AutoRacial(unit) then 
            return A.Haymaker
   	    end 
    
   	    if useRacial and A.WarStomp:AutoRacial(unit) then 
            return A.WarStomp
   	    end 
    
   	    if useRacial and A.BullRush:AutoRacial(unit) then 
            return A.BullRush
   	    end 
    end
end

-- Stealth Handler UI --
local function HandleStealth()
    local choice = GetToggle(2, "AutoStealthOOC")
    local unit = "target"
    return     (
        (IsInRaid() and choice[1]) or 
        (IsInGroup() and choice[2]) or
        (A.IsInPvP and choice[3]) or
		(A.Prowl:IsReady() and choice[4])
    )
end

A.FerociousBiteMaxEnergy.CustomCost = {
    [3] = function ()
        if (Unit(player):HasBuffs(A.IncarnationBuff.ID, true) > 0 or Unit(player):HasBuffs(A.BerserkBuff.ID, true) > 0) then 
		    return 25
        else 
		    return 50
        end
    end
}


local function IsInHumanForm()
    return Player:GetStance() == 0
end

local function IsInBearForm()
    return Player:GetStance() == 1
end

local function IsInCatForm()
    return Player:GetStance() == 2
end

local function IsInTravelForm()
    return Player:GetStance() == 3
end

local function IsInMoonkinForm()
    return Player:GetStance() == 4
end



-- [3] Single Rotation
A[3] = function(icon)
    --------------------
    --- ROTATION VAR ---
    --------------------
    local isMoving = A.Player:IsMoving()
	local isMovingFor = A.Player:IsMovingTime()
    local inCombat = Unit(player):CombatTime() > 0
    local combatTime = Unit(player):CombatTime()
    local ShouldStop = Action.ShouldStop()
    local Pull = Action.BossMods:GetPullTimer()
    local profileStop = false
    local Energy = Player:Energy()
    local EnergyRegen = Player:EnergyRegen()
    local EnergyPredicted = Player:EnergyPredicted()
    local EnergyDeficitPredicted = Player:EnergyDeficitPredicted()
    local DBM = Action.GetToggle(1, "BossMods")
    local HeartOfAzeroth = Action.GetToggle(1, "HeartOfAzeroth")
    local Racial = Action.GetToggle(1, "Racial")
    local Potion = Action.GetToggle(1, "Potion") 
    
    
    local IsInBearForm = IsInBearForm()
	local IsInCatForm = IsInCatForm()
	local IsInTravelForm = IsInTravelForm()
	local IsInMoonkinForm = IsInMoonkinForm()
	local IsInHumanForm = IsInHumanForm()
	local MassEntanglementThingFromBeyond = GetToggle(2, "MassEntanglementThingFromBeyond")
    local AoEMode = A.GetToggle(2, "AoEMode")        
    local BloodoftheEnemySyncAoE = Action.GetToggle(2, "BloodoftheEnemySyncAoE")
    local BloodoftheEnemyAoETTD = Action.GetToggle(2, "BloodoftheEnemyAoETTD")
    local BloodoftheEnemyUnits = Action.GetToggle(2, "BloodoftheEnemyUnits")
    local FocusedAzeriteBeamTTD = GetToggle(2, "FocusedAzeriteBeamTTD")
    local FocusedAzeriteBeamUnits = GetToggle(2, "FocusedAzeriteBeamUnits")
    local UnbridledFuryAuto = GetToggle(2, "UnbridledFuryAuto")
    local UnbridledFuryTTD = GetToggle(2, "UnbridledFuryTTD")
    local UnbridledFuryWithBloodlust = GetToggle(2, "UnbridledFuryWithBloodlust")
    local UnbridledFuryHP = GetToggle(2, "UnbridledFuryHP")
    local UnbridledFuryWithExecute = GetToggle(2, "UnbridledFuryWithExecute")
	local MoonfireOnlyOutOfRange = GetToggle(2, "MoonfireOnlyOutOfRange")
	local RootThingFromBeyond = GetToggle(2, "RootThingFromBeyond")
	local HandleStealth = HandleStealth()
	local OpenerRange = GetToggle(2, "OpenerRange")
	local UseWildChargeBear = GetToggle(2, "UseWildChargeBear")
	local UseWildChargeCat = GetToggle(2, "UseWildChargeCat")
	local AutoCatForm = GetToggle(2, "AutoCatForm")
    -- Trinkets vars
    local Trinket1IsAllowed, Trinket2IsAllowed = TR:TrinketIsAllowed()
    local TrinketsAoE = GetToggle(2, "TrinketsAoE")
	--local TrinketASAP = GetToggle(2, "TrinketASAP")
    local TrinketsMinTTD = GetToggle(2, "TrinketsMinTTD")
    local TrinketsUnitsRange = GetToggle(2, "TrinketsUnitsRange")
    local TrinketsMinUnits = GetToggle(2, "TrinketsMinUnits")    
    -- Azerite beam protection channel
    local CanCast = true
    local TotalCast, CurrentCastLeft, CurrentCastDone = Unit(player):CastTime()
    local _, castStartedTime, castEndTime = Unit(player):IsCasting()
    local secondsLeft, percentLeft, spellID, spellName, notInterruptable, isChannel = Unit(player):IsCastingRemains()
    -- Ensure all channel and cast are really safe
    -- Double protection with check on current casts and also timestamp of the cast
    if (spellID == A.FocusedAzeriteBeam.ID) then 
        if (CurrentCastLeft > 0 or secondsLeft > 0 or isChannel) then
            if TMW.time < castEndTime then            
                CanCast = false
            else
                CanCast = true
            end
        end
    end
    -- Showing icon PoolResource to make sure nothing else is read by GG
    if not CanCast then
        return A.PoolResource:Show(icon)
    end
	
	VarNoBT = (A.Rake:GetSpellTimeSinceLastCast() > 4 and A.MoonfireCat:GetSpellTimeSinceLastCast() > 4 and A.ThrashCat:GetSpellTimeSinceLastCast() > 4 and A.BrutalSlash:GetSpellTimeSinceLastCast() > 4 and A.SwipeCat:GetSpellTimeSinceLastCast() > 4 and A.Shred:GetSpellTimeSinceLastCast() > 4)

	
local function EnemyRotation(unit)

--[[###############################
	###### BLOODTALONS LOGIC ######
	###############################]]

local function BloodtalonsRotation(unit)


	--actions.bloodtalons=rake,target_if=(!ticking|(refreshable&persistent_multiplier>dot.rake.pmultiplier))&buff.bt_rake.down&druid.rake.ticks_gained_on_refresh>=2
	if A.Rake:IsReady(unit) and (Unit("target"):HasDeBuffs(A.RakeDebuff.ID, true) < 4 or Unit("target"):HasDeBuffs(A.RakeDebuff.ID, true) == 0) and A.Rake:GetSpellTimeSinceLastCast() > 4 then
	return
		A.Rake:Show(icon)
	end	
	
	--actions.bloodtalons+=/lunar_inspiration,target_if=refreshable&buff.bt_moonfire.down
	if A.MoonfireCat:IsReady(unit) and A.LunarInspiration:IsSpellLearned() and (Unit("target"):HasDeBuffs(A.MoonfireCatDebuff.ID, true < 4) or Unit("target"):HasDeBuffs(A.MoonfireCatDebuff.ID, true) == 0) and A.MoonfireCat:GetSpellTimeSinceLastCast() > 4 then
	return
		A.MoonfireCat:Show(icon)
	end
	
	--actions.bloodtalons+=/thrash_cat,target_if=refreshable&buff.bt_thrash.down&druid.thrash_cat.ticks_gained_on_refresh>8
	if A.ThrashCat:IsReady(unit) and (Unit("target"):HasDeBuffs(A.ThrashCat.ID, true) < 4 or Unit("target"):HasDeBuffs(A.ThrashCatDebuff.ID, true) == 0) and A.ThrashCat:GetSpellTimeSinceLastCast() > 4 then
	return
		A.ThrashCat:Show(icon)
	end	 
	
	--actions.bloodtalons+=/brutal_slash,if=buff.bt_brutal_slash.down
	if A.BrutalSlash:IsReady(unit) and A.BrutalSlash:GetSpellTimeSinceLastCast() > 4 then
	return
		A.BrutalSlash:Show(icon)
	end
	
	--actions.bloodtalons+=/swipe_cat,if=buff.bt_swipe.down&spell_targets.swipe_cat>1
	if A.SwipeCat:IsReady(unit) and (GetByRange(8, 2) or (A.BalanceAffinity:IsSpellLearned() and GetByRange(11, 2))) and A.SwipeCat:GetSpellTimeSinceLastCast() > 4 then
	return
		A.SwipeCat:Show(icon)
	end
	
	--actions.bloodtalons+=/shred,if=buff.bt_shred.down
	if A.Shred:IsReady(unit) and A.Shred:GetSpellTimeSinceLastCast() > 4 then
	return
		A.Shred:Show(icon)
	end	
	
	--actions.bloodtalons+=/swipe_cat,if=buff.bt_swipe.down
	if A.SwipeCat:IsReady(unit) and A.SwipeCat:GetSpellTimeSinceLastCast() > 4 then
	return
		A.SwipeCat:Show(icon)
	end
	
	--actions.bloodtalons+=/thrash_cat,if=buff.bt_thrash.down
	if A.ThrashCat:IsReady(unit) and A.ThrashCat:GetSpellTimeSinceLastCast() > 4 then
	return
		A.ThrashCat:Show(icon)
	end

end	

--[[###############################
	######     COOLDOWNS     ######
	###############################]]
    
local function Cooldowns(unit)

	--actions.cooldown=berserk
	if A.Berserk:IsReady(unit) then
	return
		A.Berserk:Show(icon)
	end
	
	--actions.cooldown+=/incarnation
	if A.Incarnation:IsReady(unit) then
	return
		A.Incarnation:Show(icon)
	end
	
	--actions.cooldown+=/tigers_fury,if=energy.deficit>55|(buff.bs_inc.up&buff.bs_inc.remains<13)
			--Try and not waste TF energy, but also just use it for zerk and incarns
	if A.TigersFury:IsReady(unit) and (Player:EnergyDeficit() > 55 or (Unit(player):HasBuffs(A.BerserkBuff.ID, true) < 13 or Unit(player):HasBuffs(A.IncarnationBuff.ID, true) < 13)) then
	return
		A.TigersFury:Show(icon)
	end 
	
	--actions.cooldown+=/shadowmeld,if=buff.tigers_fury.up&buff.bs_inc.down&combo_points<4&dot.rake.pmultiplier<1.6&energy>40
			--Might be wrong to use Smeld on Rake in very very niche situations, but very rarely
			

	--actions.cooldown+=/berserking,if=buff.tigers_fury.up|buff.bs_inc.up
	if A.Berserking:IsReady(unit) and (Unit(player):HasBuffs(A.TigersFuryBuff.ID, true) > 0 or (Unit(player):HasBuffs(A.BerserkBuff.ID, true) > 0 or Unit(player):HasBuffs(A.IncarnationBuff.ID, true) > 0)) then
	return
		A.Berserking:Show(icon)
	end
	
	
	--actions.cooldown+=/potion,if=buff.bs_inc.up
	
	--actions.cooldown+=/call_action_list,name=essence
	
	--actions.cooldown+=/use_items,if=buff.tigers_fury.up|target.time_to_die<20
	    	-- Non SIMC Custom Trinket1
	        if A.Trinket1:IsReady(unit) and Trinket1IsAllowed and CanCast and    
			(
    			TrinketsAoE and GetByRange(TrinketsMinUnits, TrinketsUnitsRange) and Player:AreaTTD(TrinketsUnitsRange) > TrinketsMinTTD
				or
				not TrinketsAoE and Unit(unit):TimeToDie() >= TrinketsMinTTD 					
			)
			then 
      	        return A.Trinket1:Show(icon)
   	        end 		
	        
		
		    -- Non SIMC Custom Trinket2
	        if A.Trinket2:IsReady(unit) and Trinket2IsAllowed and CanCast and	    
			(
    			TrinketsAoE and GetByRange(TrinketsMinUnits, TrinketsUnitsRange) and Player:AreaTTD(TrinketsUnitsRange) > TrinketsMinTTD
				or
				not TrinketsAoE and Unit(unit):TimeToDie() >= TrinketsMinTTD 					
			)
			then
      	       	return A.Trinket2:Show(icon) 	
	        end
end

--[[###############################
	######      FILLER       ######
	###############################]]

local function Filler(unit)

	--actions.filler=rake,target_if=variable.filler=1&dot.rake.pmultiplier<=persistent_multiplier
	if A.Rake:IsReady(unit) and (Unit("target"):HasDeBuffs(A.RakeDebuff.ID, true) < 4 or Unit("target"):HasDeBuffs(A.RakeDebuff.ID, true) == 0) then
	return
		A.Rake:Show(icon)
	end
	
	--actions.filler+=/rake,if=variable.filler=2
	
	
	--actions.filler+=/lunar_inspiration,if=variable.filler=3
	if A.MoonfireCat:IsReady(unit) and A.LunarInspiration:IsSpellLearned() and (Unit("target"):HasDeBuffs(A.MoonfireCatDebuff.ID, true < 4) or Unit("target"):HasDeBuffs(A.MoonfireCatDebuff.ID, true) == 0) then
	return
		A.Moonfire:Show(icon)
	end
	
	--actions.filler+=/swipe,if=variable.filler=4
	if A.SwipeCat:IsReady(unit) and (GetByRange(8, 2) or (A.BalanceAffinity:IsSpellLearned() and GetByRange(11, 2))) then
	return
		A.SwipeCat:Show(icon)
	end
	--actions.filler+=/shred
	if A.Shred:IsReady(unit) then
	return
		A.Shred:Show(icon)
	end

end

--[[###############################
	######     FINISHER      ######
	###############################]]
	
local function Finisher(unit)

	--actions.finisher=savage_roar,if=buff.savage_roar.down|buff.savage_roar.remains<(combo_points*5+1)*0.3
	if A.SavageRoar:IsReady(unit) and (Unit(player):HasBuffs(A.SavageRoarBuff.ID, true) == 0 or Unit(player):HasBuffs(A.SavageRoarBuff.ID, true) < (((Player:ComboPoints() * 5) + 1) * 0.3)) then
	return
		A.SavageRoar:Show(icon)
	end

	--actions.finisher+=/primal_wrath,if=druid.primal_wrath.ticks_gained_on_refresh>(variable.rip_ticks>?variable.best_rip)|spell_targets.primal_wrath>(3+1*talent.sabertooth.enabled)
	if A.PrimalWrath:IsReady(unit) and (GetByRange(3, 8) or (GetByRange(3, 11) and A.BalanceAffinity:IsSpellLearned())) and (Unit("target"):HasDeBuffs(A.RipDebuff.ID, true) == 0 or Unit("target"):HasDeBuffs(A.RipDebuff.ID, true) < 3) then
	return
		A.PrimalWrath:Show(icon)
	end
	
	--actions.finisher+=/rip,target_if=(!ticking|(remains+combo_points*talent.sabertooth.enabled)<duration*0.3|dot.rip.pmultiplier<persistent_multiplier)&druid.rip.ticks_gained_on_refresh>variable.rip_ticks
	if A.Rip:IsReady(unit) and (Unit("target"):HasDeBuffs(A.RipDebuff.ID, true) == 0 or Unit("target"):HasDeBuffs(A.RipDebuff.ID, true) < 3) then
	return
		A.Rip:Show(icon)
	end
	
	--actions.finisher+=/maim,if=buff.iron_jaws.up
	if A.Maim:IsReady(unit) and Unit(player):HasBuffs(A.IronJawsBuff.ID, true) > 0 then 
	return
		A.Maim:Show(icon)
	end
	
	--actions.finisher+=/ferocious_bite,max_energy=1,target_if=max:time_to_die
	if A.FerociousBite:IsReady(unit) then
	return
		A.FerociousBite:Show(icon)
	end

end


--local function StealthRotation

--actions.stealth=run_action_list,name=bloodtalons,if=talent.bloodtalons.enabled&buff.bloodtalons.down
--actions.stealth+=/rake,target_if=dot.rake.pmultiplier<1.6&druid.rake.ticks_gained_on_refresh>2
--actions.stealth+=/shred


--end
--[[###############################
	######BEGIN ACTION CALLS ######
	###############################]]

	--actions=cat_form,if=buff.cat_form.down
	if A.CatForm:IsReady(player) and Unit(player):HasBuffs(A.CatForm.ID, true) == 0 and AutoCatForm then
	return
		A.CatForm:Show(icon)
	end
	
	--actions+=/prowl
	if A.Prowl:IsReady(player) and not inCombat and Unit(player):HasBuffs(A.Prowl.ID, true) == 0 then
	return
		A.Prowl:Show(icon)
	end

	--actions.precombat+=/variable,name=filler,value=1
	if A.Rake:IsReady(player) and not inCombat then
	return
		A.Rake:Show(icon)
	end

	--actions+=/call_action_list,name=cooldown
    if BurstIsON(unit) and inCombat then
        return Cooldowns()
    end	
	
	--actions+=/run_action_list,name=finisher,if=combo_points>=(5-variable.4cp_bite)
	if Player:ComboPoints() >= 5 and Unit(player):HasBuffs(A.Prowl.ID, true) == 0 then
		return Finisher()
	end

--actions+=/run_action_list,name=stealth,if=buff.bs_inc.up|buff.sudden_ambush.up

--actions+=/pool_resource,if=talent.bloodtalons.enabled&buff.bloodtalons.down&(energy+3.5*energy.regen+(40*buff.clearcasting.up))>=(115-23*buff.incarnation_king_of_the_jungle.up)&active_bt_triggers=0
	if A.Bloodtalons:IsSpellLearned() and Unit(player):HasBuffs(A.BloodtalonsBuff.ID, true) == 0 and Player:EnergyDeficitPredicted() >= 20 and VarNoBT then
		return A.PoolResource:Show(icon)
	end

--actions+=/run_action_list,name=bloodtalons,if=talent.bloodtalons.enabled&(buff.bloodtalons.down|active_bt_triggers=2)
	if A.Bloodtalons:IsSpellLearned() and (Unit(player):HasBuffs(A.BloodtalonsBuff.ID, true) == 0) then
		return BloodtalonsRotation()
	end
	
--actions+=/rake,target_if=refreshable|persistent_multiplier>dot.rake.pmultiplier
	if A.Rake:IsReady() and (Unit("target"):HasDeBuffs(A.Rake.ID, true) <= 3 or Unit("target"):HasDeBuffs(A.Rake.ID, true) == 0) then
		return A.Rake:Show(icon)
	end

--actions+=/feral_frenzy,if=combo_points=0
	if A.FeralFrenzy:IsReady() and Player:ComboPoints() == 0 then
		return A.FeralFrenzy:Show(icon)
	end

--actions+=/moonfire_cat,target_if=refreshable
	if A.MoonfireCat:IsReady() and A.LunarInspiration:IsSpellLearned() and (Unit("target"):HasDeBuffs(A.MoonfireCatDebuff.ID, true) <= 3 or Unit("target"):HasDeBuffs(A.MoonfireCatDebuff.ID, true) == 0) then
		return A.Moonfire:Show(icon)
	end

--actions+=/thrash_cat,if=refreshable&druid.thrash_cat.ticks_gained_on_refresh>variable.thrash_ticks
	if A.ThrashCat:IsReady() and (Unit("target"):HasDeBuffs(A.ThrashCatDebuff.ID, true) <= 3 or Unit("target"):HasDeBuffs(A.ThrashCatDebuff.ID, true) == 0) then
		return A.ThrashCat:Show(icon)
	end

--actions+=/brutal_slash,if=(buff.tigers_fury.up&(raid_event.adds.in>(1+max_charges-charges_fractional)*recharge_time))&(spell_targets.brutal_slash*action.brutal_slash.damage%action.brutal_slash.cost)>(action.shred.damage%action.shred.cost)

--actions+=/swipe_cat,if=spell_targets.swipe_cat>2
	if A.SwipeCat:IsReady() and (GetByRange(2, 8) or (GetByRange(2, 11) and A.BalanceAffinity:IsSpellLearned())) then
		return A.SwipeCat:Show(icon)
	end
	
--actions+=/shred,if=buff.clearcasting.up
	if A.Shred:IsReady() and Unit(player):HasBuffs(A.ClearcastingBuff.ID, true) > 0 then
		return A.Shred:Show(icon)
	end
	
--actions+=/call_action_list,name=filler
	if inCombat and IsUnitEnemy("target") then
		return Filler()
	end

end
    EnemyRotation = A.MakeFunctionCachedDynamic(EnemyRotation)     

	
    -- Defensive
    local SelfDefensive = SelfDefensives()
    if SelfDefensive then 
        return SelfDefensive:Show(icon)
    end 

    -- Mouseover
    if A.IsUnitEnemy("mouseover") then
        unit = "mouseover"
        if EnemyRotation(unit) then 
            return true 
        end 
    end 

    -- Target  
    if A.IsUnitEnemy("target") then 
        unit = "target"
        if EnemyRotation(unit) then 
            return true
        end 

    end
end

-- [4] AoE Rotation
A[4] = function(icon)
    return A[3](icon, true)
end 

local function ArenaRotation(icon, unit)
    if A.IsInPvP and (A.Zone == "pvp" or A.Zone == "arena") and not Player:IsStealthed() and not Player:IsMounted() then     
        -- Interrupt
   	    local Interrupt = Interrupts(unit)
  	    if Interrupt and inCombat then 
  	        return Interrupt:Show(icon)
  	    end	
    end
end

local function PartyRotation(unit) 
    -- RemoveCorruption dispell Curse and Poison
    if A.RemoveCorruption:IsReady(unit) and (Unit(unit):HasDeBuffs("Poison") > 0 or Unit(unit):HasDeBuffs("Curse") > 0) and not Unit(unit):InLOS() then                         
        return A.RemoveCorruption
    end         
end 

A[6] = function(icon)
    return ArenaRotation(icon, "arena1")
end

A[7] = function(icon)
    local Party = PartyRotation("party1") 
    if Party then 
        return Party:Show(icon)
    end 
    return ArenaRotation(icon, "arena2")
end

A[8] = function(icon)
    local Party = PartyRotation("party2") 
    if Party then 
        return Party:Show(icon)
    end     
    return ArenaRotation(icon, "arena3")
end
