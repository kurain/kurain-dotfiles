;; load-path追加
(setq load-path (cons "~/.emacs.d/site-lisp" load-path))
(setq load-path (cons "~/.emacs.d/conf" load-path))

;;標準の画面設定
(load "init-base")

;;スペースなどを強調
(load "init-color")

;; 補完機能
(load "init-autocomplete")

;; 補完機能 old
;;(require 'auto-complete)
;;(global-auto-complete-mode t)
;;(load "init-complicate")

;;;; 各言語別設定ファイル
(load "init-perl")
(load "init-actionscript")
(load "init-gauche")
(load "init-ruby")
(load "init-yatex")
(load "init-js")
(load "init-objc")





