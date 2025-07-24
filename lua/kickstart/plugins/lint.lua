return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    opts = {
      format_on_save = function(bufnr)
        -- Format only modified lines
        local ok, conform = pcall(require, 'conform')
        if not ok then
          return
        end
        return {
          lsp_fallback = true,
          async = false,
          range = conform.get_modified_lines_range(bufnr),
        }
      end,
      formatters_by_ft = {
        ruby = { 'rubocop' },
        lua = { 'stylua' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        javascript = { 'prettier' },
        -- Add others as needed
      },
    },
  },
}
