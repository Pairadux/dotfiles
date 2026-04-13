# Personal Navi Cheatsheets

Context file for future edits to these cheatsheets.

## Navi Format Reference

```
% tag1, tag2, tag3          ← section tags (searchable/filterable)

# Description of command    ← shows in fzf picker, keep searchable
command with <placeholder>  ← the actual command

$ placeholder: command      ← dynamic completion for <placeholder>
$ placeholder: cmd --- --multi true  ← fzf options after ---
```

- `%` starts a new tag section. All commands until the next `%` share those tags.
- `#` descriptions are what the user searches in the fzf picker — make them clear.
- `<placeholder>` marks variable arguments the user fills in.
- `$ variable: command` at the bottom of a section generates dynamic completions.
- `---` after the completion command passes options to fzf (e.g. `--multi true`).

## Design Principles

- Focused on real usage patterns, not exhaustive flag references.
- Modern tools only — no cheatsheets for classic equivalents that have been replaced:
  - duf over df, dust/dua over du, fd over find, rg over grep, eza over ls, bat over cat, zoxide over cd
- Interactive TUIs (btop, ncmpcpp, lazygit, yazi) get light "it exists" entries with
  a matchable description, not comprehensive coverage.
- Custom/personal tools (muxly, jdexr, gametrak) included but not over-documented
  since the user wrote them.
- Community cheatsheets (denisidoro__cheats) are NOT modified. Personal entries only
  supplement or replace where community coverage is missing or inadequate.
- The user's aliases (gg=lazygit, cm=chezmoi, calc=eva, y=yazi, etc.) are referenced
  where relevant so the cheatsheet reminds them of shortcuts they already have.

## File Organization

| File              | Tools                                      |
|-------------------|--------------------------------------------|
| disk.cheat        | dua, dust, duf, tree                       |
| files.cheat       | fd, eza, yazi, zoxide, bat                 |
| search.cheat      | rg, fzf                                    |
| clipboard.cheat   | wl-copy, wl-paste                          |
| session.cheat     | tmux (light)                               |
| custom.cheat      | muxly, jdexr, gametrak                     |
| dev.cheat         | gh, just, lazygit, pre-commit              |
| dotfiles.cheat    | chezmoi, bob, tealdeer                     |
| pkg.cheat         | yay, flatpak, topgrade, reflector          |
| media.cheat       | yt-dlp, mpc, ncmpcpp, magick, nikon/gphoto2 |
| utils.cheat       | eva/calc, fx, glow, wget, 7zip             |
| system.cheat      | btop, fastfetch                            |
| fun.cheat         | cmatrix, cbonsai, pipes.sh, pokemon, sl, asciiquarium, vitetris, genact |
| shell-fu.cheat    | awk, sed, xargs pipeline patterns (fd/rg)  |

## User Context

- Arch Linux, Hyprland/Wayland, Ghostty terminal, zsh with Antidote
- Vim-style keybindings everywhere (hjkl)
- Muxly bound to Ctrl+O, lazygit to `gg`, chezmoi to `cm`/`ca`
- `ytdl` is a custom zsh function wrapping yt-dlp for mp3 download (macOS-only)
- `y` is a yazi wrapper that cd's on exit
- `prship` one-liner: push, create PR (--fill from commits), rebase-merge, delete branch, switch to main, pull
- `fun` alias lists all fun terminal tools
- genact is macOS-only (not installed on this machine)
- tealdeer (tldr) has basic coverage for most tools but user wants navi
  entries so they're discoverable via fzf without having to remember the tool name
