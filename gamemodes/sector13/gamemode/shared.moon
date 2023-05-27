GM.Name     = 'Sector 13'
GM.Author   = 'Sotla'

assert istable(gpm), [[
    A package manager is required to continue loading the gamemode.
    GitHub: https://github.com/Pika-Software/glua-package-manager
]]

GM.Config or= {}
GM.Logger = gpm.logger.Create 'Sector 13', Color 0, 255, 128

gpm.Import('packages/rp-immersive', true)\Then (pkg) -> 
    if CLIENT
        import UPLINK_READY from pkg.environment
        UPLINK_READY\SendToServer! 
    
gpm.Import('packages/eclipse-dev', true)

GM.DoPlayerDeath = (ply, attacker, dmg) => ply\CreateRagdoll! unless IsValid ply\GetRagdollEntity!