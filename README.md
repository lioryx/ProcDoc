# ProcDoc

**ProcDoc** is a lightweight World of Warcraft (Turtle WoW / Vanilla) addon that shows pulsing visuals whenever your character gains an instant-cast or free-cast buff—like Clearcasting, Shadow Trance, Overpower, etc. It automatically detects procs and displays on-screen alerts in a fun and noticeable way.

---

## Key Features

1. **Visual Alerts for Procs**  
   Displays large, pulsing textures around or above your character whenever a supported proc is active.

2. **Two Alert Styles**  
   - **SIDES**: Two vertical textures flanking your character.  
   - **TOP**: A single, wider texture above your character’s head.

3. **Multiple Buff Support**  
   Supports many instant/free-cast buff procs (e.g. Shadow Trance, Clearcasting, Overpower), each with unique textures and placement.

4. **No Manual Setup Needed**  
   Simply install and go—proc detection is automatic. An in-game options panel (via `/procdoc`) lets you test custom visuals and tweak appearance settings.

---

## Installation

1. **Download or Clone** the **`ProcDoc`** addon folder into your WoW `AddOns` directory.  
2. Confirm the folder is named **`ProcDoc`** and contains:
   - `ProcDoc.lua`
   - `ProcDoc.toc`
   - An `img` folder with `.tga` (and optional `.png`) images.
3. **Restart** or **Reload** your WoW client.
4. (Optional) Type **`/procdoc`** in-game to open the settings/test panel.

---

## How to Use

1. **Log In**: Enter the game with any class that has procs (Warrior, Mage, Priest, etc.).
2. **Trigger a Proc**: Cast spells or fight until you get an “instant cast” buff (e.g. Clearcasting).
3. **See the Alert**: Pulsing textures appear in the chosen style (**SIDES** or **TOP**).
4. **Buff Ends**: The alert automatically disappears when the buff expires.

**Done!** You can also open the addon’s panel with **`/procdoc`** to test procs, modify transparency, or adjust offsets.

---

## Example Alerts

1. **Warlock Shadow Trance**  
   ![Warlock Shadow Trance](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Warlock.png)

2. **Mage Clearcasting, Arcane Surge**  
   ![Mage Arcane Surge](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Mage.png)

3. **Warrior Overpower**  
   ![Warrior Overpower](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Warrior.png)

Loads of others as well!

---

## Configuration

- **Min/Max Transparency**: Controls how faint or bright the pulsing effect can get.
- **Min/Max Size**: Changes how small or large the images become during pulsing.
- **Pulse Speed**: Adjusts how quickly the images fade in/out.
- **Offsets**: Shifts the alerts vertically (top) or horizontally (sides).

You can experiment with these in the **`/procdoc`** panel. Changes are saved automatically.

![Configuration](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Config.png)

---

## Known Procs

ProcDoc supports a variety of class buffs, such as:
- **Warlock**: Shadow Trance
- **Mage**: Clearcasting, Temporal Convergence, Flash Freeze, Arcane Surge
- **Warrior**: Enrage, Overpower
- **Druid**: Clearcasting, Nature’s Grace
- **Rogue**: Remorseless, Riposte
- **Shaman**: Clearcasting
- **Priest**: Resurgence, Enlightened, Searing Light
- **Hunter**: Quick Shots
*(And more can be added in the code.)*

---

## License

Feel free to use, modify, or share **ProcDoc**. A mention or credit is welcome but not required. Enjoy your new proccing visuals!
