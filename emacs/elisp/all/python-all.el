;; -*- emacs-lisp -*-

(add-to-list 'load-path "~/.emacs.d/el-get/python-mode")

;; http://www.emacswiki.org/emacs/ProgrammingWithPythonModeDotEl
(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(add-hook 'python-mode-hook
	  (lambda ()
	    (set (make-variable-buffer-local 'beginning-of-defun-function)
		 'py-beginning-of-def-or-class)
	    (setq outline-regexp "def\\|class ")))
(add-hook 'python-mode-hook
          '(lambda () (eldoc-mode 1)) t)

; ipython
; http://www.emacswiki.org/emacs/PythonProgrammingInEmacs#toc11
(require 'ipython)
;(setq py-python-command-args '( "--colors" "Linux"))
(setq py-python-command-args '("-pylab" "-colors" "LightBG"))

(require 'python-mode)

(require 'pymacs)
(pymacs-load "ropemacs" "rope-")

(provide 'python-programming)
