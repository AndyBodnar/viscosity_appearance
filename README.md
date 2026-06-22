# viscosity_appearance

**Viscosity Appearance** — a player customization suite for FiveM (clothing, barber,
tattoos, surgeon) with a fully rebuilt, animated violet-glass NUI. This is my reworked
distribution of [illenium-appearance](https://github.com/iSentrie/illenium-appearance),
with a from-scratch React front-end and Viscosity Gaming Studio branding, wired to
[viscosity_core](https://github.com/AndyBodnar/viscosity_core).

---

## Features

- **Full customization** — heritage/face, hair & barber, clothing, props, tattoos, and
  surgeon, all in one flow.
- **Rebuilt UI** — a from-scratch React NUI with smooth animation and a tokenized violet
  theme, not a recolor.
- **Framework-native** — runs on `viscosity_core` (also supports the common frameworks
  via the underlying adapter).
- **Shops & outfits** — clothing/barber/tattoo shops, saved outfits, and management
  hooks.

---

## Requirements

- [viscosity_core](https://github.com/AndyBodnar/viscosity_core)
- ox_lib

## Installation

1. Drop `viscosity_appearance` into `resources`.
2. Import the SQL in `sql/`.
3. Ensure it **after** the core + ox_lib:
   ```cfg
   ensure ox_lib
   ensure viscosity_core
   ensure viscosity_appearance
   ```

---

## Credits & License

Built on **illenium-appearance** by **snakewiz**, licensed under the **MIT License**.
The original copyright and MIT terms are retained in [`LICENSE`](LICENSE). The React NUI
rework, Viscosity branding, and framework integration are my additions on top of that
work.

This project remains MIT-licensed.
