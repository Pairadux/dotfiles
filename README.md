# Dotflies

I have attempted to make the best possible Mouseless Development Environment that I can for myself. 

My Dotfiles are managed with [Gnu Stow](https://www.gnu.org/software/stow/) on mac & [XStow](https://github.com/majorkingleo/xstow) on Linux.
*Though I plan on eventually switching to [DotBot](https://github.com/anishathalye/dotbot) or [ Chezmoi ](https://chezmoi.io)

I am currently in love with [Folke's Tokyo Night Color Scheme](https://github.com/folke/tokyonight.nvim), so most of my configurations, when applicable, will include a Tokyo Night theme.

## What's Included?

- Fully custom ZSH environment utilizing antidote, pure prompt, zsh-completions, zsh-autosuggestions, fast-syntax-highlighting, zsh-history-substring-search, and custom scripts.
- XStow configurations
- Bat themeing
- Catnip configuration and themeing
- Hyprland configuraiton and themeing
- Kitty temp config (considered using Kitty, haven't gotten fully rid of it because I am still on the fence about it)
- Neovim config using NVChad Starter with a ton of personal tweaks and customizations
- Rofi launcher customizations and themeing
- Tmux configurations utilizing TPM and various Tmux plugins. Custom mappings and leader keys.
- Waybar configuration and themeing
- Wezterm basic configuration and themeing
- Zellij temp config (was buggy so I switched back to Tmux, but wanted to leave config in case I try it again)

## Notes

When installing these dotfiles, make sure that the ~/.config/tmux/{plugins, resurrect} directories exist **BEFORE** stowing dotfiles, otherwise you will be committing plugins and resurrect logs to your repo.

## NOTICE / WARNING

**Should you choose to take inspiration from my Dotfiles, feel free, but I am not liable for anything not working on your system the same way that it works on mine.**
