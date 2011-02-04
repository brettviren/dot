;; -*- emacs-lisp -*-

(add-to-list 'load-path "~/dot/emacs/elisp/all")
(require 'bv-packages)
(load "required.el")
(load "desired.el")
(load "bindings.el")
(load "setqs.el")
(load "functions.el")
(load "cpp.el")
;; only read email on a couple of hosts
(if (and (or (string= (getenv "HOST") "hal") (string= (getenv "HOST") "lycastus"))
	 (string= (getenv "USER") "bviren"))
    (load "email.el")
  )
(load "mode-hooks.el")





