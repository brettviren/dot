(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(require 'el-get)
(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get/el-get/recipes")
(setq el-get-sources 
      '(
;	auto-complete 
;	xcscope 
	yasnippet 
	anything
	python-mode
	pylookup
	ipython
	))
(if (or (string= (getenv "HOST") "hal") (string= (getenv "HOST") "lycastus"))
    (setq el-get-sources (append el-get-sources '(
						  offlineimap 
						  mailq
						  bbdb
						  ))))

(el-get)

(require 'anything-match-plugin)
(require 'anything-config)

(provide 'bv-packages)

