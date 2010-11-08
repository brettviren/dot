(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(require 'el-get)
(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get/el-get/recipes")
(setq el-get-sources '(auto-complete xcscope yasnippet))
(el-get)
(provide 'bv-packages)

