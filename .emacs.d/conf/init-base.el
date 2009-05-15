;; デフォルトの透明度を設定する (85%)
(add-to-list 'default-frame-alist '(alpha . 90))

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
(defface my-face-b-1 '((t (:background "medium aquamarine"))) nil)
(defface my-face-b-2 '((t (:background "gray26"))) nil)
(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)
(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(
     ("　" 0 my-face-b-1 append)
     ("\t" 0 my-face-b-2 append)
     ("[ ]+$" 0 my-face-u-1 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)
(add-hook 'find-file-hooks '(lambda ()
(if font-lock-mode
nil
(font-lock-mode t))) t)

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
