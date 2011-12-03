;;
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; ;; YASnippet
;; (add-to-list 'load-path "~/.emacs.d/el-get/yasnippet")
;; (require 'yasnippet)
;; (yas/initialize)
;; (yas/load-directory "~/.emacs.d/el-get/yasnippet/snippets")
;; (yas/load-directory "~/git/dot/emacs/elisp/yasnippets")

;; (setq auto-mode-alist (append 
;; 		       (mapcar 'purecopy
;; 			       '(
;; 				 ("/yasnippets/" . snippet-mode)
;; 				 ("/snippets/" . snippet-mode)))
;; 				 auto-mode-alist))



;; auto-complete is fucking annoying
;; (require 'auto-complete)
;; (global-auto-complete-mode t)
;; (define-key ac-complete-mode-map "\C-n" 'ac-next)
;; (define-key ac-complete-mode-map "\C-p" 'ac-previous)
;; (setq ac-auto-start 3)

;(require 'xcscope)
;(require 'pymacs)
;(pymacs-load "ropemacs" "rope-")


(require 'anything-match-plugin)
(require 'anything-config)

