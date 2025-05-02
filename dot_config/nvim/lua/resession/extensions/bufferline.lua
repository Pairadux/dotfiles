local session = require 'scope.session'
local M = {}

-- capture any opts under `extensions.scope_state = { … }`
M.config = function(cfg)
    M._cfg = cfg or {}
end

--- Run before Resession writes the session file
--- @param opts resession.Extension.OnSaveOpts
--- @return string|table  -- serialized Scope state
M.on_save = function(opts)
    -- if it’s a tab-only save and you disabled scope-saves, bail out
    if opts.target_tabpage and not M._cfg.enable_in_tab then
        return
    end
    -- grab the full state (tabs, buffers, ordering) as JSON
    return session.serialize_state()
end

--- No-op before Resession restores windows & buffers
M.on_pre_load = function(data) end

--- After Resession has restored everything else, rehydrate Scope’s state
--- @param data string|table  -- what you returned from on_save
M.on_post_load = function(data)
    if not data then
        return
    end
    -- feed it back into Scope.nvim so it recreates your tabs/buffer order
    session.deserialize_state(data)
end

return M
