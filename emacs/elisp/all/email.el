;; set up email

;; http://lists.gnu.org/archive/html/info-gnus-english/2010-09/msg00004.html
(setq 
 gnus-startup-file "~/gnus/.newsrc"
 gnus-directory "~/gnus/"
 gnus-dribble-directory "~/gnus/"
 mail-source-directory "~/gnus/incoming/"
 gnus-cache-directory "~/gnus/cache/"
)

(setq gnus-init-file "~/dot/emacs/elisp/dot.gnus.el")
(setq gnus-inhibit-startup-message t)

;; Since we rely on OfflineIMAP to fill Maildir talk to the IMAP
;; server directly to avoid authentication.  In gnus-init-file set
;; nnimap-stream to shell to make use of this.
(setq imap-shell-program '("MAIL=maildir:$HOME/Maildir /usr/lib/dovecot/imap"))

;; sieve
;; http://josefsson.org/sieve/gnus-sieve.html
;; (autoload 'sieve-mode "sieve-mode")
;; (setq auto-mode-alist (cons '("\\.si\\(v\\|eve\\)\\'" . sieve-mode)
;;                             auto-mode-alist))
;; (require 'gnus-sieve)
;;(gnus-sieve-setup) undefined?

;; Deal with sync'ing gnus directory
;(add-hook 'gnus-after-exiting-gnus-hook
;	  (lambda ()
;	    (shell-command "gnus-sync push")))

;;; nnir imap serach/indexing
(require 'nnir)

;;; not much search/indexing
(add-to-list 'load-path "~/opt/notmuch/share/emacs/site-lisp")
(require 'notmuch)
(add-hook 'gnus-group-mode-hook
          (lambda ()
            (local-set-key "S" 'notmuch-search)))
;(setq notmuch-comand (expand-file-name "~/share/notmuch"))

;; crypto
;;;; mailcrypt, see info page
; (load-library "mailcrypt") ; provides "mc-setversion"
; (mc-setversion "gpg")    ; for PGP 2.6 (default); also "5.0" and "gpg"
; (autoload 'mc-install-write-mode "mailcrypt" nil t)
; (autoload 'mc-install-read-mode "mailcrypt" nil t)
; (add-hook 'mail-mode-hook 'mc-install-write-mode)
; for gnus:
; (add-hook 'gnus-summary-mode-hook 'mc-install-read-mode)
; (add-hook 'message-mode-hook 'mc-install-write-mode)
; (add-hook 'news-reply-mode-hook 'mc-install-write-mode)
; various
; (setq mc-gpg-user-id "Brett Viren <bv@bnl.gov>")
; (setq mc-gpg-keyserver "hkp://subkeys.pgp.net")
; (setq mc-passwd-timeout 86400)


;; http://metapundit.net/sections/blog/239
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-ignore-buffers-re "^\\*")

;;; BBDB
;; http://sachachua.com/wp/2008/04/wicked-cool-emacs-bbdb-set-up-bbdb/
;; http://www.emacs.uniyar.ac.ru/doc/em24h/emacs181.htm
;; http://emacs-fu.blogspot.com/2009/08/managing-e-mail-addresses-with-bbdb.html
;; http://bbdb.sourceforge.net/bbdb.html
(require 'bbdb)
(bbdb-initialize)
;(bbdb-initialize 'gnus 'message)
(setq 
 bbdb-north-american-phone-numbers-p nil ;; allow other phone numbers
 bbdb-offer-save 1                       ;; save w/out asking
 ;bbdb-use-pop-up t                      ;; allow popups for addresses
 bbdb-electric-p t                       ;; be disposable with SPC
 ;bbdb-popup-target-lines  1             ;; very small
 bbdb-dwim-net-address-allow-redundancy t ;; always use full name
 bbdb-quiet-about-name-mismatches nil     ;; show name-mismatches 2 secs
 bbdb-always-add-address t                ;; add new addresses to existing...
                                          ;; ...contacts automatically
 ;bbdb-canonicalize-redundant-nets-p t    ;; x@foo.bar.cx => x@bar.cx
 bbdb-completion-type nil                 ;; complete on anything
 bbdb-complete-name-allow-cycling t       ;; cycle through matches
 bbbd-message-caching-enabled t           ;; be fast
 bbdb-use-alternate-names t               ;; use AKA
 bbdb-elided-display t                    ;; single-line addresses

 bbdb/news-auto-create-p nil            ;; auto create entries in bbdb

 bbdb-new-nets-always-primary 42

 bbdb-display-layout-alist 
 '((one-line
    (order phones mail-alias net notes)
    (name-end . 24)
    (toggle . t))
    (omit creation-date timestamp AKA)
   (multi-line
    (order phones mail-alias net notes)
    (omit creation-date timestamp AKA)
    (toggle . t))
   (pop-up-multi-line
    (omit creation-date timestamp AKA))
   (full-multi-line)
    (omit creation-date timestamp AKA))
)
(global-set-key "\C-cb" 'bbdb)


;; From notmuch mailing list
(require 'org-gnus)
(defun th-notmuch-file-to-group (file)
 "Calculate the Gnus group name from the given file name.

Example:

 IN: /home/horn/Mail/Dovecot/uni/INBOX/dbox-Mails/u.4075
 OUT: nnimap+Uni:INBOX"
 (message file)
 (concat "nnimap+bnl:"
	 (replace-regexp-in-string
	  "/.*" ""
	  (replace-regexp-in-string
	   "/home/bviren/Maildir/\." "" file))))

(defun th-notmuch-goto-message-in-gnus ()
 "Open a summary buffer containing the current notmuch
article."
 (interactive)
 (let ((group (th-notmuch-file-to-group (notmuch-show-get-filename)))
       (message-id (replace-regexp-in-string
		    "\"" ""
		    (replace-regexp-in-string
                    "^id:" "" (notmuch-show-get-message-id)))))
   (message "G: %s, mid: %s" group message-id)
   (if (and group message-id)
       (org-gnus-follow-link group message-id)
     (message "Couldn't get relevant infos for switching to Gnus."))))

(define-key notmuch-show-mode-map (kbd "C-c C-c") 'th-notmuch-goto-message-in-gnus)
