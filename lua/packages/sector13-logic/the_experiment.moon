class ScannerProcess extends SOUND
    sound: 'dysphoria/ss_shield_idle.wav'
    pitch: {87, 113}

class ScannerPermit extends SOUND
    sound: ["dysphoria/ss_shield_clean#{i}.wav" for i=1,2]
    pitch: {87, 113}

class ScannerRefuse extends SOUND
    sound: 'dysphoria/ss_shield_filthy.wav'
    pitch: {87, 113}

hook.Add 'OnMapLogicInitialized', _PKG\GetIdentifier'the_experiment', (controller, mapName) ->
    return unless mapName == 'the_experiment'
    with controller\GetMetaTarget 'TriggerEyeDoor'
        door = controller\GetMetaTarget 'p_funcdoor1'
        .OnTrigger = (ent, activator) -> 
            switch activator\Health!
                when 100
                    ent\EmitSound'ScannerPermit'
                    door\Fire'Open'
                else
                    ent\EmitSound'ScannerRefuse'
    with controller\GetMetaTarget 'empty_butt3'
        train = controller\GetMetaTarget 'train_train'
        .OnPressed = (ent, activator) ->
            train\Fire'Toggle'
    return
return