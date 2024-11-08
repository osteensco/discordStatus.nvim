local M = {}

local authToken = os.getenv("DISCORDTOKEN")

local stdout = vim.uv.new_pipe()

local function set_status(status_text)
    local handle = vim.uv.spawn("curl", {
        args = {
            "-X", "PATCH",
            "https://discord.com/api/v9/users/@me/settings",
            "-H", string.format("Authorization: %s", authToken),
            "-H", "Content-Type: application/json",
            "-d", string.format('{"status": "online", "custom_status": {"text": "%s"}}', status_text)
        },
        stdio = { nil, stdout, nil }

    }, function(code, signal)
        print("exit code", code)
        if code ~= 0 then
            print("Error sending status to Discord:", code, signal)
        end
    end)
    vim.uv.read_start(stdout, function(err, data)
        assert(not err, err)
        if data then
            vim.notify("Response: ", data)
        end
    end)
    stdout:close()
    handle:close()
end


function M.on_startup()
    set_status("Programming")
end

function M.on_exit()
    set_status("Offline")
end

function M.setup()
    M.on_startup()


    vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
            M.on_exit()
        end,
    })
end

return M
