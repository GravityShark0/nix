{ pkgs }:

with pkgs;
[
  # discord-canary
  emacs
  ghostty # Terminal
  mcontrolcenter # MSI

  # File viewer
  evince # Documents
  foliate # Epub
  vlc # Videos + Music

  # Media creation
  gnome-sound-recorder
  # kdePackages.kdenlive # Video editor (I should enable gpu when using this)
  krita # Drawing

  # School
  anki
  # libreoffice-fresh # Basic office utilities
  telegram-desktop
  zoom-us
]
