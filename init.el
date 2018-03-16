;;; Albaro Pereyra's default emacs config
(require 'package)
;;; Add repositories
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

;; Initialize packages before referencing them
(package-initialize)

;;; Make settings done though Emacs persistant on a different file.
(setq custom-file "~/.emacs.d/.emacs-custom.el")
(load custom-file)

;;; Install required pacakages
; Create a list of packages to install if not already installed
(setq package-list '(zenburn-theme magit jdee ensime xclip))
; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;;; Save emacs session, hopefully this will highlight the manual pages I have visited
(desktop-save-mode 1)
;; Set the number of buffers to restore eagerly, the rest will be restored when emacs is idle
(setq desktop-restore-eager 4)
;;;more on cocurency
(savehist-mode)

;;; Set default theme
(add-hook 'after-init-hook 
	  (lambda () (load-theme 'zenburn t)))

;;; Enable version control
(setq version-control t)

;;; Add line numbers to buffer
(add-hook 'prog-mode-hook 'linum-mode)
(setq linum-format "%4d \u2502 ")

;;; Add file sets menu
(filesets-init)

;;; Set tabs to spaces
;; Convert tabs to spaces, indent-tabs-mode
;; I may have to manually add every languague such as js and sgml
(setq-default
 indent-tabs-mode nil
 js-indent-level 2
 standard-indent 2
 tab-width 2
 sgml-basic-offset 2
 c-basic-offset 2
 sh-basic-offset 2
 sh-indentation 2)

;;; Set default style
;;; k&r = if (true) {
;;;         action.do();
;;;       }
;;; For the sake of clarity and fine tunning I left in other
(setq c-default-style
           '((java-mode . "k&r")
             (other . "k&r")))

;;; Print current function in mini buffer
(setq which-func-modes t)

;;; Set automatic matching braces or brackets.
(electric-pair-mode t)

;;; Set to parse local functions, in C, Java, HTML, etc.
;; TODO read more on the simantec mode
(semantic-mode t)

;;; Set automatic new lines in some languagues after a ';'
(electric-layout-mode t)

;;; Print all man pages
(setq Man-switches "-a")

;;; Bind indentation for C to return '\n'
(defun my-bind-clb ()
  (define-key c-mode-base-map "\C-m"
    'c-context-line-break))
(add-hook 'c-initialization-hook 'my-bind-clb)

;;; Print warning for suspecious C code
(global-cwarn-mode t)

;;; Set error flags on the Fly for C++ and HTML etc.
(flymake-mode t)

;;; Set on the fly spell checke
;; Disabled for logs
(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
  (add-hook hook (lambda () (flyspell-mode -1))))

;;; Set on the fly spell checker for comments
(setq flyspell-prog-mode t)

;;; Set calendar week to start on Monday
(setq calendar-week-start-day 1)

;;; Set appointment notifications
(setq appt-active 1)

;;; Find file upgrade
(ffap-bindings); do default key bindings on C-x, C-f

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)
;;remove menu items
(setq menu-bar-mode -1)

;;; Fix M-x shell by replacing zsh with sh
;;; M-x eshell seems to work better with emacs
(setq explicit-shell-file-name "/bin/sh")
(setq shell-file-name "sh")
(setq explicit-sh-args '("-"))
(setenv "SHELL" shell-file-name)
(add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)

;;; Magit recomended key bindings
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)
;;; Key binding the enable magit mode
(global-set-key (kbd "C-x M-m") 'global-magit-file-mode)

;;; Ensime settings
(global-set-key "\C-c\C-z." 'browse-url-at-point)
(global-set-key "\C-c\C-zb" 'browse-url-of-buffer)
(global-set-key "\C-c\C-zr" 'browse-url-of-region)
(global-set-key "\C-c\C-zu" 'browse-url)
(global-set-key "\C-c\C-zv" 'browse-url-of-file)
(add-hook 'dired-mode-hook
	  (lambda ()
	    (local-set-key "\C-c\C-zf" 'browse-url-of-dired-file)))

;;; Set email message sending method
; (setq message-send-mail-function 'sendmail-send-it)
;;; Set email signature
;; You must create a signature in ~/.sinature
; (setq message-signature t)

;;; MAC OS settings ;;;
;;Allow Killing and Yanking on MacOS clipboard
; (defun copy-from-osx ()
;    (shell-command-to-string "pbpaste"))
; (defun paste-to-osx (text &optional push)
;    (let ((process-connection-type nil))
;       (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
;          (process-send-string proc text)
;          (process-send-eof proc))))
