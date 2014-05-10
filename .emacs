;;; The .emacs file of Trinity
;;;   last updated 10 May 2014, 11:24:58 tquirk

(defalias 'perl-mode 'cperl-mode)

(setq-default transient-mark-mode nil)
(setq-default show-trailing-whitespace t)
(setq-default indent-tabs-mode nil)
(setq require-final-line t)
(setq coding-system-for-read 'undecided-unix)
(setq line-move-visual nil)
(setq default-major-mode 'fundamental-mode)
(setq next-line-add-newlines nil)
(setq make-backup-files nil)
(setq fill-column 74)
(setq display-time-day-and-date t)
(setq display-time-24hr-format t)
;;; Macs require some massaging
(if (eq system-type 'darwin)
    (progn
      (setq dired-use-ls-dired nil)
      (setq x-alt-keysym 'meta)))

;;; Font-lock stuff
(global-font-lock-mode t)
(setq font-lock-maximum-decoration
      '((c-mode . 2)
	(c++-mode . 2)
	(cperl-mode . 2)
	(java-mode . 2)))

;;; Timestamp stuff
(add-hook 'write-file-hooks 'time-stamp)
(setq time-stamp-active t)
(setq time-stamp-format "%02d %3b %4y, %02H:%02M:%02S %u")
(setq time-stamp-start "last updated ")
(setq time-stamp-end "$")

;;; Code folding stuff
; Hideshow
;(load-library "hideshow")
;(add-hook 'cperl-mode-hook 'hs-minor-mode)
; Outline minor mode
(add-hook 'cperl-mode-hook 'outline-minor-mode)
(define-prefix-command 'cm-map nil "Outline-")
(define-key cm-map "C-<left>" 'hide-subtree)
(define-key cm-map "C-<right>" 'show-subtree)
(define-key cm-map "C-<up>" 'hide-sublevels)
(define-key cm-map "C-<down>" 'show-all)
(global-set-key "C-@" cm-map)

;;; Functions
(defun perltidy-buffer ()
  "Run perltidy on the current buffer and open a new buffer with the output"
  (interactive)
  (shell-command (concat "perltidy -st " (buffer-file-name (current-buffer))))
  (beginning-of-buffer))

(defun list-contains-p (list atom)
  "Search a list for a given atom"
  (or (equal (car list) atom)
      (and (not (null (cdr list)))
	   (list-contains-p (cdr list) atom))))

(defun open-on-second-screen (disp)
  "Open a frame on a secondary display"
  (interactive "sDisplay: ")
  (progn
    (if (not (list-contains-p (x-display-list) disp))
	(x-open-connection disp))
    (make-frame-on-display disp)))

;; Set a key to run our new function
(global-set-key "\C-x55" '(open-on-second-screen ":0.1"))

(defun sum-times (p1 p2)
  "Find time values in the region and sum them"
  (interactive "r")
  (let ((minutes 0) (seconds 0))
    (goto-char p1)
    (while (re-search-forward "\\([0-9][0-9]*\\):\\([0-9][0-9]\\)" p2 t)
      (setq minutes (+ minutes (string-to-number (match-string 1))))
      (setq seconds (+ seconds (string-to-number (match-string 2))))
      (if (> (/ seconds 60) 0)
	  (progn
	    (setq minutes (+ minutes (/ seconds 60)))
	    (setq seconds (% seconds 60)))))
    (goto-char p2)
    (insert (format "%02d:%02d" minutes seconds))))

;;; Programming mode settings
(setq cperl-indent-level 4)
(setq cperl-continued-statement-offset 0)
(setq cperl-brace-offset -4)
(setq cperl-label-offset -2)

(defconst trinity-c-style
  '((c-basic-offset . 4)
    (c-offsets-alist . ((case-label . *)
			(access-label . /)
			(statement-case-intro . *)
			(substatement-open . 0)
			))
    )
  "Trinity's C Programming Style")
(defun trinity-c-mode-common-hook ()
  (c-add-style "PERSONAL" trinity-c-style t))

(add-hook 'c-mode-common-hook 'trinity-c-mode-common-hook)
(add-hook 'lsl-mode-common-hook 'trinity-c-mode-common-hook)

(setq auto-mode-alist
      (append '(("\\.c$" . c-mode)
		("\\.h$" . c-mode)
		("\\.y$" . c-mode)
		("\\.cc$" . c++-mode)
		("\\.C$" . c++-mode)
		("\\.m$" . objc-mode)
		("\\.java$" . java-mode)
		("\\.S$" . asm-mode)
		("\\.sgml$" . sgml-mode)
		("\\(Im\\|M\\|m\\)?akefile.*$" . makefile-mode)
		("\\.pov$" . pov-mode)
		("\\.inc$" . pov-mode)
		("\\.lsl$" . lsl-mode)
		("\\.pl$" . cperl-mode)
		("\\.t$" . cperl-mode)
		("\\.pm$" . cperl-mode)
		) auto-mode-alist))

;;; Loading modules
(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/elisp/pov-mode")

(autoload 'lsl-mode "lsl-mode.el" "Linden Scripting Language mode" t)
(autoload 'pov-mode "pov-mode.el" "POVray scene file mode" t)

;;; Other stuff
(put 'downcase-region 'disabled nil)
(tool-bar-mode -1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(display-time-mode t))

(custom-set-faces
 '(font-lock-comment-face ((t (:foreground "#FFE4B5"))))
 '(font-lock-string-face ((t (:foreground "#FFA500"))))
 '(font-lock-keyword-face ((t (:foreground "#00FFFF"))))
 '(font-lock-builtin-face ((t (:foreground "#B0C4DE"))))
 '(font-lock-function-name-face ((t (:foreground "#778899"))))
 '(font-lock-variable-name-face ((t (:foreground "#00FF00"))))
 '(font-lock-type-face ((t (:foreground "#FFFF00"))))
 '(font-lock-reference-face ((t (:foreground "#00FF00"))))
 '(font-lock-warning-face ((t (:foreground "#FF4500")))))
