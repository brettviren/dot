;; GNUS

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
(setq mm-decrypt-option 'always)
(setq mm-verify-option 'always)
(setq gnus-buttonized-mime-types '("multipart/encrypted" "multipart/signed"))
(setq smime-keys (quote (("bv@bnl.gov" "/home/bviren/dot/certs/mine/cert-and-key.pem" nil))))
(setq smime-CA-directory "/home/bviren/dot/certs/root")
(setq smime-certificate-directory "/home/bviren/dot/certs/others")
(setq password-cache t)
(setq password-cache-expiry 86400)
(add-hook 'message-send-hook 'mml-secure-message-sign-smime)

;; pgp signed mail
; http://www.emacswiki.org/emacs/GnusPGG
(require 'pgg)
;; verify/decrypt only if mml knows about the protocl used
(setq mm-verify-option 'known)
(setq mm-decrypt-option 'known)
;; Here we make button for the multipart 
(setq gnus-buttonized-mime-types '("multipart/encrypted" "multipart/signed"))
;; Automatically sign when sending mails
;(add-hook 'message-send-hook 'mml-secure-message-sign-pgpmime)
;; Enough explicit settings
;(setq pgg-passphrase-cache-expiry 300)
;(setq pgg-default-user-id jmh::primary-key)

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
	 (display . all)
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
;(setq gnus-agent-synchronize-flags nil)
(setq gnus-agent nil)

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
;; see dot/emacs/elisp/all/email.el
		(nnimap-stream shell)
		)

	;; (nnimap "gmail"
	;; 	(nnimap-address "imap.gmail.com")
	;; 	(nnimap-server-port 993)
	;; 	(remove-prefix "INBOX.")
	;; 	(nnimap-stream ssl))

	(nnfolder "old-outgoing"
		  (nnfolder-directory "/home/bviren/Mail.pre-imap/archive")
		  (nnfolder-active-file "/home/bviren/Mail.pre-imap/archive/active")
		  (nnfolder-get-new-mail nil)
		  )
	)
      nnimap-split-inbox '("INBOX"))

(setq nnimap-split-crosspost nil)	;don't cross post splits
(setq nnimap-split-rule
      '(
	("duplicates" "^Gnus-Warning:.*duplicate")

	("dusel.lbnd" "^\\(To:\\|Cc:\\|From:\\).*lbne_ndwg@fnal.gov")
	("dusel.lbdusel" "^\\(To:\\|Cc:\\|From:\\).*lbdusel@solid.physics.ucdavis.edu")
	("dusel.wc" "^\\(To:\\|Cc:\\|From:\\).*hmstk-lb-s4-water@lists.bnl.gov")
	("dusel.software" "^\\(To:\\|Cc:\\|From:\\).*hmstk-lb-software@lists.bnl.gov")
	("dusel.collab" "^\\(To:\\|Cc:\\|From:\\).*hmstk-lb-collab@lists.bnl.gov")
	("dusel.wc.sim" "^\\(To:\\|Cc:\\|From:\\).*hmstk-wc-simulation@lists.bnl.gov")
	("dusel.wc.det" "^\\(To:\\|Cc:\\|From:\\).*hmstk.*water@lists.bnl.gov")
	("dusel.wc.pmt" "^\\(To:\\|Cc:\\|From:\\).*hmstk-lb-pmt@lists.bnl.gov")
	("dusel.wc.mgt" "^\\(To:\\|Cc:\\|From:\\).*hmstk-wcd-mgt@lists.bnl.gov")
	("dusel.docdb" "^\\(To:\\|Cc:\\|From:\\).*DUSEL/LBNE R&D Document Database")

	("minos.software.offline"
	 "^\\(To:\\|Cc:\\).*minos_software_discussion@.*fnal.gov.*")
	("minos.shift" "^From:.*minos@minos-beamdata.fnal.gov")
	("minos.cc" "^\\(To:\\|Cc:\\).*minos_cc.*@.*fnal.gov.*")
	("minos.nc" "^\\(To:\\|Cc:\\).*minos_nc.*@.*fnal.gov.*")
	("minos.nue" "^\\(To:\\|Cc:\\).*minos_nue@.*fnal.gov.*")
	("minos.sim" "^\\(To:\\|Cc:\\).*minos_sim@.*fnal.gov.*")
	("minos.batch" "^\\(To:\\|Cc:\\).*minos_batch@.*fnal.gov.*")
	("minos.all" "^\\(To:\\|Cc:\\).*minos_all@.*fnal.gov.*")
	("minos.all" "^\\(To:\\|Cc:\\).*minos_authors@.*fnal.gov.*")
	("minos.near" "^\\(To:\\|Cc:\\).*minos_near@.*fnal.gov.*")
	("minos.numi-notes" "^\\(To:\\|Cc:\\).*numi-notes@.*fnal.gov.*")
	("minos.crl" "^From:.*MINOS_Logbook@fnal.gov")
	("minos.users" "^\\(To:\\|Cc:\\|From:\\).*minos-users@fnal.gov")
	("minos.beam" "^\\(To:\\|Cc:\\|From:\\).*numi_beam@fnal.gov")
	("dayabay.cvs" "^From:.*cvspub@daya.*.ihep.ac.cn")
	("dayabay.cvs" "^From:.*dayabay_cvs@dayabay.krl.caltech.edu")
	;("dayabay.svn" "^From:.*@svnserver")
	;("dayabay.svn" "^Subject:  r[0-9]+\&^From:.*@dayabay.ihep.ac.cn")
	("dayabay.svn" "^Subject:  r[0-9]+ - ")
	("dayabay.svn" "^Subject: r[0-9]+ - ")
	("dayabay.svn" "^Subject: \\[theta13-svn\\] r[0-9]+ - ")
	("dayabay.svn" "^To:.*theta13-svn")
	("dayabay.trac" "^From:.*trac@dayabay.ihep.ac.cn")
	("dayabay.docdb" "^From:.*Daya Bay Document Database")
	("dayabay.docdb" "^From:.*apache@dayabay.ihep.ac.cn")
	("dayabay.nightly" "^Subject:.*Daya Bay Offline Nightly Build")
	("dayabay.bitten" "^Subject:.*slave-loop")
	("dayabay.bitten" "^Subject:.*slave i686-debian")

	("dayabay.twiki" "^From: TWiki Administrator")

	("dayabay.muon" "^\\(To:\\|Cc:\\|From:\\).*theta13-muon@.*lbl.gov")
	("dayabay.slowcontrols" "^\\(To:\\|Cc:\\|From:\\).*theta13-slowcontrols@.*lbl.gov")
	("dayabay.antineutrino" "^\\(To:\\|Cc:\\|From:\\).*theta13-antineutrino@.*lbl.gov")
	("dayabay.simulation" "^\\(To:\\|Cc:\\|From:\\).*theta13-simulation@.*lbl.gov")
	("dayabay.offline" "^\\(To:\\|Cc:\\|From:\\).*theta13-offline@lbl.gov")
	("dayabay.offline" "^\\(To:\\|Cc:\\|From:\\).*theta13-offline@lists.lbl.gov")
	("dayabay.offline" "^Subject: \\[theta13-offline\\]")
	("dayabay.production" "^\\(To:\\|Cc:\\|From:\\).*theta13-production@lbl.gov")
	("dayabay.general" "^\\(To:\\|Cc:\\|From:\\).*theta13-general@.*lbl.gov")
	("dayabay.us" "^\\(To:\\|Cc:\\|From:\\).*theta13-us@.*lbl.gov")
	("dayabay.calib" "^\\(To:\\|Cc:\\|From:\\).*theta13-calibration@.*lbl.gov")
	;("dayabay." "^\\(To:\\|Cc:\\|From:\\).*theta13-@.*lbl.gov")
	("dayabay.papers" "^\\(To:\\|Cc:\\|From:\\).*theta13-papers@.*lbl.gov")
	("dayabay.physics" "^\\(To:\\|Cc:\\|From:\\).*theta13-physics@.*lbl.gov")
	("dayabay.talks" "^\\(To:\\|Cc:\\|From:\\).*theta13-talks@.*lbl.gov")
	("dayabay.commissioning" "^\\(To:\\|Cc:\\|From:\\).*theta13-commissioning@.*lbl.gov")
	("dayabay.eng" "^\\(To:\\|Cc:\\|From:\\).*theta13-eng@.*lbl.gov")
	("lists.pdsf-users" "^\\(To:\\|Cc:\\|From:\\).*users@nersc.gov")

	("p.yoko" "^From:.*\\(yoko\\|yoky\\|tango\\)@.*\\(homeip.net\||optonline.net\\).*")

	("svn.vgm" "^Subject: SF.net SVN: vgm")
	("cvs.minos" "^From:.*minoscvs")
	("cvs.uno" "^From:.*pdk@nngroup.physics.sunysb.edu")
	("ordo" "^From:.*\\(ordo@\\|@ordo.bnl.gov\\)")

	("snews" "^\\(To:\\|Cc:\\|From:\\).*snews.*@lists.bnl.gov")
	("snews" "^\\(To:\\|Cc:\\|From:\\).*snews-wg@lists.bnl.gov")
	("snews" "^\\(To:\\|Cc:\\|From:\\).*snnet@lists.bnl.gov")
	("cvs.snews" "^From:.*snrep@gateway.phy.bnl.gov")
	("lists.owner" "^From:\\(.*-owner\\|.*-bounces\\)@.*")
	("lists.schooltool" "^\\(To:\\|Cc:\\|From:\\).*schooltool.*@schooltool.org")
	("lists.rhml" "^\\(To:\\|Cc:\\).*mirror-list.*@redhat.com.*")
	("lists.ivtv.devel" "^\\(To:\\|Cc:\\).*ivtv-devel.*@ivtvdriver.org.*")
	("lists.ivtv.users" "^\\(To:\\|Cc:\\).*ivtv-users.*@ivtvdriver.org.*")
	("lists.rhbugs" "^From:.*bugzilla@redhat.com.*")

	("lists.fnal.linux" "^\\(To:\\|Cc:\\).*linux.*@.*fnal.gov.*")
	("lists.fnal.hepix" "^\\(To:\\|Cc:\\).*hepix-hepnt@.*fnal.gov.*")
	("lists.fnal.hepix" "^\\(To:\\|Cc:\\).*hepix@hepix.org.*")
	("lists.fnal.users" "^\\(To:\\|Cc:\\).*usersorg@.*fnal.gov.*")
	("lists.fnal.docdb" "^From:.*minos-docdb@fnal.gov")

	("lists.root" "^\\(To:\\|Cc:\\).*root.cern.ch.*")
	("lists.root" "^\\(To:\\|Cc:\\).*roottalk*")
	("lists.cmt" "^\\(To:\\|Cc:\\|From:\\).* CMT-L@in2p3.fr")
	("lists.blitz" "^Subject:.*Blitz-support.*")
	("lists.debian.amd64" "^\\(To:\\|Cc:\\).*debian-x86-64.*")
	("lists.debian.amd64" "^\\(To:\\|Cc:\\).*debian-amd64.*")
	("lists.debian.news" "^\\(To:\\|Cc:\\).*debian-news@lists.debian.org.*")
	("lists.debian.science" "^\\(To:\\|Cc:\\).*debian-science@lists.debian.org.*")
	("lists.debian.beowulf" "^\\(To:\\|Cc:\\).*debian-beowulf@lists.debian.org.*")
	("lists.guile" "^\\(To:\\|Cc:\\).*guile-user@gnu.org.*")
	("lists.pygtk" "^\\(To:\\|Cc:\\).*pygtk@daa.com.au.*")
	("lists.sigc" "^\\(To:\\|Cc:\\).*libsigc-list@gnome.org.*")

	;;; BNL mailing lists
	;; Do NOT autogenerate a group based on a list name!
	;("lists.bnl.\\2" "^\\(To:\\|From:\\|Cc:\\).*<\\(.*\\)-l@lists.bnl.gov")
	("lists.bnl.gaudi-talk" "^\\(To:\\|From:\\|Cc:\\).*gaudi-talk@lists.bnl.gov")
	("lists.open-scientist" "^\\(To:\\|From:\\|Cc:\\).*OPEN-SCIENTIST@in2p3.fr")

	("lists.bnl.scanning" "^\\(To:\\|From:\\|Cc:\\).*scanning-l@lists.bnl.gov")
	("lists.bnl.llug" "^\\(To:\\|From:\\|Cc:\\).* bnl-llug@.*bnl.gov")
	("lists.bnl.computer-liaisons" "^\\(From:\\|To:\\|Cc:\\).*computer-liaisons@phyppro1.phy.bnl.gov")
	("lists.bnl.nwg" "^\\(From:\\|To:\\|Cc:\\).*nwg@nwg.phy.bnl.gov")
	("lists.bnl.nessus"    "^From:.*noreply@secops.itd.bnl.gov")
	("lists.bnl.csac" "^\\(\\From:\\|To:\\|Cc:\\).*csac-l@.*bnl.gov")
	;("lists.bnl.cspwg" "^(\\From:\\|To:\\|Cc:\\).*<cspwg-l@lists.bnl.gov.*")
	("lists.bnl.cspwg" "^\\(To:\\|From:\\|Cc:\\).*[< ]cspwg-l@lists.bnl.gov")
	("lists.bnl.linux" "^\\(To:\\|From:\\|Cc:\\).*[< ].*linux.*@lists.bnl.gov")

	("lists.bnl.broadcast" "^To:.*broadcast-l@lists.bnl.gov")
	("lists.bnl.seminars" "^\\(From:\\|To:\\|Cc:\\).*physics-seminars-l@lists.bnl.gov")
	("lists.bnl.physics" "^\\(From:\\|To:\\|Cc:\\).*[Pp]hysics[Pp]ersonnel@bnl.gov")
	("lists.bnl.peoplesoft" "^\\(From:\\|To:\\|Cc:\\).*[Pp]soft[Hh]8[Pp][Dd]@bnl.gov")

	("lists.bnl.csmis" "^From:.*csmisdbm@bnl.gov")
	("lists.bnl.edg" "^\\(From:\\|To:\\|Cc:\\).*[Ee]dg-employees-l@lists.bnl.gov")
	("lists.bnl.dayabay" "^\\(From:\\|To:\\|Cc:\\).*dayabay-bnl-l@lists.bnl.gov")
	("lists.bnl.minos" "^\\(From:\\|To:\\|Cc:\\).*bnl-minos@minos.phy.bnl.gov")
	("lists.bnl.e949" "^\\(From:\\|To:\\|Cc:\\).*e949.general@bnlku28.phy.bnl.gov")
	("lists.bnl.physics" "^\\(From:\\|To:\\|Cc:\\).*allphysics@.*bnl.gov")
	("lists.bnl.ags" "^\\(From:\\|To:\\|Cc:\\).*ags.*@.*bnl.gov")
	("lists.bnl.apd" "^\\(From:\\|To:\\|Cc:\\).*apd@.*bnl.gov")
	("lists.bnl.notify" "^\\(From:\\|To:\\|Cc:\\).*[Nn]otify-l.*@.*bnl.gov")
	("lists.bnl.notify" "^\\(From:\\|To:\\|Cc:\\).*announce@rcf.rhic.bnl.gov")
	("lists.bnl.notify" "^\\(From:\\|To:\\|Cc:\\).*bnl-rhel-l.*@.*bnl.gov")
	("lists.bnl.notify" "^\\(From:\\|To:\\|Cc:\\).*all-listadmins-l@.*bnl.gov")

	("lists.bnl.itd-wg" "^\\(From:\\|To:\\|Cc:\\).*wirelesswg-l.*@.*bnl.gov")

	("lists.bnl.users" "^To:.*users-l@lists.bnl.gov")
	("lists.bnl.users" "^To:.*[uU]serscenter_rhic_news_distribution-l@lists.bnl.gov")
	("lists.bnl.social" "^\\(From:\\|To:\\|Cc:\\).*social-l@lists.bnl.gov")
	("lists.bnl.social" "^\\(From:\\|To:\\|Cc:\\).*asap-l@lists.bnl.gov")
	("lists.bnl.social" "^\\(From:\\|To:\\|Cc:\\).*bnl-scc-l@lists.bnl.gov")


	("lists.bnl.cyberinfo" "^\\(From:\\|To:\\|Cc:\\).*CyberSecurityPOCsa@bnl.gov")
	("lists.bnl.cyberinfo" "^From:.*cyberinfo@bnl.gov")
	("lists.bnl.sysadmin" "^\\(From:\\|To:\\|Cc:\\).*[Ss]ys[Aa]dmin.*@lists.bnl.gov")

;sysadmin-l@lists.bnl.gov

	("lists.batch" "^Subject:.*\\(torque\\|maui\\|moab\\)users")
	("lists.xxx" "^From:.*no-reply@arXiv.org")
	("lists.twisted" "^\\(To:\\|Cc:\\|From:\\).*twisted-python@twistedmatrix.com")
	("lists.twisted.web" "^\\(To:\\|Cc:\\|From:\\).*twisted-web@twistedmatrix.com")
	("lists.skribe" "^\\(To:\\|Cc:\\|From:\\).*skribe@sophia.inria.fr")
	("lists.puppet" "^\\(To:\\|Cc:\\|From:\\).*puppet-users@madstop.com")
	("lists.puppet" "^\\(To:\\|Cc:\\|From:\\).*puppet-users@googlegroups.com")

	("root.minos" "^From:.*\\(root\\|daemon\\|logcheck\\)@minos.phy.bnl.gov")
	("root.updates" "^Subject: Debian package updates")
	("root.bnlboom" "^From:.*root@bnlboom.*.phy.bnl.gov")
	("root.thassos" "^From:.*root@thassos.phy.bnl.gov")
	("root.nuhep" "^From:.*root@\\(phyppro\\|physgi\\).*")
	("root.nuhep" "^To:.*postmaster@physgi04.phy.bnl.gov.*")
	("root.monitor" "^From:.*monitor@.*bnl.gov")
	("root.monitor" "^From:.*nagios@.*bnl.gov")
	("auto.backup" "^From:.*legatounixmst.itd.bnl.gov.*")
	("auto.cfengine" "^From:.*cfengine@.*bnl.gov")
	("auto.backup" "^Subject:.*BACKUP STATUS.*")
	("auto.logwatch" "^Subject:.*LogWatch.*")
	("auto.cron" "^From: [Cc]ron .*")
	("auto.cron" "^From: .*[Cc]ron Daemon.*")
	("auto.batch" "^Subject: PBS JOB .*")
	("crap" "^\\(From:\\|To:\\|Cc:\\).*ultimate-dance-li@yahoogroups.com")
	("crap" "^\\(From:\\|To:\\|Cc:\\).*dancemgc@optonline.net")
	("root.nessus" "^Subject: Nessus Scan of ")
	;; One doesn't need this but it is a way to get things out of
	;; the INBOX so /var/mail doesn't fill up.
	("default" "^To:.*\\(bv\\|bviren\\)@bnl.gov")
	("default" "")
))


