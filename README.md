# RomZipper

A Windows batch script that uses [7-Zip](https://www.7-zip.org/) to recursively compress supported cartridge ROMs from system subfolders into individual `.zip` archives.

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

The script will create a `ROMS compressed` subfolder with a matching subfolder for each system. Only `.nes`, `.gb`, `.gbc`, `.gg`, `.gba`, `.sfc`, `.smc`, `.md`, `.gen`, and `.nds` files are processed. Files in nested folders are also supported.

The command window displays the current system, ROM being processed, and a progress bar for that system. Existing output archives are skipped. The final summary shows the number of ROMs found, archives created, failures, skipped archives, original size, compressed size, and total space saved in MB.

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
