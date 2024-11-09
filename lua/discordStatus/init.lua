local M = {}

M.config = {
    discordEnvVariable = "DISCORDTOKEN",
    discordAuthToken = nil,
    openStatus = {
        "Neovim BTW"
    },
    closeStatus = { nil },
}

function M.wait_for_env_var()
    local poll_timer = vim.uv.new_timer()
    poll_timer:start(0, 1000, vim.schedule_wrap(function()
        local authToken = os.getenv(M.config.discordEnvVariable)
        if authToken ~= nil and authToken ~= "" then
            M.config.discordAuthToken = authToken
            -- Stop the timer once the variable is found
            poll_timer:stop()
        end
    end))
end

local function get_len(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

local function rand_item(tbl)
    math.randomseed(os.time())
    local randInt = math.random(1, tbl.len)
    return tbl[randInt]
end

local function set_status(status_text)
    local poll_timer = vim.uv.new_timer()

    poll_timer:start(0, 1000, vim.schedule_wrap(function()
        local token = M.config.discordAuthToken
        if token ~= nil and token ~= "" then
            if status_text ~= nil then
                status_text = '"' .. status_text .. '"'
            else
                status_text = "null"
            end

            local stdout = vim.uv.new_pipe(false)
            local handle, err = vim.uv.spawn("curl", {
                args = {
                    "-X", "PATCH",
                    "https://discord.com/api/v9/users/@me/settings",
                    "-H", string.format("Authorization: %s", M.config.discordAuthToken),
                    "-H", "Content-Type: application/json",
                    "-d", string.format('{"status": "online", "custom_status": {"text": %s}}', status_text)
                },
                stdio = { nil, stdout, nil }

            }, function(code, signal)
                if code ~= 0 then
                    vim.notify("Error sending status to Discord: " .. code .. " " .. signal)
                end
                stdout:close()
                handle:close()
            end)

            if not handle then
                vim.notify("Failed to spawn curl process: " .. err)
                return
            end

            vim.uv.read_start(stdout, function(err, data)
                if err then
                    print("Error reading response: " .. err)
                    return
                end
                if data then
                    print()
                else
                    stdout:close()
                    handle:close()
                end
            end)

            poll_timer:stop()
        end
    end))
end

function M.on_startup()
    local status = rand_item(M.config.openStatus)
    set_status(status)
end

function M.on_exit()
    local status = rand_item(M.config.closeStatus)
    set_status(status)
end

function M.setup(opts)
    M.config = vim.tbl_deep_extend('force', M.config, opts)

    openStatus_len = get_len(M.config.openStatus)
    M.config.openStatus.len = openStatus_len

    closeStatus_len = get_len(M.config.closeStatus)
    M.config.closeStatus.len = closeStatus_len

    vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
            M.on_exit()
        end,
    })



    M.on_startup()
end

return M
