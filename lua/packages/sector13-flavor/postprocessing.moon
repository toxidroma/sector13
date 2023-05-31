import sin, cos from math
hook.Add 'RenderScreenspaceEffects', _PKG\GetIdentifier'postprocessing', ->
    colormod = 
        "$pp_colour_addr": .01
        "$pp_colour_addg": -.01
        "$pp_colour_colour": .666
        "$pp_colour_brightness": 0
        "$pp_colour_contrast": 1.3 + .2323 * sin(CurTime!*.666)
    DrawColorModify colormod