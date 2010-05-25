;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;;; cperl-mode
(require 'cperl-mode)

;; perl-modeを使わない
(defalias 'perl-mode 'cperl-mode)

;; cperl-modeを適用する
(setq auto-mode-alist
      (append '(("\\.\\([pP][Llm]\\|t\\)$" . cperl-mode))  auto-mode-alist ))

;; コーディングスタイル
(setq cperl-close-paren-offset -4)
(setq cperl-continued-statement-offset 4)
(setq cperl-indent-level 4)
(setq cperl-indent-parens-as-block t)
(setq cperl-label-offset -4)
(setq cperl-highlight-variables-indiscriminately t)

;; faces
(set-face-bold-p 'cperl-array-face nil)
(set-face-background 'cperl-array-face "blightblue")
(set-face-bold-p 'cperl-hash-face nil)
(set-face-italic-p 'cperl-hash-face nil)
(set-face-background 'cperl-hash-face "blightblue")

;; ~/bin/make_pmlist.shをcronで回して作っておいた、インストール済み
;; Perlモジュールリストをファイルに書き出したものを、cperl-modeのフック
;; でロードする(dabbrev補完用)。
;; http://d.hatena.ne.jp/antipop/20080304/1204635027
(defvar perl-pmlist-file-name (expand-file-name "~/.emacs.d/perl/pmlist"))
(defvar perl-pmlist-buffer-name "*PerlModules*")
(defvar perl-pmlist-make-command (concat (expand-file-name "~/bin/make_pmlist.sh")
                                      " "
                                      perl-pmlist-file-name))

(defun perl-make-pmlist-buffer ()
  (interactive)
  (with-temp-buffer
    (when (interactive-p)
      (shell-command perl-pmlist-make-command))
    (unless (get-buffer perl-pmlist-buffer-name)
      (set-buffer (find-file-noselect perl-pmlist-file-name))
      (rename-buffer perl-pmlist-buffer-name)
      (auto-revert-mode t))))

(add-hook 'cperl-mode-hook 'perl-make-pmlist-buffer)

;; use文を、C-c C-mで自動挿入。
;; http://subtech.g.hatena.ne.jp/antipop/20070917/1189962499
(add-hook 'cperl-mode-hook
          (lambda ()
            (local-set-key (kbd "\C-c \C-m") 'perl-insert-use-statement)))

(defun perl-insert-use-statement (current-point)
  "use statement auto-insertion."
  (interactive "d")
  (insert-use-statement
   (detect-module-name current-point)
   (detect-insert-point)))

(defun insert-use-statement (module-name insert-point)
  (save-excursion
    (goto-char insert-point)
    (insert (concat "\nuse " module-name ";"))))

(defun detect-insert-point ()
  (save-excursion
    (if (re-search-backward "use .+;" 1 t)
        (match-end 0)
      (progn
        (string-match "^$" (buffer-string))
        (match-end 0)))))

(defun detect-module-name (current-point)
  (let ((str (save-excursion
               (buffer-substring
                current-point
                (progn (beginning-of-line) (point))))))
    (if (string-match "\\([[:alnum:]-_:]+\\)$" str)
        (match-string 1 str)
      (error "Module name not found"))))

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


;;perl-Tidy
(defun perltidy-region ()
  "Run perltidy on the current region."
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "perltidy -q" nil t)))
(defun perltidy-defun ()
  "Run perltidy on the current defun."
  (interactive)
  (save-excursion (mark-defun)
                  (perltidy-region)))

;; pod-mode
;; Perl Hacks p.15
(require 'pod-mode)
(add-to-list 'auto-mode-alist
             '("\\.pod$" . pod-mode))
(add-hook 'pod-mode-hook
          '(lambda () (progn
                        (font-lock-mode)
                        (auto-fill-mode 1)
                        (flyspell-mode 1)
                        )))

;; Template Toolkit
;; http://clouder.jp/yoshiki/mt/archives/000377.html
(require 'html-tt)
(setq auto-mode-alist (cons '("\\.tt$" . html-helper-mode) auto-mode-alist))
(add-hook 'html-helper-mode-hook 'html-tt-load-hook)
(setq html-tt-sequence-face 'bold)
(setq html-tt-sequence-face 'italic)
(setq html-tt-sequence-start "[% ")
(setq html-tt-sequence-end " %]")

;; [2008-03-12]
;; bracket.elにinsert-single-quotationを追加したのに伴い、以下の設定も追従

;; bracket.elにより、対応する括弧を自動挿入
(add-hook 'cperl-mode-hook
          '(lambda()
             (progn
               (define-key cperl-mode-map "{" 'insert-braces)
               (define-key cperl-mode-map "(" 'insert-parens)
               (define-key cperl-mode-map "\"" 'insert-double-quotation)
               (define-key cperl-mode-map "'" 'insert-single-quotation)
               (define-key cperl-mode-map "[" 'insert-brackets)
               (define-key cperl-mode-map "\C-c}" 'insert-braces-region)
               (define-key cperl-mode-map "\C-c)" 'insert-parens-region)
               (define-key cperl-mode-map "\C-c]" 'insert-brackets-region)
               (define-key cperl-mode-map "\C-c\"" 'insert-double-quotation-region))))
