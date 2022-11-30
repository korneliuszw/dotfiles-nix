local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({select = true}),
    ['<C-b>', '<UP>'] = cmp.mapping.scroll_docs(-1),
    ['<C-f>', '<DOWN>'] = cmp.mapping.scroll_docs(1)
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
  }, {
    { name = 'buffer' }
  })
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path'}
  }, {
    { name = 'cmdline'}
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')['tsserver'].setup {
  capabilities = capabilities
}
