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
local AuraIsValidByPhialofSerenity				= A.AuraIsValidByPhialofSerenity
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

--For Toaster
local Toaster                                    = _G.Toaster
local GetSpellTexture                             = _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

-- Spells
Action[ACTION_CONST_PRIEST_SHADOW] = {
    -- Racial
    ArcaneTorrent					= Action.Create({ Type = "Spell", ID = 50613	}),
    BloodFury						= Action.Create({ Type = "Spell", ID = 20572	}),
    Fireblood						= Action.Create({ Type = "Spell", ID = 265221	}),
    AncestralCall					= Action.Create({ Type = "Spell", ID = 274738	}),
    Berserking						= Action.Create({ Type = "Spell", ID = 26297	}),
    ArcanePulse             		= Action.Create({ Type = "Spell", ID = 260364	}),
    QuakingPalm           			= Action.Create({ Type = "Spell", ID = 107079	}),
    Haymaker           				= Action.Create({ Type = "Spell", ID = 287712	}), 
    BullRush           				= Action.Create({ Type = "Spell", ID = 255654	}),    
    WarStomp        				= Action.Create({ Type = "Spell", ID = 20549	}),
    GiftofNaaru   					= Action.Create({ Type = "Spell", ID = 59544	}),
    Shadowmeld   					= Action.Create({ Type = "Spell", ID = 58984    }),
    Stoneform 						= Action.Create({ Type = "Spell", ID = 20594    }), 
    BagofTricks						= Action.Create({ Type = "Spell", ID = 312411	}),
    WilloftheForsaken				= Action.Create({ Type = "Spell", ID = 7744		}),   
    EscapeArtist					= Action.Create({ Type = "Spell", ID = 20589    }), 
    EveryManforHimself				= Action.Create({ Type = "Spell", ID = 59752    }),
    LightsJudgment					= Action.Create({ Type = "Spell", ID = 255647   }),
	RocketJump						= Action.Create({ Type = "Spell", ID = 69070 	}),	

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
	WeakenedSoul					= Action.Create({ Type = "Spell", ID = 6788		}),	
	PsychicScream					= Action.Create({ Type = "Spell", ID = 8122 	}),
	Resurrection					= Action.Create({ Type = "Spell", ID = 2006 	}),
	ShackleUndead					= Action.Create({ Type = "Spell", ID = 9484 	}),
	ShadowWordDeath					= Action.Create({ Type = "Spell", ID = 32379 	}),
	ShadowWordPain					= Action.Create({ Type = "Spell", ID = 589 		}),	
	FocusedWill						= Action.Create({ Type = "Spell", ID = 45243, Hidden = true 	}),
	MindSoothe						= Action.Create({ Type = "Spell", ID = 453 		}),
	PowerInfusion					= Action.Create({ Type = "Spell", ID = 10060 	}),
	
	-- Shadow Specific
    DevouringPlague					= Action.Create({ Type = "Spell", ID = 335467	}),
    Dispersion						= Action.Create({ Type = "Spell", ID = 47585	}),
    MindFlay						= Action.Create({ Type = "Spell", ID = 15407	}),	
    MindSear						= Action.Create({ Type = "Spell", ID = 48045	}),	
    PurifyDisease					= Action.Create({ Type = "Spell", ID = 213634	}),
    ShadowMend						= Action.Create({ Type = "Spell", ID = 186263	}),	
    Shadowfiend						= Action.Create({ Type = "Spell", ID = 34433	}),
    Shadowform						= Action.Create({ Type = "Spell", ID = 232698	}),	
    Silence							= Action.Create({ Type = "Spell", ID = 15487	}),
    VampiricEmbrace					= Action.Create({ Type = "Spell", ID = 15286	}),
    VampiricTouch					= Action.Create({ Type = "Spell", ID = 34914	}),
    VoidEruption					= Action.Create({ Type = "Spell", ID = 228260	}),
    VoidformBuff					= Action.Create({ Type = "Spell", ID = 194249, Hidden = true 	}),    
    VoidBolt						= Action.Create({ Type = "Spell", ID = 205448	}),	
	DarkThought						= Action.Create({ Type = "Spell", ID = 341207, Hidden = true 	}),

	-- Normal Talents
    FortressoftheMind				= Action.Create({ Type = "Spell", ID = 193195, Hidden = true 	}),
    DeathandMadness					= Action.Create({ Type = "Spell", ID = 321291, Hidden = true 	}),	
    UnfurlingDarkness				= Action.Create({ Type = "Spell", ID = 341273, Hidden = true 	}),
    UnfurlingDarknessBuff			= Action.Create({ Type = "Spell", ID = 341282, Hidden = true	}),	
    BodyandSoul						= Action.Create({ Type = "Spell", ID = 64129, Hidden = true		}),	
    Sanlayn							= Action.Create({ Type = "Spell", ID = 199855, Hidden = true 	}),
    Intangibility					= Action.Create({ Type = "Spell", ID = 288733, Hidden = true 	}),
    TwistofFate						= Action.Create({ Type = "Spell", ID = 109142, Hidden = true 	}),
    Misery							= Action.Create({ Type = "Spell", ID = 238558, Hidden = true 	}),
    SearingNightmare				= Action.Create({ Type = "Spell", ID = 341385, Hidden = true 	}),
    LastWord						= Action.Create({ Type = "Spell", ID = 263716, Hidden = true 	}),	
    MindBomb						= Action.Create({ Type = "Spell", ID = 205369 	}),
    PsychicHorror					= Action.Create({ Type = "Spell", ID = 64044 	}),
    AuspiciousSpirits				= Action.Create({ Type = "Spell", ID = 155271, Hidden = true 	}),
    PsychicLink						= Action.Create({ Type = "Spell", ID = 199484, Hidden = true 	}),	
    ShadowCrash						= Action.Create({ Type = "Spell", ID = 205385	}),
    Damnation						= Action.Create({ Type = "Spell", ID = 341374	}),
    Mindbender						= Action.Create({ Type = "Spell", ID = 200174 	}),	
    VoidTorrent						= Action.Create({ Type = "Spell", ID = 263165	}),
    AncientMadness					= Action.Create({ Type = "Spell", ID = 341240, Hidden = true 	}),
	HungeringVoid					= Action.Create({ Type = "Spell", ID = 341273, Hidden = true 	}),
    SurrendertoMadness				= Action.Create({ Type = "Spell", ID = 319952 	}),	

	-- PvP Talents


	-- Covenant Abilities
    BoonoftheAscended				= Action.Create({ Type = "Spell", ID = 325013	}),
    AscendedBlast					= Action.Create({ Type = "Spell", ID = 325315	}),	
    SummonSteward					= Action.Create({ Type = "Spell", ID = 324739	}),
    Mindgames						= Action.Create({ Type = "Spell", ID = 323673	}),
    DoorofShadows					= Action.Create({ Type = "Spell", ID = 300728	}),
    UnholyNova						= Action.Create({ Type = "Spell", ID = 324724	}),
    Fleshcraft						= Action.Create({ Type = "Spell", ID = 331180	}),
    FaeGuardians					= Action.Create({ Type = "Spell", ID = 327661	}),
    WrathfulFaerie					= Action.Create({ Type = "Spell", ID = 342132	}),	
    BenevolentFaerie				= Action.Create({ Type = "Spell", ID = 327710	}),	
    GuardianFaerie					= Action.Create({ Type = "Spell", ID = 327694	}),		
    Soulshape						= Action.Create({ Type = "Spell", ID = 310143	}),
    Flicker							= Action.Create({ Type = "Spell", ID = 324701	}),

	-- Conduits
	-- Shadow Conduits
    DissonantEchoes					= Action.Create({ Type = "Spell", ID = 343144	}),
	
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
};

-- To create essences use next code:
local A = setmetatable(Action[ACTION_CONST_PRIEST_SHADOW], { __index = Action })

local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end

local player = "player"
local target = "target"
local mouseover = "mouseover"

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

local function SelfDefensives()

	--Healthstone
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

	--SpiritualHealingPotion
	local SpiritualHealingPotion = A.GetToggle(2, "SpiritualHealingPotionHP")
	if A.SpiritualHealingPotion:IsReady(player, nil, nil, true) and Unit(player):HealthPercent() <= SpiritualHealingPotion then
		return A.AbyssalHealingPotion
	end	

	--Dispersion
	local DispersionHP = A.GetToggle(2, "DispersionHP")	
	if A.Dispersion:IsReady(unit, nil, nil, true) and Unit(player):HealthPercent() <= DispersionHP then
		return A.Dispersion
	end	
	
	local VampiricEmbrace = A.GetToggle(2, "VampiricEmbrace")
	if A.VampiricEmbrace:IsReady(unit) and Unit(player):HealthPercent() <= VampiricEmbrace then
		return A.VampiricEmbrace
	end

	if not StMActive and not Player:IsChanneling() then		
		
		--Fade
		local FadeHP = A.GetToggle(2, "FadeHP")		
		if A.Fade:IsReady(unit, nil, nil, true) and Unit(player):HealthPercent() <= FadeHP then
			return A.Fade
		end	
		
		--ShadowMend
		local ShadowMendHP = A.GetToggle(2, "ShadowMendHP")			
		if A.ShadowMend:IsReady(unit) and Unit(player):HealthPercent() <= ShadowMendHP then
			return A.ShadowMend
		end

		--PW:S
		local PWSHP = A.GetToggle(2, "PWSHP")			
		if A.PowerWordShield:IsReady(unit) and Unit(player):HasDeBuffs(A.WeakenedSoul.ID, true) == 0 and Unit(player):HealthPercent() <= PWSHP then
			return A.PowerWordShield
		end	
	end
		
end


local function CombatOffGCD()

end

local function RefreshDoTs()

	--Paste multidot function here

end

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
        
        -- Fear
        if useCC and A.PsychicHorror:IsReady(unit) and A.PsychicHorror:AbsentImun(unit, Temp.TotalAndMagKick, true) and Unit(unit):IsControlAble("stun", 0) then 
            return A.PsychicHorror              
        end 
        
    end
end

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


--- ======= ACTION LISTS =======
-- [3] Single Rotation
A[3] = function(icon, isMulti)
	
	-- Function Remaps
    local isMoving = A.Player:IsMoving()
	local isMovingFor = A.Player:IsMovingTime()		
	local inCombat = Unit(player):CombatTime() > 0	
	local VoidFormActive = Unit(player):HasBuffs(A.VoidformBuff.ID, true) > 0
	local Insanity = Player:Insanity()
	local FaeriesActive = A.FaeGuardians:GetSpellTimeSinceLastCast() < 19
	local FiendActive = A.Shadowfiend:GetSpellTimeSinceLastCast() < 15 or A.Mindbender:GetSpellTimeSinceLastCast() < 15
    local StMActive = A.SurrendertoMadness:GetSpellTimeSinceLastCast() <= 25
	
	-- Toggle Remaps
	local UseRacial = A.GetToggle(1, "Racial")
	local CombatMeditation = A.GetToggle(2, "CombatMeditation")
	local UseCovenant = A.GetToggle(1, "Covenant")
	local ShadowflamePrism = A.GetToggle(2, "ShadowflamePrism")	
	local Painbreaker = A.GetToggle(2, "Painbreaker")
	local PWSAlways = A.GetToggle(2, "PWSAlways")
	
	--Spell Fixes
    if Temp.VampiricTouchDelay == 0 and Player:IsCasting() == A.VampiricTouch:Info() then
        Temp.VampiricTouchDelay = 90
    end
    
    if Temp.VampiricTouchDelay > 0 then
        Temp.VampiricTouchDelay = Temp.VampiricTouchDelay - 1
    end
	
	
	local CanCast = true 
    local TotalCast, CurrentCastLeft, CurrentCastDone = Unit(player):CastTime()	
    local _, castStartedTime, castEndTime = Unit(player):IsCasting()	
    local secondsLeft, percentLeft, spellID, spellName, notInterruptable, isChannel = Unit(player):IsCastingRemains()	
    if (spellID == A.VoidTorrent.ID) then 
        if (CurrentCastLeft > 0 or secondsLeft > 0 or isChannel) then
            if TMW.time < castEndTime then            
                CanCast = false
            else
                CanCast = true
            end
        end
    end	
    ------------------------------------------------------
    ---------------- ENEMY UNIT ROTATION -----------------
    ------------------------------------------------------
	
    local function EnemyRotation(unit)
        
	--actions+=/variable,name=dots_up,op=set,value=dot.shadow_word_pain.ticking&dot.vampiric_touch.ticking
    VarDotsUp = (Unit(unit):HasDeBuffs(A.ShadowWordPain.ID, true) > 0 and Unit(unit):HasDeBuffs(A.VampiricTouch.ID, true) > 0)
	
	--actions+=/variable,name=all_dots_up,op=set,value=dot.shadow_word_pain.ticking&dot.vampiric_touch.ticking&dot.devouring_plague.ticking
	VarAllDotsUp = (Unit(unit):HasDeBuffs(A.ShadowWordPain.ID, true) > 0 and Unit(unit):HasDeBuffs(A.VampiricTouch.ID, true) > 0 and Unit(unit):HasDeBuffs(A.DevouringPlague.ID, true) > 0)		

	--Toaster for Unfurling Darkness alert
	if Unit(player):HasBuffs(A.UnfurlingDarknessBuff.ID, true) > 0 then
	A.Toaster:SpawnByTimer("TripToast", 0, "Unfurling Darkness Active!", "Target a new enemy for instant-cast Vampiric Touch!", A.VampiricTouch.ID)
	end
	
	--Toaster for Shadow Crash alert
	if inCombat and A.ShadowCrash:GetCooldown() < 2 and A.ShadowCrash:IsTalentLearned() then
	A.Toaster:SpawnByTimer("TripToast", 0, "Shadow Crash!", "Get your cursor ready!", A.ShadowCrash.ID)
	end	

	--actions.precombat+=/variable,name=mind_sear_cutoff,op=set,value=2
	VarMindSearCutoff = 2
	
	--# Start using Searing Nightmare at 3+ targets or 4+ if you are in Voidform
	--actions+=/variable,name=searing_nightmare_cutoff,op=set,value=spell_targets.mind_sear>2+buff.voidform.up
	VarSearingNightmareCutoff = MultiUnits:GetActiveEnemies() > 2 + num(VoidFormActive)
	
	--# Cooldown Pool Variable, Used to pool before activating voidform. Currently used to control when to activate voidform with incoming adds.
	--actions+=/variable,name=pool_for_cds,op=set,value=cooldown.void_eruption.up&(!raid_event.adds.up|raid_event.adds.duration<=10|raid_event.adds.remains>=10+5*(talent.hungering_void.enabled|covenant.kyrian))&((raid_event.adds.in>20|spell_targets.void_eruption>=5)|talent.hungering_void.enabled|covenant.kyrian)
	VarPoolForCDs = ((A.VoidEruption:GetCooldown() == 0 and not A.VoidEruption:IsBlocked()) or A.VoidEruption:IsBlocked())
	

	--# Executed before combat begins. Accepts non-harmful --actions only.
	--actions.precombat=flask
	--actions.precombat+=/food
	--actions.precombat+=/augmentation
	--# Snapshot raid buffed stats before combat begins and pre-potting is done.
	--actions.precombat+=/snapshot_stats
	
		--#####################
		--##### PRECOMBAT #####
		--#####################
		
		local function Precombat()
			--actions.precombat+=/arcane_torrent
			if A.ArcaneTorrent:IsReady(player) and UseRacial then
				return A.ArcaneTorrent:Show(icon)
			end
			
			--actions.precombat+=/vampiric_touch
			if A.VampiricTouch:IsReady(unit) and Temp.VampiricTouchDelay == 0 and CanCast and not A.Damnation:IsReady(unit) and Unit(unit):HasDeBuffs(A.VampiricTouch.ID, true) == 0 then
				return A.VampiricTouch:Show(icon)
			end	
			
			if A.Damnation:IsReady(unit) and CanCast then
				return A.Damnation:Show(icon)
			end
			
		end
		--# Executed every time the actor is available.

		--################
		--##### BOON #####
		--################
		
		local function Boon()
		
			--actions.boon=ascended_blast,if=spell_targets.mind_sear<=3
			if A.AscendedBlast:IsReady(unit) and CanCast and MultiUnits:GetActiveEnemies() <= 3 then
				return A.AscendedBlast:Show(icon)
			end	
			
			--actions.boon+=/ascended_nova,if=spell_targets.ascended_nova>1&spell_targets.mind_sear>1+talent.searing_nightmare.enabled
			if A.AscendedNova:IsReady(player) and CanCast and MultiUnits:GetByRange(8, 2) > (1 + num(A.SearingNightmare:IsTalentLearned())) then
				return A.AscendedNova:Show(icon)
			end
		
		end

		--#####################
		--##### COOLDOWNS #####
		--#####################

		local function Cooldowns()
		--# Use Power Infusion with Voidform. Hold for Voidform comes off cooldown in the next 10 seconds otherwise use on cd unless the Pelagos Trait Combat Meditation is talented, or if there will not be another Void Eruption this fight.
			--actions.cds=power_infusion,if=buff.voidform.up|!soulbind.combat_meditation.enabled&cooldown.void_eruption.remains>=10|fight_remains<cooldown.void_eruption.remains
			if A.PowerInfusion:IsReady(player) and CanCast and (VoidFormActive or (not CombatMeditation and A.VoidEruption:GetCooldown() >= 10) or (Unit(unit):IsBoss() and Unit(unit):TimeToDie() < A.VoidEruption:GetCooldown())) then
				return A.PowerInfusion:Show(icon)
			end
		
			--# Use on CD but prioritise using Void Eruption first, if used inside of VF on ST use after a voidbolt for cooldown efficiency and for hungering void uptime if talented.
			--actions.cds+=/boon_of_the_ascended,if=!buff.voidform.up&!cooldown.void_eruption.up&spell_targets.mind_sear>1&!talent.searing_nightmare.enabled|(buff.voidform.up&spell_targets.mind_sear<2&!talent.searing_nightmare.enabled&prev_gcd.1.void_bolt)|(buff.voidform.up&talent.searing_nightmare.enabled)
			if A.BoonoftheAscended:IsReady(player) and CanCast and UseCovenant and (not isMoving or StMActive) and (not VoidFormActive and A.VoidEruption:GetCooldown() > 0 and MultiUnits:GetActiveEnemies() > 1 and not A.SearingNightmare:IsTalentLearned() or (VoidFormActive and MultiUnits:GetActiveEnemies() < 2 and not A.SearingNightmare:IsTalentLearned() and Player:PrevGCD(1, A.VoidBolt:Info())) or (VoidFormActive and A.SearingNightmare:IsTalentLearned())) then
				return A.BoonoftheAscended:Show(icon)
			end
				
			--actions.cds+=/call_action_list,name=trinkets
			--Trinket 1
			if A.Trinket1:IsReady(unitID) then
				return A.Trinket1:Show(icon)    
			end
			
			--Trinket 2
			if A.Trinket2:IsReady(unitID) then
				return A.Trinket2:Show(icon)    
			end	

		end

		--###############
		--##### CWC #####
		--###############

		local function CWC()
			--# Use Searing Nightmare if you will hit enough targets and Power Infusion and Voidform are not ready, or to refresh SW:P on two or more targets.
			--actions.cwc=searing_nightmare,use_while_casting=1,target_if=(variable.searing_nightmare_cutoff&!variable.pool_for_cds)|(dot.shadow_word_pain.refreshable&spell_targets.mind_sear>1)
			if A.SearingNightmare:IsReady(player, nil, nil, true) and CanCast and (not isMoving or StMActive) and Player:IsChanneling() == A.MindSear:Info() and ((VarSearingNightmareCutoff and not VarPoolForCDs) or (Unit(unit):HasDeBuffs(A.ShadowWordPain.ID, true) < 4.8 and MultiUnits:GetActiveEnemies() > 1)) then
				return A.RocketJump:Show(icon)
			end
			
			--# Short Circuit Searing Nightmare condition to keep SW:P up in AoE
			--actions.cwc+=/searing_nightmare,use_while_casting=1,target_if=talent.searing_nightmare.enabled&dot.shadow_word_pain.refreshable&spell_targets.mind_sear>2
			if A.SearingNightmare:IsReady(player, nil, nil, true) and CanCast and (not isMoving or StMActive) and Player:IsChanneling() == A.MindSear:Info() and Unit(unit):HasDeBuffs(A.ShadowWordPain.ID, true) < 4.8 and MultiUnits:GetActiveEnemies() > 2 then
				return A.RocketJump:Show(icon)
			end
			
			--# Only_cwc makes the action only usable during channeling and not as a regular action.
			--actions.cwc+=/mind_blast,only_cwc=1
			if A.MindBlast:IsReady(unit, nil, nil, true) and CanCast and Unit(player):HasBuffs(A.DarkThought.ID, true) > 0 then
				return A.MindBlast:Show(icon)
			end
			
		end

		--################
		--##### MAIN #####
		--################
		
		local function Main()
		
			--actions.main=call_action_list,name=boon,if=buff.boon_of_the_ascended.up
			if Unit(player):HasBuffs(A.BoonoftheAscended.ID, true) > 0 then
				if Boon() then
					return true
				end
			end	
			
			-- PWS Always if selected
			if A.PowerWordShield:IsReady(player) and PWSAlways and Unit(player):HasBuffs(A.PowerWordShield.ID, true) == 0 and Unit(player):HasDeBuffs(A.WeakenedSoul.ID, true) == 0 then
				return A.PowerWordShield:Show(icon)
			end
			
			--# Use Void Eruption on cooldown pooling at least 40 insanity but not if you will overcap insanity in VF. Make sure shadowfiend/mindbender is on cooldown before VE.
			--actions.main+=/void_eruption,if=variable.pool_for_cds&insanity>=40&(insanity<=85|talent.searing_nightmare.enabled&variable.searing_nightmare_cutoff)&!cooldown.fiend.up
			if A.VoidEruption:IsReady(unit) and CanCast and (not isMoving or StMActive) and VarPoolForCDs and Insanity >= 40 and (Insanity <= 85 or A.SearingNightmare:IsTalentLearned() and VarSearingNightmareCutoff) and ((A.Shadowfiend:GetCooldown() > 0 and not A.Mindbender:IsTalentLearned()) or (A.Mindbender:GetCooldown() > 0 and A.Mindbender:IsTalentLearned())) then
				return A.VoidEruption:Show(icon)
			end
			
			--# Make sure you put up SW:P ASAP on the target if Wrathful Faerie isn't active.
			--actions.main+=/shadow_word_pain,if=buff.fae_guardians.up&!debuff.wrathful_faerie.up
			if A.ShadowWordPain:IsReady(unit) and FaeriesActive and Unit(unit):HasDeBuffs(A.WrathfulFaerie.ID, true) == 0 then
				return A.ShadowWordPain:Show(icon)
			end
			
			--actions.main+=/call_action_list,name=cds
			if A.BurstIsON(unit) then
				if Cooldowns() then
					return true
				end
			end
			
			--# High Priority Mind Sear action to refresh DoTs with Searing Nightmare
			--actions.main+=/mind_sear,target_if=talent.searing_nightmare.enabled&spell_targets.mind_sear>variable.mind_sear_cutoff&!dot.shadow_word_pain.ticking&!cooldown.fiend.up
			if A.MindSear:IsReady(unit) and (not isMoving or StMActive) and A.SearingNightmare:IsTalentLearned() and MultiUnits:GetActiveEnemies() > VarMindSearCutoff and Unit(unit):HasDeBuffs(A.ShadowWordPain.ID, true) < 4.8 and ((A.Shadowfiend:GetCooldown() > 0 and not A.Mindbender:IsTalentLearned()) or (A.Mindbender:GetCooldown() > 0 and A.Mindbender:IsTalentLearned())) then
				return A.MindSear:Show(icon)
			end	
			
			--# Prefer to use Damnation ASAP if any DoT is not up.
			--actions.main+=/damnation,target_if=!variable.all_dots_up
			if A.Damnation:IsReady(unit, nil, nil, true) and CanCast and not VarAllDotsUp then
				return A.Damnation:Show(icon)
			end
			
			--# Use Void Bolt at higher priority with Hungering Void up to 4 targets, or other talents on ST.
			--actions.main+=/void_bolt,if=insanity<=85&talent.hungering_void.enabled&talent.searing_nightmare.enabled&spell_targets.mind_sear<=6|((talent.hungering_void.enabled&!talent.searing_nightmare.enabled)|spell_targets.mind_sear=1)
			if A.VoidBolt:IsReady(unit, nil, nil, true) and CanCast and VoidFormActive and ((Insanity <= 85 and A.HungeringVoid:IsTalentLearned() and A.SearingNightmare:IsTalentLearned() and MultiUnits:GetActiveEnemies() <= 6) or ((A.HungeringVoid:IsTalentLearned() and not A.SearingNightmare:IsTalentLearned()) or MultiUnits:GetActiveEnemies() == 1)) then
				return A.VoidBolt:Show(icon)
			end
			
			--# Don't use Devouring Plague if you can get into Voidform instead, or if Searing Nightmare is talented and will hit enough targets.
			--actions.main+=/devouring_plague,target_if=(refreshable|insanity>75)&(!variable.pool_for_cds|insanity>=85)&(!talent.searing_nightmare.enabled|(talent.searing_nightmare.enabled&!variable.searing_nightmare_cutoff))
			if A.DevouringPlague:IsReady(unit, nil, nil, true) and CanCast and (Unit(unit):HasDeBuffs(A.DevouringPlague.ID, true) < 1 or Insanity > 75) and (not VarPoolForCDs or Insanity >= 85) and (not A.SearingNightmare:IsTalentLearned() or (A.SearingNightmare:IsTalentLearned() and not VarSearingNightmareCutoff)) then
				return A.DevouringPlague:Show(icon)
			end
			
			--# Use VB on CD if you don't need to cast Devouring Plague, and there are less than 4 targets out (5 with conduit).
			--actions.main+=/void_bolt,if=spell_targets.mind_sear<(4+conduit.dissonant_echoes.enabled)&insanity<=85&talent.searing_nightmare.enabled|!talent.searing_nightmare.enabled
			if A.VoidBolt:IsReady(unit, nil, nil, true) and CanCast and VoidFormActive and ((MultiUnits:GetActiveEnemies() < 4 and Insanity <= 85 and A.SearingNightmare:IsTalentLearned()) or not A.SearingNightmare:IsTalentLearned()) then
				return A.VoidBolt:Show(icon)
			end
			
			--# Use Shadow Word: Death if the target is about to die or you have Shadowflame Prism equipped with Mindbender or Shadowfiend active.
			--actions.main+=/shadow_word_death,target_if=(target.health.pct<20&spell_targets.mind_sear<4)|(pet.fiend.active&runeforge.shadowflame_prism.equipped)
			if A.ShadowWordDeath:IsReady(unit, nil, nil, true) and CanCast and ((Unit(unit):HealthPercent() < 20 and MultiUnits:GetActiveEnemies() < 4) or (FiendActive and ShadowflamePrism)) then
				return A.ShadowWordDeath:Show(icon)
			end
			
			--# Use Surrender to Madness on a target that is going to die at the right time.
			--actions.main+=/surrender_to_madness,target_if=target.time_to_die<25&buff.voidform.down
			if A.SurrendertoMadness:IsReady(player) and A.BurstIsON(unit) and Unit(unit):TimeToDie() < 25 and not VoidFormActive then
				return A.SurrendertoMadness:Show(icon)
			end	
			
			--# Use Void Torrent only if SW:P and VT are active and the target won't die during the channel.
			--actions.main+=/void_torrent,target_if=variable.dots_up&target.time_to_die>3&buff.voidform.down&active_dot.vampiric_touch==spell_targets.vampiric_touch&spell_targets.mind_sear<(5+(6*talent.twist_of_fate.enabled))
			if A.VoidTorrent:IsReady(unit) and CanCast and (not isMoving or StMActive) and VarDotsUp and Unit(unit):TimeToDie() > 3 and not VoidFormActive and MultiUnits:GetByRangeMissedDoTs(40, 0, A.VampiricTouch.ID) and MultiUnits:GetActiveEnemies() < (5 + (6 * num(A.TwistofFate:IsTalentLearned()))) then
				return A.VoidTorrent:Show(icon)
			end
			
			--actions.main+=/mindbender,if=dot.vampiric_touch.ticking&(talent.searing_nightmare.enabled&spell_targets.mind_sear>variable.mind_sear_cutoff|dot.shadow_word_pain.ticking)
			if A.Mindbender:IsReady(unit) and A.Mindbender:IsTalentLearned() and CanCast and Unit(unit):HasDeBuffs(A.VampiricTouch.ID, true) > 0 and (A.SearingNightmare:IsTalentLearned() and MultiUnits:GetActiveEnemies() > VarMindSearCutoff or Unit(unit):HasDeBuffs(A.ShadowWordPain.ID, true) > 0) then
				return A.Mindbender:Show(icon)
			end
			
			if A.Shadowfiend:IsReady(unit) and not A.Mindbender:IsTalentLearned() and CanCast and Unit(unit):HasDeBuffs(A.VampiricTouch.ID, true) > 0 and (A.SearingNightmare:IsTalentLearned() and MultiUnits:GetActiveEnemies() > VarMindSearCutoff or Unit(unit):HasDeBuffs(A.ShadowWordPain.ID, true) > 0) then
				return A.Shadowfiend:Show(icon)
			end			
			
			--# Use SW:D with Painbreaker Psalm unless the target will be below 20% before the cooldown comes back
			--actions.main+=/shadow_word_death,if=runeforge.painbreaker_psalm.equipped&variable.dots_up&target.time_to_pct_20>(cooldown.shadow_word_death.duration+gcd)
			if A.ShadowWordDeath:IsReady(unit) and Painbreaker and VarDotsUp and Unit(unit):TimeToDieX(20) > 17 then
				return A.ShadowWordDeath:Show(icon)
			end	
			
			--# Use Shadow Crash on CD unless there are adds incoming.
			--actions.main+=/shadow_crash,if=raid_event.adds.in>10
			if A.ShadowCrash:IsReady(player) and CanCast then	
				return A.ShadowCrash:Show(icon)
			end
			
			--# Use Mind Sear to consume Dark Thoughts procs on AOE. TODO Confirm is this is a higher priority than redotting on AOE unless dark thoughts is about to time out
			--actions.main+=/mind_sear,target_if=spell_targets.mind_sear>variable.mind_sear_cutoff&buff.dark_thought.up,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2
			if A.MindSear:IsReady(unit) and CanCast and (not isMoving or StMActive) and MultiUnits:GetActiveEnemies() > VarMindSearCutoff and Unit(player):HasBuffs(A.DarkThought.ID, true) > 0 then
				return A.MindSear:Show(icon)
			end
			
			--# Use Mind Flay to consume Dark Thoughts procs on ST. TODO Confirm if this is a higher priority than redotting unless dark thoughts is about to time out
			--actions.main+=/mind_flay,if=buff.dark_thought.up&variable.dots_up,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&cooldown.void_bolt.up
			if A.MindFlay:IsReady(unit) and CanCast and (not isMoving or StMActive) and Unit(player):HasBuffs(A.DarkThought.ID, true) > 0 then
				return A.MindFlay:Show(icon)
			end
			
			--# Use Mind Blast if you don't need to refresh DoTs. Stop casting at 4 or more targets with Searing Nightmare talented.
			--actions.main+=/mind_blast,if=variable.dots_up&raid_event.movement.in>cast_time+0.5&(spell_targets.mind_sear<4&!talent.misery.enabled|spell_targets.mind_sear<6&talent.misery.enabled)
			if A.MindBlast:IsReady(unit, nil, nil, true) and CanCast and (not isMoving or StMActive) and VarDotsUp and ((MultiUnits:GetActiveEnemies() < 4 and not A.Misery:IsTalentLearned()) or (MultiUnits:GetActiveEnemies() < 6 and A.Misery:IsTalentLearned())) then
				return A.MindBlast:Show(icon)
			end
			
			--actions.main+=/vampiric_touch,target_if=refreshable&target.time_to_die>6|(talent.misery.enabled&dot.shadow_word_pain.refreshable)|buff.unfurling_darkness.up
			if A.VampiricTouch:IsReady(unit, nil, nil, true) and CanCast and Temp.VampiricTouchDelay == 0 and Unit(unit):HasDeBuffs(A.VampiricTouch.ID, true) < 6.3 and (not isMoving or StMActive or Unit(player):HasBuffs(A.UnfurlingDarknessBuff.ID, true) > 0) and (Unit(unit):TimeToDie() > 6 or (A.Misery:IsTalentLearned() and Unit(unit):HasDeBuffs(A.ShadowWordPain.ID, true) < 4.8) or Unit(player):HasBuffs(A.UnfurlingDarknessBuff.ID, true) > 0) then
				return A.VampiricTouch:Show(icon)
			end
			
			--# Special condition to stop casting SW:P on off-targets when fighting 3 or more stacked mobs and using Psychic Link and NOT Misery.
			--actions.main+=/shadow_word_pain,if=refreshable&target.time_to_die>4&!talent.misery.enabled&talent.psychic_link.enabled&spell_targets.mind_sear>2
			if A.ShadowWordPain:IsReady(unit, nil, nil, true) and CanCast and Unit(unit):HasDeBuffs(A.ShadowWordPain.ID, true) < 4.8 and Unit(unit):TimeToDie() > 4 and not A.Misery:IsTalentLearned() and A.PsychicLink:IsTalentLearned() and MultiUnits:GetActiveEnemies() > 2 then
				return A.ShadowWordPain:Show(icon)
			end
			
			--# Keep SW:P up on as many targets as possible, except when fighting 3 or more stacked mobs with Psychic Link.
			--actions.main+=/shadow_word_pain,target_if=refreshable&target.time_to_die>4&!talent.misery.enabled&!(talent.searing_nightmare.enabled&spell_targets.mind_sear>variable.mind_sear_cutoff)&(!talent.psychic_link.enabled|(talent.psychic_link.enabled&spell_targets.mind_sear<=2))
			if A.ShadowWordPain:IsReady(unit, nil, nil, true) and CanCast and Unit(unit):HasDeBuffs(A.ShadowWordPain.ID, true) < 4.8 and Unit(unit):TimeToDie() > 4 and not A.Misery:IsTalentLearned() and not (A.SearingNightmare:IsTalentLearned() and MultiUnits:GetActiveEnemies() > VarMindSearCutoff) and (not A.PsychicLink:IsTalentLearned() or (A.PsychicLink:IsTalentLearned() and MultiUnits:GetActiveEnemies() <= 2)) then
				return A.ShadowWordPain:Show(icon)
			end
			
			--actions.main+=/mind_sear,target_if=spell_targets.mind_sear>variable.mind_sear_cutoff,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2
			if A.MindSear:IsReady(unit) and CanCast and (not isMoving or StMActive) and MultiUnits:GetActiveEnemies() > VarMindSearCutoff then
				return A.MindSear:Show(icon)
			end
			
			--actions.main+=/mind_flay,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&cooldown.void_bolt.up
			if A.MindFlay:IsReady(unit) and CanCast and (not isMoving or StMActive) then
				return A.MindFlay:Show(icon)
			end
			
			--# Use SW:D as last resort if on the move
			--actions.main+=/shadow_word_death
			if A.ShadowWordDeath:IsReady(unit) and CanCast and isMoving then
				return A.ShadowWordDeath:Show(icon)
			end
			
			--PWS Moving
			if isMovingFor > Action.GetToggle(2, "PWSMove") and CanCast and Unit(player):HasDeBuffs(A.WeakenedSoul.ID) == 0 and Action.GetToggle(2, "UsePWS") and A.BodyandSoul:IsTalentLearned() then                   
				A.Toaster:SpawnByTimer("TripToast", 0, "Speed Boost!", "Using Power Word: Shield!", A.PowerWordShield.ID)
				return A.PowerWordShield:Show(icon)
			end			
			
			--# Use SW:P as last resort if on the move and SW:D is on CD
			--actions.main+=/shadow_word_pain
			if A.ShadowWordPain:IsReady(unit) and CanCast and isMoving then
				return A.ShadowWordPain:Show(icon)
			end
			
		end	


		--actions.precombat+=/shadowform,if=!buff.shadowform.up
		if A.Shadowform:IsReady(player) and Unit(player):HasBuffs(A.Shadowform.ID, true) == 0 and not VoidFormActive then
			return A.Shadowform:Show(icon)
		end

		local Interrupt = Interrupts(unit)
		if Interrupt and CanCast then 
			return Interrupt:Show(icon)
		end		
		
		--actions+=/fireblood,if=buff.voidform.up
		if A.Fireblood:IsReady(player) and CanCast and UseRacial and VoidFormActive then
			return A.Fireblood:Show(icon)
		end
		
		--actions+=/berserking,if=buff.voidform.up
		if A.Berserking:IsReady(player) and CanCast and UseRacial and VoidFormActive then
			return A.Berserking:Show(icon)
		end	
		
		--# Use Light's Judgment if there are 2 or more targets, or adds aren't spawning for more than 75s.
		--actions+=/lights_judgment,if=spell_targets.lights_judgment>=2|(!raid_event.adds.exists|raid_event.adds.in>75)
		if A.LightsJudgment:IsReady(unit) and CanCast and UseRacial then
			return A.LightsJudgment:Show(icon)
		end
		
		--actions+=/ancestral_call,if=buff.voidform.up
		if A.AncestralCall:IsReady(player) and CanCast and UseRacial and VoidFormActive then
			return A.AncestralCall:Show(icon)
		end		

		--UnfurlingDarkness Safety Net
		if A.VampiricTouch:IsReady(unit, nil, nil, A.GetToggle(2, "ByPassSpells")) and CanCast and (Unit("player"):HasBuffs(A.UnfurlingDarknessBuff.ID, true) > 0 and Unit("player"):HasBuffs(A.UnfurlingDarknessBuff.ID, true) < 3) then
			return A.VampiricTouch:Show(icon)
		end	

		--High Priority Mind Blast to consume 2 charges
		if A.MindBlast:IsReady(unit, nil, nil, true) and CanCast and A.MindBlast:GetSpellCharges() > 1 then
			return A.MindBlast:Show(icon)
		end
		--actions.cds+=/mindgames,target_if=insanity<90&(variable.all_dots_up|buff.voidform.up)&(!talent.hungering_void.enabled|debuff.hungering_void.up|!buff.voidform.up)&(!talent.searing_nightmare.enabled|spell_targets.mind_sear<5)
		if A.Mindgames:IsReady(unit) and inCombat and CanCast and (not isMoving or StMActive) and UseCovenant and Player:Insanity() < 90 and (VarAllDotsUp or VoidFormActive) and (not A.HungeringVoid:IsTalentLearned() or Unit(unit):HasDeBuffs(A.HungeringVoid.ID, true) > 0 or not VoidFormActive) and (not A.SearingNightmare:IsTalentLearned() or MultiUnits:GetActiveEnemies() < 5) then
			return A.Mindgames:Show(icon)
		end	

		--# Use Unholy Nova on CD, holding briefly to wait for power infusion or add spawns.
		--actions.cds+=/unholy_nova,if=((!raid_event.adds.up&raid_event.adds.in>20)|raid_event.adds.remains>=15|raid_event.adds.duration<15)&
		if A.UnholyNova:IsReady(unit) and inCombat and UseCovenant and ((MultiUnits:GetActiveEnemies() > 2 and Player:AreaTTD(40) > 5) or BurstIsON(unit)) then
			return A.UnholyNova:Show(icon)
		end
		
		--Faerie Bois??
		if A.FaeGuardians:IsReady(unit) and inCombat and Unit(unit):TimeToDie() > 15 and UseCovenant then
			return A.FaeGuardians:Show(icon)
		end
		
		--Void Bolt out of Voidform procs
		if A.VoidBolt:IsReady(unit, nil, nil, true) and Unit(player):HasBuffs(A.DissonantEchoes.ID, true) > 0 then
			return A.VoidBolt:Show(icon)
		end
		
		--actions+=/call_action_list,name=cwc
		if Player:IsChanneling() == A.MindSear:Info() or Player:IsChanneling() == A.MindFlay:Info() then
			if CWC() then
				return true
			end
		end
		
		--actions+=/run_action_list,name=main
		if inCombat and CanCast then
			if Main() then
				return true
			end
		end
		
		--actions=potion,if=buff.voidform.up|buff.power_infusion.up	
		
		--Precombat
		if not inCombat and CanCast then
			if Precombat() then
				return true
			end
		end
	end
    
    -- End on EnemyRotation()

	if A.PowerWordFortitude:IsReady(player) and Unit(player):HasBuffs(A.PowerWordFortitude.ID, true) < 300 and not inCombat then
		return A.PowerWordFortitude:Show(icon)
	end
    
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
