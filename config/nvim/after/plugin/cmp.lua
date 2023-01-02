local cmp = require 'cmp'
local luasnip = require 'luasnip'

-- Load snippets
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-j>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      end
    end),
    ['<C-k>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      end
    end),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true, -- If this is true, will select the first item even if none is selected.
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        local entries = cmp.get_entries()
        if #entries > 0 and (#entries == 1 or entries[1].exact or cmp.get_selected_entry()) then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true})
        end
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
  },
}