--##############################
--##### TRIP'S HOLY PRIEST #####
--##############################

local _G, setmetatable							= _G, setmetatable
local A                         			    = _G.Action
local Covenant									= _G.LibStub("Covenant")
local TMW										= _G.TMW
local Listener                                  = Action.Listener
local Create                                    = Action.Create
local GetToggle                                 = Action.GetToggle
local SetToggle                                 = Action.SetToggle
local GetGCD                                    = Action.GetGCD
local GetCurrentGCD                             = Action.GetCurrentGCD
local GetPing                                   = Action.GetPing
local ShouldStop                                = Action.ShouldStop
local BurstIsON                                 = Action.BurstIsON
local CovenantIsON								= Action.CovenantIsON
local AuraIsValid                               = Action.AuraIsValid
local InterruptIsValid                          = Action.InterruptIsValid
local FrameHasSpell                             = Action.FrameHasSpell
local Utils                                     = Action.Utils
local TeamCache                                 = Action.TeamCache
local EnemyTeam                                 = Action.EnemyTeam
local FriendlyTeam                              = Action.FriendlyTeam
local LoC                                       = Action.LossOfControl
local Player                                    = Action.Player 
local MultiUnits                                = Action.MultiUnits
local UnitCooldown                              = Action.UnitCooldown
local Unit                                      = Action.Unit 
local IsUnitEnemy                               = Action.IsUnitEnemy
local IsUnitFriendly                            = Action.IsUnitFriendly
local ActiveUnitPlates                          = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
local pairs                                     = pairs
local HealingEngine 							= Action.HealingEngine
local TeamCacheFriendly                         = TeamCache.Friendly
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
local UnitExists, UnitIsPlayer, UnitClass, UnitCreatureType, UnitInRange, UnitInRaid, UnitInParty, UnitGUID, UnitPower, UnitPowerMax = 
UnitExists, UnitIsPlayer, UnitClass, UnitCreatureType, UnitInRange, UnitInRaid, UnitInParty, UnitGUID, UnitPower, UnitPowerMax

--For Toaster
local Toaster									= _G.Toaster
local GetSpellTexture 							= _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999


Action[ACTION_CONST_PRIEST_HOLY] = {
    -- Racial
    ArcaneTorrent					= Action.Create({ Type = "Spell", ID = 50613	}),
    BloodFury						= Action.Create({ Type = "Spell", ID = 20572	}),
    Fireblood						= Action.Create({ Type = "Spell", ID = 265221	}),
    AncestralCall					= Action.Create({ Type = "Spell", ID = 274738	}),
    Berserking						= Action.Create({ Type = "Spell", ID = 26297    }),
    ArcanePulse						= Action.Create({ Type = "Spell", ID = 260364	}),
    QuakingPalm						= Action.Create({ Type = "Spell", ID = 107079	}),
    Haymaker						= Action.Create({ Type = "Spell", ID = 287712	}), 
    WarStomp						= Action.Create({ Type = "Spell", ID = 20549	}),
    BullRush						= Action.Create({ Type = "Spell", ID = 255654	}),  
    GiftofNaaru						= Action.Create({ Type = "Spell", ID = 59544    }),
    Shadowmeld						= Action.Create({ Type = "Spell", ID = 58984    }), -- Used for HoA
    Stoneform						= Action.Create({ Type = "Spell", ID = 20594    }), 
    BagofTricks						= Action.Create({ Type = "Spell", ID = 312411	}),
    WilloftheForsaken				= Action.Create({ Type = "Spell", ID = 7744		}), -- not usable in APL but user can Queue it   
    EscapeArtist					= Action.Create({ Type = "Spell", ID = 20589    }), -- not usable in APL but user can Queue it
    EveryManforHimself				= Action.Create({ Type = "Spell", ID = 59752    }), -- not usable in APL but user can Queue it
	RocketJump						= Action.Create({ Type = "Spell", ID = 69070 	}), -- used for Circle of Healing

	--Priest General
    DesperatePrayer					= Action.Create({ Type = "Spell", ID = 19236 	}),
	DispelMagic						= Action.Create({ Type = "Spell", ID = 528 		}),
	Fade							= Action.Create({ Type = "Spell", ID = 586 		}),
	FlashHeal						= Action.Create({ Type = "Spell", ID = 2061 	}),
	LeapofFaith						= Action.Create({ Type = "Spell", ID = 73325 	}),
	Levitate						= Action.Create({ Type = "Spell", ID = 1706 	}),
	MassDispel						= Action.Create({ Type = "Spell", ID = 32375 	}),
	MindBlast						= Action.Create({ Type = "Spell", ID = 8092 	}),
	MindControl						= Action.Create({ Type = "Spell", ID = 605 		}),
	MindVision						= Action.Create({ Type = "Spell", ID = 2096 	}),
	PowerWordFortitude				= Action.Create({ Type = "Spell", ID = 21562 	}),
	PowerWordShield					= Action.Create({ Type = "Spell", ID = 17 		}),
	PsychicScream					= Action.Create({ Type = "Spell", ID = 8122 	}),
	Resurrection					= Action.Create({ Type = "Spell", ID = 2006 	}),
	ShackleUndead					= Action.Create({ Type = "Spell", ID = 9484 	}),
	ShadowWordDeath					= Action.Create({ Type = "Spell", ID = 32379 	}),
	ShadowWordPain					= Action.Create({ Type = "Spell", ID = 589 		}),	
	Smite							= Action.Create({ Type = "Spell", ID = 585 		}),
	FocusedWill						= Action.Create({ Type = "Spell", ID = 45243, Hidden = true 	}),
	MindSoothe						= Action.Create({ Type = "Spell", ID = 453 		}),
	PowerInfusion					= Action.Create({ Type = "Spell", ID = 10060 	}),
	
	-- Holy Specific
    CircleofHealing					= Action.Create({ Type = "Spell", ID = 204883	}),
    DivineHymn						= Action.Create({ Type = "Spell", ID = 64843	}),
    GuardianSpirit					= Action.Create({ Type = "Spell", ID = 47788	}),	
    Heal							= Action.Create({ Type = "Spell", ID = 2060		}),	
    HolyFire						= Action.Create({ Type = "Spell", ID = 14914	}),
    HolyNova						= Action.Create({ Type = "Spell", ID = 132157	}),
    HolyWordChastise				= Action.Create({ Type = "Spell", ID = 88625	}),	
    HolyWordSanctify				= Action.Create({ Type = "Spell", ID = 34861	}),	
    HolyWordSerenity				= Action.Create({ Type = "Spell", ID = 2050		}),
	MassResurrection				= Action.Create({ Type = "Spell", ID = 212036	}),
    PrayerofHealing					= Action.Create({ Type = "Spell", ID = 596		}),
    PrayerofMending					= Action.Create({ Type = "Spell", ID = 33076	}),
    PrayerofMendingBuff				= Action.Create({ Type = "Spell", ID = 41635, Hidden = true 	}),	
    Purify							= Action.Create({ Type = "Spell", ID = 527		}),
    Renew							= Action.Create({ Type = "Spell", ID = 139		}),	
    SymbolofHope					= Action.Create({ Type = "Spell", ID = 64901	}),
    MasteryEchoofLight				= Action.Create({ Type = "Spell", ID = 77485, Hidden = true		}),
    SpiritofRedemption				= Action.Create({ Type = "Spell", ID = 20711, Hidden = true		}),	

	-- Normal Talents
    Enlightenment					= Action.Create({ Type = "Spell", ID = 193155, Hidden = true	}),
    TrailofLight					= Action.Create({ Type = "Spell", ID = 200128, Hidden = true	}),	
    RenewedFaith					= Action.Create({ Type = "Spell", ID = 341997, Hidden = true	}),
    AngelsMercy						= Action.Create({ Type = "Spell", ID = 238100, Hidden = true	}),
    BodyandSoul						= Action.Create({ Type = "Spell", ID = 64129, Hidden = true 	}),
    AngelicFeather					= Action.Create({ Type = "Spell", ID = 121536	}),	
    CosmicRipple					= Action.Create({ Type = "Spell", ID = 238136, Hidden = true	}),	
    GuardianAngel					= Action.Create({ Type = "Spell", ID = 200209, Hidden = true	}),
    Afterlife						= Action.Create({ Type = "Spell", ID = 196707, Hidden = true	}),	
    PsychicVoice					= Action.Create({ Type = "Spell", ID = 196704, Hidden = true	}),
    Censure							= Action.Create({ Type = "Spell", ID = 200199, Hidden = true	}),	
    ShiningForce					= Action.Create({ Type = "Spell", ID = 204263	}),	
    SurgeofLight					= Action.Create({ Type = "Spell", ID = 109186, Hidden = true	}),
    SurgeofLightBuff				= Action.Create({ Type = "Spell", ID = 114255, Hidden = true	}),	
    BindingHeal						= Action.Create({ Type = "Spell", ID = 32546	}),	
    PrayerCircle					= Action.Create({ Type = "Spell", ID = 321377, Hidden = true	}),	
    Benediction						= Action.Create({ Type = "Spell", ID = 193157, Hidden = true	}),	
    DivineStar						= Action.Create({ Type = "Spell", ID = 110744	}),
    Halo							= Action.Create({ Type = "Spell", ID = 120517	}),
    LightoftheNaaru					= Action.Create({ Type = "Spell", ID = 196985, Hidden = true	}),	
    Apotheosis						= Action.Create({ Type = "Spell", ID = 200183	}),
	HolyWordSalvation				= Action.Create({ Type = "Spell", ID = 265202	}),

	-- PvP Talents
    HolyWard						= Action.Create({ Type = "Spell", ID = 213610	}),
    HolyWordConcentration			= Action.Create({ Type = "Spell", ID = 289657	}),
    GreaterHeal						= Action.Create({ Type = "Spell", ID = 289666	}),
    CircleofHealing					= Action.Create({ Type = "Spell", ID = 204883	}),	
    CardinalMending					= Action.Create({ Type = "Spell", ID = 328529, Hidden = true	}),
    MiracleWorker					= Action.Create({ Type = "Spell", ID = 235587, Hidden = true	}),	
    SpiritoftheRedeemer				= Action.Create({ Type = "Spell", ID = 215982	}),	
    RayofHope						= Action.Create({ Type = "Spell", ID = 197268	}),
    GreaterFade						= Action.Create({ Type = "Spell", ID = 213602	}),
    DeliveredfromEvil				= Action.Create({ Type = "Spell", ID = 196611, Hidden = true	}),
    CircleofHealing					= Action.Create({ Type = "Spell", ID = 204883	}),	
    Thoughtsteal					= Action.Create({ Type = "Spell", ID = 316262	}),
    DivineAscension					= Action.Create({ Type = "Spell", ID = 328530	}),	

	-- Covenant Abilities
    BoonoftheAscended				= Action.Create({ Type = "Spell", ID = 325013	}),
    SummonSteward					= Action.Create({ Type = "Spell", ID = 324739	}),
    Mindgames						= Action.Create({ Type = "Spell", ID = 323673	}),
    DoorofShadows					= Action.Create({ Type = "Spell", ID = 300728	}),
    UnholyNova						= Action.Create({ Type = "Spell", ID = 324724	}),
    Fleshcraft						= Action.Create({ Type = "Spell", ID = 331180	}),
    FaeGuardians					= Action.Create({ Type = "Spell", ID = 327661	}),
    Soulshape						= Action.Create({ Type = "Spell", ID = 310143	}),
    Flicker							= Action.Create({ Type = "Spell", ID = 324701	}),

	-- Conduits
	-- Holy Conduits
	FocusedMending					= Action.Create({ Type = "Spell", ID = 337914	}),
	HolyOration						= Action.Create({ Type = "Spell", ID = 338345	}),
	LastingSpirit					= Action.Create({ Type = "Spell", ID = 337811	}),	
	ResonantWords					= Action.Create({ Type = "Spell", ID = 337947	}),
	-- Covenant Conduits
	CourageousAscension				= Action.Create({ Type = "Spell", ID = 337966	}),
	ShatteredPerceptions			= Action.Create({ Type = "Spell", ID = 338315	}),
	FesteringTransfusion			= Action.Create({ Type = "Spell", ID = 337979	}),
	FaeFermata						= Action.Create({ Type = "Spell", ID = 338305	}),
	-- Endurance Conduits
	CharitableSoul					= Action.Create({ Type = "Spell", ID = 337715	}),
	LightsInspiration				= Action.Create({ Type = "Spell", ID = 337748	}),
	TranslucentImage				= Action.Create({ Type = "Spell", ID = 337662	}),
	-- Finese Conduits
	ClearMind						= Action.Create({ Type = "Spell", ID = 337707	}),
	MentalRecovery					= Action.Create({ Type = "Spell", ID = 337954	}),
	MoveWithGrace					= Action.Create({ Type = "Spell", ID = 337678	}),
	PowerUntoOthers					= Action.Create({ Type = "Spell", ID = 337762	}),	
	-- Legendaries
	-- General Legendaries
	CauterizingShadows				= Action.Create({ Type = "Spell", ID = 336370	}),
	MeasuredContemplation			= Action.Create({ Type = "Spell", ID = 341804	}),	
	TwinsoftheSunPriestess			= Action.Create({ Type = "Spell", ID = 336897	}),
	VaultofHeavens					= Action.Create({ Type = "Spell", ID = 336470	}),

	--Anima Powers - to add later...
	DivineImage						= Action.Create({ Type = "Spell", ID = 336400	}),
	FlashConcentration				= Action.Create({ Type = "Spell", ID = 336266	}),
	HarmoniousApparatus				= Action.Create({ Type = "Spell", ID = 336314	}),
	Xanshi							= Action.Create({ Type = "Spell", ID = 337477	}),	
	
	-- Trinkets
	

	-- Potions
    PotionofUnbridledFury			= Action.Create({ Type = "Potion", ID = 169299, QueueForbidden = true }), 	
    SuperiorPotionofUnbridledFury	= Action.Create({ Type = "Potion", ID = 168489, QueueForbidden = true }),
    PotionofSpectralAgility			= Action.Create({ Type = "Potion", ID = 171270, QueueForbidden = true }),
    PotionofSpectralStamina			= Action.Create({ Type = "Potion", ID = 171274, QueueForbidden = true }),
    PotionofEmpoweredExorcisms		= Action.Create({ Type = "Potion", ID = 171352, QueueForbidden = true }),
    PotionofHardenedShadows			= Action.Create({ Type = "Potion", ID = 171271, QueueForbidden = true }),
    PotionofPhantomFire				= Action.Create({ Type = "Potion", ID = 171349, QueueForbidden = true }),
    PotionofDeathlyFixation			= Action.Create({ Type = "Potion", ID = 171351, QueueForbidden = true }),
    SpiritualHealingPotion			= Action.Create({ Type = "Potion", ID = 171267, QueueForbidden = true }),  	

    -- Misc
    Channeling                      = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),    -- Show an icon during channeling
    TargetEnemy                     = Action.Create({ Type = "Spell", ID = 44603, Hidden = true     }),    -- Change Target (Tab button)
    StopCast                        = Action.Create({ Type = "Spell", ID = 61721, Hidden = true     }),        -- spell_magic_polymorphrabbit
    PoolResource                    = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),
	Quake                           = Action.Create({ Type = "Spell", ID = 240447, Hidden = true     }), -- Quake (Mythic Plus Affix)
}

-- To create essences use next code:
Action:CreateEssencesFor(ACTION_CONST_PRIEST_HOLY)  -- where PLAYERSPEC is Constance (example: ACTION_CONST_MONK_BM)
local A = setmetatable(Action[ACTION_CONST_PRIEST_HOLY], { __index = Action })

local Temp                                     = {
    TotalAndPhys                            = {"TotalImun", "DamagePhysImun"},
    TotalAndPhysKick                        = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                        = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun                     = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun                 = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMag                                = {"TotalImun", "DamageMagicImun"},
}

local player = "player"
local targettarget = "targettarget"
local target = "target"
local mouseover = "mouseover"

Toaster:Register("TripToast", function(toast, ...) -- Register Toaster
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

local function IsSchoolHolyFree() -- Holy locked
	return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "HOLY") == 0
end 

local function IsSchoolShadowFree() -- Shadow locked
	return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "SHADOW") == 0
end 

local function IsSchoolFireFree() -- Fire locked
	return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "FIRE") == 0
end 

local function GetValidMembers(IsPlayer) -- Get Friendly Group Members
    local HealingEngineMembersALL = HealingEngine.Data.SortedUnitIDs
    if not IsPlayer then 
        return #HealingEngineMembersALL
    else 
        local total = 0 
        if #HealingEngineMembersALL > 0 then 
            for i = 1, #HealingEngineMembersALL do
                if Unit(HealingEngineMembersALL[i].Unit):IsPlayer() then
                    total = total + 1
                end
            end 
        end 
        return total 
    end 
end

local function GetByRange(count, range, isStrictlySuperior, isStrictlyInferior, isStrictlyEqual, isCheckEqual, isCheckCombat) -- Range check function
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

local function Interrupts(unit)
    local useKick, useCC, useRacial = A.InterruptIsValid(unit)
    
    if useCC and A.HolyWordChastise:IsReady(unit) and A.HolyWordChastise:AbsentImun(unit, Temp.TotalAndPhysAndCC, true) and ((Unit(unit):IsControlAble("incapacitate", 0) and not A.Censure:IsTalentLearned()) or (Unit(unit):IsControlAble("stun", 0) and A.Censure:IsTalentLearned())) then 
        return A.HolyWordChastise              
    end             
    
    if useRacial and A.QuakingPalm:AutoRacial(unit, nil, nil, isSoothingMistCasting) then 
        return A.QuakingPalm
    end 
    
    if useRacial and A.Haymaker:AutoRacial(unit, nil, nil, isSoothingMistCasting) then 
        return A.Haymaker
    end 
    
    if useRacial and A.WarStomp:AutoRacial(unit, nil, nil, isSoothingMistCasting) then 
        return A.WarStomp
    end 
    
    if useRacial and A.BullRush:AutoRacial(unit, nil, nil, isSoothingMistCasting) then 
        return A.BullRush
    end      
	
end 
Interrupts = A.MakeFunctionCachedDynamic(Interrupts)

local function SelfDefensives() -- Defensives
    if Unit(player):CombatTime() == 0 then  
        return 
    end
    
    local DesperatePrayer = A.GetToggle(2, "DesperatePrayer")
    if    DesperatePrayer >= 0 and A.DesperatePrayer:IsReady(player) and 
    (
        (     -- Auto 
            DesperatePrayer >= 100 and 
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
            DesperatePrayer < 100 and 
            Unit(player):HealthPercent() <= DesperatePrayer
        )
    ) 
    then 
        return A.DesperatePrayer
    end 
end 
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

local function RenewOnTank()
    local CurrentTanks = HealingEngine.GetMembersByMode("TANK")
	local total = 0
	for i = 1, #CurrentTanks do 
	    if Unit(CurrentTanks[i].Unit):HasBuffs(A.Renew.ID, player, true) > 0 then
            total = total + 1
        end
	end
    return total
end


--- ======= ACTION LISTS =======
A[3] = function(icon, isMulti) -- Single target icon displayer

--#####################
--##### VARIABLES #####
--#####################

    local isMoving = A.Player:IsMoving()
    local inCombat = Unit(player):CombatTime() > 0
    local combatTime = Unit(player):CombatTime()
	local AoEON = A.GetToggle(2, "AoE")
    local TotalCast, CurrentCastLeft, CurrentCastDone = Unit(player):CastTime()
    local _, castStartedTime, castEndTime = Unit(player):IsCasting()
    local secondsLeft, percentLeft, spellID, spellName, notInterruptable, isChannel = Unit(player):IsCastingRemains()
    local getmembersAll = HealingEngine.Data.SortedUnitIDs
	local CurrentTanks = A.HealingEngine.GetMembersByMode("TANK")	
	local DungeonEmergency = HealingEngine.GetTimeToDieUnits(3) >= 1
	local HolyNovaTargets = A.GetToggle(2, "HolyNovaTargets")
	local DungeonGroup = TeamCache.Friendly.Size >= 2 and TeamCache.Friendly.Size <= 5
	local RaidGroup = TeamCache.Friendly.Size >= 5
	local HolyWordSerenity = A.GetToggle(2, "HolyWordSerenity")
	local UseSanctifyOnSelf = A.GetToggle(2, "UseSanctifyOnSelf")
	local SanctifyHP = A.GetToggle(2, "SanctifyHP")
	local SanctifyTargets = A.GetToggle(2, "SanctifyTargets")
	local CircleofHealingHP = A.GetToggle(2, "CircleofHealingHP")
	local CircleofHealingTargets = A.GetToggle(2, "CircleofHealingTargets")	
	local DivineHymnHP = A.GetToggle(2, "DivineHymnHP")
	local DivineHymnTargets = A.GetToggle(2, "DivineHymnTargets")
	local GuardianSpiritHP = A.GetToggle(2, "GuardianSpiritHP")
	local HealHP = A.GetToggle(2, "HealHP")
	local FlashHealHP = A.GetToggle(2, "FlashHealHP")
	local FlashHealSOLHP = A.GetToggle(2, "FlashHealSOLHP")
	local PrayerofHealingHP = A.GetToggle(2, "PrayerofHealingHP")
	local PrayerofHealingTargets = A.GetToggle(2, "PrayerofHealingTargets")
	local HaloHP = A.GetToggle(2, "HaloHP")
	local HaloTargets = A.GetToggle(2, "HaloTargets")
	local SalvationHP = A.GetToggle(2, "SalvationHP")
	local SalvationTargets = A.GetToggle(2, "SalvationTargets")	
	local RenewMode = A.GetToggle(2, "RenewMode")
	local BlanketRenewOOC = A.GetToggle(2, "BlanketRenewOOC")
	local TrinketMana = A.GetToggle(2, "TrinketMana")
	local TrinketHP = A.GetToggle(2, "TrinketHP")
	local DPSMana = A.GetToggle(2, "DPSMana")
	local AngelicFeather = A.GetToggle(2, "AngelicFeather")

    local CanCast = true
    if inCombat and (spellID == A.DivineHymn.ID) then 
        if secondsLeft > 0 + A.GetPing() then
            CanCast = false
        else
            CanCast = true
        end
    end
	
--#################
--##### PURGE #####
--#################

	if inCombat and A.DispelMagic:IsReady(unit) and not Unit(unit):IsBoss() and not IsInRaid() and AuraIsValid(unit, "UsePurge", "MagicMovement") then
		return A.DispelMagic:Show(icon)
	end
	if inCombat and A.DispelMagic:IsReady(unit) and not Unit(unit):IsBoss() and not IsInRaid() and AuraIsValid(unit, "UsePurge", "PurgeHigh") then
		return A.DispelMagic:Show(icon)
	end
	if inCombat and A.DispelMagic:IsReady(unit) and not Unit(unit):IsBoss() and not IsInRaid() and AuraIsValid(unit, "UsePurge", "PurgeLow") then
		return A.DispelMagic:Show(icon)
	end

	
--########################	
--##### DMG ROTATION #####
--########################
		
	local function DamageRotation(unit)

			if TeamCacheFriendly.Size == 0 then
			
				--Purify
				if CanCast and A.Purify:IsReady(player) and A.Purify:AbsentImun(player) and A.AuraIsValid(player, "UseDispel", "Dispel") and Unit(player):TimeToDie() > 5 then 
					return A.Purify:Show(icon)
				end 			
			
				-- OOC Renew
				if CanCast and A.Renew:IsReady(player) and BlanketRenewOOC and (not inCombat) and Unit(player):HealthPercent() <= 99 and Unit(player):HasBuffs(A.Renew.ID, true) == 0 then
					return A.Renew:Show(icon)
				end	

				-- Trinket 1
				if inCombat and A.Trinket1:IsReady(player) and ((Player:ManaPercentage() <= TrinketMana) or (Unit(player):HealthPercent() <= TrinketHP)) then
					return A.Trinket1:Show(icon)    
				end

				-- Trinket 2
				if inCombat and A.Trinket2:IsReady(unit) and ((Player:ManaPercentage() <= TrinketMana) or (Unit(player):HealthPercent() <= TrinketHP)) then
					return A.Trinket2:Show(icon)    
				end			
				
				-- Apotheosis Single Target
				if CanCast and inCombat and A.Apotheosis:IsReady(player) and A.Apotheosis:IsTalentLearned() and HealingEngine.GetTimeToDieUnits(2) >= 1 and HealingEngine.GetTimeToDieUnits(2) < 3 and A.HolyWordSerenity:GetCooldown() > 8 then
					return A.Apotheosis:Show(icon)
				end	
				
				-- Apotheosis AoE
				if CanCast and inCombat and A.Apotheosis:IsReady(player) and A.Apotheosis:IsTalentLearned() and (HealingEngine.GetIncomingDMGAVG() > (HealingEngine.GetIncomingHPSAVG() * 2)) and A.HolyWordSanctify:GetCooldown() > 8 then
					return A.Apotheosis:Show(icon)
				end			
				
				-- Guardian Spirit
				if CanCast and inCombat and A.GuardianSpirit:IsReady(player) and Unit(player):HealthPercent() <= GuardianSpiritHP then
					return A.GuardianSpirit:Show(icon)
				end
				
				-- Sanctify @player
				if CanCast and inCombat and A.HolyWordSanctify:IsReady(player) and Unit(player):HealthPercent() <= SanctifyHP then
					return A.HolyWordSanctify:Show(icon)
				end			
				
				-- Serenity
				if CanCast and inCombat and A.HolyWordSerenity:IsReady(player) and Unit(player):HealthPercent() <= HolyWordSerenity then
					return A.HolyWordSerenity:Show(icon)
				end
			
				-- Halo
				if CanCast and inCombat and A.Halo:IsReady(player) then
					return A.Halo:Show(icon)
				end	
		
				-- Circle of Healing
				if CanCast and inCombat and A.CircleofHealing:IsReady(player) and Unit(player):HealthPercent() <= CircleofHealingHP then
					return A.RocketJump:Show(icon)
				end	

				--Divine Star - best I could come up with
				if CanCast and inCombat and A.DivineStar:IsReady(player) and Unit(unit):GetRange() <= 20 then
					return A.DivineStar:Show(icon)
				end	

				-- Flash Heal without SoL
				if CanCast and A.FlashHeal:IsReady(player) and A.HolyWordSerenity:GetCooldown() > 0 and (not isMoving) and Unit(player):HealthPercent() <= FlashHealHP and Unit(player):HasBuffs(A.SurgeofLightBuff.ID, true) == 0 then
					return A.FlashHeal:Show(icon)
				end

				-- Flash Heal with SoL
				if CanCast and A.FlashHeal:IsReady(player) and A.HolyWordSerenity:GetCooldown() > 0 and Unit(player):HealthPercent() <= FlashHealSOLHP and Unit(player):HasBuffs(A.SurgeofLightBuff.ID, true) > 0 then
					return A.FlashHeal:Show(icon)
				end		
			
			
			end
		
		if (Unit(player):PowerPercent() >= DPSMana and TeamCacheFriendly.Size > 1) or TeamCacheFriendly.Size == 0 then
	
			if A.ShadowWordDeath:IsReady(unit) and Unit(unit):HealthPercent() <= 20 then
				return A.ShadowWordDeath:Show(icon)
			end	
			
			if A.HolyNova:IsReady(player) and MultiUnits:GetByRange(12, 10) >= HolyNovaTargets and AoEON then
				return A.HolyNova:Show(icon)
			end	
			
			if A.ShadowWordPain:IsReady(unit) and (Unit(unit):HasDeBuffs(A.ShadowWordPain.ID, true) == 0 or Unit(unit):HasDeBuffs(A.ShadowWordPain.ID, true) < 5) then
				return A.ShadowWordPain:Show(icon)
			end	
			
			if A.HolyFire:IsReady(unit) and not isMoving then
				return A.HolyFire:Show(icon)
			end			
			
			if A.Smite:IsReady(unit) and not isMoving then
				return A.Smite:Show(icon)
			end
		
		end
	
	end


	--############################	
	--##### HEALING ROTATION #####
	--############################

	local function HealingRotation(unit)
	local useDispel, useShields, useHoTs, useUtils = HealingEngine.GetOptionsByUnitID(unit)
	local unitGUID = UnitGUID(unit)	


		if TeamCacheFriendly.Size > 1 then
			--Divine Star notification
			if inCombat and (A.DivineStar:IsReady(player) or A.DivineStar:GetCooldown() <= 2) and A.DivineStar:IsTalentLearned() and MultiUnits:GetByRange(28, 2) > 1 then
				A.Toaster:SpawnByTimer("TripToast", 0, "Divine Star!", "Divine Star will be ready soon! Position yourself!", A.DivineStar.ID)
			end

			--Healing Engine Purify Target
			if A.Purify:IsReady() then
				for i = 1, #getmembersAll do 
					if Unit(getmembersAll[i].Unit):GetRange() <= 40 and AuraIsValid(getmembersAll[i].Unit, "UseDispel", "Dispel") then  
						HealingEngine.SetTarget(getmembersAll[i].Unit)                  									
					end				
				end
			end

			--Purify
			if CanCast and A.Purify:IsReady(unit) and A.Purify:AbsentImun(unit) and A.AuraIsValid(unit, "UseDispel", "Dispel") and Unit(unit):TimeToDie() > 5 then 
				return A.Purify:Show(icon)
			end 
			
			-- OOC Renew
			if CanCast and A.Renew:IsReady(unit) and BlanketRenewOOC and (not inCombat) and Unit(unit):HealthPercent() <= 99 and Unit(unit):HasBuffs(A.Renew.ID, true) == 0 then
				return A.Renew:Show(icon)
			end	
	
			-- OOC Renew Targeting
			if CanCast and A.Renew:IsReady(unit) and BlanketRenewOOC and (not inCombat) and Unit(unit):HasBuffs(A.Renew.ID, true) > 0 then
				for i = 1, #getmembersAll do
					if Unit(getmembersAll[i].Unit):HealthPercent() <= 99 
					then
						HealingEngine.SetTarget(getmembersAll[i].Unit, 0.5)
					end
				end
			end
			
			-- Trinket 1
			if inCombat and A.Trinket1:IsReady(unit) and ((Player:Mana() <= TrinketMana) or (Unit(unit):HealthPercent() <= TrinketHP and A.IsUnitFriendly(unit))) then
                return A.Trinket1:Show(icon)    
            end

			-- Trinket 2
			if inCombat and A.Trinket2:IsReady(unit) and ((Player:Mana() <= TrinketMana) or (Unit(unit):HealthPercent() <= TrinketHP and A.IsUnitFriendly(unit))) then
                return A.Trinket2:Show(icon)    
            end			
			
			--Holy Word: Salvation
			if CanCast and inCombat and A.HolyWordSalvation:IsReady(player) and A.HolyWordSalvation:IsTalentLearned() and HealingEngine.GetBelowHealthPercentUnits(SalvationHP, 40) >= SalvationTargets then 
				return A.HolyWordSalvation:Show(icon)
			end	
			
			-- Apotheosis Single Target
			if CanCast and inCombat and A.Apotheosis:IsReady(player) and A.Apotheosis:IsTalentLearned() and HealingEngine.GetTimeToDieUnits(2) >= 1 and HealingEngine.GetTimeToDieUnits(2) < 3 and A.HolyWordSerenity:GetCooldown() > 8 then
				return A.Apotheosis:Show(icon)
			end	
			
			-- Apotheosis AoE
			if CanCast and inCombat and A.Apotheosis:IsReady(unit) and A.Apotheosis:IsTalentLearned() and (HealingEngine.GetIncomingDMGAVG() > (HealingEngine.GetIncomingHPSAVG() * 2)) and A.HolyWordSanctify:GetCooldown() > 8 then
				return A.Apotheosis:Show(icon)
			end			
			
			-- Guardian Spirit
			if CanCast and inCombat and A.GuardianSpirit:IsReady(unit) and Unit(unit):HealthPercent() <= GuardianSpiritHP then
				return A.GuardianSpirit:Show(icon)
			end
			
			-- Sanctify @player
			if CanCast and inCombat and A.HolyWordSanctify:IsReady(player) and UseSanctifyOnSelf and HealingEngine.GetBelowHealthPercentUnits(SanctifyHP, 10) >= SanctifyTargets then
				return A.HolyWordSanctify:Show(icon)
			end	
			
			-- Sanctify GTAoE
			if CanCast and inCombat and A.HolyWordSanctify:IsReady(player) and (not UseSanctifyOnSelf) and HealingEngine.GetBelowHealthPercentUnits(SanctifyHP, 40) >= SanctifyTargets then
				return A.HolyWordSanctify:Show(icon)
			end				
			
			-- Serenity
			if CanCast and inCombat and A.HolyWordSerenity:IsReady(unit) and Unit(unit):HealthPercent() <= HolyWordSerenity then
				return A.HolyWordSerenity:Show(icon)
			end
		
			-- Halo
			if CanCast and inCombat and A.Halo:IsReady(player) and HealingEngine.GetBelowHealthPercentUnits(HaloHP, 30) >= HaloTargets then
				return A.Halo:Show(icon)
			end	
	
			-- Circle of Healing
			if CanCast and inCombat and A.CircleofHealing:IsReady(unit) and HealingEngine.GetBelowHealthPercentUnits(CircleofHealingHP, 30) >= CircleofHealingTargets then
				return A.RocketJump:Show(icon)
			end	

			--Prayer of Mending
			if CanCast and inCombat and A.PrayerofMending:IsReady(unit) and Unit(unit):IsTank() and Unit(unit):HasBuffs(A.PrayerofMendingBuff.ID, true) == 0 then
				return A.PrayerofMending:Show(icon)
			end	

			--Divine Star - best I could come up with
			if CanCast and inCombat and A.DivineStar:IsReady(player) and inCombat and MultiUnits:GetByRange(28, 2) > 1 then
				return A.DivineStar:Show(icon)
			end	

			--Renew Tank
			if CanCast and A.Renew:IsReady(unit) and RenewMode == "TANK" and RenewOnTank() == 0 then
			    for i = 1, #CurrentTanks do 
					if Unit(CurrentTanks[i].Unit):GetRange() <= 40 then 
						if Unit(CurrentTanks[i].Unit):IsPlayer() and Unit(CurrentTanks[i].Unit):HasBuffs(A.Renew.ID, true) < 1 then    
							HealingEngine.SetTarget(CurrentTanks[i].Unit)
							return A.Renew:Show(icon)                        
						end                    
					end                
				end    
			end

			-- Divine Hymn
			if CanCast and inCombat and A.BurstIsON(unit) and A.DivineHymn:IsReady(player) and (not isMoving) and combatTime > 0 and HealingEngine.GetBelowHealthPercentUnits(DivineHymnHP) >= DivineHymnTargets then
				A.Toaster:SpawnByTimer("TripToast", 0, "Divine Hymn!", "Stop moving! Using Divine Hymn!", A.DivineHymn.ID)			
				return A.DivineHymn:Show(icon)
			end

			-- Prayer of Healing
			if CanCast and inCombat and A.PrayerofHealing:IsReady(unit) and (not isMoving) and (not DungeonEmergency) and HealingEngine.GetBelowHealthPercentUnits(PrayerofHealingHP) >= PrayerofHealingTargets and A.HolyWordSanctify:GetCooldown() > 0 then
				return A.PrayerofHealing:Show(icon)
			end	

			-- Flash Heal without SoL
			if CanCast and A.FlashHeal:IsReady(unit) and A.HolyWordSerenity:GetCooldown() > 0 and (not isMoving) and Unit(unit):HealthPercent() <= FlashHealHP and Unit(player):HasBuffs(A.SurgeofLightBuff.ID, true) == 0 then
				return A.FlashHeal:Show(icon)
			end

			-- Flash Heal with SoL
			if CanCast and A.FlashHeal:IsReady(unit) and A.HolyWordSerenity:GetCooldown() > 0 and Unit(unit):HealthPercent() <= FlashHealSOLHP and Unit(player):HasBuffs(A.SurgeofLightBuff.ID, true) > 0 then
				return A.FlashHeal:Show(icon)
			end			

			-- Binding Heal
			if CanCast and A.BindingHeal:IsReady(unit) and A.BindingHeal:IsTalentLearned() and A.HolyWordSerenity:GetCooldown() > 0 and A.HolyWordSanctify:GetCooldown() > 0 and HealingEngine.GetBelowHealthPercentUnits(95) >= 2 and (not isMoving) and Unit(unit):HealthPercent() <= HealHP then
				return A.BindingHeal:Show(icon)
			end
			
			-- Heal
			if CanCast and A.Heal:IsReady(unit) and A.HolyWordSerenity:GetCooldown() > 0 and (not isMoving) and Unit(unit):HealthPercent() <= HealHP and Unit(player):HasBuffs(A.SurgeofLightBuff.ID, true) == 0 then
				return A.Heal:Show(icon)
			end

			-- Interrupts
			if unit == "target" and A.IsUnitEnemy("targettarget") and CanCast then 
				local Interrupt = Interrupts("targettarget")
				if Interrupt then 
					return Interrupt:Show(icon)
				end 
			end   

			--Angelic Feather
			if CanCast and Player:IsMovingTime() > 0.5 and A.AngelicFeather:IsReady(player) and (not Player:IsMounted()) and AngelicFeather then 
				return A.AngelicFeather:Show(icon)
			end	
			
			--Leap of Faith
			if CanCast and A.LeapofFaith:IsReady(unit) and Unit(unit):GetRange() <= 38 and (not Unit(unit):IsTank()) and (not UnitIsUnit("target", "player")) and Unit(unit):TimeToDie() <= GetGCD() + GetCurrentGCD() and Unit(unit):HasBuffs("TotalImun") == 0 and Unit(unit):HasDeBuffs("Rooted") == 0 then
				return A.LeapofFaith:Show(icon)
			end	
			
			if CanCast and A.Renew:IsReady(unit) and RenewMode == "EVERYONE" and Unit(unit):HealthPercent() <= 95 then
				return A.Renew:Show(icon)
			end
		end
	
	end

	--#############################
	--##### MAIN ACTION CALLS #####
	--#############################
	
    -- Defensive
    local SelfDefensive = SelfDefensives()
    if SelfDefensive then 
        return SelfDefensive:Show(icon)
    end 
    
	-- Friendly Mouseover
    if A.IsUnitFriendly(mouseover) then 
        unit = mouseover  
		
        if HealingRotation(unit) then 
            return true 
        end             
    end
	
    -- Heal Target 
    if A.IsUnitFriendly(target) then 
        unit = target 
		
        if HealingRotation(unit) then 
            return true 
        end 
    end    
	
    -- Enemy Mouseover 
    if A.IsUnitEnemy(mouseover) then 
        unit = mouseover	
		
        if DamageRotation(unit) then 
            return true 
        end 
    end 
    
    -- DPS Target     
    if A.IsUnitEnemy(target) then 
        unit = target
        
        if DamageRotation(unit) then 
            return true 
        end 
    end 

    -- DPS targettarget     
    if A.IsUnitEnemy(targettarget) then 
        unit = targettarget
        
        if DamageRotation(unit) then 
            return true 
        end 
    end 

		
end 
    
    -- End of Rotation