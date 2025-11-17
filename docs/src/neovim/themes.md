# Custom Color Themes

Custom and ported colorschemes

## Available Themes

### Dracula Recharged

**File**: `colors/dracula-recharged.lua`

A port of Chadracula - a modern take on the classic Dracula theme with enhanced contrast and refined colors.

```lua
require('dracula-recharged').load()
```

### Iced Lightning

**Files**: `colors/iced-lightning*.lua`

Cool-toned theme available in multiple variants (it's just [iceberg.vim](https://github.com/cocopon/iceberg.vim)):

- `iced-lightning.lua` - Base theme
- `iced-lightning-dark.lua` - Dark variant
- `iced-lightning-light.lua` - Light variant

```lua
require('iced-lightning').load()
```

## Usage

Themes are loaded via require statements that call the theme's `.load()` function. Each theme file contains minimal bootstrap code that delegates to the actual theme implementation.

## Structure

Each theme file follows the same pattern:

1. Import the theme module
2. Call `.load()` to activate
