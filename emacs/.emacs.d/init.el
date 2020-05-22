(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
		    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(require 'use-package-ensure)
(setq use-package-verbose t)

(global-set-key (kbd "<f5>") 'other-window)
(global-set-key (kbd "C-`") 'linum-mode) ; toggle line numbers

(setq-default cursor-type 'bar)		; slim cursor
(setq inhibit-startup-screen 1)		; no startup screen
(setq initial-scratch-message nil)	; no startup scratch message
(setq doc-view-continuous t)		; pull screen view along when cursor reaches edges
(setq sentence-end-double-space nil)	; set sentence to end with single space
(setq visible-bell nil			; remove annoying bell on C-g
      ring-bell-function 'flash-mode-line) ;
(defun flash-mode-line ()		   ; flash mode-line on C-g
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil #'invert-face 'mode-line))
(delete-selection-mode 1)		; delete over a selection region on insert
(fset 'yes-or-no-p 'y-or-n-p)		; use "y/n" instead of "yes/no"
(global-linum-mode 0)			; no line numbering
(global-visual-line-mode 1)		; wrap text
(setq fill-column 80)

;; (add-to-list 'default-frame-alist '(fullscreen . fullboth)) ;fullscreen start
;; (add-to-list 'default-frame-alist '(fullscreen . maximized)) ;start fullscreen
;; (scroll-bar-mode -1)			; remove scroll bar
;; (tool-bar-mode -1)			; remove toolbar
;; (menu-bar-mode -1)			; remove menu bar

(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)
(recentf-mode 0)

;; (use-package zenburn-theme
;; 	:ensure t
;; 	:init (load-theme 'zenburn t))

(use-package solarized-theme
  :ensure t
  :init (load-theme 'solarized-dark t)); or -light

;; (use-package leuven-theme
;; 	:ensure t
;; 	:init (load-theme 'leuven t))

(use-package smart-mode-line
  :ensure t
  :init
  (sml/setup))

(display-battery-mode)

;; (use-package symon
;;   :ensure t
;;   :init (setq symon-monitors
;; 		'(symon-linux-memory-monitor
;; 		  symon-linux-cpu-monitor
;; 		  symon-linux-network-rx-monitor
;; 		  symon-linux-network-tx-monitor
;; 		  symon-linux-battery-monitor))
;;   :hook ((after-init-hook) . symon-mode))

;; (use-package smartparens
;;   :hook ((prog-mode text-mode) . smartparens-mode))

(use-package company
   :ensure t
:init
(add-hook 'after-init-hook 'global-company-mode))

(use-package rainbow-delimiters
  :ensure t
:hook ((prog-mode) . rainbow-delimiters-mode))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package yasnippet
:ensure t
:init
(add-to-list 'load-path
	     "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1))

(require 're-builder)
(setq reb-re-syntax 'string)

(use-package paredit
  :ensure t
  :init
  (autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
  (add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
  (add-hook 'ielm-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook           #'enable-paredit-mode)
  (add-hook 'slime-repl-mode-hook (lambda () (paredit-mode +1))))

(use-package which-key
  :ensure t
  :init
  (which-key-mode 1))

;; (use-package helm
;;   :init
;;   (helm-mode t)
;;   :bind
;;   (("M-x" . helm-M-x)
;;    ("C-x r b" . helm-filtered-bookmarks)
;;    ("C-x C-f" . helm-find-files))
;;   ;; :init
;;   ;; (helm-mode 1)
;;   :custom
;;   (helm-mode-fuzzy-match t)
;;   (helm-completion-in-region-fuzzy-match t))

;; (use-package ace-window
;;   :bind ("M-o" . ace-window)
;;   :config (setq aw-dispatch-always t))

(use-package ivy
    :ensure t
  :demand
  :bind ("C-c C-r" . ivy-resume)
  :config
  (setq magit-completing-read-function 'ivy-completing-read)
  (setq projectile-completion-system 'ivy)
  (setq ivy-use-virtual-buffers nil
	ivy-count-format "%d/%d "))

(ivy-mode 1)

(use-package swiper
  :ensure t
  :config (setq search-default-mode #'char-fold-to-regexp)
  :bind ("C-s" . swiper))

(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file)
	 ("<f1> f" . counsel-describe-function)
	 ("<f1> v" . counsel-describe-variable)
	 ("<f1> l" . counsel-find-library)
	 ("<f2> i" . counsel-info-lookup-symbol)
	 ("<f2> u" . counsel-unicode-char)
	 ("C-c g" . counsel-git)
	 ("C-c j" . counsel-git-grep)
	 ("C-c k" . counsel-ag)
	 ("C-x l" . counsel-locate)
	 ("C-S-o" . counsel-rhythmbox)
	 ("C-r" . counsel-minibuffer-history)))

(use-package pdf-tools
  :pin manual ;; manually update
  :config
  ;; initialise
  (pdf-tools-install)
  ;; open pdfs scaled to fit page
  (setq-default pdf-view-display-size 'fit-page)
  ;; automatically annotate highlights
  (setq pdf-annot-activate-created-annotations t)
  ;; use normal isearch
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward))

;; (use-package org-pdfview
;;   :ensure t
;;   :config
;;   (eval-after-load 'org '(require 'org-pdfview))
;;   (add-to-list 'org-file-apps 
;; 		    '("\\.pdf\\'" . (lambda (file link)
;; 				      (org-pdfview-open link)))))

(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")))

;; (use-package projectile)
;; (projectile-mode +1)
;; (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
;; (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
;; (setq projectile-project-search-path '("~/"))

;; (load "~/.emacs.d/elisp/password-store")

;; (use-package pass
;;   :ensure t)

;; (use-package ivy-pass
;;   :ensure t)

(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/")
             t)
     (add-to-list 'package-pinned-packages '(magit . "melpa-stable"))

     (add-to-list 'package-pinned-packages '(ghub . "melpa-stable"))
(add-to-list 'package-pinned-packages '(git-commit . "melpa-stable"))
(add-to-list 'package-pinned-packages '(magit-popup . "melpa-stable"))
     (add-to-list 'package-pinned-packages '(with-editor . "melpa-stable"))

(use-package elpy
  :ensure t
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable)
  (setq elpy-rpc-virtualenv-path 'current))

(setq flycheck-python-pycompile-executable "python3"
      flycheck-python-pylint-executable "python3"
      flycheck-python-flake8-executable "python3")
(setq python-shell-interpreter "python3"
      python-shell-interpreter-args "-i")
(setq org-babel-python-command "python3")
;; (python-shell-completion-native-disabled-interpreters (quote ("python3")))

(use-package py-autopep8
  :ensure t
  :init
  (add-hook 'python-mode-hook 'py-autopep8-enable-on-save))

;; (use-package pyenv-mode)		;M-x pyvenv-activate

(use-package ess
  :init (require 'ess-rutils))

(use-package slime)
;; (setq inferior-lisp-program "sbcl")
;;   (slime-setup '(slime-company))
;;   (load (expand-file-name "~/quicklisp/slime-helper.el"))

(use-package geiser
  :ensure t
  :config
  (setq geiser-default-implementation 'mit)
  (setq geiser-active-implementations '(mit))
  :hook ((scheme-mode-hook) . geiser-mode))

(eval-after-load "tex" 
 '(setcdr (assoc "LaTeX" TeX-command-list)
	  '("%`%l%(mode) -shell-escape%' %t"
	    TeX-run-TeX nil (latex-mode doctex-mode) :help "Run LaTeX")))

(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-source-correlate-start-server t)

(setq tex-bibtex-command "biber")
(setq TeX-parse-self t)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ; with AUCTeX LaTeX mode
   (add-hook 'latex-mode-hook 'turn-on-reftex)   ; with Emacs latex mode
   (setq reftex-plug-into-AUCTeX t)
   ;; So that RefTeX also recognizes \addbibresource. Note that you
   ;; can't use $HOME in path for \addbibresource but that "~"
   ;; works.
   (setq reftex-bibliography-commands '("bibliography" "nobibliography" "addbibresource"))
   (eval-after-load 'reftex-vars
'(progn
   ;; (also some other reftex-related customizations)
   (setq reftex-cite-format
         '((?\C-m . "\\cite[]{%l}")
           (?f . "\\footcite[][]{%l}")
           (?t . "\\textcite[]{%l}")
           (?p . "\\parencite[]{%l}")
           (?o . "\\citepr[]{%l}")
           (?n . "\\nocite{%l}")))))

(setq bibtex-dialect 'biblatex)

(use-package ivy-bibtex
  :ensure t)

;; (use-package ebib
;;   :ensure t
;;   :bind (("C-c C-e" . ebib)
;; 	   ("C-c b" . ebib-insert-citation))
;;   :config
;;   (setq ebib-bibtex-dialect "biblatex")
;;   (setq ebib-layout 'custom))

(use-package org
  ;; :bind
  ;; (("\C-cl" . org-store-link)
  ;;  ("\C-ca" . org-agenda)
  ;;  ("\C-cc" . org-capture)
  ;;  ("\C-cb" . org-switchb))
  :config
  (unless (string-match-p "\\.gpg" org-agenda-file-regexp)
  (setq org-agenda-file-regexp
	(replace-regexp-in-string "\\\\\\.org" "\\\\.org\\\\(\\\\.gpg\\\\)?"
				  org-agenda-file-regexp))) ;https://emacs.stackexchange.com/questions/36542/include-org-gpg-files-in-org-agenda
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((lisp . t)
     (R . t)
     (latex . t)
     (python . t)
     (shell . t)
     (scheme . t)))
  (setq org-confirm-babel-evaluate nil)
  (add-to-list 'org-structure-template-alist
	       '("r" . "src R :results output :colnames yes :hline yes :session rsession1 :tangle yes :comments link :exports both :eval never-export"))
  (add-to-list 'org-structure-template-alist
	       '("g" . "src R :file chart.png :res 100 :height 400 :width 600 :results output graphics :colnames yes :session rsession1 :exports both :eval never-export"))
  (add-to-list 'org-structure-template-alist
	       '("p" . "src python :results output :colnames yes :session pysession1 :tangle yes :comments link :exports both :eval never-export"))
  :custom
  (org-list-allow-alphabetical t)
  (org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-irc org-mhe org-rmail org-w3m org-drill org-eval org-learn)))
  (org-todo-keywords (quote ((sequence "TODO" "WAITING" "|" "CLOSED"))))
  (org-drill-cram-hours 0)
  (org-log-done 'time)
  (org-link-file-path-type "relative")
  (org-todo-keywords '((sequence "TODO" "WAITING" "|" "CLOSED")))
  (org-agenda-time-grid
   (quote
    ((daily weekly today)
     (800 1000 1200 1400 1600 1800 2000)
     "......" "----------------"))))

(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
(add-hook 'org-mode-hook 'org-display-inline-images)
(if (require 'toc-org nil t)
(add-hook 'org-mode-hook 'toc-org-mode)
(warn "toc-org not found"))

(setq org-latex-minted-options '(("frame" "lines")
				 ("fontsize" "\\scriptsize")
				 ("xleftmargin" "\\parindent")
				 ("linenos" "")))
(setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))
;; (require 'ox-latex)
;; (setq org-latex-listings (quote minted))

;; (use-package toc-org
;; :ensure t)

;; (use-package pandoc-mode
;; :ensure t)

;; (use-package ox-pandoc
;; :ensure t)

;; (use-package org-super-agenda)

;; (setq org-agenda-skip-scheduled-if-done t
;; 	     org-agenda-skip-deadline-if-done t
;; 	     org-agenda-include-deadlines t
;; 	     org-agenda-include-diary nil
;; 	     org-agenda-block-separator nil
;; 	     org-agenda-compact-blocks t
;; 	     org-agenda-start-with-log-mode t
;; 	     org-agenda-start-on-weekday 1
;; 	     org-deadline-warning-days 30)

;; (setq org-agenda-custom-commands
;; 	     '(("v" "week-overview"
;; 		((agenda ""
;; 			 ((org-super-agenda-groups
;; 			   '((:discard (:tag ("drill")
;; 					     :regexp "CLOSED")
;; 				       :order 0)
;; 			     (:name "Residual Tasks"
;; 				    :scheduled past
;; 				    :deadline past
;; 				    :order 2
;; 				    )
;; 			     (:name "Schedule"
;; 				    :time-grid t
;; 				    :order 3)
;; 			     (:name "Current Tasks"
;; 				    :scheduled today
;; 				    :order 4)
;; 			     (:name "Waiting"
;; 				    :todo "WAITING"
;; 				    :order 5)
;; 			     (:name "Unscheduled Future Deadlines"
;; 				    :and (:not (:scheduled future)
;; 					       :deadline future)
;; 				    :order 6)
;; 			     (:name "Future Tasks"
;; 				    :deadline t
;; 				    :scheduled t
;; 				    :order 7)))))
;; 		 (todo "WAITING" ((org-agenda-overriding-header "Waiting")
;; 				  (org-agenda-todo-ignore-with-date 1)))
;; 		 (todo "TODO"
;; 		       ((org-agenda-overriding-header "")
;; 			(org-agenda-todo-ignore-with-date 1)
;; 			(org-super-agenda-groups
;; 			 '((:name "Reserve Tasks"
;; 				  :tag ("reserve")
;; 				  :order 1)
;; 			   (:name "Unscheduled Tasks"
;; 				  :anything t
;; 				  :order 0)))))))))

(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(setq package-check-signature nil)

;; (use-package calfw
;; 	 :ensure t)
;; (use-package calfw-org
;; 	 :ensure t)

;; (use-package org-ref
;; 	 :ensure t
;; 	 :config
;; 	 (require 'org-id)
;; 	 (require 'org-ref-wos)
;; 	 (require 'org-ref-scopus)
;; 	 (require 'org-ref-pubmed)
;; 	 (require 'doi-utils)
;; 	 (setq bibtex-autokey-year-length 4
;; 	 bibtex-autokey-name-year-separator "-"
;; 	 bibtex-autokey-year-title-separator "-"
;; 	 bibtex-autokey-titleword-separator "-"
;; 	 bibtex-autokey-titlewords 2
;; 	 bibtex-autokey-titlewords-stretch 1
;; 	 bibtex-autokey-titleword-length 5)
;; 	 (setq org-export-with-broken-links t)
;; 	 ;; (setq org-latex-pdf-process
;; 	 ;;       '("pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f"
;; 	 ;; 	"bibtex %b"
;; 	 ;; 	"makeindex %b"
;; 	 ;; 	"pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f"
;; 	 ;; 	"pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f"))
;; 	 (setq  org-latex-pdf-process
;; 	'("latexmk -shell-escape -bibtex -pdf %f"))
;; 	 (setq org-ref-completion-library 'org-ref-ivy-cite))

(use-package markdown-mode
  :defer t)

(use-package polymode
  :ensure t)

(use-package poly-R
  :ensure t)

(use-package poly-markdown
  :ensure t)

(use-package poly-org
  :ensure t)

;; (use-package ledger-mode
;;   :defer t)

(use-package eval-in-repl
  :ensure t
  :init
  (require 'eval-in-repl-ielm)
  (define-key emacs-lisp-mode-map (kbd "<C-return>") 'eir-eval-in-ielm)
  ;; for *scratch*
  (define-key lisp-interaction-mode-map (kbd "<C-return>") 'eir-eval-in-ielm)
  ;; for M-x info
  (define-key Info-mode-map (kbd "<C-return>") 'eir-eval-in-ielm)
  ;;; Geiser support (for Racket and Guile Scheme)
  ;; When using this, turn off racket-mode and scheme supports
  ;; (require 'geiser) ; if not done elsewhere
  (add-hook 'geiser-mode-hook
       	     '(lambda ()
       		(local-set-key (kbd "<C-return>") 'eir-eval-in-geiser)))

  ;; (require 'scheme)    ; if not done elsewhere
  ;; (require 'cmuscheme) ; if not done elsewhere
  ;; (require 'eval-in-repl-scheme)
  ;; (add-hook 'scheme-mode-hook
  ;; 		 '(lambda ()
  ;; 		    (local-set-key (kbd "<C-return>") 'eir-eval-in-scheme)))

  ;; shell support
  (require 'eval-in-repl-shell)
  (add-hook 'sh-mode-hook
	    '(lambda()
	       (local-set-key (kbd "C-<return>") 'eir-eval-in-shell))))

;; (setq load-path (cons "/usr/local/share/mdk" load-path))
;; (autoload 'mixal-mode "mixal-mode" t)
;; (add-to-list 'auto-mode-alist '("\\.mixal\\'" . mixal-mode))
;; (autoload 'mixvm "mixvm" "mixvm/gud interaction" t)

(use-package j-mode
  :ensure t
  :init
  (local-set-key (kbd "C-c !") 'j-console)
  (local-set-key (kbd "C-<return>") 'j-console-execute-line)
  (custom-set-faces
   '(j-verb-face ((t (:foreground "Red"))))
   '(j-adverb-face ((t (:foreground "Green"))))
   '(j-conjunction-face ((t (:foreground "Blue"))))
   '(j-other-face ((t (:foreground "Black"))))))
