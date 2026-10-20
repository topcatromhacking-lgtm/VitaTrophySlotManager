# PS Vita 100 Trophy Limit Workaround: Vita Trophy Slot Manager (TopCat MOD)

**Keep more than 100 games' trophy histories on a PS Vita without permanently deleting older local trophy data.** Vita Trophy Slot Manager is an experimental **local archive / restore workaround** for the PS Vita **100 trophy-title limit**. It is a modification of [ONElua Team's Trophy Manager](https://github.com/ONElua/TrophyManager), not a system-level patch that raises Sony's limit.

**Looking for a solution to "PS Vita 100 trophies limit", "maximum 100 trophy titles", or "cannot launch game because trophy list is full"?** The idea is to **archive a trophy title before adding another**, then restore it later when you have a free active slot.

> **Experimental homebrew. Back up your trophy data first.** This app modifies console trophy folders and the local trophy database. A failed copy, interrupted operation, database rebuild or synchronization could cause data loss. The archive is not a substitute for an independent backup.

## The problem: only 100 active trophy titles

On PS Vita, the trophy system has a 100-title limit. With a full local list, starting an additional trophy-enabled game can be blocked until a title is removed. This is particularly troublesome for users who play offline or wish to preserve old, unsynchronized trophies.

The original ONElua Trophy Manager offered trophy viewing and deletion. This TopCat modification adds an alternative: **hide/archive rather than permanently delete.** It changes the *number of locally active trophy titles*, **not** the console's underlying hardcoded limit.

### How the workaround works

The app presents two lists:

**ACTIVE:** Trophy sets in the normal local trophy folders. They count toward the 100-title limit.

**HIDDEN / ARCHIVED:** Trophy sets moved to `ux0:data/ONETROPHY/archive/` and removed from active storage. These are preserved for possible later restoration and do not occupy active trophy slots.

For example, starting with 100 active titles, archive three older titles to leave 97 active slots. You can then introduce new trophy-enabled games. When you want an archived set back, first make room in the active list and use **Unhide**. The app refuses to unhide at 100 active titles.

**This is a local storage-management workaround.** It does not unlock trophies, edit trophy awards, bypass PlayStation Network requirements, guarantee PSN synchronization, or allow more than 100 *simultaneously active* local trophy titles.

## Download and release history

**TopCatRH MOD (experimental, shared July 2, 2026).**

- [Original GBAtemp discussion and public MOD announcement](https://gbatemp.net/threads/wip-ps-vita-trophy-archive-manager-workaround-for-the-100-trophy-title-limit.681990/)
- [Original TopCatRH MOD download linked in the GBAtemp release post](https://www.mediafire.com/file/473nz1qlpugdqbh/TrophySlotManager_TopCatRH_MOD.zip/file)
- [Original ONElua Trophy Manager project](https://github.com/ONElua/TrophyManager)

**GitHub mirror status:** the original MOD VPK is available through the release link above. The binary has not yet been added as a GitHub release asset. The supplied VPK has been inspected, and the original MOD binary (11,670,066 bytes) has SHA-256:
`c08fca8ac1b6fe10fd561a97d383c25fa573f5759fa804e93851bc29800b2ac5`.
This checksum identifies the user-supplied VPK; it has **not** been independently compared with the file hosted on MediaFire.

The VPK reports the inherited ONElua application version **1.03** in `sce_sys/param.sfo`. This should **not** be mistaken for a separate, officially numbered TopCat release.

## Controls

| Button | Action |
| --- | --- |
| **L / R** | Switch between Active and Hidden trophy lists |
| **Square** | Hide/archive selected Active title, or restore selected Hidden title |
| **Triangle** | Permanently delete the selected trophy data, **including an archived entry if selected in Hidden** |
| **Start** | Refresh lists; if trophy database changes are pending, follow the offline database-update flow |
| **Select** | Sort titles |
| **Cross / Circle** | Select/back according to the Vita's regional accept/cancel mapping |

The upper-right counter displays `active / 100` in Active view. Restoration is blocked once 100 active trophy titles are present.

## Install and use cautiously

Use a compatible homebrew-enabled PS Vita or PSTV capable of installing VPK files. Download the original MOD, extract the VPK, install it with your normal VPK installer, and **disable Wi-Fi before running or rebuilding the trophy database**. Preserve an external backup of your current trophy data before trying Hide, Unhide, Delete, or any database rebuild.

To free a trophy slot, open Active, select the old title, press **Square** and confirm. The app copies trophy icons/configuration/data to the archive, removes the active folders when the copy succeeds, updates its archive index, and flags the trophy database for refresh. After rebuilding the database as directed by the app, test the list before launching a new trophy-enabled game. To restore, make room (fewer than 100 active titles), go to Hidden, select the title, and press **Square**.

The working archive root and index are:
```text
ux0:data/ONETROPHY/archive/
  icons/
  conf/
  data/
  index.txt
```

**Important:** If you use an older build, switching builds or restoring previous archives may require additional precautions. Do not erase the archive folder. **Triangle means permanent deletion, not temporary hiding.** Never interrupt file operations or assume that seeing an entry in the list means every file has been checked byte-for-byte.

### Known experimental caveats

- The app changes trophy folders under `ur0:` and `ux0:`, and uses a local database rebuild. The code checks whether destination directories exist after copying, but does not verify each copied file against a cryptographic checksum.
- The inherited ONElua updater is still present. It points to the **original upstream update endpoint**, which is not a TopCat MOD update channel. **Avoid accepting upstream update prompts**, as an upstream package could replace the modification.
- The original July MOD VPK contains an embedded duplicate/older `TrophySlotManager/` tree and a nested VPK. The main root-level Lua scripts are the more recent MOD implementation. Do not mix the older embedded sources with the primary source.
- This release has **not** been independently validated across every firmware, emulator, game, PSN scenario, or console configuration. Report issues with steps to reproduce; do not share other users' trophy or account data.

## Technical implementation

The main code changes are in `system/commons.lua` (archiving, restoration, archive index, safeguards) and `system/trophies_title.lua` (Active/Hidden UI, 100-slot counter, hide/restore operations, duplicate-state protection, and database refresh). The archive index is text-based. The code prevents restoring when `#trophyT >= 100`.

The intent is to preserve the active/archived trophy data locally, not to patch Sony's firmware or circumvent server-side rules. Code and logic can be audited in the readable Lua scripts packaged within the supplied VPK. The verified [Lua source tree](source/) has now been published in this repository. The two core files are [archive management](source/system/commons.lua) and [trophy list / UI](source/system/trophies_title.lua); see [source provenance](SOURCE-NOTES.md) for byte-level validation and packaging details. All 15 root-level Lua/text files were verified against the original historical VPK by matching Git blob SHA-1 IDs.

## Credits and license

**Original foundation:** [ONElua Team / Gdljjrod, Trophy Manager](https://github.com/ONElua/TrophyManager). The ONElua app itself credits **Silica** for Trophax, and **WZ-JK** for graphical assets.

**TopCat / TopCatRH:** local archive/restore modification, Active and Hidden lists, explicit 100-title safeguards, integration, debugging, and documentation.

The Lua source headers identify **GNU General Public License v3.0**. This is an unofficial, noncommercial community modification, not an official Sony, PlayStation, or ONElua release. Preserve upstream authorship and license notices when redistributing modified code. The upstream interpreter/runtime and artwork retain their respective attribution and applicable licensing.

## Feedback

The [GBAtemp discussion](https://gbatemp.net/threads/wip-ps-vita-trophy-archive-manager-workaround-for-the-100-trophy-title-limit.681990/) documents the original concept and July 2026 release. Use GitHub issues to report failures with active-title count, selected action, whether Wi-Fi was disabled, firmware/platform details, and what happened after the trophy database refresh. Do **not** submit private backups or PSN information.
