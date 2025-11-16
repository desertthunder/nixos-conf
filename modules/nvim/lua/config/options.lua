vim.g.have_nerd_font = false

-- Line numbers
vim.o.number = true
-- vim.o.relativenumber = true

-- Enable mouse
vim.o.mouse = 'a'

-- Hide mode (shown in statusline)
vim.o.showmode = false

-- Sync clipboard with OS
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Indentation
vim.o.breakindent = true

-- Persistent undo
vim.o.undofile = true

-- Smart case-insensitive search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Sign column
vim.o.signcolumn = 'yes'

-- Faster completion
vim.o.updatetime = 250

-- Faster key sequence completion
vim.o.timeoutlen = 300

-- Split behavior
vim.o.splitright = true
vim.o.splitbelow = true

-- Whitespace characters
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Live substitution preview
vim.o.inccommand = 'split'

-- Highlight cursor line
vim.o.cursorline = true

-- Scrolloff
vim.o.scrolloff = 10

-- Confirm unsaved changes
vim.o.confirm = true
