# Rom Zipper Plus

A feature-enhanced fork of the original [RomZipper](https://github.com/ItsRetroPup/RomZipper). Rom Zipper Plus uses [7-Zip](https://www.7-zip.org/) to recursively compress supported cartridge ROMs from system subfolders into individual `.zip` archives.

## What is different from the original?

Compared with the original main version, Rom Zipper Plus adds:

- Top-level ROM folder support with one subfolder per system
- Recursive scanning of nested system folders
- Alphabetical system-folder processing
- A supported ROM extension filter, so unrelated files are ignored
- Support for Atari 2600, Game Gear, Nintendo 64, Neo Geo Pocket, PC Engine, Sega 32X, Sega Master System, Virtual Boy, WonderSwan, and WonderSwan Color formats, in addition to the original systems
- Compression level 5 by default for a balance between speed and archive size
- Existing-archive detection, so previously compressed ROMs are skipped
- Live system and ROM status messages with a per-system progress bar
- Final results showing created, failed, and skipped archives plus size savings in MB
- Output folders created only for systems that contain archives
- `RemoveEmptyFolders.bat` for cleaning empty folders beneath the ROMs directory

The original version compresses all files in a single folder. Rom Zipper Plus is designed for an organized ROM collection with separate system folders.

These changes were made for my own ROM-management workflow. If you have feedback or ideas for improvement, please email [hello@williamgrullon.com](mailto:hello@williamgrullon.com).

## Requirements

- Windows
- [7-Zip](https://www.7-zip.org/) installed

## Usage

1. Place `RomZipper.bat` in the top-level ROMs folder, with one subfolder per system (for example, `NES`, `Game Boy`, or `GBA`)
2. Open the script in a text editor and update the `zipExe` path if 7-Zip is not installed in the default location:
   ```bat
   set "zipExe=C:\Program Files\7-Zip\7z.exe"
   ```
3. Double-click the script to run it

The script will create a `ROMS compressed` subfolder and matching system subfolders only when that system has an archive to place there. System folders are processed in alphabetical order. Supported extensions are `.26`, `.a26`, `.z64`, `.nes`, `.gb`, `.gbc`, `.gg`, `.gba`, `.sfc`, `.smc`, `.md`, `.gen`, `.nds`, `.ngp`, `.pce`, `.32x`, `.sms`, `.vb`, `.ws`, and `.wsc`. Files in nested folders are also supported.

The command window displays the current system, ROM being processed, and a progress bar for that system. Existing output archives are skipped. The final summary shows the number of ROMs found, archives created, failures, skipped archives, original size, compressed size, and total space saved in MB.

To remove empty folders beneath the ROMs folder, double-click `RemoveEmptyFolders.bat`. It scans recursively and leaves the folder containing the script intact.

## Notes

- Only processes supported cartridge ROM extensions; other files are ignored
- Compression is set to level 5 (normal) — a good balance for raw ROM files; already-compressed formats such as `.chd`, `.cso`, and `.rvz` typically gain little from further compression
- Supports filenames containing special characters like `!`

## Compression Levels

To change the compression level, edit this line in the script:

```bat
set "COMPRESSION_LEVEL=5"
```

| Level | Description |
|-------|-------------|
| 1 | Fastest |
| 3 | Fast |
| 5 | Normal |
| 7 | Maximum |
| 9 | Ultra |
