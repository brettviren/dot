(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(require 'el-get)
(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get/el-get/recipes")
(setq el-get-sources 
      '(
;	auto-complete 
;	xcscope 
	yasnippet 
	))
(if (or (string= (getenv "HOST") "hal") (string= (getenv "HOST") "lycastus"))
(setq auto-mode-alist (append 
		       (mapcar 'purecopy
			       '(
				 offlineimap 
				 mailq
				 bbdb
				 ))
		       el-get-sources))
(el-get)
(provide 'bv-packages)

