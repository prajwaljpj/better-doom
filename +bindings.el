;;; ~/.doom.d/+bindings.el -*- lexical-binding: t; -*-
(map! :map org-mode-map
      :localleader
      :desc "Emphasize" "z" 'org-emphasize)
(after! company
  (define-key! company-active-map
    "RET"       nil
    [return]    nil
    "TAB"       #'company-complete-selection
    [tab]       #'company-complete-selection))
