local M = {}

M.config = {
    discordEnvVariable = "DISCORDTOKEN",
    openStatus = { "Programming", "Coding" },
    -- TODO
    -- handle nil and make sure it works (should clear a custom status)
    closeStatus = { "!Programming", "Procrastinating", nil }

}

local function wait_for_env_var()
    -- TODO
    -- have user pass in env variable and this function will search for it
    -- clean up unecessary stuff like stdout varaible, print statements, dependency setup, etc
    -- set up logging? at least allocate places where logging would be useful

    local poll_timer = vim.uv.new_timer()

    poll_timer:start(0, 100, vim.schedule_wrap(function()
        local authToken = os.getenv("DISCORDTOKEN")

        -- Check if the environment variable is set
        if authToken ~= nil and authToken ~= "" then
            -- Set the global authToken
            M.config.discordAuthToken = authToken
            print("DISCORDTOKEN found! ", authToken)

            -- Stop the timer once the variable is found
            poll_timer:stop()
        else
            -- You can log or notify that it's still not found
            vim.notify("Waiting...")
        end
    end))
end

local function set_status(status_text)
    local poll_timer = vim.uv.new_timer()

    poll_timer:start(0, 100, vim.schedule_wrap(function()
        local token = M.config.discordAuthToken
        if token ~= nil and token ~= "" then
            print(token)
            local stdout = vim.uv.new_pipe(false)
            local handle, err = vim.uv.spawn("curl", {
                args = {
                    "-X", "PATCH",
                    "https://discord.com/api/v9/users/@me/settings",
                    "-H", string.format("Authorization: %s", M.config.discordAuthToken),
                    "-H", "Content-Type: application/json",
                    "-d", string.format('{"status": "online", "custom_status": {"text": "%s"}}', status_text)
                },
                stdio = { nil, stdout, nil }

            }, function(code, signal)
                if code ~= 0 then
                    vim.notify("Error sending status to Discord: " .. code .. " " .. signal)
                else
                    vim.notify("Status update sent successfully.")
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
                    print("Response: " .. data)
                    print("token used: ", M.config.discordAuthToken)
                else
                    stdout:close()
                    handle:close()
                end
            end)

            poll_timer:stop()
        else
            print("Waiting...")
        end
    end))
end

function M.on_startup()
    set_status("Programming", token)
end

function M.on_exit(token)
    set_status("Offline")
end

function M.setup()
    vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
            M.on_exit()
        end,
    })

    wait_for_env_var()
    M.on_startup()
end

return M
