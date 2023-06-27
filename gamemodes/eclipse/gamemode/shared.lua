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

hook.Add('PackageInstalled', 'welcome', function(pkg)
  name = pkg:GetName()
  if name == 'rp-immersive' then
    if CLIENT then
      pkg.Environment.UPLINK_READY:SendToServer()
    end
  end
end)

gpm.Import('packages/rp-immersive', true)
gpm.Import('packages/rp-immersive-dev', true)
gpm.Import('packages/rp-immersive-anatomy', true)
gpm.Import('packages/rp-immersive-violence', true)