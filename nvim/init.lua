-- $Id init.lua
-- Main init file
-- ~/.config/nvim

if vim.g.neovide then
    vim.o.guifont = "Cascadia Code NF:h14"
    vim.g.neovide_cursor_short_animation_length = 0.04
    vim.g.neovide_cursor_vfx_mode = "sonicboom"
    vim.g.neovide_title_text_color = "pink"
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_remember_window_size = true

    vim.g.neovide_cursor_animate_command_line = true
    -- If disabled, the switch from editor window to command line is non-animated,i
    -- and the cursor jumps between command line and editor window immediately.
    -- Does not influence animation inside of the command line.

end

require('before')
require('plugins')

require('config')
