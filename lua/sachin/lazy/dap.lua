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

            -- Configure dap-ui to only show the Breakpoints pane (right)
            -- and the REPL/logs pane (bottom). Disable other panes and controls.
            require("dapui").setup({
                layouts = {
                    {
                        -- Breakpoints on the right
                        elements = {
                            { id = "breakpoints", size = 1.0 },
                        },
                        size = 40, -- width of right sidebar
                        position = "right",
                    },
                    {
                        -- REPL / logs at the bottom
                        elements = {
                            { id = "repl", size = 1.0 },
                        },
                        size = 10, -- height of bottom panel
                        position = "bottom",
                    },
                },
                -- Disable control UI (play/step buttons) since they're not needed
                controls = {
                    enabled = false,
                },
                floating = {
                    max_height = 0.3,
                    max_width = 0.5,
                    border = "single",
                },
            })

            -- DAP adapter for Dart / Flutter
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

            -- Keep automatic open/close behaviour but now only the configured panes will appear.
            -- dap.listeners.before.attach.dapui_config = function()
            --     ui.open()
            -- end
            -- dap.listeners.before.launch.dapui_config = function()
            --     ui.open()
            -- end
            -- dap.listeners.before.event_terminated.dapui_config = function()
            --     ui.close()
            -- end
            -- dap.listeners.before.event_exited.dapui_config = function()
            --     ui.close()
            -- end
        end,
    },
}
