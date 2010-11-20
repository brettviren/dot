;; set up email

(setq gnus-init-file "~/dot/emacs/elisp/dot.gnus.el")
(setq gnus-inhibit-startup-message t)


;; sieve
;; http://josefsson.org/sieve/gnus-sieve.html
;; (autoload 'sieve-mode "sieve-mode")
;; (setq auto-mode-alist (cons '("\\.si\\(v\\|eve\\)\\'" . sieve-mode)
;;                             auto-mode-alist))
;; (require 'gnus-sieve)
;;(gnus-sieve-setup) undefined?


;;; not much
(add-to-list 'load-path "~/opt/notmuch/share/emacs/site-lisp")
(require 'notmuch)
(add-hook 'gnus-group-mode-hook
          (lambda ()
            (local-set-key "S" 'notmuch-search)))

;; crypto
;;;; mailcrypt, see info page
;; (load-library "mailcrypt") ; provides "mc-setversion"
;; (mc-setversion "gpg")    ; for PGP 2.6 (default); also "5.0" and "gpg"
;; (autoload 'mc-install-write-mode "mailcrypt" nil t)
;; (autoload 'mc-install-read-mode "mailcrypt" nil t)
;; (add-hook 'mail-mode-hook 'mc-install-write-mode)
;; (add-hook 'gnus-summary-mode-hook 'mc-install-read-mode)
;; (add-hook 'message-mode-hook 'mc-install-write-mode)
;; (add-hook 'news-reply-mode-hook 'mc-install-write-mode)
;; (setq mc-gpg-user-id "Brett Viren <bv@bnl.gov>")
;; (setq mc-gpg-keyserver "hkp://subkeys.pgp.net")

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

