import Holdtypes from install 'packages/rp-immersive'

hook.Add 'PreLoadAnimations', 'sequence harvest', ->
    IncludeModel mdl for mdl in *{
        'models/dysphoria/anims/zps_surv.mdl'
    }
    
class Pipe extends THING
    Model: Model 'models/props_canal/mattpipe.mdl'
    Animations: 
        attack: Holdtypes.swinging
        prime: Holdtypes.something
        throw: Holdtypes.throwing
    HandOffset:
        Pos: Vector 0, 0, 8
        Ang: Angle 0, 0, 180
    Attack:
        Enabled: true
        Offset: Vector 0, 0, -16
        Damage: 23
        DamageType: DMG_CLUB
        Delay: {.19, .62}
        Force: 50
        ImpactSound: 'Weapon_Melee_Blunt.Impact_Heavy'
        WhooshSound: 'Weapon_Melee.PipeLeadLight'

{
    :Pipe
}