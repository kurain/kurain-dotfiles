(defun recenter-and-fontify-buffer ()
  "comment..."
  (interactive)
  (recenter)
  (font-lock-fontify-buffer))
(define-key esc-map "\C-l" 'recenter-and-fontify-buffer)

;; カーソル位置のfaceを調べる関数
(defun describe-face-at-point()
  "Return facce used at point."
  (interactive)
  (message "%s" (get-char-property (point) 'face)))

;; develock
;; http://www.jpl.org/elips/
(require 'develock nil t)
(if (featurep 'develock)
    (progn
      (setq develock-max-column-plist
            (list 'java-mode  90
                  'jde-mode   90
                  'j2-mode nil
                  'emacs-lisp-mode 90
                  'lisp-interaction-mode 90
                  'html-mode  nil
                  'html-helper-mode nil
                  'cperl-mode 90
                  'perl-mode  90))
      (let ((elem (copy-sequence (assq 'message-mode develock-keywords-alist))))
        (setcar elem 'html-helper-mode)
        (setq develock-keywords-alist
              (cons elem (delq (assq 'html-helper-mode develock-keywords-alist)
                               develock-keywords-alist))))
      ))

;; izonmoji-mode from navi2ch
(require 'izonmoji-mode nil t)
(if (featurep 'izonmoji-mode)
    (progn
      (defface my-izonmoji-win-face
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
  (font-lock-add-keywords
   major-mode
   '(("\t" 0 my-face-b-2 append)
     ("　" 0 my-face-b-1 append)
     ("[ \t]+$" 0 my-face-u-1 append)
     ;;("[\r]*\n" 0 my-face-r-1 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)

(defun toggle-colorful-space()
  "toggle while space font-lock"
  (interactive)
  (if my-face-b-1
      (progn
        (setq my-face-b-1 nil)
        (setq my-face-b-2 nil)
        (setq my-face-u-1 nil)
        (if (featurep 'develock)
            (develock-mode 0)))
    (progn
      (setq my-face-b-1 'my-face-b-1)
      (setq my-face-b-2 'my-face-b-2)
      (setq my-face-u-1 'my-face-u-1))))

