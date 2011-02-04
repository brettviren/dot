(setq scroll-step 1
      next-screen-context-lines 1
      line-number-mode t
      column-number-mode t
      mouse-yank-at-point t
      user-mail-address "bv@bnl.gov"
      display-time-mode t
      scroll-bar-mode (quote right)
      show-paren-mode t
      size-indication-mode t
      transient-mark-mode t
      inhibit-splash-screen t
      )

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "sensible-browser")

(global-font-lock-mode 1)
(iswitchb-mode t)
(setq auto-mode-alist (append 
		       (mapcar 'purecopy
			       '(
				 ("rc$" . conf-mode)
				 ))
		       auto-mode-alist))
