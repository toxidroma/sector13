import UPLINK from install 'packages/class-war'

import Clamp from math
import ReadString, WriteString,
    ReadVector, WriteVector from net
import insert from table

local INFO

class UPLINK_INFO extends UPLINK
    @Write: (txt, pos) =>
        WriteString txt
        WriteVector pos
    @Read: => ReadString!, ReadVector!
    @Callback: (ply, txt, pos) => 
        INFO txt,
            :pos

if CLIENT
    export class INFO
        @ACTIVE = {}
        new: (@text, data) =>
            @[k] = v for k, v in pairs data
            @font or= 'CloseCaption_Normal'
            @pos or= LocalPlayer!\GetEyeTrace!.HitPos
            @duration or= 6.66
            @deathTime or= CurTime! + @duration
            @color or= color_white
            @@ACTIVE[tostring @] = @
        Draw: =>
            ts = @pos\ToScreen!
            c = Color @color.r, @color.g, @color.b, Clamp((255/@duration) * (@deathTime - CurTime!), 0, 255)
            if c.a <= 0
                @@ACTIVE[tostring @] = nil
            else
                draw.SimpleText @text, @font, ts.x, ts.y, c

    hook.Add 'PostDrawHUD', 'draw info', -> v\Draw! for k, v in pairs INFO.ACTIVE
    
if SERVER
    export INFO = (ply, txt, pos) -> UPLINK_INFO\Send ply, txt, pos

{
    :INFO
}