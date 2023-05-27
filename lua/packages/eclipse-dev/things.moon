class Unstable extends THING
    @SetupDataTables: =>
        super!
        @AddNetworkVar 'Bool', 'Armed'
    @ImpactThreshold: 256
    @Radius: 250
    @Damage: 175
    @Used: (ply) =>
        unless @GetArmed!
            @EmitSound 'Default.PullPin_Grenade'
            @SetArmed true
    @Detonate: =>
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
    @PhysicsCollide: (data) =>
        super data
        if @GetArmed!
            @Detonate! if data.Speed > @ImpactThreshold