--- LSP

local lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

--- LSP:nix
lsp.nil_ls.setup({
  capabilities = capabilities,
})

--- LSP:lua
lsp.lua_ls.setup({
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
	library = {
          checkThirdParty = false,
	  library = {
	    vim.env.VIMRUNTIME
	  }
	},
      },
    },
  },
  capabilities = capabilities
})

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
    { name = 'luasnip'  },
    { name = 'path'     },
    { name = 'buffer'   },
    { name = 'nvim_lsp' },
  }),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'cmdline' }
  }, {
    { name = 'path' }
  }),
})


--- UI

require('noice').setup()

require('feline').setup()

--- File Explorer

require('oil').setup()
require('neo-tree').setup({
  enable_git_status = true,
})

--- Telescope (Global Search, etc.)

-- File and text search in hidden files and directories
-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#file-and-text-search-in-hidden-files-and-directories
local telescopeConfig = require('telescope.config')
local vimgrep_args = { unpack(telescopeConfig.values.vimgrep_arguments) }
-- want to search in hidden/dot files.
table.insert(vimgrep_args, '--no-ignore')
table.insert(vimgrep_args, '--hidden')
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_args, '--glob')
table.insert(vimgrep_args, '!**/.git/*')

require('telescope').setup({
  defaults = {
    vimgrep_arguments = vimgrep_args,
  },
  pickers = {
    find_files = {
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = { 'rg', '--files', '--no-ignore', '--hidden', '--glob', '!**/.git/*' },
    },
  },
})

--- Git

require('neogit').setup({
  -- vsplit if window would have 80 cols, otherwise split
  kind = 'auto',
})
