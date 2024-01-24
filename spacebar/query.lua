local log   = hs.logger.new('query', 'info')
log.i('Loading module: query')

local function yabai(command, callback) -- {{{
    callback = callback or function(x) return x end
    command = '-m ' .. command

    hs.task.new(
        spacebar.config:get'paths.yabai',
        u.task_cb(callback),   -- wrap callback in json decoder
        command:split(' ')
    ):start()
end  -- }}}

local function spaceMapper(yabaiSpaces)
  local res = {['current'] = {}, ['others'] = {}}
  for _,space in pairs(yabaiSpaces or {}) do
    if space['has-focus'] then
      res['current'] = { ['title'] = space.label, ['windows'] = u.length(space.windows) }
    else
      res['others'][#res['others']+1] = { ['title'] = space.label, ['windows'] = u.length(space.windows) }
    end
  end
  return res
end

local function run(opts) -- {{{
  opts = opts or {}

  log.i('Refreshing spacebar')
  local yabai_cmd = 'query --spaces --display 1'

  yabai(yabai_cmd, function(yabaiRes)
      local spaces = spaceMapper(yabaiRes)
      spacebar:ingest( -- hand over to spacebar
        spaces
      )
  end)
end -- }}}

return {
  run = run,
  setLogLevel = log.setLogLevel
}