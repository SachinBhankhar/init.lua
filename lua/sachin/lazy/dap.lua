return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "leoluz/nvim-dap-go",
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
        },
        config = function()
            local dap = require "dap"
            local ui = require "dapui"

            require("dapui").setup()
            require("dap-go").setup()

            vim.keymap.set("n", "<space>tb", require('dapui').toggle)

            require("nvim-dap-virtual-text").setup()

            -- Handled by nvim-dap-go
            -- dap.adapters.go = {
            --   type = "server",
            --   port = "${port}",
            --   executable = {
            --     command = "dlv",
            --     args = { "dap", "-l", "127.0.0.1:${port}" },
            --   },
            -- }

            dap.adapters.dart = {
                type = "executable",
                command = "dart",
                -- This command was introduced upstream in https://github.com/dart-lang/sdk/commit/b68ccc9a
                args = { "debug_adapter" }
            }

            dap.configurations.dart = {
                {
                    type = "dart",
                    request = "launch",
                    name = "Launch Dart Program",
                    -- The nvim-dap plugin populates this variable with the filename of the current buffer
                    program = "${file}",
                    -- The nvim-dap plugin populates this variable with the editor's current working directory
                    cwd = "${workspaceFolder}",
                    args = { "--help" }, -- Note for Dart apps this is args, for Flutter apps toolArgs
                }
            }

            vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
            vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

            -- Eval var under cursor
            vim.keymap.set("n", "<space>?", function()
                require("dapui").eval(nil, { enter = true })
            end)

            vim.keymap.set("n", "<space>c", dap.continue)
            vim.keymap.set("n", "<space>si", dap.step_into)
            vim.keymap.set("n", "<space>sv", dap.step_over)
            vim.keymap.set("n", "<space>st", dap.step_out)
            vim.keymap.set("n", "<space>sb", dap.step_back)
            vim.keymap.set("n", "<space>rs", dap.restart)

            dap.listeners.before.attach.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                ui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                ui.close()
            end
        end,
    },
}
