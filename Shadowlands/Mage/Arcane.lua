--##############################
--##### TRIP'S ARCANE MAGE #####
--##############################

--Credit to Taste

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

--For Toaster
local Toaster																	= _G.Toaster
local GetSpellTexture 															= _G.TMW.GetSpellTexture


--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

-- Spells
Action[ACTION_CONST_MAGE_ARCANE] = {
    -- Racial
    ArcaneTorrent                          = Action.Create({ Type = "Spell", ID = 50613     }),
    BloodFury                              = Action.Create({ Type = "Spell", ID = 20572      }),
    Fireblood                              = Action.Create({ Type = "Spell", ID = 265221     }),
    AncestralCall                          = Action.Create({ Type = "Spell", ID = 274738     }),
    Berserking                             = Action.Create({ Type = "Spell", ID = 26297    }),
    ArcanePulse                            = Action.Create({ Type = "Spell", ID = 260364    }),
    QuakingPalm                            = Action.Create({ Type = "Spell", ID = 107079     }),
    Haymaker                               = Action.Create({ Type = "Spell", ID = 287712     }), 
    WarStomp                               = Action.Create({ Type = "Spell", ID = 20549     }),
    BullRush                               = Action.Create({ Type = "Spell", ID = 255654     }),  
    GiftofNaaru                            = Action.Create({ Type = "Spell", ID = 59544    }),
    Shadowmeld                             = Action.Create({ Type = "Spell", ID = 58984    }), -- usable in Action Core 
    Stoneform                              = Action.Create({ Type = "Spell", ID = 20594    }), 
    WilloftheForsaken                      = Action.Create({ Type = "Spell", ID = 7744        }), -- not usable in APL but user can Queue it   
    EscapeArtist                           = Action.Create({ Type = "Spell", ID = 20589    }), -- not usable in APL but user can Queue it
    EveryManforHimself                     = Action.Create({ Type = "Spell", ID = 59752    }), -- not usable in APL but user can Queue it
    -- Generics
    ArcaneIntellectBuff                    = Action.Create({ Type = "Spell", ID = 1459, Hidden = true }),
    ArcaneIntellect                        = Action.Create({ Type = "Spell", ID = 1459 }),
    ArcaneFamiliarBuff                     = Action.Create({ Type = "Spell", ID = 210126, Hidden = true }),
    ArcaneFamiliar                         = Action.Create({ Type = "Spell", ID = 205022 }),
    Equipoise                              = Action.Create({ Type = "Spell", ID = 286027 }),
    MirrorImage                            = Action.Create({ Type = "Spell", ID = 55342 }),
    ArcaneBlast                            = Action.Create({ Type = "Spell", ID = 30451 }),
    Evocation                              = Action.Create({ Type = "Spell", ID = 12051 }),
    ChargedUp                              = Action.Create({ Type = "Spell", ID = 205032 }),
    ArcaneChargeBuff                       = Action.Create({ Type = "Spell", ID = 36032, Hidden = true }),
    NetherTempest                          = Action.Create({ Type = "Spell", ID = 114923 }),
    NetherTempestDebuff                    = Action.Create({ Type = "Spell", ID = 114923, Hidden = true }),
    RuneofPowerBuff                        = Action.Create({ Type = "Spell", ID = 116014, Hidden = true }),
    ArcanePowerBuff                        = Action.Create({ Type = "Spell", ID = 12042, Hidden = true }),
    RuleofThreesBuff                       = Action.Create({ Type = "Spell", ID = 264774, Hidden = true }),
    Overpowered                            = Action.Create({ Type = "Spell", ID = 155147 }),
    LightsJudgment                         = Action.Create({ Type = "Spell", ID = 255647 }),
    BagofTricks                            = Action.Create({ Type = "Spell", ID = 312411 }),
    RuneofPower                            = Action.Create({ Type = "Spell", ID = 116011 }),
    ArcanePower                            = Action.Create({ Type = "Spell", ID = 12042 }),
    Berserking                             = Action.Create({ Type = "Spell", ID = 26297 }),
    BloodFury                              = Action.Create({ Type = "Spell", ID = 20572 }),
    Fireblood                              = Action.Create({ Type = "Spell", ID = 265221 }),
    AncestralCall                          = Action.Create({ Type = "Spell", ID = 274738 }),
    PresenceofMind                         = Action.Create({ Type = "Spell", ID = 205025 }),
    PresenceofMindBuff                     = Action.Create({ Type = "Spell", ID = 205025, Hidden = true }),
    BerserkingBuff                         = Action.Create({ Type = "Spell", ID = 26297, Hidden = true }),
    BloodFuryBuff                          = Action.Create({ Type = "Spell", ID = 20572, Hidden = true }),
    ArcaneOrb                              = Action.Create({ Type = "Spell", ID = 153626 }),
    Resonance                              = Action.Create({ Type = "Spell", ID = 205028 }),
    ArcaneBarrage                          = Action.Create({ Type = "Spell", ID = 44425 }),
    ArcaneExplosion                        = Action.Create({ Type = "Spell", ID = 1449 }),
    ArcaneMissiles                         = Action.Create({ Type = "Spell", ID = 5143 }),
    ClearcastingBuff                       = Action.Create({ Type = "Spell", ID = 263725, Hidden = true }),
    Amplification                          = Action.Create({ Type = "Spell", ID = 236628 }),
    Supernova                              = Action.Create({ Type = "Spell", ID = 157980 }),
    BloodoftheEnemyBuff                    = Action.Create({ Type = "Spell", ID = 297108, Hidden = true }),
    Shimmer                                = Action.Create({ Type = "Spell", ID = 212653     }),
	Blink                                  = Action.Create({ Type = "Spell", ID = 1953     }),
	IncantersFlowBuff                      = Action.Create({ Type = "Spell", ID = 116267, Hidden = true     }), -- IncantersFlowBuff
	TouchoftheMagi                         = Action.Create({ Type = "Spell", ID = 321507  }),
    -- Azerite Traits (BfA)
    ArcanePummeling                        = Action.Create({ Type = "Spell", ID = 270669}),
    Equipoise                              = Action.Create({ Type = "Spell", ID = 286027}),
	-- PvP
	FrostNova                              = Action.Create({ Type = "Spell", ID = 122     }),
	Decurse                                = Action.Create({ Type = "Spell", ID = 475     }),
	CounterSpell                           = Action.Create({ Type = "Spell", ID = 2139     }),
	RingofFrost                            = Action.Create({ Type = "Spell", ID = 113724     }),
	Polymorph                              = Action.Create({ Type = "Spell", ID = 118     }),
	Slow                                   = Action.Create({ Type = "Spell", ID = 31589     }),
	TemporalShield                         = Action.Create({ Type = "Spell", ID = 198111     }),
	SpellSteal                             = Action.Create({ Type = "Spell", ID = 30449     }),
	PolymorphGreen                         = Action.Create({ Type = "Spell", ID = 118, Color = "GREEN", Desc = "GREEN" }),  -- AntiFakeCC
    -- Covenant Abilities
    RadiantSpark                           = Action.Create({ Type = "Spell", ID = 307443   }),
    MirrorsofTorment                       = Action.Create({ Type = "Spell", ID = 314793   }),
    Deathborne                             = Action.Create({ Type = "Spell", ID = 324220   }),
    ShiftingPower                          = Action.Create({ Type = "Spell", ID = 314791   }),
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
    KnotofAncientFury                      = Action.Create({ Type = "Trinket", ID = 166795 }),
    FirstMatesSpyglass                     = Action.Create({ Type = "Trinket", ID = 158163 }),
    VialofAnimatedBlood                    = Action.Create({ Type = "Trinket", ID = 159625 }),
    -- Misc
    Channeling                             = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),	-- Show an icon during channeling
    TargetEnemy                            = Action.Create({ Type = "Spell", ID = 44603, Hidden = true     }),	-- Change Target (Tab button)
    StopCast                               = Action.Create({ Type = "Spell", ID = 61721, Hidden = true     }),		-- spell_magic_polymorphrabbit
    CyclotronicBlast                       = Action.Create({ Type = "Spell", ID = 293491, Hidden = true}),
    ConcentratedFlameBurn                  = Action.Create({ Type = "Spell", ID = 295368, Hidden = true}),
    RazorCoralDebuff                       = Action.Create({ Type = "Spell", ID = 303568, Hidden = true     }),
    ConductiveInkDebuff                    = Action.Create({ Type = "Spell", ID = 302565, Hidden = true     }),
    -- Hidden Heart of Azeroth
    -- added all 3 ranks ids in case used by rotation
    VisionofPerfectionMinor                = Action.Create({ Type = "Spell", ID = 296320, Hidden = true}),
    VisionofPerfectionMinor2               = Action.Create({ Type = "Spell", ID = 299367, Hidden = true}),
    VisionofPerfectionMinor3               = Action.Create({ Type = "Spell", ID = 299369, Hidden = true}),
    UnleashHeartOfAzeroth                  = Action.Create({ Type = "Spell", ID = 280431, Hidden = true}),
    RecklessForceBuff                      = Action.Create({ Type = "Spell", ID = 302932, Hidden = true     }),	 
	StopCast                               = Action.Create({ Type = "Spell", ID = 61721, Hidden = true     }),		-- spell_magic_polymorphrabbit
	DummyTest                              = Action.Create({ Type = "Spell", ID = 159999, Hidden = true     }), -- Dummy stop dps icon 
	PoolResource                           = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),
	
	--Extra as replacement icons until loader updates
	Regeneratin							   = Action.Create({ Type = "Spell", ID = 291944 }), -- used for Touch of the Magi
	RocketJump							   = Action.Create({ Type = "Spell", ID = 69070 }), -- used for Mirror Image
	Darkflight							   = Action.Create({ Type = "Spell", ID = 68992 }), -- used for Heart of Azeroth
	
};

-- To create essences use next code:
Action:CreateEssencesFor(ACTION_CONST_MAGE_ARCANE)  -- where PLAYERSPEC is Constance (example: ACTION_CONST_MONK_BM)
local A = setmetatable(Action[ACTION_CONST_MAGE_ARCANE], { __index = Action })

------------------------------------------
---------------- VARIABLES ---------------
------------------------------------------
local VarConserveMana = 0
local VarFontDoubleOnUse = 0
local VarFontofPowerPrecombatChannel = 0
local VarTotalBurns = 0
local VarAverageBurnLength = 0

A.Listener:Add("ROTATION_VARS", "PLAYER_REGEN_ENABLED", function()
  VarConserveMana = 0
  VarFontDoubleOnUse = 0
  VarFontofPowerPrecombatChannel = 0
  VarTotalBurns = 0
  VarAverageBurnLength = 0
end)

local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end
local player = "player"
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
	return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "ARCANE") == 0
end 

local function InRange(unit)
	-- @return boolean 
	return A.ArcaneBlast:IsInRange(unit)
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


-- [1] CC AntiFake Rotation (FOCUS)
A[1] = function(icon)    
    local unit = "focus"
    local totalPoly = Unit("player"):CastTime(118) + GetCurrentGCD()
	local totalRoF = Unit("player"):CastTime(113724) + GetCurrentGCD()
	
    if A.PolymorphGreen:IsReady(nil, nil, nil, true) and 
    (
        IsUnitEnemy("focus") and
        A.Polymorph:IsInRange("focus") and
        -- Bear Form, Cat Form, Moonkin Form, Travel Form
        Unit("focus"):HasBuffs({5487, 768, 24858, 783}, true) == 0 and
        Unit(unit):HasBuffs("TotalImun") <= totalPoly and
        Unit(unit):HasBuffs("CCMagicImun") <= totalPoly and
        Unit(unit):HasBuffs("Reflect") <= totalPoly
    )
    then 
        return A.PolymorphGreen:Show(icon)         
    end     

    if A.RingofFrost:IsReady(nil, nil, nil, true) and 
    (
        IsUnitEnemy("focus") and
        A.RingofFrost:IsSpellLearned() and 
        A.Polymorph:IsInRange("focus") and
        (    
            -- Bear Form, Cat Form, Moonkin Form, Travel Form
            Unit("focus"):HasBuffs({5487, 768, 24858, 783}, true) > 0 or
            Unit(unit):HasBuffs("Reflect") > 0
        ) and
        Unit(unit):HasBuffs("TotalImun") <= totalRoF and
        Unit(unit):HasBuffs("CCMagicImun") <= totalRoF
    )
    then 
        return A.RingofFrost:Show(icon)         
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
            if not notKickAble and A.CounterSpell:IsReady(unit, nil, nil, true) and A.CounterSpell:AbsentImun(unit, Temp.TotalAndMag, true) then
                return A.CounterSpell:Show(icon)                                                  
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
    if not A.CounterSpell:IsReadyByPassCastGCD(unit) or not A.CounterSpell:AbsentImun(unit, Temp.TotalAndMagKick) then
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
        -- CounterSpell
        if useKick and not notInterruptable and A.CounterSpell:IsReady(unit) then 
            return A.CounterSpell
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
		
    -- TemporalShield
    if A.TemporalShield:IsReady(player) and 
    Unit(player):CombatTime() > 0 and
    A.TemporalShield:IsSpellLearned() and
    Unit(player):HasBuffs(198111, true)==0 and
    (
        (                
            FriendlyTeam("HEALER"):GetCC() > 0 and
            Unit(player):IsFocused() and
            Unit(player):Health() <= Unit(player):Health()*0.7 and
            Unit(player):TimeToDie()<13        
        ) or    
        Unit(player):UseDeff()
    )
    then 
        return A.TemporalShield
    end 
   
    -- Stoneform on self dispel (only PvE)
    if A.Stoneform:IsRacialReady(player, true) and not A.IsInPvP and A.AuraIsValid(player, "UseDispel", "Dispel") then 
        return A.Stoneform
    end 		
end 
SelfDefensives = A.MakeFunctionCachedDynamic(SelfDefensives)


-- Variables
TR.IFST = {
    CurrStacks = 0,
    CurrStacksTime = 0,
    OldStacks = 0,
    OldStacksTime = 0,
    Direction = 0
}

A.Listener:Add("ROTATION_VARS", "PLAYER_REGEN_ENABLED", function()
    TR.IFST.CurrStacks = 0
    TR.IFST.CurrStacksTime = 0
    TR.IFST.OldStacks = 0
    TR.IFST.OldStacksTime = 0
    TR.IFST.Direction = 0
end)

local function IFTracker()
    local TickDiff = TR.IFST.CurrStacksTime - TR.IFST.OldStacksTime
    local CurrStacks = TR.IFST.CurrStacks
    local CurrStacksTime = TR.IFST.CurrStacksTime
    local OldStacks = TR.IFST.OldStacks
	
	if Unit(player):CombatTime() == 0 then 
	    return
	end
		
    if Unit(player):HasBuffs(A.IncantersFlowBuff.ID, true) > 0 then
        if (Unit(player):HasBuffsStacks(A.IncantersFlowBuff.ID, true) ~= CurrStacks or (Unit(player):HasBuffsStacks(A.IncantersFlowBuff.ID, true) == CurrStacks and TickDiff > 1)) then
            TR.IFST.OldStacks = CurrStacks
            TR.IFST.OldStacksTime = CurrStacksTime
        end		
        TR.IFST.CurrStacks = Unit(player):HasBuffsStacks(A.IncantersFlowBuff.ID, true)
        TR.IFST.CurrStacksTime = Unit(player):CombatTime()		
        if TR.IFST.CurrStacks > TR.IFST.OldStacks then
            if TR.IFST.CurrStacks == 5 then
                TR.IFST.Direction = 0
            else
                TR.IFST.Direction = 1
            end
        elseif TR.IFST.CurrStacks < TR.IFST.OldStacks then
            if TR.IFST.CurrStacks == 1 then
                TR.IFST.Direction = 0
            else
                TR.IFST.Direction = -1
            end
        else
            if TR.IFST.CurrStacks == 1 then
                TR.IFST.Direction = 1
            else
                TR.IFST.Direction = -1
            end
        end
    else
        TR.IFST.OldStacks = 0
        TR.IFST.OldStacksTime = 0
        TR.IFST.CurrStacks = 0
        TR.IFST.CurrStacksTime = 0
        TR.IFST.Direction = 0
    end
end

-- Implementation of IncantersFlow simc reference incanters_flow_time_to.COUNT.DIRECTION
-- @parameter: COUNT between "1 - 5" 
-- @parameter: DIRECTION "up", "down" or "any"
local function IFTimeToX(count, direction)
    local low
    local high
    local buff_position
    if TR.IFST.Direction == -1 or (TR.IFST.Direction == 0 and TR.IFST.CurrStacks == 0) then
      buff_position = 10 - TR.IFST.CurrStacks + 1
    else
      buff_position = TR.IFST.CurrStacks
    end
    if direction == "up" then
        low = count
        high = count
    elseif direction == "down" then
        low = 10 - count + 1
        high = 10 - count + 1
    else
        low = count
        high = 10 - count + 1
    end
    if low == buff_position or high == buff_position then
        return 0
    end
    local ticks_low = (10 + low - buff_position) % 10
    local ticks_high = (10 + high - buff_position) % 10
    return (TR.IFST.CurrStacksTime - TR.IFST.OldStacksTime) + math.min(ticks_low, ticks_high) - 1
end

Player.ArcaneBurnPhase = {}
local BurnPhase = Player.ArcaneBurnPhase

function BurnPhase:Reset()
    self.state = false
    self.last_start = TMW.time
    self.last_stop = TMW.time
end
BurnPhase:Reset()

function BurnPhase:Start()
    if Unit("player"):CombatTime() > 0 then
        self.state = true
        self.last_start = TMW.time
    end
end

function BurnPhase:Stop()
    self.state = false
    self.last_stop = TMW.time
end

function BurnPhase:On()
    return self.state or 
	(
	    Unit("player"):CombatTime() == 0 and 
	    (
		    (
			    A.ArcanePower:GetCooldown() == 0 and A.Evocation:GetCooldown() <= VarAverageBurnLength and 
				(
				    Player:ArcaneChargesP() == Player:ArcaneChargesMax() 
				)
			)
		)
	)	
end

function BurnPhase:Duration()
    return self.state and (TMW.time - self.last_start) or 0
end

A.Listener:Add("ROTATION_VARS", "PLAYER_REGEN_DISABLED", function()
    BurnPhase:Reset()
end)

local function PresenceOfMindMax()
    return 2
end

local function ArcaneMissilesProcMax()
    return 3
end

function Player:ArcaneChargesP()
    return math.min(self:ArcaneCharges() + num(Unit("player"):IsCasting(A.ArcaneBlast)), 4)
end

--Burn
local function Burn(unit)

    -- variable,name=total_burns,op=add,value=1,if=!burn_phase
    if (not BurnPhase:On()) then
        VarTotalBurns = VarTotalBurns + 1
    end
	
    -- start_burn_phase,if=!burn_phase
    if (not BurnPhase:On()) and Player:ManaPercentageP() >= 50 then
	    --A.Toaster:SpawnByTimer("TripToast", 0, "Burn Phase", "Starting Burn Phase!", A.Evocation.ID)
        BurnPhase:Start()
    end
	
    -- stop_burn_phase,if=burn_phase&prev_gcd.1.evocation&target.time_to_die>variable.average_burn_length&burn_phase_duration>0
    if (BurnPhase:On() and (A.LastPlayerCastName == A.Evocation:Info() or Player:ManaPercentageP() < 50) and Unit(unit):TimeToDie() > VarAverageBurnLength and BurnPhase:Duration() > 0) then
		--A.Toaster:SpawnByTimer("TripToast", 0, "Conserve Phase", "Saving Mana!", A.Evocation.ID)
        BurnPhase:Stop()
    end
	
    -- charged_up,if=buff.arcane_charge.stack<=1
    if A.ChargedUp:IsReady(player) and (Player:ArcaneChargesP() <= 1) then
        return A.ChargedUp
    end
	
    -- mirror_image
    if A.MirrorImage:IsReady(player) and A.BurstIsON(unit) then
        return A.MirrorImage
    end
	
    -- nether_tempest,if=(refreshable|!ticking)&buff.arcane_charge.stack=buff.arcane_charge.max_stack&buff.rune_of_power.down&buff.arcane_power.down
    if A.NetherTempest:IsReady(unit) and ((Unit(unit):HasDeBuffs(A.NetherTempestDebuff.ID, true) < 5 or Unit(unit):HasDeBuffs(A.NetherTempestDebuff.ID, true) == 0) and Player:ArcaneChargesP() == Player:ArcaneChargesMax() and Unit("player"):HasBuffs(A.RuneofPowerBuff.ID, true) == 0 and Unit("player"):HasBuffs(A.ArcanePowerBuff.ID, true) == 0) then
        return A.NetherTempest
    end
	
    -- arcane_blast,if=buff.rule_of_threes.up&talent.overpowered.enabled&active_enemies<3
    if A.ArcaneBlast:IsReady(unit) and (Unit("player"):HasBuffs(A.RuleofThreesBuff.ID, true) > 0 and A.Overpowered:IsSpellLearned() and GetByRange(3, 40, false, true)) 	
	then
        return A.ArcaneBlast
    end
	
    -- lights_judgment,if=buff.arcane_power.down
    if A.LightsJudgment:IsReady(unit) and A.BurstIsON(unit) and (Unit("player"):HasBuffs(A.ArcanePowerBuff.ID, true) == 0) then
        return A.LightsJudgment
    end
	
    -- bag_of_tricks,if=buff.arcane_power.down
    if A.BagofTricks:AutoRacial(unit) and (Unit("player"):HasBuffs(A.ArcanePowerBuff.ID, true) == 0) then
        return A.BagofTricks
    end
	
    -- rune_of_power,if=!buff.arcane_power.up&(mana.pct>=50|cooldown.arcane_power.remains=0)&(buff.arcane_charge.stack=buff.arcane_charge.max_stack)
    if A.RuneofPower:IsReady(player) and (Unit("player"):HasBuffs(A.ArcanePowerBuff.ID, true) == 0 and (Player:ManaPercentageP() >= 50 or A.ArcanePower:GetCooldown() == 0) and (Player:ArcaneChargesP() == Player:ArcaneChargesMax())) then
        return A.RuneofPower
    end
	
    -- berserking
    if A.Berserking:AutoRacial(unit) and Action.GetToggle(1, "Racial") and A.BurstIsON(unit) then
        return A.Berserking
    end
	
    -- arcane_power
    if A.ArcanePower:IsReady(player) and Unit(player):CombatTime() > 0 and A.BurstIsON(unit) then
        return A.ArcanePower
    end
	
    -- use_items,if=buff.arcane_power.up|target.time_to_die<cooldown.arcane_power.remains
    -- blood_fury
    if A.BloodFury:AutoRacial(unit) and Action.GetToggle(1, "Racial") and A.BurstIsON(unit) then
        return A.BloodFury
    end
	
    -- fireblood
    if A.Fireblood:AutoRacial(unit) and Action.GetToggle(1, "Racial") and A.BurstIsON(unit) then
        return A.Fireblood
    end
	
    -- ancestral_call
    if A.AncestralCall:AutoRacial(unit) and Action.GetToggle(1, "Racial") and A.BurstIsON(unit) then
        return A.AncestralCall
    end
	
    -- presence_of_mind,if=(talent.rune_of_power.enabled&buff.rune_of_power.remains<=buff.presence_of_mind.max_stack*action.arcane_blast.execute_time)|buff.arcane_power.remains<=buff.presence_of_mind.max_stack*action.arcane_blast.execute_time
    if A.PresenceofMind:IsReady(player) and A.BurstIsON(unit) and 
	(
	    (
		    A.RuneofPower:IsSpellLearned() and Unit("player"):HasBuffs(A.RuneofPowerBuff.ID, true) <= PresenceOfMindMax() * A.ArcaneBlast:GetSpellCastTime()
		)
		or Unit("player"):HasBuffs(A.ArcanePowerBuff.ID, true) <= PresenceOfMindMax() * A.ArcaneBlast:GetSpellCastTime()
	)
	then
        return A.PresenceofMind
    end
	
    -- potion,if=buff.arcane_power.up&((!essence.condensed_lifeforce.major|essence.condensed_lifeforce.rank<2)&(buff.berserking.up|buff.blood_fury.up|!(race.troll|race.orc))|buff.guardian_of_azeroth.up)|target.time_to_die<cooldown.arcane_power.remains
    --if A.PotionofUnbridledFury:IsReady(unit) and Action.GetToggle(1, "Potion") and (Unit("player"):HasBuffs(A.ArcanePowerBuff.ID, true) and ((not Azerite:EssenceHasMajor(A.CondensedLifeforce.ID) or A.CondensedLifeforce:GetRank() < 2) and (Unit("player"):HasBuffs(A.BerserkingBuff.ID, true) or Unit("player"):HasBuffs(A.BloodFuryBuff.ID, true) or not (Unit("player"):IsRace("Troll") or Unit("player"):IsRace("Orc"))) or Unit("player"):HasBuffs(A.GuardianofAzerothBuff.ID, true)) or Unit(unit):TimeToDie() < A.ArcanePower:GetCooldown()) then
    --    A.PotionofUnbridledFury
    --end
	
    -- arcane_orb,if=buff.arcane_charge.stack=0|(active_enemies<3|(active_enemies<2&talent.resonance.enabled))
    if A.ArcaneOrb:IsReady(player) and (Player:ArcaneChargesP() == 0 or (GetByRange(3, 40, false, true) or (GetByRange(2, 40, false, true) and A.Resonance:IsSpellLearned()))) then
        return A.ArcaneOrb
    end
	
    -- arcane_barrage,if=active_enemies>=3&(buff.arcane_charge.stack=buff.arcane_charge.max_stack)
    if A.ArcaneBarrage:IsReady(unit) and (GetByRange(3, 40) and (Player:ArcaneChargesP() == Player:ArcaneChargesMax())) then
        return A.ArcaneBarrage
    end
	
    -- arcane_explosion,if=active_enemies>=3
    if A.ArcaneExplosion:IsReady(player) and A.GetToggle(2, "AoE") and MultiUnits:GetByRange(10) > 2 then
        return A.ArcaneExplosion
    end
	
    -- arcane_missiles,if=buff.clearcasting.react&active_enemies<3&(talent.amplification.enabled|(!talent.overpowered.enabled&azerite.arcane_pummeling.rank>=2)|buff.arcane_power.down),chain=1
    if A.ArcaneMissiles:IsReady(unit) and 
	(
	    Unit("player"):HasBuffs(A.ClearcastingBuff.ID, true) > 0 and GetByRange(3, 40, false, true) and 
		(
		    A.Amplification:IsSpellLearned() 
		    or 
		    (not A.Overpowered:IsSpellLearned() and A.ArcanePummeling:GetAzeriteRank() >= 2) 
		    or 
		    Unit("player"):HasBuffs(A.ArcanePowerBuff.ID, true) == 0
		)
	)
	then
        return A.ArcaneMissiles
    end
	
    -- arcane_blast,if=active_enemies<3
    if A.ArcaneBlast:IsReady(unit) and (GetByRange(3, 40, false, true)) then
        return A.ArcaneBlast
    end
	
    -- variable,name=average_burn_length,op=set,value=(variable.average_burn_length*variable.total_burns-variable.average_burn_length+(burn_phase_duration))%variable.total_burns
   -- if (true) then
  --      VarAverageBurnLength = (VarAverageBurnLength * VarTotalBurns - VarAverageBurnLength + (BurnPhase:Duration())) / VarTotalBurns
  --  end
	
    -- evocation,interrupt_if=mana.pct>=85,interrupt_immediate=1
    if A.Evocation:IsReady(player) and Player:ManaPercentageP() < 85 then 
        return A.Evocation
	else
	    if A.Evocation:GetSpellTimeSinceLastCast() < 5 and Player:ManaPercentageP() >= 85 then
	        return A.StopCast
		end
    end
	
    -- arcane_barrage
    if A.ArcaneBarrage:IsReady(unit) then
        return A.ArcaneBarrage
    end
	
end
Burn = A.MakeFunctionCachedDynamic(Burn)


local function MyDamageBuffs()
    return 
    Unit(player):HasBuffs({12042, 190319, 12472}, true) > 0 
	or
    Unit(player):HasBuffs("BurstHaste") > 0
end



--- ======= ACTION LISTS =======
-- [3] Single Rotation
A[3] = function(icon, isMulti)
    --------------------
    --- ROTATION VAR ---
    --------------------
    local isMoving = A.Player:IsMoving()
	local isMovingFor = A.Player:IsMovingTime()
    local inCombat = Unit("player"):CombatTime() > 0
    local combatTime = Unit("player"):CombatTime()
    local ShouldStop = Action.ShouldStop()
    local Pull = Action.BossMods:GetPullTimer()
	local TrinketsAoE = Action.GetToggle(2, "TrinketsAoE")
	local TrinketsMinTTD = Action.GetToggle(2, "TrinketsMinTTD")
	local TrinketsUnitsRange = Action.GetToggle(2, "TrinketsUnitsRange")
	local TrinketsMinUnits = Action.GetToggle(2, "TrinketsMinUnits")	
	local Trinket1IsAllowed, Trinket2IsAllowed = TR.TrinketIsAllowed()	
    -- Blink Handler
	local BlinkAny = A.Shimmer:IsSpellLearned() and A.Shimmer or A.Blink	
    
	-- Rotations Variables
	local BurnConditions = (Player:ManaPercentageP() >= 50)

	-- variable,name=average_burn_length
	VarAverageBurnLength = (VarAverageBurnLength * VarTotalBurns - VarAverageBurnLength + (BurnPhase:Duration())) / VarTotalBurns
			
    -- variable,name=conserve_mana,op=set,value=60+20*azerite.equipoise.enabled
    VarConserveMana = 60 + 20 * num(A.Equipoise:GetAzeriteRank() > 0)
		
    -- variable,name=font_double_on_use,op=set,value=equipped.azsharas_font_of_power&(equipped.gladiators_badge|equipped.gladiators_medallion|equipped.ignition_mages_fuse|equipped.tzanes_barkspines|equipped.azurethos_singed_plumage|equipped.ancient_knot_of_wisdom|equipped.shockbiters_fang|equipped.neural_synapse_enhancer|equipped.balefire_branch)
    VarFontDoubleOnUse = num(A.AzsharasFontofPower:IsExists() and (A.IgnitionMagesFuse:IsExists() or A.TzanesBarkspines:IsExists() or A.AncientKnotofWisdom:IsExists() or A.ShockbitersFang:IsExists() or A.NeuralSynapseEnhancer:IsExists() or A.BalefireBranch:IsExists()))
			
    -- variable,name=font_of_power_precombat_channel,op=set,value=12,if=variable.font_double_on_use&variable.font_of_power_precombat_channel=0
    if (bool(VarFontDoubleOnUse) and VarFontofPowerPrecombatChannel == 0) then
        VarFontofPowerPrecombatChannel = 12
    end
	
    ------------------------------------------------------
    ---------------- ENEMY UNIT ROTATION -----------------
    ------------------------------------------------------
    local function EnemyRotation(unit)
		
		-- Interrupts
        local Interrupt = Interrupts(unit)
        if inCombat and Interrupt then 
            return Interrupt:Show(icon)
        end 
		
        -- PvP Slow
		if A.Slow:IsReady(unit) and Unit(unit):IsPlayer() and Unit(unit):TimeToDie() > 6 and A.Slow:GetSpellTimeSinceLastCast() > 5 and A.IsInPvP and Unit(unit):HasDeBuffs(A.Slow.ID, true) == 0 then 
           return A.Slow:Show(icon)
        end	

        -- PvP SpellSteal Important Purje
		if A.SpellSteal:IsReady(unit) and Unit(unit):IsPlayer() and Unit(unit):TimeToDie() > 6 and A.SpellSteal:GetSpellTimeSinceLastCast() > 2 and A.IsInPvP and Unit(unit):HasBuffs("ImportantPurje") > 2 then 
           return A.SpellSteal:Show(icon)
        end	

        -- PvP SpellSteal Second Purje
		if A.SpellSteal:IsReady(unit) and Unit(unit):IsPlayer() and Unit(unit):TimeToDie() > 6 and A.SpellSteal:GetSpellTimeSinceLastCast() > 2 and A.IsInPvP and Unit(unit):HasBuffs("SecondPurje") > 2 then 
           return A.SpellSteal:Show(icon)
        end	
		
        -- PvP blink_any
        if BlinkAny:IsReady(unit) and A.LastPlayerCastName ~= BlinkAny:Info() and A.LastPlayerCastName == A.FrostNova:Info() and A.IsInPvP then
            return BlinkAny:Show(icon)
        end	
		
        -- PvP Combo Frost Nova into Blink
		if A.FrostNova:IsReady(player) and A.IsInPvP and 
		(
		    Unit(player):IsFocused("MELEE") and Unit(unit):UseBurst() 
			or 
			Unit(player):IsExecuted()
		)
		and Unit(unit):GetRange() <= 12 and UnitIsUnit("targettarget", "player")
		then 
           return A.FrostNova:Show(icon)
        end	
		
        -- PvP Force Arcane Missile
		if A.ArcaneMissiles:IsReady(unit) and Unit(unit):IsPlayer() and A.IsInPvP and (Unit(unit):HealthPercent() < 20 or Unit(unit):TimeToDie() < 3) then 
           return A.ArcaneMissiles:Show(icon)
        end	
		
        --Precombat
        if combatTime == 0 and not Player:IsMounted() and Unit(unit):IsExists() and unit ~= "mouseover" then
            -- flask
            -- food
            -- augmentation
            -- arcane_intellect
            if A.ArcaneIntellect:IsReady(player) and Unit("player"):HasBuffs(A.ArcaneIntellectBuff.ID, true) == 0 then
                return A.ArcaneIntellect:Show(icon)
            end
			
            -- arcane_familiar
            if A.ArcaneFamiliar:IsReady(player) and Unit("player"):HasBuffs(A.ArcaneFamiliarBuff.ID, true) == 0 then
                return A.ArcaneFamiliar:Show(icon)
            end
			
            -- snapshot_stats
            -- use_item,name=azsharas_font_of_power
            if A.AzsharasFontofPower:IsReady(player) then
                return A.AzsharasFontofPower:Show(icon)
            end
			
            -- mirror_image
            if A.MirrorImage:IsReady(player) and A.BurstIsON(unit) then
                return A.RocketJump:Show(icon)
            end
			
            -- potion
            if A.PotionofUnbridledFury:IsReady(unit) and Action.GetToggle(1, "Potion") then
                return A.PotionofUnbridledFury:Show(icon)
            end
			
            -- arcane_blast
            if A.ArcaneBlast:IsReady(unit) then
                return A.ArcaneBlast:Show(icon)
            end
        end

        -- call_action_list,name=essences
		if Unit("player"):GetLevel() < 60 then
			-- guardian_of_azeroth
			if A.GuardianofAzeroth:IsReady(unit) and BurstIsON then
				return A.Darkflight:Show(icon)
			end
			
			-- focused_azerite_beam
			if A.FocusedAzeriteBeam:IsReady(unit) and BurstIsON then
				return A.Darkflight:Show(icon)
			end
			
			-- memory_of_lucid_dreams
			if A.MemoryofLucidDreams:IsReady(unit) and BurstIsON then
				return A.Darkflight:Show(icon)
			end
			
			-- blood_of_the_enemy
			if A.BloodoftheEnemy:IsReady(unit) and BurstIsON then
				return A.Darkflight:Show(icon)
			end
			
			-- purifying_blast
			if A.PurifyingBlast:IsReady(unit) and BurstIsON then
				return A.Darkflight:Show(icon)
			end
			
			--[[ ripple_in_space
			if A.RippleInSpace:AutoHeartOfAzerothP(unit, true) and HeartOfAzeroth then
				return A.Darkflight:Show(icon)
			end]]
			
			-- concentrated_flame,line_cd=6
			if A.ConcentratedFlame:IsReady(unit) and BurstIsON then
				return A.Darkflight:Show(icon)
			end
			
			-- reaping_flames
			if A.ReapingFlames:IsReady(unit) and BurstIsON then
				return A.Darkflight:Show(icon)
			end
		end -- level 60 check
		
        -- use_item,name=azsharas_font_of_power,if=buff.rune_of_power.down&buff.arcane_power.down&(cooldown.arcane_power.remains<=4+10*variable.font_double_on_use&cooldown.evocation.remains<=variable.average_burn_length+4+10*variable.font_double_on_use|time_to_die<cooldown.arcane_power.remains)
        if A.AzsharasFontofPower:IsReady(player) and 
		(
		    Unit("player"):HasBuffs(A.RuneofPowerBuff.ID, true) == 0 and Unit("player"):HasBuffs(A.ArcanePowerBuff.ID, true) == 0 and 
			(
			    A.ArcanePower:GetCooldown() <= 4 + 10 * VarFontDoubleOnUse and A.Evocation:GetCooldown() <= VarAverageBurnLength + 4 + 10 * VarFontDoubleOnUse 
				or
				Unit(unit):TimeToDie() < A.ArcanePower:GetCooldown()
			)
		)
		then
            return A.AzsharasFontofPower:Show(icon)
        end

		-- Non SIMC Custom Trinket1
		if A.Trinket1:IsReady(unit) and ((TrinketOnlyBurst and A.BurstIsON(unit)) or (not TrinketOnlyBurst and not A.BurstIsON(unit))) and Trinket1IsAllowed and inCombat and CanCast and Unit(unit):GetRange() < 6 and    
		(
			TrinketsAoE and GetByRange(TrinketsMinUnits, TrinketsUnitsRange) and Player:AreaTTD(TrinketsUnitsRange) > TrinketsMinTTD
			or
			not TrinketsAoE and Unit(unit):TimeToDie() >= TrinketsMinTTD 					
		)
		then 
			return A.Trinket1:Show(icon)
		end 		
				
		-- Non SIMC Custom Trinket2
		if A.Trinket2:IsReady(unit) and ((TrinketOnlyBurst and A.BurstIsON(unit)) or (not TrinketOnlyBurst and not A.BurstIsON(unit))) and Trinket2IsAllowed and inCombat and CanCast and Unit(unit):GetRange() < 6 and	    
		(
			TrinketsAoE and GetByRange(TrinketsMinUnits, TrinketsUnitsRange) and Player:AreaTTD(TrinketsUnitsRange) > TrinketsMinTTD
			or
			not TrinketsAoE and Unit(unit):TimeToDie() >= TrinketsMinTTD 					
		)
		then
			return A.Trinket2:Show(icon) 	
		end            

        -- Manually added: arcane_barrage,if=cooldown.touch_of_the_magi.up&cooldown.arcane_power.up&buff.arcane_charge.stack>0&cooldown.evocation.remains<=variable.average_burn_length
        if A.ArcaneBarrage:IsReady(unit) and (A.TouchoftheMagi:GetCooldown() == 0 and A.ArcanePower:GetCooldown() == 0 and Player:ArcaneChargesP() > 0 and A.Evocation:GetCooldown() <= VarAverageBurnLength) then
            return A.ArcaneBarrage:Show(icon)
        end
		
        -- Manually added: touch_of_the_magi,if=cooldown.arcane_power.up&buff.arcane_charge.stack=0&cooldown.evocation.remains<=variable.average_burn_length
        if A.TouchoftheMagi:IsReady(unit) and (A.ArcanePower:GetCooldown() == 0 and Player:ArcaneChargesP() == 0 and A.Evocation:GetCooldown() <= VarAverageBurnLength) then
            return A.Regeneratin:Show(icon)
        end
		
        -- Burn
        local Burn = Burn(unit)
	    -- call_action_list,name=burn,if=burn_phase|target.time_to_die<variable.average_burn_length
        if inCombat and Burn and (BurnPhase:On() or Unit(unit):TimeToDie() < VarAverageBurnLength) then
            return Burn:Show(icon)
        end
		
        -- call_action_list,name=burn,if=(cooldown.arcane_power.remains=0&cooldown.evocation.remains<=variable.average_burn_length&(buff.arcane_charge.stack=buff.arcane_charge.max_stack|(talent.charged_up.enabled&cooldown.charged_up.remains=0&buff.arcane_charge.stack<=1)))
        if inCombat and Burn and 
		(
		    (
			    A.ArcanePower:GetCooldown() == 0 and A.Evocation:GetCooldown() <= VarAverageBurnLength and 
				(
				    Player:ArcaneChargesP() == Player:ArcaneChargesMax() 
				)
			)
		)
		then
            return Burn:Show(icon)
        end
			
        -- call_action_list,name=conserve,if=!burn_phase
        if inCombat and not BurnPhase:On() then
            -- mirror_image
            if A.MirrorImage:IsReady(player) and A.BurstIsON(unit) then
                return A.RocketJump:Show(icon)
            end

            -- Manually added: touch_of_the_magi,if=cooldown.arcane_power.remains>45&buff.arcane_charge.stack=0
            if A.TouchoftheMagi:IsReady(unit) and (A.ArcanePower:GetCooldown() > 45 and Player:ArcaneChargesP() == 0) then
              	return A.Regeneratin:Show(icon)
            end
			
            -- nether_tempest,if=(refreshable|!ticking)&buff.arcane_charge.stack=buff.arcane_charge.max_stack&buff.rune_of_power.down&buff.arcane_power.down
            if A.NetherTempest:IsReady(unit) and ((Unit(unit):HasDeBuffsRefreshable(A.NetherTempestDebuff.ID, true) or Unit(unit):HasDeBuffs(A.NetherTempestDebuff.ID, true) == 0) and Player:ArcaneChargesP() == Player:ArcaneChargesMax() and Unit("player"):HasBuffs(A.RuneofPowerBuff.ID, true) == 0 and Unit("player"):HasBuffs(A.ArcanePowerBuff.ID, true) == 0) then
                return A.NetherTempest:Show(icon)
            end
			
            -- arcane_orb,if=buff.arcane_charge.stack<=2&(cooldown.arcane_power.remains>10|active_enemies<=2)
            if A.ArcaneOrb:IsReady(player) and (Player:ArcaneChargesP() <= 2 and (A.ArcanePower:GetCooldown() > 10 or GetByRange(3, 40, false, true))) then
                return A.ArcaneOrb:Show(icon)
            end
			
            -- arcane_blast,if=buff.rule_of_threes.up&buff.arcane_charge.stack>3
            if A.ArcaneBlast:IsReady(unit) and (Unit("player"):HasBuffs(A.RuleofThreesBuff.ID, true) > 0 and Player:ArcaneChargesP() > 3) then
                return A.ArcaneBlast:Show(icon)
            end
			
            -- use_item,name=tidestorm_codex,if=buff.rune_of_power.down&!buff.arcane_power.react&cooldown.arcane_power.remains>20
            if A.TidestormCodex:IsReady(unit) and (Unit("player"):HasBuffs(A.RuneofPowerBuff.ID, true) == 0 and Unit("player"):HasBuffsStacks(A.ArcanePowerBuff.ID, true) == 0 and A.ArcanePower:GetCooldown() > 20) then
                return A.TidestormCodex:Show(icon)
            end
			
            -- use_item,effect_name=cyclotronic_blast,if=buff.rune_of_power.down&!buff.arcane_power.react&cooldown.arcane_power.remains>20
            if A.CyclotronicBlast:IsReady(unit) and (Unit("player"):HasBuffs(A.RuneofPowerBuff.ID, true) == 0 and Unit("player"):HasBuffsStacks(A.ArcanePowerBuff.ID, true) == 0 and A.ArcanePower:GetCooldown() > 20) then
                return A.CyclotronicBlast:Show(icon)
            end
			
            -- rune_of_power,if=buff.arcane_charge.stack=buff.arcane_charge.max_stack&(full_recharge_time<=execute_time|full_recharge_time<=cooldown.arcane_power.remains|target.time_to_die<=cooldown.arcane_power.remains)
            if A.RuneofPower:IsReady(player) and 
			(
			    Player:ArcaneChargesP() == Player:ArcaneChargesMax() and 
				(
				    A.RuneofPower:GetSpellChargesFullRechargeTime() <= A.RuneofPower:GetSpellCastTime() 
					or
					A.RuneofPower:GetSpellChargesFullRechargeTime() <= A.ArcanePower:GetCooldown() 
					or
					Unit(unit):TimeToDie() <= A.ArcanePower:GetCooldown()
				)
			)
			then
                return A.RuneofPower:Show(icon)
            end
			
            -- arcane_missiles,if=mana.pct<=95&buff.clearcasting.react&active_enemies<3,chain=1
            if A.ArcaneMissiles:IsReady(unit) and 
			(
			    Player:ManaPercentageP() <= 95 and Unit("player"):HasBuffs(A.ClearcastingBuff.ID, true) > 0 and GetByRange(3, 40, false, true)
			)
			then
                return A.ArcaneMissiles:Show(icon)
            end
			
            -- arcane_barrage,if=((buff.arcane_charge.stack=buff.arcane_charge.max_stack)&((mana.pct<=variable.conserve_mana)|(talent.rune_of_power.enabled&cooldown.arcane_power.remains>cooldown.rune_of_power.full_recharge_time&mana.pct<=variable.conserve_mana+25))|(talent.arcane_orb.enabled&cooldown.arcane_orb.remains<=gcd&cooldown.arcane_power.remains>10))|mana.pct<=(variable.conserve_mana-10)
            if A.ArcaneBarrage:IsReady(unit) and 
			(
			    (
				    (
					    Player:ArcaneChargesP() == Player:ArcaneChargesMax()) and 
						(
						    (
							    Player:ManaPercentageP() <= VarConserveMana
							) 
						    or 
						    (A.RuneofPower:IsSpellLearned() and A.ArcanePower:GetCooldown() > A.RuneofPower:GetSpellChargesFullRechargeTime() and Player:ManaPercentageP() <= VarConserveMana + 25)
					    ) 
						or 
						(A.ArcaneOrb:IsSpellLearned() and A.ArcaneOrb:GetCooldown() <= A.GetGCD() and A.ArcanePower:GetCooldown() > 10)
				)
				or Player:ManaPercentageP() <= (VarConserveMana - 10)
			)
			then
                return A.ArcaneBarrage:Show(icon)
            end
			
            -- supernova,if=mana.pct<=95
            if A.Supernova:IsReady(unit) and (Player:ManaPercentageP() <= 95) then
                return A.Supernova:Show(icon)
            end
			
            -- arcane_explosion,if=active_enemies>=3&(mana.pct>=variable.conserve_mana|buff.arcane_charge.stack=3)
            if A.ArcaneExplosion:IsReady(player) and A.GetToggle(2, "AoE") and 
			(
			    MultiUnits:GetByRange(10) > 2 and 
			    (
			        Player:ManaPercentageP() >= VarConserveMana 
				    or 
				    Player:ArcaneChargesP() == 3
			    )
			) 
			then
                return A.ArcaneExplosion:Show(icon)
            end
			
            -- arcane_blast
            if A.ArcaneBlast:IsReady(unit) then
                return A.ArcaneBlast:Show(icon)
            end
			
            -- arcane_barrage
            if A.ArcaneBarrage:IsReady(unit) then
                return A.ArcaneBarrage:Show(icon)
            end
        end
	
        -- call_action_list,name=movement
        -- blink_any,if=movement.distance>=10
        if BlinkAny:IsReady(unit) and (Unit(unit):GetRange() > 40) and not A.IsInPvP then
            return BlinkAny:Show(icon)
        end
		
        -- presence_of_mind
        if A.PresenceofMind:IsReady(player) and inCombat and A.BurstIsON(unit) then
            return A.PresenceofMind:Show(icon)
        end
		
        -- arcane_missiles
        if A.ArcaneMissiles:IsReady(unit) then
            return A.ArcaneMissiles:Show(icon)
        end
		
        -- arcane_orb
        if A.ArcaneOrb:IsReady(player) then
            return A.ArcaneOrb:Show(icon)
        end
		
        -- supernova
        if A.Supernova:IsReady(unit) then
            return A.Supernova:Show(icon)
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
-- Passive 
local function ArenaRotation(icon, unit)
			
    if A.IsInPvP and (A.Zone == "pvp" or A.Zone == "arena") and not Player:IsStealthed() and not Player:IsMounted() then
        -- Note: "arena1" is just identification of meta 6
        if (unit == "arena1" or unit == "arena2" or unit == "arena3") then  
			-- Interrupt
   		    local Interrupt = Interrupts(unit)
  		    if Interrupt then 
  		        return Interrupt:Show(icon)
  		    end	
        end
    end 
			
	-- @Arena Frost Nova
    if A.FrostNova:IsReady(player) and A.Zone == "arena" and not EnemyTeam():IsBreakAble(12) and
    (   
        (
            not UnitIsUnit(unit, "target") and
            not MyDamageBuffs() 
        ) 
		or    
        (
            Unit(unit):HasBuffs("DamageBuffs") > 0 and
            (
                Unit(unit):IsMelee() 
				or
                Unit(unit):IsHealer() 
            )
        )    
    ) and
    Unit(unit):GetRange() <= 12 and 
    Unit(unit):GetCurrentSpeed() >= 100 and
    Unit(unit):HasBuffs("Freedom") == 0 and 
    Unit(unit):HasBuffs("TotalImun") == 0 and 
    Unit(unit):HasBuffs({31224, 48707, 204018, 227847, 213610}, true) == 0
    then
	    return A.FrostNova:Show(icon)
	end

	
	
end 

--[[local function PartyRotation(unit)
    if (unit == "party1" and not A.GetToggle(2, "PartyUnits")[1]) or (unit == "party2" and not A.GetToggle(2, "PartyUnits")[2]) then 
        return false 
    end

  	-- Decurse Party1 & 2
    if A.Decurse:IsReady(unit) and A.Decurse:AbsentImun(unit, Temp.TotalAndMag) and Unit(unit):HasDeBuffs("Curse") > 0 then
        return A.Decurse
    end
end ]]
  
A[6] = nil

A[7] = nil

A[8] = nil
