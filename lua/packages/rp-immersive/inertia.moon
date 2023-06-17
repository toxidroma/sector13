import Clamp from math
import InOutCubic from math.ease
import TraceLine from util
matspeeds =
    [MAT_DIRT]: .8
    [MAT_FLESH]: .8
    [MAT_SNOW]: .7
    [MAT_SAND]: .8
    [MAT_SLOSH]: .7
    [MAT_GRASS]: .9

hook.Add 'SetupPlayerDataTables', 'inertia', (classy) ->
    with classy
        \NetworkVar 'Float',   'SpeedTarget'
        \NetworkVar 'Float',   'SpeedLerp'
        \NetworkVar 'Float',   'CrouchSpeedTarget'
        \NetworkVar 'Float',   'CrouchSpeedLerp'
        \NetworkVar 'Float',   'SpeedLerpRate'
        \NetworkVar 'Float',   'OldZ'
        \NetworkVar 'Bool',    'Midair'
    return

hook.Add 'SetupMove', 'inertia', (ply, mv, cmd) ->
    with ply
        return if (not .GetMidair) or \StanceIs STANCE_PRONE
        cls = ply\ClassTable!
        ct = CurTime!
        if \OnGround! and \GetMidair!
            \SetMidair false
            \SetSpeedLerp \GetSpeedLerp! + \GetVelocity!\Length! / 3
        tr = TraceLine start: \GetPos!, endpos: (\GetPos! - Vector(0,0,20)), filter: (ent) -> ent\GetClass! == 'prop_physics'
        with mv
            \SetMaxClientSpeed ply\GetSpeedLerp!
            \SetMaxSpeed ply\GetSpeedLerp!
        \SetCrouchedWalkSpeed \GetCrouchSpeedLerp!
        \SetLadderClimbSpeed 100
        \SetRunSpeed cls.RunSpeed * 1.5
        unless \StanceIs STANCE_SQUAT
            onfoot = (\OnGround! or \WaterLevel! >= 1)
            advancing = cmd\GetForwardMove! > 0
            adventure = (cmd\GetSideMove! != 0) or (cmd\GetForwardMove! < 0)
            moving = (cmd\GetSideMove! != 0) and (cmd\GetForwardMove! != 0)
            careful = cmd\KeyDown IN_WALK
            if \IsSprinting! and advancing and onfoot
                \SetSpeedTarget cls.RunSpeed
                \SetSpeedLerpRate .005
            elseif not careful and advancing and onfoot
                \SetSpeedTarget cls.WalkSpeed
                \SetSpeedLerpRate .1
            elseif not careful and adventure and onfoot
                \SetSpeedTarget cls.WalkSpeed * .9
                \SetSpeedLerpRate .1
            elseif careful and onfoot and moving
                \SetSpeedTarget cls.SlowWalkSpeed
                \SetSpeedLerpRate .2
            else
                \SetSpeedTarget 30
                \SetSpeedLerpRate .023
        \SetSpeedLerp Lerp \GetSpeedLerpRate!, \GetSpeedLerp!, \GetSpeedTarget!   
        \SetMidair true unless \OnGround!
        if \GetSpeedLerp! > cls.RunSpeed/1.5 and not (\IsSprinting! and \KeyDown IN_FORWARD)
            mv\SetForwardSpeed \GetSpeedLerp!
    return
hook.Add 'PlayerStepSoundTime', 'inertia', (ply, type, walking) ->
    if cls = ply\ClassTable!
        speed = ply\GetVelocity!\Length!
        perc = speed / cls.WalkSpeed
        speed_new = Clamp(660 - (330 * perc * 0.75), 200, 1000)
        return speed_new