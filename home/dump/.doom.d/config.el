;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-user-dir "~/.nix/home/dump/.doom.d/")

;; Resolve bad $SHELL
(setq shell-file-name (executable-find "bash"))

;; Place your private configuration here! remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Scroll margins
(setq scroll-margin 8)

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Gravity"
      user-mail-address "alternativegravitational@protonmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:

(setq doom-font (font-spec :family "Aporetic Sans Mono" :size 36)
      doom-variable-pitch-font (font-spec :family "Aporetic Sans" :size 36))
;; doom-variable-pitch-font (font-spec :family "Ubuntu Sans Nerd Font" :size 20))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-rose-pine-dawn)

(setq fancy-splash-image "~/.doom.d/themes/marisa-10.png")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; (setq display-line-numbers-current-absolute t)
(setq display-line-numbers-type 'visual)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Notes/")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Nakakatawa ka naman

;;; Package configs
(after! org
  ;; Default
  (setq org-archive-location (concat org-directory ".archive/%s_archive::"))
  ;; Captures
  (setq org-default-notes-file (concat org-directory "refile.org"))
  ;; RETURN will follow links in org-mode files
  (setq org-return-follows-link  t)
  ;; Hide emphasis markers
  (setq org-hide-emphasis-markers t)
  ;; Schedules
  (setq org-agenda-prefix-format
        '((agenda . " %-12:c%?-12t% s")
          (todo . " %i %-12:c")
          (tags . " %i %-12:c")
          (search . " %i %-12:c")))
  ;; Org-Roam
  (setq org-roam-directory (file-truename "~/Notes/wiki"))
  ;; Org priorities
  (setq org-highest-priority ?A)
  (setq org-default-priority ?D)
  (setq org-lowest-priority ?E)
  ;; Org when export
  (setq org-export-with-section-numbers nil)
  (setq org-export-with-toc nil)
  (setq org-export-with-date t)
  (setq org-latex-packages-alist '(("margin=1.5in" "geometry" nil)(" " "nopageno" t)))
  (setq org-startup-with-latex-preview t)
  (setq org-startup-with-overview t)
  (setq org-format-latex-options
        (plist-put (plist-put org-format-latex-options :scale 3.5)
                   :html-scale 3.5))
  ;; Set closed timestamp when closing
  (setq org-log-done 'time)
  )

;; Org capture templates
(after! org-capture
  (add-to-list 'org-capture-templates
               '("s" "School todo" entry (file (concat org-directory "/school_todo.org")) "* %?\n%U\n%i"))
  (add-to-list 'org-capture-templates
               '("R" "Reminders" entry (file (concat org-directory "/reminders.org") "Refile") "* %?\n%U\n%i"))
  (add-to-list 'org-capture-templates
               '("r" "Refile" entry (file org-default-notes-file) "* %?\n%U\n%i")))

;; Configure to allow both english and tagalog in spell checking
(after! ispell
  (setq ispell-program-name "hunspell")
  (setq ispell-dictionary "en_US")
  ;; (setq ispell-dictionary "en_US,tl")
  ;; mkdir -p ~/.emacs.d/.local/etc/ispell && touch ~/.emacs.d/.local/etc/ispell/.pws && chmod 660 ~/.emacs.d/.local/etc/ispell/.pws
  (setq ispell-personal-dictionary "~/.emacs.d/.local/etc/ispell/.pws")
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "en_US"))
;; (ispell-hunspell-add-multi-dic "en_US,tl"))
(add-hook 'spell-fu-mode-hook
          (lambda ()
            (spell-fu-dictionary-add (spell-fu-get-ispell-dictionary "en_US"))
            (spell-fu-dictionary-add (spell-fu-get-ispell-dictionary "tl"))
            (spell-fu-dictionary-add (spell-fu-get-ispell-dictionary "en_US,tl"))))

;; Make which-key faster
(after! which-key
  (setq which-key-idle-delay 0.1))

;; Don't use return to confirm
(after! corfu
  (setq +corfu-want-ret-to-confirm nil))

;; (after! org-fancy-priorities
;;   (setq org-fancy-priorities-list '((?A . "⚑")
;;                                     (?B . "⬆")
;;                                     (?C . "■")
;;                                     (?D . "⬇")
;;                                     (?E . "❄")))
;; (setq org-priority-faces '((?A . (:foreground "#b4637a"))
;;                            (?B . (:foreground "#d7827e"))
;;                            (?C . (:foreground "#ea9d34"))
;;                            (?D . (:foreground "#907aa9"))
;;                            (?E . (:foreground "#56949f")))))
(after! org-modern
  ;; (setq org-modern-priority (quote ((?A . "⚑")
  ;;                                   (?B . "⬆")
  ;;                                   (?C . "■")
  ;;                                   (?D . "⬇")
  ;;                                   (?E . "❄"))))

  (setq org-modern-priority-faces '((?A . (:inverse-video t :foreground "#b4637a"))
                                    (?B . (:inverse-video t :foreground "#d7827e"))
                                    (?C . (:inverse-video t :foreground "#ea9d34"))
                                    (?D . (:inverse-video t :foreground "#907aa9"))
                                    (?E . (:inverse-video t :foreground "#56949f")))))

(use-package! lsp-ltex-plus
  :hook (org-mode . (lambda ()
                      (require 'lsp-ltex-plus)
                      (lsp-deferred)))
  (markdown-mode . (lambda ()
                     (require 'lsp-ltex-plus)
                     (lsp-deferred)))
  :init
  (setq lsp-ltex-plus-version "18.5.0")
  (setq lsp-ltex-plus-additional-rules-enable-picky-rules "true")
  (setq lsp-ltex-plus-language "en")
  (setq lsp-ltex-plus-mother-tongue "tl-PH"))

;;; Key maps
;; Allow for C-y to accept company selection
;; (map! :after corfu
;;       :map corfu-map
;;       "C-y" #'corfu-insert
;;       "C-e" #'corfu-quit)

;; (map! :after treemacs
;;       :leader
;;       ">" #'treemacs)

;; Only move through visual lines
(map! :after evil
      :map evil-motion-state-map
      [remap evil-next-line] #'evil-next-visual-line
      [remap evil-previous-line] #'evil-previous-visual-line)

(map! :leader
      :desc "Mixed Pitch Mode"
      "t p" #'mixed-pitch-mode)

(map! :leader
      :desc "Open plan/schedule"
      "n p" #'(lambda () (interactive) (find-file "~/Notes/assets/schedule.jpg")))

(map! :leader
      :desc "Open calendar"
      "n A" #'cfw:open-org-calendar)

(map! :leader
      :desc "Export to pdf"
      "n e" #'org-latex-export-to-pdf)

(map! :leader
      :desc "Close window"
      "x" #'evil-window-delete)

(map! :leader
      :desc "Save buffer"
      "w" #'save-buffer)

(map! "C-f" #'projectile-find-file)


;;; Various silly things
;; (load! "silly/pomodoro.el")
;; (load! "silly/plot.el")
(setq default-frame-alist '((undecorated . t)))
