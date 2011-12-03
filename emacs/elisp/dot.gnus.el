;; GNUS

;;(shell-command "gnus-sync pull")

;; for mairix based searching
;; http://www.emacswiki.org/emacs/GnusMairix
;; http://www.randomsample.de/nnmairix-doc/nnmairix.html#nnmairix
;(require 'nnmairix)

;; Generic setup
;(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)
;(setq gnus-group-mode-line-format "Gnus: %%b {%S}")

;; Big Brother Data Base integration
(require 'bbdb-gnus)


(defun my-message-setup-hook ()
  (bbdb-define-all-aliases)
  (local-set-key "\M-TAB" 'bbdb-complete-name)
  )
(add-hook 'message-setup-hook 'my-message-setup-hook)
(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus) 
(add-hook 'gnus-startup-hook 'bbdb-insinuate-message) 
(add-hook 'gnus-startup-hook '(lambda () (variable-pitch-mode t)) )


;; Search imap

;; (define-key gnus-group-mode-map (kbd "G")
;;    '(lambda ()
;;       (interactive)
;;       (offlineimap)
;;       )
;;    )
;; (define-key gnus-group-mode-map (kbd "O")
;;    '(lambda ()
;;       (interactive)
;;       (switch-to-buffer "*OfflineIMAP*")
;;       )
;;    )

;; cert signed mail
; http://www.emacswiki.org/emacs/GnusSMIME
;(setq mm-decrypt-option 'always)
;(setq mm-verify-option 'always)
;(setq gnus-buttonized-mime-types '("multipart/encrypted" "multipart/signed"))
;(setq smime-keys (quote (("bv@bnl.gov" "/home/bviren/git/dot/certs/mine/cert-and-key.pem" nil))))
;(setq smime-CA-directory "/home/bviren/git/dot/certs/root")
;(setq smime-certificate-directory "/home/bviren/git/dot/certs/others")
;(setq password-cache t)
;(setq password-cache-expiry 86400)
;(add-hook 'message-send-hook 'mml-secure-message-sign-smime)

;; pgp signed mail
; http://www.emacswiki.org/emacs/GnusPGG
(require 'pgg)
;; verify/decrypt only if mml knows about the protocl used
(setq mm-verify-option 'known)
(setq mm-decrypt-option 'known)
;; Here we make button for the multipart 
(setq gnus-buttonized-mime-types '("multipart/encrypted" "multipart/signed"))
;; Automatically sign when sending mails
(add-hook 'message-send-hook 'mml-secure-message-sign-pgpmime)
;; Enough explicit settings
(setq pgg-default-user-id "bv"
      pgg-gpg-use-agent t)


;; Find gpg2
;(defcustom pgg-gpg-program "gpg2"
;  "The GnuPG executable."
;  :group 'pgg-gpg
;  :type 'string)


;; Tells Gnus to inline the part
(eval-after-load "mm-decode"
  '(add-to-list 'mm-inlined-types "application/pgp$"))
;; Tells Gnus how to display the part when it is requested
(eval-after-load "mm-decode"
  '(add-to-list 'mm-inline-media-tests '("application/pgp$"
                                         mm-inline-text identity)))
;; Tell Gnus not to wait for a request, just display the thing
;; straight away.
(eval-after-load "mm-decode"
  '(add-to-list 'mm-automatic-display "application/pgp$"))
;; But don't display the signatures, please.
(eval-after-load "mm-decode"
  (quote (setq mm-automatic-display (remove "application/pgp-signature"
                                            mm-automatic-display))))
;;; end ppg

(setq gnus-group-line-format "%M%S%p%P%5y:%B%(%G%)%l %O\n")
(setq gnus-parameters
      '(
	("^nnimap.*"
	 (gcc-self . t)
	 )
	("bnl:.*"
	 (comment . "bnl")
	 ;(display . all)
	 (gcc-self . t)
	 )
	("gmail:.*"
	 (comment . "gmail")
	 (posting-style
	  (address "brett.viren@gmail.com"))
	 )
	))

;; Handle multiple SMTP accounts using a mixture of these:
;; http://www.emacswiki.org/cgi-bin/wiki/MultipleSMTPAccounts
;; http://www.emacswiki.org/cgi-bin/wiki/GnusMSMTP
;; http://www.emacswiki.org/cgi-bin/wiki/GnusGmail
(defun set-smtp-local ()
  "Send mail to localhost server"
  (setq smtpmail-smtp-server "localhost"))

(set-smtp-local)			;default

(defun set-smtp-gmail ()
  "Set up smtp through gmail"
  (setq smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
	smtpmail-smtp-server "smtp.gmail.com"
	smtpmail-default-smtp-server "smtp.gmail.com"
	smtpmail-smtp-service 587
	smtpmail-auth-credentials '(("smtp.gmail.com" 587
				     "brett.viren@gmail.com" nil))))

(defun change-smtp ()
  "A function to switch between the two"
  (if (message-mail-p)
      (save-excursion
	(let* ((from (save-restriction
		       (message-narrow-to-headers)
		       (message-fetch-field "from"))))
	  (cond
	   ((string-match "bv@bnl.gov" from) (set-smtp-local))
	   ((string-match "bviren@bnl.gov" from) (set-smtp-local))
	   ((string-match "brett.viren@gmail.com" from) (set-smtp-gmail))
	   (t set-smtp-local))))))

(add-hook 'message-send-hook 'change-smtp)


;; Reading mail
;; http://www.emacswiki.org/emacs/MimeTypesWithGnus
;; Never show vcard stuff, I never need it anyway
(setq gnus-ignored-mime-types 
      '("text/x-vcard"))
;; Plop MS Doc files through antiword, stripping them of evilness
(add-to-list 'mm-inline-media-tests
	     '("application/msword" mm-inline-text identity))
(add-to-list 'mm-automatic-external-display "application/msword")
(add-to-list 'mm-attachment-override-types "application/msword")
;;(add-to-list 'mm-automatic-display "application/msword")


;; Local system mail
(setq gnus-select-method 
      '(nnml "private"))
(setq nnml-directory "~/nnml")
(setq nnml-active-file "~/nnml/active")

(setq gnus-treat-date-lapsed 'head)
(setq gnus-article-date-lapsed-new-header t)
;(gnus-start-date-timer)
;; show both date and time since
;; (setq gnus-treat-date-user-defined 'head
;;       gnus-article-time-format
;;       (lambda (time)
;; 	(let ((date (message-make-date time)))
;; 	  (format "%s\n%s\n%s"
;; 		  (article-make-date-line date 'original)
;; 		  (article-make-date-line date 'local)
;; 		  (article-make-date-line date 'lapsed)))))




;; Archiving sent mail
(setq gnus-message-archive-group
      '((concat "mail.outbox." (format-time-string "%Y-%m"))))

;; Handle duplicates
(setq nnmail-treat-duplicates 'delete)
(setq gnus-summary-ignore-duplicates 'delete)

;; How do I look?
(setq gnus-posting-styles
      '(

	(".*"
	 (name "Brett Viren")
	 (address "bv@bnl.gov"))

	("lists.fnal.linux"
	 (address "bviren@minos.phy.bnl.gov"))

	("mail.minos.software.offline"
	 (address "bviren@bnl.gov"))

	("lists.bnl.ssh-admins"
	 (address "bviren@bnl.gov"))

	(header "to" "minos_software_discussion"
	 (address "bviren@bnl.gov"))

	(header "cc" "minos_software_discussion"
	 (address "bviren@bnl.gov"))
	))

;;;;;;;;;;;;;;;;;;;;;;
;; Rest is for IMAP ;;
;;;;;;;;;;;;;;;;;;;;;;

;; keep flags on server
(setq gnus-agent-synchronize-flags t)
;(setq gnus-agent nil)

(setq gnus-secondary-select-methods
      '(

	;; (nnmaildir "main" 
	;; 	   (directory "~/.nnmaildir")
	;; 	   ;(target-prefix "../Maildir/.")
	;; 	   )

	(nnimap "bnl"
;; ssl connection to imaps
;		(nnimap-address "home.phy.bnl.gov")
;		(nnimap-server-port 993)
;		(nnimap-stream ssl)
;; ssh tunneled to imap
;		(nnimap-address "localhost")
;		(nnimap-server-port 143)
;		(nnimap-stream network)
;		(nnimap-authenticator login)
;; directly call imap server.  
;; Need to set imap-shell-program
;; see git/dot/emacs/elisp/all/email.el
		(nnimap-stream shell)
		;(nnir-search-engine imap)
		)

	;; (nnimap "gmail"
	;;  	(nnimap-address "imap.gmail.com")
	;; 	(nnimap-server-port 993)
	;;  	(remove-prefix "INBOX.")
	;;  	(nnimap-stream ssl))

	(nnfolder "old-outgoing"
		  (nnfolder-directory "/home/bviren/Mail.pre-imap/archive")
		  (nnfolder-active-file "/home/bviren/Mail.pre-imap/archive/active")
		  (nnfolder-get-new-mail nil)
		  )
	)
      nnimap-split-inbox '("INBOX"))

