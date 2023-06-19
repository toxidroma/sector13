class PipeBeatdown extends SOUND
    sound: "eclipse/weapons/metallic_beatdown#{i}.wav" for i=1,5

class Pipe extends THING
    Model: Model 'models/props_canal/mattpipe.mdl'
    HandOffset:
        Pos: Vector 3, -1.5, -10
        Ang: Angle!
    Attack:
        Enabled: true
        Offset: Vector 3, 0, -13
        Damage: 23
        DamageType: DMG_CLUB
        Delay: .666
        Force: 50
        Sound: 'PipeBeatdown'

{
    :Pipe
}