# Neovim Configuration

My Neovim setup (bootstrapped with kickstart.nvim) with Lazy.nvim plugin management, custom extensions, and carefully selected color themes.

## Structure

- **Base configuration**: `modules/nvim/init.lua` - Entry point with Lazy.nvim setup
- **Custom extensions**: `modules/nvim/lua/cheatsheet/` - Interactive keymap browser
- **Color themes**: `modules/nvim/colors/` - Custom and ported colorschemes

## Features

- **Leader key**: Space (` `) for all custom mappings
- **Plugin management**: Lazy.nvim with automatic installation
- **Interactive cheatsheet**: `<leader>?` to browse all keymaps
- **Multiple themes**: Dracula Recharged and Iced Lightning variants
- **Nerd Font support**: Icons and symbols throughout UI

## Quick Start

Toggle cheatsheet with `<leader>?` to see all available keymaps organized by category.

## Extensions

- [Cheatsheet](./cheatsheet.md) - Interactive keymap browser
- [Color Themes](./themes.md) - Available colorschemes
