--##################################
--###### TRIP'S SHADOW PRIEST ######
--##################################

local _G, setmetatable                            = _G, setmetatable
local A                                         = _G.Action
local Listener                                    = Action.Listener
local Create                                    = Action.Create
local GetToggle                                    = Action.GetToggle
local SetToggle                                    = Action.SetToggle
local GetGCD                                    = Action.GetGCD
local GetCurrentGCD                                = Action.GetCurrentGCD
local GetPing                                    = Action.GetPing
local ShouldStop                                = Action.ShouldStop
local BurstIsON                                    = Action.BurstIsON
local AuraIsValid                                = Action.AuraIsValid
local InterruptIsValid                            = Action.InterruptIsValid
local FrameHasSpell                                = Action.FrameHasSpell
local Azerite                                    = LibStub("AzeriteTraits")
local Utils                                        = Action.Utils
local TeamCache                                    = Action.TeamCache
local EnemyTeam                                    = Action.EnemyTeam
local FriendlyTeam                                = Action.FriendlyTeam
local LoC                                        = Action.LossOfControl
local Player                                    = Action.Player 
local MultiUnits                                = Action.MultiUnits
local UnitCooldown                                = Action.UnitCooldown
local Unit                                        = Action.Unit 
local IsUnitEnemy                                = Action.IsUnitEnemy
local IsUnitFriendly                            = Action.IsUnitFriendly
local ActiveUnitPlates                            = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
local TR                                        = Action.TasteRotation
local pairs                                     = pairs
local Pet                                       = LibStub("PetLibrary")

--Toaster stuff
local ADDON_NAME, private														= ...
local _G, unpack, type, math, pairs, error, next, setmetatable, select, rawset	= _G, unpack, type, math, pairs, error, next, setmetatable, select, rawset
local tremove																	= table.remove
local math_floor																= math.floor
local math_huge																	= math.huge
local math_max																	= math.max
local wipe																		= _G.wipe
local hooksecurefunc															= _G.hooksecurefunc
local CopyTable																	= _G.CopyTable
local UIParent																	= _G.UIParent
local Toaster																	= _G.Toaster -- The Action _G.Toaster will be initilized first, then _G.Toaster will be replaced by original if Toaster addon will be loaded, but we will keep our local
local LibStub																	= _G.LibStub
local GetSpellTexture 															= _G.TMW.GetSpellTexture
local AceDB 																	= LibStub("AceDB-3.0", true)
local AceConfigRegistry 														= LibStub("AceConfigRegistry-3.0", true)	
local AceConfigDialog 															= LibStub("AceConfigDialog-3.0", true)	
local AceLocale																	= LibStub("AceLocale-3.0", true)
local LibWindow 																= LibStub("LibWindow-1.1", true)
local LibToast 																	= LibStub("LibToast-1.0", true)
local templates																	= LibToast and LibToast.templates
local unique_templates															= LibToast and LibToast.unique_templates
local active_toasts																= LibToast and LibToast.active_toasts
local DEFAULT_FADE_HOLD_TIME													= 5
local DEFAULT_WIDTH																= 250
local DEFAULT_HEIGHT															= 50

local TMW 																		= _G.TMW

local toStr 																	= A.toStr
local toNum 																	= A.toNum 
local CONST 																	= A.Const
local Listener																	= A.Listener
local FormatGameLocale															= A.FormatGameLocale
local FormatedGameLocale														= A.FormatedGameLocale
local Unit 																		= A.Unit 

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

-- Spells
Action[ACTION_CONST_PRIEST_SHADOW] = {
    -- Racial
    ArcaneTorrent                          = Action.Create({ Type = "Spell", ID = 50613 }),
    BloodFury                              = Action.Create({ Type = "Spell", ID = 20572 }),
    Fireblood                              = Action.Create({ Type = "Spell", ID = 265221 }),
    AncestralCall                          = Action.Create({ Type = "Spell", ID = 274738 }),
    Berserking                             = Action.Create({ Type = "Spell", ID = 26297 }),
    ArcanePulse                            = Action.Create({ Type = "Spell", ID = 260364 }),
    QuakingPalm                            = Action.Create({ Type = "Spell", ID = 107079 }),
    Haymaker                               = Action.Create({ Type = "Spell", ID = 287712 }), 
    WarStomp                               = Action.Create({ Type = "Spell", ID = 20549 }),
    BullRush                               = Action.Create({ Type = "Spell", ID = 255654 }),    
    GiftofNaaru                            = Action.Create({ Type = "Spell", ID = 59544 }),
    Shadowmeld                             = Action.Create({ Type = "Spell", ID = 58984 }), -- usable in Action Core 
    Stoneform                              = Action.Create({ Type = "Spell", ID = 20594 }), 
    WilloftheForsaken                      = Action.Create({ Type = "Spell", ID = 7744  }), -- not usable in APL but user can Queue it    
    EscapeArtist                           = Action.Create({ Type = "Spell", ID = 20589 }), -- not usable in APL but user can Queue it
    EveryManforHimself                     = Action.Create({ Type = "Spell", ID = 59752 }), -- not usable in APL but user can Queue it
    Darkflight                             = Action.Create({ Type = "Spell", ID = 68992    }),
    -- Generics
    Shadowfiend                            = Action.Create({ Type = "Spell", ID = 34433 }),
    -- Mindbender                             = Action.Create({ Type = "Spell", ID = 200174 }),
    SurrenderToMadness                     = Action.Create({ Type = "Spell", ID = 319952 }),
    VampiricTouch                          = Action.Create({ Type = "Spell", ID = 34914 }),
    ShadowWordPain                         = Action.Create({ Type = "Spell", ID = 589 }),
    MindBlast                              = Action.Create({ Type = "Spell", ID = 8092 }),
    MindFlay                               = Action.Create({ Type = "Spell", ID = 15407 }),
    MindSear                               = Action.Create({ Type = "Spell", ID = 48045 }),
    VoidEruption                           = Action.Create({ Type = "Spell", ID = 228260 }),
    VoidBolt                               = Action.Create({ Type = "Spell", ID = 205448 }),
    ShadowCrash                            = Action.Create({ Type = "Spell", ID = 342834 }),
    ShadowWordDeath                        = Action.Create({ Type = "Spell", ID = 32379 }),
    VoidTorrent                            = Action.Create({ Type = "Spell", ID = 263165 }),
    Misery                                 = Action.Create({ Type = "Spell", ID = 238558, Hidden = true }),
    Shadowform                             = Action.Create({ Type = "Spell", ID = 232698 }),
    ChorusofInsanity                       = Action.Create({ Type = "Spell", ID = 278661 }),
    VoidformBuff                           = Action.Create({ Type = "Spell", ID = 194249, Hidden = true }),    
    VampiricTouchDebuff                    = Action.Create({ Type = "Spell", ID = 34914, Hidden = true }),
    ShadowWordPainDebuff                   = Action.Create({ Type = "Spell", ID = 589, Hidden = true }),
    WeakenedSoulDebuff                     = Action.Create({ Type = "Spell", ID = 6788, Hidden = true }),
    Damnation                              = Action.Create({ Type = "Spell", ID = 341374}),
    UnfurlingDarknessBuff                  = Action.Create({ Type = "Spell", ID = 341282, Hidden = true}),
	UnfurlingDarknessTalent				   = Action.Create({ Type = "Spell", ID = 341273, Hidden = true}), 
    SearingNightmare                       = Action.Create({ Type = "Spell", ID = 341385}),
    PsychicLink                            = Action.Create({ Type = "Spell", ID = 199484}),
    PowerInfusion                          = Action.Create({ Type = "Spell", ID = 10060}),
    DevouringPlague                        = Action.Create({ Type = "Spell", ID = 335467}),
	DarkThought							   = Action.Create({ Type = "Spell", ID = 341207, Hidden = true }),
	HungeringVoid						   = Action.Create({ Type = "Spell", ID = 345128, Hidden = true }),
	TwistofFateBuff						   = Action.Create({ Type = "Spell", ID = 123254, Hidden = true }),
	TwistofFateTalent					   = Action.Create({ Type = "Spell", ID = 109142, Hidden = true }),
	ShadowCrashDebuff					   = Action.Create({ Type = "Spell", ID = 342835, Hidden = true }),
	BodyAndSoul							   = Action.Create({ Type = "Spell", ID = 64129, Hidden = true }),
--    DevouringPlagueDebuff                  = Action.Create({ Type = "Spell", ID = 335467, Hidden = true}),
    -- PvP   
    Silence                                = Action.Create({ Type = "Spell", ID = 15487 }),    
    PsychicScream                          = Action.Create({ Type = "Spell", ID = 8122   }), -- Fear
    PsychicHorror                          = Action.Create({ Type = "Spell", ID = 64044 }), -- Fear + Disarm
    -- Covenant Abilities
    AscendedBlast                          = Action.Create({ Type = "Spell", ID = 325283}), 
    AscendedNova                           = Action.Create({ Type = "Spell", ID = 325020}), 
    BoonoftheAscended                      = Action.Create({ Type = "Spell", ID = 325013}), 
    --    BoonoftheAscendedBuff                  = Action.Create({ Type = "Spell", ID = 325013}), 
    FaeGuardians                           = Action.Create({ Type = "Spell", ID = 327661}), 
    Mindgames                              = Action.Create({ Type = "Spell", ID = 323673}), 
    UnholyNova                             = Action.Create({ Type = "Spell", ID = 324724}), 
    -- Conduit Effects
    DissonantEchoesBuff                    = Action.Create({ Type = "Spell", ID = 343144}), 
    -- Utilities 
    PowerWordFortitude                     = Action.Create({ Type = "Spell", ID = 21562 }),    -- Shield
    DispelMagic                            = Action.Create({ Type = "Spell", ID = 528,   }),    
    -- Defensives
    PowerWordShield                        = Action.Create({ Type = "Spell", ID = 17    }), 
    VampiricEmbrace                        = Action.Create({ Type = "Spell", ID = 15286 }),
    Dispersion                             = Action.Create({ Type = "Spell", ID = 47585 }),    
    -- Oils
    EmbalmersOil                           = Action.Create({ Type = "Spell", ID = 171286, QueueForbidden = true }), 
    ShadowcoreOil                          = Action.Create({ Type = "Spell", ID = 171285, QueueForbidden = true }),  
    -- Potions
    -- stats
    PotionofSpectralAgility                = Action.Create({ Type = "Potion", ID = 171270, QueueForbidden = true }), 
    PotionofSpectralIntellect              = Action.Create({ Type = "Potion", ID = 171273, QueueForbidden = true }), 
    PotionofSpectralStrength               = Action.Create({ Type = "Potion", ID = 171275, QueueForbidden = true }), 
    PotionofSpectralStamina                = Action.Create({ Type = "Potion", ID = 171274, QueueForbidden = true }), 
    -- heal
    SpiritualHealingPotion                 = Action.Create({ Type = "Potion", ID = 171267, QueueForbidden = true }), 
    SpiritualManaPotion                    = Action.Create({ Type = "Potion", ID = 171268, QueueForbidden = true }), 
    SpiritualRejuvenationPotion            = Action.Create({ Type = "Potion", ID = 171269, QueueForbidden = true }), 
    PotionofSpiritualClarity               = Action.Create({ Type = "Potion", ID = 171272, QueueForbidden = true }), 
    -- combat effects potions
    PotionofDeathlyFixation                = Action.Create({ Type = "Potion", ID = 171351, QueueForbidden = true }), 
    PotionofEmpoweredExorcisms             = Action.Create({ Type = "Potion", ID = 171352, QueueForbidden = true }),
    PotionofPhantomFire                    = Action.Create({ Type = "Potion", ID = 171349, QueueForbidden = true }),
    PotionofDivineAwakening                = Action.Create({ Type = "Potion", ID = 171350, QueueForbidden = true }),
    PotionofSacrificialAnima               = Action.Create({ Type = "Potion", ID = 176811, QueueForbidden = true }),
    -- utilities potions
    PotionofHardenedShadows                = Action.Create({ Type = "Potion", ID = 171271, QueueForbidden = true }),
    PotionofShadedSight                    = Action.Create({ Type = "Potion", ID = 171264, QueueForbidden = true }),
    PotionofSoulPurity                     = Action.Create({ Type = "Potion", ID = 171263, QueueForbidden = true }),
    PotionofSpecterSwiftness               = Action.Create({ Type = "Potion", ID = 171370, QueueForbidden = true }),
    PotionoftheHiddenSpirit                = Action.Create({ Type = "Potion", ID = 171266, QueueForbidden = true }),
    PotionofthePsychopompsSpeed            = Action.Create({ Type = "Potion", ID = 184090, QueueForbidden = true }),
    PotionofUnhinderedPassing              = Action.Create({ Type = "Potion", ID = 183823, QueueForbidden = true }),
    -- Nathria Trinkets
    SanguineVintage                        = Action.Create({ Type = "Trinket", ID = 184031 }),
    ManaboundMirror                        = Action.Create({ Type = "Trinket", ID = 184029 }),
    GluttonousSpike                        = Action.Create({ Type = "Trinket", ID = 184023 }),
    DreadfireVessel                        = Action.Create({ Type = "Trinket", ID = 184030 }),
    MemoryofPastSins                       = Action.Create({ Type = "Trinket", ID = 184025 }),
    ConsumptiveInfusion                    = Action.Create({ Type = "Trinket", ID = 184022 }),
    StoneLegionHeraldry                    = Action.Create({ Type = "Trinket", ID = 184027 }),
    BargastsLeash                          = Action.Create({ Type = "Trinket", ID = 184017 }),
    -- OP Dungeons Trinkets
    BloodSpatteredScale                    = Action.Create({ Type = "Trinket", ID = 179331 }),
    OverwhelmingPowerCrystal               = Action.Create({ Type = "Trinket", ID = 179342 }),
    SunbloodAmethyst                       = Action.Create({ Type = "Trinket", ID = 178826 }),
    PulsatingStoneheart                    = Action.Create({ Type = "Trinket", ID = 178825 }),
    BladedancersArmorKit                   = Action.Create({ Type = "Trinket", ID = 178862 }),  
    
    -- Legendaries
    PainbreakerPsalmChest                  = Action.Create({ Type = "Spell", ID = 173241 }),
    PainbreakerPsalmCloak                  = Action.Create({ Type = "Spell", ID = 173242 }),
    CalltotheVoidGloves                    = Action.Create({ Type = "Spell", ID = 173244 }),
    CalltotheVoidWrists                    = Action.Create({ Type = "Spell", ID = 173249 }),
    -- Misc
    PoolResource                           = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),
    TargetEnemy                            = Action.Create({ Type = "Spell", ID = 44603, Hidden = true }),-- Change Target (Tab button)
    StopCast                               = Action.Create({ Type = "Spell", ID = 61721, Hidden = true }),    -- spell_magic_polymorphrabbit
    DummyTest                              = Action.Create({ Type = "Spell", ID = 159999, Hidden = true     }), -- Dummy stop dps icon
	ConcentratedFlame					   = Action.Create({ Type = "Spell", ID = 295373, }),

};

-- To create essences use next code:
Action:CreateEssencesFor(ACTION_CONST_PRIEST_SHADOW)  -- where PLAYERSPEC is Constance (example: ACTION_CONST_MONK_BM)
local A = setmetatable(Action[ACTION_CONST_PRIEST_SHADOW], { __index = Action })


------------------------------------------
---------------- VARIABLES ---------------
------------------------------------------
local VarDotsUp = false;
local VarAllDotsUp = false;
local VarMindSearCutoff = 1;
local VarSearingNightmareCutoff = false;
local PainbreakerEquipped = (A.PainbreakerPsalmChest:IsExists() or A.PainbreakerPsalmCloak:IsExists())
local CalltotheVoidEquipped = (A.CalltotheVoidGloves:IsExists() or A.CalltotheVoidWrists:IsExists())

A.Listener:Add("ROTATION_VARS", "PLAYER_REGEN_ENABLED", function()
        VarDotsUp = false
        VarAllDotsUp = false
        VarMindSearCutoff = 1
        VarSearingNightmareCutoff = false
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
    VampiricTouchDelay                      = 0,
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
    return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "SHADOW") == 0
end 

local function InRange(unit)
    -- @return boolean 
    return A.VampiricTouch:IsInRange(unit)
end 
InRange = A.MakeFunctionCachedDynamic(InRange)

local function GetByRange(count, range, isStrictlySuperior, isStrictlyInferior, isStrictlyEqual, isCheckEqual, isCheckCombat)
    -- @return boolean 
    local c = 0 
    
    if isStrictlySuperior == nil then
        isStrictlySuperior = false
    end
    
    if isStrictlyInferior == nil then
        isStrictlyInferior = false
    end    
    
    if isStrictlyEqual == nil then
        isStrictlyEqual = false
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
            if isStrictlySuperior and not isStrictlyInferior and not isStrictlyEqual then
                if c > count then
                    return true
                end
            end
            
            -- Strictly inferior <
            if isStrictlyInferior and not isStrictlySuperior and not isStrictlyEqual then
                if c < count then
                    return true
                end
            end
            
            -- Strictly equal ==
            if not isStrictlyInferior and not isStrictlySuperior and isStrictlyEqual then
                if c == count then
                    return true
                end
            end    
            
            -- Classic >=
            if not isStrictlyInferior and not isStrictlySuperior and not isStrictlyEqual then
                if c >= count then 
                    return true 
                end 
            end
        end 
        
    end
    
end  
GetByRange = A.MakeFunctionCachedDynamic(GetByRange)

-- ExecuteRange
local function ExecuteRange()
    return 20
end

-- DotsUp
local function DotsUp(unitID, all)
    if all then
        return (Unit(unitID):HasDeBuffs(A.ShadowWordPainDebuff.ID, true) > 0 and Unit(unitID):HasDeBuffs(A.VampiricTouchDebuff.ID, true) > 0 and Unit(unitID):HasDeBuffs(A.DevouringPlague.ID, true) > 0)
    else
        return (Unit(unitID):HasDeBuffs(A.ShadowWordPainDebuff.ID, true) > 0 and Unit(unitID):HasDeBuffs(A.VampiricTouchDebuff.ID, true) > 0)
    end
end

-- Non GCD spell check
local function countInterruptGCD(unit)
    if not A.Silence:IsReadyByPassCastGCD(unit) or not A.Silence:AbsentImun(unit, Temp.TotalAndMagKick) then
        return true
    end
end

-- Interrupts spells
local function Interrupts(unit)

	useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))

    
    if castRemainsTime >= A.GetLatency() then
        -- Silence
        if useKick and A.Silence:IsReady(unit) and A.Silence:AbsentImun(unit, Temp.TotalAndMagKick, true) then 
            return A.Silence
        end 
        
        -- Fear Disarm
        if useCC and A.PsychicHorror:IsReady(unit) and A.PsychicHorror:AbsentImun(unit, Temp.TotalAndMagKick, true) and Unit(unit):IsControlAble("stun", 0) then 
            return A.PsychicHorror              
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

-- Defensives
local function SelfDefensives()
    if Unit(player):CombatTime() == 0 then  
        return 
    end
    
    local VampiricEmbrace = A.GetToggle(2, "VampiricEmbrace")
    if    VampiricEmbrace >= 0 and A.VampiricEmbrace:IsReady(player) and 
    (
        (     -- Auto 
            VampiricEmbrace >= 100 and 
            (
                (
                    not A.IsInPvP and 
                    Unit(player):HealthPercent() < 80 and 
                    Unit(player):TimeToDieX(20) < 8 
                ) or 
                (
                    A.IsInPvP and 
                    (
                        Unit(player):UseDeff() or 
                        (
                            Unit(player, 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused(nil, true)                                 
                        )
                    )
                )
            ) and 
            Unit(player):HasBuffs("DeffBuffs") == 0
        ) or 
        (    -- Custom
            VampiricEmbrace < 100 and 
            Unit(player):HealthPercent() <= VampiricEmbrace
        )
    ) 
    then 
        return A.VampiricEmbrace
    end 
end 
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

function Player:AreaTTD(range)
    local ttdtotal = 0
	local totalunits = 0
    local r = range
    
	for _, unitID in pairs(ActiveUnitPlates) do 
		if Unit(unitID):GetRange() <= r then 
			local ttd = Unit(unitID):TimeToDie()
			totalunits = totalunits + 1
			ttdtotal = ttd + ttdtotal
		end
	end
    
	if totalunits == 0 then
		return 0
	end
    
	return ttdtotal / totalunits
end	

-- Multidot Handler UI --
local function HandleMultidots()
    local choice = Action.GetToggle(2, "AutoDotSelection")
    
    if choice == "In Raid" then
        if IsInRaid() then
            return true
        else
            return false
        end
    elseif choice == "In Dungeon" then 
        if IsInGroup() then
            return true
        else
            return false
        end
    elseif choice == "In PvP" then     
        if A.IsInPvP then 
            return true
        else
            return false
        end        
    elseif choice == "Everywhere" then 
        return true
    else
        return false
    end
    --print(choice)
end


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
    local profileStop = false
    local DBM = Action.GetToggle(1, "BossMods")
    local HeartOfAzeroth = Action.GetToggle(1, "HeartOfAzeroth")
    local Racial = Action.GetToggle(1, "Racial")
    local Potion = Action.GetToggle(1, "Potion")
    local UnbridledFuryAuto = GetToggle(2, "UnbridledFuryAuto")
    local UnbridledFuryTTD = GetToggle(2, "UnbridledFuryTTD")
    local UnbridledFuryWithBloodlust = GetToggle(2, "UnbridledFuryWithBloodlust")
    local UnbridledFuryHP = GetToggle(2, "UnbridledFuryHP")
    local UnbridledFuryWithExecute = GetToggle(2, "UnbridledFuryWithExecute")
    local FocusedAzeriteBeamTTD = GetToggle(2, "FocusedAzeriteBeamTTD")
    local FocusedAzeriteBeamUnits = GetToggle(2, "FocusedAzeriteBeamUnits")
	local PWSMove = GetToggle(2, "PWSMove")
	local UsePWS = GetToggle(2, "UsePWS")
	local MultiDotDistance = GetToggle(2, "MultiDotDistance")
	local VTDelay = GetToggle(2, "VTDelay")
	local VTRefreshable = (Unit("target"):HasDeBuffs(A.VampiricTouchDebuff.ID, true) < 4 or Unit("target"):HasDeBuffs(A.VampiricTouchDebuff.ID, true) == 0)
	local SWPRefreshable = (Unit("target"):HasDeBuffs(A.ShadowWordPainDebuff.ID, true) < 4 or Unit("target"):HasDeBuffs(A.ShadowWordPainDebuff.ID, true) == 0)	
    -- Multidots var
    local MissingShadowWordPain = MultiUnits:GetByRangeMissedDoTs(MultiDotDistance, 5, A.ShadowWordPain.ID) --MultiDots(40, A.FlameShockDebuff, 15, 4) --MultiUnits:GetByRangeMissedDoTs(40, 10, 188389)  MultiUnits:GetByRangeMissedDoTs(range, stop, dots, ttd)
    local MissingVampiricTouch = MultiUnits:GetByRangeMissedDoTs(MultiDotDistance, 5, A.VampiricTouch.ID) --MultiDots(40, A.FlameShockDebuff, 15, 4) --MultiUnits:GetByRangeMissedDoTs(40, 10, 188389)  MultiUnits:GetByRangeMissedDoTs(range, stop, dots, ttd)
    local AppliedShadowWordPain = MultiUnits:GetByRangeAppliedDoTs(MultiDotDistance, 5, A.ShadowWordPain.ID) --MultiDots(40, A.FlameShockDebuff, 15, 4) --MultiUnits:GetByRangeMissedDoTs(40, 10, 188389)  MultiUnits:GetByRangeMissedDoTs(range, stop, dots, ttd)
    local AppliedVampiricTouch = MultiUnits:GetByRangeAppliedDoTs(MultiDotDistance, 5, A.VampiricTouch.ID) --MultiDots(40, A.FlameShockDebuff, 15, 4) --MultiUnits:GetByRangeMissedDoTs(40, 10, 188389)  MultiUnits:GetByRangeMissedDoTs(range, stop, dots, ttd)
    local ShadowWordPainToRefresh = MultiUnits:GetByRangeDoTsToRefresh(MultiDotDistance, 5, A.ShadowWordPain.ID, 6, 5)
    local VampiricTouchToRefresh = MultiUnits:GetByRangeDoTsToRefresh(MultiDotDistance, 5, A.VampiricTouch.ID, 6, 5)
    -- Trinkets vars
    local Trinket1IsAllowed, Trinket2IsAllowed = TR:TrinketIsAllowed()
    local TrinketsAoE = GetToggle(2, "TrinketsAoE")
    local TrinketsMinTTD = GetToggle(2, "TrinketsMinTTD")
    local TrinketsUnitsRange = GetToggle(2, "TrinketsUnitsRange")
    local TrinketsMinUnits = GetToggle(2, "TrinketsMinUnits")
    local StMActive = A.SurrenderToMadness:GetSpellTimeSinceLastCast() <= 25
    local VoidFormActive = Unit(player):HasBuffs(A.VoidformBuff.ID, true) > 0
    -- Azerite beam protection channel
    local CanCast = true
    local TotalCast, CurrentCastLeft, CurrentCastDone = Unit(player):CastTime()
    local _, castStartedTime, castEndTime = Unit(player):IsCasting()
    local secondsLeft, percentLeft, spellID, spellName, notInterruptable, isChannel = Unit(player):IsCastingRemains()
	local TargetsMissingSWP = MultiUnits:GetByRangeMissedDoTs(nil, 5, A.ShadowWordPainDebuff.ID)
	local TargetsMissingVT = MultiUnits:GetByRangeMissedDoTs(nil, 5, A.VampiricTouchDebuff.ID)	
	local AutoMultiDot = A.GetToggle(2, "AutoMultiDot")	
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
	
    if Temp.VampiricTouchDelay == 0 and Player:IsCasting() == "Vampiric Touch" then
        Temp.VampiricTouchDelay = VTDelay
    end
    
    if Temp.VampiricTouchDelay > 0 then
            --print(Temp.VampiricTouchDelay)
        Temp.VampiricTouchDelay = Temp.VampiricTouchDelay - 1
    end
    ------------------------------------------------------
    ---------------- ENEMY UNIT ROTATION -----------------
    ------------------------------------------------------
	
    local function EnemyRotation(unit)
        
		--Variables
        -- variable,name=dots_up,op=set,value=dot.shadow_word_pain.ticking&dot.vampiric_touch.ticking
        VarDotsUp = (Unit(unit):HasDeBuffs(A.ShadowWordPainDebuff.ID, true) > 4 and Unit(unit):HasDeBuffs(A.VampiricTouchDebuff.ID, true) > 4)

        VarAllDotsUp = (Unit(unit):HasDeBuffs(A.ShadowWordPainDebuff.ID, true) > 4 and Unit(unit):HasDeBuffs(A.VampiricTouchDebuff.ID, true) > 4 and Unit(unit):HasDeBuffs(A.DevouringPlague.ID, true) > 2)		
		
		--Toaster for Unfurling Darkness alert
		if Unit(player):HasBuffs(A.UnfurlingDarknessBuff.ID, true) > 0 then
		A.Toaster:SpawnByTimer("TripToast", 0, "Unfurling Darkness Active!", "Target a new enemy for instant-cast Vampiric Touch!", A.VampiricTouch.ID)
		end
		
		--actions.precombat+=/shadowform,if=!buff.shadowform.up
		if A.Shadowform:IsReady(unit) and Unit(player):HasBuffsDown(A.Shadowform.ID, true) and not VoidFormActive then
			return A.Shadowform:Show(icon)
		end
		
		local Interrupt = Interrupts(unit)
		if Interrupt then 
			return Interrupt:Show(icon)
		end			
		
		--actions.precombat+=/arcane_torrent
		if A.ArcaneTorrent:IsReady(unit) and useRacial and A.ArcaneTorrent:AutoRacial(unit) and Unit(player):CombatTime() == 0 then
			return A.ArcaneTorrent:Show(icon)
		end

			-- Auto Multi DoT
			if AutoMultiDot and (VarDotsUp and unit ~= mouseover) and Player:AreaTTD(40) > 8 and MultiUnits:GetActiveEnemies() >= 2 and (TargetsMissingSWP > 0 and TargetsMissingSWP < 5 or Unit("target"):IsDummy())
			then
				local SWP_Nameplates = MultiUnits:GetActiveUnitPlates()
				if SWP_Nameplates then  
					for SWP_UnitID in pairs(ActiveUnitPlates) do             
						if not UnitIsUnit(unit, SWP_UnitID) then 
							if (Unit(SWP_UnitID):HasDeBuffs(A.ShadowWordPainDebuff.ID, true) == 0 or Unit(SWP_UnitID):HasDeBuffs(A.ShadowWordPainDebuff.ID, true) < 4) and Unit(SWP_UnitID):GetRange() <= 40 and (not A.SearingNightmare:IsTalentLearned()) and ((A.Zone == "none" and (Unit(SWP_UnitID):IsDummy() or Unit(SWP_UnitID):IsDummyPvP())) or Unit(SWP_UnitID):CombatTime() > 0) then 
								return A:Show(icon, ACTION_CONST_AUTOTARGET)
							end
						elseif Unit(SWP_UnitID):GetRange() > 40 or (not (A.Zone == "none" and (Unit(SWP_UnitID):IsDummy() or Unit(SWP_UnitID):IsDummyPvP())) and Unit(SWP_UnitID):CombatTime() == 0) then -- forces to re-pick target if /targetenemy selected out of range or out of combat unit 
							return A:Show(icon, ACTION_CONST_AUTOTARGET)
						end         
					end 
				end         
			end 
			
			if AutoMultiDot and (VarDotsUp and unit ~= mouseover) and Player:AreaTTD(40) > 8 and MultiUnits:GetActiveEnemies() >= 2 and (TargetsMissingVT > 0 and TargetsMissingVT < 5 or Unit("target"):IsDummy())
			then
				local VT_Nameplates = MultiUnits:GetActiveUnitPlates()
				if VT_Nameplates then  
					for VT_UnitID in pairs(ActiveUnitPlates) do             
						if not UnitIsUnit(unit, VT_UnitID) then 
							if (Unit(VT_UnitID):HasDeBuffs(A.VampiricTouchDebuff.ID, true) == 0 or Unit(VT_UnitID):HasDeBuffs(A.VampiricTouchDebuff.ID, true) < 4) and Unit(VT_UnitID):GetRange() <= 40 and ((A.Zone == "none" and (Unit(VT_UnitID):IsDummy() or Unit(VT_UnitID):IsDummyPvP())) or Unit(VT_UnitID):CombatTime() > 0) then 
								return A:Show(icon, ACTION_CONST_AUTOTARGET)
							end
						elseif Unit(VT_UnitID):GetRange() > 40 or (not (A.Zone == "none" and (Unit(VT_UnitID):IsDummy() or Unit(VT_UnitID):IsDummyPvP())) and Unit(VT_UnitID):CombatTime() == 0) then -- forces to re-pick target if /targetenemy selected out of range or out of combat unit 
							return A:Show(icon, ACTION_CONST_AUTOTARGET)
						end         
					end 
				end         
			end	
		
		--MindBlast bypass MindFlay channel
		if A.MindBlast:IsReady(unit, nil, nil, A.GetToggle(2, "ByPassSpells")) and Unit("player"):HasBuffs(A.DarkThought.ID, true) > 0 and VarDotsUp and (not A.DevouringPlague:IsReady()) then
			return A.MindBlast:Show(icon)
		end

		-- vampiric_touch
		if A.VampiricTouch:IsReady(unit, nil, nil, A.GetToggle(2, "ByPassSpells")) and Temp.VampiricTouchDelay == 0 and (Unit("player"):HasBuffs(A.UnfurlingDarknessBuff.ID, true) > 0 and Unit("player"):HasBuffs(A.UnfurlingDarknessBuff.ID, true) < 3) then
			return A.VampiricTouch:Show(icon)
		end	
		
		--actions.precombat+=/vampiric_touch
		if A.VampiricTouch:IsReady(unit) and Temp.VampiricTouchDelay == 0 and Unit(player):CombatTime() == 0 and not A.Damnation:IsReady() and Unit(unit):HasDeBuffs(A.VampiricTouchDebuff.ID, true) == 0 then
			return A.VampiricTouch:Show(icon)
		end
		

		--actions+=/call_action_list,name=cwc
		--actions.cwc=searing_nightmare,use_while_casting=1,target_if=(variable.searing_nightmare_cutoff&!variable.pi_or_vf_sync_condition)|(dot.shadow_word_pain.refreshable&spell_targets.mind_sear>1)
		if A.SearingNightmare:IsReady(unit, nil, nil, A.GetToggle(2, "ByPassSpells")) and A.SearingNightmare:IsTalentLearned() and Player:IsChanneling() == "Mind Sear" -- or  MissingShadowWordPain > 2 
		then 
			return A.SearingNightmare:Show(icon)
		end	
		
		--actions+=/run_action_list,name=main

		--actions.main=void_eruption,if=variable.pi_or_vf_sync_condition&insanity>=40
		if A.VoidEruption:IsReady(unit, nil, nil, A.GetToggle(2, "ByPassSpells")) and Player:Insanity() >= 40 and not VoidFormActive and (not isMoving or StMActive) and Player:AreaTTD(40) > 15 then
			return A.VoidEruption:Show(icon)
		end	

		--actions.main+=/shadow_word_pain,if=buff.fae_guardians.up&!debuff.wrathful_faerie.up
		
		
		--actions.main+=/call_action_list,name=cds
		--Use Silence on CD if legendary equipped
		--[[Essence
		if A.ConcentratedFlame:IsReady(unit) and BurstIsON then
			return A.Darkflight:Show(icon)
		end]]

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
			
		--Trinkets
			-- Non SIMC Custom Trinket1
		if A.Trinket1:IsReady(unit) and Trinket1IsAllowed and    
		(
			TrinketsAoE and GetByRange(TrinketsMinUnits, TrinketsUnitsRange) and Player:AreaTTD(TrinketsUnitsRange) > TrinketsMinTTD
			or
			not TrinketsAoE and Unit(unit):TimeToDie() >= TrinketsMinTTD                     
		)
		then 
			return A.Trinket1:Show(icon)
		end         
		
		-- Non SIMC Custom Trinket2
		if A.Trinket2:IsReady(unit) and Trinket2IsAllowed and        
		(
			TrinketsAoE and GetByRange(TrinketsMinUnits, TrinketsUnitsRange) and Player:AreaTTD(TrinketsUnitsRange) > TrinketsMinTTD
			or
			not TrinketsAoE and Unit(unit):TimeToDie() >= TrinketsMinTTD                     
		)
		then
			return A.Trinket2:Show(icon)     
		end    

		if A.VampiricTouch:IsReady(unit, nil, nil, A.GetToggle(2, "ByPassSpells")) and Temp.VampiricTouchDelay == 0 and ((VTRefreshable and Unit(unit):TimeToDie() > 6) or (A.Misery:IsTalentLearned() and SWPRefreshable)) then
			return A.VampiricTouch:Show(icon)
		end			
		
		--actions.main+=/mind_sear,target_if=talent.searing_nightmare.enabled&spell_targets.mind_sear>(variable.mind_sear_cutoff+1)&!dot.shadow_word_pain.ticking&!cooldown.Shadowfiend.up
		if A.MindSear:IsReady(unit) and A.SearingNightmare:IsTalentLearned() and MultiUnits:GetActiveEnemies() > 3 and  Unit(unit):HasBuffs(A.ShadowWordPainDebuff.ID, true) == 0 and A.Shadowfiend:GetCooldown() > 0 and (not isMoving or StMActive)then
			return A.MindSear:Show(icon)
		end			

		--actions.main+=/damnation,target_if=!variable.all_dots_up
		if A.Damnation:IsReady(unit) and not VarAllDotsUp then
			return A.Damnation:Show(icon)
		end	
		--actions.main+=/void_bolt,if=insanity<=85&((talent.hungering_void.enabled&spell_targets.mind_sear<5)|spell_targets.mind_sear=1)
		if A.VoidBolt:IsReady(unit, nil, nil, A.GetToggle(2, "ByPassSpells")) and VoidFormActive and Player:Insanity() <= 85 and ((A.HungeringVoid:IsSpellLearned() and MultiUnits:GetActiveEnemies() < 5) or MultiUnits:GetActiveEnemies() < 2) then
			return A.VoidBolt:Show(icon)
		end	

		--actions.main+=/devouring_plague,target_if=(refreshable|insanity>75)&!variable.pi_or_vf_sync_condition&(!talent.searing_nightmare.enabled|(talent.searing_nightmare.enabled&!variable.searing_nightmare_cutoff))
		if A.DevouringPlague:IsReady(unit, nil, nil, A.GetToggle(2, "ByPassSpells")) and ((Unit(unit):HasDeBuffs(A.DevouringPlague.ID, true) < 3 or Unit(unit):HasDeBuffs(A.DevouringPlague.ID, true) == 0) or Player:Insanity() > 75) and ((not A.VoidEruption:IsReady()) or VoidFormActive) and (not A.SearingNightmare:IsSpellLearned() or (A.SearingNightmare:IsSpellLearned() and MultiUnits:GetActiveEnemies() <= 3)) then
			return A.DevouringPlague:Show(icon)
		end	

		--actions.main+=/void_bolt,if=spell_targets.mind_sear<(4+conduit.dissonant_echoes.enabled)&insanity<=85
		if A.VoidBolt:IsReady(unit) and MultiUnits:GetActiveEnemies() < 4 and Player:Insanity() <= 85 and VoidFormActive then
			return A.VoidBolt:Show(icon)
		end	
		--actions.main+=/shadow_word_death,target_if=(target.health.pct<20&spell_targets.mind_sear<4)|(pet.fiend.active&runeforge.shadowflame_prism.equipped)
		if A.ShadowWordDeath:IsReady(unit) and Unit(unit):HealthPercent() < 20 and MultiUnits:GetActiveEnemies() < 4 then
			return A.ShadowWordDeath:Show(icon)
		end	


		--actions.main+=/surrender_to_madness,target_if=target.time_to_die<25&buff.voidform.down
		if A.SurrenderToMadness:IsReady(unit) and Unit(unit):TimeToDie() < 25 and not VoidFormActive then
			return A.SurrenderToMadness:Show(icon)
		end
		
		--actions.main+=/Shadowfiend,if=dot.vampiric_touch.ticking&((talent.searing_nightmare.enabled&spell_targets.mind_sear>(variable.mind_sear_cutoff+1))|dot.shadow_word_pain.ticking)
		if A.Shadowfiend:IsReady(unit) and BurstIsON(unit) and Unit(unit):HasDeBuffs(A.VampiricTouchDebuff.ID, true) > 0 and Unit(unit):HasDeBuffs(A.ShadowWordPainDebuff.ID, true) > 0 then
			return A.Shadowfiend:Show(icon)
		end	
		--actions.main+=/void_torrent,target_if=variable.dots_up&target.time_to_die>4&buff.voidform.down&spell_targets.mind_sear<(5+(6*talent.twist_of_fate.enabled))
		if A.VoidTorrent:IsReady(unit) and (not isMoving or StMActive) and VarDotsUp and Unit(unit):TimeToDie() > 4 and not VoidFormActive and MultiUnits:GetActiveEnemies() < (5 + (6 * num(A.TwistofFateTalent:IsSpellLearned()))) then
			return A.VoidTorrent:Show(icon)
		end	

		--actions.main+=/shadow_word_death,if=runeforge.painbreaker_psalm.equipped&variable.dots_up&target.time_to_pct_20>(cooldown.shadow_word_death.duration+gcd)


		--actions.main+=/shadow_crash,if=spell_targets.shadow_crash=1&(cooldown.shadow_crash.charges=3|debuff.shadow_crash_debuff.up|action.shadow_crash.in_flight|target.time_to_die<cooldown.shadow_crash.full_recharge_time)&raid_event.adds.in>30
		if A.ShadowCrash:IsReady(player) and MultiUnits:GetActiveEnemies() < 2 and (A.ShadowCrash:GetSpellCharges() > 2 or Unit(unit):HasDeBuffs(A.ShadowCrashDebuff.ID, true) > 0) then
			return A.ShadowCrash:Show(icon)
		end


		--actions.main+=/shadow_crash,if=raid_event.adds.in>30&spell_targets.shadow_crash>1
		if A.ShadowCrash:IsReady(player) and MultiUnits:GetActiveEnemies() > 1 then
			return A.ShadowCrash:Show(icon)
		end	

		--actions.main+=/mind_sear,target_if=spell_targets.mind_sear>variable.mind_sear_cutoff&buff.dark_thought.up,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2


		--actions.main+=/mind_blast,if=variable.dots_up&raid_event.movement.in>cast_time+0.5&spell_targets.mind_sear<4
		if A.MindBlast:IsReady(unit, nil, nil, A.GetToggle(2, "ByPassSpells")) and VarDotsUp and MultiUnits:GetActiveEnemies() < 4 and (not isMoving or StMActive or Unit(player):HasBuffs(A.DarkThought.ID, true) > 0) then
			return A.MindBlast:Show(icon)
		end	
		
		--[[actions.main+=/vampiric_touch,target_if=refreshable&target.time_to_die>6|(talent.misery.enabled&dot.shadow_word_pain.refreshable)|buff.unfurling_darkness.up
		if A.VampiricTouch:IsReady(unit, nil, nil, A.GetToggle(2, "ByPassSpells")) and Temp.VampiricTouchDelay == 0 and (not isMoving or Unit(player):HasBuffs(A.SurrenderToMadness.ID, true) > 0) and Unit(unit):HasDeBuffs(A.VampiricTouchDebuff.ID, true) < 4 or Unit(unit):HasDeBuffs(A.VampiricTouchDebuff.ID, true) == 0 and Unit(unit):TimeToDie() > 6 then
			return A.VampiricTouch:Show(icon)
		end]]
		
		--[[if A.VampiricTouch:IsReady(unit, nil, nil, A.GetToggle(2, "ByPassSpells")) and Temp.VampiricTouchDelay == 0 and ((A.Misery:IsSpellLearned() and not VarDotsUp) or (not A.Misery:IsSpellLearned() and (Unit(unit):HasDeBuffs(A.VampiricTouchDebuff.ID, true) < 4 or Unit(unit):HasDeBuffs(A.VampiricTouchDebuff.ID, true) == 0))) and Unit(unit):TimeToDie() > 6 and (not isMoving or StMActive) then
			return A.VampiricTouch:Show(icon)
		end]]
		
		
		--[[or (A.VampiricTouch:IsReady(unit) and Temp.VampiricTouchDelay == 0 and A.Misery:IsSpellLearned() and not VarDotsUp) then
			return A.VampiricTouch:Show(icon)
		end]]

		--actions.main+=/shadow_word_pain,if=refreshable&target.time_to_die>4&!talent.misery.enabled&talent.psychic_link.enabled&spell_targets.mind_sear>2
		if A.ShadowWordPain:IsReady(unit, nil, nil, A.GetToggle(2, "ByPassSpells")) and (Unit(unit):HasDeBuffs(A.ShadowWordPainDebuff.ID, true) == 0 or Unit(unit):HasDeBuffs(A.ShadowWordPainDebuff.ID, true) < 3) and Unit(unit):TimeToDie() > 4 and not A.Misery:IsSpellLearned() then
			return	A.ShadowWordPain:Show(icon)
		end	

		--actions.main+=/shadow_word_pain,target_if=refreshable&target.time_to_die>4&!talent.misery.enabled&!(talent.searing_nightmare.enabled&spell_targets.mind_sear>(variable.mind_sear_cutoff+1))&(!talent.psychic_link.enabled|(talent.psychic_link.enabled&spell_targets.mind_sear<=2))
		
		
		--actions.main+=/mind_sear,target_if=spell_targets.mind_sear>variable.mind_sear_cutoff,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2
		if A.MindSear:IsReady(unit) and MultiUnits:GetActiveEnemies() > 2 and (not isMoving or StMActive) then
			return A.MindSear:Show(icon)
		end	
		
		--actions.main+=/mind_flay,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&cooldown.void_bolt.up
		if A.MindFlay:IsReady(unit) and (not isMoving or StMActive) then
			return A.MindFlay:Show(icon)
		end	

		--actions.main+=/shadow_word_death
		if A.ShadowWordDeath:IsReady(unit) and isMoving and inCombat then
			return A.ShadowWordDeath:Show(icon)
		end	

		--PWS Moving
		if isMovingFor > Action.GetToggle(2, "PWSMove") and Unit("player"):HasDeBuffs(A.WeakenedSoulDebuff.ID) == 0 and Action.GetToggle(2, "UsePWS") and A.BodyAndSoul:IsSpellLearned() then
			-- Notification                    
			A.Toaster:SpawnByTimer("TripToast", 0, "Speed Boost!", "Using Power Word: Shield!", A.PowerWordShield.ID)
			return A.PowerWordShield:Show(icon)
		end

		--actions.main+=/shadow_word_pain
		if A.ShadowWordPain:IsReady(unit) and isMoving and inCombat then
			return A.ShadowWordPain:Show(icon)
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
