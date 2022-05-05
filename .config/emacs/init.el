(add-to-list 'load-path (concat user-emacs-directory "lisp"))

(require 'my)

(my-init-package-archives)

(custom-set-variables '(package-selected-packages '(magit
                                                    reason-mode
                                                    debian-el
                                                    csv-mode
                                                    counsel
                                                    go-guru
                                                    go-rename
                                                    rust-mode
                                                    go-mode
                                                    markdown-mode
                                                    scala-mode
                                                    gnu-elpa-keyring-update
                                                    modus-operandi-theme
                                                    lsp-mode
                                                    yaml-mode
                                                    tuareg
                                                    ocp-indent
                                                    dune
                                                    ocamlformat
                                                    auctex)))

(package-initialize)

;; Ensure that packages are installed.
(package-install-selected-packages)

;;; APT
(require 'apt-sources)           ; To force update of `auto-mode-alist'.

(require 'ocp-indent)

(require 'dune)

(require 'ocamlformat)

;;; Go
(require 'go-guru)

(add-hook 'go-mode-hook 'my-go-mode-hook-f)

;;; LSP
(add-hook 'prog-mode-hook 'lsp-deferred)

(custom-set-variables '(lsp-headerline-breadcrumb-enable t)
                      '(lsp-headerline-breadcrumb-enable-symbol-numbers t)
                      '(lsp-headerline-breadcrumb-segments '(symbols))
                      '(lsp-diagnostics-provider :none)
                      '(lsp-enable-symbol-highlighting nil)
                      '(lsp-enable-snippet nil)
                      '(lsp-before-save-edits nil)
                      '(lsp-signature-auto-activate nil)
                      '(lsp-modeline-code-actions-enable nil)
                      '(lsp-modeline-diagnostics-enable nil))

;;; Ispell

;; Use hunspell instead of aspell because hunspell has a better French
;; support.
(custom-set-variables '(ispell-program-name "hunspell"))

(add-hook 'text-mode-hook 'flyspell-mode)

;; Switch to French dictionary when writing mails or LaTeX files.
(my-add-hooks '(message-mode-hook LaTeX-mode-hook)
              'my-ispell-change-to-fr-dictionary)

;;; Filling
(custom-set-variables '(fill-column 72))

(custom-set-variables '(comment-multi-line t))

(add-to-list 'fill-nobreak-predicate 'fill-french-nobreak-p)

;; auto-fill-mode is only enabled in CC mode (and not in all program
;; modes) because it seems to be the only program mode that properly
;; deals with auto-fill.
(my-add-hooks '(text-mode-hook c-mode-common-hook) 'auto-fill-mode)

;;; Mail
(custom-set-variables
 '(mail-header-separator
   "-=-=-=-=-=-=-=-=-=# Don't remove this line #=-=-=-=-=-=-=-=-=-"))

;;; Whitespace
(global-whitespace-mode 1)

;; Do not display spaces, tabs and newlines marks.
(custom-set-variables
 '(whitespace-style (cl-set-difference whitespace-style '(tabs
                                                          spaces
                                                          newline
                                                          space-mark
                                                          tab-mark
                                                          newline-mark)))
 '(whitespace-action '(auto-cleanup)))

;; Turn off whitespace-mode in Dired-like buffers.
(custom-set-variables
 '(whitespace-global-modes '(not dired-mode archive-mode git-rebase-mode)))

;;; Auto-Revert
(global-auto-revert-mode 1)

;;; Compilation
(custom-set-variables '(compilation-scroll-output 'first-error)
                      '(compilation-context-lines 0))

;;; Ffap
(custom-set-variables '(ffap-machine-p-known 'reject))

;;; Auto-insert

;; This skeleton is like the one provided by default, except that we add
;; an appropriate comment after the #endif.
(define-auto-insert '("\\.\\([Hh]\\|hh\\|hpp\\)\\'" . "C / C++ guard macro")
  '((upcase (concat (file-name-nondirectory
                     (file-name-sans-extension buffer-file-name))
                    "_"
                    (file-name-extension buffer-file-name)))
    "#ifndef " str "\n#define " str "\n\n" _ "\n\n#endif /* not " str " */\n"))

;; This skeleton is like the one provided by default, except that it
;; does the inclusion for .hpp file too.
(define-auto-insert '("\\.\\([Cc]\\|cc\\|cpp\\)\\'" . "C / C++ source")
  '(nil "#include \""
        (let
            ((stem
              (file-name-sans-extension buffer-file-name)))
          (cond
           ((file-exists-p
             (concat stem ".h"))
            (file-name-nondirectory
             (concat stem ".h")))
           ((file-exists-p
             (concat stem ".hh"))
            (file-name-nondirectory
             (concat stem ".hh")))
           ((file-exists-p
             (concat stem ".hpp"))
            (file-name-nondirectory
             (concat stem ".hpp")))))
        & 34 | -10))

;; Prompt the user for the appropriate Makefile type to insert.
(define-auto-insert '("[Mm]akefile\\'" . "Makefile") 'my-makefile-auto-insert)

(define-auto-insert '(".gitignore\\'" . ".gitignore file")
  'my-gitignore-auto-insert)

(define-auto-insert '(".ocp-indent\\'" . ".ocp-indent file")
  'my-ocp-indent-auto-insert)

(custom-set-variables
 '(auto-insert-directory (my-prefix-by-user-emacs-directory "insert/")))
(auto-insert-mode 1)

;;; Semantic
(my-add-to-list
 'semantic-default-submodes
 '(global-semantic-stickyfunc-mode global-semantic-mru-bookmark-mode))

(semantic-mode 1)

;;; CC mode
(c-add-style "my-linux" '("linux" (indent-tabs-mode . t)))

(add-hook 'c-initialization-hook 'my-c-initialization-hook-f)

;; In java-mode and c++-mode, we use C style comments and not
;; single-line comments.
(my-add-hooks '(java-mode-hook c++-mode-hook) 'my-c-trad-comment-on)

;;; Tuareg
(custom-set-variables '(tuareg-interactive-read-only-input t))

(add-hook 'tuareg-mode-hook 'my-tuareg-mode-hook-f)

;;; Reason
(add-hook 'reason-mode-hook 'my-reason-mode-hook-f)

;;; Scala
(custom-set-variables '(scala-indent:default-run-on-strategy 1))

(add-hook 'scala-mode-hook 'my-c-trad-comment-on)

;;; Proof general
(custom-set-variables '(proof-splash-enable nil)
                      '(proof-three-window-mode-policy 'hybrid)
                      '(coq-one-command-per-line nil))

;;; Asm
(custom-set-variables '(asm-comment-char ?#))

;;; Prolog
;; (setq-default prolog-system 'eclipse)

;;; LaTeX
(custom-set-variables '(TeX-auto-save t)
                      '(TeX-parse-self t)
                      '(LaTeX-section-hook '(LaTeX-section-heading
                                             LaTeX-section-title
                                             LaTeX-section-toc
                                             LaTeX-section-section
                                             LaTeX-section-label))
                      '(reftex-plug-into-AUCTeX t)
                      '(reftex-enable-partial-scans t)
                      '(reftex-save-parse-info t)
                      '(reftex-use-multiple-selection-buffers t)
                      '(TeX-electric-math (cons "$" "$"))
                      '(TeX-electric-sub-and-superscript t)
                      '(font-latex-fontify-script 'multi-level))

(custom-set-variables '(TeX-master nil))

(my-add-hook 'LaTeX-mode-hook
             '(TeX-PDF-mode LaTeX-math-mode TeX-source-correlate-mode
                            reftex-mode))

;;; Magit
(require 'magit)

(custom-set-variables '(git-commit-summary-max-length fill-column)
                      '(magit-diff-refine-hunk t))

;;; Markdown
(custom-set-variables '(markdown-command "pandoc")
                      '(markdown-asymmetric-header t)
                      '(markdown-fontify-code-blocks-natively t))

(add-hook 'markdown-mode-hook 'my-markdown-mode-hook-f)

;;; Miscellaneous settings
(setq disabled-command-function nil)

(custom-set-variables '(inhibit-startup-screen t)
                      '(custom-file
                        (my-prefix-by-user-emacs-directory ".custom.el"))
                      '(auto-mode-case-fold nil)
                      '(load-prefer-newer t)
                      '(track-eol t)
                      '(view-read-only t)
                      '(comint-prompt-read-only t)
                      '(term-buffer-maximum-size 0)
                      '(vc-follow-symlinks t)
                      '(vc-command-messages t))

(custom-set-variables
 '(require-final-newline t)
 '(scroll-up-aggressively 0)
 '(scroll-down-aggressively 0)
 '(indent-tabs-mode nil)
 '(mode-line-format (remove '(vc-mode vc-mode) mode-line-format)))

(my-add-to-list 'completion-ignored-extensions
                '("auto/" ".prv/" "_build/" "_opam/" "target/"
                  "_client/" "_deps/" "_server/" ".sass-cache/"
                  ".d" ".native" ".byte" ".bc" ".exe" ".pdf"
                  ".out" ".fls" ".synctex.gz" ".rel" ".unq" ".tns"
                  ".emacs.desktop" ".emacs.desktop.lock" "_region_.tex"))

(custom-set-variables
 '(counsel-find-file-ignore-regexp
   (concat (regexp-opt completion-ignored-extensions) "\\'")))

;; Hack to open files like Makefile.local or Dockerfile.test with the
;; right mode.
(add-to-list 'auto-mode-alist '("\\.[^\\.].*\\'" nil t) t)

(my-add-to-list 'auto-mode-alist
                '(("README\\'" . text-mode)
                  ;; ("\\.pl\\'" . prolog-mode)
                  ("dune-project\\'" . dune-mode)
                  ("dune-workspace\\'" . dune-mode)
                  ("bash-fc\\'" . sh-mode)
                  ("\\.bash_aliases\\'" . sh-mode)
                  ("\\.gitignore\\'" . conf-unix-mode)
                  ("\\.dockerignore\\'" . conf-unix-mode)
                  ("\\.ml[ly]\\'" . tuareg-mode)
                  ("\\.top\\'" . tuareg-mode)
                  ("\\.ocamlinit\\'" . tuareg-mode)
                  ("\\.ocp-indent\\'" . conf-unix-mode)
                  ("Dockerfile\\'" . conf-space-mode)
                  ("_tags\\'" . conf-colon-mode)
                  ("_log\\'" . conf-unix-mode)
                  ("\\.merlin\\'" . conf-space-mode)
                  ("\\.mrconfig\\'" . conf-unix-mode)
                  ("\\.eml\\'" . message-mode)))

(tool-bar-mode 0)

(menu-bar-mode 0)

(scroll-bar-mode 0)

(toggle-frame-fullscreen)

(column-number-mode 1)

(global-subword-mode 1)

(delete-selection-mode 1)

(electric-indent-mode 1)

(electric-pair-mode 1)

(show-paren-mode 1)

(savehist-mode 1)

(winner-mode 1)

(ivy-mode 1)

(counsel-mode 1)

;;; Ivy
(custom-set-variables '(ivy-display-functions-alist nil))
                                        ; Should be done after enabling
                                        ; `counsel-mode'.

;;; Custom global key bindings
(my-global-set-key "a" 'ff-get-other-file)

(my-global-set-key "b" 'windmove-left)

(my-global-set-key "c" 'my-compile)

(my-global-set-key "f" 'windmove-right)

(global-set-key (kbd "C-x g") 'magit-status)

(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)

(my-set-magit-key "f" 'magit-find-file)

(my-set-magit-key "4 f" 'magit-find-file-other-window)

(my-global-set-key "h" 'man)

(my-global-set-key "i" 'my-indent-buffer)

(my-global-set-key "j" 'browse-url)

(my-global-set-key "k" 'my-kill-current-buffer)

(my-set-lsp-key "h" 'lsp-describe-thing-at-point)

(my-set-lsp-key "n" 'lsp-breadcrumb-narrow-to-symbol)

(my-set-lsp-key "r" 'lsp-rename)

(my-global-set-key "m" 'imenu)

(my-global-set-key "n" 'windmove-down)

(my-set-ispell-key "c" 'ispell-comments-and-strings)

(my-set-ispell-key "d" 'ispell-change-dictionary)

(my-set-ispell-key "e" 'my-ispell-en)

(my-set-ispell-key "f" 'my-ispell-fr)

(my-set-ispell-key "o" 'ispell)

(my-global-set-key "p" 'windmove-up)

(my-global-set-key "s" 'my-git-grep)

(my-global-set-key "t" 'my-transpose-windows)

(my-global-set-key "u" 'winner-undo)

(my-global-set-key "x" 'counsel-git)

(my-global-set-key "v" 'my-ansi-term)

(my-global-set-key "w" 'whitespace-cleanup)

(my-global-set-key "y" 'blink-matching-open)

;; Enable smerge-mode when necessary.
(add-hook 'find-file-hook 'my-try-smerge t)

(add-hook 'conf-mode-hook 'my-indent-tabs-mode-on)

(add-hook 'message-mode-hook 'my-message-mode-hook-f)

(add-hook 'csv-mode-hook 'my-csv-mode-hook-f)

(load-theme 'modus-operandi t)

;;; Emacs server
(server-start)