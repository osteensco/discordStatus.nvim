<h1>discordStatus.nvim</h1>
A simple plugin that sets your discord status for you when you open up neovim.

<br>

<h2>Setup</h2>

```lua
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
- **discordEnvVariable:** The variable name of your discord token. If provided, discordStatus.nvim will search for a .env file in the neovim config's root directory for this variable.
- **discordAuthToken:** Alternatively provide the auth token yourself.
- **openStatus:** Table of possible status's to set when neovim is opened. If length > 1 a random status from this table will be chosen.
- **closeStatus:** Alternatively change your status when neovim closes. `nil` value will simply clear out your status. If length > 1 a random status from this table will be chosen.

<h2>Discord auth token</h2>

An easy way to get an auth token is via browser dev tools.
Go to discord.com, login, and navigate to the network tab. 
For a more detailed explaination, [click here](https://gist.github.com/MarvNC/e601f3603df22f36ebd3102c501116c6).

