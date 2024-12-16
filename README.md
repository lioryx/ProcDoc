# ProcDoc

**ProcDoc** is a simple World of Warcraft (Turtle WoW / Vanilla) addon that displays flashy, pulsing alerts whenever you gain specific “instant cast” or “free cast” procs (e.g. Shadow Trance, Clearcasting). The alerts can appear in **two styles**:

1. **SIDES** – Two vertical textures on either side of your character (like glowing wings).
2. **TOP** – A single texture anchored above your character’s head (wider, banner-like).

With ProcDoc, if multiple procs are active at the same time, you’ll see separate pulsing effects for each proc.

---

## How It Works

- **Detect Procs**: The addon automatically checks if your character has any known instant/free-cast buffs.
- **Show Alerts**: For each buff detected, ProcDoc displays **pulsing textures**:
  - If the buff is configured to show on the sides, you’ll see **two** textures to the left and right of your character.
  - If the buff is configured to show on top, you’ll see **one** texture above your character’s head.
- **Pulsing Effects**: The textures smoothly fade in and out while slightly scaling, creating a dynamic alert effect.
- **Multiple Procs**: If multiple buffs are active, each one shows its own alert style (some may be sides, some may be top).

---

## What the User Will See

### Single Proc (SIDES)
If you have a proc that uses the **SIDES** style (e.g. Shadow Trance for a Warlock), two matching TGA images appear on the left and right of your character. They’ll pulse in brightness and size until the proc buff expires, then vanish automatically.

### Single Proc (TOP)
If a buff is configured to appear **above** the character (like Warrior’s Flurry), you’ll see a single wide texture floating above your character’s head, pulsing until the buff expires.

### Multiple Procs
If you gain two or more special buffs at once (e.g. Warrior’s Enrage **and** Flurry), you might see both styles simultaneously: two vertical textures on the sides for one buff, plus a single wide texture up top for another buff.

---

## Installation

1. **Download** or **Clone** the ProcDoc addon folder into your Turtle WoW/Vanilla WoW `AddOns` directory.  
2. Ensure the folder name is **`ProcDoc`** and contains:
   - `ProcDoc.lua`
   - `ProcDoc.toc`
   - An `img` subfolder with various `.tga` files for the alert visuals.
3. **Restart** or **Reload** the game client.  
4. Open **AddOns** in the character screen or in-game to verify **ProcDoc** is enabled.

---

## Usage

Once installed and active:

1. **Log in** to your character (Mage, Warlock, Warrior, etc.).
2. **Trigger** a known proc (e.g. cast spells until **Clearcasting** procs, or attack until **Flurry** procs).
3. **Observe** the pulsing alert textures around or above your character when the proc is active.
4. When the buff wears off, the alerts automatically hide.

**That’s it!** There are no in-game slash commands or manual settings needed. The addon just works in the background.

---

## Alerts

**1. Warlock Shadow Trance**

![Warlock](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Warlock.png)

**2. Mage Clearcasting and Temporal Convergence**

![Mage](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Mage.png)

**3. Druid Clearcasting**

![Druid](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Druid.png)

**4. Shaman Clearcasting**

![Shaman](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Shaman.png)

**5. Hunter Quick Shots**

![Hunter](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Hunter.png)

**6. Warrior Enrage and Flurry**

![Warrior](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Warrior.png)

**7. Rogue Remorseless Attacks**

![Rogue](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Rogue.png)


---
## License

 Feel free to use and share **ProcDoc** as you like. A mention or link back is always appreciated but not required. Enjoy your new proccing visuals!