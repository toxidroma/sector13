GM.Name = 'eclipse'
GM.Author = 'Toxidroma'
GM.Email = 'toxidroma@lacks.email'
GM.Website = 'https://github.com/toxidroma'
if not (GM.Config) then
  GM.Config = { }
end
if not (GM.Logger) then
  --GM.Logger = gpm.Logger.Create('ECLIPSE'), Color(0, 255, 128)
end
GM.Initialize = function(self) end
GM.CanProperty = function(self, pl, property, ent) return pl:IsSuperAdmin() end 
assert(istable(gpm), 'eclipse will not function at all without the gLua Package Manager.\nGet it here: https://github.com/Pika-Software/glua-package-manager')
gpm.Import('packages/rp-immersive', true):Then(function(pkg)
  if CLIENT then
    local UPLINK_READY
    UPLINK_READY = pkg.Environment.UPLINK_READY
    return UPLINK_READY:SendToServer()
  end
end)
gpm.Import('packages/rp-immersive-dev', true)
gpm.Import('packages/rp-immersive-violence', true)