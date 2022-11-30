-- https://github.com/Theory-of-Everything/nii-nvim/blob/master/lua/keymap.lua
local function map(mode, bind, exec, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend('force', options, opts)
	end
	vim.api.nvim_set_keymap(mode, bind, exec, opts)
end

local opt = {}

vim.g.mapleader = ' '
map('', '<C-c>', ':CommentToggle<CR>', opt) -- comment selection
map('n', '<leader>op', ':NvimTreeToggle<CR>', opt) -- nvimtree
map('', '<leader>ya', ':%y+<CR>', opt) -- copy to clipboard
--map('n', '<leader>wp', '<C-W>w', opt)
--map('n', '<leader>wd', '<C-W>q, opt')
--map('n', '<leader>wv', '<C-W>v, opt')
map('n', '<leader>rc', ':source $MYVIMRC<CR>', opt)
