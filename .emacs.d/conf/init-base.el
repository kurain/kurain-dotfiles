; 言語を日本語にする
(set-language-environment 'Japanese)
; 極力UTF-8とする
(prefer-coding-system 'utf-8)

;; Command-Key and Option-Key
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

;; font for mac
;; (add-to-list 'default-frame-alist '(font . "fontset-menlokakugo"))
;; (set-fontset-font "fontset-menlokakugo"
;;                   'unicode
;;                   (font-spec :family "Hiragino Kaku Gothic ProN" :size 16)
;;                   nil
;;                   'append)
;; (create-fontset-from-ascii-font "Menlo-14:weight=normal:slant=normal" nil "menlokakugo")

(when (>= emacs-major-version 23)
 (set-face-attribute 'default nil
                     :family "monaco"
                     :height 140)
 (set-fontset-font
  (frame-parameter nil 'font)
  'japanese-jisx0208
  '("Hiragino Maru Gothic Pro" . "iso10646-1"))
 (set-fontset-font
  (frame-parameter nil 'font)
  'japanese-jisx0212
  '("Hiragino Maru Gothic Pro" . "iso10646-1"))
 (set-fontset-font
  (frame-parameter nil 'font)
  'mule-unicode-0100-24ff
  '("monaco" . "iso10646-1"))
 (setq face-font-rescale-alist
      '(("^-apple-hiragino.*" . 1.2)
        (".*osaka-bold.*" . 1.2)
        (".*osaka-medium.*" . 1.2)
        (".*courier-bold-.*-mac-roman" . 1.0)
        (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
        (".*monaco-bold-.*-mac-roman" . 0.9)
        ("-cdac$" . 1.3))))

;;load-path 追加
(setq load-path (cons "/usr/share/emacs/site-lisp" load-path))

;; デフォルトの透明度を設定する (85%)
(add-to-list 'default-frame-alist '(alpha . 90))

;;列数表示
(column-number-mode t)

;;Bellの音を消してビジュアルで
(setq ring-bell-function 'ignore)
(setq visible-bell t)

;;color-theme.el
(load "color-theme")
(color-theme-initialize)
(color-theme-dark-laptop)

;;; ツールバーを消す
(tool-bar-mode 0)

;;tab,全角を目立たせる
;; (defface my-face-b-1 '((t (:background "medium aquamarine"))) nil)
;; (defface my-face-b-2 '((t (:background "gray26"))) nil)
;; (defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
;; (defvar my-face-b-1 'my-face-b-1)
;; (defvar my-face-b-2 'my-face-b-2)
;; (defvar my-face-u-1 'my-face-u-1)
;; (defadvice font-lock-mode (before my-font-lock-mode ())
;;   (font-lock-add-keywords
;;    major-mode
;;    '(
;;      ("　" 0 my-face-b-1 append)
;;      ("\t" 0 my-face-b-2 append)
;;      ("[ ]+$" 0 my-face-u-1 append)
;;      )))
;; (ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
;; (ad-activate 'font-lock-mode)
;; (add-hook 'find-file-hooks '(lambda ()
;; (if font-lock-mode
;; nil
;; (font-lock-mode t))) t)


(defun recenter-and-fontify-buffer ()
  "comment..."
  (interactive)
  (recenter)
  (font-lock-fontify-buffer))
(define-key esc-map "\C-l" 'recenter-and-fontify-buffer)

;; カーソル位置のfaceを調べる関数
(defun describe-face-at-point()
  "Return facce used at point."
  ;; izonmoji-mode from navi2ch
  (require 'izonmoji-mode nil t)
  (if (featurep 'izonmoji-mode)
      (progn      (defface my-izonmoji-win-face
                    '((((class color) (type tty)) (:foreground "cyan"))
                      (((class color) (background light)) (:foreground "cyan4" :strike-through "cyan4"))
                      (((class color) (background dark))  (:foreground "Aquamarine3"))
                      (t (:underline t)))
                    "Windowsの機種依存文字のフェイス。")
                  (defface my-izonmoji-mac-face
                    '((((class color) (type tty)) (:foreground "magenta"))
                      (((class color) (background light)) (:box (:line-width 1 :color "SteelBlue3") :strike-through "SteelBlue3"))
                      (((class color) (background dark))  (:foreground "pink3"))
                      (t (:underline t)))
                    "Macの機種依存文字のフェイス。")
                  (setq izonmoji-win-face 'my-izonmoji-win-face)
                  (setq izonmoji-mac-face 'my-izonmoji-mac-face)
                  ))

;;; タブ、全角スペース、行末のスペースに色を付ける
;;; http://www.bookshelf.jp/soft/meadow_26.html#SEC313
;;; http://homepage1.nifty.com/blankspace/emacs/color.html
  ;;(defface my-face-r-1 '((t (:background "gray15"))) nil)
  (defface my-face-b-1 '((t (:background "gray26"))) nil)
  (defface my-face-b-2 '((t (:background "gray70"))) nil)
  (defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
  ;;(defvar my-face-r-1 'my-face-r-1)
  (defvar my-face-b-1 'my-face-b-1)
  (defvar my-face-b-2 'my-face-b-2)
  (defvar my-face-u-1 'my-face-u-1)

  (defadvice font-lock-mode (before my-font-lock-mode ())
    (font-lock-add-keywords   major-mode   '(("\t" 0 my-face-b-2 append)
                                             ("　" 0 my-face-b-1 append)
                                             ("[ \t]+$" 0 my-face-u-1 append)
                                             ;;("[\r]*\n" 0 my-face-r-1 append)
                                             )))
  (ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
  (ad-activate 'font-lock-mode)

  (defun toggle-colorful-space()
    "toggle while space font-lock"
    (interactive)
    (if my-face-b-1      (progn        (setq my-face-b-1 nil)
                                       (setq my-face-b-2 nil)
                                       (setq my-face-u-1 nil)
                                       (if (featurep 'develock)
                                           (develock-mode 0)))
      (progn      (setq my-face-b-1 'my-face-b-1)
                  (setq my-face-b-2 'my-face-b-2)
                  (setq my-face-u-1 'my-face-u-1))))
  (interactive)
  (message "%s" (get-char-property (point) 'face)))

;; develock
;; http://www.jpl.org/elips/
(require 'develock nil t)
(if (featurep 'develock)
    (progn
      (setq develock-max-column-plist
            (list 'java-mode  90                  'jde-mode   90                  'emacs-lisp-mode 90                  'lisp-interaction-mode 90                  'html-mode  nil                  'html-helper-mode nil                  'cperl-mode 90                  'perl-mode  90))
      (let ((elem (copy-sequence (assq 'message-mode develock-keywords-alist))))
        (setcar elem 'html-helper-mode)
        (setq develock-keywords-alist              (cons elem (delq (assq 'html-helper-mode develock-keywords-alist)
                                                                    develock-keywords-alist))))
      ))



;;キーバインド
; C-h でカーソルの左にある文字を消す
(define-key global-map "\C-h" 'delete-backward-char)
; C-h に割り当てられている関数 help-command を C-x C-h に割り当てる
(define-key global-map "\C-x\C-h" 'help-command)

;; 日本語・英語混じり文での区切判定
(defadvice dabbrev-expand
  (around modify-regexp-for-japanese activate compile)
  "Modify `dabbrev-abbrev-char-regexp' dynamically for Japanese words."
  (if (bobp)
      ad-do-it
    (let ((dabbrev-abbrev-char-regexp
           (let ((c (char-category-set (char-before))))
             (cond 
              ((aref c ?a) "[-_A-Za-z0-9]") ; ASCII
              ((aref c ?j) ; Japanese
               (cond
                ((aref c ?K) "\\cK") ; katakana
                ((aref c ?A) "\\cA") ; 2byte alphanumeric
                ((aref c ?H) "\\cH") ; hiragana
                ((aref c ?C) "\\cC") ; kanji
                (t "\\cj")))
              ((aref c ?k) "\\ck") ; hankaku-kana
              ((aref c ?r) "\\cr") ; Japanese roman ?
              (t dabbrev-abbrev-char-regexp)))))
      ad-do-it)))

;; html-mode for hatena
(add-hook 'html-mode-hook '(lambda () (setq tab-width 4)))

;; delete region with back space key
(delete-selection-mode 1)

;; タイトルバーにバッファ名
(setq frame-title-format "%b")

;; iswitchb
(iswitchb-mode 1)
(defadvice iswitchb-exhibit
  (after
   iswitchb-exhibit-with-display-buffer
   activate)
  "選択している buffer を window に表示してみる。"
  (when (and
         (eq iswitchb-method iswitchb-default-method)
         iswitchb-matches)
    (select-window
     (get-buffer-window (cadr (buffer-list))))
    (let ((iswitchb-method 'samewindow))
      (iswitchb-visit-buffer
       (get-buffer (car iswitchb-matches))))
    (select-window (minibuffer-window))))

;;tab をsoft tab 4に
(setq-default tab-width 4 indent-tabs-mode nil)

;;flymake-keys
(global-set-key "\M-gn" '(lambda ()
                           (interactive)
                           (let (line (line-number-at-pos))
                             (flymake-goto-next-error)
                             (when (equal line (line-number-at-pos))
                               (next-error)))))
(global-set-key "\M-gp" '(lambda ()
                           (interactive)
                           (let (line (line-number-at-pos))
                             (flymake-goto-prev-error)
                             (when (equal line (line-number-at-pos))
                               (previous-error)))))
(global-set-key "\C-cd" 'flymake-display-err-menu-for-current-line)

;;鬼軍曹
(load "drill-instructor")
(setq drill-instructor-global t)

