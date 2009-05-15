;; actionscript
; "Symbol's value as variable is void: running-on-x"といわれたので。
; via http://blog.pettomato.com/content/site-lisp/.emacs
(defvar running-on-x (eq window-system 'x))
(autoload 'actionscript-mode "actionscript-mode" "Major mode for actionscript." t)
;; Activate actionscript-mode for any files ending in .as
(add-to-list 'auto-mode-alist '("\\.as$" . actionscript-mode))
;; Load our actionscript-mode extensions.
(eval-after-load "actionscript-mode" '(load "as-config"))
