--######################################
--##### TRIP'S UNHOLY DEATH KNIGHT #####
--######################################

local _G, setmetatable                            = _G, setmetatable
local A                                         = _G.Action
local Covenant                                    = _G.LibStub("Covenant")
local TMW                                        = _G.TMW
local Listener                                  = Action.Listener
local Create                                    = Action.Create
local GetToggle                                 = Action.GetToggle
local SetToggle                                 = Action.SetToggle
local GetGCD                                    = Action.GetGCD
local GetCurrentGCD                             = Action.GetCurrentGCD
local GetPing                                   = Action.GetPing
local ShouldStop                                = Action.ShouldStop
local BurstIsON                                 = Action.BurstIsON
local CovenantIsON                                = Action.CovenantIsON
local AuraIsValid                               = Action.AuraIsValid
local InterruptIsValid                          = Action.InterruptIsValid
local FrameHasSpell                             = Action.FrameHasSpell
local Utils                                     = Action.Utils
local TeamCache                                 = Action.TeamCache
local EnemyTeam                                 = Action.EnemyTeam
local FriendlyTeam                              = Action.FriendlyTeam
local LoC                                       = Action.LossOfControl
local Player                                    = Action.Player
local Pet                                       = LibStub("PetLibrary") 
local MultiUnits                                = Action.MultiUnits
local UnitCooldown                              = Action.UnitCooldown
local Unit                                      = Action.Unit 
local IsUnitEnemy                               = Action.IsUnitEnemy
local IsUnitFriendly                            = Action.IsUnitFriendly
local ActiveUnitPlates                          = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
local pairs                                     = pairs

--For Toaster
local Toaster                                    = _G.Toaster
local GetSpellTexture                             = _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

Action[ACTION_CONST_DEATHKNIGHT_UNHOLY] = {
    -- Racial
    ArcaneTorrent                    = Action.Create({ Type = "Spell", ID = 50613    }),
    BloodFury                        = Action.Create({ Type = "Spell", ID = 20572    }),
    Fireblood                        = Action.Create({ Type = "Spell", ID = 265221   }),
    AncestralCall                    = Action.Create({ Type = "Spell", ID = 274738   }),
    Berserking                        = Action.Create({ Type = "Spell", ID = 26297    }),
    ArcanePulse                        = Action.Create({ Type = "Spell", ID = 260364   }),
    QuakingPalm                        = Action.Create({ Type = "Spell", ID = 107079   }),
    Haymaker                        = Action.Create({ Type = "Spell", ID = 287712   }), 
    WarStomp                        = Action.Create({ Type = "Spell", ID = 20549    }),
    BullRush                        = Action.Create({ Type = "Spell", ID = 255654   }),  
    GiftofNaaru                        = Action.Create({ Type = "Spell", ID = 59544    }),
    Shadowmeld                        = Action.Create({ Type = "Spell", ID = 58984    }), 
    Stoneform                        = Action.Create({ Type = "Spell", ID = 20594    }), 
    BagofTricks                        = Action.Create({ Type = "Spell", ID = 312411    }),
    WilloftheForsaken                = Action.Create({ Type = "Spell", ID = 7744        }),   
    EscapeArtist                    = Action.Create({ Type = "Spell", ID = 20589    }), 
    EveryManforHimself                = Action.Create({ Type = "Spell", ID = 59752    }), 
    LightsJudgment                    = Action.Create({ Type = "Spell", ID = 255647    }),
	RocketJump                    	= Action.Create({ Type = "Spell", ID = 69070    }),
	DarkFlight						= Action.Create({ Type = "Spell", ID = 68992    }),
    
    -- Death Knight General
    AntiMagicShell                    = Action.Create({ Type = "Spell", ID = 48707    }),
    AntiMagicZone                    = Action.Create({ Type = "Spell", ID = 51052    }),
    ChainsofIce                        = Action.Create({ Type = "Spell", ID = 45524    }),
    ControlUndead                    = Action.Create({ Type = "Spell", ID = 111673    }),
    DarkCommand                        = Action.Create({ Type = "Spell", ID = 56222    }),
    DeathandDecay                    = Action.Create({ Type = "Spell", ID = 43265    }),
	DeathandDecayBuff                = Action.Create({ Type = "Spell", ID = 188290    }),
    DeathCoil                        = Action.Create({ Type = "Spell", ID = 47541    }),
    DeathGate                        = Action.Create({ Type = "Spell", ID = 50977    }),
    DeathGrip                        = Action.Create({ Type = "Spell", ID = 49576    }),
    DeathStrike                        = Action.Create({ Type = "Spell", ID = 49998    }),
    DeathsAdvance                    = Action.Create({ Type = "Spell", ID = 48265    }),    
    IceboundFortitude                = Action.Create({ Type = "Spell", ID = 48792    }),
    Lichborne                        = Action.Create({ Type = "Spell", ID = 49039    }),    
    MindFreeze                        = Action.Create({ Type = "Spell", ID = 47528    }),
    PathofFrost                        = Action.Create({ Type = "Spell", ID = 3714        }),
    RaiseAlly                        = Action.Create({ Type = "Spell", ID = 61999    }),
    Runeforging                        = Action.Create({ Type = "Spell", ID = 53428    }),
    SacrificialPact                    = Action.Create({ Type = "Spell", ID = 327574    }),
    OnaPaleHorse                    = Action.Create({ Type = "Spell", ID = 51986, Hidden = true        }),
    VeteranoftheFourthWar            = Action.Create({ Type = "Spell", ID = 319278, Hidden = true    }),
    UnholyStrength                    = Action.Create({ Type = "Spell", ID = 53365, Hidden = true        }),
	PetClaw							= Action.Create({ Type = "Spell", ID = 47468, Hidden = true        }),
    
    -- Unholy Specific
    Apocalypse                        = Action.Create({ Type = "Spell", ID = 275699    }),
    ArmyoftheDead                    = Action.Create({ Type = "Spell", ID = 42650    }),
    DarkTransformation                = Action.Create({ Type = "Spell", ID = 63560    }),    
    Epidemic                        = Action.Create({ Type = "Spell", ID = 207317    }),
    FesteringStrike                    = Action.Create({ Type = "Spell", ID = 85948    }),
    FesteringWound                    = Action.Create({ Type = "Spell", ID = 194310, Hidden = true    }),
    Outbreak                        = Action.Create({ Type = "Spell", ID = 77575    }),
	FrostFever						= Action.Create({ Type = "Spell", ID = 55095    }),
	BloodPlague						= Action.Create({ Type = "Spell", ID = 55078    }),
    VirulentPlague                    = Action.Create({ Type = "Spell", ID = 191587    }),    
    RaiseDead                        = Action.Create({ Type = "Spell", ID = 46584    }),
    ScourgeStrike                    = Action.Create({ Type = "Spell", ID = 55090    }),
    DarkSuccor                        = Action.Create({ Type = "Spell", ID = 178819, Hidden = true    }),
    MasteryDreadblade                = Action.Create({ Type = "Spell", ID = 77515, Hidden = true        }),
    RunicCorruption                    = Action.Create({ Type = "Spell", ID = 51462, Hidden = true        }),
    SuddenDoom                        = Action.Create({ Type = "Spell", ID = 49530, Hidden = true        }),
    SuddenDoomBuff                    = Action.Create({ Type = "Spell", ID = 81340, Hidden = true        }),        
    
    -- Normal Talents
    InfectedClaws                    = Action.Create({ Type = "Spell", ID = 207272, Hidden = true    }),
    AllWillServe                    = Action.Create({ Type = "Spell", ID = 194916, Hidden = true    }),
    ClawingShadows                    = Action.Create({ Type = "Spell", ID = 207311    }),
    BurstingSores                    = Action.Create({ Type = "Spell", ID = 207264, Hidden = true    }),
    EbonFever                        = Action.Create({ Type = "Spell", ID = 207269, Hidden = true    }),
    UnholyBlight                    = Action.Create({ Type = "Spell", ID = 115989    }),
    UnholyBlightDebuff                = Action.Create({ Type = "Spell", ID = 115994, Hidden = true    }),
    GripoftheDead                    = Action.Create({ Type = "Spell", ID = 273952, Hidden = true    }),
    DeathsReach                        = Action.Create({ Type = "Spell", ID = 276079, Hidden = true    }),
    Asphyxiate                        = Action.Create({ Type = "Spell", ID = 108194    }),
    PestilentPustules                = Action.Create({ Type = "Spell", ID = 194917, Hidden = true    }),
    HarbingerofDoom                    = Action.Create({ Type = "Spell", ID = 276023, Hidden = true    }),
    SoulReaper                        = Action.Create({ Type = "Spell", ID = 343294    }),
    SpellEater                        = Action.Create({ Type = "Spell", ID = 207321, Hidden = true    }),
    WraithWalk                        = Action.Create({ Type = "Spell", ID = 212552    }),
    DeathPact                        = Action.Create({ Type = "Spell", ID = 48743    }),    
    Pestilence                        = Action.Create({ Type = "Spell", ID = 277234, Hidden = true    }),
    UnholyPact                        = Action.Create({ Type = "Spell", ID = 319230, Hidden = true    }),
    Defile                            = Action.Create({ Type = "Spell", ID = 152280    }),
    ArmyoftheDamned                    = Action.Create({ Type = "Spell", ID = 276837, Hidden = true    }),
    SummonGargoyle                    = Action.Create({ Type = "Spell", ID = 49206    }),
    UnholyAssault                    = Action.Create({ Type = "Spell", ID = 207289    }),    
    
    -- PvP Talents
    DarkSimulacrum                    = Action.Create({ Type = "Spell", ID = 77606    }),
    NecroticStrike                    = Action.Create({ Type = "Spell", ID = 223829    }),
    LifeandDeath                    = Action.Create({ Type = "Spell", ID = 288855, Hidden = true    }),
    Reanimation                        = Action.Create({ Type = "Spell", ID = 210128    }),
    CadaverousPallor                = Action.Create({ Type = "Spell", ID = 201995, Hidden = true    }),
    NecroticAura                    = Action.Create({ Type = "Spell", ID = 199642, Hidden = true    }),
    DecomposingAura                    = Action.Create({ Type = "Spell", ID = 199720, Hidden = true    }),
    NecromancersBargain                = Action.Create({ Type = "Spell", ID = 288848, Hidden = true    }),    
    RaiseAbomination                = Action.Create({ Type = "Spell", ID = 288853    }),
    Transfusion                        = Action.Create({ Type = "Spell", ID = 288977    }),
    DomeofAncientShadow                = Action.Create({ Type = "Spell", ID = 328718, Hidden = true    }),    
    
    -- Covenant Abilities
    SummonSteward                    = Action.Create({ Type = "Spell", ID = 324739    }),
    DoorofShadows                    = Action.Create({ Type = "Spell", ID = 300728    }),
    Fleshcraft                        = Action.Create({ Type = "Spell", ID = 321687    }),
	Fleshcraftshield                  = Action.Create({ Type = "Spell", ID = 324867    }),
    Soulshape                        = Action.Create({ Type = "Spell", ID = 310143    }),
    Flicker                            = Action.Create({ Type = "Spell", ID = 324701    }),
    ShackletheUnworthy                = Action.Create({ Type = "Spell", ID = 312202    }),
    SwarmingMist                    = Action.Create({ Type = "Spell", ID = 311648    }),
	SwarmingMistBuff				= Action.Create({ Type = "Spell", ID = 312546    }),
    AbominationLimb                    = Action.Create({ Type = "Spell", ID = 315443    }),
    DeathsDue                        = Action.Create({ Type = "Spell", ID = 324128    }),    
    
    -- Conduits
    ConvocationoftheDead            = Action.Create({ Type = "Spell", ID = 338553, Hidden = true    }),
    EmbraceDeath                    = Action.Create({ Type = "Spell", ID = 337980, Hidden = true    }),
    EternalHunger                    = Action.Create({ Type = "Spell", ID = 337381, Hidden = true    }),
    LingeringPlague                    = Action.Create({ Type = "Spell", ID = 338566, Hidden = true    }),
    Proliferation                    = Action.Create({ Type = "Spell", ID = 338664, Hidden = true    }),    
    ImpenetrableGloom                = Action.Create({ Type = "Spell", ID = 338628, Hidden = true    }),
    BrutalGrasp                        = Action.Create({ Type = "Spell", ID = 338651, Hidden = true    }),
    WitheringGround                    = Action.Create({ Type = "Spell", ID = 341344, Hidden = true    }),
    HardenedBones                    = Action.Create({ Type = "Spell", ID = 337972, Hidden = true    }),
    InsatiableAppetite                = Action.Create({ Type = "Spell", ID = 338330, Hidden = true    }),    
    ReinforcedShell                    = Action.Create({ Type = "Spell", ID = 337764, Hidden = true    }),
    ChilledResilience                = Action.Create({ Type = "Spell", ID = 337704, Hidden = true    }),
    FleetingWind                    = Action.Create({ Type = "Spell", ID = 338093, Hidden = true    }),
    SpiritDrain                        = Action.Create({ Type = "Spell", ID = 337705, Hidden = true    }),
    UnendingGrip                    = Action.Create({ Type = "Spell", ID = 338311, Hidden = true    }),  
	LeadbyExample                    = Action.Create({ Type = "Spell", ID = 342156, Hidden = true    }),	
    
    -- Legendaries
    -- General Legendaries
    DeathsEmbrace                    = Action.Create({ Type = "Spell", ID = 334728, Hidden = true    }),
    GripoftheEverlasting            = Action.Create({ Type = "Spell", ID = 334724, Hidden = true    }),
    Phearomones                        = Action.Create({ Type = "Spell", ID = 335177, Hidden = true    }),
    Superstrain                        = Action.Create({ Type = "Spell", ID = 334974, Hidden = true    }),    
    
    --Unholy Legendaries
    DeadliestCoil                    = Action.Create({ Type = "Spell", ID = 334949, Hidden = true    }),
    DeathsCertainty                    = Action.Create({ Type = "Spell", ID = 334898, Hidden = true    }),
    FrenziedMonstrosity                = Action.Create({ Type = "Spell", ID = 334888, Hidden = true    }),
    ReanimatedShambler                = Action.Create({ Type = "Spell", ID = 334836, Hidden = true    }),    
    
    --Anima Powers - to add later...
    
    
    -- Trinkets
    
    
    -- Potions
    PotionofUnbridledFury            = Action.Create({ Type = "Potion", ID = 169299, QueueForbidden = true }),     
    SuperiorPotionofUnbridledFury    = Action.Create({ Type = "Potion", ID = 168489, QueueForbidden = true }),
    PotionofSpectralStrength        = Action.Create({ Type = "Potion", ID = 171275, QueueForbidden = true }),
    PotionofSpectralStamina            = Action.Create({ Type = "Potion", ID = 171274, QueueForbidden = true }),
    PotionofEmpoweredExorcisms        = Action.Create({ Type = "Potion", ID = 171352, QueueForbidden = true }),
    PotionofHardenedShadows            = Action.Create({ Type = "Potion", ID = 171271, QueueForbidden = true }),
    PotionofPhantomFire                = Action.Create({ Type = "Potion", ID = 171349, QueueForbidden = true }),
    PotionofDeathlyFixation            = Action.Create({ Type = "Potion", ID = 171351, QueueForbidden = true }),
    SpiritualHealingPotion            = Action.Create({ Type = "Potion", ID = 171267, QueueForbidden = true }),      
    
    -- Misc
    Channeling                      = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),    -- Show an icon during channeling
    TargetEnemy                     = Action.Create({ Type = "Spell", ID = 44603, Hidden = true     }),    -- Change Target (Tab button)
    StopCast                        = Action.Create({ Type = "Spell", ID = 61721, Hidden = true     }),        -- spell_magic_polymorphrabbit
    PoolResource                    = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),
    Quake                           = Action.Create({ Type = "Spell", ID = 240447, Hidden = true     }), -- Quake (Mythic Plus Affix)
	GCD                     	 = Action.Create({ Type = "Spell", ID = 61304, Hidden = true     }),   
}


-- To create essences use next code:
A:CreateEssencesFor(ACTION_CONST_DEATHKNIGHT_UNHOLY)  -- where PLAYERSPEC is Constance (example: ACTION_CONST_MONK_BM)
local A = setmetatable(Action[ACTION_CONST_DEATHKNIGHT_UNHOLY], { __index = Action })


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

local function InMelee(unit)
    -- @return boolean 
    return A.ScourgeStrike:IsInRange(unit)
end 

local function GetByRange(count, range, isCheckEqual, isCheckCombat)
    -- @return boolean 
    local c = 0 
    for unit in pairs(ActiveUnitPlates) do 
        if (not isCheckEqual or not UnitIsUnit("target", unit)) and (not isCheckCombat or Unit(unit):CombatTime() > 0) then 
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
GetByRange = A.MakeFunctionCachedDynamic(GetByRange)

-- Non GCD spell check
local function countInterruptGCD(unit)
    if not A.MindFreeze:IsReadyByPassCastGCD(unit) or not A.MindFreeze:AbsentImun(unit, Temp.TotalAndMagKick) then
        return true
    end
end

--Work around fix for AoE off breaking
	if UseAoE == true
		then AoETargets = Action.GetToggle(2,"AoETargets")
	end
	if UseAoE == false
		then AoETargets = 10
	end

--Army Usage
local function CanUseArmyofDead(unitID, AoETargets) 
    -- @return boolean 
    local ArmyUsage = GetToggle(2, "ArmyUsage")
    
    if ArmyUsage == "BOSS" and (Unit("target"):IsBoss() or Unit("target"):IsPlayer()) then
        return true
    end
    
    if ArmyUsage == "AoE" and UseAoE then        
        if GetByRange(AoETargets, 10) then
            return true
        end
    end
    
    if ArmyUsage == "BOTH" then        
        if Unit("target"):IsBoss() or Unit("target"):IsPlayer() or (UseAoE and GetByRange(AoETargets, 10)) then
            return true
        end
    end
    
    if ArmyUsage == "EVERYONE" then
        return true
    end
end

-- Interrupts spells
local function Interrupts(unit)
    local DeathGripInterrupt = Action.GetToggle(2, "DeathGripInterrupt")
    local AsphyxiateInterrupt = Action.GetToggle(2, "AsphyxiateInterrupt")
    
    useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))
    
    if castRemainsTime >= A.GetLatency() then
        -- MindFreeze
        if useKick and not notInterruptable and A.MindFreeze:IsReady(unit) then 
            return A.MindFreeze
        end
        
        -- DeathGrip
        if A.DeathGrip:IsReady(unit) and DeathGripInterrupt and A.MindFreeze:GetCooldown() > 1 and useCC then 
            return A.DeathGrip
        end 
        
        -- Asphyxiate
        if A.Asphyxiate:IsSpellLearned() and A.Asphyxiate:IsReady(unit) and AsphyxiateInterrupt and A.MindFreeze:GetCooldown() > 1 and useCC then 
            return A.Asphyxiate
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

local function SelfDefensives(unit)
    local HPLoosePerSecond = Unit(player):GetDMG() * 100 / Unit(player):HealthMax()
    
    if Unit(player):CombatTime() == 0 then 
        return 
    end 
    
    -- Icebound Fortitude
    
    local IceboundFortitudeAntiStun = GetToggle(2, "IceboundFortitudeAntiStun")
    local IceboundFortitude = GetToggle(2, "IceboundFortitudeHP")
    if     IceboundFortitude >= 0 and A.IceboundFortitude:IsReady(player) and 
    (
        (   -- Auto 
            IceboundFortitude >= 100 and 
            (
                -- HP lose per sec >= 20
                Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 30 or 
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.30 or 
                -- TTD 
                Unit(player):TimeToDieX(25) < 2 or
                -- Player stunned
                LoC:Get("STUN") > 2 and IceboundFortitudeAntiStun or            
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
            IceboundFortitude < 100 and 
            Unit(player):HealthPercent() <= IceboundFortitude
        )
    ) 
    then 
        return A.IceboundFortitude
    end  
	
	-- Lichborne
	local LichborneAntiStun = GetToggle(2, "LichborneAntiStun")
    local Lichborne = GetToggle(2, "LichborneHP")
    if     Lichborne >= 0 and A.Lichborne:IsReady(player) and 
    (
        (   -- Auto 
            Lichborne >= 100 and 
            (
                -- HP lose per sec >= 20
                Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 30 or 
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.30 or 
                -- TTD 
                Unit(player):TimeToDieX(25) < 2 or
                -- Player stunned
                LoC:Get("STUN") > 2 and LichborneAntiStun or  				
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
            Lichborne < 100 and 
            Unit(player):HealthPercent() <= Lichborne
        )
    ) 
    then 
        return A.Lichborne
    end  
	
    
    -- Emergency AntiMagicShell
    local AntiMagicShell = GetToggle(2, "AntiMagicShellHP")
    if     AntiMagicShell >= 0 and A.AntiMagicShell:IsReady(player) and 
    (
        (   -- Auto 
            AntiMagicShell >= 100 and 
            (
                -- HP lose per sec >= 10
                Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 15 or 
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.15 or 
                -- TTD Magic
                Unit(player):TimeToDieMagicX(30) < 3 or 
                
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
            AntiMagicShell < 100 and 
            Unit(player):HealthPercent() <= AntiMagicShell
        )
    ) 
    then 
        return A.AntiMagicShell
    end          
    
    -- Emergency Death Pact
    local DeathPact = GetToggle(2, "DeathPactHP")
    if     DeathPact >= 0 and A.DeathPact:IsReady(player) and A.DeathPact:IsSpellLearned() and 
    (
        (   -- Auto 
            DeathPact >= 100 and 
            (
                -- HP lose per sec >= 30
                Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 30 or 
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.30 or 
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
            DeathPact < 100 and 
            Unit(player):HealthPercent() <= DeathPact
        )
    ) 
    then 
        return A.DeathPact
    end          
    
    -- HealingPotion
    local SpiritualHealingPotion = A.GetToggle(2, "SpiritualHealingPotionHP")
    if     SpiritualHealingPotion >= 0 and A.SpiritualHealingPotion:IsReady(player) and 
    (
        (     -- Auto 
            SpiritualHealingPotion >= 100 and 
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
                            Unit("player", 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused() 
                        )
                    )
                )
            ) and 
            Unit(player):HasBuffs("DeffBuffs", true) == 0
        ) or 
        (    -- Custom
            SpiritualHealingPotion < 100 and 
            Unit(player):HealthPercent() <= SpiritualHealingPotion
        )
    ) 
    then 
        return A.SpiritualHealingPotion
    end 
	
	--Fleshcraft
	--local FleshcraftHP = Action.GetToggle(2, "FleshcraftHP")
	--local FlashcraftOperator = Action.GetToggle(2, "FleshcraftOperator")
	--local FlashcraftTTD = Action.GetToggle(2, "FleshcraftTTD")
	--if FleshcraftOperator == "AND" and A.Fleshcraft:IsReady(player) and A.Fleshcraft:GetSpellTimeSinceLastCast() > 120 and Unit(player):HealthPercent() <= FleshcraftHP and Unit(player):TimeToDie() <= FlashcraftTTD then
	--	return A.Fleshcraft
	--end
	--if FleshcraftOperator == "OR" and A.Fleshcraft:IsReady(player) and A.Fleshcraft:GetSpellTimeSinceLastCast() > 120 and (Unit(player):HealthPercent() <= FleshcraftHP or Unit(player):TimeToDie() <= FlashcraftTTD) then
	--	return A.Fleshcraft
	--end
	
	
end 
SelfDefensives = A.MakeFunctionCachedDynamic(SelfDefensives)

--- ======= ACTION LISTS =======
-- [3] Single Rotation
A[3] = function(icon, isMulti)
    --------------------
    --- ROTATION VAR ---
    --------------------
    local isMoving = A.Player:IsMoving()
    local inCombat = Unit("player"):CombatTime() > 0
    local combatTime = Unit("player"):CombatTime()
    local RunicPower = Player:RunicPower()
    local RunicPowerDeficit = Player:RunicPowerDeficit()
    local VirulentPlagueTargets = Player:GetDeBuffsUnitCount(A.VirulentPlague.ID)
    local VirulentPlagueRefreshable = Unit("target"):HasDeBuffs(A.VirulentPlague.ID, true) < 4 or Unit("target"):HasDeBuffs(A.VirulentPlague.ID, true) == 0
	local FrostFeverRefreshable = Unit("target"):HasDeBuffs(A.FrostFever.ID, true) < 4 or Unit("target"):HasDeBuffs(A.FrostFever.ID, true) == 0
	local BloodPlagueRefreshable = Unit("target"):HasDeBuffs(A.BloodPlague.ID, true) < 4 or Unit("target"):HasDeBuffs(A.BloodPlague.ID, true) == 0

    --    local PotionTTD = Unit("target"):TimeToDie() > Action.GetToggle(2, "PotionTTD")
    local AutoPotionSelect = Action.GetToggle(2, "AutoPotionSelect")
    local PotionTrue = Action.GetToggle(1, "Potion")    
    local GargoyleActive = A.SummonGargoyle:GetSpellTimeSinceLastCast() <= 30
    --    local UseArmyoftheDead = A.ArmyoftheDead:IsReady("player") and not A.ArmyoftheDead:IsBlocked() and Unit("target"):IsBoss()
    local DeathandDecayTicking = Unit(player):HasBuffs(A.DeathandDecayBuff.ID, true) > 0
    local Racial = Action.GetToggle(1, "Racial")
    local UseAoE = Action.GetToggle(2, "AoE")
    local DeathStrikeHP = Action.GetToggle(2, "DeathStrikeHP")    
    local AoETargets = Action.GetToggle(2, "AoETargets")
    local AutoSwitchFesteringStrike = GetToggle(2, "AutoSwitchFesteringStrike")
    local currentTargets = MultiUnits:GetByRange(7)    
    local MissingFesteringWound = MultiUnits:GetByRangeMissedDoTs(10, 5, A.FesteringWound.ID)
    local ActiveFesteringWound = MultiUnits:GetByRangeAppliedDoTs(6, 5, A.FesteringWound.ID)
	local MouseoverTarget = UnitName("mouseover")
	local DnDSlider = Action.GetToggle(2, "DnDSlider")

	
    
    --actions+=/variable,name=pooling_for_gargoyle,value=cooldown.summon_gargoyle.remains<5&talent.summon_gargoyle.enabled
    VarPoolingForGargoyle = A.SummonGargoyle:GetCooldown() < 8 and A.SummonGargoyle:IsTalentLearned() and BurstIsON("target")
    
    ------------------------------------------------------
    ---------------- ENEMY UNIT ROTATION -----------------
    ------------------------------------------------------
    local function EnemyRotation(unit)

		--LegoSwap
		if Action.GetToggle(2,"LegoSwap") and not UnitAffectingCombat("player") and Pet:IsActive() and BurstIsON(unit) and not UnitIsDead("target") then
			if A.DeadliestCoil:HasLegendaryCraftingPower() and A.DarkTransformation:GetCooldown() == 0 then 
				return A.QuakingPalm:Show(icon)
				else if A.FrenziedMonstrosity:HasLegendaryCraftingPower() and A.DarkTransformation:GetCooldown() == 0 and Unit("pet"):HasDeBuffs(A.ControlUndead.ID, true) == 0 then
					return A.DarkTransformation:Show(icon) 
					else if A.FrenziedMonstrosity:HasLegendaryCraftingPower() and A.DarkTransformation:GetSpellTimeSinceLastCast() < 60 then
						return A.DarkFlight:Show(icon)
						
					end
				end
			end
		end
		
		
        --Force Timmy to claw
		--if A.PetClaw:IsReady("pettarget") and UnitExists("pet") and UnitPower("pet") >= 40 and Unit("pet"):HasBuffs(A.DarkTransformation.ID, true) == 0 and GetSpellCooldown(47468) <= 0 and IsSpellInRange(77575, "pettarget") == 1 then
		--return A.RocketJump:Show(icon)
		--print(IsSpellInRange(55090, "pettarget"))
		--end
		
		local Interrupt = Interrupts(unit)
        if Interrupt then 
            return Interrupt:Show(icon)
        end    
	
		--Fleshcraft precombat cast
		--	if A.Fleshcraft:IsReady(player) 
		--	and Unit("player"):CombatTime() == 0 then
		--return A.Fleshcraft:Show(icon)
		--end
		
        --Death Strike below HP %
        if A.DeathStrike:IsReady(unit) and Unit(player):HealthPercent() <= DeathStrikeHP then
            return A.DeathStrike:Show(icon)
        end

		--actions.cooldowns+=/soul_reaper,target_if=target.time_to_pct_35<5&target.time_to_die>5
        if A.SoulReaper:IsReady(unit) and Unit("target"):TimeToDieX(35) < 5 and Unit("target"):TimeToDie() > 5 then
            return A.SoulReaper:Show(icon)
         end 
			
		-- Return to Focus
		if UnitGUID("target") ~= UnitGUID("focus") and UnitExists("focus") and UnitHealth("focus") > 0 and not UnitIsFriend("player", "focus") and Action.GetToggle(2, "FocusTunnel") and Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) > 0 and IsItemInRange(37727, "focus") then
			return A.RocketJump:Show(icon)
		end
			
		--Spiteful Soul Slow
		if A.ChainsofIce:IsReady("mouseover") and Action.GetToggle(2, "SlowSpiteful") and (string.find(UnitGUID("mouseover"), 174773)) and Unit("mouseover"):GetRange() < 30 and UnitName("mouseovertarget") == UnitName(player) then
		return A.ChainsofIce:Show(icon)
		end
		        
		--Soul Reaper scan for <35 or TimeTo35 < 5  @mouseover     
        if A.SoulReaper:IsReady() and Action.GetToggle(2, "mouseover") and Action.GetToggle(2, "SoulReaperMouseover") and Unit("mouseover"):GetRange() < 5 and Unit("target"):TimeToDieX(35) > 5 and InMelee("mouseover") and not Unit("mouseover"):InLOS() and Unit("mouseover"):TimeToDieX(35) < 5 and Unit("mouseover"):TimeToDie() > 5 and Unit("mouseover"):HasDeBuffs(A.SoulReaper.ID, true) == 0 then 
            return A.SoulReaper:Show(icon)
        end
		
        -- Festering Strike auto target (credit to Taste for this)
        if AutoSwitchFesteringStrike and A.BurstIsON(unit) and Unit(unit):HasDeBuffsStacks(A.FesteringWound.ID, true) > 0 and Player:AreaTTD(10) > 5 and Player:Rune() >= 2 and A.DeathandDecay:GetCooldown() <= 5 and currentTargets >= 2 and currentTargets <= 5 and (MissingFesteringWound > 0 and MissingFesteringWound < 5 or Unit(unit):IsDummy())
        then
            local FesteringStrike_Nameplates = MultiUnits:GetActiveUnitPlates()
            if FesteringStrike_Nameplates then  
                for FesteringStrike_UnitID in pairs(FesteringStrike_Nameplates) do             
                    if Unit(FesteringStrike_UnitID):GetRange() < 5 and InMelee(FesteringStrike_UnitID) and not Unit(FesteringStrike_UnitID):InLOS() and Unit(FesteringStrike_UnitID):HasDeBuffsStacks(A.FesteringWound.ID, true) == 0 then 
                        return A:Show(icon, ACTION_CONST_AUTOTARGET)
                    end         
                end 
            end
        end
		
		--Festering Switch with CD off
		if AutoSwitchFesteringStrike and not A.BurstIsON(unit) and Unit(unit):HasDeBuffsStacks(A.FesteringWound.ID, true) > 0 and Player:AreaTTD(10) > 5 and Player:Rune() >= 2 and A.DeathandDecay:GetCooldown() <= 5 and currentTargets >= 2 and currentTargets <= 5 and (MissingFesteringWound > 0 and MissingFesteringWound < 5 or Unit(unit):IsDummy())
		 then
            local FesteringStrike_Nameplates = MultiUnits:GetActiveUnitPlates()
            if FesteringStrike_Nameplates then  
                for FesteringStrike_UnitID in pairs(FesteringStrike_Nameplates) do             
                    if Unit(FesteringStrike_UnitID):GetRange() < 6 and InMelee(FesteringStrike_UnitID) and not Unit(FesteringStrike_UnitID):InLOS() and Unit(FesteringStrike_UnitID):HasDeBuffsStacks(A.FesteringWound.ID, true) == 0 then 
                        return A:Show(icon, ACTION_CONST_AUTOTARGET)
                   end         
                end 
            end
        end
		
		--actions.cooldowns+=/raise_dead,if=!pet.ghoul.active
        if not Pet:IsActive() and A.RaiseDead:IsReady() then
            return A.RaiseDead:Show(icon)
        end  
		
        --actions+=/arcane_torrent,if=runic_power.deficit>65&(pet.gargoyle.active|!talent.summon_gargoyle.enabled)&rune.deficit>=5
        if A.ArcaneTorrent:IsReady(player) and A.BurstIsON(unit) and Racial and RunicPowerDeficit > 65 and (GargoyleActive or not A.SummonGargoyle:IsTalentLearned()) and Player:Rune() < 2 then
            return A.ArcaneTorrent:Show(icon)
        end    
        
        --actions+=/blood_fury,if=pet.gargoyle.active|buff.unholy_assault.up|talent.army_of_the_damned.enabled&(pet.army_ghoul.active|cooldown.army_of_the_dead.remains>target.time_to_die)
        if A.BloodFury:IsReady(player) and A.BurstIsON(unit) and Racial and (GargoyleActive or Unit(player):HasBuffs(A.UnholyAssault.ID, true) > 0 or A.ArmyoftheDamned:IsTalentLearned()) and (A.ArmyoftheDamned:IsTalentLearned()) and Unit("player"):CombatTime() > 0 then
            return A.BloodFury:Show(icon)
        end    
        
        --actions+=/berserking,if=pet.gargoyle.active|buff.unholy_assault.up|talent.army_of_the_damned.enabled&(pet.army_ghoul.active|cooldown.army_of_the_dead.remains>target.time_to_die)
        if A.Berserking:IsReady(player) and A.BurstIsON(unit) and Racial and (GargoyleActive or Unit(player):HasBuffs(A.UnholyAssault.ID, true) > 0 or A.ArmyoftheDamned:IsTalentLearned()) and (A.ArmyoftheDamned:IsTalentLearned()) then
            return A.Berserking:Show(icon)
        end                
        --actions+=/lights_judgment,if=buff.unholy_strength.up + Time to Die > 5
        if A.LightsJudgment:IsReady(unit) and A.BurstIsON(unit) and Racial and Unit(player):HasBuffs(A.UnholyStrength.ID, true) > 0 and Player:AreaTTD(10) > 5 then
            return A.LightsJudgment:Show(icon)
        end
        
        --actions+=/ancestral_call,if=pet.gargoyle.active|buff.unholy_assault.up|talent.army_of_the_damned.enabled&(pet.army_ghoul.active|cooldown.army_of_the_dead.remains>target.time_to_die)
        if A.AncestralCall:IsReady(player) and A.BurstIsON(unit) and Racial and (GargoyleActive or Unit(player):HasBuffs(A.UnholyAssault.ID, true) > 0 or A.ArmyoftheDamned:IsTalentLearned()) and (A.ArmyoftheDamned:IsTalentLearned()) then
            return A.AncestralCall:Show(icon)
        end    
        
        --[[actions+=/arcane_pulse,if=active_enemies>=2|(rune.deficit>=5&runic_power.deficit>=60)
        if A.ArcanePulse:IsReady(unit) and A.BurstIsON(unit) and Racial and MultiUnits:GetByRange(8, 2) >= 2 or (Player:Rune() < 2 and RunicPowerDeficit >= 60) then
            return A.ArcanePulse:Show(icon)
        end    ]]
        
        --actions+=/fireblood,if=pet.gargoyle.active|buff.unholy_assault.up|talent.army_of_the_damned.enabled&(pet.army_ghoul.active|cooldown.army_of_the_dead.remains>target.time_to_die)
        if A.Fireblood:IsReady(player) and A.BurstIsON(unit) and Racial and (GargoyleActive or Unit(player):HasBuffs(A.UnholyAssault.ID, true) > 0 or A.ArmyoftheDamned:IsTalentLearned()) and (A.ArmyoftheDamned:IsTalentLearned()) and Unit("player"):CombatTime() > 0 then
            return A.Fireblood:Show(icon)
        end                
        
        --actions+=/bag_of_tricks,if=buff.unholy_strength.up&active_enemies=1
        if A.BagofTricks:IsReady(unit) and A.BurstIsON(unit) and Racial and Unit(player):HasBuffs(A.UnholyStrength.ID, true) > 0 and MultiUnits:GetByRange(10, AoETargets) < AoETargets then
            return A.BagofTricks:Show(icon)
        end   
		
		--actions+=/outbreak,if=dot.virulent_plague.refreshable&!talent.unholy_blight.enabled&!raid_event.adds.exists
        if A.Outbreak:IsReady(unit) and VirulentPlagueRefreshable and not A.UnholyBlight:IsTalentLearned() then
            return A.Outbreak:Show(icon)
        end 

		-- OutBreak if Burst is off
		if A.Outbreak:IsReady(unit) and not A.BurstIsON(unit) and VirulentPlagueRefreshable then
            return A.Outbreak:Show(icon)
        end 
        
        --actions+=/outbreak,if=dot.virulent_plague.refreshable&(!talent.unholy_blight.enabled|talent.unholy_blight.enabled&cooldown.unholy_blight.remains)&active_enemies>=2
        if A.Outbreak:IsReady(unit) and VirulentPlagueRefreshable and (not A.UnholyBlight:IsTalentLearned() or (A.UnholyBlight:IsTalentLearned() and A.UnholyBlight:GetCooldown() > 0)) then
            return A.Outbreak:Show(icon)
        end  
		
		--actions+=/outbreak,if=runeforge.superstrain&(dot.frost_fever.refreshable|dot.blood_plague.refreshable)
		if A.Outbreak:IsReady(unit) and A.Superstrain:HasLegendaryCraftingPower() and (FrostFeverRefreshable or BloodPlagueRefreshable) then
			return A.Outbreak:Show(icon)
		end
		
		-- Outbreak if Burst is off
		if A.Outbreak:IsReady(unit) and not A.BurstIsON(unit) and A.Superstrain:HasLegendaryCraftingPower() and (FrostFeverRefreshable or BloodPlagueRefreshable) then
			return A.Outbreak:Show(icon)
		end
		
		--SoulReaper if CD is off
        if not A.BurstIsON(unit) and A.SoulReaper:IsReady(unit) and Unit("target"):TimeToDieX(35) < 5 and Unit("target"):TimeToDie() > 5 then
            return A.SoulReaper:Show(icon)
        end    
		
		--actions.cooldowns+=/raise_dead,if=!pet.ghoul.active
		if not Pet:IsActive() and A.RaiseDead:IsReady() then
			return A.RaiseDead:Show(icon)
		end 
	
 
        --#####################
        --##### AOE BURST #####
        --#####################
        
         local function AoEBurst() 
				
			--actions.cooldowns+=/soul_reaper,target_if=target.time_to_pct_35<5&target.time_to_die>5
            if A.SoulReaper:IsReady(unit) and Unit("target"):TimeToDieX(35) < 5 and Unit("target"):TimeToDie() > 5 then
                return A.SoulReaper:Show(icon)
            end
            			
			--actions.aoe_burst+=/epidemic,if=runic_power.deficit<(10+death_knight.fwounded_targets*3)&death_knight.fwounded_targets<6&!variable.pooling_for_gargoyle|buff.swarming_mist.up
            if A.Epidemic:IsReady(player) and ((A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 4) > 3) or (not A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) > 2)) and ((RunicPowerDeficit < (10 + (ActiveFesteringWound * 3)) and ActiveFesteringWound < 6 and not VarPoolingForGargoyle) or A.SwarmingMist:GetSpellTimeSinceLastCast() < 8) and Unit("target"):HasDeBuffs(A.VirulentPlague.ID, true) > 0 then
                return A.Epidemic:Show(icon)
            end 

			--DeathCoil if Deadliest Coil lego
			if A.DeathCoil:IsReady(unit) and ((A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 4) <= 3) or (not A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) <= 2)) and ((RunicPowerDeficit < (10 + (ActiveFesteringWound * 3)) and ActiveFesteringWound < 6 and not VarPoolingForGargoyle) or A.SwarmingMist:GetSpellTimeSinceLastCast() < 8) and Unit("target"):HasDeBuffs(A.VirulentPlague.ID, true) > 0 then
				return A.DeathCoil:Show(icon)
			end
            
            --actions.aoe_burst+=/epidemic,if=runic_power.deficit<25&death_knight.fwounded_targets>5&!variable.pooling_for_gargoyle
            if A.Epidemic:IsReady(player) and ((A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 4) > 3) or (not A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) > 2)) and RunicPowerDeficit < 25 and ActiveFesteringWound > 5 and not VarPoolingForGargoyle and Unit("target"):HasDeBuffs(A.VirulentPlague.ID, true) > 0 then
                return A.Epidemic:Show(icon)
            end

			if A.DeathCoil:IsReady(unit) and ((A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 4) <= 3) or (not A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) <= 2)) and RunicPowerDeficit < 25 and ActiveFesteringWound > 5 and not VarPoolingForGargoyle and Unit("target"):HasDeBuffs(A.VirulentPlague.ID, true) > 0 then
				return A.DeathCoil:Show(icon)
			end

            --actions.aoe_burst+=/epidemic,if=!death_knight.fwounded_targets&!variable.pooling_for_gargoyle|fight_remains<5|raid_event.adds.exists&raid_event.adds.remains<5
            if A.Epidemic:IsReady(unit) and ((A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 4) > 3) or (not A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) > 2)) and ((not ActiveFesteringWound and not VarPoolingForGargoyle) or Player:AreaTTD(10) < 5) and Unit("target"):HasDeBuffs(A.VirulentPlague.ID, true) > 0 then 
               return A.Epidemic:Show(icon)
            end    
			
            if A.DeathCoil:IsReady(unit) and ((A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 4) <= 3) or (not A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) <= 2)) and ((not ActiveFesteringWound and not VarPoolingForGargoyle) or Player:AreaTTD(10) < 5) and Unit("target"):HasDeBuffs(A.VirulentPlague.ID, true) > 0 then 
				return A.DeathCoil:Show(icon)
			end
     
            --actions.aoe_burst+=/wound_spender
            if A.ScourgeStrike:IsReady(unit) then
                return A.ScourgeStrike:Show(icon)
            end    
            
            if A.ClawingShadows:IsReady(unit) then
                return A.ClawingShadows:Show(icon)
            end
            
			--actions.generic_aoe=epidemic,if=buff.sudden_doom.react
            if A.Epidemic:IsReady(player) and ((A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) > 3) or (not A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) > 2)) and Unit(player):HasBuffs(A.SuddenDoomBuff.ID, true) > 0 and Unit("target"):HasDeBuffs(A.VirulentPlague.ID, true) > 0 then
                return A.Epidemic:Show(icon)
            end 

            if A.DeathCoil:IsReady(unit) and ((A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) <= 3) or (not A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) <= 2)) and Unit(player):HasBuffs(A.SuddenDoomBuff.ID, true) > 0 then
				return A.DeathCoil:Show(icon)
			end
			
            --actions.aoe_burst+=/epidemic,if=!variable.pooling_for_gargoyle
            if A.Epidemic:IsReady(player) and ((A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) > 3) or (not A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) > 2)) and not VarPoolingForGargoyle and Unit("target"):HasDeBuffs(A.VirulentPlague.ID, true) > 0 then
                return A.Epidemic:Show(icon)
            end       
			
			if A.DeathCoil:IsReady(unit) and ((A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) <= 3) or (not A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) <= 2)) and not VarPoolingForGargoyle then
				return A.DeathCoil:Show(icon)
			end

            
        end 
        
        
        --#####################
        --##### AOE SETUP #####
        --#####################
        
        local function AoESetup()    
             
			--actions.aoe_setup=any_dnd,if=death_knight.fwounded_targets=active_enemies|raid_event.adds.exists&raid_event.adds.remains<=11
            if A.DeathandDecay:IsReady(player) and MissingFesteringWound == 0 then
                return A.DeathandDecay:Show(icon)
            end
            
            if A.Defile:IsReady(player) and MissingFesteringWound == 0 and A.Defile:IsTalentLearned() then
                return A.Defile:Show(icon)
            end
            
            if A.DeathsDue:IsReady(unit) and MissingFesteringWound == 0 then
                return A.DeathsDue:Show(icon)
            end            
            
            --actions.aoe_setup+=/any_dnd,if=death_knight.fwounded_targets>=5
            if A.DeathandDecay:IsReady(player) and ActiveFesteringWound >= DnDSlider then
                return A.DeathandDecay:Show(icon)
            end
            
            if A.Defile:IsReady(player) and A.Defile:IsTalentLearned() and ActiveFesteringWound >= DnDSlider then
                return A.Defile:Show(icon)
            end
            
            if A.DeathsDue:IsReady(unit) and ActiveFesteringWound >= DnDSlider then
                return A.DeathsDue:Show(icon)
            end   

			--actions.aoe_setup+=/death_coil,if=buff.dark_transformation.up&runeforge.deadliest_coil&active_enemies<=3
			if A.DeathCoil:IsReady(unit) and Unit("pet"):HasBuffs(A.DarkTransformation.ID, true) > 0 and A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 4) <= 3 then
				return A.DeathCoil:Show(icon)
			end
			
			--actions.aoe_setup+=/epidemic,if=!variable.pooling_for_gargoyle 
			if A.Epidemic:IsReady(player) and ((A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) > 3) or (not A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) > 2)) and not VarPoolingForGargoyle and Unit("target"):HasDeBuffs(A.VirulentPlague.ID, true) > 0 then
                return A.Epidemic:Show(icon)
			end
			
			if A.DeathCoil:IsReady(unit) and ((A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) <= 3)or (not A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) <= 2)) and not VarPoolingForGargoyle then
				return A.DeathCoil:Show(icon)
			end

            --actions.aoe_setup+=/festering_strike,target_if=max:debuff.festering_wound.stack,if=debuff.festering_wound.stack<=3&cooldown.apocalypse.remains<3
            if A.FesteringStrike:IsReady(unit) and A.BurstIsON and Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) <= 3 and A.Apocalypse:GetCooldown() < 3 then
                return A.FesteringStrike:Show(icon)
            end    
            
            --actions.aoe_setup+=/festering_strike,target_if=debuff.festering_wound.stack<1
            if A.FesteringStrike:IsReady(unit) and Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) < 1 then
                return A.FesteringStrike:Show(icon)
            end    
            --actions.aoe_setup+=/festering_strike,target_if=min:debuff.festering_wound.stack,if=rune.time_to_4<(cooldown.death_and_decay.remains&!talent.defile|cooldown.defile.remains&talent.defile)
            if A.FesteringStrike:IsReady(unit) and Player:RuneTimeToX(4) < (A.DeathandDecay:GetCooldown() or A.Defile:GetCooldown()) then
                return A.FesteringStrike:Show(icon)
            end    
				
			--actions.generic_aoe=epidemic,if=buff.sudden_doom.react
            if A.Epidemic:IsReady(player) and ((A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) > 3) or (not A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) > 2)) and Unit(player):HasBuffs(A.SuddenDoomBuff.ID, true) > 0 and Unit("target"):HasDeBuffs(A.VirulentPlague.ID, true) > 0 then
                return A.Epidemic:Show(icon)
            end
			
            if A.DeathCoil:IsReady(unit) and ((A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) <= 3) or (not A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) <= 2)) and Unit(player):HasBuffs(A.SuddenDoomBuff.ID, true) > 0 then
				return A.DeathCoil:Show(icon)
			end
			
            --actions.aoe_burst+=/epidemic,if=!variable.pooling_for_gargoyle
            if A.Epidemic:IsReady(player) and ((A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) > 3) or (not A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) > 2)) and not VarPoolingForGargoyle and Unit("target"):HasDeBuffs(A.VirulentPlague.ID, true) > 0 then
                return A.Epidemic:Show(icon)
            end  
			            
			if A.DeathCoil:IsReady(unit) and ((A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) <= 3) or (not A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) <= 2)) and not VarPoolingForGargoyle then
				return A.DeathCoil:Show(icon)
			end


			--festering if finished spread or spread off
			if A.ScourgeStrike:IsReady(unit) and (not AutoSwitchFesteringStrike or MissingFesteringWound == 0) then
				return A.ScourgeStrike:Show(icon)
			end
			
			if A.ClawingShadows:IsReady(unit) and (not AutoSwitchFesteringStrike or MissingFesteringWound == 0) then
				return A.ClawingShadows:Show(icon)
			end
            
        end  
        
        
        --#####################
        --##### COOLDOWNS #####
        --#####################
        
        local function Cooldowns()    
            --actions.cooldowns=use_items
  
			
            --actions.cooldowns=potion,if=pet.gargoyle.active|buff.unholy_assault.up|talent.army_of_the_damned&(pet.army_ghoul.active|pet.apoc_ghoul.active|cooldown.army_of_the_dead.remains>target.time_to_die)|fight_remains<26
            -- Unbridled Fury
            --if A.PotionofUnbridledFury:IsReady(unit) and AutoPotionSelect == "UnbridledFuryPot" and (GargoyleActive or Unit(player):HasBuffs(A.UnholyAssault.ID, true) > 0 or (A.ArmyoftheDamned:IsTalentLearned()))
           -- then
            --    -- Notification                    
            --    A.Toaster:SpawnByTimer("TripToast", 0, "Combat Potion!", "Using Combat Potion!", A.PotionofUnbridledFury.ID)  
            --    return A.PotionofUnbridledFury:Show(icon)
            --end
            
            --Spectral Strength
            if A.PotionofSpectralStrength:IsReady(player) and Action.GetToggle(1, "Potion") and IsItemInRange(32321) and ((GargoyleActive or Unit(player):HasBuffs(A.UnholyAssault.ID, true) > 0 or A.ArmyoftheDamned:IsTalentLearned()) and (A.ArmyoftheDead:GetSpellTimeSinceLastCast() < 30 or A.Apocalypse:GetSpellTimeSinceLastCast() < 15 or A.ArmyoftheDead:GetCooldown() > Unit("target"):TimeToDie()) or Player:AreaTTD(10) < 26)
            then
                -- Notification                    
                A.Toaster:SpawnByTimer("TripToast", 0, "Combat Potion!", "Using Combat Potion!", A.PotionofSpectralStrength.ID)  
                return A.PotionofSpectralStrength:Show(icon)
            end
            
            -- Empowered Exorcisms
            --if A.PotionofEmpoweredExorcisms:IsReady(unit) and AutoPotionSelect == "EmpoweredExorcismsPot" and (GargoyleActive or Unit(player):HasBuffs(A.UnholyAssault.ID, true) > 0 or (A.ArmyoftheDamned:IsTalentLearned()))
            --then
                -- Notification                    
            --    A.Toaster:SpawnByTimer("TripToast", 0, "Combat Potion!", "Using Combat Potion!", A.PotionofEmpoweredExorcisms.ID)  
            --    return A.PotionofEmpoweredExorcisms:Show(icon)
            --end
            
            -- Phantom Fire
           -- if A.PotionofPhantomFire:IsReady(unit) and AutoPotionSelect == "PhantomFirePot" and (GargoyleActive or Unit(player):HasBuffs(A.UnholyAssault.ID, true) > 0 or (A.ArmyoftheDamned:IsTalentLearned()))
            --then
            --    -- Notification                    
            --    A.Toaster:SpawnByTimer("TripToast", 0, "Combat Potion!", "Using Combat Potion!", A.PotionofPhantomFire.ID)  
            --    return A.PotionofPhantomFire:Show(icon)
            --end
            
            -- Deathly Fixation
            --if A.PotionofDeathlyFixation:IsReady(unit) and AutoPotionSelect == "DeathlyFixationPot" and (GargoyleActive or Unit(player):HasBuffs(A.UnholyAssault.ID, true) > 0 or (A.ArmyoftheDamned:IsTalentLearned()))
            --then
                -- Notification                    
            --    A.Toaster:SpawnByTimer("TripToast", 0, "Combat Potion!", "Using Combat Potion!", A.PotionofDeathlyFixation.ID)  
            --    return A.PotionofDeathlyFixation:Show(icon)
           -- end                
            
            -- Trinket 1
            if A.Trinket1:IsReady(unit) and Unit(unit):GetRange() <= 7 and ((A.UnholyAssault:IsTalentLearned()) or (GargoyleActive and A.SummonGargoyle:IsTalentLearned()) or A.ArmyoftheDamned:IsTalentLearned()) then
                return A.Trinket1:Show(icon)    
            end
            
            -- Trinket 2
            if A.Trinket2:IsReady(unit) and Unit(unit):GetRange() <= 7 and ((A.UnholyAssault:IsTalentLearned()) or (GargoyleActive and A.SummonGargoyle:IsTalentLearned()) or A.ArmyoftheDamned:IsTalentLearned()) then
                return A.Trinket2:Show(icon)    
            end     
					
			--actions.covenants=swarming_mist,if=variable.st_planning&runic_power.deficit>16
			if A.SwarmingMist:IsReady() and MultiUnits:GetByRange(10, AoETargets) < AoETargets and RunicPowerDeficit > 16 then
				return A.SwarmingMist:Show(icon)
			end
		  
			--actions.covenants+=/swarming_mist,if=cooldown.apocalypse.remains&(active_enemies>=2&active_enemies<=5&runic_power.deficit>10+(active_enemies*6)|active_enemies>5&runic_power.deficit>40)
			if A.SwarmingMist:IsReady() and A.Apocalypse:GetCooldown() > 0 and (MultiUnits:GetByRange(10, AoETargets) >= AoETargets and MultiUnits:GetByRange(10, 6) <= 5 and RunicPowerDeficit > (10 + (6 * MultiUnits:GetByRange(10, 10))) or MultiUnits:GetByRange(10, 6) > 5 and RunicPowerDeficit>40) then
				return A.SwarmingMist:Show(icon)
			end	   
			
			--actions.covenants+=/abomination_limb,if=variable.st_planning&!soulbind.lead_by_example&cooldown.apocalypse.remains&rune.time_to_4>(3+buff.runic_corruption.remains)
			if A.AbominationLimb:IsReady() and MultiUnits:GetByRange(10, AoETargets) < AoETargets and not A.LeadbyExample:IsSoulbindLearned() and A.Apocalypse:GetCooldown() > 0 and Player:RuneTimeToX(4) > (3 + Unit(player):HasBuffs(A.RunicCorruption.ID, true)) then
				return A.AbominationLimb:Show(icon)
			end
		
			--actions.covenants+=/abomination_limb,if=variable.st_planning&soulbind.lead_by_example&(cooldown.unholy_blight.remains|!talent.unholy_blight&cooldown.dark_transformation.remains)
			if A.AbominationLimb:IsReady() and MultiUnits:GetByRange(10, AoETargets) < AoETargets and A.LeadbyExample:IsSoulbindLearned() and (A.UnholyBlight:GetCooldown() > 0 or not A.UnholyBlight:IsTalentLearned() and A.DarkTransformation:GetCooldown() > 0) then
				return A.AbominationLimb:Show(icon)
			end
		
			--actions.covenants+=/abomination_limb,if=active_enemies>=2&rune.time_to_4>(3+buff.runic_corruption.remains)
			if A.AbominationLimb:IsReady() and MultiUnits:GetByRange(10, AoETargets) >= AoETargets and Player:RuneTimeToX(4) > (3 + Unit(player):HasBuffs(A.RunicCorruption.ID, true)) then
				return A.AbominationLimb:Show(icon)
			end
			
			--actions.covenants+=/shackle_the_unworthy,if=variable.st_planning&cooldown.apocalypse.remains
			if A.ShackletheUnworthy:IsReady(unit) and MultiUnits:GetByRange(10, AoETargets) < AoETargets and A.Apocalypse:GetCooldown() > 0 then
				return A.ShackletheUnworthy:Show(icon)
			end
		
			--actions.covenants+=/shackle_the_unworthy,if=active_enemies>=2&(death_and_decay.ticking|raid_event.adds.remains<=14)
			if A.ShackletheUnworthy:IsReady(unit) and MultiUnits:GetByRange(10, AoETargets) >= AoETargets and (DeathandDecayTicking or MultiUnits:GetByRange(10, 15) <= 14) then
				return A.ShackletheUnworthy:Show(icon)
			end
			
			--actions.cooldowns+=/army_of_the_dead,if=cooldown.unholy_blight.remains<3&cooldown.dark_transformation.remains<3&talent.unholy_blight&!soulbind.lead_by_example|!talent.unholy_blight|fight_remains<35
			if A.ArmyoftheDead:IsReady(player) and CanUseArmyofDead(unitID, AoETargets) and A.UnholyBlight:GetCooldown() < 3 and A.DarkTransformation:GetCooldown() < 3 and A.UnholyBlight:IsTalentLearned() and (not A.LeadbyExample:IsSoulbindLearned() or not A.UnholyBlight:IsTalentLearned() or Player:AreaTTD(10) > 35 or Unit(unit):IsDummy()) then
				return A.ArmyoftheDead:Show(icon)
			end	
			
			--Army with legoswap
			if A.ArmyoftheDead:IsReady(player) and CanUseArmyofDead(unitID, AoETargets) and Action.GetToggle(2,"LegoSwap") and Unit("player"):CombatTime() < 15 and A.UnholyBlight:GetCooldown() < 3 and A.UnholyBlight:IsTalentLearned() and (not A.LeadbyExample:IsSoulbindLearned() or not A.UnholyBlight:IsTalentLearned() or Player:AreaTTD(10) > 35 or Unit(unit):IsDummy()) then
				return A.ArmyoftheDead:Show(icon)
			end

			
			--actions.cooldowns+=/army_of_the_dead,if=cooldown.unholy_blight.remains<3&cooldown.abomination_limb.ready&soulbind.lead_by_example
			if A.ArmyoftheDead:IsReady(player) and CanUseArmyofDead(unitID, AoETargets) and A.UnholyBlight:GetCooldown() < 3 and A.AbominationLimb:IsReady() and A.LeadbyExample:IsSoulbindLearned() then
				return A.ArmyoftheDead:Show(icon)
			end
			
			--actions.cooldowns+=/unholy_blight,if=variable.st_planning&(cooldown.dark_transformation.remains<gcd|buff.dark_transformation.up)&(!runeforge.deadliest_coil|!talent.army_of_the_damned|conduit.convocation_of_the_dead.rank<5)
			if A.UnholyBlight:IsReady(player) and Unit("target"):GetRange() < 10 and MultiUnits:GetByRange(10, AoETargets) < AoETargets and (A.DarkTransformation:IsReadyByPassCastGCD() or Unit("pet"):HasBuffs(A.DarkTransformation.ID, true) > 0) and (not A.DeadliestCoil:HasLegendaryCraftingPower() or not A.ArmyoftheDamned:IsTalentLearned() or not A.ConvocationoftheDead:IsSoulbindLearned()) then
				return A.UnholyBlight:Show(icon)
			end
			
            --actions.cooldowns+=/unholy_blight,if=variable.st_planning&runeforge.deadliest_coil&talent.army_of_the_damned&conduit.convocation_of_the_dead.rank>=5&cooldown.apocalypse.remains<3&(cooldown.dark_transformation.remains<gcd|buff.dark_transformation.up)
            if A.UnholyBlight:IsReady(player) and Unit("target"):GetRange() < 10 and MultiUnits:GetByRange(10, AoETargets) < AoETargets and A.DeadliestCoil:HasLegendaryCraftingPower() and A.ArmyoftheDamned:IsTalentLearned() and A.ConvocationoftheDead:IsSoulbindLearned() and A.Apocalypse:GetCooldown() < 3 and (A.DarkTransformation:IsReadyByPassCastGCD() or Unit("pet"):HasBuffs(A.DarkTransformation.ID, true) > 0) then
                return A.UnholyBlight:Show(icon)
            end     
		
			--actions.cooldowns+=/unholy_blight,if=active_enemies>=2|fight_remains<21
			if A.UnholyBlight:IsReady(player) and Unit("target"):GetRange() < 10 and (MultiUnits:GetByRange(10, AoETargets) >= AoETargets or Player:AreaTTD(10) < 21) then
				return A.UnholyBlight:Show(icon)
			end
            
            --actions.cooldowns+=/dark_transformation,if=variable.st_planning&(dot.unholy_blight_dot.remains|!talent.unholy_blight)
            if A.DarkTransformation:IsReady(player) and Unit("pet"):HasDeBuffs(A.ControlUndead.ID, true) == 0 and MultiUnits:GetByRange(10, AoETargets) < AoETargets and (Unit("target"):HasDeBuffs(A.UnholyBlightDebuff.ID, true) > 0 or not A.UnholyBlight:IsTalentLearned()) then
                return A.DarkTransformation:Show(icon)
            end    
            
            --actions.cooldowns+=/dark_transformation,if=active_enemies>=2|fight_remains<21
            if A.DarkTransformation:IsReady(player) and Unit("pet"):HasDeBuffs(A.ControlUndead.ID, true) == 0 and (MultiUnits:GetByRange(10, AoETargets) >= AoETargets or Player:AreaTTD(10) < 5) then
                return A.DarkTransformation:Show(icon)
            end    
			
            --actions.cooldowns+=/apocalypse,if=active_enemies=1&debuff.festering_wound.stack>=4&talent.unholy_blight&talent.army_of_the_damned&runeforge.deadliest_coil&conduit.convocation_of_the_dead.rank>=5&dot.unholy_blight_dot.remains
            if A.Apocalypse:IsReady(unit) and MultiUnits:GetByRange(10, AoETargets) < AoETargets and Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) >= 4 and A.UnholyBlight:IsTalentLearned() and A.ArmyoftheDamned:IsTalentLearned() and A.DeadliestCoil:HasLegendaryCraftingPower() and A.ConvocationoftheDead:IsSoulbindLearned() and Unit("target"):HasDeBuffs(A.UnholyBlightDebuff.ID, true) > 0 then
                return A.Apocalypse:Show(icon)
            end    
            
			--actions.cooldowns+=/apocalypse,if=active_enemies=1&debuff.festering_wound.stack>=4&talent.unholy_blight&dot.unholy_blight_dot.remains>10&!talent.army_of_the_damned&conduit.convocation_of_the_dead.rank<5
			if A.Apocalypse:IsReady(unit) and MultiUnits:GetByRange(10, AoETargets) < AoETargets and Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) >= 4 and A.UnholyBlight:IsTalentLearned() and Unit("target"):HasDeBuffs(A.UnholyBlightDebuff.ID, true) > 10 and not A.ArmyoftheDamned:IsTalentLearned() and not A.ConvocationoftheDead:IsSoulbindLearned() then
				return A.Apocalypse:Show(icon)
			end
			
			--actions.cooldowns+=/apocalypse,if=active_enemies=1&debuff.festering_wound.stack>=4&(!talent.unholy_blight|talent.army_of_the_damned&(!runeforge.deadliest_coil|conduit.convocation_of_the_dead.rank<5)|!talent.army_of_the_damned&conduit.convocation_of_the_dead.rank>=5|fight_remains<16)
			if A.Apocalypse:IsReady(unit) and MultiUnits:GetByRange(10, AoETargets) < AoETargets and Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) >= 4 and (not A.UnholyBlight:IsTalentLearned() or (A.ArmyoftheDamned:IsTalentLearned() and ((not A.DeadliestCoil:HasLegendaryCraftingPower() or not A.ConvocationoftheDead:IsSoulbindLearned())) or (not A.ArmyoftheDamned:IsTalentLearned() and A.ConvocationoftheDead:IsSoulbindLearned())) or Player:AreaTTD(10) < 16) then
				return A.Apocalypse:Show(icon)
			end
			
            --actions.cooldowns+=/apocalypse,target_if=max:debuff.festering_wound.stack,if=active_enemies>=2&debuff.festering_wound.stack>=4&!death_and_decay.ticking
            if A.Apocalypse:IsReady(unit) and MultiUnits:GetByRange(10, AoETargets) >= AoETargets and Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) >= 4 and not DeathandDecayTicking then
                return A.Apocalypse:Show(icon)
            end    
            
            --actions.cooldowns+=/summon_gargoyle,if=runic_power.deficit<14&(cooldown.unholy_blight.remains<10|dot.unholy_blight_dot.remains)
            if A.SummonGargoyle:IsReady(unit) and RunicPowerDeficit < 14 and (A.UnholyBlight:GetCooldown() < 10 or Unit("target"):HasDeBuffs(A.UnholyBlightDebuff.ID, true) > 0) then
                return A.SummonGargoyle:Show(icon)
            end    
            
            --actions.cooldowns+=/unholy_assault,if=variable.st_planning&debuff.festering_wound.stack<2&(pet.apoc_ghoul.active|conduit.convocation_of_the_dead&buff.dark_transformation.up&!pet.army_ghoul.active)
            if A.UnholyAssault:IsReady(unit) and Unit("target"):GetRange() < 10 and MultiUnits:GetByRange(10, AoETargets) < AoETargets and Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) < 2 and (A.Apocalypse:GetSpellTimeSinceLastCast() < 15 or (A.ConvocationoftheDead:IsSoulbindLearned() and Unit("pet"):HasBuffs(A.DarkTransformation.ID, true) > 0) and not A.ArmyoftheDead:GetSpellTimeSinceLastCast() > 30) then
                return A.UnholyAssault:Show(icon)
            end    
            
            --actions.cooldowns+=/unholy_assault,target_if=min:debuff.festering_wound.stack,if=active_enemies>=2&debuff.festering_wound.stack<2
            if A.UnholyAssault:IsReady(unit) and Unit("target"):GetRange() < 10 and MultiUnits:GetByRange(10, AoETargets) >= AoETargets and Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) < 2 then
                return A.UnholyAssault:Show(icon)
            end    
            
            --actions.cooldowns+=/soul_reaper,target_if=target.time_to_pct_35<5&target.time_to_die>5
            if A.SoulReaper:IsReady(unit) and Unit("target"):TimeToDieX(35) < 5 and Unit("target"):TimeToDie() > 5 then
                return A.SoulReaper:Show(icon)
            end    
			
			--actions.cooldowns+=/raise_dead,if=!pet.ghoul.active
			if not Pet:IsActive() and A.RaiseDead:IsReady() then
				return A.RaiseDead:Show(icon)
			end 
			
			--actions.cooldowns+=/sacrificial_pact,if=active_enemies>=2&!buff.dark_transformation.up&!cooldown.dark_transformation.ready
			if A.SacrificialPact:IsReady() and A.RaiseDead:IsReady() and MultiUnits:GetByRange(10, AoETargets) >= AoETargets and Unit("pet"):HasBuffs(A.DarkTransformation.ID, true) == 0 and A.DarkTransformation:GetCooldown() > 0 then
				return A.SacrificialPact:Show(icon)
			end
			
			--actions.cooldowns+=/raise_dead,if=!pet.ghoul.active
			if not Pet:IsActive() and A.RaiseDead:IsReady() then
				return A.RaiseDead:Show(icon)
			end 

            
        end
        
        --######################
        --##### GENERIC ST #####
        --######################
        
        local function GenericST()
            
            --actions.generic=death_coil,if=buff.sudden_doom.react&!variable.pooling_for_gargoyle|pet.gargoyle.active
            if A.DeathCoil:IsReady(unit) and Unit(player):HasBuffs(A.SuddenDoomBuff.ID, true) > 0 and not (VarPoolingForGargoyle or GargoyleActive) then
                return A.DeathCoil:Show(icon)
            end    
            
            --actions.generic+=/death_coil,if=runic_power.deficit<13&!variable.pooling_for_gargoyle
            if A.DeathCoil:IsReady(unit) and RunicPowerDeficit < 13 and not VarPoolingForGargoyle then
                return A.DeathCoil:Show(icon)
            end    
            
            --actions.generic+=/any_dnd,if=cooldown.apocalypse.remains&(talent.defile.enabled|covenant.night_fae|runeforge.phearomones)
            if A.Defile:IsReady(player) and A.Apocalypse:GetCooldown() > 0 and (A.Defile:IsTalentLearned() or A.Phearomones:HasLegendaryCraftingPower()) then
                return A.Defile:Show(icon)
            end    
			
			if A.DeathsDue:IsReady(player) and A.Apocalypse:GetCooldown() > 0 and (A.Phearomones:HasLegendaryCraftingPower()) then
                return A.DeathsDue:Show(icon)
            end  
            
            --actions.generic+=/wound_spender,if=debuff.festering_wound.stack>4
            if A.ScourgeStrike:IsReady(unit) and Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) > 4 then
                return A.ScourgeStrike:Show(icon)
            end    
            
            if A.ClawingShadows:IsReady(unit) and Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) > 4 then
                return A.ClawingShadows:Show(icon)
            end
            
            --actions.generic+=/wound_spender,if=debuff.festering_wound.up&cooldown.apocalypse.remains>5&(!talent.unholy_blight|talent.army_of_the_damned&conduit.convocation_of_the_dead.rank<5|!talent.army_of_the_damned&conduit.convocation_of_the_dead.rank>=5|!conduit.convocation_of_the_dead)
            if A.ScourgeStrike:IsReady(unit) and Unit("target"):HasDeBuffs(A.FesteringWound.ID, true) > 0 and A.Apocalypse:GetCooldown() > 5 and (not A.UnholyBlight:IsTalentLearned() or (A.ArmyoftheDamned:IsTalentLearned() and not A.ConvocationoftheDead:IsSoulbindLearned()) or (not A.ArmyoftheDamned:IsTalentLearned() and A.ConvocationoftheDead:IsSoulbindLearned()) or not A.ConvocationoftheDead:IsSoulbindLearned()) then
                return A.ScourgeStrike:Show(icon)
            end    
            
            if A.ClawingShadows:IsReady(unit) and Unit("target"):HasDeBuffs(A.FesteringWound.ID, true) > 0 and A.Apocalypse:GetCooldown() > 5 and (not A.UnholyBlight:IsTalentLearned() or (A.ArmyoftheDamned:IsTalentLearned() and not A.ConvocationoftheDead:IsSoulbindLearned()) or (not A.ArmyoftheDamned:IsTalentLearned() and A.ConvocationoftheDead:IsSoulbindLearned()) or not A.ConvocationoftheDead:IsSoulbindLearned()) then
                return A.ClawingShadows:Show(icon)
            end               
            
            --actions.generic+=/wound_spender,if=debuff.festering_wound.up&talent.unholy_blight&(!talent.army_of_the_damned&conduit.convocation_of_the_dead.rank<5|talent.army_of_the_damned&conduit.convocation_of_the_dead.rank>=5)&(cooldown.unholy_blight.remains>10&!dot.unholy_blight_dot.remains|cooldown.apocalypse.remains>10)
            if A.ScourgeStrike:IsReady(unit) and Unit("target"):HasDeBuffs(A.FesteringWound.ID, true) > 0 and A.UnholyBlight:IsTalentLearned() and ((not A.ArmyoftheDamned:IsTalentLearned() and not A.ConvocationoftheDead:IsSoulbindLearned()) or (A.ArmyoftheDamned:IsTalentLearned() and A.ConvocationoftheDead:IsSoulbindLearned())) and (A.UnholyBlight:GetCooldown() > 10 and Unit("target"):HasDeBuffs(A.UnholyBlightDebuff.ID, true) <= 0 or A.Apocalypse:GetCooldown() > 10) then
                return A.ScourgeStrike:Show(icon)
            end    
            
            if A.ClawingShadows:IsReady(unit) and Unit("target"):HasDeBuffs(A.FesteringWound.ID, true) > 0 and A.UnholyBlight:IsTalentLearned() and ((not A.ArmyoftheDamned:IsTalentLearned() and not A.ConvocationoftheDead:IsSoulbindLearned()) or (A.ArmyoftheDamned:IsTalentLearned() and A.ConvocationoftheDead:IsSoulbindLearned())) and (A.UnholyBlight:GetCooldown() > 10 and Unit("target"):HasDeBuffs(A.UnholyBlightDebuff.ID, true) <= 0 or A.Apocalypse:GetCooldown() > 10) then
                return A.ClawingShadows:Show(icon)
            end

			--Wound Spender if CD is off
			if A.ScourgeStrike:IsReady(unit) and not A.BurstIsON(unit) and Unit("target"):HasDeBuffs(A.FesteringWound.ID, true) > 0 then
				return A.ScourgeStrike:Show(icon)
			end
			
			if A.ClawingShadows:IsReady(unit) and not A.BurstIsON(unit) and Unit("target"):HasDeBuffs(A.FesteringWound.ID, true) > 0 then
				return A.ScourgeStrike:Show(icon)
			end
			
            --actions.generic+=/death_coil,if=runic_power.deficit<20&!variable.pooling_for_gargoyle
            if A.DeathCoil:IsReady(unit) and RunicPowerDeficit < 20 and not VarPoolingForGargoyle then
                return A.DeathCoil:Show(icon)
            end    
            
            --actions.generic+=/festering_strike,if=debuff.festering_wound.stack<1
            if A.FesteringStrike:IsReady(unit) and Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) < 1 then
                return A.FesteringStrike:Show(icon)
            end    
            
            --actions.generic+=/festering_strike,if=debuff.festering_wound.stack<4&cooldown.apocalypse.remains<5&(!talent.unholy_blight|talent.army_of_the_damned&conduit.convocation_of_the_dead.rank<5|!talent.army_of_the_damned&conduit.convocation_of_the_dead.rank>=5|!conduit.convocation_of_the_dead)
            if A.FesteringStrike:IsReady(unit) and A.BurstIsON(unit) and Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) < 4 and A.Apocalypse:GetCooldown() < 5 and (not A.UnholyBlight:IsTalentLearned() or (A.ArmyoftheDamned:IsTalentLearned() and not A.ConvocationoftheDead:IsSoulbindLearned()) or (not A.ArmyoftheDamned:IsTalentLearned() and A.ConvocationoftheDead:IsSoulbindLearned()) or not A.ConvocationoftheDead:IsSoulbindLearned()) then
                return A.FesteringStrike:Show(icon)
            end    
            
            --actions.generic+=/festering_strike,if=debuff.festering_wound.stack<4&talent.unholy_blight&(!talent.army_of_the_damned&conduit.convocation_of_the_dead.rank<5|talent.army_of_the_damned&conduit.convocation_of_the_dead.rank>=5)&(cooldown.unholy_blight.remains<10|cooldown.apocalypse.remains<10&dot.unholy_blight_dot.remains)
            if A.FesteringStrike:IsReady(unit) and A.BurstIsON(unit) and Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) < 4 and A.UnholyBlight:IsTalentLearned() and ((not A.ArmyoftheDamned:IsTalentLearned() and not A.ConvocationoftheDead:IsSoulbindLearned()) or (A.ArmyoftheDamned:IsTalentLearned() and A.ConvocationoftheDead:IsSoulbindLearned())) and (A.UnholyBlight:GetCooldown() < 10 or (A.Apocalypse:GetCooldown() < 10 and Unit("target"):HasDeBuffs(A.UnholyBlightDebuff.ID, true) > 0)) then
                return A.FesteringStrike:Show(icon)
            end

			--if Burst is off
			if A.FesteringStrike:IsReady(unit) and not A.BurstIsON(unit) and Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) < 1 then
                return A.FesteringStrike:Show(icon)
            end
            
            --actions.generic+=/death_coil,if=!variable.pooling_for_gargoyle
            if A.DeathCoil:IsReady(unit) and not VarPoolingForGargoyle then
                return A.DeathCoil:Show(icon)
            end
            
        end
        
        --#######################
        --##### GENERIC AOE #####
        --#######################
        
        local function GenericAOE()
            
			--actions.cooldowns+=/soul_reaper,target_if=target.time_to_pct_35<5&target.time_to_die>5
            if A.SoulReaper:IsReady(unit) and Unit("target"):TimeToDieX(35) < 5 and Unit("target"):TimeToDie() > 5 then
                return A.SoulReaper:Show(icon)
            end 
			
            --actions.generic_aoe=epidemic,if=buff.sudden_doom.react
            if A.Epidemic:IsReady(player) and ((A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 4) > 3) or (not A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) > 2)) and Unit(player):HasBuffs(A.SuddenDoomBuff.ID, true) > 0 and Unit("target"):HasDeBuffs(A.VirulentPlague.ID, true) > 0 then
                return A.Epidemic:Show(icon)
            end  

            if A.DeathCoil:IsReady(unit) and ((A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 4) <= 3) or (not A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) <= 2)) and Unit(player):HasBuffs(A.SuddenDoomBuff.ID, true) > 0 then
				return A.DeathCoil:Show(icon)
			end
            
            --actions.generic_aoe+=/epidemic,if=!variable.pooling_for_gargoyle
            if A.Epidemic:IsReady(player) and ((A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 4) > 3) or (not A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) > 2)) and not VarPoolingForGargoyle and Unit("target"):HasDeBuffs(A.VirulentPlague.ID, true) > 0 then
                return A.Epidemic:Show(icon)
            end 

            if A.DeathCoil:IsReady(unit) and ((A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 4) <= 3) or (not A.DeadliestCoil:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10, 3) <= 2)) and not VarPoolingForGargoyle then
				return A.DeathCoil:Show(icon)
			end
			
            --actions.generic_aoe+=/wound_spender,target_if=max:debuff.festering_wound.stack,if=(cooldown.apocalypse.remains>5&debuff.festering_wound.up|debuff.festering_wound.stack>4)&(fight_remains<cooldown.death_and_decay.remains+10|fight_remains>cooldown.apocalypse.remains)
            if A.ScourgeStrike:IsReady(unit) and ((A.Apocalypse:GetCooldown() > 5 and Unit("target"):HasDeBuffs(A.FesteringWound.ID, true) > 0) or Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) > 4) and (Player:AreaTTD(10) < (A.DeathandDecay:GetCooldown() + 10) or (Player:AreaTTD(8) > A.Apocalypse:GetCooldown())) then 
                return A.ScourgeStrike:Show(icon)
            end    
            
            if A.ClawingShadows:IsReady(unit) and ((A.Apocalypse:GetCooldown() > 5 and Unit("target"):HasDeBuffs(A.FesteringWound.ID, true) > 0) or Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) > 4) and (Player:AreaTTD(10) < (A.DeathandDecay:GetCooldown() + 10) or (Player:AreaTTD(8) > A.Apocalypse:GetCooldown())) then 
                return A.ClawingShadows:Show(icon)
            end

			--if Burst is off
			if A.ScourgeStrike:IsReady(unit) and not A.BurstIsON(unit) and (Unit("target"):HasDeBuffs(A.FesteringWound.ID, true) > 0) then 
                return A.ScourgeStrike:Show(icon)
            end

			if A.ClawingShadows:IsReady(unit) and not A.BurstIsON(unit) and (Unit("target"):HasDeBuffs(A.FesteringWound.ID, true) > 0) then 
                return A.ClawingShadows:Show(icon)
            end   
            
            --actions.generic_aoe+=/festering_strike,target_if=max:debuff.festering_wound.stack,if=debuff.festering_wound.stack<=3&cooldown.apocalypse.remains<3|debuff.festering_wound.stack<1
            if A.FesteringStrike:IsReady(unit) and A.BurstIsON(unit) and Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) <= 3 and A.Apocalypse:GetCooldown() < 3 or Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) < 1 then
                return A.FesteringStrike:Show(icon)
            end
            
            --actions.generic_aoe+=/festering_strike,target_if=min:debuff.festering_wound.stack,if=cooldown.apocalypse.remains>5&debuff.festering_wound.stack<1
            if A.FesteringStrike:IsReady(unit) and A.BurstIsON(unit) and A.Apocalypse:GetCooldown() > 5 and Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) < 1 then
                return A.FesteringStrike:Show(icon)
            end        
			
			--Festering if Burst if off
            if A.FesteringStrike:IsReady(unit) and not A.BurstIsON and Unit("target"):HasDeBuffsStacks(A.FesteringWound.ID, true) < 1 then
                return A.FesteringStrike:Show(icon)
            end  
            
        end    
        
        
        --actions+=/call_action_list,name=cooldowns
        if A.BurstIsON(unit) and inCombat and Cooldowns() then     
            return Cooldowns()
        end
        
        --actions+=/run_action_list,name=aoe_setup,if=active_enemies>=2&(cooldown.death_and_decay.remains<10&!talent.defile|cooldown.defile.remains<10&talent.defile)&!death_and_decay.ticking
        if MultiUnits:GetByRange(10, AoETargets) >= AoETargets and (A.DeathandDecay:GetCooldown() < 10 and not A.Defile:IsTalentLearned() or A.Defile:GetCooldown() < 10 and A.Defile:IsTalentLearned()) and not DeathandDecayTicking and inCombat then             
            return AoESetup()
        end
        
        --actions+=/run_action_list,name=aoe_burst,if=active_enemies>=2&death_and_decay.ticking
        if MultiUnits:GetByRange(10, AoETargets) >= AoETargets and DeathandDecayTicking then             
            return AoEBurst()
        end    
        
        --actions+=/run_action_list,name=generic_aoe,if=active_enemies>=2&(!death_and_decay.ticking&(cooldown.death_and_decay.remains>10&!talent.defile.enabled|cooldown.defile.remains>10&talent.defile.enabled))
        if MultiUnits:GetByRange(10, AoETargets) >= AoETargets and (not DeathandDecayTicking and ((A.DeathandDecay:GetCooldown() > 10 and not A.Defile:IsTalentLearned()) or (A.Defile:GetCooldown() > 10 and A.Defile:IsTalentLearned()))) then             
            return GenericAOE()
        end    
        
        --actions+=/call_action_list,name=generic,if=active_enemies=1
        if MultiUnits:GetByRange(10, AoETargets) < AoETargets then             
            return GenericST()
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
