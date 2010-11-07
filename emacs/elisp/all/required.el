;;

(add-to-list 'load-path "~/.emacs.d/el-get/yasnippet")
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/el-get/yasnippet/snippets")
(yas/load-directory "~/dot/emacs/elisp/yasnippets")

(setq auto-mode-alist (append 
		       (mapcar 'purecopy
			       '(
				 ("/yasnippets/" . snippet-mode)
				 ("/snippets/" . snippet-mode)
				 ))))

;(require 'xcscope)
;(require 'pymacs)
;(pymacs-load "ropemacs" "rope-")
