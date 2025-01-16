# ProcDoc

**ProcDoc** is a lightweight World of Warcraft (Turtle WoW / Vanilla) addon that shows pulsing visuals whenever your character gains an instant-cast or free-cast buff—like Clearcasting, Shadow Trance, Overpower, etc. It automatically detects procs and displays on-screen alerts in a fun and noticeable way.

---

## Key Features

1. **Visual Alerts for Procs**  
   Displays large, pulsing textures around or above your character whenever a supported proc is active.

2. **Multiple Buff Support**  
   Supports many instant/free-cast buff procs (e.g. Shadow Trance, Clearcasting, Overpower), each with unique textures and placement.

3. **No Manual Setup Needed**  
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

## Configuration

- **Min/Max Transparency**: Controls how faint or bright the pulsing effect can get.
- **Min/Max Size**: Changes how small or large the images become during pulsing.
- **Pulse Speed**: Adjusts how quickly the images fade in/out.
- **Offsets**: Shifts the alerts vertically (top) or horizontally (sides).

You can experiment with these in the **`/procdoc`** panel. Changes are saved automatically.

![Configuration](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Config.png)

---

## Supported Procs

ProcDoc supports a variety of procs and alerts when key abilities or buffs become available for each class. Below is a list of currently supported procs:

### **Warlock**
![Warlock](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Warlock.png)
- **Shadow Trance**: Procs from Nightfall, allowing an instant Shadow Bolt cast.


### **Mage**
![Mage](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Mage.png)
- **Clearcasting**: Grants a free spell cast (Arcane Concentration proc).
- **Netherwind Focus**: Part of the Netherwind set bonus, increases spell efficiency.
- **Temporal Convergence**: Unique Mage buff (custom to Turtle WoW).
- **Flash Freeze**: Enhances Frost-based spells (custom to Turtle WoW).
- **Arcane Surge**: Boosts Arcane damage (custom to Turtle WoW).


### **Warrior**
![Warrior](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Warrior.png)
- **Enrage**: Triggered after being critically hit, increases physical damage.
- **Overpower**: Becomes available after the target dodges.
- **Execute**: Becomes available when the target's health drops below 20% (25% with talents).


### **Druid**
![Druid](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Druid.png)
- **Clearcasting**: Grants a free attack or spell (Omen of Clarity proc).
- **Nature’s Grace**: Reduces the cast time of the next spell after landing a critical hit.


### **Rogue**
![Rogue](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Rogue.png)

- **Remorseless**: Increases critical strike chance after killing an enemy.
- **Riposte**: Becomes available after parrying an attack.


### **Shaman**
![Shaman](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Shaman.png)

- **Clearcasting**: Grants a free spell cast (via Elemental Focus talent).


### **Priest**
![Shaman](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Shaman.png)
- **Resurgence**: Unique Priest proc (custom to Turtle WoW).
- **Enlightened**: Provides a temporary boost to abilities (custom to Turtle WoW).
- **Searing Light**: Increases damage for specific spells (custom to Turtle WoW).


### **Hunter**
![Hunter](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Hunter.png)
- **Quick Shots**: Increases attack speed (via Improved Aspect of the Hawk talent).
- **Counterattack**: Becomes available after parrying an attack.
- **Mongoose Bite**: Becomes available after dodging an attack.


### **Paladin**
![Paladin](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Paladin.png)
- **Hammer of Wrath**: Becomes available when the target is below 20% health (Turtle WoW addition).


### Additional Notes
- The list includes both classic procs and custom procs unique to Turtle WoW.
- New procs and alerts can easily be added by modifying the configuration in the `PROC_DATA` and `ACTION_PROCS` tables in the code. That, or hit me up and I can add it to the main addon!


---

## License

Feel free to use, modify, or share **ProcDoc**. A mention or credit is welcome but not required. Enjoy your new proccing visuals!
