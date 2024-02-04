WELCOME_MESSAGE = [[
 
     If you don't ask the right questions,
        you don't get the right answers.
                                      ~ Robert Half
]]

local M = {}

-- adding a place to store some log, temp
M.logs = {}

function M.defaults()
  local defaults = {
    debug = false,
    edgy = true,
    yank_register = "+",
    default_provider = "ollama",
    providers = {
      openai = {
        enabled = true,
        model = "gpt-4",
        api_host = os.getenv("OPENAI_API_HOST") or "https://api.openai.com",
        api_key = os.getenv("OPENAI_API_KEY") or "",
        api_params = {
          frequency_penalty = 0,
          presence_penalty = 0,
          temperature = 0.5,
          top_p = 0.99,
        },
        api_chat_params = {
          frequency_penalty = 0.8,
          presence_penalty = 0.5,
          temperature = 0.8,
          top_p = 0.99,
        },
      },
      textgenui = {
        enabled = true,
        api_host = os.getenv("OGPT_API_HOST"),
        api_key = os.getenv("OGPT_API_KEY"),
        model = {
          -- create a modify url specifically for mixtral to run
          name = "mixtral-8-7b",
          -- model = {
          --   -- create a modify url specifically for mixtral to run
          --   name = "mixtral-8-7b",
          --   modify_url = function(url)
          --     -- given a URL, this function modifies the URL specifically to the model
          --     -- This is useful when you have different models hosted on different subdomains like
          --     -- https://model1.yourdomain.com/
          --     -- https://model2.yourdomain.com/
          --     local new_model = "mixtral-8-7b"
          --     local host = url:match("https?://([^/]+)")
          --     local subdomain, domain, tld = host:match("([^.]+)%.([^.]+)%.([^.]+)")
          --     local _new_url = url:gsub(host, new_model .. "." .. domain .. "." .. tld)
          --     return _new_url
          --   end,
          --   conform_fn = function(params)
          --     -- Different models might have different instruction format
          --     -- for example, Mixtral operates on `<s> [INST] Instruction [/INST] Model answer</s> [INST] Follow-up instruction [/INST] `
          --   end,
          -- },
        },
        api_params = {
          frequency_penalty = 0,
          presence_penalty = 0,
          temperature = 0.5,
          top_p = 0.99,
        },
        api_chat_params = {
          frequency_penalty = 0.8,
          presence_penalty = 0.5,
          temperature = 0.8,
          top_p = 0.99,
        },
      },
      ollama = {
        enabled = true,
        api_host = os.getenv("OLLAMA_API_HOST") or "http://localhost:11434",
        api_key = os.getenv("OLLAMA_API_KEY") or "",
        models = {
          {
            -- create a modify url specifically for mixtral to run
            name = "mistral:7b",
            modify_url = function(url)
              return url
            end,
            -- conform_fn = function(params)
            --   -- Different models might have different instruction format
            --   -- for example, Mixtral operates on `<s> [INST] Instruction [/INST] Model answer</s> [INST] Follow-up instruction [/INST] `
            -- end,
          },
        },
        model = {
          name = "mistral:7b",
          system_message = nil,
        },
        api_params = {
          -- used for `edit` and `edit_code` strategy in the actions
          model = nil,
          -- model = "mistral:7b",
          frequency_penalty = 0,
          presence_penalty = 0,
          temperature = 0.5,
          top_p = 0.99,
        },
        api_chat_params = {
          -- use default ollama model
          model = nil,
          temperature = 0.8,
          top_p = 0.99,
        },
      },
    },

    edit = {
      layout = "default",
      edgy = nil, -- use global default
      diff = false,
      keymaps = {
        close = "<C-c>",
        accept = "<C-y>", -- accept the output and write to original buffer
        toggle_diff = "<C-d>", -- view the diff between left and right panes and use diff-mode
        toggle_parameters = "<C-p>", -- Toggle parameters window
        cycle_windows = "<Tab>",
        use_output_as_input = "<C-u>",
      },
    },
    popup = {
      edgy = nil, -- use global default
      position = 1,
      size = {
        width = "40%",
        height = 10,
      },
      padding = { 1, 1, 1, 1 },
      enter = true,
      focusable = true,
      zindex = 50,
      border = {
        style = "rounded",
      },
      buf_options = {
        modifiable = false,
        readonly = false,
        filetype = "ogpt-popup",
        syntax = "markdown",
      },
      win_options = {
        wrap = true,
        linebreak = true,
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
      keymaps = {
        close = { "<C-c>", "q" },
        accept = "<C-CR>",
        append = "a",
        prepend = "p",
        yank_code = "c",
        yank_to_register = "y",
      },
    },

    chat = {
      welcome_message = WELCOME_MESSAGE,
      loading_text = "Loading, please wait ...",
      question_sign = "", -- 🙂
      answer_sign = "ﮧ", -- 🤖
      border_left_sign = "|",
      border_right_sign = "|",
      max_line_length = 120,
      edgy = nil, -- use global default
      sessions_window = {
        active_sign = " 󰄵 ",
        inactive_sign = " 󰄱 ",
        current_line_sign = "",
        border = {
          style = "rounded",
          text = {
            top = " Sessions ",
          },
        },
        win_options = {
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        },
        buf_options = {
          filetype = "ogpt-sessions",
        },
      },
      keymaps = {
        close = { "<C-c>" },
        yank_last = "<C-y>",
        yank_last_code = "<C-i>",
        scroll_up = "<C-u>",
        scroll_down = "<C-d>",
        new_session = "<C-n>",
        cycle_windows = "<Tab>",
        cycle_modes = "<C-f>",
        next_message = "J",
        prev_message = "K",
        select_session = "<CR>",
        rename_session = "r",
        delete_session = "d",
        draft_message = "<C-d>",
        edit_message = "e",
        delete_message = "d",
        toggle_parameters = "<C-p>",
        toggle_message_role = "<C-r>",
        toggle_system_role_open = "<C-s>",
        stop_generating = "<C-x>",
      },
    },
    popup_layout = {
      default = "center",
      center = {
        width = "80%",
        height = "80%",
      },
      right = {
        width = "30%",
        width_parameters_open = "50%",
      },
    },
    output_window = {
      border = {
        highlight = "FloatBorder",
        style = "rounded",
        text = {
          top = " OGPT ",
        },
      },
      win_options = {
        wrap = true,
        linebreak = true,
        foldcolumn = "1",
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
      buf_options = {
        filetype = "ogpt-window",
        syntax = "markdown",
      },
    },
    system_window = {
      border = {
        highlight = "FloatBorder",
        style = "rounded",
        text = {
          top = " SYSTEM ",
        },
      },
      win_options = {
        wrap = true,
        linebreak = true,
        foldcolumn = "2",
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
      buf_options = {
        filetype = "ogpt-system-window",
      },
    },
    input_window = {
      prompt = "  ",
      border = {
        highlight = "FloatBorder",
        style = "rounded",
        text = {
          top_align = "center",
          top = " Instruction ",
        },
      },
      win_options = {
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
      buf_options = {
        filetype = "ogpt-input",
      },
      submit = "<C-Enter>",
      submit_n = "<Enter>",
      max_visible_lines = 20,
    },
    parameters_window = {
      setting_sign = "  ",
      border = {
        style = "rounded",
        text = {
          top = " Parameters ",
        },
      },
      win_options = {
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
      buf_options = {
        filetype = "ogpt-parameters-window",
      },
    },
    actions = {
      -- all strategy "edit" have instruction as input
      edit_code_with_instructions = {
        type = "edit",
        strategy = "edit_code",
        template = "Given the follow code snippet, {{instruction}}.\n\nCode:\n```{{filetype}}\n{{input}}\n```",
        delay = true,
        extract_codeblock = true,
        params = {
          frequency_penalty = 0,
          presence_penalty = 0,
          temperature = 0.5,
          top_p = 0.99,
        },
      },

      -- all strategy "edit" have instruction as input
      edit_with_instructions = {
        -- if not specified, will use default provider
        -- provider = "ollama",
        -- model = "mistral:7b",
        type = "edit",
        strategy = "edit",
        template = "Given the follow input, {{instruction}}.\n\nInput:\n```{{filetype}}\n{{input}}\n```",
        delay = true,
        params = {
          temperature = 0.5,
          top_p = 0.99,
        },
      },
    },

    actions_paths = {
      -- default action that comes with ogpt/lua/flow/actions
      debug.getinfo(1, "S").source:sub(2):match("(.*/)") .. "actions.json",
    },
    show_quickfixes_cmd = "Trouble quickfix",
    predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
  }
  return defaults
end

M.options = {}

M.namespace_id = vim.api.nvim_create_namespace("OGPTNS")

function M.setup(options)
  options = options or {}
  M.options = vim.tbl_deep_extend("force", {}, M.defaults(), options)
  local _complete_replace = {
    "actions",
  }

  local function update_edgy_flag(chat_type)
    for _, t in ipairs(chat_type) do
      if not M.options[t].edgy then
        M.options[t].edgy = M.options.edgy
      end
    end
  end

  update_edgy_flag({
    "chat",
    "edit",
    "popup",
  })

  for _, to_replace in pairs(_complete_replace) do
    vim.tbl_contains(options, to_replace)
    for key, item in pairs(options[to_replace] or {}) do
      M.options[to_replace][key] = item
    end
  end
end

function M.get_provider(provider_name, action, override)
  local Api = require("ogpt.api")
  override = override or {}
  provider_name = provider_name or M.options.default_provider
  local provider = require("ogpt.provider." .. provider_name)
  local envs = provider.load_envs(override.envs)
  provider = vim.tbl_extend("force", provider, override)
  provider.envs = envs
  provider.api = Api(provider, action, {})
  return provider
end

function M.get_action_params(provider, override)
  provider = provider or M.options.default_provider
  local default_params = M.options.providers[provider].api_params
  default_params.model = default_params.model or M.options.providers[provider].model
  default_params.provider = provider
  return vim.tbl_extend("force", default_params, override or {})
end

function M.get_chat_params(provider, override)
  provider = provider or M.options.default_provider
  local default_params = M.options.providers[provider].api_chat_params or {}
  default_params.model = default_params.model or M.options.providers[provider].model
  default_params.provider = provider
  return vim.tbl_extend("force", default_params, override or {})
end

function M.expand_model(api, params)
  local provider_models = M.options.providers[api.provider.name].models or {}
  params = M.get_action_params(api.provider.name, params)
  local _model = params.model

  local _completion_url = api.provider.envs.CHAT_COMPLETIONS_URL

  local function _expand(name, _m)
    if type(_m) == "table" then
      if _m.modify_url and type(_m.modify_url) == "function" then
        _completion_url = _m.modify_url(_completion_url)
      elseif _m.modify_url then
        _completion_url = _m.modify_url
      else
        params.model = _m.name
        for _, model in ipairs(provider_models) do
          if model.name == _m.name then
            _expand(model)
            break
          end
        end
      end
      params.model = _m.name or name
    else
      for _name, model in pairs(provider_models) do
        if _name == _m then
          if type(model) == "table" then
            _expand(_name, model)
            break
          elseif type(model) == "string" then
            params.model = model
          end
        end
      end
    end
  end

  _expand(nil, _model)

  params = M.expand_url(api, params)

  return params, _completion_url
end

function M.expand_url(api, params)
  params = M.get_action_params(api.provider.name, params)
  local _model = params.model
  local _conform_fn = _model and _model.conform_fn

  if _conform_fn then
    params = _conform_fn(params)
  else
    params = api.provider.conform(params)
  end
  return params
end

return M
