;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!
(load! "+bindings")

;; These are used for a number of things, particularly for GPG configuration,
;; some email clients, file templates and snippets.
(setq user-full-name "Prajwal Rao"
      user-mail-address "prajwaljpj@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-nord)

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/Dropbox/org")
(setq org-agenda-files '("~/Dropbox/org"))

;; My capture template (TODO You can change them accordingly)

;; (setq org-capture-templates
;;       '(("t" "Todo" entry (file+headline "~/Dropbox/org/gtd.org" "Tasks")
;;          "* TODO %?\n  %i\n  %a")
;;         ("j" "Journal" entry (file+datetree "~/Dropbox/org/journal.org")
;;          "* %?\nEntered on %U\n  %i\n  %a")))

(after! org
  (setq org-capture-templates
      '(("t" "All TODOs")
 ("tp" "Personal todo" entry
  (file+headline +org-capture-todo-file "Personal Tasks")
  "* [ ] %?\n%i\n%a" :prepend t)
 ("tw" "Work todo" entry
  (file+headline +org-capture-todo-file "Professional Tasks")
  "* [ ] %?\n%i\n%a" :prepend t)
 ("ti" "Ideas" entry
  (file+headline +org-capture-todo-file "Ideas")
  "* [ ] %?\n%i\n%a" :prepend t)
 ("n" "All Notes")
 ("np" "Personal notes" entry
  (file+headline +org-capture-notes-file "Personal Notes")
  "* %u %?\n%i\n%a" :prepend t)
 ("nw" "Work notes" entry
  (file+headline +org-capture-notes-file "Professional Notes")
  "* %u %?\n%i\n%a" :prepend t)
 ("ni" "Interesting" entry
  (file+headline +org-capture-notes-file "Interesting")
  "* %u %?\n%i\n%a" :prepend t)
 ("nl" "For Later" entry
  (file+headline +org-capture-notes-file "Look Later")
  "* %u %?\n%i\n%a" :prepend t)
 ("j" "Journal" entry
  (file+olp+datetree +org-capture-journal-file)
  "* %U %?\n%i\n%a" :prepend t)
 ("p" "Templates for projects")
 ("pt" "Project-local todo" entry
  (file+headline +org-capture-project-todo-file "Inbox")
  "* TODO %?\n%i\n%a" :prepend t)
 ("pn" "Project-local notes" entry
  (file+headline +org-capture-project-notes-file "Inbox")
  "* %U %?\n%i\n%a" :prepend t)
 ("pc" "Project-local changelog" entry
  (file+headline +org-capture-project-changelog-file "Unreleased")
  "* %U %?\n%i\n%a" :prepend t)
 ("o" "Centralized templates for projects")
 ("ot" "Project todo" entry #'+org-capture-central-project-todo-file "* TODO %?\n %i\n %a" :heading "Tasks" :prepend nil)
 ("on" "Project notes" entry #'+org-capture-central-project-notes-file "* %U %?\n %i\n %a" :heading "Notes" :prepend t)
 ("oc" "Project changelog" entry #'+org-capture-central-project-changelog-file "* %U %?\n %i\n %a" :heading "Changelog" :prepend t)))
  )

;; Some custom commands for agenda view
;; for more information follow this link
;; https://blog.aaronbieber.com/2016/09/24/an-agenda-for-life-with-org-mode.html
(setq org-agenda-custom-commands
      '(("c" "Simple agenda view"
         ((agenda "")
          (alltodo "")))))

(defun air-org-skip-subtree-if-priority (priority)
  "Skip an agenda subtree if it has a priority of PRIORITY.

PRIORITY may be one of the characters ?A, ?B, or ?C."
  (let ((subtree-end (save-excursion (org-end-of-subtree t)))
        (pri-value (* 1000 (- org-lowest-priority priority)))
        (pri-current (org-get-priority (thing-at-point 'line t))))
    (if (= pri-value pri-current)
        subtree-end
      nil)))

(defun air-org-skip-subtree-if-habit ()
  "Skip an agenda entry if it has a STYLE property equal to \"habit\"."
  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
    (if (string= (org-entry-get nil "STYLE") "habit")
        subtree-end
      nil)))

(setq org-agenda-custom-commands
      '(("a" "Daily agenda and all TODOs"
         ((tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High-priority unfinished tasks:")))
          (agenda "" ((org-agenda-ndays 1)))
          (alltodo ""
                   ((org-agenda-skip-function '(or (air-org-skip-subtree-if-habit)
                                                   (air-org-skip-subtree-if-priority ?A)
                                                   (org-agenda-skip-if nil '(scheduled deadline))))
                    (org-agenda-overriding-header "ALL normal priority tasks:"))))
         ((org-agenda-compact-blocks t)))))

;; To show org agenda child todos
(after! org
  (setq org-agenda-dim-blocked-tasks t))

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type nil)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;; Python Configs
(setq +python-ipython-repl-args '("-i" "--simple-prompt" "--no-color-info"))
(setq +python-jupyter-repl-args '("--simple-prompt"))

;; Company backend TODO
(after! company
  (setq company-idle-delay 0.0
        company-echo-delay 0.0
        company-minimum-prefix-length 0
        company-tooltip-flip-when-above t))
;; (set-company-backend! 'lsp-mode '(company-lsp))
;; (after! company
;;   (setq company-idle-delay 0.0
;;         ;; company-tooltip-idle-delay 0.1
;;         company-minimum-prefix-length 5
;;         company-lsp-async t))

;; (set-company-backend! '(python-mode
;;                         c-mode)
;;   '(:separate company-lsp
;;               company-capf
;;               ;; company-tabnine
;;               company-files
;;               company-yasnippet))

(after! org
  (set-company-backend! 'org-mode
    '(company-latex-commands :with company-math-symbols-latex))
  )
(after! org
  (setq company-math-allow-latex-symbols-in-faces t))
;; (set-company-backend! 'org
;;    ;; company-ispell
;;               'company-capf
;;               ;; company-tabnine ;; Try tabnine? seems promising
;;               'company-files
;;               'company-yasnippet)

;; (setq +lsp-company-backend '(company-lsp :with company-tabnine :separate))

;; (after! lsp-ui
;;   (setq lsp-ui-doc-delay 0.0
;;          lsp-ui-doc-position 'bottom
;;          lsp-ui-peek-enable t))

;; do i have to do this? or redundant?
;; (set-lookup-handlers! 'python-mode
;;   :definition #'lsp-find-definition
;;   :references #'lsp-find-references
;;   :documentation #'lsp-document-highlight)

;; tide mode setup
;; (after! tide
;;   (setq tide-completion-detailed t
;;         tide-always-show-documentation t)
;;   )

;; Prettier js
;; (setq prettier-js-args '(
;;   "--trailing-comma" "none"
;;   "--parser" "flow"
;;   "--semi" "false"
;;   "single-quote" "true"
;;   ))

;; Flow minor mode for js
(add-hook! (rjsx-mode js2-mode)
     #'(flow-minor-enable-automatically))

;; ranger deer mode disable by default
(after! ranger
  (setq ranger-override-dired nil))

;; For virtualenv and eshell compatibility
(after! eshell (venv-initialize-eshell)
  (setq venv-location "/home/prajwaljpj/.virtualenvs/"))
