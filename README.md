<p align="center">
  <img src="https://github.com/JeysonFlores/switcher/blob/main/data/icons/128/com.github.jeysonflores.switcher.svg" alt="Icon" />
</p>
<h1 align="center">Switcher</h1>
<h4 align="center">Set default wallpapers for Pantheon's Dark & Light mode</h4>

<p align="center">
  <a href="https://appcenter.elementary.io/com.github.jeysonflores.switcher"><img src="https://appcenter.elementary.io/badge.svg" alt="Get it on AppCenter" /></a>
</p>

<p align="center">
  <a href="https://github.com/JeysonFlores/switcher/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/License-GPL3.0-blue.svg?style=for-the-badge">
  </a>
  <a href="https://github.com/JeysonFlores/switcher/releases">
    <img src="https://img.shields.io/badge/Release-v%201.0-blue.svg?style=for-the-badge">
  </a>
</p>

| ![Screenshot](https://github.com/JeysonFlores/switcher/blob/main/data/screenshots/screenshot-1.png) | ![Screenshot](https://github.com/JeysonFlores/switcher/blob/main/data/screenshots/screenshot-2.png) |


# Dependencies
    - 'glib-2.0'
    - 'gobject-2.0'
    - 'granite'
    - 'gtk+-3.0'
    - 'gdk-pixbuf-2.0'
    - 'libhandy-1 (>= 0.90.0)'

# Building & Run
  ```
    git clone https://github.com/JeysonFlores/switcher.git
    cd switcher
    flatpak-builder build com.github.jeysonflores.switcher.yml --user --install --force-clean
    flatpak run com.github.jeysonflores.switcher
  ```


# Acknowledgements
   - Thanks to the Elementary's Community Discord Server for the original idea.
