# Lab 1 Animated Slides (Motion Canvas)

This project now animates all Lab 1 exercises except the floating-point section.

## Run

```bash
npm install
npm start
```

Open the local URL shown by Vite.

## Slide navigation

- Open Motion Canvas presenter mode in the browser.
- Use arrow keys (`Left` / `Right`) to move between slide stops and scenes.

## File map

- `src/project.ts`: scene order
- `src/scenes/01-title.tsx`: scope and navigation intro
- `src/scenes/02-lab1-full.tsx`: full non-floating walkthrough
- `src/scenes/helpers.tsx`: reusable frame and reveal helpers
- `src/styles.ts`: colors, fonts, pacing
