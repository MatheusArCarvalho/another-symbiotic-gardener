# Another Symbiotic Gardener

Short: a small Godot (GDScript) puzzle/strategy project about placing plants in a grid to create beneficial symbiosis.

Quick start
-----------
1. Install Godot 4.x (recommended).
2. Open this project folder in Godot (open the `project.godot` file).
3. Ensure the `GameManager` autoload is configured (Project Settings → Autoload):
   - Path: `scripts/autoloads/game_manager.gd`
   - Name: `GameManager`
4. Ensure the main scene is set to `scenes/main/main.tscn` (Project Settings → Run → Main Scene) or open that scene manually.
5. Press Play in the editor to run the project.

Optional CLI (Windows PowerShell)
--------------------------------
If you have the Godot executable on PATH or call it directly, you can open the project from PowerShell:

```powershell
# If 'godot' is on PATH
godot -e "C:\Users\gtama\Documents\Godot\Projects\another-symbiontic-gardener\another-symbiotic-gardener"

# Or call the Godot exe directly (adjust path to your Godot installation)
"C:\Program Files\Godot\Godot.exe" -e "C:\Users\gtama\Documents\Godot\Projects\another-symbiontic-gardener\another-symbiotic-gardener"
```

Project structure (high level)
------------------------------
- `project.godot` — Godot project file
- `scenes/` — scene files (grid, tiles, plants, main, UI)
- `scripts/` — GDScript files (autoloads/game_manager.gd, plant base, tile, ui, main controller, etc.)
- `documetation/doc.txt` — Expanded developer documentation

Notes for developers
--------------------
- The `GameManager` autoload holds the logical grid and is responsible for the Resolve step.
- `Grid` handles visual tile generation and placement.
- `Plant` base script stores `provides`/`needs` arrays and `update_symbiosis()` logic.

If you'd like, I can also:
- add a short `documetation/DEV_SETUP.md` focused on developer setup,
- generate a text diagram of scenes and node relationships, or
- add example plant scenes to `scenes/plants/` for testing.

Author / Contact
----------------
MatheusArCarvalho
