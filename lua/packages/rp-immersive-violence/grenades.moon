import THING from install 'packages/rp-immersive'
class PinPull extends SOUND
    sound: 'snd_jack_pinpull.wav'

class SpoonFly extends SOUND
    sound: 'snd_jack_spoonfling.wav'

class SpoonBounce extends SOUND
    sound: 'snd_jack_spoonbounce.wav'

class GRENADE extends THING
    Model: Model 'models/jmod/explosives/grenades/sticknade/stick_grenade.mdl'
    PrimeSound: 'PinPull'
    SetupDataTables: =>
        super!
        @AddNetworkVar 'Bool', 'Primed'
        @AddNetworkVar 'Bool', 'Armed'
    Radius: 250
    Damage: 175
    Operate: (ply) => unless @GetPrimed! then @Prime! else @Arm!
    Prime: =>
        unless @GetPrimed!
            @EmitSound @PrimeSound
            @SetPrimed true
            true
    Arm: =>
        unless @GetArmed! or not @GetPrimed!
            @EmitSound 'SpoonFly'
            @SetArmed true
            true
    Think: =>
        super!
        return if CLIENT
        unless @GetArmed! or IsValid @GetHolder!
            @Arm! if @GetPrimed! 
    Detonate: =>
        pos = @WorldSpaceCenter!
        util.ScreenShake pos, 25, 150, 1, @Radius
        with ents.Create 'env_explosion'
            \SetOwner @GetOwner!
            \SetPos pos
            \SetKeyValue 'iMagnitude', @Damage
            \SetKeyValue 'iRadiusOverride', @Radius
            \Spawn!
            \Activate!
            \Fire 'Explode'
        @Remove!

class Timed extends GRENADE
    HandOffset:
        Pos: Vector 1.98, -0.32, 2.47
        Ang: Angle!
    Arm: => 
        if super!
            timer.Simple 4, -> @Detonate! if IsValid @ 

class Impact extends GRENADE
    Model: Model 'models/jmod/explosives/grenades/impactnade/impact_grenade.mdl'
    PrimeSound: 'SpoonFly'
    ImpactThreshold: 256
    Prime: => @Arm! and @SetBodygroup 2, 1 if super!
    PhysicsCollide: (data) =>
        super data
        if @GetArmed!
            @Detonate! if data.Speed > @ImpactThreshold

{
    :Timed
    :Impact
}