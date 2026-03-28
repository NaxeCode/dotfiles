# ~/.config/nushell/config.nu
let _start = (date now)

# --- Common env ------------------------------------------------------------
$env.EDITOR               = "nvim"
$env.VISUAL               = "nvim"
$env.OLLAMA_API_BASE      = "http://127.0.0.1:11434"
$env.OLLAMA_MODEL         = "qwen3-coder:30b"
$env.AIDER_MODEL          = "ollama_chat/qwen3-coder:30b"
$env.OPENAI_API_BASE      = $"($env.OLLAMA_API_BASE)/v1"
$env.OPENCODE_API_BASE    = "http://localhost:11434/v1"
$env.OPENCODE_MODEL       = "ollama/qwen3-coder:30b"
$env.OPENCODE_API_KEY     = "ollama"
# $env.DEEPSEEK_API_KEY     = "..." # Loaded from secrets.nu if present
$env.CLICOLOR             = 1
$env.OPENCODE_ENABLE_EXA  = 1

$env.config = {
    show_banner: false,
    buffer_editor: "nvim"
}

# --- Load Secrets -----------------------------------------------------------
if ("~/.config/nushell/secrets.nu" | path expand | path exists) {
    source ~/.config/nushell/secrets.nu
}

# --- Load platform-specific bits --------------------------------------------
if $nu.os-info.family == "windows" {
  source windows.nu
} else if $nu.os-info.family == "macos" {
  source macos.nu
} else {
  source linux.nu
}

# --- Theme State -------------------------------------------------------------
let _theme = (
    if ("~/.config/theme" | path expand | path exists) {
        open ("~/.config/theme" | path expand) | str trim
    } else {
        "dark"
    }
)

# --- Cross-platform Aliases --------------------------------------------------
alias gl  = cd $env.GITLAB_BASE
alias pp  = cd ($env.GITLAB_BASE | path join "personal")
alias nv  = cd $env.NEOVIM
alias pc  = cd ($env.GITLAB_BASE | path join "playcheckv3")
alias pcg = cd ($env.GITLAB_BASE | path join "playcheckv3" "GamePlugins")
alias pr  = cd ($env.GITLAB_BASE | path join "playreview")
alias qt  = cd ($env.GITLAB_BASE | path join "quantumsystem")
alias gg  = cd ($env.GITLAB_BASE | path join "quantumsystem" "Quantum.GameFiles" "Games")
alias tb  = cd ($env.GITLAB_BASE | path join "quantum.toolbox")
alias or  = cd ($env.GITLAB_BASE | path join "quantum.orion")
alias ph  = cd ($env.GITLAB_BASE | path join "phoenix")

# --- TMUX Aliases ----------------------------------------------------------
alias t   = tmux
alias ta  = tmux attach
alias tls = tmux ls

# --- Better Defaults & Migrated Aliases -------------------------------------
if (which eza | is-not-empty) {
    alias ll = eza -la --group-directories-first --git
    alias la = eza -a --group-directories-first
    alias tree = eza --tree
}
if (which colorls | is-not-empty) {
    if $_theme == "light" {
        alias ls = colorls --light --sd
    } else {
        alias ls = colorls --dark --sd
    }
}
alias g  = git status
alias ga = git add
alias gc = git commit -m

if (which batcat | is-not-empty) {
    alias cat = batcat --paging=never --style=plain
} else if (which bat | is-not-empty) {
    alias cat = bat --paging=never --style=plain
}

if (which rg | is-not-empty) {
    alias grep = rg
}

if (which fd | is-not-empty) {
    alias find = fd
} else if (which fdfind | is-not-empty) {
    alias find = fdfind
    alias fd = fdfind
}

# --- Whisper & Llama --------------------------------------------------------
alias qw = qpwgraph
alias whisper = /home/naxecode/whisper.cpp/start-whisper.sh
alias llama = /home/naxecode/llama.cpp/build/bin/llama-server -m /home/naxecode/models/qwen35-27b/Qwen_Qwen3.5-27B-Q4_K_M.gguf --host 127.0.0.1 --port 8080 -ngl 999 -c 49152 --temp 0.2 --top-p 0.9

# --- Functions --------------------------------------------------------------
def --env y [...args] {
    let tmp = (mktemp -t yazi-cwd.XXXXXX)
    yazi ...$args --cwd-file=$tmp
    if ($tmp | path exists) {
        let cwd = (open $tmp)
        if $cwd != "" and $cwd != $env.PWD {
            cd $cwd
        }
        rm -f $tmp
    }
}

# --- Minimal Startup Info --------------------------------------------------
let _ms = (((date now) - $_start) / 1ms | math round --precision 2)
let _version = (version).version
print $"(ansi g)Nushell v($_version)(ansi reset)  (ansi y)load: ($_ms)ms(ansi reset)"

# --- External Tool Integrations ----------------------------------------------
if ("~/.cache/starship/init.nu" | path expand | path exists) {
    source ~/.cache/starship/init.nu
}
source ~/.cache/zoxide/init.nu

# --- Config Short-cuts (Must come BEFORE cd alias) --------------------------
def nuconf [] {
    cd ~/.config/nushell
    nvim config.nu
}

# --- Quick Reload ----------------------------------------------------------
alias rl = exec nu

# --- Helper: Persistent Export ----------------------------------------------
def --env ex [arg1: string, arg2?: any] {
    let config_path = $nu.config-path
    
    # Parse name and value
    let parts = if ($arg2 == null) and ($arg1 | str contains "=") {
        $arg1 | split row -n 2 "="
    } else {
        [$arg1, $arg2]
    }

    if ($parts | length) != 2 or ($parts.1 == null) {
        print $"(ansi r)Error: Usage is 'ex NAME VALUE' or 'ex NAME=VALUE'(ansi reset)"
        return
    }

    let name = ($parts.0 | str trim)
    let value = $parts.1
    
    # Safely get type string without triggering table printing
    let v_type = ($value | describe | into string | str replace --regex ':.*' '')
    
    let val_serialized = if $v_type == "string" {
        $"\"($value)\""
    } else {
        ($value | inspect)
    }
    
    let pattern = $"^\\s*\\$env\\.($name)\\s*="
    let new_line = $"$env.($name) = ($val_serialized)"

    let content = (open $config_path | lines)
    let matches = ($content | enumerate | where { |it| $it.item =~ $pattern })

    let result = if ($matches | is-not-empty) {
        let first_match = ($matches | first)
        let old_line = ($first_match.item | str trim)
        
        if ($old_line == $new_line) or ($old_line == $"$env.($name) = '($value)'") {
            { variable: $name, action: "SKIP", status: "already set", value: $old_line }
        } else {
            # Replace all occurrences (cleans up duplicates)
            $content 
            | each { |it| if ($it =~ $pattern) { $new_line } else { $it } } 
            | str join "\n" 
            | save -f $config_path
            { variable: $name, action: "UPDATE", from: $old_line, to: $new_line }
        }
    } else {
        # Append new value
        $"\n($new_line)" | save --append $config_path
        { variable: $name, action: "ADD", value: $new_line }
    }

    load-env { ($name): $value }
    print ([ $result ] | table)
}

# --- Navigation ---------------------------------------------------------------
alias c = cd

$env.HSA_OVERRIDE_GFX_VERSION = "11.0.0"
