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
    discordEnvVariable = "DISCORDTOKEN",
    discordAuthToken = nil,
    openStatus = {
        "Neovim BTW"
    },
    closeStatus = { nil },
})
```
- **discordEnvVariable:** The environment variable name of your discord token. Apart from setting an environment variable normally, you can add a .env file in your neovim config's root directory and discordStatus.nvim will look for it here if not found otherwise.
- **discordAuthToken:** Alternatively provide the auth token directly and read it in yourself. Or hardcode it if you're unhinged.
- **openStatus:** Table of possible status's to set when neovim is opened. If length > 1 a random status from this table will be chosen.
- **closeStatus:** Alternatively change your status when neovim closes. `nil` value will simply clear out your status. If length > 1 a random status from this table will be chosen.

<h2>Discord auth token</h2>

An easy way to get an auth token is via browser dev tools.
Go to discord.com, login, and navigate to the network tab. 
For a more detailed explaination, [click here](https://gist.github.com/MarvNC/e601f3603df22f36ebd3102c501116c6).

