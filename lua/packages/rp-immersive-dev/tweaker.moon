import LFrame, LButton, LLabel, LNumSlider from luna
{
    Round: round
} = math
import insert from table
export class Tweaker extends LFrame
    Title: 'Tweaker'
    Width: 320
    Height: 200
    IsMenu: true

    new: (x, y) =>
        super x, y
        if @@instance
            @@instance\Remove! if IsValid @@instance
            @@instance = nil
        @@instance = @
        @item = LocalPlayer!\Wielding!
        @controls = {}
        for axis in *{'x', 'y', 'z'}
            with slider = LNumSlider!
                @Add slider
                \SetText axis
                \SetMinMax -23, 23
                \SetDecimals 2
                \SetValue @item.HandOffset.Pos[axis]
                .OnValueChanged = (val) => @GetParent!.item.HandOffset.Pos[axis] = val
                \DockMargin 48, 0, 0, 0
                insert @controls, slider
                \Dock TOP
                with slider.resetButton = LButton!
                    @Add slider.resetButton
                    .DoClick = => slider\SetValue 0
        with outputButton = LButton!
            @Add outputButton
            wide = @GetWide!/3
            \DockMargin wide, 0, wide, 10
            .DoClick = => 
                item = @GetParent!.item
                off = item.HandOffset.Pos
                vectxt = "Vector #{round off.x, 2}, #{round off.y, 2}, #{round off.z, 2}"
                SetClipboardText vectxt
                print item\GetModel!, "\n#{vectxt}"
            \Dock BOTTOM
        @MakePopup!
    Think: => 
        super!
        if @item
            if (not IsValid @item) or LocalPlayer!\Wielding! != @item
                print IsValid(@item), LocalPlayer!\Wielding == @item
                return @Remove!
    PerformLayout: =>
        super!
        for slider in *@controls
            slider\SetWide @GetWide!*4/15
            slider.resetButton\SetPos 16, slider\GetY!


hook.Add "PreDrawHalos", "tweaker", ->
    return unless IsValid vgui.GetHoveredPanel!
    ent = properties.GetHovered( EyePos!, gui.ScreenToVector gui.MousePos! )
    return unless IsValid ent
    c = Color( 255, 255, 255, 255 )
    c.r = 200 + math.sin( RealTime! * 50 ) * 55
    c.g = 200 + math.sin( RealTime! * 20 ) * 55
    c.b = 200 + math.cos( RealTime! * 60 ) * 55

    t = { ent }
    table.insert( t, ent\GetActiveWeapon! ) if ( ent.GetActiveWeapon and IsValid ent\GetActiveWeapon! ) 
    halo.Add( t, c, 2, 2, 2, true, false )