# ~/.config/nushell/env.nu

# Use a closure to update the PATH intelligently
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# The standard directories to ensure are in our path
let standard_paths = [
    ($env.HOME | path join ".local" "bin")
    ($env.HOME | path join ".cargo" "bin")
    "/snap/bin"
    "/usr/local/bin"
    "/home/linuxbrew/.linuxbrew/bin"
]

# Append the standard paths to the existing PATH, removing duplicates
$env.PATH = ($env.PATH | split row (char esep) | prepend $standard_paths | uniq)

# --- FZF and Search --------------------------------------------------------
let fd_bin = if (which fd | is-not-empty) { "fd" } else if (which fdfind | is-not-empty) { "fdfind" } else { "" }
if $fd_bin != "" {
    $env.FZF_DEFAULT_COMMAND = $"($fd_bin) --type f --hidden --follow --exclude .git"
    $env.FZF_CTRL_T_COMMAND = $env.FZF_DEFAULT_COMMAND
    $env.FZF_ALT_C_COMMAND = $"($fd_bin) --type d --hidden --follow --exclude .git"
}

# --- Everforest & Colors ---------------------------------------------------
$env.LSCOLORS = "exfxcxdxbxegedabagacad"
$env.FZF_DEFAULT_OPTS = "--height=40% --layout=reverse --border --color=bg+:#3d484d,bg:#2d353b,spinner:#a7c080,hl:#dbbc7f,fg:#d3c6aa,header:#83c092,info:#7fbbb3,pointer:#a7c080,marker:#e69875,fg+:#fff9e8,prompt:#a7c080,hl+:#e67e80"

# --- Zoxide init ----------------------------------------------------------
if (which zoxide | is-not-empty) {
    zoxide init nushell --cmd cd | save -f ~/.cache/zoxide/init.nu
}

# --- fnm init -------------------------------------------------------------
$env.FNM_DIR = ($env.HOME | path join ".local" "share" "fnm")
if ($env.FNM_DIR | path exists) {
    $env.PATH = ($env.PATH | prepend [($env.FNM_DIR | path join "aliases" "default" "bin")])
}
