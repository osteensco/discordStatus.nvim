<h1>discordStatus.nvim</h1>
A simple plugin that sets your discord status for you when you open up neovim.

<br>

<h2>Setup</h2>

```lua
--Lazy setup
    {
        'osteensco/discordStatus.nvim',
        dependencies = { "osteensco/dotenv.nvim" },
    },

-- Defaults
require('discordStatus').setup({
    discordEnvVariable = "DISCORDTOKEN", --The environment variable name of your discord token. 
    discordAuthToken = nil, --Alternatively provide the auth token directly.
    openStatus = { --Status(es) to set when neovim is opened.
        "Neovim BTW"
    },
    closeStatus = { nil }, --Status(es) to set when neovim is closed.
})
```
<h3> Some additional notes on the config: </h3>

Apart from setting an environment variable normally, you can add a .env file in your neovim config's root directory and discordStatus.nvim will look for it here if not found otherwise.
If you are providing your auth token directly, you will need to read it in yourself. 
In `openStatus` and `closeStatus` fields, if the length is > 1 a random status from this table will be chosen. A value of `nil` will simply clear out your status.

<h2>Discord auth token</h2>

An easy way to get an auth token is via browser dev tools.
Go to discord.com, login, and navigate to the network tab. 
For a more detailed explaination, [click here](https://gist.github.com/MarvNC/e601f3603df22f36ebd3102c501116c6).

