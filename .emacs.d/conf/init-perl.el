;; cperl-mode
;;(defun modify-alist (alist-symbol key value &optional search-cdr)
;;(modify-alist 'interpreter-mode-alist 'perl-mode 'cperl-mode t)
;;(modify-alist 'auto-mode-alist        'perl-mode 'cperl-mode t)
(setq auto-mode-alist 
      (cons (cons "\\.pl\\'" 'cperl-mode)
            auto-mode-alist))
(setq auto-mode-alist 
      (cons (cons "\\.pm\\'" 'cperl-mode)
            auto-mode-alist))

;(autoload 'perl-mode "cperl-mode" "alternate mode for editing Perl programs" t)

(setq cperl-auto-newline t)
(setq cperl-indent-parens-as-block t)
(setq cperl-close-paren-offset -4)
(setq cperl-indent-level 4)
(setq cperl-label-offset -4)
(setq cperl-continued-statement-offset 4)
(setq cperl-highlight-variables-indiscriminately t)
(add-hook 'cperl-mode-hook
          (lambda ()
	    (define-key cperl-mode-map "\C-cc" 'cperl-check-syntax)
	    (define-key cperl-mode-map "\C-cm" 'cperl-pod-to-manpage)
	    (define-key cperl-mode-map "\C-cd" 'my-perldb)
	    (setq indent-tabs-mode nil)
            (set-face-italic-p 'cperl-hash-face nil)))
(setq auto-mode-alist
      (append '(("\\.t$" . cperl-mode)) auto-mode-alist))
;(setq cperl-invalid-face nil)

;; cperl-mode#2 http://chenyang.info/jieqi/study/perl/bioinfo.html#sec9
(defun my-perl-run ()
  (interactive)
  (let ((file-name (buffer-file-name (current-buffer))))
    (setq compile-command (concat "perl \"" file-name "\""))
    (call-interactively 'compile)))

(defun my-perl-check-syntax ()
  (interactive)
  (let ((file-name (buffer-file-name (current-buffer))))
    (setq compile-command (concat "perl -wc \"" file-name "\""))
    (call-interactively 'compile)))

(defun my-perldb ()
  (interactive)
  (require 'gud)
  (add-to-list 'gud-perldb-history
               (format "perl -d %s"
		          (file-name-nondirectory
			   (buffer-file-name (current-buffer)))))
  (call-interactively 'cperl-db))


;;(require 'perl-find-library)

(defun  perl-find-module ()
  (interactive)
  (let
      (end begin module path-to-module)
    (save-excursion
      (setq begin (save-excursion (skip-chars-backward "a-zA-Z0-9_:") (point)))
      (setq end (save-excursion (skip-chars-forward "a-zA-Z0-9_:") (point)))
      (setq module (buffer-substring begin end))
      )
    (shell-command (concat "perldoc -lm " module) "*perldoc*")
    (save-window-excursion
      (switch-to-buffer "*perldoc*")
      (setq end (point))
      (setq begin (save-excursion (beginning-of-line) (point)))
      (setq path-to-module (buffer-substring begin end))
      )
    (message path-to-module)
    (find-file path-to-module)
))

(add-hook 'cperl-mode-hook
	  (function (lambda ()
                      (define-key cperl-mode-map "\M-." 'perl-find-module))))


(add-hook 'c-mode-common-hook
          '(lambda ()
             ;; センテンスの終了である ';' を入力したら、自動改行+インデント
             (c-toggle-auto-hungry-state 1)
	     (gtags-mode 1)
             ;; RET キーで自動改行+インデント
             (define-key c-mode-base-map "\C-m" 'newline-and-indent)
	     ))


;;Flymake For Perl
;; flymake (Emacs22から標準添付されている)
(require 'flymake)

;; set-perl5lib
;; 開いたスクリプトのパスに応じて、@INCにlibを追加してくれる
;; 以下からダウンロードする必要あり
;; http://svn.coderepos.org/share/lang/elisp/set-perl5lib/set-perl5lib.el
(require 'set-perl5lib)

;; エラー、ウォーニング時のフェイス
(set-face-background 'flymake-errline "red4")
(set-face-foreground 'flymake-errline "black")
(set-face-background 'flymake-warnline "yellow")
(set-face-foreground 'flymake-warnline "black")

;; エラーをミニバッファに表示
;; http://d.hatena.ne.jp/xcezx/20080314/1205475020
(defun flymake-display-err-minibuf ()
  "Displays the error/warning for the current line in the minibuffer"
  (interactive)
  (let* ((line-no             (flymake-current-line-no))
         (line-err-info-list  (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (count               (length line-err-info-list)))
    (while (> count 0)
      (when line-err-info-list
        (let* ((file       (flymake-ler-file (nth (1- count) line-err-info-list)))
               (full-file  (flymake-ler-full-file (nth (1- count) line-err-info-list)))
               (text (flymake-ler-text (nth (1- count) line-err-info-list)))
               (line       (flymake-ler-line (nth (1- count) line-err-info-list))))
          (message "[%s] %s" line text)))
      (setq count (1- count)))))

;; Perl用設定
;; http://unknownplace.org/memo/2007/12/21#e001
(defvar flymake-perl-err-line-patterns
  '(("\\(.*\\) at \\([^ \n]+\\) line \\([0-9]+\\)[,.\n]" 2 3 nil 1)))

(defconst flymake-allowed-perl-file-name-masks
  '(("\\.pl$" flymake-perl-init)
    ("\\.pm$" flymake-perl-init)
    ("\\.t$" flymake-perl-init)))

(defun flymake-perl-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "perl" (list "-wc" local-file))))

(defun flymake-perl-load ()
  (interactive)
  (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
    (setq flymake-check-was-interrupted t))
  (ad-activate 'flymake-post-syntax-check)
  (setq flymake-allowed-file-name-masks (append flymake-allowed-file-name-masks flymake-allowed-perl-file-name-masks))
  (setq flymake-err-line-patterns flymake-perl-err-line-patterns)
  (set-perl5lib)
  (flymake-mode t))

(add-hook 'cperl-mode-hook 'flymake-perl-load)
