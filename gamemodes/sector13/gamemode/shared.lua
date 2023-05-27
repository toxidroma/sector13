GM.Name = 'Sector 13'
GM.Author = 'Sotla'
assert(istable(gpm), [[    A package manager is required to continue loading the gamemode.
    GitHub: https://github.com/Pika-Software/glua-package-manager
]])
GM.Config = GM.Config or { }
GM.Logger = gpm.logger.Create('Sector 13', Color(0, 255, 128))
return gpm.Import('packages/rp-immersive', true):Then(function(pkg)
  if CLIENT then
    local UPLINK_READY
    UPLINK_READY = pkg.environment.UPLINK_READY
    UPLINK_READY:SendToServer()
  end
  if SERVER then
    AddCSLuaFile('bots.lua')
  end
  return include('bots.lua')
end)
