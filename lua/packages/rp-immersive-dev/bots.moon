import bor from bit
import NormalizeAngle, random from math
--thanks combinecontrol
hook.Add 'StartCommand', tostring(_PKG), (bot, cmd) ->
    return unless bot\IsBot!
    unless bot.AI
        bot.AI =
            Next: CurTime!
    with cmd
        \ClearButtons!
        \ClearMovement!
        \SetViewAngles bot\EyeAngles!
    unless bot\Alive!
        bot.AI.Respawn = CurTime! + 23 unless bot.AI.Respawn
        cmd\SetButtons IN_JUMP if CurTime! >= bot.AI.Respawn
        with bot.AI
            .Next = CurTime! + 15
            .Target = nil
        return
    with bot.AI
        if .Target and .Target\IsValid!
            unless .Target\Alive!
                .Target = nil
                .Next = CurTime! + 4
            if .Target\InVehicle! or .Target\GetNoDraw!
                .Target = nil
        else
            dist, closest = 400, nil
            for ply in *player.GetAll!
                continue if ply == bot
                if ply\Alive!
                    continue if ply\InVehicle! or ply\GetNoDraw!
                    if bot\CanSee ply
                        d = ply\GetPos!\Distance bot\GetPos!
                        if d < dist
                            dist = d
                            closest = ply
            if closest and closest\IsValid!
                .Target = closest
        return unless .Target and .Target\IsValid!
        eyeang = (.Target\EyePos! - bot\EyePos!)\GetNormal!\Angle!
        with eyeang
            .p = NormalizeAngle .p
            .y = NormalizeAngle .y
            .r = NormalizeAngle .r
        dist = bot\DistanceFrom .Target
        cmd\SetButtons bit.bor(cmd\GetButtons!, IN_SPEED) if dist > 400
        cmd\SetForwardMove bot\GetMaxSpeed! if dist > 100
        if CurTime! >= .Next
            if dist <= 50
                cmd\SetButtons bit.bor(cmd\GetButtons!, IN_JUMP)
                .Next = CurTime! + random(20, 60)
                return
            .Next = CurTime! + .1
        cmd\SetViewAngles eyeang
        bot\SetEyeAngles eyeang