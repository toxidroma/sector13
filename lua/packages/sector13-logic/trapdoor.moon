import random from math
hook.Add 'OnMapLogicInitialized', _PKG\GetIdentifier'trapdoor', (controller, mapName) ->
    return unless mapName == 'trapdoor'
    door = controller\GetMetaTarget 'trapdoor_door'
    with controller\GetMetaTarget 'trapdoor_trigger'
        .OnTrigger = (ent, activator) ->
            ent.risk or= 0
            ent.waitUntil or= 0
            return unless CurTime! > ent.waitUntil
            if random(100) <= ent.risk
                ent.risk = 0
                ent.waitUntil = CurTime! + 3
                ent\EmitSound'ambient/alarms/klaxon1.wav'
                timer.Simple .666, -> 
                    door\Fire'Open'
                    door\EmitSound 'doors/door_metal_thin_open1.wav', 75, random 87, 103
                    timer.Simple 1, -> 
                        door\Fire'Close'
                        timer.Simple .42, -> door\EmitSound 'doors/door_metal_thin_close2.wav', 75, random 87, 103
            else
                ent.risk += random 5
                ent\EmitSound 'ambient/alarms/warningbell1.wav', 75, 87 + ent.risk
    return
return