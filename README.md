# BOLT-LOVE, a demo game using LOVE2D

This project is a simple demo game created to learn and demonstrate the capabilities of the [LÖVE](https://love2d.org/) framework. The game, **BOLT-LOVE**, is a small arcade game where the player has to dodge procedurally generated lightning bolts.

## Technical Features

This demo is an idea that can serve as the basis for a learning project, showcasing some techniques:

### Procedural Generation

- **Procedural Lightning**: The main threat in the game, the lightning bolts, are not pre-rendered sprites. They are generated procedurally using algorithms that create segmented lines with random bifurcations. This creates a unique and unpredictable pattern every time. The lightning also has an electrical effect created by adding random noise to the line segments.

- **Procedural Audio**: The sound effects in the game are generated in real-time. Instead of using pre-recorded audio files, functions like `generateSound` create sounds like "laser", "explosion", "coin", and "hit" by generating waveform data on the fly. This is achieved by manipulating parameters like frequency and duration to produce unique sound effects directly from code.

### Matrix-based Sprites

- **Player and Animations**: The player character is not an image file. Its appearance and animations are defined by 16x16 matrices of 1s and 0s directly in the code (see `playerSprites` in `game/main.lua`). A custom function `drawSprite` reads these matrices and draws the character pixel by pixel on the screen. This is a classic technique reminiscent of early video games and is a great way to handle simple graphics without external assets.

## How to Play

- **Objective**: Dodge the yellow lightning bolts and collect the falling stars for points.
- **Controls**: Press `Space`, `Enter`, or the `arrow keys` (left/right) to change the player's direction. Mouse clicks also work.

## Screenshots

<div align="center">
  <p style="max-width:900px; margin:0 auto;">A few screenshots, click a thumbnail to open the full image.</p>
  <div style="margin-top:12px; overflow-x:auto; white-space:nowrap; padding:8px 4px; -webkit-overflow-scrolling:touch;">
    <a href="https://github.com/user-attachments/assets/f0b43911-fcff-4223-84e4-d92f06ffe275" target="_blank" rel="noopener">
      <img src="https://github.com/user-attachments/assets/f0b43911-fcff-4223-84e4-d92f06ffe275" width="280" style="display:inline-block; margin-right:8px; border-radius:8px; box-shadow:0 6px 18px rgba(0,0,0,0.12);" alt="screen1" />
    </a>
    <a href="https://github.com/user-attachments/assets/3c0d0a9b-80ff-41ac-b848-d18f29e9b48b" target="_blank" rel="noopener">
      <img src="https://github.com/user-attachments/assets/3c0d0a9b-80ff-41ac-b848-d18f29e9b48b" width="280" style="display:inline-block; margin-right:8px; border-radius:8px; box-shadow:0 6px 18px rgba(0,0,0,0.12);" alt="screen2" />
    </a>
    <a href="https://github.com/user-attachments/assets/621312d1-6436-4d6f-9b5e-732e376d7c27" target="_blank" rel="noopener">
      <img src="https://github.com/user-attachments/assets/621312d1-6436-4d6f-9b5e-732e376d7c27" width="280" style="display:inline-block; margin-right:8px; border-radius:8px; box-shadow:0 6px 18px rgba(0,0,0,0.12);" alt="screen3" />
    </a>
    <a href="https://github.com/user-attachments/assets/ef578ec9-5ac1-4b59-a575-8f4f285e551c" target="_blank" rel="noopener">
      <img src="https://github.com/user-attachments/assets/ef578ec9-5ac1-4b59-a575-8f4f285e551c" width="280" style="display:inline-block; margin-right:8px; border-radius:8px; box-shadow:0 6px 18px rgba(0,0,0,0.12);" alt="screen4" />
    </a>
    <a href="https://github.com/user-attachments/assets/ec48ab4a-0e21-472e-8a21-95f60e82dd1b" target="_blank" rel="noopener">
      <img src="https://github.com/user-attachments/assets/ec48ab4a-0e21-472e-8a21-95f60e82dd1b" width="280" style="display:inline-block; margin-right:8px; border-radius:8px; box-shadow:0 6px 18px rgba(0,0,0,0.12);" alt="screen5" />
    </a>
  </div>
</div>


