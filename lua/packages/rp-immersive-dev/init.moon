install 'packages/rp-immersive'
install 'luna', 'https://github.com/toxidroma/luna' if CLIENT
include'bots.lua'
if CLIENT
    include'tweaker.lua'
    concommand.Add 'tweak', (ply) -> 
        return unless CLIENT
        if ply\Wielding! and IsValid ply\Wielding!
            with Tweaker!
                \Center!

if SERVER
    concommand.Add 'gimme', (ply, _, _, argstr) -> 
        return unless game.SinglePlayer! or not game.IsDedicated!
        return unless argstr\StartsWith'thing/'
        ply\Wielding!\Remove! if IsValid ply\Wielding!
        ply\GiveItem argstr

include'puppetstrings.lua'

{
    :Tweaker
}