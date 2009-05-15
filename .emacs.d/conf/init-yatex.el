;; For YaTeX
(setq auto-mode-alist (cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(setq tex-command "~/Library/TeXShop/bin/platex2pdf-utf8" dvi2-command "open -a TexShop")
