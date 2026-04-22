-- Core Functions
function has_not(item)
    return Tracker:ProviderCountForCode(item) == 0
end

function has(item)
    return Tracker:ProviderCountForCode(item) > 0
end

function has_at_least(item, amount)
    return Tracker:ProviderCountForCode(item) >= amount
end

function has_exactly(item, amount)
    return Tracker:ProviderCountForCode(item) == amount
end

-- Visibility Rules
function hasGoalRipto()
    return has("goal_ripto")
end

-- function hasGoalTalisman()
--     return has("goal_14_talisman")
-- end

-- function hasGoal40Orb()
--     return has("goal_40_orb")
-- end

function hasGoal64Orb()
    return has("goal_64_orb")
end

function hasGoal100Percent()
    return has("goal_100_percent")
end

function hasGoal10Token()
    return has("goal_10_tokens")
end

function hasGoalSkillpoint()
    return has("goal_all_skillpoints")
end

function hasGoalEpilogue()
    return has("goal_epilogue")
end

function hasOpenWorld()
    return has("setting_open_world")
end

function hasOpenAbilityAndWarps()
    return has("setting_open_world_warp_unlocks")
end

function hasLevelLocks()
    return has("setting_level_lock")
end

function hasTotalGems()
    return has("setting_enable_total_gem_checks")
end

function hasMaxTotalAtLeast(amount)
    if has("setting_enable_total_gem_checks") then
        return has_at_least("setting_max_total_gem_checks",tonumber(amount))
    else
        return false
    end
end

function hasSkillPoints()
    return has("setting_enable_skillpoint_checks")
end

function hasSkillPointsGoal()
    return hasGoalSkillpoint() or hasGoalEpilogue()
end

function hasLifeBottles()
    return has("setting_enable_life_bottle_checks")
end

function hasSpiritParticles()
    return has("setting_enable_spirit_particle_checks")
end

function hasMoneybagsVanilla()
    return has("setting_moneybags_vanilla")
end

function hasDeathlink()
    return has("setting_deathlink")
end

-- Accessibilty Rules
function hasCrushDefeated()
    return has("crush_defeated") or (hasOpenWorld() and hasOpenAbilityAndWarps())
end

function hasGulpDefeated()
    return has("gulp_defeated") or (hasOpenWorld() and hasOpenAbilityAndWarps())
end

function hasRiptoDefeated()
    return has("ripto_defeated")
end

function hasSwim()
    return has("swim") or hasRiptoDefeated()
end

function hasClimb()
    return has("climb") or hasRiptoDefeated()
end

function hasHeadbash()
    return has("headbash") or hasRiptoDefeated()
end

function hasDoubleJump()
    return has("double_jump")
end

function hasPermanentFireball()
    return has("infinite_fireball")
end

function canBreakCrates()
    return hasPermanentFireball() or hasHeadbash()
end

function maxSparxHealth()
    if ((not has("setting_enable_progressive_sparx_logic")) or (Tracker:FindObjectForCode("setting_enable_progressive_sparx_health").CurrentStage == 4)) then
        return 3
    else
        return Tracker:FindObjectForCode("progressive_sparx").CurrentStage
    end
end

function hasSparxHealth(health)
    print("Max health = " .. maxSparxHealth())
    print("Threshold = " .. tonumber(health))
    return (maxSparxHealth() >= tonumber(health))
end

function canReachSummerSecondHalf()
    return hasSwim() or (has("setting_trick_logic_sf_second_half_double_jump") and hasDoubleJump()) or has("setting_trick_logic_sf_second_half_nothing")
end

function canReachMetro()
    return has_at_least("orb",6)
end

function canReachAutumnSecondHalf()
    return hasClimb() or (has("setting_trick_logic_ap_climb_skip") and hasDoubleJump())
end

function canPassAutumnDoor()
    return canReachAutumnSecondHalf() and (has_at_least("orb",8) or (hasDoubleJump() and (has("setting_trick_logic_ap_door_skip") or has("setting_trick_logic_ap_climb_skip"))))
end

function canReachWinterSecondHalf()
    return hasHeadbash() or (has("setting_trick_logic_wt_castle_double_jump") and hasDoubleJump()) or has("setting_trick_logic_wt_castle_penguin_proxy")
end

function canReachRiptoDoor()
    return canReachWinterSecondHalf() and (has_at_least("orb",Tracker:FindObjectForCode("setting_ripto_door_orbs").AcquiredCount) or (((has("setting_trick_logic_wt_oob_double_jump") and hasDoubleJump()) or has("setting_trick_logic_wt_oob_nothing")) and has("setting_trick_logic_wt_swim_from_oob") and hasSwim()))
end

function hasAquariaWall()
    return canReachSummerSecondHalf() and ((has("setting_trick_logic_sf_swim_in_air") and hasSwim()) or (has("setting_trick_logic_sf_aquaria_wall_double_jump") and hasDoubleJump()) or has("setting_trick_logic_sf_aquaria_wall_nothing") or has("money_at_wall") or hasRiptoDefeated())
end

function hasAquariaSub()
    return has("money_at_sub") or hasRiptoDefeated()
end

function hasSOPortal()
    return has("money_so_portal") or hasRiptoDefeated()
end

function hasCGBridge()
    return has("money_cg_bridge") or hasRiptoDefeated()
end

function hasMCElevator()
    return has("money_mc_elevator") or hasRiptoDefeated()
end

function hasZPortal()
    return has("money_z_portal") or hasRiptoDefeated()
end

function hasISPortal()
    return has("money_is_portal") or hasRiptoDefeated()
end

function hasCSPortal()
    return has("money_cs_portal") or hasRiptoDefeated()
end

--Trick Rules
function canReachSFSecretLedge()
    return hasSwim() or (has("setting_trick_logic_sf_ledge_double_jump") and hasDoubleJump())
end

function canReachSFLadder()
    return canReachSummerSecondHalf() and (hasClimb() or (has("setting_trick_logic_sf_swim_in_air") and hasSwim()) or (has("setting_trick_logic_sf_frog_proxy")))
end

function canReachGlimmerIndoorLamps()
    return hasClimb() or (has("setting_trick_logic_indoor_lamps_double_jump") and hasDoubleJump()) or (has("setting_trick_logic_indoor_lamps_fireball") and hasPermanentFireball()) or has("setting_trick_logic_indoor_lamps_superfly")
end

function canReachAquariaFirstTunnel()
    return hasSwim() or (has("setting_trick_logic_at_first_tunnel_double_jump") and hasDoubleJump()) or has("setting_trick_logic_at_sheep_proxy")
end

function canReachAquariaRoomTwoBottom()
    return hasSwim() or has("setting_trick_logic_at_sheep_proxy")
end

function canReachAquariaRoomTwoCrabPit()
    return hasSwim() or (has("setting_trick_logic_at_sheep_proxy") and has("setting_trick_logic_at_gems_oob"))
end

function canReachAquariaRoomTwoSharkPit()
    return (hasSwim() and (hasAquariaSub() or hasPermanentFireball())) or (has("setting_trick_logic_at_sheep_proxy") and has("setting_trick_logic_at_gems_oob") and hasPermanentFireball())
end

function canReachAquariaRoomTwoMiddle()
    return hasSwim() or (has("setting_trick_logic_at_sheep_proxy") and has("setting_trick_logic_at_gems_oob"))
end

function canReachAquariaRoomTwoTop()
    return (hasSwim() and (hasAquariaSub() or (has("setting_trick_logic_at_button_three_fireball") and hasPermanentFireball()))) or (has("setting_trick_logic_at_sheep_proxy") and has("setting_trick_logic_at_gems_oob"))
end

function canReachAquariaPreMoneybagsTunnel()
    return hasSwim() or (has("setting_trick_logic_at_sheep_proxy") and has("setting_trick_logic_at_gems_oob"))
end

function canReachAquariaSharkTunnel()
    return (hasSwim() and (hasAquariaSub() or (has("setting_trick_logic_at_button_three_fireball") and hasPermanentFireball()))) or (has("setting_trick_logic_at_sheep_proxy") and has("setting_trick_logic_at_gems_oob") and hasPermanentFireball())
end

function canReachAquariaRoomThree()
    return (hasSwim() and (hasAquariaSub() or (has("setting_trick_logic_at_button_three_fireball") and hasPermanentFireball()))) or has("setting_trick_logic_at_sheep_proxy")
end

function canReachAquariaTalismanAreaGems()
    return canReachAquariaRoomThree() or (has("setting_trick_logic_at_talisman_area_double_jump") and hasDoubleJump())
end

function canReachAquariaChildrenOrb()
    return (canReachAquariaRoomThree() and has("setting_trick_logic_at_royal_children_oob")) or (hasSwim() and hasAquariaSub())
end

function canReachAquariaSpiritParticles()
    return hasSwim() and hasAquariaSub()
end

function canReachSunnyMiddleRoom()
    return hasSwim() or has("setting_trick_logic_sb_first_turtle")
end

function canReachSunnyMiddleLadders()
    return canReachSunnyMiddleRoom() and (hasClimb() or (has("setting_trick_logic_sb_double_jump_ladder_skip") and hasDoubleJump()) or has("setting_trick_logic_sb_nothing_ladder_skip"))
end

function canReachSunnyFinalArea()
    return hasSwim() or has("setting_trick_logic_sb_first_turtle")
end

function canReachSunnyTurtleSoup()
    return has("setting_trick_logic_sb_first_turtle") or (hasSwim() and (hasClimb() or has("setting_trick_logic_sb_final_turtle")))
end

function canReachMetroPlatform()
    return canReachMetro() or (has("setting_trick_logic_ap_zephyr_double_jump") and hasDoubleJump())
end

function canReachAutumnWall()
    return canReachMetro() or (has("setting_trick_logic_ap_zephyr_double_jump") and hasDoubleJump())
end

function canReachAutumnShadySection()
    return canPassAutumnDoor() and hasSOPortal()
end

function canReachCrystalBridge()
    return hasCGBridge() or (has("setting_trick_logic_crystal_bridge_double_jump") and hasDoubleJump()) or has("setting_trick_logic_crystal_bridge_snowball_proxy")
end

function canReachZephyrLadder()
    return hasClimb() or (has("setting_trick_logic_zephyr_ladder_double_jump") and hasDoubleJump())
end

function canReachShadyHippos()
    return hasHeadbash() or ((not has("setting_shady_require_headbash")) and hasPermanentFireball())
end

function canPassMagmaStart()
    return hasClimb() or (has("setting_trick_logic_mc_start_double_jump") and hasDoubleJump()) or has("setting_trick_logic_mc_start_nothing")
end

function canReachMagmaSecondLevel()
    return canPassMagmaStart() and (hasClimb() or (has("setting_trick_logic_mc_second_level_double_jump") and hasDoubleJump()))
end

function canReachMagmaPopcorn()
    return canPassMagmaStart() and (hasClimb() or (has("setting_trick_logic_mc_popcorn_double_jump") and hasDoubleJump()))
end

function canReachMagmaMoneybags()
    return canReachMagmaSecondLevel() and (hasClimb() or (has("setting_trick_logic_mc_moneybags_double_jump") and hasDoubleJump()))
end

function canPassMagmaElevator()
    return canReachMagmaMoneybags() and (hasMCElevator() or (has("setting_trick_logic_mc_elevator_double_jump") and hasDoubleJump()))
end

function canReachMagmaTalisman()
    return (canPassMagmaElevator() and hasClimb()) or (canReachMagmaMoneybags() and (has("setting_trick_logic_mc_elevator_double_jump") and hasDoubleJump()))
end

function canReachMagmaPartyCrashers()
    return canReachMagmaTalisman()
end

function canReachMagmaFireballBalloons()
    return canReachMagmaPartyCrashers() or (canPassMagmaElevator() and hasPermanentFireball())
end

function canReachFractureSupercharge()
    return true
end

function canReachFractureFaun()
    return true
end

function canReachFractureHunter()
    return hasHeadbash() or ((not has("setting_fracture_require_headbash")) and hasPermanentFireball())
end

function canReachFractureEnemies()
    return has("setting_fracture_easy_earthshapers") or hasPermanentFireball() or canReachFractureHunter()
end

function canReachWinterWaterfall()
    return canReachWinterSecondHalf() and (hasSwim() or (has("setting_trick_logic_wt_oob_double_jump") and hasDoubleJump()) or has("setting_trick_logic_wt_oob_nothing"))
end

function canPassMetropolisElevator()
    return hasHeadbash() or hasPermanentFireball()
end

function canReachMetropolisOx()
    return canPassMetropolisElevator() and (hasClimb() or has("setting_trick_logic_metropolis_ox_superfly"))
end

--Level Rules
function canSatisfyLevelLock(levelCode)
    if hasLevelLocks() and (not has(levelCode)) then
        return false
    end
    return true
end

function hasIdolSpringsAccess()
    return canSatisfyLevelLock("idol_springs_unlock")
end

function hasColossusAccess()
    return canSatisfyLevelLock("colossus_unlock")
end

function hasHurricosAccess()
    return canReachSummerSecondHalf() and canSatisfyLevelLock("hurricos_unlock")
end

function hasAquariaTowersAccess()
    return hasAquariaWall() and canSatisfyLevelLock("aquaria_towers_unlock")
end

function hasSunnyBeachAccess()
    return canReachSummerSecondHalf() and canSatisfyLevelLock("sunny_beach_unlock")
end

function hasOceanSpeedwayAccess()
    return (has_at_least("orb",3) or (has("setting_trick_logic_sf_swim_in_air") and hasSwim())) and canReachSummerSecondHalf() and canSatisfyLevelLock("ocean_speedway_unlock")
end

function hasCrushAccess()
    return canReachSummerSecondHalf() and (hasOpenWorld() or has_at_least("summer_talisman",6))
end

function hasAutumnPlainsAccess()
    return (hasOpenWorld() and hasOpenAbilityAndWarps()) or hasCrushDefeated()
end

function hasSkelosBadlandsAccess()
    return hasAutumnPlainsAccess() and canSatisfyLevelLock("skelos_badlands_unlock")
end

function hasCrystalGlacierAccess()
    return hasAutumnPlainsAccess() and canSatisfyLevelLock("crystal_glacier_unlock")
end

function hasBreezeHarborAccess()
    return hasAutumnPlainsAccess() and canSatisfyLevelLock("breeze_harbor_unlock")
end

function hasZephyrAccess()
    return hasAutumnPlainsAccess() and hasZPortal() and canSatisfyLevelLock("zephyr_unlock")
end

function hasMetroSpeedwayAccess()
    return hasAutumnPlainsAccess() and canReachMetro() and canSatisfyLevelLock("metro_speedway_unlock")
end

function hasScorchAccess()
    return hasAutumnPlainsAccess() and canReachAutumnSecondHalf() and canSatisfyLevelLock("scorch_unlock")
end

function hasShadyOasisAccess()
    return hasAutumnPlainsAccess() and canReachAutumnShadySection() and canSatisfyLevelLock("shady_oasis_unlock")
end

function hasMagmaConeAccess()
    return hasAutumnPlainsAccess() and canPassAutumnDoor() and canSatisfyLevelLock("magma_cone_unlock")
end

function hasFractureHillsAccess()
    return hasAutumnPlainsAccess() and canReachAutumnSecondHalf() and canSatisfyLevelLock("fracture_hills_unlock")
end

function hasIcySpeedwayAccess()
    return hasAutumnPlainsAccess() and canPassAutumnDoor() and hasISPortal() and canSatisfyLevelLock("icy_speedway_unlock")
end

function hasGulpAccess()
    return hasAutumnPlainsAccess() and canPassAutumnDoor() and (hasOpenWorld() or (has_at_least("summer_talisman",6) and has_at_least("autumn_talisman",8)))
end

function hasWinterTundraAccess()
    return (hasOpenWorld() and hasOpenAbilityAndWarps()) or hasGulpDefeated()
end

function hasMysticMarshAccess()
    return hasWinterTundraAccess() and canSatisfyLevelLock("mystic_marsh_unlock")
end

function hasCloudTemplesAccess()
    return (hasWinterTundraAccess() and canSatisfyLevelLock("cloud_temples_unlock")) and (has_at_least("orb",15) or (canReachWinterSecondHalf() and (((has("setting_trick_logic_wt_oob_double_jump") and hasDoubleJump()) or has("setting_trick_logic_wt_oob_nothing")) and ((has("setting_trick_logic_wt_swim_from_oob") and hasSwim()) or has("setting_trick_logic_wt_glide_from_oob")))))
end

function hasCanyonSpeedwayAccess()
    return (hasWinterTundraAccess() and canSatisfyLevelLock("canyon_speedway_unlock")) and (hasCSPortal() or (canReachWinterSecondHalf() and ((has("setting_trick_logic_wt_oob_double_jump") and hasDoubleJump()) or has("setting_trick_logic_wt_oob_nothing")) and (((has("setting_trick_logic_wt_swim_from_oob") and hasSwim()) or has("setting_trick_logic_wt_glide_from_oob")))))
end

function hasRoboticaFarmsAccess()
    return hasWinterTundraAccess() and canReachWinterSecondHalf() and canSatisfyLevelLock("robotica_farms_unlock")
end

function hasMetropolisAccess()
    return (hasWinterTundraAccess() and canSatisfyLevelLock("metropolis_unlock")) and (canReachWinterSecondHalf() and (has_at_least("orb",25) or (has("setting_trick_logic_wt_oob_double_jump") and hasDoubleJump() or has("setting_trick_logic_wt_oob_nothing")) and (has("setting_trick_logic_wt_swim_from_oob") and hasSwim() or has("setting_trick_logic_wt_glide_from_oob"))))
end

function hasRiptoAccess()
    return hasWinterTundraAccess() and canReachRiptoDoor()
end

function hasDragonShoresAccess()
    --The only checks in dragon shores also require 55 orbs and 8000 gems
    if (not has_at_least("orb",55)) or (not canReachTotalGemCount(8000)) then
        return false
    end
    return hasWinterTundraAccess() and (hasRiptoDefeated() or (canSatisfyLevelLock("aquaria_towers_unlock") and canReachWinterSecondHalf() and ((has("setting_trick_logic_wt_oob_double_jump") and hasDoubleJump() or has("setting_trick_logic_wt_oob_nothing")) and (has("setting_trick_logic_wt_swim_from_oob") and hasSwim() or has("setting_trick_logic_wt_glide_from_oob")))))
end

function reachableGemCountSummerForest()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        reachable_gems = 155
        if canReachSFSecretLedge() then
            reachable_gems = reachable_gems + 9
        end
        if hasSwim() then
            reachable_gems = reachable_gems + 42
        end
        if canReachSummerSecondHalf() then
            reachable_gems = reachable_gems + 170
        end
        if canReachSFLadder() then
            reachable_gems = reachable_gems + 10
        end
        if hasAquariaWall() then
            reachable_gems = reachable_gems + 14
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_summ")
    end
    return reachable_gems
end

function reachableGemCountGlimmer()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        reachable_gems = 353
        if canReachGlimmerIndoorLamps() then
            reachable_gems = reachable_gems + 47
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_glim")
    end
    return reachable_gems
end

function reachableGemCountIdolSprings()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasIdolSpringsAccess() then
            return 0
        end
        reachable_gems = 298
        if hasSwim() then
            reachable_gems = reachable_gems + 102
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_idol")
    end
    return reachable_gems
end

function reachableGemCountColossus()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasColossusAccess() then
            return 0
        end
        reachable_gems = 400
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_colo")
    end
    return reachable_gems
end

function reachableGemCountHurricos()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasHurricosAccess() then
            return 0
        end
        reachable_gems = 400
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_hurr")
    end
    return reachable_gems
end

function reachableGemCountAquariaTowers()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasAquariaTowersAccess() then
            return 0
        end
        reachable_gems = 35
        if canReachAquariaFirstTunnel() then
            reachable_gems = reachable_gems + 19
        end
        if canReachAquariaRoomTwoBottom() then
            reachable_gems = reachable_gems + 21
        end
        if canReachAquariaRoomTwoCrabPit() then
            reachable_gems = reachable_gems + 27
        end
        if canReachAquariaRoomTwoSharkPit() then
            reachable_gems = reachable_gems + 25
        end
        if canReachAquariaRoomTwoMiddle() then
            reachable_gems = reachable_gems + 13
        end
        if canReachAquariaRoomTwoTop() then
            reachable_gems = reachable_gems + 22
        end
        if canReachAquariaRoomThree() then
            reachable_gems = reachable_gems + 56
        end
        if canReachAquariaTalismanAreaGems() then
            reachable_gems = reachable_gems + 17
        end
        if canReachAquariaSharkTunnel() then
            reachable_gems = reachable_gems + 40
        end
        if canReachAquariaRoomThree() then
            reachable_gems = reachable_gems + 125
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_aqua")
    end
    return reachable_gems
end

function reachableGemCountSunnyBeach()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasSunnyBeachAccess() then
            return 0
        end
        reachable_gems = 86
        if (canReachSunnyTurtleSoup() and hasSwim()) then
            reachable_gems = reachable_gems + 10
        end
        if canReachSunnyMiddleRoom() then
            reachable_gems = reachable_gems + 184
        end
        if canReachSunnyMiddleLadders() then
            reachable_gems = reachable_gems + 10
        end
        if canReachSunnyFinalArea() then
            reachable_gems = reachable_gems + 21
        end
        if hasSwim() then
            reachable_gems = reachable_gems + 89
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_sunn")
    end
    --print("DEBUG- Sunny Beach reachable gems: " .. tostring(reachable_gems))
    return reachable_gems
end

function reachableGemCountOceanSpeedway()
    local reachable_gems = 0
    if not hasOceanSpeedwayAccess() then
        return 0
    -- elseif has("setting_enable_gemsanity_off") then
    --     reachable_gems = 400
    else
        reachable_gems = 400 --Tracker:ProviderCountForCode("inventory_gems_ocea")
    end
    return reachable_gems
end

function reachableGemCountAutumnPlains()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasAutumnPlainsAccess() then
            return 0
        end
        reachable_gems = 105
        if canReachMetroPlatform() then
            reachable_gems = reachable_gems + 2
        end
        if hasSwim() then
            reachable_gems = reachable_gems + 13
        end
        if canReachAutumnWall() then
            reachable_gems = reachable_gems + 20
        end
        if canReachAutumnSecondHalf() then
            reachable_gems = reachable_gems + 51
        end
        if canPassAutumnDoor() then
            reachable_gems = reachable_gems + 202
        end
        if canReachAutumnShadySection() then
            reachable_gems = reachable_gems + 7
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_autu")
    end
    return reachable_gems
end

function reachableGemCountSkelosBadlands()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasSkelosBadlandsAccess() then
            return 0
        end
        reachable_gems = 400
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_skel")
    end
    return reachable_gems
end

function reachableGemCountCrystalGlacier()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasCrystalGlacierAccess() then
            return 0
        end
        reachable_gems = 245
        if canReachCrystalBridge() then
            reachable_gems = reachable_gems + 155
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_crys")
    end
    return reachable_gems
end

function reachableGemCountBreezeHarbor()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasBreezeHarborAccess() then
            return 0
        end
        reachable_gems = 391
        if hasSwim() then
            reachable_gems = reachable_gems + 9
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_bree")
    end
    return reachable_gems
end

function reachableGemCountZephyr()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasZephyrAccess() then
            return 0
        end
        reachable_gems = 284
        if canReachZephyrLadder() then
            reachable_gems = reachable_gems + 116
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_zeph")
    end
    return reachable_gems
end

function reachableGemCountMetroSpeedway()
    local reachable_gems = 0
    if not hasMetroSpeedwayAccess() then
        return 0
    -- elseif has("setting_enable_gemsanity_off") then
    --     reachable_gems = 400
    else
        reachable_gems = 400 --Tracker:ProviderCountForCode("inventory_gems_mesp")
    end
    return reachable_gems
end

function reachableGemCountScorch()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasScorchAccess() then
            return 0
        end
        reachable_gems = 400
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_scor")
    end
    return reachable_gems
end

function reachableGemCountShadyOasis()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasShadyOasisAccess() then
            return 0
        end
        reachable_gems = 380
        if canBreakCrates() then
            reachable_gems = reachable_gems + 20
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_shad")
    end
    return reachable_gems
end

function reachableGemCountMagmaCone()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasMagmaConeAccess() then
            return 0
        end
        reachable_gems = 14
        if canPassMagmaStart() then
            reachable_gems = reachable_gems + 60
        end
        if canReachMagmaSecondLevel() then
            reachable_gems = reachable_gems + 163
        end
        if canReachMagmaPopcorn() then
            reachable_gems = reachable_gems + 47
        end
        if canReachMagmaMoneybags() then
            reachable_gems = reachable_gems + 11
        end
        if canPassMagmaElevator() then
            reachable_gems = reachable_gems + 50
        end
        if canReachMagmaTalisman() then
            reachable_gems = reachable_gems + 35
        end
        if canReachMagmaFireballBalloons() then
            reachable_gems = reachable_gems + 20
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_magm")
    end
    return reachable_gems
end

function reachableGemCountFractureHills()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasFractureHillsAccess() then
            return 0
        end
        reachable_gems = 400
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_frac")
    end
    return reachable_gems
end

function reachableGemCountIcySpeedway()
    local reachable_gems = 0
    if not hasIcySpeedwayAccess() then
        return 0
    -- elseif has("setting_enable_gemsanity_off") then
    --     reachable_gems = 400
    else
        reachable_gems = 400 --Tracker:ProviderCountForCode("inventory_gems_icys")
    end
    return reachable_gems
end

function reachableGemCountWinterTundra()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasWinterTundraAccess() then
            return 0
        end
        reachable_gems = 139
        if canBreakCrates() then
            reachable_gems = reachable_gems + 35
        end
        if hasHeadbash() then
            reachable_gems = reachable_gems + 11
        end
        if canReachWinterSecondHalf() then
            reachable_gems = reachable_gems + 208
        end
        if canReachRiptoDoor() then
            reachable_gems = reachable_gems + 7
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_wint")
    end
    return reachable_gems
end

function reachableGemCountMysticMarsh()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasMysticMarshAccess() then
            return 0
        end
        reachable_gems = 312
        if hasSwim() then
            reachable_gems = reachable_gems + 88
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_myst")
    end
    return reachable_gems
end

function reachableGemCountCloudTemples()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasCloudTemplesAccess() then
            return 0
        end
        reachable_gems = 375
        if canBreakCrates() then
            reachable_gems = reachable_gems + 25
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_clou")
    end
    return reachable_gems
end

function reachableGemCountCanyonSpeedway()
    local reachable_gems = 0
    if not hasCanyonSpeedwayAccess() then
        return 0
    -- elseif has("setting_enable_gemsanity_off") then
    --     reachable_gems = 400
    else
        reachable_gems = 400 --Tracker:ProviderCountForCode("inventory_gems_cany")
    end
    return reachable_gems
end

function reachableGemCountRoboticaFarms()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasRoboticaFarmsAccess() then
            return 0
        end
        reachable_gems = 400
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_robo")
    end
    return reachable_gems
end

function reachableGemCountMetropolis()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasMetropolisAccess() then
            return 0
        end
        reachable_gems = 24
        if canReachMetropolisOx() then
            reachable_gems = reachable_gems + 15
        end
        if canPassMetropolisElevator() then
            reachable_gems = reachable_gems + 361
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_metr")
    end
    return reachable_gems
end

function canReachGemCount(area, amount)
    local reachable_gems = 0
    if area == "summer_forest" then
        reachable_gems = reachableGemCountSummerForest()
    elseif area == "glimmer" then
        reachable_gems = reachableGemCountGlimmer()
    elseif area == "idol_springs" then
        reachable_gems = reachableGemCountIdolSprings()
    elseif area == "colossus" then
        reachable_gems = reachableGemCountColossus()
    elseif area == "hurricos" then
        reachable_gems = reachableGemCountHurricos()
    elseif area == "aquaria_towers" then
        reachable_gems = reachableGemCountAquariaTowers()
    elseif area == "sunny_beach" then
        reachable_gems = reachableGemCountSunnyBeach()
    elseif area == "ocean_speedway" then
        reachable_gems = reachableGemCountOceanSpeedway()
    elseif area == "autumn_plains" then
        reachable_gems = reachableGemCountAutumnPlains()
    elseif area == "skelos_badlands" then
        reachable_gems = reachableGemCountSkelosBadlands()
    elseif area == "crystal_glacier" then
        reachable_gems = reachableGemCountCrystalGlacier()
    elseif area == "breeze_harbor" then
        reachable_gems = reachableGemCountBreezeHarbor()
    elseif area == "zephyr" then
        reachable_gems = reachableGemCountZephyr()
    elseif area == "metro_speedway" then
        reachable_gems = reachableGemCountMetroSpeedway()
    elseif area == "scorch" then
        reachable_gems = reachableGemCountScorch()
    elseif area == "shady_oasis" then
        reachable_gems = reachableGemCountShadyOasis()
    elseif area == "magma_cone" then
        reachable_gems = reachableGemCountMagmaCone()
    elseif area == "fracture_hills" then
        reachable_gems = reachableGemCountFractureHills()
    elseif area == "icy_speedway" then
        reachable_gems = reachableGemCountIcySpeedway()
    elseif area == "winter_tundra" then
        reachable_gems = reachableGemCountWinterTundra()
    elseif area == "mystic_marsh" then
        reachable_gems = reachableGemCountMysticMarsh()
    elseif area == "cloud_temples" then
        reachable_gems = reachableGemCountCloudTemples()
    elseif area == "canyon_speedway" then
        reachable_gems = reachableGemCountCanyonSpeedway()
    elseif area == "robotica_farms" then
        reachable_gems = reachableGemCountRoboticaFarms()
    elseif area == "metropolis" then
        reachable_gems = reachableGemCountMetropolis()
    end

    if reachable_gems >= tonumber(amount) then
        return true
    else
        return false
    end
end

function canReachTotalGemCount(amount)
    local reachable_gems = 0
    reachable_gems = reachable_gems + reachableGemCountSummerForest()
    reachable_gems = reachable_gems + reachableGemCountGlimmer()
    reachable_gems = reachable_gems + reachableGemCountIdolSprings()
    reachable_gems = reachable_gems + reachableGemCountColossus()
    reachable_gems = reachable_gems + reachableGemCountHurricos()
    reachable_gems = reachable_gems + reachableGemCountAquariaTowers()
    reachable_gems = reachable_gems + reachableGemCountSunnyBeach()
    reachable_gems = reachable_gems + reachableGemCountOceanSpeedway()
    reachable_gems = reachable_gems + reachableGemCountAutumnPlains()
    reachable_gems = reachable_gems + reachableGemCountSkelosBadlands()
    reachable_gems = reachable_gems + reachableGemCountCrystalGlacier()
    reachable_gems = reachable_gems + reachableGemCountBreezeHarbor()
    reachable_gems = reachable_gems + reachableGemCountZephyr()
    reachable_gems = reachable_gems + reachableGemCountMetroSpeedway()
    reachable_gems = reachable_gems + reachableGemCountScorch()
    reachable_gems = reachable_gems + reachableGemCountShadyOasis()
    reachable_gems = reachable_gems + reachableGemCountMagmaCone()
    reachable_gems = reachable_gems + reachableGemCountFractureHills()
    reachable_gems = reachable_gems + reachableGemCountIcySpeedway()
    reachable_gems = reachable_gems + reachableGemCountWinterTundra()
    reachable_gems = reachable_gems + reachableGemCountMysticMarsh()
    reachable_gems = reachable_gems + reachableGemCountCloudTemples()
    reachable_gems = reachable_gems + reachableGemCountCanyonSpeedway()
    reachable_gems = reachable_gems + reachableGemCountRoboticaFarms()
    reachable_gems = reachable_gems + reachableGemCountMetropolis()

    if reachable_gems >= tonumber(amount) then
        return true
    else
        return false
    end
end