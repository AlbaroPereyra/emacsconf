;;; Albaro Pereyra's default emacs config
;;; Before deploying run: touch ~/.emacs.d/.emacs-custom.el

(require 'package)
;;; Add repositories
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;;; Initialize packages before referencing them
(package-initialize)

;;; Make settings done though Emacs persistant on a different file.
(setq custom-file "~/.emacs.d/.emacs-custom.el")
(load custom-file)

;;; Install required pacakages
; Create a list of packages to install if not already installed
(setq package-list '(zenburn-theme magit jdee ensime xclip php-mode sbt-mode hydra))
; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;;; Save emacs session
(desktop-save-mode t)
;;; Set the number of buffers to restore eagerly, the rest will be restored when emacs is idle
(setq desktop-restore-eager 3)
;;; more settings on cocurency
(savehist-mode)
(save-place-mode 1)

;;; Set default theme
(add-hook 'after-init-hook
  (lambda () (load-theme 'zenburn t)))

;;; Enable version control
(setq
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/.saves/"))    ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)       ; use versioned backups

;;; Add line numbers to buffer
(add-hook 'prog-mode-hook 'linum-mode)
  (setq linum-format "%4d \u2502 ")

;;; Add file sets menu
(filesets-init)

;;; Set tabs to spaces
;;; Convert tabs to spaces, indent-tabs-mode
;;; I may have to manually add every languague such as js and sgml
(setq
  indent-tabs-mode nil
  js-indent-level 2
  standard-indent 2
  tab-width 2
  sgml-basic-offset 2
  c-basic-offset 2
  sh-basic-offset 2
  sh-indentation 2
  php-mode-force-pear nil)

;;; Set default style to k&r:
;;; if (true) {
;;;   action.do();
;;; }
;;; For the sake of clarity and fine tunning I left in other default styles
(setq c-default-style
  '((java-mode . "k&r")
    (php-mode . "k&r")))

;;; enable abbreviation for jdee
(setq jdee-enable-abbrev-mode t)

;;; bind tab to jdee-complete in jdee mode
(add-hook 'jdee-mode-hook
  (lambda ()
    (define-key jdee-mode-map "\t"
      'jdee-complete)))
;;; return closes the open brace instead of new line
;;; jdee-electric-return-p ; looks like this var does not exist.
(setq jdee-electric-return-mode t)

;;; Scala settings
(add-hook 'sbt-mode-hook (lambda ()
  o(add-hook 'before-save-hook 'sbt-hydra:check-modified-buffers)))

;; allow interactive templates
(setq tempo-interactive t)

;;; Print current function in mini buffer
(setq which-func-modes t)

;;; Set automatic matching braces or brackets.
(setq electric-pair-mode t)

;;; Set to parse local functions, in C, Java, HTML, etc.
;;; TODO read more on the simantec mode
(setq semantic-mode t)

;;; Set automatic new lines in some languagues after a ';'
(setq electric-layout-mode t)

;;; Print all man pages
(setq Man-switches "-a")

;;; Bind indentation for C to return '\n'
(defun my-bind-clb ()
  (define-key c-mode-base-map "\C-m"
    'c-context-line-break))
(add-hook 'c-initialization-hook 'my-bind-clb)

;;; Print warning for suspecious C code
(setq global-cwarn-mode t)

;;; Set error flags on the Fly for C++ and HTML etc.
(setq flymake-mode t)

;;; Set on the fly spell checker
;;; Disabled for logs
(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
  (add-hook hook (lambda () (flyspell-mode -1))))

;;; Set on the fly spell checker for comments
(setq flyspell-prog-mode t)

;;; Set calendar week to start on Monday
(setq calendar-week-start-day 1)

;;; Set ERC IRC client settings
'(erc-modules
   (quote
    (autojoin button completion fill irccontrols list match menu move-to-prompt netsplit networks noncommands notifications readonly ring services sound stamp spelling track)))
 
;;; Set appointment notifications
(setq appt-active 1)

;;; Find file upgrade
(ffap-bindings); do default key bindings on C-x, C-f

;;remove menu items
(menu-bar-mode -1)

;;; Make scripts executable on save
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;;; Fix 'M-x shell' by replacing the default shell(zsh) with sh
;;; M-x eshell seems to work better with emacs
(setq explicit-shell-file-name "/bin/sh")
(setq shell-file-name "sh")
(setq explicit-sh-args '("-"))
(setenv "SHELL" shell-file-name)
(add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)

;;; Per the following guide:
;https://github.com/jdee-emacs/jdee-server
;;; Java Jdee settings
;'(jdee-electric-return-p t)
;'(jdee-server-dir "~/myJars")

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
;   (shell-command-to-string "pbpaste"))
; (defun paste-to-osx (text &optional push)
;   (let ((process-connection-type nil))
;     (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
;       (process-send-string proc text)
;       (process-send-eof proc))))
;
; (setq interprogram-cut-function 'paste-to-osx)
; (setq interprogram-paste-function 'copy-from-osx)
;;; Windows settings
;(normal-erase-is-backspace-mode 1)
