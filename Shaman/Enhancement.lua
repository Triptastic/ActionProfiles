--#####################################
--##### TRIP'S ENHANCEMENT SHAMAN #####
--#####################################

--Full credit to Taste

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

--Toaster stuff
local Toaster																	= _G.Toaster
local GetSpellTexture 															= _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

-- Spells
Action[ACTION_CONST_SHAMAN_ENCHANCEMENT] = {
    -- Racial
    ArcaneTorrent                          = Create({ Type = "Spell", ID = 50613     }),
    BloodFury                              = Create({ Type = "Spell", ID = 20572      }),
    Fireblood                              = Create({ Type = "Spell", ID = 265221     }),
    AncestralCall                          = Create({ Type = "Spell", ID = 274738     }),
    Berserking                             = Create({ Type = "Spell", ID = 26297    }),
    ArcanePulse                            = Create({ Type = "Spell", ID = 260364    }),
    QuakingPalm                            = Create({ Type = "Spell", ID = 107079     }),
    Haymaker                               = Create({ Type = "Spell", ID = 287712     }), 
    WarStomp                               = Create({ Type = "Spell", ID = 20549     }),
    BullRush                               = Create({ Type = "Spell", ID = 255654     }),  
    GiftofNaaru                            = Create({ Type = "Spell", ID = 59544    }),
    Shadowmeld                             = Create({ Type = "Spell", ID = 58984    }), -- usable in Action Core 
    Stoneform                              = Create({ Type = "Spell", ID = 20594    }), 
    WilloftheForsaken                      = Create({ Type = "Spell", ID = 7744        }), -- not usable in APL but user can Queue it   
    EscapeArtist                           = Create({ Type = "Spell", ID = 20589    }), -- not usable in APL but user can Queue it
    EveryManforHimself                     = Create({ Type = "Spell", ID = 59752    }), -- not usable in APL but user can Queue it
    -- Generics
    LightningShield                        = Create({ Type = "Spell", ID = 192106 }),
    CrashLightning                         = Create({ Type = "Spell", ID = 187874 }),
    Rockbiter                              = Create({ Type = "Spell", ID = 193786 }),
    Landslide                              = Create({ Type = "Spell", ID = 197992 }),
    LandslideBuff                          = Create({ Type = "Spell", ID = 202004 , Hidden = true     }),
    Windstrike                             = Create({ Type = "Spell", ID = 115356 }),
    AscendanceBuff                         = Create({ Type = "Spell", ID = 114051 , Hidden = true     }),
    Ascendance                             = Create({ Type = "Spell", ID = 114051 }),
    FeralSpirit                            = Create({ Type = "Spell", ID = 51533  }),
    BloodoftheEnemyBuff                    = Create({ Type = "Spell", ID = 297108 , Hidden = true     }),
    MoltenWeaponBuff                       = Create({ Type = "Spell", ID = 224125 , Hidden = true     }),
    CracklingSurgeBuff                     = Create({ Type = "Spell", ID = 224127 , Hidden = true     }),
    IcyEdgeBuff                            = Create({ Type = "Spell", ID = 224126 , Hidden = true     }),
    EarthenSpikeDebuff                     = Create({ Type = "Spell", ID = 188089 , Hidden = true}),
    EarthenSpike                           = Create({ Type = "Spell", ID = 188089 }),
    Stormstrike                            = Create({ Type = "Spell", ID = 17364  }),
    LightningConduit                       = Create({ Type = "Spell", ID = 275388 }),
    LightningConduitDebuff                 = Create({ Type = "Spell", ID = 275391 , Hidden = true}),
    StormbringerBuff                       = Create({ Type = "Spell", ID = 201845 , Hidden = true     }),
    GatheringStormsBuff                    = Create({ Type = "Spell", ID = 198300 , Hidden = true     }),
    LightningBolt                          = Create({ Type = "Spell", ID = 188196 }),
    Overcharge                             = Create({ Type = "Spell", ID = 210727 }),
    Sundering                              = Create({ Type = "Spell", ID = 197214 }),
    Thundercharge                          = Create({ Type = "Spell", ID = 204366 }),
    BagofTricks                            = Create({ Type = "Spell", ID = 312411 }),
    ForcefulWinds                          = Create({ Type = "Spell", ID = 262647 }),
    Flametongue                            = Create({ Type = "Spell", ID = 193796 }),
    SearingAssault                         = Create({ Type = "Spell", ID = 192087 }),
    LavaLash                               = Create({ Type = "Spell", ID = 60103  }),
    PrimalPrimer                           = Create({ Type = "Spell", ID = 272992 }),
    HotHand                                = Create({ Type = "Spell", ID = 201900 }),
    HotHandBuff                            = Create({ Type = "Spell", ID = 215785 , Hidden = true     }),
    StrengthofEarthBuff                    = Create({ Type = "Spell", ID = 273465 , Hidden = true     }),
    CrashingStorm                          = Create({ Type = "Spell", ID = 192246 }),
    Frostbrand                             = Create({ Type = "Spell", ID = 196834 }),
    Hailstorm                              = Create({ Type = "Spell", ID = 334196 }),
    FrostbrandBuff                         = Create({ Type = "Spell", ID = 196834 , Hidden = true     }),
    PrimalPrimerDebuff                     = Create({ Type = "Spell", ID = 273006 , Hidden = true}),
    FlametongueBuff                        = Create({ Type = "Spell", ID = 194084 , Hidden = true     }),
    FuryofAir                              = Create({ Type = "Spell", ID = 197211 }),
    FuryofAirBuff                          = Create({ Type = "Spell", ID = 197211 , Hidden = true     }),
    TotemMastery                           = Create({ Type = "Spell", ID = 262395 }),
    ResonanceTotemBuff                     = Create({ Type = "Spell", ID = 262419 , Hidden = true     }),
    SunderingDebuff                        = Create({ Type = "Spell", ID = 197214 , Hidden = true}),
    SeethingRageBuff                       = Create({ Type = "Spell", ID = 297126 , Hidden = true     }),
    NaturalHarmony                         = Create({ Type = "Spell", ID = 278697 }),
    NaturalHarmonyFrostBuff                = Create({ Type = "Spell", ID = 279029 , Hidden = true     }),
    NaturalHarmonyFireBuff                 = Create({ Type = "Spell", ID = 279028 , Hidden = true     }),
    NaturalHarmonyNatureBuff               = Create({ Type = "Spell", ID = 279033 , Hidden = true     }),
    WindShear                              = Create({ Type = "Spell", ID = 57994 }),
	WindShearGreen			    		   = Create({ Type = "SpellSingleColor", ID = 57994, Color = "GREEN", Desc = "[2] Kick", QueueForbidden = true}),
    Hex                                    = Create({ Type = "Spell", ID = 51514 }),	
	HexGreen	   						   = Create({ Type = "SpellSingleColor", ID = 51514, Color = "GREEN", Desc = "[1] CC", QueueForbidden = true}),
    Boulderfist                            = Create({ Type = "Spell", ID = 246035 }),
    StrengthofEarth                        = Create({ Type = "Spell", ID = 273461 }),
	EarthElemental                         = Create({ Type = "Spell", ID = 198103 }), -- Earth Elemental manual queue
	WindfuryWeapon						   = Create({ Type = "Spell", ID = 33757 }),
	FlametongueWeapon					   = Create({ Type = "Spell", ID = 318038 }), 
	WindfuryTotem						   = Create({ Type = "Spell", ID = 8512 }),
	WindfuryTotemBuff					   = Create({ Type = "Spell", ID = 327942 }),
	ChainLightning						   = Create({ Type = "Spell", ID = 188443 }),
	Stormkeeper							   = Create({ Type = "Spell", ID = 320137 }),
	MaelstromWeapon						   = Create({ Type = "Spell", ID = 187880 , Hidden = true	}), 
	ElementalBlast						   = Create({ Type = "Spell", ID = 117014 }),
	FlameShock							   = Create({ Type = "Spell", ID = 188389 }),
	FireNova							   = Create({ Type = "Spell", ID = 333974 }),
	FrostShock							   = Create({ Type = "Spell", ID = 196840 }),
	IceStrike							   = Create({ Type = "Spell", ID = 342240 }),
    -- Utilities
    BloodLust                              = Create({ Type = "Spell", ID = 204361     }),
    LightningLasso                         = Create({ Type = "Spell", ID = 305483     }),
    CapacitorTotem                         = Create({ Type = "Spell", ID = 192058     }),
    GroundingTotem                         = Create({ Type = "Spell", ID = 204336     }),
    TremorTotem                            = Create({ Type = "Spell", ID = 8143     }),
    CounterStrikeTotem                     = Create({ Type = "Spell", ID = 204331     }),
    SkyfuryTotem                           = Create({ Type = "Spell", ID = 204330     }),
    FeralLunge                             = Create({ Type = "Spell", ID = 196884     }),
    Purge                                  = Create({ Type = "Spell", ID = 370     }),
    GhostWolf                              = Create({ Type = "Spell", ID = 2645     }),
    EarthShield                            = Create({ Type = "Spell", ID = 974     }),
    HealingSurge                           = Create({ Type = "Spell", ID = 8004     }),
    CleanseSpirit                          = Create({ Type = "Spell", ID = 51886     }), -- PartyDispell
    GhostWolfBuff                          = Create({ Type = "Spell", ID = 2645, Hidden = true     }),
    Shamanism                              = Create({ Type = "Spell", ID = 193876, Hidden = true     }), 
    AstralShift                            = Create({ Type = "Spell", ID = 108271     }),  	
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
    -- Misc
    Channeling                             = Create({ Type = "Spell", ID = 209274, Hidden = true     }),	-- Show an icon during channeling
    TargetEnemy                            = Create({ Type = "Spell", ID = 44603, Hidden = true     }),	-- Change Target (Tab button)
    StopCast                               = Create({ Type = "Spell", ID = 61721, Hidden = true     }),		-- spell_magic_polymorphrabbit
    CyclotronicBlast                       = Create({ Type = "Spell", ID = 293491, Hidden = true}),
    ConcentratedFlameBurn                  = Create({ Type = "Spell", ID = 295368, Hidden = true}),
    RazorCoralDebuff                       = Create({ Type = "Spell", ID = 303568, Hidden = true     }),
    ConductiveInkDebuff                    = Create({ Type = "Spell", ID = 302565, Hidden = true     }),
    -- Hidden Heart of Azeroth
    -- added all 3 ranks ids in case used by rotation
    VisionofPerfectionMinor                = Create({ Type = "Spell", ID = 296320, Hidden = true}),
    VisionofPerfectionMinor2               = Create({ Type = "Spell", ID = 299367, Hidden = true}),
    VisionofPerfectionMinor3               = Create({ Type = "Spell", ID = 299369, Hidden = true}),
    RecklessForceBuff                      = Create({ Type = "Spell", ID = 302932, Hidden = true     }),	 
    BlessingofProtection                   = Create({ Type = "Spell", ID = 1022, Hidden = true     }),	-- Used to check on offensive dispell 
    PoolResource                           = Create({ Type = "Spell", ID = 209274, Hidden = true     }),	
	DummyTest                              = Create({ Type = "Spell", ID = 159999, Hidden = true     }), -- Dummy stop dps icon
	Darkflight							   = Action.Create({ Type = "Spell", ID = 68992 }), -- used for Heart of Azeroth		
};

-- To create essences use next code:
Action:CreateEssencesFor(ACTION_CONST_SHAMAN_ENCHANCEMENT)  -- where PLAYERSPEC is Constance (example: ACTION_CONST_MONK_BM)
local A = setmetatable(Action[ACTION_CONST_SHAMAN_ENCHANCEMENT], { __index = Action })


------------------------------------------
---------------- VARIABLES ---------------
------------------------------------------
local VarFurycheckCl = false
local VarCooldownSync = false
local VarFurycheckEs = false
local VarFurycheckSs = false
local VarFurycheckLb = false
local VarOcpoolSs = false
local VarOcpoolCl = false
local VarOcpoolLl = false
local VarFurycheckLl = false
local VarFurycheckFb = false
local VarClpoolLl = false
local VarClpoolSs = false
local VarFreezerburnEnabled = 0;
local VarOcpool = false
local VarOcpoolFb = false
local VarRockslideEnabled = false

A.Listener:Add("ROTATION_VARS", "PLAYER_REGEN_ENABLED", function()
  VarFurycheckCl = false
  VarCooldownSync = false
  VarFurycheckEs = false
  VarFurycheckSs = false
  VarFurycheckLb = false
  VarOcpoolSs = false
  VarOcpoolCl = false
  VarOcpoolLl = false
  VarFurycheckLl = false
  VarFurycheckFb = false
  VarClpoolLl = false
  VarClpoolSs = false
  VarFreezerburnEnabled = 0
  VarOcpool = false
  VarOcpoolFb = false
  VarRockslideEnabled = false
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

--Register Toaster
Toaster:Register("TripToast", function(toast, ...)
	local title, message, spellID = ...
	toast:SetTitle(title or "nil")
	toast:SetText(message or "nil")
	if spellID then 
		if type(spellID) ~= "number" then 
			error(tostring(spellID) .. " (spellID) is not a number for TripToast!")
			toast:SetIconTexture("Interface\FriendsFrame\Battlenet-WoWicon")
		else 
			toast:SetIconTexture((GetSpellTexture(spellID)))
		end 
	else 
		toast:SetIconTexture("Interface\FriendsFrame\Battlenet-WoWicon")
	end 
	toast:SetUrgencyLevel("normal") 
end)

local function IsSchoolFree()
	return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "SHADOW") == 0
end 

local function InRange(unit)
	-- @return boolean 
	return A.LavaLash:IsInRange(unit)
end 
InRange = A.MakeFunctionCachedDynamic(InRange)

local function GetByRange(count, range, isStrictlySuperior, isStrictlyInferior, isCheckEqual, isCheckCombat)
	-- @return boolean 
	local c = 0 
	
	if isStrictlySuperior == nil then
	    isStrictlySuperior = false
	end

	if isStrictlyInferior == nil then
	    isStrictlyInferior = false
	end	
	
	for unit in pairs(ActiveUnitPlates) do 
		if (not isCheckEqual or not UnitIsUnit("target", unit)) and (not isCheckCombat or Unit(unit):CombatTime() > 0) then 
			if InRange(unit) then 
				c = c + 1
			elseif range then 
				local r = Unit(unit):GetRange()
				if r > 0 and r <= range then 
					c = c + 1
				end 
			end 
			-- Strictly superior than >
			if isStrictlySuperior and not isStrictlyInferior then
			    if c > count then
				    return true
				end
			end
			
			-- Stryctly inferior <
			if isStrictlyInferior and not isStrictlySuperior then
			    if c < count then
			        return true
				end
			end
			
			-- Classic >=
			if not isStrictlyInferior and not isStrictlySuperior then
			    if c >= count then 
				    return true 
			    end 
			end
		end 
		
	end
	
end  
GetByRange = A.MakeFunctionCachedDynamic(GetByRange)

-- API - Tracker
-- Initialize Tracker 
Pet:AddTrackers(ACTION_CONST_SHAMAN_ENCHANCEMENT, { -- this template table is the same with what has this library already built-in, just for example
    [29264] = {
        name = "Spirit Wolves",
        duration = 15,
    },
})

-- Function to check for Infernal duration
local function SpiritWolvesTime()
    return Pet:GetRemainDuration(29264) or 0
end 
SpiritWolvesTime = A.MakeFunctionCachedStatic(SpiritWolvesTime)

local function ResonanceTotemTime()
    for index = 1, 4 do
        local _, totemName, startTime, duration = GetTotemInfo(index)
        if totemName == A.TotemMastery:Info() then
            return (floor(startTime + duration - TMW.time + 0.5)) or 0
        end
    end
    return 0
end
ResonanceTotemTime = A.MakeFunctionCachedStatic(ResonanceTotemTime)

-- [1] CC AntiFake Rotation
local function AntiFakeStun(unit) 
    return 
    A.IsUnitEnemy(unit) and  
    Unit(unit):GetRange() <= 20 and 
    Unit(unit):IsControlAble("incapacitate", 0) and 
    A.HexGreen:AbsentImun(unit, Temp.TotalAndPhysAndCCAndStun, true)          
end 
A[1] = function(icon)    
    if	A.HexGreen:IsReady(nil, nil, nil, true) and 
    (
        AntiFakeStun("mouseover") or 
        AntiFakeStun("target") or 
        (
            not A.IsUnitEnemy("mouseover") and 
            not A.IsUnitEnemy("target")
        )
    )
    then 
        return A.HexGreen:Show(icon)         
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
            -- Pummel		
            if not notKickAble and A.WindShearGreen:IsReady(unit, nil, nil, true) and A.WindShearGreen:AbsentImun(unit, Temp.TotalAndMag, true) then
                return A.WindShearGreen:Show(icon)                                                  
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

-- Non GCD spell check
local function countInterruptGCD(unit)
    if not A.WindShear:IsReadyByPassCastGCD(unit) or not A.WindShear:AbsentImun(unit, Temp.TotalAndMagKick) then
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
	    -- WindShear
        if useKick and A.WindShear:IsReady(unit) then 
	        -- Notification					
			A.Toaster:SpawnByTimer("TripToast", 0, "Interrupt!", "Interrupting with Wind Shear!", A.WindShear.ID)
            return A.WindShear
        end 
	
        -- CapacitorTotem
        if useCC and Action.GetToggle(2, "UseCapacitorTotem") and A.WindShear:GetCooldown() > 0 and A.CapacitorTotem:IsReady(player) then 
			-- Notification					
            A.Toaster:SpawnByTimer("TripToast", 0, "Interrupt!", "Interrupting with Capacitor Totem!", A.CapacitorTotem.ID)
            return A.CapacitorTotem
        end  
    
        -- Hex	
        if useCC and A.Hex:IsReady(unit) and A.Hex:AbsentImun(unit, Temp.TotalAndCC, true) and Unit(unit):IsControlAble("incapacitate", 0) then 
	        -- Notification					
            A.Toaster:SpawnByTimer("TripToast", 0, "Interrupt!", "Interrupting with Hex!", A.Hex.ID)
            return A.Hex              
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
    
    -- EarthShieldHP
    local EarthShield = Action.GetToggle(2, "EarthShieldHP")
    if     EarthShield >= 0 and A.EarthShield:IsReady(player) and  
    (
        (     -- Auto 
            EarthShield >= 100 and 
            (
                Unit(player):HasBuffsStacks(A.EarthShield.ID, true) <= 3 
                or A.IsInPvP and Unit(player):HasBuffsStacks(A.EarthShield.ID, true) <= 2
            ) 
        ) or 
        (    -- Custom
            EarthShield < 100 and 
            Unit(player):HasBuffs(A.EarthShield.ID, true) <= 5 and 
            Unit(player):HealthPercent() <= EarthShield
        )
    ) 
    then 
        return A.EarthShield
    end
    
    -- HealingSurgeHP
    local HealingSurge = Action.GetToggle(2, "HealingSurgeHP")
    if     HealingSurge >= 0 and A.HealingSurge:IsReady(player) and Unit("player"):CombatTime() > 2  and
    (
        (     -- Auto 
            HealingSurge >= 100 and 
            (
                -- HP lose per sec >= 10
                Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 10 or 
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.10 or 
                -- TTD 
                Unit(player):TimeToDieX(25) < 5 or 
                (
                    A.IsInPvP and 
                    (
                        Unit(player):UseDeff() or 
                        (
                            Unit(player, 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused() 
                        )
                    )
                )
            ) and 
            Unit(player):HasBuffs("DeffBuffs", true) == 0
        ) or 
        (    -- Custom
            HealingSurge < 100 and 
            Unit(player):HealthPercent() <= HealingSurge
        )
    ) 
    then 
        return A.HealingSurge
    end
    
    -- Abyssal Healing Potion
    local AbyssalHealingPotion = Action.GetToggle(2, "AbyssalHealingPotionHP")
    if     AbyssalHealingPotion >= 0 and A.AbyssalHealingPotion:IsReady(player) and 
    (
        (     -- Auto 
            AbyssalHealingPotion >= 100 and 
            (
                -- HP lose per sec >= 25
                Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 25 or 
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.25 or 
                -- TTD 
                Unit(player):TimeToDieX(25) < 5 or 
                (
                    A.IsInPvP and 
                    (
                        Unit(player):UseDeff() or 
                        (
                            Unit(player, 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused() 
                        )
                    )
                )
            ) and 
            Unit(player):HasBuffs("DeffBuffs", true) == 0
        ) or 
        (    -- Custom
            AbyssalHealingPotion < 100 and 
            Unit(player):HealthPercent() <= AbyssalHealingPotion
        )
    ) 
    then 
        return A.AbyssalHealingPotion
    end  
    
    -- AstralShift
    local AstralShift = Action.GetToggle(2, "AstralShiftHP")
    if     AstralShift >= 0 and A.AstralShift:IsReady(player) and 
    (
        (     -- Auto 
            AstralShift >= 100 and 
            (
                -- HP lose per sec >= 20
                Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 20 or 
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.20 or 
                -- TTD 
                Unit(player):TimeToDieX(25) < 5 or 
                (
                    A.IsInPvP and 
                    (
                        Unit(player):UseDeff() or 
                        (
                            Unit(player, 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused() 
                        )
                    )
                )
            ) and 
            Unit(player):HasBuffs("DeffBuffs", true) == 0
        ) or 
        (    -- Custom
            AstralShift < 100 and 
            Unit(player):HealthPercent() <= AstralShift
        )
    ) 
    then 
        return A.AstralShift
    end     
    -- Stoneform on self dispel (only PvE)
    if A.Stoneform:IsRacialReady(player, true) and not A.IsInPvP and A.AuraIsValid(player, "UseDispel", "Dispel") then 
        return A.Stoneform
    end 
end 
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

--Maintenance
local function Maintenance(unit)
	local FlametongueRefresh = Action.GetToggle(2, "FlametongueRefresh")
	local FrostbrandRefresh = Action.GetToggle(2, "FrostbrandRefresh")
    -- flametongue,if=!buff.flametongue.up
    if A.Flametongue:IsReady(unit) and (Unit(player):HasBuffs(A.FlametongueBuff.ID, true) < FlametongueRefresh) then
        return A.Flametongue
    end
			
    -- frostbrand,if=talent.hailstorm.enabled&!buff.frostbrand.up&variable.furyCheck_FB
    if A.Frostbrand:IsReady(unit) and (A.Hailstorm:IsSpellLearned() and Unit(player):HasBuffs(A.FrostbrandBuff.ID, true) < FrostbrandRefresh and VarFurycheckFb) then
        return A.Frostbrand
    end		
end
Maintenance = A.MakeFunctionCachedDynamic(Maintenance)

--- ======= ACTION LISTS =======
-- [3] Single Rotation
A[3] = function(icon, isMulti)
    --------------------
    --- ROTATION VAR ---
    --------------------
    local isMoving = A.Player:IsMoving()
	local isMovingFor = A.Player:IsMovingTime()
    local inCombat = Unit(player):CombatTime() > 0
	local combatTime = Unit(player):CombatTime()
    local ShouldStop = Action.ShouldStop()
    local Pull = Action.BossMods:GetPullTimer()
	local CanCast = true
	local profileStop = false
    local SpiritWolvesTime = SpiritWolvesTime()
    local HeartOfAzeroth = Action.GetToggle(1, "HeartOfAzeroth")
    local Potion = Action.GetToggle(1, "Potion")	
	local Racial = Action.GetToggle(1, "Racial")
	local DBM = Action.GetToggle(1, "BossMods")

	
	-- FocusedAzeriteBeam protection channel
	local secondsLeft, percentLeft, spellID, spellName, notInterruptable, isChannel = Unit(player):IsCastingRemains()
		-- @return:
		-- [1] Currect Casting Left Time (seconds) (@number)
		-- [2] Current Casting Left Time (percent) (@number)
		-- [3] spellID (@number)
		-- [4] spellName (@string)
		-- [5] notInterruptable (@boolean, false is able to be interrupted)
		-- [6] isChannel (@boolean)
	if percentLeft > 0.01 and spellName == A.FocusedAzeriteBeam:Info() then 
	    CanCast = false
	else
	    CanCast = true
	end	
	
	if not CanCast then
	    return A.PoolResource:Show(icon)
	end	
	
	------------------------------------
	---------- DUMMY DPS TEST ----------
	------------------------------------
	local DummyTime = GetToggle(2, "DummyTime")
	if DummyTime > 0 then
    	local unit = "target"
		local endtimer = 0
		
    	if Unit(unit):IsExists() and Unit(unit):IsDummy() then
        	if Unit(player):CombatTime() >= (DummyTime * 60) then
            	StopAttack()
				endtimer = TMW.time
            	--ClearTarget() -- Protected ? 
	       	    -- Notification					
          	    Action.SendNotification(DummyTime .. " Minutes Dummy Test Concluded - Profile Stopped", A.DummyTest.ID)			
         	    
				if endtimer < TMW.time + 5 then
				    profileStop = true
				    --return A.DummyTest:Show(icon)
				end
    	    end
  	    end
	end	
	-- Mounted
	if Player:IsMounted() then
	    profileStop = true
	end
	
    ------------------------------------------------------
    ---------------- ENEMY UNIT ROTATION -----------------
    ------------------------------------------------------
    local function EnemyRotation(unit)
	
		local FlametongueRefresh = Action.GetToggle(2, "FlametongueRefresh")
		local FrostbrandRefresh = Action.GetToggle(2, "FrostbrandRefresh")
		local GhostWolfTime = Action.GetToggle(2, "GhostWolfTime")
		local UseGhostWolf = Action.GetToggle(2, "UseGhostWolf")
		local CounterStrikeTotemHPlosepersec =  Action.GetToggle(2, "CounterStrikeTotemHPlosepersec")
		local CounterStrikeTotemTTD =  Action.GetToggle(2, "CounterStrikeTotemTTD")
		local FeralLungeHP = Action.GetToggle(2, "FeralLungeHP")
		local FeralLungeRange = Action.GetToggle(2, "FeralLungeRange")
		local SkyfuryTotemTTD = Action.GetToggle(2, "SkyfuryTotemTTD")
		local SkyfuryTotemHP = Action.GetToggle(2, "SkyfuryTotemHP")
		local TrinketsAoE = Action.GetToggle(2, "TrinketsAoE")
		local TrinketsMinTTD = Action.GetToggle(2, "TrinketsMinTTD")
		local TrinketsUnitsRange = Action.GetToggle(2, "TrinketsUnitsRange")
		local TrinketsMinUnits = Action.GetToggle(2, "TrinketsMinUnits")	
		local TotemMasteryRefresh = Action.GetToggle(2, "TotemMasteryRefresh")	
		local UseTotemMastery = Action.GetToggle(2, "UseTotemMastery")	
		local FocusedAzeriteBeamTTD = Action.GetToggle(2, "FocusedAzeriteBeamTTD")
		local FocusedAzeriteBeamUnits = Action.GetToggle(2, "FocusedAzeriteBeamUnits")
		local EarthElementalHP = Action.GetToggle(2, "EarthElementalHP")
		local EarthElementalRange = Action.GetToggle(2, "EarthElementalRange")
		local EarthElementalUnits = Action.GetToggle(2, "EarthElementalUnits")
		local UnbridledFuryAuto = Action.GetToggle(2, "UnbridledFuryAuto")
		local UnbridledFuryTTD = Action.GetToggle(2, "UnbridledFuryTTD")
		local UnbridledFuryWithBloodlust = Action.GetToggle(2, "UnbridledFuryWithBloodlust")
		local UnbridledFuryWithExecute = Action.GetToggle(2, "UnbridledFuryWithExecute")
		local UnbridledFuryHP = Action.GetToggle(2, "UnbridledFuryHP")
		local MinInterrupt = Action.GetToggle(2, "MinInterrupt")
		local MaxInterrupt = Action.GetToggle(2, "MaxInterrupt")
		local UseSyncCooldowns = Action.GetToggle(2, "UseSyncCooldowns")
		local TrinketOnlyBurst = Action.GetToggle(2, "TrinketOnlyBurst")
        -- Trinkets var             
        local Trinket1IsAllowed, Trinket2IsAllowed = TR.TrinketIsAllowed()
        
		--[[ DoT tracking?
		local AppliedFlameShock = MultiUnits:GetByRangeAppliedDoTs(40, 5, A.FlameShock.ID)
		local FlameShockToRefresh = MultiUnits:GetByRangeDoTsToRefresh(40, 5, A.FlameShock.ID)
		local MissingFlameShock = MultiUnits:GetByRangeMissedDoTs(12, 5, A.FlameShock.ID)]]
		
    	-- Interrupt
        local Interrupt = Interrupts(unit)
        if Interrupt then 
            return Interrupt:Show(icon)
        end	
	
        -- Purge
        -- Note: Toggles  ("UseDispel", "UsePurge", "UseExpelEnrage")
        -- Category ("Dispel", "MagicMovement", "PurgeFriendly", "PurgeHigh", "PurgeLow", "Enrage")
        if A.Purge:IsReady(unit) and inCombat and A.LastPlayerCastName ~= A.Purge:Info() and not ShouldStop and Action.AuraIsValid("target", "UsePurge", "PurgeHigh") 
		and Unit(unit):HasBuffs(A.BlessingofProtection.ID, true) == 0
		then
            return A.Purge:Show(icon)
        end 
			
        -- Purge
        -- Note: Toggles  ("UseDispel", "UsePurge", "UseExpelEnrage")
        -- Category ("Dispel", "MagicMovement", "PurgeFriendly", "PurgeHigh", "PurgeLow", "Enrage")
        if A.Purge:IsReady(unit) and inCombat and A.LastPlayerCastName ~= A.Purge:Info() and not ShouldStop and Action.AuraIsValid("target", "UsePurge", "PurgeLow") 
		and Unit(unit):HasBuffs(A.BlessingofProtection.ID, true) == 0
		then
            return A.Purge:Show(icon)
        end 
			
        --[[Feral Lunge
        if (Unit(unit):GetRange() >= Action.GetToggle(2, "FeralLungeRange") and inCombat and Unit(unit):GetRange() <= 25 or Unit(unit):IsMovingOut()) and Unit(unit):HealthPercent() <= Action.GetToggle(2, "FeralLungeHP") and A.FeralLunge:IsReady(unit) and A.FeralLunge:IsSpellLearned() then
            return A.FeralLunge:Show(icon)
        end]]
			
		-- Bloodlust Shamanism PvP
        if A.BloodLust:IsReady(player) and inCombat and BurstIsON(unit) and A.Shamanism:IsSpellLearned() then 
            return A.BloodLust:Show(icon)
        end 
			
		-- Skyfury Totem
        if A.IsInPvP and A.SkyfuryTotem:IsReady(player) and inCombat and (Unit(unit):HealthPercent() <= SkyfuryTotemHP or Unit(unit):TimeToDie() <= SkyfuryTotemTTD) and BurstIsON(unit) and A.SkyfuryTotem:IsSpellLearned() then 
            return A.SkyfuryTotem:Show(icon)
        end

		-- Tremor Totem on Friendly LOC
        if A.TremorTotem:IsReady(player) and inCombat and FriendlyTeam():GetDeBuffs("Fear") > 0 then 
            return A.TremorTotem:Show(icon)
        end
			
		-- CounterStrikeTotem on enemy burst 
        if A.IsInPvP and Unit(player):IsFocused() and inCombat and A.CounterStrikeTotem:IsReady(player) and A.CounterStrikeTotem:IsSpellLearned() and
		   (
		        -- HP lose per sec >= 30
                Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= CounterStrikeTotemHPlosepersec 
				or  
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * (CounterStrikeTotemHPlosepersec / 100)
				or
				Unit(player):TimeToDie() <= CounterStrikeTotemTTD
			)
		then 
            return A.CounterStrikeTotem:Show(icon)
        end
		
	   	-- Non SIMC Custom Trinket1
	    if A.Trinket1:IsReady(unit) and ((TrinketOnlyBurst and BurstIsON(unit)) or (not TrinketOnlyBurst and not BurstIsON(unit))) and Trinket1IsAllowed and inCombat and CanCast and Unit(unit):GetRange() < 6 and    
		(
    		TrinketsAoE and GetByRange(TrinketsMinUnits, TrinketsUnitsRange) and Player:AreaTTD(TrinketsUnitsRange) > TrinketsMinTTD
			or
			not TrinketsAoE and Unit(unit):TimeToDie() >= TrinketsMinTTD 					
		)
		then 
      	    return A.Trinket1:Show(icon)
   	    end 		
	        	
		-- Non SIMC Custom Trinket2
	    if A.Trinket2:IsReady(unit) and ((TrinketOnlyBurst and BurstIsON(unit)) or (not TrinketOnlyBurst and not BurstIsON(unit))) and Trinket2IsAllowed and inCombat and CanCast and Unit(unit):GetRange() < 6 and	    
		(
    		TrinketsAoE and GetByRange(TrinketsMinUnits, TrinketsUnitsRange) and Player:AreaTTD(TrinketsUnitsRange) > TrinketsMinTTD
			or
			not TrinketsAoE and Unit(unit):TimeToDie() >= TrinketsMinTTD 					
		)
		then
      	   	return A.Trinket2:Show(icon) 	
	    end
		
--#############################
--#########  ACTIONS   ########
--#############################

		--Earth Elemental calls
		if Unit("player"):HealthPercent() <= EarthElementalHP and GetByRange(EarthElementalUnits, EarthElementalRange) then
			A.EarthElemental:Show(icon)
		end

		--Ghost Wolf calls
		if isMovingFor > Action.GetToggle(2, "GhostWolfTime") and Unit(unit):GetRange() > 8 and A.GhostWolf:IsReady(player) and Action.GetToggle(2, "UseGhostWolf") and Unit(player):HasBuffs(A.GhostWolfBuff.ID, true) == 0 then
			-- Notification                    
			A.Toaster:SpawnByTimer("TripToast", 0, "Out of Range!", "Using Ghost Wolf.", A.GhostWolf.ID)
			return A.GhostWolf:Show(icon)
		end

		--actions.precombat+=/lightning_shield
		if A.LightningShield:IsReady(unit) and ((not inCombat and Unit("player"):HasBuffs(A.LightningShield.ID, true) < 150) or Unit("player"):HasBuffs(A.LightningShield.ID, true) == 0) then
			return A.LightningShield:Show(icon)
		end

		--Windfury Totem if in group and not Windfury totem buff and timesincelastcast > whatever
		if A.WindfuryTotem:IsReady("player") and Action.InstanceInfo.GroupSize >= 2 and inCombat and (Unit("player"):HasBuffs(A.WindfuryTotemBuff.ID, true) == 0 or A.WindfuryTotem:GetSpellTimeSinceLastCast() > 90) then
			return A.WindfuryTotem:Show(icon)
		end	
			
		--actions+=/windstrike
		if A.Windstrike:IsReady(unit) and Unit("player"):HasBuffs(A.AscendanceBuff.ID, true) > 0 then
			return A.Windstrike:Show(icon)
		end
		
		--actions+=/blood_fury,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
		if A.BloodFury:IsReady(unit) and BurstIsON(unit) and AutoRacial and (not A.Ascendance:IsSpellLearned() or Unit("player"):HasBuffs(A.AscendanceBuff.ID) > 0 or A.Ascendance:GetCooldown() > 50) then
			return A.BloodFury:Show(icon)
		end
		
		--actions+=/berserking,if=!talent.ascendance.enabled|buff.ascendance.up
		if A.Berserking:IsReady(unit) and BurstIsON(unit) and AutoRacial and (not A.Ascendance:IsSpellLearned() or Unit("player"):HasBuffs(A.AscendanceBuff.ID) > 0) then
			return A.Berserking:Show(icon)
		end		
		
		--actions+=/fireblood,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
		if A.Fireblood:IsReady(unit) and BurstIsON(unit) and AutoRacial and (not A.Ascendance:IsSpellLearned() or Unit("player"):HasBuffs(A.AscendanceBuff.ID) > 0 or A.Ascendance:GetCooldown() > 50) then
			return A.Fireblood:Show(icon)
		end				
		
		--actions+=/ancestral_call,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
		if A.AncestralCall:IsReady(unit) and BurstIsON(unit) and AutoRacial and (not A.Ascendance:IsSpellLearned() or Unit("player"):HasBuffs(A.AscendanceBuff.ID) > 0 or A.Ascendance:GetCooldown() > 50) then
			return A.AncestralCall:Show(icon)
		end			
		
		--actions+=/bag_of_tricks,if=!talent.ascendance.enabled|!buff.ascendance.up
		if A.BagofTricks:IsReady(unit) and BurstIsON(unit) and AutoRacial and (not A.Ascendance:IsSpellLearned() or Unit("player"):HasBuffs(A.AscendanceBuff.ID) == 0) then
			return A.BagofTricks:Show(icon)
		end	

		--actions+=/feral_spirit
		if A.FeralSpirit:IsReady(unit) and BurstIsON(unit) and A.GetToggle(2, "EnableFS") then
			return A.FeralSpirit:Show(icon)
		end

			-- guardian_of_azeroth
			if A.GuardianofAzeroth:IsReady(unit) and BurstIsON(unit) then
				return A.Darkflight:Show(icon)
			end
			
			-- focused_azerite_beam
			if A.FocusedAzeriteBeam:IsReady(unit) and BurstIsON(unit) then
				return A.Darkflight:Show(icon)
			end
			
			-- memory_of_lucid_dreams
			if A.MemoryofLucidDreams:IsReady(unit) and BurstIsON(unit) then
				return A.Darkflight:Show(icon)
			end
			
			-- blood_of_the_enemy
			if A.BloodoftheEnemy:IsReady(unit) and BurstIsON(unit) then
				return A.Darkflight:Show(icon)
			end
			
			-- purifying_blast
			if A.PurifyingBlast:IsReady(unit) and BurstIsON(unit) then
				return A.Darkflight:Show(icon)
			end
			
			--[[ ripple_in_space
			if A.RippleInSpace:AutoHeartOfAzerothP(unit, true) and HeartOfAzeroth then
				return A.Darkflight:Show(icon)
			end]]
			
			-- concentrated_flame,line_cd=6
			if A.ConcentratedFlame:IsReady(unit) and BurstIsON(unit) then
				return A.Darkflight:Show(icon)
			end
			
			-- reaping_flames
			if A.ReapingFlames:IsReady(unit) and BurstIsON(unit) then
				return A.Darkflight:Show(icon)
			end
		
		--actions+=/earth_elemental
		if A.EarthElemental:IsReady(unit) and BurstIsON(unit) and GetToggle(2, "EarthElementalDPS") then
			return A.EarthElemental:Show(icon)
		end
		
		--actions+=/earthen_spike
		if A.EarthenSpike:IsReady(unit) then
			return A.EarthenSpike:Show(icon)
		end
		
		--actions+=/sundering
		if A.Sundering:IsReady(unit) and Unit(unit):GetRange() <= 8 then
			return A.Sundering:Show(icon)
		end		
		
		--actions+=/ascendance
		if A.Ascendance:IsReady(unit) and BurstIsON(unit) then
			return A.Ascendance:Show(icon)
		end	

		
--#############################
--######### PRE-COMBAT ########
--#############################

		local function Precombat(unit)
			--actions.precombat+=/windfury_weapon
			--if A.WindfuryWeapon:IsReady() and not inCombat and 
			
			--actions.precombat+=/flametongue_weapon
			
			--actions.precombat+=/stormkeeper,if=talent.stormkeeper.enabled
			--DBM timer
			
			--actions.precombat+=/windfury_totem
			--DBM timer
		end
		

--#############################
--#########    AOE     ########
--#############################

		local function AoERotation(unit)
		
			--actions.aoe=crash_lightning
			if A.CrashLightning:IsReady("player") and Unit("target"):GetRange() <= 8 then
				return A.CrashLightning:Show(icon)
			end
			
			--actions.aoe+=/chain_lightning,if=buff.stormkeeper.up&buff.maelstrom_weapon.stack>=5
			if A.ChainLightning:IsReady(unit) and Unit("player"):HasBuffs(A.Stormkeeper.ID, true) > 0 and Unit("player"):HasBuffsStacks(A.MaelstromWeapon.ID, true) >= 5 then
				return A.ChainLightning:Show(icon)
			end	
			
			--actions.aoe+=/elemental_blast,if=buff.maelstrom_weapon.stack>=5
			if A.ElementalBlast:IsReady(unit) and Unit("player"):HasBuffsStacks(A.MaelstromWeapon.ID, true) >= 5 then
				return A.ElementalBlast:Show(icon)
			end	
			
			--actions.aoe+=/stormkeeper,if=buff.maelstrom_weapon.stack>=5
			if A.Stormkeeper:IsReady(unit) and Unit("player"):HasBuffsStacks(A.MaelstromWeapon.ID, true) >= 5 then
				return A.Stormkeeper:Show(icon)
			end	
			
			--actions.aoe+=/chain_lightning,if=buff.maelstrom_weapon.stack=10
			if A.ChainLightning:IsReady(unit) and Unit("player"):HasBuffsStacks(A.MaelstromWeapon.ID, true) >= 10 then
				return A.ChainLightning:Show(icon)
			end	
			
			--actions.aoe+=/flame_shock,target_if=refreshable,cycle_targets=1,if=talent.fire_nova.enabled
			if A.FlameShock:IsReady(unit) and (Unit("target"):HasDeBuffs(A.FlameShock.ID, true) == 0 or Unit("target"):HasDeBuffs(A.FlameShock.ID, true) < 4) and A.FireNova:IsSpellLearned() then
				return A.FlameShock:Show(icon)
			end	
			
			--actions.aoe+=/fire_nova,if=active_dot.flame_shock>=3
			if A.FireNova:IsReady("player") and Unit("target"):HasDeBuffs(A.FlameShock.ID, true) > 0 then
				return A.FireNova:Show(icon)
			end	
			
			--actions.aoe+=/stormstrike
			if A.Stormstrike:IsReady(unit) then
				return A.Stormstrike:Show(icon)
			end	
			
			--actions.aoe+=/lava_lash
			if A.LavaLash:IsReady(unit) then
				return A.LavaLash:Show(icon)
			end	
			
			--actions.aoe+=/flame_shock,target_if=refreshable,cycle_targets=1,if=!buff.hailstorm.up
			if A.FlameShock:IsReady(unit) and (Unit("target"):HasDeBuffs(A.FlameShock.ID, true) == 0 or Unit("target"):HasDeBuffs(A.FlameShock.ID, true) < 4) and Unit("player"):HasBuffs(A.Hailstorm.ID, true) == 0 then
				return A.FlameShock:Show(icon)
			end	
			
			--actions.aoe+=/frost_shock
			if A.FrostShock:IsReady(unit) then
				return A.FrostShock:Show(icon)
			end	
			
			--actions.aoe+=/ice_strike
			if A.IceStrike:IsReady(unit) then
				return A.IceStrike:Show(icon)
			end	
			
			--actions.aoe+=/chain_lightning,if=buff.maelstrom_weapon.stack>=5
			if A.ChainLightning:IsReady(unit) and Unit("player"):HasBuffsStacks(A.MaelstromWeapon.ID, true) >= 5 then
				return A.ChainLightning:Show(icon)
			end	
			
			--actions.aoe+=/windfury_totem,if=buff.windfury_totem.remains<30
			--if A.WindfuryTotem:IsReady(unit) and Action.InstanceInfo.GroupSize > 1 and 
		
		end

--#############################
--####    SINGLE TARGET    ####
--#############################

		local function SingleRotation(unit)
			--actions.single=flame_shock,if=!ticking
			if A.FlameShock:IsReady(unit) and Unit("target"):HasDeBuffs(A.FlameShock.ID, true) == 0 then
				return A.FlameShock:Show(icon)
			end
			
			--actions.single+=/frost_shock,if=buff.hailstorm.up
			if A.FrostShock:IsReady(unit) and Unit("player"):HasBuffs(A.Hailstorm.ID, true) > 0 then
				return A.FrostShock:Show(icon)
			end
			
			--actions.single+=/lightning_bolt,if=buff.stormkeeper.up&buff.maelstrom_weapon.stack>=5
			if A.LightningBolt:IsReady(unit) and Unit("player"):HasBuffs(A.Stormkeeper.ID, true) > 0 and Unit("player"):HasBuffsStacks(A.MaelstromWeapon.ID, true) >= 5 then
				return A.LightningBolt:Show(icon)
			end
			
			--actions.single+=/elemental_blast,if=buff.maelstrom_weapon.stack>=5
			if A.ElementalBlast:IsReady(unit) and Unit("player"):HasBuffsStacks(A.MaelstromWeapon.ID, true) >= 5 then
				return A.ElementalBlast:Show(icon)
			end	
			
			--actions.single+=/lightning_bolt,if=buff.maelstrom_weapon.stack=10
			if A.LightningBolt:IsReady(unit) and Unit("player"):HasBuffsStacks(A.MaelstromWeapon.ID, true) >= 10 then
				return A.LightningBolt:Show(icon)
			end			
			
			--actions.single+=/lava_lash,if=buff.hot_hand.up
			if A.LavaLash:IsReady(unit) and Unit("player"):HasBuffs(A.HotHandBuff.ID, true) > 0 then
				return A.LavaLash:Show(icon)
			end	
			
			--actions.single+=/stormstrike
			if A.Stormstrike:IsReady(unit) then
				return A.Stormstrike:Show(icon)
			end
			
			--actions.single+=/stormkeeper,if=buff.maelstrom_weapon.stack>=5
			if A.Stormkeeper:IsReady(unit) and Unit("player"):HasBuffsStacks(A.MaelstromWeapon.ID, true) >= 5 then
				return A.Stormkeeper:Show(icon)
			end	
			
			--actions.single+=/lava_lash
			if A.LavaLash:IsReady(unit) then
				return A.LavaLash:Show(icon)
			end			
			
			--actions.single+=/crash_lightning
			if A.CrashLightning:IsReady("player") and Unit("target"):GetRange() <= 8 then
				return A.CrashLightning:Show(icon)
			end		
			
			--actions.single+=/flame_shock,target_if=refreshable
			if A.FlameShock:IsReady(unit) and (Unit("target"):HasDeBuffs(A.FlameShock.ID, true) == 0 or Unit("target"):HasDeBuffs(A.FlameShock.ID, true) < 4) then
				return A.FlameShock:Show(icon)
			end			
			
			--actions.single+=/frost_shock
			if A.FrostShock:IsReady(unit) then
				return A.FrostShock:Show(icon)
			end				
			
			--actions.single+=/ice_strike
			if A.IceStrike:IsReady(unit) then
				return A.IceStrike:Show(icon)
			end				
			
			--actions.single+=/fire_nova,if=active_dot.flame_shock
			if A.FireNova:IsReady("player") and Unit("target"):HasDeBuffs(A.FlameShock.ID, true) > 0 then
				return A.FireNova:Show(icon)
			end	
			
			--actions.single+=/lightning_bolt,if=buff.maelstrom_weapon.stack>=5
			if A.LightningBolt:IsReady(unit) and Unit("player"):HasBuffsStacks(A.MaelstromWeapon.ID, true) >= 5 then
				return A.LightningBolt:Show(icon)
			end	
			
			--actions.single+=/windfury_totem,if=buff.windfury_totem.remains<30
		
		end 
		
		--actions+=/call_action_list,name=single,if=active_enemies=1
		--actions+=/call_action_list,name=aoe,if=active_enemies>1		
		if (MultiUnits:GetByRange(8) >= 2) then
			return AoERotation(unit)
		end
		
		if (MultiUnits:GetByRange(8) <= 1) then
			return SingleRotation(unit)
		end

		
    end
    -- End on EnemyRotation()

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
-- Finished

-- [4] AoE Rotation
A[4] = function(icon)
    return A[3](icon, true)
end
 -- [5] Trinket Rotation
-- No specialization trinket actions 

local function ArenaRotation(icon, unit)
    if A.IsInPvP and (A.Zone == "pvp" or A.Zone == "arena") and not Player:IsStealthed() and not Player:IsMounted() then
        -- Note: "arena1" is just identification of meta 6
        if (unit == "arena1" or unit == "arena2" or unit == "arena3") then  

            -- Hex	
            if useCC and A.Hex:IsReady(unit) and A.Hex:AbsentImun(unit, Temp.TotalAndCC, true) and Unit(unit):IsControlAble("incapacitate") then 
	            -- Notification					
                A.Toaster:SpawnByTimer("TripToast", 0, "Hexing!", "Hex on " .. unit, A.Hex.ID)
                return A.Hex:Show(icon)              
            end
			
	    end
		
		-- Interrupt
        local Interrupt = Interrupts(unit)
        if Interrupt then 
            return Interrupt:Show(icon)
        end	
				
		-- CounterStrike Totem on Enemyburst
        if A.CounterStrikeTotem:IsReady(player) and Unit(player):IsFocused("DAMAGER") and Unit(player):GetDMG() > 2 and A.CounterStrikeTotem:IsSpellLearned() then 
            return A.CounterStrikeTotem:Show(icon)
        end
	
		-- Grounding Totem Casting BreakAble CC
        if A.GroundingTotem:IsReady(player) and A.GroundingTotem:IsSpellLearned() and Action.ShouldReflect(unit) and EnemyTeam():IsCastingBreakAble(0.25) then 
            return A.GroundingTotem:Show(icon)
        end
		
        -- Purge
        -- Note: Toggles  ("UseDispel", "UsePurge", "UseExpelEnrage")
        -- Category ("Dispel", "MagicMovement", "PurgeFriendly", "PurgeHigh", "PurgeLow", "Enrage")
        if A.Purge:IsReady(unit) and A.LastPlayerCastName ~= A.Purge:Info() and Action.AuraIsValid(unit, "UsePurge", "PurgeHigh") 
		and Unit(unit):HasBuffs(A.BlessingofProtection.ID, true) == 0
		then
            return A.Purge:Show(icon)
        end 
			
        -- Purge
        -- Note: Toggles  ("UseDispel", "UsePurge", "UseExpelEnrage")
        -- Category ("Dispel", "MagicMovement", "PurgeFriendly", "PurgeHigh", "PurgeLow", "Enrage")
        if A.Purge:IsReady(unit) and A.LastPlayerCastName ~= A.Purge:Info() and Action.AuraIsValid(unit, "UsePurge", "PurgeLow") 
		and Unit(unit):HasBuffs(A.BlessingofProtection.ID, true) == 0
		then
            return A.Purge:Show(icon)
        end         		
    end 
end 

--[[local function PartyRotation(unit)
    if (unit == "party1" and not Action.GetToggle(2, "PartyUnits")[1]) or (unit == "party2" and not Action.GetToggle(2, "PartyUnits")[2]) then 
        return false 
    end

  	-- CleanseSpirit
    --if A.CleanseSpirit:IsReady(unit) and A.CleanseSpirit:AbsentImun(unit, Temp.TotalAndMag) and Action.AuraIsValid(unit, "UseDispel", "Magic") and not Unit(unit):InLOS() then
    --    return A.CleanseSpirit
    --end
end ]]

A[6] = nil

A[7] = nil

A[8] = nil
