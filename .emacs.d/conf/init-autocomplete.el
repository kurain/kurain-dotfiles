(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/site-lisp/ac-dict")
(ac-config-default)

;;company-el
(autoload 'company-mode "company" nil t)