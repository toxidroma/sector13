import Round from math
import upper, rep from string
import IsEmpty from table
import JSONToTable from util

concommand.Add 'puppetstrings', (ply, _, _, argstr) -> 
    return unless game.SinglePlayer! or not game.IsDedicated!
    data = JSONToTable file.Read "pac3/__animations/#{argstr}.txt", 'DATA'
    print"class #{argstr} extends #{upper data.Type}"
    print"#{' '\rep 4}Interpolation: INTERP_#{upper data.Interpolation}"
    print"#{' '\rep 4}Frames: {"
    for frame in *data.FrameData
        ease = "'#{frame.EaseStyle}'" if frame.EaseStyle
        ease or= 'nil'
        print"#{' '\rep 8}KEYFRAME #{frame.FrameRate}, #{ease}, {"
        for bone, datas in pairs frame.BoneInfo
            continue unless datas.MF != 0 or datas.MR != 0 or datas.MU != 0 or datas.RR != 0 or datas.RU != 0 or datas.RF != 0
            vecstr = "Vector(#{Round datas.MF, 3}, #{Round datas.MR, 3}, #{Round datas.MU, 3})" if datas.MF != 0 or datas.MR != 0 or datas.MU != 0
            angstr = "Angle(#{Round datas.RR, 3}, #{Round datas.RU, 3}, #{Round datas.MF, 3})" if datas.RR != 0 or datas.RU != 0 or datas.RF != 0
            vecstr or= "nil"
            angstr or= "nil"
            print"#{' '\rep 12}'#{bone}': BONE #{vecstr}, #{angstr}"
        print"#{' '\rep 8}}"
    print"#{' '\rep 4}}"