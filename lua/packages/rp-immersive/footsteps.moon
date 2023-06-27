import Clamp, Rand from math
import insert from table
import GetSurfacePropName, JSONToTable, TableToJSON, TraceLine, PointContents from util

hook.Add 'PlayerFootstep', 'fuck default footsteps', (ply, pos, foot, sound, volume, rf) -> true if ply\OnGround! and ply\GetMoveType! == MOVETYPE_WALK
hook.Add 'PlayerStepSoundTime', 'fuck default footsteps', (ply, type, walking) -> 9999 if ply\OnGround! and ply\GetMoveType! == MOVETYPE_WALK

return unless CLIENT

--https://github.com/PAC3-Server/notagain/blob/master/lua/notagain/essential/autorun/realistic_footsteps.lua
sounds = JSONToTable file.Read('rp-immersive-footsteps.txt', 'DATA') or ''
sounds or= {}
unless next sounds
    for _, name in pairs sound.GetTable!
        if name\EndsWith'StepLeft' or name\EndsWith'StepRight'
            data = sound.GetProperties name
            data.sound = {data.sound} if isstring data.sound
            friendly = name\match("(.+)%.")\lower!
            sounds[friendly] or= {
                sounds: {}
                done: {}
                pitch: data.pitch
                level: data.level
                volume: data.volume
            }
            for path in *data.sound
                path = path\lower!
                unless sounds[friendly].done[path]
                    insert sounds[friendly].sounds, path
                    sounds[friendly].done[path] = true
    file.Write 'rp-immersive-footsteps.txt', TableToJSON sounds

feet = {'left', 'right'}
hook.Add 'Think', 'fuck default footsteps', ->
    for ply in *player.GetAll!
        continue unless ply\GetMoveType! == MOVETYPE_WALK and ply\OnGround!
        continue if ply\GetVelocity!\IsZero!
        with ply
            for foot in *feet
                .realistic_footsteps or= {}
                .realistic_footsteps[foot] or= {}
                \SetupBones!
                id = \LookupBone foot == 'right' and 'valvebiped.bip01_r_foot' or 'valvebiped.bip01_l_foot'
                continue unless id
                m = \GetBoneMatrix id
                continue unless m
                scale = \GetModelScale! or 1
                pos = m\GetTranslation!
                vel = (.realistic_footsteps[foot].last_pos or pos) - pos
                .realistic_footsteps[foot].smooth_vel or= vel
                .realistic_footsteps[foot].smooth_vel = .realistic_footsteps[foot].smooth_vel + ((vel - .realistic_footsteps[foot].smooth_vel) * Clamp FrameTime!*5, .0001, 1)
                --hack to prevent crazy velocities
                do
                    l = .realistic_footsteps[foot].smooth_vel\Length!
                    .realistic_footsteps[foot].smooth_vel\Zero! if l + 0 != l
                dir = Vector 0, 0, -50
                trace = TraceLine
                    start: pos - dir*.25
                    endpos: pos + dir
                    filter: ply
                trace.Hit = false if trace.HitTexture == 'TOOLS/TOOLSNODRAW' or trace.HitTexture == '**empty**'
                --if dir is -50 this is required to check if the foot is actually above player pos
                trace.Hit = false if pos.z - \GetPos!.z > scale*7.5
                volume = Clamp vel\Length2D!/20, 0, 1
                trace.Hit = false if volume == 0
                trace.Hit = false if .realistic_footsteps[foot].hit and .realistic_footsteps[foot].hit > CurTime!
                if trace.Hit
                    .realistic_footsteps[foot].hit = CurTime! + .25
                    local data
                    if bit.band(PointContents(trace.HitPos), CONTENTS_WATER) == CONTENTS_WATER
                        data = sounds.water
                    elseif trace.SurfaceProps != -1
                        name = GetSurfacePropName trace.SurfaceProps
                        data = sounds[name]
                        unless data
                            for k,v in pairs sounds
                                if k\find name
                                    data = v
                                    break
                        data = sounds.default unless data
                    
                    if data
                        if .realistic_footsteps_last_foot != foot and (not .realistic_footsteps[foot].next_play or .realistic_footsteps[foot].next_play < RealTime!)
                            mute = false
                            path = table.Random data.sounds
                            for name, func in pairs hook.GetTable().PlayerFootstep
                                unless name == _PKG\GetIdentifier'fuck default footsteps'
                                    ret = func ply, pos, path, volume
                                    if ret == true
                                        mute = true
                                        break
                            continue if mute
                            import pitch from data
                            pitch = Rand pitch[1], pitch[2] if istable pitch
                            EmitSound path, pos, \EntIndex!, CHAN_BODY, data.volume*volume, 60 or data.level, SND_NOFLAGS, Clamp (pitch/scale) + Rand(-10,10), 0, 255
                            .realistic_footsteps[foot].next_play = RealTime! + .1
                            .realistic_footsteps_last_foot = foot
                .realistic_footsteps[foot].last_pos = pos
--IMPLEMENT EXTRA SOUNDS AS FROM HERE:
    --https://github.com/PAC3-Server/notagain/blob/master/lua/notagain/essential/autorun/realistic_footsteps.lua#L290