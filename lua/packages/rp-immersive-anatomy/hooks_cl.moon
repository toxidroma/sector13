import abs, min, max from math

HURTS = 0
hook.Add 'player_hurt', 'OWWW', (data) ->
    lp = LocalPlayer!        
    return unless data.userid == lp\UserID!
    lp.previousHealth or= lp\GetMaxHealth!
    diff = abs data.health - lp.previousHealth
    lp.previousHealth = data.health

    HURTS += diff*.0666
    HURTS = max HURTS, 6.66

hook.Add 'RenderScreenspaceEffects', 'OWWW', ->
    DrawSharpen 1, min 6, HURTS if HURTS > 0
    HURTS = Lerp FrameTime!*.666, HURTS, 0