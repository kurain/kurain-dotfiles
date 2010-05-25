;; load-path追加
(setq load-path (cons "~/.emacs.d/site-lisp" load-path))
(setq load-path (cons "~/.emacs.d/conf" load-path))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; OS判別

;; .emacs で OS の判定を関数化しよう - msshの日記
;; http://d.hatena.ne.jp/mssh/20081208/1228742294
;; を少し修正

(defvar os-type nil)
(setq os-type (cond
 ((string-match "linux" system-configuration) 'linux)
 ((string-match "mingw" system-configuration) 'win)
 ((string-match "apple" system-configuration) 'osx)
))

(defun linux? () (eq os-type 'linux))
(defun win?   () (eq os-type 'win))
(defun osx?   () (eq os-type 'osx))



;;標準の画面設定
(load "init-base")

;;スペースなどを強調
(load "init-color")

(load "init-anything")

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





