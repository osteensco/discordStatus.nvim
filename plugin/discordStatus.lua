require('dotenv').setup({ enable_on_load = true, verbose = false, wk_dir = vim.fn.stdpath("config") })
require('discordStatus').wait_for_env_var()
