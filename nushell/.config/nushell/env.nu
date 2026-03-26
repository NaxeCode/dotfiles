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
