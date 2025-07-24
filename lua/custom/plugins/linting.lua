-- return {
-- 'dense-analysis/ale',
--    config = function()
--    local g = vim.g

--   g.ale_linters = {
--      javascript = { 'eslint' },
--      typescript = { 'eslint' },
--      typescriptreact = { 'eslint' },
--      ruby = { 'rubocop', 'ruby' },
--    }

--    g.ale_fixers = {
--      javascript = { 'eslint' },
--      typescript = { 'eslint' },
--      typescriptreact = { 'eslint' },
--      ruby = { 'rubocop' },
--    }
--  end,
--}
return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    config = function()
      local conform = require 'conform'

      conform.setup {
        formatters_by_ft = {
          ruby = { 'rubocop' },
          lua = { 'stylua' },
          typescript = { 'prettier' },
          typescriptreact = { 'prettier' },
          javascript = { 'prettier' },
          -- Add more filetypes as needed
        },
      }

      vim.api.nvim_create_autocmd('BufWritePre', {
        callback = function(args)
          local bufnr = args.buf
          local ok_gs, gitsigns = pcall(require, 'gitsigns')
          if not ok_gs or not gitsigns.get_hunks then
            return
          end

          local hunks = gitsigns.get_hunks(bufnr)
          if not hunks or #hunks == 0 then
            return
          end

          for _, hunk in ipairs(hunks) do
            if hunk.type == 'add' or hunk.type == 'change' then
              local start_line = hunk.added.start
              local end_line = start_line + hunk.added.count

              conform.format {
                bufnr = bufnr,
                async = false,
                lsp_fallback = true,
                range = { start = start_line, ["end"] = end_line },
              }
            end
          end
        end,
      })
    end,
  },
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
