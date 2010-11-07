;;

(add-to-list 'load-path "~/.emacs.d/el-get/yasnippet")
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/el-get/yasnippet/snippets")

;(require 'xcscope)
;(require 'pymacs)
;(pymacs-load "ropemacs" "rope-")
