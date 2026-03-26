```markdown
# Design System Strategy: Urban Nostalgia & The Golden Hour

## 1. Overview & Creative North Star
**The Creative North Star: "The Asphalt Explorer"**
This design system rejects the clinical, "too-perfect" minimalism of modern SaaS. Instead, it captures the raw, sun-drenched energy of a city at 4:00 PM—the early 2000s urban aesthetic where grit meets optimism. We are building a "Digital Scrapbook of the Streets."

To break the "template" look, we utilize **Intentional Asymmetry**. Containers should rarely be perfectly aligned; a 1-degree rotation or a slight offset creates the "sticker-slapped" feel of a skate park. We use high-contrast typography scales—pairing massive, "loud" display headers with hyper-clean, technical labels—to mimic the juxtaposition of street graffiti on city signage.

---

## 2. Colors: The Sun-Drenched Palette
Our palette isn't just a set of hex codes; it’s a lighting environment. 

- **Primary (`#954400`) & Primary Container (`#ff7b04`):** These represent the "Sun-drenched Orange." Use the Container for high-energy backgrounds and the Primary for interactive depth.
- **Secondary (`#b12121`):** The "Warm Brick Red." Reserved for urgency, grit, and character-driven accents.
- **Tertiary (`#0f6b00`):** The "Neon Pop." This is our graffiti tag—use it sparingly for "Success" states or high-visibility highlights.
- **Surface & Background (`#f8f6f5`):** Not a sterile white, but a warm, paper-like neutral that feels like sun-bleached concrete.

**The "No-Line" Rule:** 
Strictly prohibit 1px solid borders for sectioning. We define space through color blocking. A `surface-container-low` section sitting on a `surface` background is the only way to denote a change in context. 

**The "Glass & Gradient" Rule:** 
To add "soul," use subtle linear gradients on CTAs: `primary` (bottom-left) to `primary-container` (top-right). For floating "sticker" menus, use Glassmorphism: `surface-container-lowest` at 80% opacity with a `20px` backdrop-blur to let the "urban" background colors bleed through.

---

## 3. Typography: Loud & Clear
We balance the "Jet Set Radio" energy with technical legibility.

- **Display & Headline (Plus Jakarta Sans):** These are our "Power Fonts." Use `display-lg` (3.5rem) for hero moments. The rounded terminals of Plus Jakarta Sans provide that "cartoonish but high-quality" vibe. Tighten the letter-spacing (`-0.02em`) for headlines to make them feel like heavy stickers.
- **Title & Body (Work Sans):** Our "Workhorse." Work Sans is clean and grounded, ensuring the UI remains usable even when the surrounding aesthetics are loud.
- **Labels (Space Grotesk):** We use Space Grotesk for technical data and labels. Its slightly quirky, monospaced-adjacent feel mimics the "marker pen" notations on a city map.

---

## 4. Elevation & Depth: Tonal Layering
Traditional shadows are too "software-like." We use **Physical Layering.**

- **The Layering Principle:** 
  - Level 0: `background` (The street).
  - Level 1: `surface-container-low` (The sidewalk).
  - Level 2: `surface-container-highest` (The raised platform/card).
- **Ambient Shadows:** 
  If an element must "float" (like a floating action button), use an extra-diffused shadow: `offset: 0 12px, blur: 32px, color: rgba(149, 68, 0, 0.08)`. Notice we use a tint of our `primary` color for the shadow, not black, to maintain the "sunny" vibe.
- **The "Ghost Border" Fallback:** 
  If accessibility requires a container edge, use `outline-variant` at 15% opacity. It should feel like a faint pencil mark, not a hard stroke.

---

## 5. Components: The Urban Kit

### Buttons (The "Tape" Aesthetic)
- **Primary:** `primary-container` background with `on-primary-container` text. Apply a `md` (1.5rem) corner radius. 
- **Interaction:** On hover, shift to `primary-fixed-dim`. 
- **Signature Detail:** Add a "tape" effect—a small rectangle of `surface-variant` at 40% opacity overlapping the corner of the button to make it look "stuck" to the screen.

### Chips (The "Sticker" Aesthetic)
- Use `full` (9999px) roundedness. 
- **Unselected:** `surface-container-high` with `on-surface-variant` text.
- **Selected:** `tertiary-container` with `on-tertiary-container` text. This provides that "Neon Pop" against the asphalt.

### Input Fields (The "Marker" Aesthetic)
- No borders. Use `surface-container-highest` as the fill.
- Focus state: A thick (3px) `surface-tint` underline, mimicking a heavy marker stroke.
- Labels: Always use `label-md` (Space Grotesk) in `outline` color.

### Cards & Lists (The "Stacked Paper" Aesthetic)
- **Forbid dividers.** Use `3.5rem` (Spacing 10) of vertical white space to separate list items.
- Cards use `lg` (2rem) roundedness and `surface-container-lowest`. 
- Overlap a "Handwritten Tag" (a small italicized text component using a Tertiary color) across the card’s top-right edge to break the grid.

---

## 6. Do’s and Don'ts

### Do:
- **Use "Bandage" Elements:** Use small, high-radius rectangles (Color: `secondary-fixed`) to "patch" corners of images or containers.
- **Embrace the Tilt:** Rotate decorative images or stickers by 1–3 degrees to create energy.
- **Stack Surfaces:** Put a `surface-container-lowest` card inside a `surface-container-low` section.

### Don’t:
- **Don’t use Black (#000000):** Use `on-background` (`#2e2f2f`) for text. Pure black kills the "nostalgic sun" warmth.
- **Don’t use 1px Lines:** Dividers and borders make the UI feel like a spreadsheet. Use spacing or color shifts instead.
- **Don’t Center Everything:** The "explorer" vibe is active. Use left-aligned, heavy-weighted layouts to create a sense of forward motion.

### Accessibility Note:
While we use a "nostalgic" palette, ensure all text on `primary-container` and `secondary-container` passes WCAG AA contrast ratios. Use the `on-primary-container` and `on-secondary-container` tokens specifically designed for this purpose.```