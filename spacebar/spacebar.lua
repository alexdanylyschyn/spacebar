-- luacheck: globals table.merge
-- luacheck: globals u
-- luacheck: ignore 112
local wf    = hs.window.filter
local timer = hs.timer.delayed
local log   = hs.logger.new('spacebar', 'info')

log.i'Loading module: spacebar'
_G.u = require 'lib.utils'
_G.spacebar = {} -- access spacebar under global 'spacebar'
spacebar.config = require'spacebar.configmanager'
spacebar.query = require'spacebar.query'

function spacebar:init(userConfig) -- {{{
    log.i'Initializing spacebar'
    if spacebar.menubar then -- re-initializtion guard https://github.com/AdamWagner/stackline/issues/46
        return log.i'spacebar already initialized'
    end

    -- init config with default settings + user overrides
    self.config:init(u.extend(require 'spacebar.conf', userConfig or {}))

    self:setupMenubar()
    self:update()
    return self
end -- }}}

function spacebar:setupMenubar()
  self.menubar = hs.menubar.new()

  self.menubar:setTitle('Yabai')
end

function spacebar:update()
  self.query.run()
end

function spacebar:ingest(spaces)
 u.p(spaces)

 local title = string.format("%s - %s", spaces['current']['title'], tostring(spaces['current']['windows']))
 self.menubar:setTitle(title)

 local menuitems = {}

  for _,space in pairs(spaces['others'] or {}) do
    table.insert(menuitems, { ['title'] = string.format("%s - %s", space['title'], tostring(space['windows'])), ['fn'] = function(mod) if mod.cmd then self:move(space) else self:switch(space) end end })
  end
 self.menubar:setMenu(menuitems)
end

function spacebar:switch(space)
  command = string.format('-m space --focus %s', space['title'])

  hs.task.new(
      self.config:get'paths.yabai',
      nil,
      command:split(' ')
  ):start()
end

function spacebar:move(space)
  command = string.format('-m window --space %s', space['title'])

  hs.task.new(
      self.config:get'paths.yabai',
      nil,
      command:split(' ')
  ):start()end

function spacebar:setLogLevel(lvl) -- {{{
    log.setLogLevel(lvl)
    log.i( ('Window.log level set to %s'):format(lvl) )
end -- }}}

return spacebar
