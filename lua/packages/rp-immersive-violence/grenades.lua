local THING
THING = install('rp-immersive', 'https://github.com/toxidroma/rp-immersive').THING
local PinPull
do
  local _class_0
  local _parent_0 = SOUND
  local _base_0 = {
    sound = 'snd_jack_pinpull.wav'
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "PinPull",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  PinPull = _class_0
end
local SpoonFly
do
  local _class_0
  local _parent_0 = SOUND
  local _base_0 = {
    sound = 'snd_jack_spoonfling.wav'
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "SpoonFly",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  SpoonFly = _class_0
end
local SpoonBounce
do
  local _class_0
  local _parent_0 = SOUND
  local _base_0 = {
    sound = 'snd_jack_spoonbounce.wav'
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "SpoonBounce",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  SpoonBounce = _class_0
end
print(THING, SOUND)
local GRENADE
do
  local _class_0
  local _parent_0 = THING
  local _base_0 = {
    Model = Model('models/jmod/explosives/grenades/sticknade/stick_grenade.mdl'),
    PrimeSound = 'PinPull',
    SetupDataTables = function(self)
      _class_0.__parent.__base.SetupDataTables(self)
      self:AddNetworkVar('Bool', 'Primed')
      return self:AddNetworkVar('Bool', 'Armed')
    end,
    Radius = 250,
    Damage = 175,
    Operate = function(self, ply)
      if not (self:GetPrimed()) then
        return self:Prime()
      else
        return self:Arm()
      end
    end,
    Prime = function(self)
      if not (self:GetPrimed()) then
        self:EmitSound(self.PrimeSound)
        self:SetPrimed(true)
        return true
      end
    end,
    Arm = function(self)
      if not (self:GetArmed() or not self:GetPrimed()) then
        self:EmitSound('SpoonFly')
        self:SetArmed(true)
        return true
      end
    end,
    Think = function(self)
      _class_0.__parent.__base.Think(self)
      if not (self:GetArmed() or IsValid(self:GetHolder())) then
        if self:GetPrimed() then
          return self:Arm()
        end
      end
    end,
    Detonate = function(self)
      local pos = self:WorldSpaceCenter()
      util.ScreenShake(pos, 25, 150, 1, self.Radius)
      do
        local _with_0 = ents.Create('env_explosion')
        _with_0:SetOwner(self:GetOwner())
        _with_0:SetPos(pos)
        _with_0:SetKeyValue('iMagnitude', self.Damage)
        _with_0:SetKeyValue('iRadiusOverride', self.Radius)
        _with_0:Spawn()
        _with_0:Activate()
        _with_0:Fire('Explode')
      end
      return self:Remove()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "GRENADE",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  GRENADE = _class_0
end
local Timed
do
  local _class_0
  local _parent_0 = GRENADE
  local _base_0 = {
    Arm = self:Wait(4, function()
      if _class_0.__parent.__base.Arm(self) then
        return self:Detonate()
      end
    end)
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Timed",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Timed = _class_0
end
local ImpactDecap
do
  local _class_0
  local _parent_0 = SOUND
  local _base_0 = {
    sound = 'snds_jack_gmod/ez_weapons/shotrevolver/open.wav'
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "ImpactDecap",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  ImpactDecap = _class_0
end
local Impact
do
  local _class_0
  local _parent_0 = GRENADE
  local _base_0 = {
    Model = Model('models/jmod/explosives/grenades/impactnade/impact_grenade.mdl'),
    PrimeSound = 'ImpactDecap',
    ImpactThreshold = 256,
    Prime = function(self)
      if _class_0.__parent.__base.Prime(self) then
        return self:SetBodygroup(2, 1)
      end
    end,
    PhysicsCollide = function(self, data)
      _class_0.__parent.__base.PhysicsCollide(self, data)
      if self:GetArmed() then
        if data.Speed > self.ImpactThreshold then
          return self:Detonate()
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Impact",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Impact = _class_0
  return _class_0
end
