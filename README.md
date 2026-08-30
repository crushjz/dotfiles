# dotfiles

My personal dotfiles.

> dotfiles: configuration files that are used to customize and personalize your system.

# Tools

- [Aerospace](https://aerospace.dev/) as the tiling window manager (MacOS).
- [Ghostty](https://ghostty.org/) as the terminal emulator.
- [Zsh](https://www.zsh.org/) as the shell.
- [GNU Stow](https://www.gnu.org/software/stow/) to manage the dotfiles symlinks.
- [Neovim](https://neovim.io/) as the main text editor.
- [tmux](https://github.com/tmux/tmux/wiki) as the terminal multiplexer.
- [lazygit](https://github.com/jesseduffield/lazygit) as terminal UI for git commands.

# Installation

Clone the repository into your home directory and enter it:

```bash
git clone <repository-url> "$HOME/dotfiles"
cd "$HOME/dotfiles"
```

Preview and install all managed packages:

```bash
stow -n -v aerospace ghostty karabiner kitty lazygit nvim starship tmux zsh
stow aerospace ghostty karabiner kitty lazygit nvim starship tmux zsh
```

Install only selected packages by passing their names to Stow:

```bash
stow zsh tmux nvim
```

## Stow Packages

Each managed tool is an independent GNU Stow package. The package directory
mirrors the path where its files belong under `$HOME`:

```text
aerospace/.config/aerospace/
ghostty/.config/ghostty/
karabiner/.config/karabiner/
kitty/.config/kitty/
lazygit/.config/lazygit/
nvim/.config/nvim/
starship/.config/starship.toml
tmux/.tmux.conf
zsh/.zshrc
```

The repository does not symlink the entire `~/.config` directory. Instead,
`~/.config` is a normal directory containing the selected Stow-managed links
alongside unmanaged application configuration.

Manage individual packages as needed:

```bash
stow nvim
stow -D ghostty
```
