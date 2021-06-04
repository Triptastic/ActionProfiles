--#############################
--##### TRIP'S TBC HUNTER #####
--#############################

local _G, setmetatable, pairs, ipairs, select, error, math = 
_G, setmetatable, pairs, ipairs, select, error, math 

local wipe                                     = _G.wipe     
local math_max                                = math.max      

local TMW                                     = _G.TMW 
local strlowerCache                          = TMW.strlowerCache
local Action                                = _G.Action
local toNum                                 = Action.toNum
local CONST                                 = Action.Const
local Create                                 = Action.Create
local Listener                                = Action.Listener
local Print                                    = Action.Print
local TeamCache                                = Action.TeamCache
local EnemyTeam                                = Action.EnemyTeam
local FriendlyTeam                            = Action.FriendlyTeam
local LoC                                     = Action.LossOfControl
local Player                                = Action.Player 
local MultiUnits                            = Action.MultiUnits
local UnitCooldown                            = Action.UnitCooldown
local Unit                                    = Action.Unit 
local Pet                                       = LibStub("PetLibrary") 

local SetToggle                                = Action.SetToggle
local GetToggle                                = Action.GetToggle
local GetPing                                = Action.GetPing
local GetGCD                                = Action.GetGCD
local GetCurrentGCD                            = Action.GetCurrentGCD
local GetLatency                            = Action.GetLatency
local GetSpellInfo                            = Action.GetSpellInfo
local BurstIsON                                = Action.BurstIsON
local InterruptIsValid                        = Action.InterruptIsValid
local IsUnitEnemy                            = Action.IsUnitEnemy
local DetermineUsableObject                    = Action.DetermineUsableObject 
local DetermineIsCurrentObject                = Action.DetermineIsCurrentObject 
local DetermineCountGCDs                    = Action.DetermineCountGCDs 
local DetermineCooldownAVG                    = Action.DetermineCooldownAVG 
local AuraIsValid                            = Action.AuraIsValid

local CanUseStoneformDefense                = Action.CanUseStoneformDefense
local CanUseStoneformDispel                    = Action.CanUseStoneformDispel
local CanUseHealingPotion                    = Action.CanUseHealingPotion
local CanUseLivingActionPotion                = Action.CanUseLivingActionPotion
local CanUseLimitedInvulnerabilityPotion    = Action.CanUseLimitedInvulnerabilityPotion
local CanUseRestorativePotion                = Action.CanUseRestorativePotion
local CanUseSwiftnessPotion                    = Action.CanUseSwiftnessPotion

local TeamCacheFriendly                        = TeamCache.Friendly
local ActiveUnitPlates                        = MultiUnits:GetActiveUnitPlates()

local SPELL_FAILED_TARGET_NO_POCKETS        = _G.SPELL_FAILED_TARGET_NO_POCKETS      
local ERR_INVALID_ITEM_TARGET                = _G.ERR_INVALID_ITEM_TARGET    
local MAX_BOSS_FRAMES                        = _G.MAX_BOSS_FRAMES  

local CreateFrame                            = _G.CreateFrame
local UIParent                                = _G.UIParent        
local StaticPopup1                            = _G.StaticPopup1    
local StaticPopup1Button2                    -- nil because frame is not created at this moment

local GetWeaponEnchantInfo                    = _G.GetWeaponEnchantInfo    
local GetItemInfo                            = _G.GetItemInfo  
local      UnitGUID,       UnitIsUnit,      UnitCreatureType,       UnitAttackPower = 
_G.UnitGUID, _G.UnitIsUnit, _G.UnitCreatureType, _G.UnitAttackPower

Action[Action.PlayerClass]                     = {
	--Racial
    Shadowmeld								= Create({ Type = "Spell", ID = 20580		}),  
    Perception								= Create({ Type = "Spell", ID = 20600, FixedTexture = CONST.HUMAN	}), 
    BloodFury								= Create({ Type = "Spell", ID = 20572		}), 
    Berserking								= Create({ Type = "Spell", ID = 20554		}), 
    Stoneform								= Create({ Type = "Spell", ID = 20594		}), 
    WilloftheForsaken						= Create({ Type = "Spell", ID = 7744		}), 
    EscapeArtist							= Create({ Type = "Spell", ID = 20589		}),	
	ArcaneTorrent							= Create({ Type = "Spell", ID = 28730		}),

	--General
    ShootBow								= Create({ Type = "Spell", ID = 2480,     QueueForbidden = true, BlockForbidden = true	}),
    ShootCrossbow							= Create({ Type = "Spell", ID = 7919,     QueueForbidden = true, BlockForbidden = true	}),
    ShootGun                                = Create({ Type = "Spell", ID = 7918,     QueueForbidden = true, BlockForbidden = true	}),
    Throw									= Create({ Type = "Spell", ID = 2764,     QueueForbidden = true, BlockForbidden = true	}),	

	--Beast Mastery
	AspectoftheBeast						= Create({ Type = "Spell", ID = 13161		}),
	AspectoftheCheetah						= Create({ Type = "Spell", ID = 5118		}),
    AspectoftheHawk							= Create({ Type = "Spell", ID = 13165		}),
    AspectoftheMonkey						= Create({ Type = "Spell", ID = 13163		}),
    AspectofthePack							= Create({ Type = "Spell", ID = 13159		}),
    AspectoftheViper						= Create({ Type = "Spell", ID = 34074		}),	
    AspectoftheWild							= Create({ Type = "Spell", ID = 20043		}),
    BeastLore								= Create({ Type = "Spell", ID = 1462		}),
    BestialWrath							= Create({ Type = "Spell", ID = 19574		}),
    CallPet									= Create({ Type = "Spell", ID = 883			}),
    DismissPet								= Create({ Type = "Spell", ID = 2641		}),
    EagleEye								= Create({ Type = "Spell", ID = 6197		}),
    EyesoftheBeast							= Create({ Type = "Spell", ID = 1002		}),
    FeedPet									= Create({ Type = "Spell", ID = 6991		}),
    Intimidation							= Create({ Type = "Spell", ID = 19577		}),
    KillCommand								= Create({ Type = "Spell", ID = 34026		}),	
    MendPet									= Create({ Type = "Spell", ID = 136			}),
    RevivePet								= Create({ Type = "Spell", ID = 982			}),
    ScareBeast								= Create({ Type = "Spell", ID = 1513		}),
    TameBeast								= Create({ Type = "Spell", ID = 1515		}),

	--Marksmanship
    AimedShot								= Create({ Type = "Spell", ID = 19434		}),    
	ArcaneShot								= Create({ Type = "Spell", ID = 3044		}),
    ConcussiveShot							= Create({ Type = "Spell", ID = 5116		}),
    DistractingShot							= Create({ Type = "Spell", ID = 20736		}),
    Flare									= Create({ Type = "Spell", ID = 1543		}),
    HuntersMark								= Create({ Type = "Spell", ID = 1130		}),
    MultiShot								= Create({ Type = "Spell", ID = 2643		}),
    RapidFire								= Create({ Type = "Spell", ID = 3045		}),
    ScatterShot								= Create({ Type = "Spell", ID = 19503		}),	
    ScorpidSting							= Create({ Type = "Spell", ID = 3043		}),
    SerpentSting							= Create({ Type = "Spell", ID = 1978		}),
    SilencingShot							= Create({ Type = "Spell", ID = 34490		}),	
    SteadyShot								= Create({ Type = "Spell", ID = 34120		}),	
    TrueshotAura							= Create({ Type = "Spell", ID = 19506		}),	
    ViperSting								= Create({ Type = "Spell", ID = 3034		}),	
    Volley									= Create({ Type = "Spell", ID = 1510		}),

	--Survival
    Counterattack							= Create({ Type = "Spell", ID = 19306		}),
    Deterrence								= Create({ Type = "Spell", ID = 19263		}),
    Disengage								= Create({ Type = "Spell", ID = 781			}),
    ExplosiveTrap							= Create({ Type = "Spell", ID = 13813		}),
    FeignDeath								= Create({ Type = "Spell", ID = 5384		}),
    FreezingTrap							= Create({ Type = "Spell", ID = 1499		}),
	FreezingTrapDebuff						= Create({ Type = "Spell", ID = 3355 or 14308 }),
    FrostTrap								= Create({ Type = "Spell", ID = 13809		}),
    ImmolationTrap							= Create({ Type = "Spell", ID = 13795		}),
    Misdirection							= Create({ Type = "Spell", ID = 34477		}),	
    MongooseBite							= Create({ Type = "Spell", ID = 1495		}),
    RaptorStrike							= Create({ Type = "Spell", ID = 2973		}),
    Readiness								= Create({ Type = "Spell", ID = 23989		}),
    SnakeTrap								= Create({ Type = "Spell", ID = 34600		}),	
    TrackHidden								= Create({ Type = "Spell", ID = 19885		}),	
    WingClip								= Create({ Type = "Spell", ID = 2974		}),
    WyvernString							= Create({ Type = "Spell", ID = 19386		}),

	--Misc
    Heroism									= Create({ Type = "Spell", ID = 32182		}),
    Bloodlust								= Create({ Type = "Spell", ID = 2825		}),
    Drums									= Create({ Type = "Spell", ID = 29529		}),	
}

local A                                     = setmetatable(Action[Action.PlayerClass], { __index = Action })

local player                                 = "player"
local targettarget                            = "targettarget"

local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end
local player = "player"
local target = "target"
local pet = "pet"
local targettarget = "targettarget"

local VarCAExecute = false;

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

--[[ API - Spell
Pet:AddActionsSpells(254, {

	-- number accepted
	17253, -- Bite
	16827, -- Claw
	49966, -- Smack 
}, true)]]


local function AtRange(unit)
	-- @return boolean 
	return A.ArcaneShot:IsInRange(unit)
end 
AtRange = A.MakeFunctionCachedDynamic(AtRange)

local function InMelee(unit)
	-- @return boolean 
	return A.WingClip:IsInRange(unit)
end 
InMelee = A.MakeFunctionCachedDynamic(InMelee)

--- ======= ACTION LISTS =======
-- [3] Single Rotation
A[3] = function(icon, isMulti)
    --------------------
    --- ROTATION VAR ---
    --------------------
    local isMoving = A.Player:IsMoving()
    local inCombat = Unit(player):CombatTime() > 0
	local combatTime = Unit(player):CombatTime()
	local MultiShotST = A.GetToggle(2, "MultiShotST")
	local AutoSyncCDs = A.GetToggle(2, "AutoSyncCDs")
	local ManaSave = A.GetToggle(2, "ManaSave")
	local MendPet = A.GetToggle(2, "MendPet")
	local FreezingTrapPvE = A.GetToggle(2, "FreezingTrapPvE")
	local ConcussiveShotPvE = A.GetToggle(2, "ConcussiveShotPvE")	
	local ProtectFreeze = A.GetToggle(2, "ProtectFreeze")
	
	--local AutoAspect = A.GetToggle(2, "AutoAspect")
		--AutoAspect[1] = Hawk
		--AutoAspect[2] = Cheetah
		--AutoAspect[3] = Viper
	
	local BurnPhase = Unit(player):HasBuffs(A.Heroism.ID) > 0 or Unit(player):HasBuffs(A.Bloodlust.ID) > 0 or Unit(player):HasBuffs(A.Drums.ID) > 0
	local CheetahBuff = Unit(player):HasBuffs(A.AspectoftheCheetah.ID, true) > 0 or Unit(player):HasBuffs(A.AspectofthePack.ID, true) > 0



	--[[if AutoAspect[3] then 
		if Unit(player):HasBuffs(A.AspectoftheViper.ID, true) == 0 and Player:ManaPercentage() < 95 and not inCombat then
			return A.AspectoftheViper:Show(icon)
		end
	end
	
	if AutoAspect[2] then
		if Unit(player):HasBuffs(A.AspectoftheCheetah.ID, true) == 0 and ((Player:ManaPercentage() > 95 and AutoAspect[3]) or not AutoAspect[3]) and not inCombat then
			return A.AspectoftheCheetah:Show(icon)
		end
	end]]

	if A.CallPet:IsReady(player) and not Pet:IsActive() then
		return A.CallPet:Show(icon)
	end
	
    ------------------------------------------------------
    ---------------- ENEMY UNIT ROTATION -----------------
    ------------------------------------------------------
    local function EnemyRotation(unit)

		if ProtectFreeze and Unit(target):HasDeBuffs(A.FreezingTrapDebuff.ID) > 0 and A.MultiUnits:GetActiveEnemies() >= 2 then
			return A:Show(icon, CONST.AUTOTARGET)
		end

		--[[if AutoAspect[1] then
			if (CheetahBuff and inCombat) or (not C`heetahBuff) then
				if A.AspectoftheHawk:IsReady(player) and Unit(player):HasBuffs(A.AspectoftheHawk.ID, true) == 0 and ((Player:ManaPercentage() >= 95 and AutoAspect[3]) or inCombat) then
					return A.AspectoftheHawk:Show(icon)
				end	
			end
		end]]

		if A.FreezingTrap:IsReady(player) and FreezingTrapPvE and A.MultiUnits:GetActiveEnemies() >= 2 and A.MultiUnits:GetByRange(1, 5) then
			return A.FreezingTrap:Show(icon)
		end

		if A.MendPet:IsReady(player) and Unit(pet):HealthPercent() < MendPet and Pet:IsActive() and Pet:HasBuffs(A.MendPet.ID, true) == 0 then
			return A.MendPet:Show(icon)
		end

		if A.HuntersMark:IsReady(unit) and Unit(unit):HasDeBuffs(A.HuntersMark.ID, true) == 0 and Unit(unit):TimeToDie() > 2 then
			return A.HuntersMark:Show(icon)
		end

		if A.KillCommand:IsReady(unit) then
			return A.KillCommand:Show(icon)
		end

		if AtRange() then
			if not Player:IsShooting() then
				return A:Show(icon, CONST.AUTOSHOOT)
			end	
			
			if A.ConcussiveShot:IsReady(unit) and ConcussiveShotPvE and UnitIsUnit(targettarget, player) then
				return A.ConcussiveShot:Show(icon)
			end
			
			if BurstIsON(unit) or (not BurstIsON(unit) and AutoSyncCDs) then
				if (AutoSyncCDs and BurnPhase) or not AutoSyncCDs then
					if A.BestialWrath:IsReady(player) and (Unit(unit):TimeToDie() > 5 or Unit(unit):IsBoss()) then
						return A.BestialWrath:Show(icon)
					end
				
					if A.RapidFire:IsReady(player) and (Unit(unit):TimeToDie() > 5 or Unit(unit):IsBoss()) then
						return A.RapidFire:Show(icon)
					end

					--Trinket 1
					if A.Trinket1:IsReady(unit) then
						return A.Trinket1:Show(icon)    
					end
					
					--Trinket 2
					if A.Trinket2:IsReady(unit) then
						return A.Trinket2:Show(icon)    
					end					
					
				end					
			end
 
			local ShootTimer = Player:GetSwingShoot()
			--print(ShootTimer)
			if ShootTimer >= Player:Execute_Time(A.SteadyShot.ID) and Player:ManaPercentage() > ManaSave then
				if A.SteadyShot:IsReady(unit) then
					return A.SteadyShot:Show(icon)
				end					
			end
			
			if ShootTimer < Player:Execute_Time(A.SteadyShot.ID) and ShootTimer > Player:Execute_Time(A.MultiShot.ID) and Player:ManaPercentage() > ManaSave then
				if A.MultiShot:IsReady(unit) and MultiShotST then
					return A.MultiShot:Show(icon)
				end
				
				if A.ArcaneShot:IsReady(unit) then
					return A.ArcaneShot:Show(icon)
				end
			end
		end

		if InMelee() then
			if not Player:IsAttacking() then
				return A:Show(icon, CONST.AUTOATTACK)
			end
			
			if A.MongooseBite:IsReady(unit) then
				return A.MongooseBite:Show(icon)
			end
			
			if A.RaptorStrike:IsReady(unit) and not A.RaptorStrike:IsSpellCurrent() then
				return A.RaptorStrike:Show(icon)
			end
		
		end
		
       
    end

    -- End on EnemyRotation()


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

A[1] = nil

A[4] = nil

A[5] = nil

A[6] = nil

A[7] = nil

A[8] = nil
