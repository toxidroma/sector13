class Pipe extends THING
    Model: Model 'models/props_canal/mattpipe.mdl'
    OnPrimaryInteract: (tr, ply, hands) => ply\Spasm sequence: 'melee_1h_left', SS: true if ply\StateIs STATE.PRIMED