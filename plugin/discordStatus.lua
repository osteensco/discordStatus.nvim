require('dotenv').setup({ enable_on_load = true, verbose = true, wk_dir = vim.fn.stdpath("config") })
require('discordStatus').wait_for_env_var()
