# Source provenance and audit notes

This source tree is a byte-for-byte copy of the **root-level Lua/text scripts** embedded in the user-supplied `TrophySlotManager.vpk` (11,670,066 bytes; SHA-256 `c08fca8ac1b6fe10fd561a97d383c25fa573f5759fa804e93851bc29800b2ac5`).

The VPK is a ZIP-format package. It contains a second, older `TrophySlotManager/` folder and a nested `TrophySlotManager.vpk` in addition to the root files. **Only the outer root-level script files are mirrored here.** Do not substitute the older nested versions of `system/commons.lua` or `system/trophies_title.lua` for the root-level files.

The original executable binary (`eboot.bin`), packaged assets (`resources/`, SFO and icons), and the duplicated nested VPK are not reproduced in `source/`. They remain inside the historic VPK distribution, linked in the main README. This is a historical source mirror, **not a self-contained reproducible build system**.

The main MOD functionality resides in:
- `source/system/commons.lua`: local trophy archive structure, text index, hide/restore operations and duplicate guards; declares `ACTIVE_TROPHY_LIMIT = 100`.
- `source/system/trophies_title.lua`: Active/Hidden lists, explicit `N/100` counter, Square archive/restore, Triangle permanent deletion, offline database-refresh flow and stale-record guards.

All other source files are inherited from ONElua Trophy Manager. The individual Lua headers identify GNU GPL v3, and the repository contains the complete license text. Credits and original links are in the main README.

**Runtime caution:** `source/script.lua` still runs the inherited `git/updater.lua` when network strength is sufficient. That updater points to ONElua's own update endpoint and is **not** a valid update system for TopCat's MOD. Do not accept an upstream update prompt if your intent is to keep the archiving features.

The VPK and the original ZIP were successfully decompressed and ZIP CRC-checked; this was a static package and source inspection, **not a new PS Vita gameplay validation**.
