local utils = {}

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

function utils.opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= 'o' then scopes['o'][key] = value end
end

function utils.map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function utils.create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        vim.api.nvim_command('augroup ' .. group_name)
        vim.api.nvim_command('autocmd!')
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten {'autocmd', def}, ' ')
            vim.api.nvim_command(command)
        end
        vim.api.nvim_command('augroup END')
    end
end

function utils.path_exists(path)
   return vim.loop.fs_stat(path) and true or false
end

--- Check if a file or directory exists in this path
function utils.exists(file)
    local ok, err, code = os.rename(file, file)
    if not ok then
        if code == 13 then
        -- Permission denied, but it exists
            return true
        end
    end
    return ok, err
end

--- Check if a directory exists in this path
function utils.isdir(path)
    -- "/" works on both Unix and Windows
    return utils.exists(path ..'/')
end

-- Check if a file or directory exists in this path
function utils.load_plugin(plugin)
	local opt_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/" .. plugin
	local ok, err = utils.isdir(opt_path)
	if ok then
		vim.api.nvim_command[[packadd .. plugin]]
        -- print (plugin, ': loaded')
	end
	return ok, err
end

return utils
