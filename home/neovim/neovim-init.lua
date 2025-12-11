--- Neovim global settings

-- set relative numbers
vim.opt.number = true
vim.opt.relativenumber = true
-- set color scheme
vim.cmd('colorscheme edge')
-- enable true colors in terminal
vim.opt.termguicolors = true
-- change default shiftwidth
vim.opt.shiftwidth = 2
-- Use the appropriate number of spaces to insert a <Tab>.
vim.opt.expandtab = true
-- Split to right/down
vim.opt.splitbelow = true
vim.opt.splitright = true

-- remapping
--- terminal-mode
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])
vim.keymap.set('t', '<A-Left>',  [[<C-\><C-n><C-w>h]])
vim.keymap.set('t', '<A-Down>',  [[<C-\><C-n><C-w>j]])
vim.keymap.set('t', '<A-Up>',    [[<C-\><C-n><C-w>k]])
vim.keymap.set('t', '<A-Right>', [[<C-\><C-n><C-w>l]])
vim.keymap.set('n', '<A-Left>',  '<C-w>h')
vim.keymap.set('n', '<A-Down>',  '<C-w>j')
vim.keymap.set('n', '<A-Up>',    '<C-w>k')
vim.keymap.set('n', '<A-Right>', '<C-w>l')

-- Create alias using neovim API
local alias_table = {
  { 'Q',  'quit'  },
  { 'Qa', 'qall'  },
  { 'QA', 'qall'  },
  { 'W',  'write' },
  { 'Wq', 'wq'    },
  { 'WQ', 'wq'    },
  { 'Wqa','wqall' },
  { 'WQa','wqall' },
  { 'WQA','wqall' },
}
-- iterate over the alias table, not using the index
for _, pair in ipairs(alias_table) do
  -- Create the alias with no configuration `{}`
  vim.api.nvim_create_user_command(pair[1], pair[2], { bang = true })
end

--- WhichKey
local which_key = require('which-key')
which_key.add({
  -- Open new terminal in new window and set the mode to terminal insert mode with 'i'
  { lhs='<Leader>t', rhs='<cmd>split +term<cr>i', desc='Open terminal in a new window', mode='n' },
  -- Toggle mouse support with `m`
  -- useful when the mouse is used by an app inside a terminal (like less)
  {
    lhs='<Leader>m',
    rhs=function()
      local current_mouse = vim.o.mouse
      if current_mouse == '' then
        vim.o.mouse = 'a'
        vim.notify('Mouse enabled', vim.log.levels.INFO)
      else
        vim.o.mouse = ''
        vim.notify('Mouse disabled', vim.log.levels.INFO)
      end
    end,
    desc='Toggle mouse'
  },
  -- Yank/paste from/to system clipboard
  { lhs='<Leader>y', rhs='"+y', desc='Yank (Copy) to system clipboard', mode={ 'n', 'v' } },
  { lhs='<Leader>p', rhs='"+p', desc='Paste from system clipboard', mode={ 'n', 'v' } },
  { lhs='<Leader>n', rhs='<cmd>Neotree toggle<cr>', desc='Toggle Neotree', mode={ 'n', 'v' } }
})

--- LSP
local capabilities = require('cmp_nvim_lsp').default_capabilities()

--- LSP:typst
vim.lsp.config('tinymist', {
  single_file_support = true,
  root_dir = function ()
    return vim.fn.getcwd()
  end,
  settings = {
    -- Export PDFs when a document has a title (and save a file),
    -- which is useful to filter out template files.
    exportPdf = "onDocumentHasTitle";
    -- set the rootPath to -,
    -- so that tinymist will always use parent directory of the file as the root path
    root_dir = "-";
    formatterMode = "typstyle";
  },
})
vim.lsp.enable('tinymist')

-- typst-preview.nvim
require('typst-preview').setup({
  dependencies_bin = {
    ['tinymist'] = 'tinymist',
    ['websocat'] = 'websocat',
  },
})

-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.typ",
  callback = function()
    vim.api.nvim_set_option_value("filetype", "typst", {})
  end,
})

--- LSP:nix
vim.lsp.config('nil_ls', {
  capabilities = capabilities,
})
vim.lsp.enable('nil_ls')

--- LSP:lua
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      --- Tell the language server which version of Lua you're using
      --- (most likely LuaJIT in the case of Neovim)
      runtime = { version = 'LuaJIT' };

      --- Get the language server to recognize the `vim` global
      diagnostics = { globals = { 'vim' }, },

      --- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false, },

      --- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
	library = {
	  vim.env.VIMRUNTIME
	},
      },
    },
  },
  capabilities = capabilities
})
vim.lsp.enable('lua_ls')

-- Lazily enhance lua_ls
--- @diagnostic disable-next-line: missing-fields
require('lazydev').setup({
  library = {
    {
      path = "luvit-meta/library",
      words = { "vim%.uv" },
    },
  };
})

--- LSP:C/C++
vim.lsp.config('clangd', {
  capabilities = capabilities
})
vim.lsp.enable('clangd')

require('clangd_extensions').setup({
  server = {
    capabilities = capabilities,
  },
})

--- LSP:Python
vim.lsp.enable('pyright')

--- VimTeX

vim.g.vimtex_view_general_viewer = 'okular'
vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'
vim.api.nvim_create_user_command('ZoteroCite', function()
  local format = vim.bo.filetype:match(".*tex") and "cite" or "pandoc"
  local api_call = 'http://127.0.0.1:23119/better-bibtex/cayw?format=' .. format .. '&brackets'
  local ref = vim.fn.system('curl -s "' .. api_call .. '"')
  vim.cmd('normal! i' .. ref)
end, { nargs = 0 })

--- Autocomplete

local luasnip = require('luasnip')
luasnip.config.setup({ history = false })
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local cmp = require('cmp')
--- @diagnostic disable-next-line: redundant-parameter
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-n>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-y>'] = cmp.mapping(cmp.mapping.confirm(),       { 'i', 'c' }),
    ['<C-q>'] = cmp.mapping(cmp.mapping.close(),         { 'i', 'c' }),
    --- smart tab
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
    --- smart shift tab
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    --- Enter key
    ['<CR>'] = cmp.mapping({
       i = function(fallback)
         if cmp.visible() and cmp.get_active_entry() then
           cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
         else
           fallback()
         end
       end,
       s = cmp.mapping.confirm({ select = true }),
       c = function(fallback)
	if cmp.visible() and cmp.get_active_entry() then
	  cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
        else
	  fallback()
	end
       end,
    }),
  },
  sources = cmp.config.sources({
    { name = 'vimtex'   },
    { name = 'lazydev'  },
    { name = 'luasnip'  },
    { name = 'path'     },
    { name = 'buffer'   },
    { name = 'nvim_lsp' },
  }),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'cmdline' }
  }, {
    { name = 'path' }
  }),
})

--- UI

require('noice').setup()

require('lualine').setup({
  extensions = {
    'trouble',
    'neo-tree'
  },
})

--- @diagnostic disable-next-line: missing-fields
require('trouble').setup({
  auto_close = true,
  auto_refresh = true,
  multiline = true,
  focus = true,
  -- Preview in a split to the right of the trouble list
  -- https://github.com/folke/trouble.nvim/blob/main/docs/examples.md#preview-in-a-split-to-the-right-of-the-trouble-list
  modes = {
    default = {
      mode = 'diagnostics',
      auto_open = true,
    },
  },
})

--- File Explorer
require('neo-tree').setup({
  sources = {
    "filesystem",
    "buffers",
    "git_status",
    "document_symbols",
  },
  -- All config that is not default will be presented here.
  -- https://github.com/nvim-neo-tree/neo-tree.nvim/blob/main/lua/neo-tree/defaults.lua
  enable_cursor_hijack = true,
  filesystem = {
    -- This will use the OS level file watchers to detect changes
    -- instead of relying on nvim autocmd events.
    use_libuv_file_watcher = true,
    follow_current_file = {
      enabled = false,
    },
    hijack_netrw_behavior = "open_default",
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = {
        ".git"
      },
    },
    window = {
      mappings = {
        ["o"] = "system_open",
      },
    },
  },
  commands = {
    --- @diagnostic disable-next-line: redundant-parameter
    system_open = function(state)
      local node = state.tree:get_node()
      local path = node:get_id()
      -- Linux only
      vim.fn.jobstart({"xdg-open", path}, {detach = true})
    end,
  },
  -- source_selector provides clickable tabs to switch between sources.
  --- @diagnostic disable-next-line: missing-fields
  source_selector = {
    winbar = true,
    sources = {
      { source = "filesystem" },
      { source = "buffers" },
      { source = "git_status" },
    },
  },
  -- event handlers
  event_handlers = {
    {
      event = "neo_tree_window_after_open",
      handler = function()
        vim.cmd("wincmd =")
      end,
    },
    { -- Enforce Normal mode
      event = "neo_tree_buffer_enter",
      handler = function()
        vim.cmd("stopinsert")
      end
    }
  },
})

-- Autostart Neotree on startup
-- https://github.com/MarvelousAlbattani/neovim/blob/ed88d34b703682c528e90ebdd988c9e9193bc972/init.lua#L37
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local filetype = vim.bo.filetype
    if filetype ~= 'man' and filetype ~= 'gitcommit' then
      require("neo-tree.command").execute({})
      vim.cmd("wincmd p")
    end
  end,
})

--- Telescope (Global Search, etc.)
-- File and text search in hidden files and directories
-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#file-and-text-search-in-hidden-files-and-directories
local telescope_config = require('telescope.config')
local telescope_builtin = require('telescope.builtin')
local lga_actions = require('telescope-live-grep-args.actions')
local vimgrep_args = { unpack(telescope_config.values.vimgrep_arguments) }
-- want to search in hidden/dot files.
table.insert(vimgrep_args, '--no-ignore')
table.insert(vimgrep_args, '--hidden')
table.insert(vimgrep_args, '--sort=path')
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_args, '--glob')
table.insert(vimgrep_args, '!**/.git/*')
--- Setup telecope here
require('telescope').setup({
  defaults = {
    vimgrep_arguments = vimgrep_args,
  },
  extensions = {
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
          -- freeze the current list and start a fuzzy search in the frozen list
          ["<C-space>"] = lga_actions.to_fuzzy_refine,
        },
      },
    }
  },
})
require('telescope').load_extension('live_grep_args')
-- add telescope shortcut keymap on <Leader> to which-key.nvim
local telescope_prefix = '<Leader>'
which_key.add({
  mode = { 'n', 'v' }, -- NORMAL and VISUAL mode
  { lhs=telescope_prefix..'a', rhs=require('telescope').extensions.live_grep_args.live_grep_args, desc='Live grep search' },
  { lhs=telescope_prefix..'s', rhs=telescope_builtin.live_grep, desc='Live grep search' },
  { lhs=telescope_prefix..'q', rhs=telescope_builtin.live_grep, desc='Live grep search' },
  { lhs=telescope_prefix..'b', rhs=telescope_builtin.buffers, desc='List buffers' },
  { lhs=telescope_prefix..'f', rhs=telescope_builtin.find_files, desc='Open files' },
})

--- Git
local neogit = require('neogit')
neogit.setup({
  disable_hint = true,
  kind = 'tab',
  graph_style = 'kitty',
})
-- add neogit shortcut keymap on <Leader> to which-key.nvim
local neogit_prefix = '<Leader>'
which_key.add({
  { lhs=neogit_prefix..'g', rhs=neogit.open, desc='Neogit' }
})

require('gitsigns').setup({})

--- Extra Functionalities
-- image-nvim
--- @diagnostic disable-next-line: missing-fields
require('image').setup({})

-- csvview-nvim
require('csvview').setup({})
-- autostart on CSV open
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.csv",
  callback = function()
    require('csvview').enable()
  end,
})

-- flatten-nvim
require('flatten').setup({
  window = {
    open = "alternate",
  },
})
