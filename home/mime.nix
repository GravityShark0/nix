{ ... }:

{
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = [ "zen.desktop" ];
    "x-scheme-handler/https" = [ "zen.desktop" ];
    "x-scheme-handler/chrome" = [ "zen.desktop" ];
    "text/html" = [ "zen.desktop" ];
    "application/x-extension-htm" = [ "zen.desktop" ];
    "application/x-extension-html" = [ "zen.desktop" ];
    "application/x-extension-shtml" = [ "zen.desktop" ];
    "application/xhtml+xml" = [ "zen.desktop" ];
    "application/x-extension-xhtml" = [ "zen.desktop" ];
    "application/x-extension-xht" = [ "zen.desktop" ];
    "text/x-bibtex" = [ "nvim.desktop" ];
    "application/pdf" = [ "zen.desktop" ];
    "image/png" = [ "org.gnome.Loupe.desktop" ];
    "text/plain" = [ "nvim.desktop" ];
    "image/gif" = [ "org.gnome.Loupe.desktop" ];
    "text/org" = [ "emacsclient.desktop" ];
    "text/x-pascal" = [ "nvim.desktop" ];
    "text/x-csrc" = [ "nvim.desktop" ];
    "image/jpeg" = [ "org.gnome.Loupe.desktop;" ];
  };
}
