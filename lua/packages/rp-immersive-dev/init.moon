install 'rp-immersive', 'https://github.com/toxidroma/rp-immersive'
install 'luna', 'https://github.com/toxidroma/luna' if CLIENT
include'bots.lua'
if CLIENT
    include'tweaker.lua'
    concommand.Add 'tweak', (ply) -> 
        return unless CLIENT
        if ply\Wielding! and IsValid ply\Wielding!
            with Tweaker!
                \Center!

{
    :Tweaker
}