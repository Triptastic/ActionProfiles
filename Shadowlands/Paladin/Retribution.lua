--######################################
--##### TRIP'S RETRIBUTION PALADIN #####
--######################################

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
local AuraIsValidByPhialofSerenity				= A.AuraIsValidByPhialofSerenity
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

--For Toaster
local Toaster									= _G.Toaster
local GetSpellTexture 							= _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

Action[ACTION_CONST_PALADIN_RETRIBUTION] = {
    -- Racial
    ArcaneTorrent						= Create({ Type = "Spell", ID = 50613	}),
    BloodFury							= Create({ Type = "Spell", ID = 20572	}),
    Fireblood							= Create({ Type = "Spell", ID = 265221	}),
    AncestralCall						= Create({ Type = "Spell", ID = 274738	}),
    Berserking							= Create({ Type = "Spell", ID = 26297	}),
    ArcanePulse							= Create({ Type = "Spell", ID = 260364	}),
    QuakingPalm							= Create({ Type = "Spell", ID = 107079	}),
    Haymaker							= Create({ Type = "Spell", ID = 287712	}), 
    WarStomp							= Create({ Type = "Spell", ID = 20549	}),
    BullRush							= Create({ Type = "Spell", ID = 255654	}),  
    GiftofNaaru							= Create({ Type = "Spell", ID = 59544	}),
    Shadowmeld							= Create({ Type = "Spell", ID = 58984	}), -- usable in Action Core 
    Stoneform							= Create({ Type = "Spell", ID = 20594	}), 
    WilloftheForsaken					= Create({ Type = "Spell", ID = 7744	}), -- not usable in APL but user can Queue it   
    EscapeArtist						= Create({ Type = "Spell", ID = 20589	}), -- not usable in APL but user can Queue it
    EveryManforHimself					= Create({ Type = "Spell", ID = 59752	}), -- not usable in APL but user can Queue it
    LightsJudgment						= Create({ Type = "Spell", ID = 255647	}),	
    
    -- Spells
    -- Paladin General
    AvengingWrath						= Create({ Type = "Spell", ID = 31884	}),    
    BlessingofFreedom					= Create({ Type = "Spell", ID = 1044	}),
    BlessingofProtection				= Create({ Type = "Spell", ID = 1022	}),
    BlessingofSacrifice					= Create({ Type = "Spell", ID = 6940	}),
    ConcentrationAura					= Create({ Type = "Spell", ID = 317920	}),
    Consecration						= Create({ Type = "Spell", ID = 26573	}),
    CrusaderAura						= Create({ Type = "Spell", ID = 32223	}),
    CrusaderStrike						= Create({ Type = "Spell", ID = 35395	}),
    DevotionAura						= Create({ Type = "Spell", ID = 465		}),    
    DivineShield						= Create({ Type = "Spell", ID = 642		}),
    DivineSteed							= Create({ Type = "Spell", ID = 190784	}),
    FlashofLight						= Create({ Type = "Spell", ID = 19750	}),
    HammerofJustice						= Create({ Type = "Spell", ID = 853		}),
    HammerofJusticeGreen				= Create({ Type = "SpellSingleColor", ID = 853, Color = "GREEN", Desc = "[1] CC", Hidden = true, Hidden = true, QueueForbidden = true }),    
    HammerofWrath						= Create({ Type = "Spell", ID = 24275	}),
    HandofReckoning						= Create({ Type = "Spell", ID = 62124	}),    
    Judgment							= Create({ Type = "Spell", ID = 20271	}),
    JudgmentDebuff						= Create({ Type = "Spell", ID = 197277, Hidden = true	}),	
    LayOnHands							= Create({ Type = "Spell", ID = 633		}),    
    Redemption							= Create({ Type = "Spell", ID = 7328	}),
    RetributionAura						= Create({ Type = "Spell", ID = 183435	}),
    ShieldoftheRighteous				= Create({ Type = "Spell", ID = 53600	}),
    TurnEvil							= Create({ Type = "Spell", ID = 10326	}),
    WordofGlory							= Create({ Type = "Spell", ID = 85673	}),  
    Forbearance							= Create({ Type = "Spell", ID = 25771	}),
    
    -- Retribution Specific
    BladeofJustice						= Create({ Type = "Spell", ID = 184575	}),
    CleanseToxins						= Create({ Type = "Spell", ID = 213644	}),	
    DivineStorm							= Create({ Type = "Spell", ID = 53385	}),	
    HandofHindrance						= Create({ Type = "Spell", ID = 183218	}),	
    Rebuke								= Create({ Type = "Spell", ID = 96231	}),	
    ShieldofVengeance					= Create({ Type = "Spell", ID = 184662	}),	
    TemplarsVerdict						= Create({ Type = "Spell", ID = 85256	}),
    WakeofAshes							= Create({ Type = "Spell", ID = 255937	}),	
    
    -- Normal Talents
    Zeal		                        = Create({ Type = "Spell", ID = 269569, Hidden = true	}),
    RighteousVerdict					= Create({ Type = "Spell", ID = 267610, Hidden = true	}),	
    ExecutionSentence					= Create({ Type = "Spell", ID = 343527	}),
    FiresofJustice						= Create({ Type = "Spell", ID = 203316, Hidden = true	}),
    BladeofWrath						= Create({ Type = "Spell", ID = 231832, Hidden = true 	}),
    EmpyreanPower						= Create({ Type = "Spell", ID = 326732, Hidden = true	}),
    EmpyreanPowerBuff					= Create({ Type = "Spell", ID = 326733, Hidden = true	}),	
    FistofJustice						= Create({ Type = "Spell", ID = 234299, Hidden = true	}),
    Repentance							= Create({ Type = "Spell", ID = 20066	}),
    BlindingLight						= Create({ Type = "Spell", ID = 115750	}),
    UnbreakableSpirit					= Create({ Type = "Spell", ID = 114154, Hidden = true	}),	
    Cavalier							= Create({ Type = "Spell", ID = 230332, Hidden = true	}),
    EyeforanEye							= Create({ Type = "Spell", ID = 205191	}),	
    DivinePurpose						= Create({ Type = "Spell", ID = 223817, Hidden = true	}),	
    HolyAvenger							= Create({ Type = "Spell", ID = 105809	}),		
    Seraphim							= Create({ Type = "Spell", ID = 152262	}),		
    SelflessHealer						= Create({ Type = "Spell", ID = 85804, Hidden = true	}),	
    JusticarsVengeance					= Create({ Type = "Spell", ID = 215661	}),	
    HealingHands						= Create({ Type = "Spell", ID = 326734, Hidden = true	}),	
    SanctifiedWrath						= Create({ Type = "Spell", ID = 317866, Hidden = true	}),
    Crusade								= Create({ Type = "Spell", ID = 231895	}),	
    FinalReckoning						= Create({ Type = "Spell", ID = 343721	}),	
    FinalReckoningDebuff				= Create({ Type = "Spell", ID = 343724, Hidden = true	}),	
    
    -- PvP Talents
    Luminescence						= Create({ Type = "Spell", ID = 199428, Hidden = true	}),
    UnboundFreedom						= Create({ Type = "Spell", ID = 305394, Hidden = true	}),
    VengeanceAura						= Create({ Type = "Spell", ID = 210323, Hidden = true	}),
    BlessingofSanctuary					= Create({ Type = "Spell", ID = 210256	}),	
    UltimateRetribution					= Create({ Type = "Spell", ID = 287947, Hidden = true	}),
    Lawbringer							= Create({ Type = "Spell", ID = 246806, Hidden = true	}),	
    DivinePunisher						= Create({ Type = "Spell", ID = 204914, Hidden = true	}),
    AuraofReckoning						= Create({ Type = "Spell", ID = 247675, Hidden = true	}),
    Jurisdiction						= Create({ Type = "Spell", ID = 204979, Hidden = true	}),
    LawandOrder							= Create({ Type = "Spell", ID = 204934, Hidden = true	}),	
    CleansingLight						= Create({ Type = "Spell", ID = 236186	}),	
    
    -- Covenant Abilities
    DivineToll						= Create({ Type = "Spell", ID = 304971    }),    
    SummonSteward					= Create({ Type = "Spell", ID = 324739    }),
    AshenHallow						= Create({ Type = "Spell", ID = 316958    }),    
    DoorofShadows					= Create({ Type = "Spell", ID = 300728    }),
    VanquishersHammer				= Create({ Type = "Spell", ID = 328204    }),    
    Fleshcraft						= Create({ Type = "Spell", ID = 331180    }),
    BlessingoftheSeasons            = Create({ Type = "Spell", ID = 328278    }),
    BlessingofSummer                = Create({ Type = "Spell", ID = 328620    }),    
    BlessingofAutumn                = Create({ Type = "Spell", ID = 328622    }),    
    BlessingofSpring                = Create({ Type = "Spell", ID = 328282    }),    
    BlessingofWinter                = Create({ Type = "Spell", ID = 328281    }),        
    Soulshape						= Create({ Type = "Spell", ID = 310143    }),
    Flicker							= Create({ Type = "Spell", ID = 324701    }),
    
    -- Conduits
    
    
    -- Legendaries
    -- General Legendaries
    
    -- Retribution Legendaries
    
    
    --Anima Powers - to add later...
    
    
    -- Trinkets
    
    
    -- Potions
    PotionofUnbridledFury				= Create({ Type = "Potion", ID = 169299, QueueForbidden = true 	}),     
    SuperiorPotionofUnbridledFury		= Create({ Type = "Potion", ID = 168489, QueueForbidden = true 	}),
    PotionofSpectralStrength			= Create({ Type = "Potion", ID = 171275, QueueForbidden = true 	}),
    PotionofSpectralStamina				= Create({ Type = "Potion", ID = 171274, QueueForbidden = true	}),
    PotionofEmpoweredExorcisms			= Create({ Type = "Potion", ID = 171352, QueueForbidden = true 	}),
    PotionofHardenedShadows				= Create({ Type = "Potion", ID = 171271, QueueForbidden = true 	}),
    PotionofPhantomFire					= Create({ Type = "Potion", ID = 171349, QueueForbidden = true 	}),
    PotionofDeathlyFixation				= Create({ Type = "Potion", ID = 171351, QueueForbidden = true 	}),
    SpiritualHealingPotion				= Create({ Type = "Item", ID = 171267, QueueForbidden = true 	}),
    PhialofSerenity						= Create({ Type = "Item", ID = 177278	}),
    
    -- Misc
    Channeling							= Create({ Type = "Spell", ID = 209274, Hidden = true	}),    -- Show an icon during channeling
    TargetEnemy							= Create({ Type = "Spell", ID = 44603, Hidden = true	}),    -- Change Target (Tab button)
    StopCast							= Create({ Type = "Spell", ID = 61721, Hidden = true	}),        -- spell_magic_polymorphrabbit
    PoolResource						= Create({ Type = "Spell", ID = 209274, Hidden = true	}),
    Quake								= Create({ Type = "Spell", ID = 240447, Hidden = true	}), -- Quake (Mythic Plus Affix)
    Cyclone								= Create({ Type = "Spell", ID = 33786, Hidden = true	}), -- Cyclone 

	-- Ally Checks
    TouchofKarma						= Create({ Type = "Spell", ID = 125174, Hidden = true	}),	
    DieByTheSword						= Create({ Type = "Spell", ID = 118038, Hidden = true	}),	
	
    TouchOfDeathDebuff					= Create({ Type = "Spell", ID = 115080, Hidden = true	}),
    KarmaDebuff							= Create({ Type = "Spell", ID = 122470, Hidden = true	}),
    VendettaDebuff						= Create({ Type = "Spell", ID = 79140, Hidden = true	}),
    SolarBeamDebuff						= Create({ Type = "Spell", ID = 78675, Hidden = true	}),
    IntimidatingShoutDebuff				= Create({ Type = "Spell", ID = 5246, Hidden = true		}),
    SmokeBombDebuff						= Create({ Type = "Spell", ID = 76577, Hidden = true	}),
    BlindDebuff							= Create({ Type = "Spell", ID = 2094, Hidden = true		}),
    GarroteDebuff						= Create({ Type = "Spell", ID = 1330, Hidden = true		}),	
    Taunt								= Create({ Type = "Spell", ID = 62124, Desc = "[6] PvP Pets Taunt", QueueForbidden = true	}),	
    
}

local A = setmetatable(Action[ACTION_CONST_PALADIN_RETRIBUTION], { __index = Action })

local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end

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
    BoPDebuffsPvP                            = {A.TouchOfDeathDebuff.ID, A.KarmaDebuff.ID},
    -- Hex, Polly, Repentance, Blind, Wyvern Sting, Ring of Frost, Paralysis, Freezing Trap, Mind Control
    BoSDebuffsPvP                            = {51514, 118, 20066, 2094, 19386, 82691, 115078, 3355, 605}	
}

local IsIndoors, UnitIsUnit = IsIndoors, UnitIsUnit
local player = "player"
local target = "target"
local mouseover = "mouseover"

local function IsHolySchoolFree()
    return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "HOLY") == 0
end 

local function InRange(unit)
    return A.TemplarsVerdict:IsInRange(unit)
end 
InRange = A.MakeFunctionCachedDynamic(InRange)

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
            if not notKickAble and A.Rebuke:IsReady(unit, nil, nil, true) and A.Rebuke:AbsentImun(unit, Temp.TotalAndMag, true) then
                return A.Rebuke:Show(icon)                                                  
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

	if not Player:IsStealthed() then 	
		-- Healthstone | AbyssalHealingPotion
		local Healthstone = GetToggle(1, "HealthStone") 
		if Healthstone >= 0 then 
			if A.HS:IsReady(player) then 					
				if Healthstone >= 100 then -- AUTO 
					if Unit(player):TimeToDie() <= 9 and Unit(player):HealthPercent() <= 40 then
						A.Toaster:SpawnByTimer("TripToast", 0, "Healthstone!", "Using Healthstone!", A.HS.ID)						
						return A.HS
					end 
				elseif Unit(player):HealthPercent() <= Healthstone then 
					A.Toaster:SpawnByTimer("TripToast", 0, "Healthstone!", "Using Healthstone!", A.HS.ID)				
					return A.HS							 
				end
			elseif A.Zone ~= "arena" and (A.Zone ~= "pvp" or not A.InstanceInfo.isRated) and A.SpiritualHealingPotion:IsReady(player) then 
				if Healthstone >= 100 then -- AUTO 
					if Unit(player):TimeToDie() <= 9 and Unit(player):HealthPercent() <= 40 and Unit(player):HealthDeficit() >= A.SpiritualHealingPotion:GetItemDescription()[1] then
						A.Toaster:SpawnByTimer("TripToast", 0, "Health Potion!", "Using Health Potion!", A.SpiritualHealingPotion.ID)					
						return A.AbyssalHealingPotion
					end 
				elseif Unit(player):HealthPercent() <= Healthstone then
					A.Toaster:SpawnByTimer("TripToast", 0, "Health Potion!", "Using Health Potion!", A.SpiritualHealingPotion.ID)				
					return A.AbyssalHealingPotion						 
				end				
			end 
		end
		
		-- PhialofSerenity
		if A.Zone ~= "arena" and (A.Zone ~= "pvp" or not A.InstanceInfo.isRated) and A.PhialofSerenity:IsReady(player) then 
			-- Healing 
			local PhialofSerenityHP, PhialofSerenityOperator, PhialofSerenityTTD = GetToggle(2, "PhialofSerenityHP"), GetToggle(2, "PhialofSerenityOperator"), GetToggle(2, "PhialofSerenityTTD")
			if PhialofSerenityOperator == "AND" then 
				if (PhialofSerenityHP <= 0 or Unit(player):HealthPercent() <= PhialofSerenityHP) and (PhialofSerenityTTD <= 0 or Unit(player):TimeToDie() <= PhialofSerenityTTD) then 
					return A.PhialofSerenity
				end 
			else
				if (PhialofSerenityHP > 0 and Unit(player):HealthPercent() <= PhialofSerenityHP) or (PhialofSerenityTTD > 0 and Unit(player):TimeToDie() <= PhialofSerenityTTD) then 
					return A.PhialofSerenity
				end 
			end 
			
			-- Dispel 
			if AuraIsValidByPhialofSerenity() then 
				return A.PhialofSerenity	
			end 
		end 
	end

    -- DivineShield
    local DivineShield = GetToggle(2, "DivineShieldHP")
    if     DivineShield >= 0 and A.DivineShield:IsReady(player) and 
    (
        (     -- Auto 
            DivineShield >= 100 and 
            (
                (
                    not A.IsInPvP and 
                    Unit(player):HealthPercent() < 25 and 
                    Unit(player):TimeToDieX(5) < 6 
                ) or 
                (
                    A.IsInPvP and Unit(player):HealthPercent() < 20 and 
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
            DivineShield < 100 and 
            Unit(player):HealthPercent() <= DivineShield
        )
    ) 
    then 
        return A.DivineShield
    end
    
    -- BlessingofProtection
    local BlessingofProtection = GetToggle(2, "BlessingofProtection")
    if BlessingofProtection >= 0 and A.BlessingofProtection:IsReady(player) and
    (
        (    -- Auto
            BlessingofProtection >=  100 and
            (
                (
                    not A.IsInPvP and
                    Unit(player):HealthPercent() < 30 and
                    Unit(player):TimeToDieX(20) < 3 and 
                    Unit(player):GetRealTimeDMG(3) > 0 and
                    Unit(player):HasBuffs("DeffBuffs") == 0
                ) or
                (
                    A.IsInPvP and                        
                    (
                        (    -- Defensive
                            Unit(player):HealthPercent() < 35 and
                            Unit(player):GetRealTimeDMG(3) > 0 and
                            Unit(player):IsFocused("MELEE", true) and
                            Unit(player):HasBuffs("DeffBuffs") == 0
                        ) or
                        (    -- Disarmed
                            Unit(player):HasBuffs(A.AvengingWrath.ID, true) > 10 and
                            LoC:Get("DISARM") > 4.5
                        ) or
                        (    -- PvP Debuffs (Touch of Death, Karma, Vendetta
                            Unit(player):HasDeBuffs(Temp.BoPDebuffsPvP) > 4 or
                            Unit(player):HasDeBuffs(A.VendettaDebuff.ID) > 15
                        )
                    )
                )
            )
        ) or 
        (    -- Custom
            BlessingofProtection < 100 and 
            Unit(player):HealthPercent() <= BlessingofProtection
        )
    ) 
    then 
        return A.BlessingofProtection
    end
    
    -- ShieldofVengeance
    local ShieldofVengeance = GetToggle(2, "ShieldofVengeance")
    if ShieldofVengeance >= 0 and A.ShieldofVengeance:IsReady(player) and
    (
        (     -- Auto 
            ShieldofVengeance >= 100 and 
            (
                (
                    not A.IsInPvP and 
                    Unit(player):HealthPercent() < 40 and 
                    Unit(player):TimeToDieX(20) < 6 
                ) or 
                (
                    A.IsInPvP and Unit(player):HealthPercent() < 40 and
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
            ShieldofVengeance < 100 and 
            Unit(player):HealthPercent() <= ShieldofVengeance
        )
    ) 
    then 
        return A.ShieldofVengeance
    end
    
    -- WordofGlory
    local WordofGlory = GetToggle(2, "WoGHP")
    if WordofGlory >= 0 and A.WordofGlory:IsReady(player) and Unit(player):HasBuffsStacks(A.SelflessHealer.ID, true) < 4 and
    (
        WordofGlory >= 100 and
        (
            not A.IsInPvP and
            (
                (
                    IsInRaid() and 
                    Unit(player):HealthPercent() < 20
                ) or 
                (
                    A.InstanceInfo.KeyStone > 1 and 
                    Unit(player):HealthPercent() < 40
                ) or 
                (
                    not IsInRaid() and
                    A.InstanceInfo.KeyStone < 2 and
                    Unit(player):HealthPercent() < 75
                )
            ) or
            (
                A.IsInPvP and
                (
                    Unit(player):HasBuffs("DamageBuffs") > 0 and 
                    Unit(player):HealthPercent() < 40 or
                    Unit(player):HealthPercent() <  60
                )
            )
        ) or 
        (    -- Custom
            WordofGlory < 100 and 
            Unit(player):HealthPercent() <= WordofGlory
        )
    )
    then
        return A.WordofGlory
    end
	
    -- Selfless Healer
    local WordofGlory = GetToggle(2, "WoGHP")
    if WordofGlory >= 0 and A.WordofGlory:IsReady(player) and Unit(player):HasBuffsStacks(A.SelflessHealer.ID, true) >= 4 and
    (
        WordofGlory >= 100 and
        (
            not A.IsInPvP and
            (
                (
                    IsInRaid() and 
                    Unit(player):HealthPercent() < 20
                ) or 
                (
                    A.InstanceInfo.KeyStone > 1 and 
                    Unit(player):HealthPercent() < 40
                ) or 
                (
                    not IsInRaid() and
                    A.InstanceInfo.KeyStone < 2 and
                    Unit(player):HealthPercent() < 75
                )
            ) or
            (
                A.IsInPvP and
                (
                    Unit(player):HasBuffs("DamageBuffs") > 0 and 
                    Unit(player):HealthPercent() < 40 or
                    Unit(player):HealthPercent() <  60
                )
            )
        ) or 
        (    -- Custom
            WordofGlory < 100 and 
            Unit(player):HealthPercent() <= WordofGlory
        )
    )
    then
        return A.FlashofLight
    end	
    
    -- Stoneform (Self Dispel)
    if not A.IsInPvP and A.Stoneform:IsRacialReady(player, true) and AuraIsValid(player, "UseDispel", "Dispel") then 
        return A.Stoneform
    end
end
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

-- Non GCD spell check
local function countInterruptGCD(unit)
    if not A.Rebuke:IsReadyByPassCastGCD(unit) or not A.Rebuke:AbsentImun(unit, Temp.TotalAndMagKick) then
        return true
    end
end

-- Interrupts spells
local function Interrupts(unit)
    local unit
    if A.IsUnitEnemy("mouseover") then 
        unit = "mouseover"
    elseif A.IsUnitEnemy("target") then 
        unit = "target"
    end  

    if A.GetToggle(2, "TasteInterruptList") then
        useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, "TasteBFAContent", true, countInterruptGCD(unit))
    else
        useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))
    end   
    
    if castRemainsTime >= A.GetLatency() then
        if useKick and A.Rebuke:IsReady(unit) and A.Rebuke:AbsentImun(unit, Temp.TotalAndMagKick, true) then 
            -- Notification                    
            Action.SendNotification("Rebuke interrupting on Target ", A.Rebuke.ID)
            return A.Rebuke
        end 
        
        if useCC and A.HammerofJustice:IsReady(unit) and A.HammerofJustice:AbsentImun(unit, Temp.TotalAndCC, true) and Unit(unit):IsControlAble("stun", 0) then 
            -- Notification                    
            Action.SendNotification("HammerofJustice interrupting...", A.HammerofJustice.ID)
            return A.HammerofJustice              
        end    
        
        -- Asphyxiate
        if useCC and A.Asphyxiate:IsSpellLearned() and A.Asphyxiate:IsReady(unit) then 
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
Interrupts = A.MakeFunctionCachedDynamic(Interrupts)

A[3] = function(icon, isMulti)

    local isMoving = A.Player:IsMoving()
    local isMovingFor = A.Player:IsMovingTime()
    local inCombat = Unit("player"):CombatTime() > 0
    local combatTime = Unit("player"):CombatTime()
	local HolyPower = Player:HolyPower()
		
	local UseRacial = A.GetToggle(1, "Racial")
	local UseCovenant = A.GetToggle(1, "Covenant")
    local WordofGloryHP = A.GetToggle(2, "WoGHP")
    local BlessingofProtectionHP = A.GetToggle(2, "BlessingofProtection")	
	

	HPGReady = A.WakeofAshes:GetCooldown() < A.GetGCD() or A.BladeofJustice:GetCooldown() < A.GetGCD() or A.HammerofWrath:GetCooldown() < A.GetGCD() or A.Judgment:GetCooldown() < A.GetGCD() or A.CrusaderStrike:GetCooldown() < A.GetGCD()	

	-- actions.finishers=variable,name=ds_castable,value=spell_targets.divine_storm>=2|buff.empyrean_power.up&debuff.judgment.down&buff.divine_purpose.down|spell_targets.divine_storm>=2&buff.crusade.up&buff.crusade.stack<10
	VarDsCastable = (MultiUnits:GetByRange(8, 3) >= 2 or (Unit(player):HasBuffs(A.EmpyreanPowerBuff.ID, true) > 0 and Unit(unit):HasDeBuffs(A.JudgmentDebuff.ID, true) == 0 and Unit(player):HasBuffs(A.DivinePurpose.ID, true) == 0))
	

    local function EnemyRotation(unit)
	
		local function Cooldowns()
		
			-- actions.cooldowns=potion,if=(buff.bloodlust.react|buff.avenging_wrath.up&buff.avenging_wrath.remains>18|buff.crusade.up&buff.crusade.remains<25)
			
			-- actions.cooldowns+=/lights_judgment,if=spell_targets.lights_judgment>=2|(!raid_event.adds.exists|raid_event.adds.in>75)
			if A.LightsJudgment:IsReady(unit) and UseRacial then
				return A.LightsJudgment:Show(icon)
			end
			
			-- actions.cooldowns+=/fireblood,if=buff.avenging_wrath.up|buff.crusade.up&buff.crusade.stack=10
			if A.Fireblood:IsReady(player) and UseRacial and (Unit(player):HasBuffs(A.AvengingWrath.ID, true) > 0 or Unit(player):HasBuffs(A.Crusade.ID, true) > 0 and Unit(player):HasBuffsStacks(A.Crusade.ID, true) == 10) then
				return A.Fireblood:Show(icon)
			end
			
			-- actions.cooldowns+=/shield_of_vengeance
			if A.ShieldofVengeance:IsReady(player) and Unit(unit):GetRange() <= 15 then
				return A.ShieldofVengeance:Show(icon)
			end
			
			-- actions.cooldowns+=/blessing_of_the_seasons
			if A.BlessingofAutumn:IsReady(player) or A.BlessingofSpring:IsReady(player) or A.BlessingofSummer:IsReady(player) or A.BlessingofWinter:IsReady(player) then
				return A.BlessingoftheSeasons:Show(icon)
			end

			-- Trinkets
			if A.Trinket1:IsReady(unitID) and (Unit(player):HasBuffs(A.AvengingWrath.ID, true) > 0 or Unit(player):HasBuffs(A.Crusade.ID, true) > 0 and Unit(player):HasBuffsStacks(A.Crusade.ID, true) == 10) then
				return A.Trinket1:Show(icon)
			end	

			if A.Trinket2:IsReady(unitID) and (Unit(player):HasBuffs(A.AvengingWrath.ID, true) > 0 or Unit(player):HasBuffs(A.Crusade.ID, true) > 0 and Unit(player):HasBuffsStacks(A.Crusade.ID, true) == 10) then
				return A.Trinket2:Show(icon)
			end					

			-- actions.cooldowns+=/avenging_wrath,if=(holy_power>=4&time<5|holy_power>=3&time>5|talent.holy_avenger.enabled&cooldown.holy_avenger.remains=0)&time_to_hpg=0
			if A.AvengingWrath:IsReady(player) and not A.Crusade:IsTalentLearned() and ((HolyPower >= 4 and combatTime > 0 and combatTime < 5 or HolyPower >= 3 and combatTime > 5 or A.HolyAvenger:IsTalentLearned() and A.HolyAvenger:GetCooldown() < A.GetGCD()) and HPGReady) then
				return A.AvengingWrath:Show(icon)
			end
			
			-- actions.cooldowns+=/crusade,if=(holy_power>=4&time<5|holy_power>=3&time>5|talent.holy_avenger.enabled&cooldown.holy_avenger.remains=0)&time_to_hpg=0
			if A.Crusade:IsReady(player) and A.Crusade:IsTalentLearned() and ((HolyPower >= 4 and combatTime > 0 and combatTime < 5 or HolyPower >= 3 and combatTime > 5 or A.HolyAvenger:IsTalentLearned() and A.HolyAvenger:GetCooldown() < A.GetGCD()) and HPGReady) then
				return A.Crusade:Show(icon)
			end			
			
			-- actions.cooldowns+=/ashen_hallow
			if A.AshenHallow:IsReady(player) and UseCovenant then
				return A.AshenHallow:Show(icon)
			end
			
			-- actions.cooldowns+=/holy_avenger,if=time_to_hpg=0&((buff.avenging_wrath.up|buff.crusade.up)|(buff.avenging_wrath.down&cooldown.avenging_wrath.remains>40|buff.crusade.down&cooldown.crusade.remains>40))
			if A.HolyAvenger:IsReady(player) and (HPGReady and ((Unit(player):HasBuffs(A.AvengingWrath.ID, true) > 0 or Unit(player):HasBuffs(A.Crusade.ID, true) > 0) or (Unit(player):HasBuffs(A.AvengingWrath.ID, true) == 0 and A.AvengingWrath:GetCooldown() > 40 or Unit(player):HasBuffs(A.Crusade.ID, true) == 0 and A.Crusade:GetCooldown() > 40))) then
				return A.HolyAvenger:Show(icon)
			end
			
			-- actions.cooldowns+=/final_reckoning,if=holy_power>=3&cooldown.avenging_wrath.remains>gcd&time_to_hpg=0&(!talent.seraphim.enabled|buff.seraphim.up)
			if A.FinalReckoning:IsReady(player) and HolyPower >= 3 and A.AvengingWrath:GetCooldown() > A.GetGCD() and HPGReady and (not A.Seraphim:IsTalentLearned() or Unit(player):HasBuffs(A.Seraphim.ID, true) > 0) then
				return A.FinalReckoning:Show(icon)
			end
		
		end


		local function Finishers()
			
			-- actions.finishers+=/seraphim,if=((!talent.crusade.enabled&buff.avenging_wrath.up|cooldown.avenging_wrath.remains>25)|(buff.crusade.up|cooldown.crusade.remains>25))&(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains<10)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains<10)&time_to_hpg=0
			if A.Seraphim:IsReady(player) and ((not A.Crusade:IsTalentLearned() and (Unit(player):HasBuffs(A.AvengingWrath.ID, true) > 0 or A.AvengingWrath:GetCooldown() > 25 or not BurstIsON(unit))) or (A.Crusade:IsTalentLearned() and (Unit(player):HasBuffs(A.Crusade.ID, true) > 0 or A.Crusade:GetCooldown() > 25 or not BurstIsON(unit)))) and (not A.FinalReckoning:IsTalentLearned() or A.FinalReckoning:GetCooldown() < 10 or not BurstIsON(unit)) and (not A.ExecutionSentence:IsTalentLearned() or A.ExecutionSentence:GetCooldown() < 10) and HPGReady then
				return A.Seraphim:Show(icon)
			end
			
			-- actions.finishers+=/vanquishers_hammer,if=(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>gcd*10|debuff.final_reckoning.up)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*10|debuff.execution_sentence.up)|spell_targets.divine_storm>=2
			if A.VanquishersHammer:IsReady(unit) and UseCovenant and ((not A.FinalReckoning:IsTalentLearned() or A.FinalReckoning:GetCooldown() > A.GetGCD() * 10 or Unit(unit):HasDeBuffs(A.FinalReckoningDebuff.ID, true) > 0 or not BurstIsON(unit)) and (not A.ExecutionSentence:IsTalentLearned() or A.ExecutionSentence:GetCooldown() > A.GetGCD() * 10 or Unit(unit):HasDeBuffs(A.ExecutionSentence.ID, true) > 0) or MultiUnits:GetByRange(8, 3) >= 2) then
				return A.VanquishersHammer:Show(icon)
			end
			
			-- actions.finishers+=/execution_sentence,if=spell_targets.divine_storm<=3&((!talent.crusade.enabled|buff.crusade.down&cooldown.crusade.remains>10)|buff.crusade.stack>=3|cooldown.avenging_wrath.remains>10|debuff.final_reckoning.up)&time_to_hpg=0
			if A.ExecutionSentence:IsReady(unit) and MultiUnits:GetByRange(8, 3) <= 3 and ((not A.Crusade:IsTalentLearned() and A.AvengingWrath:GetCooldown() > 10) or (A.Crusade:IsTalentLearned() and Unit(player):HasBuffs(A.Crusade.ID, true) == 0 and A.Crusade:GetCooldown() > 10 or Unit(player):HasBuffsStacks(A.Crusade.ID, true) >= 3) or Unit(unit):HasDeBuffs(A.FinalReckoningDebuff.ID, true) > 0 or not A.FinalReckoning:IsTalentLearned()) and HPGReady and Unit(unit):TimeToDie() > 8 then
				return A.ExecutionSentence:Show(icon)
			end
			
			-- actions.finishers+=/divine_storm,if=variable.ds_castable&!buff.vanquishers_hammer.up&((!talent.crusade.enabled|cooldown.crusade.remains>gcd*3)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*3|spell_targets.divine_storm>=3)|spell_targets.divine_storm>=2&(talent.holy_avenger.enabled&cooldown.holy_avenger.remains<gcd*3|buff.crusade.up&buff.crusade.stack<10))
			if A.DivineStorm:IsReady(player) and Unit(unit):GetRange() <= 8 and VarDsCastable and Unit(player):HasBuffs(A.VanquishersHammer.ID, true) == 0 and ((not A.Crusade:IsTalentLearned() or A.Crusade:GetCooldown() > A.GetGCD() * 3 or not BurstIsON(unit)) and (not A.ExecutionSentence:IsTalentLearned() or A.ExecutionSentence:GetCooldown() > A.GetGCD() * 3 or MultiUnits:GetByRange(8, 3) >= 3) or MultiUnits:GetByRange(8, 2) >= 2 and ((A.HolyAvenger:IsTalentLearned() and A.HolyAvenger:GetCooldown() < A.GetGCD() * 3 or Unit(player):HasBuffs(A.Crusade.ID, true) > 0 and Unit(player):HasBuffsStacks(A.Crusade.ID, true) < 10) or not BurstIsON(unit))) then
				return A.DivineStorm:Show(icon)
			end
			
			-- actions.finishers+=/templars_verdict,if=(!talent.crusade.enabled|cooldown.crusade.remains>gcd*3)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*3&spell_targets.divine_storm<=3)&(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>gcd*3)&(!covenant.necrolord.enabled|cooldown.vanquishers_hammer.remains>gcd)|talent.holy_avenger.enabled&cooldown.holy_avenger.remains<gcd*3|buff.holy_avenger.up|buff.crusade.up&buff.crusade.stack<10|buff.vanquishers_hammer.up
			if A.TemplarsVerdict:IsReady(unit) and ((not A.Crusade:IsTalentLearned() or A.Crusade:GetCooldown() > A.GetGCD() * 3 or not BurstIsON(unit)) and (not A.ExecutionSentence:IsTalentLearned() or (A.ExecutionSentence:GetCooldown() > A.GetGCD() * 3 or Unit(unit):TimeToDie() <= 8) and MultiUnits:GetByRange(8, 3) <= 3) and (not A.FinalReckoning:IsTalentLearned() or A.FinalReckoning:GetCooldown() > A.GetGCD() * 3) and (Player:GetCovenant() ~= 4 or A.VanquishersHammer:GetCooldown() > A.GetGCD()) or A.HolyAvenger:IsTalentLearned() and A.HolyAvenger:GetCooldown() < A.GetGCD() * 3 or Unit(player):HasBuffs(A.HolyAvenger.ID, true) > 0 or Unit(player):HasBuffs(A.Crusade.ID, true) > 0 and Unit(player):HasBuffsStacks(A.Crusade.ID, true) < 10 or Unit(player):HasBuffs(A.VanquishersHammer.ID, true) > 0 or not BurstIsON(unit)) then
				return A.TemplarsVerdict:Show(icon)
			end		

		end

		local function Generators()
			
			-- actions.generators=call_action_list,name=finishers,if=holy_power>=5|buff.holy_avenger.up|debuff.final_reckoning.up|debuff.execution_sentence.up|buff.memory_of_lucid_dreams.up|buff.seething_rage.up
			if HolyPower >= 5 or Unit(player):HasBuffs(A.HolyAvenger.ID, true) > 0 or Unit(unit):HasDeBuffs(A.FinalReckoningDebuff.ID, true) > 0 or Unit(unit):HasDeBuffs(A.ExecutionSentence.ID, true) > 0 then
				if Finishers() then
					return true
				end
			end
			
			-- actions.generators+=/divine_toll,if=!debuff.judgment.up&(!raid_event.adds.exists|raid_event.adds.in>30)&(holy_power<=2|holy_power<=4&(cooldown.blade_of_justice.remains>gcd*2|debuff.execution_sentence.up|debuff.final_reckoning.up))&(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>gcd*10)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*10)
			if A.DivineToll:IsReady(unit) and UseCovenant and Unit(unit):HasDeBuffs(A.JudgmentDebuff.ID, true) == 0 and (HolyPower <= 2 or HolyPower <= 4 and (A.BladeofJustice:GetCooldown() > A.GetGCD() * 2 or Unit(unit):HasDeBuffs(A.ExecutionSentence.ID, true) > 0 or Unit(unit):HasDeBuffs(A.FinalReckoningDebuff.ID, true) > 0)) and (not A.FinalReckoning:IsTalentLearned() or A.FinalReckoning:GetCooldown() > A.GetGCD() * 10) and (not A.ExecutionSentence:IsTalentLearned() or A.ExecutionSentence:GetCooldown() > A.GetGCD() * 10 or Unit(unit):TimeToDie() <= 8) then
				return A.DivineToll:Show(icon)
			end
			
			-- actions.generators+=/wake_of_ashes,if=(holy_power=0|holy_power<=2&(cooldown.blade_of_justice.remains>gcd*2|debuff.execution_sentence.up|debuff.final_reckoning.up))&(!raid_event.adds.exists|raid_event.adds.in>20)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>15)&(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>15)
			if A.WakeofAshes:IsReady(player) and Unit(unit):GetRange() <= 10 and (HolyPower == 0 or HolyPower <= 2 and (A.BladeofJustice:GetCooldown() > A.GetGCD() * 2 or Unit(unit):HasDeBuffs(A.ExecutionSentence.ID, true) > 0 or Unit(unit):HasDeBuffs(A.FinalReckoningDebuff.ID, true) > 0)) and (not A.ExecutionSentence:IsTalentLearned() or A.ExecutionSentence:GetCooldown() > 15 or Unit(unit):TimeToDie() <= 8) and (not A.FinalReckoning:IsTalentLearned() or A.FinalReckoning:GetCooldown() > 15 or not BurstIsON(unit)) then
				return A.WakeofAshes:Show(icon)
			end
			
			-- actions.generators+=/hammer_of_wrath,if=holy_power<=4
			if A.HammerofWrath:IsReady(unit) and HolyPower <= 4 then
				return A.HammerofWrath:Show(icon)
			end
			
			-- actions.generators+=/blade_of_justice,if=holy_power<=3
			if A.BladeofJustice:IsReady(unit) and HolyPower <= 3 then
				return A.BladeofJustice:Show(icon)
			end
			
			-- actions.generators+=/judgment,if=!debuff.judgment.up&(holy_power<=2|holy_power<=4&cooldown.blade_of_justice.remains>gcd*2)
			if A.Judgment:IsReady(unit) and Unit(unit):HasDeBuffs(A.JudgmentDebuff.ID, true) == 0 and (HolyPower <= 2 or HolyPower <= 4 and A.BladeofJustice:GetCooldown() > A.GetGCD() * 2) then
				return A.Judgment:Show(icon)
			end
			
			-- actions.generators+=/call_action_list,name=finishers,if=(target.health.pct<=20|buff.avenging_wrath.up|buff.crusade.up|buff.empyrean_power.up)
			if (Unit(unit):HealthPercent() <= 20 or Unit(player):HasBuffs(A.AvengingWrath.ID, true) > 0 or Unit(player):HasBuffs(A.Crusade.ID, true) > 0 or Unit(player):HasBuffs(A.EmpyreanPowerBuff.ID, true) > 0) then
				if Finishers() then
					return true
				end
			end
			
			-- actions.generators+=/crusader_strike,if=cooldown.crusader_strike.charges_fractional>=1.75&(holy_power<=2|holy_power<=3&cooldown.blade_of_justice.remains>gcd*2|holy_power=4&cooldown.blade_of_justice.remains>gcd*2&cooldown.judgment.remains>gcd*2)
			if A.CrusaderStrike:IsReady(unit) and A.CrusaderStrike:GetSpellChargesFrac() >= 1.75 and (HolyPower <= 2 or HolyPower <= 3 and A.BladeofJustice:GetCooldown() > A.GetGCD() * 2 or HolyPower == 4 and A.BladeofJustice:GetCooldown() > A.GetGCD() * 2 and A.Judgment:GetCooldown() > A.GetGCD() * 2) then
				return A.CrusaderStrike:Show(icon)
			end
			
			-- actions.generators+=/call_action_list,name=finishers
			if Finishers() then
				return true
			end
			
			-- actions.generators+=/consecration,if=!consecration.up
			if A.Consecration:IsReady(player) and Unit(unit):GetRange() <= 10 and A.Consecration:GetSpellTimeSinceLastCast() >= 12 then
				return A.Consecration:Show(icon)
			end
			
			-- actions.generators+=/crusader_strike,if=holy_power<=4
			if A.CrusaderStrike:IsReady(unit) and HolyPower <= 4 then
				return A.CrusaderStrike:Show(icon)
			end
			
			-- actions.generators+=/arcane_torrent,if=holy_power<=4
			if A.ArcaneTorrent:IsReady(player) and UseRacial and HolyPower <= 4 then
				return A.ArcaneTorrent:Show(icon)
			end
			
			-- actions.generators+=/consecration,if=time_to_hpg>gcd	
			if A.Consecration:IsReady(player) and Unit(unit):GetRange() <= 10 and not HPGReady then
				return A.Consecration:Show(icon)
			end
			
		end
		
		-- actions+=/rebuke
        local Interrupt = Interrupts(unit)
        if inCombat and Interrupt then 
            return Interrupt:Show(icon)
        end 		
		
		-- actions+=/call_action_list,name=cooldowns
		if BurstIsON(unit) then
			if Cooldowns() then
				return true
			end
		end
		
		-- actions+=/call_action_list,name=generators
		if Generators() then
			return true
		end

	end

    local function FriendlyRotation(unit)

		if not inCombat and Unit(unit):IsDead() then
			return A.Redemption:Show(icon)
		end

		if A.FlashofLight:IsReady(unit) and Unit(player):HasBuffsStacks(A.SelflessHealer.ID, true) >= 4 and Unit(unit):HealthPercent() <= WordofGloryHP then
			return A.FlashofLight:Show(icon)
		end
	
		if A.WordofGlory:IsReady(unit) and Unit(unit):HealthPercent() <= WordofGloryHP then
			return A.WordofGlory:Show(icon)
		end
		
		if A.BlessingofProtection:IsReady(unit) and Unit(unit):HasDeBuffs(A.Forbearance.ID, true) == 0 and Unit(unit):HealthPercent() <= BlessingofProtectionHP then
			return A.BlessingofProtection:Show(icon)
		end

	
	end


    -- Defensive
    local SelfDefensive = SelfDefensives()
    if SelfDefensive then 
        return SelfDefensive:Show(icon)
    end 

	-- Mouseover friendly
	if A.IsUnitFriendly("mouseover") then
		unit = "mouseover"
		if FriendlyRotation(unit) then
			return true
		end
	end
	
	if A.IsUnitFriendly("target") then
		unit = "target"
		if FriendlyRotation(unit) then
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

A[4] = nil
A[5] = nil 

local function FreezingTrapUsedByEnemy()
    if     UnitCooldown:GetCooldown("arena", ACTION_CONST_SPELLID_FREEZING_TRAP) > UnitCooldown:GetMaxDuration("arena", ACTION_CONST_SPELLID_FREEZING_TRAP) - 2 and 
    UnitCooldown:IsSpellInFly("arena", ACTION_CONST_SPELLID_FREEZING_TRAP) and 
    Unit(player):GetDR("incapacitate") > 0 
    then 
        local Caster = UnitCooldown:GetUnitID("arena", ACTION_CONST_SPELLID_FREEZING_TRAP)
        if Caster and Unit(Caster):GetRange() <= 40 then 
            return true 
        end 
    end 
end 

local function ArenaRotation(icon, unitID)
    if A.IsInPvP and (A.Zone == "pvp" or A.Zone == "arena") and not Player:IsStealthed() and not Player:IsMounted() then             
        -- Note: "arena1" is just identification of meta 6
        if unitID == "arena1" and (Unit(player):GetDMG() == 0 or not Unit(player):IsFocused("DAMAGER")) then                 
            -- PvP Pet Taunt        
            if A.Taunt:IsReady() and EnemyTeam():IsTauntPetAble(A.Taunt.ID) then 
                -- Freezing Trap 
                if FreezingTrapUsedByEnemy() then 
                    return A.Taunt:Show(icon)
                end 
                
                -- Casting BreakAble CC
                if EnemyTeam():IsCastingBreakAble(0.25) then 
                    return A.Taunt:Show(icon)
                end 
                
                -- Try avoid something totally random at opener (like sap / blind)
                if Unit(player):CombatTime() <= 5 and (Unit(player):CombatTime() > 0 or Unit("target"):CombatTime() > 0 or MultiUnits:GetByRangeInCombat(40, 1) >= 1) then 
                    return A.Taunt:Show(icon) 
                end 
                
                -- Roots if not available freedom 
                if LoC:Get("ROOT") > 0 then 
                    return A.Taunt:Show(icon) 
                end 
            end 
        end
        
        -- AutoSwitcher
        if unitID == "arena1" and A.GetToggle(1, "AutoTarget") and A.IsUnitEnemy(target) and not A.AbsentImun(nil, target, Temp.TotalAndPhys) and MultiUnits:GetByRange(12, 2) >= 2 then 
            return A:Show(icon, ACTION_CONST_AUTOTARGET)
        end
    end 
end

local function PartyRotation(icon, unitID)
    local isSchoolFree = IsHolySchoolFree()
    local WordofGloryHP = A.GetToggle(2, "WoGHP")
	local BlessingofProtection = A.GetToggle(2, "BlessingofProtection")	
	
    -- Return 
    if not isSchoolFree or Player:IsStealthed() or Player:IsMounted() then 
        return 
    end 
    
    -- CleanseToxins
    if A.CleanseToxins:IsReadyByPassCastGCD(unitID) and AuraIsValid(unitID, "UseDispel", "Dispel") and not Unit(unitID):InLOS() and A.CleanseToxins:AbsentImun(unitID) then                         
        return A.CleanseToxins:Show(icon) 
    end

	-- FoL/WoG
	if A.FlashofLight:IsReady(unitID) and Unit(player):HasBuffsStacks(A.SelflessHealer.ID, true) >= 4 and Unit(unitID):HealthPercent() <= WordofGloryHP then
		return A.FlashofLight:Show(icon)
	end

	if A.WordofGlory:IsReady(unitID) and Unit(unitID):HealthPercent() <= WordofGloryHP then
		return A.WordofGlory:Show(icon)
	end
   
    -- BlessingofProtection
	if A.BlessingofProtection:IsReady(unitID, nil, nil, true) and A.IsInPvP and ((Unit(unitID):HealthPercent() <= BlessingofProtection and Unit(unitID):IsFocused("MELEE", true)) or ((A.BlessingofSanctuary:GetCooldown() > 0 or not A.BlessingofSanctuary:IsTalentLearned()) and Unit(unitID):HasDeBuffs("Stuned") > 2)) and Unit(unitID):HasBuffs(A.TouchofKarma.ID, true) == 0 and Unit(unitID):HasBuffs(A.DieByTheSword.ID, true) == 0 then
		return A.BlessingofProtection:Show(icon)
	end
    
    -- BlessingofSacrifice
    if A.BlessingofSacrifice:IsReady(unitID, nil, nil, true) and Unit(player):HealthPercent() > Unit(unitID):HealthPercent() * 1.5 and Unit(unitID):HasBuffs(A.BlessingofProtection.ID) == 0 and Unit(unitID):GetRealTimeDMG() > 0 and Unit(unitID):HasBuffs("DeffBuffs") == 0 and A.BlessingofSacrifice:AbsentImun(unitID) then
        return A.BlessingofSacrifice:Show(icon) 
    end
    
    -- BlessingofSanctuary
    if A.BlessingofSanctuary:IsReady(unitID, nil, nil, true) and (Unit(unitID):HasDeBuffs("Stuned") > 2 or Unit(unitID):HasDeBuffs("Fear") > 2) then
        return A.BlessingofSanctuary:Show(icon) 
    end
    
    -- BlessingofFreedom
    if A.BlessingofFreedom:IsReadyByPassCastGCD(unitID) and not Unit(player, 5):HasFlags() and (Unit(unitID):IsFocused(nil, true) or (Unit(unitID):IsMelee() and Unit(unitID):HasBuffs("DamageBuffs") > 0)) and not Unit(unitID):InLOS() and A.BlessingofFreedom:AbsentImun(unitID) then
        if Unit(unitID):HasDeBuffs("Rooted") > A.GetGCD() then 
            return A.BlessingofFreedom:Show(icon) 
        end 
        
        local cMoving = Unit(unitID):GetCurrentSpeed()
        if cMoving > 0 and cMoving < 64 then -- 64 because unitID can moving backward 
            return A.BlessingofFreedom:Show(icon) 
        end 
    end
end

A[6] = function(icon)    
    if PartyRotation(icon, UnitExists("raid1") and "raid1" or "party1") then
        return true 
    end
    
    return ArenaRotation(icon, "arena1")
end

A[7] = function(icon)
    if PartyRotation(icon, UnitExists("raid2") and "raid2" or "party2") then
        return true 
    end
    
    return ArenaRotation(icon, "arena2")
end

A[8] = function(icon)
    return ArenaRotation(icon, "arena3")
end
	