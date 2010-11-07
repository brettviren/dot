;; Tell what file extentions should trigger c++-mode
(setq auto-mode-alist (append 
		       (mapcar 'purecopy
			       '(
				 ("\\.onx$" . xml-mode)
				 ("\\.xml$" . xml-mode)
				 ))
		       auto-mode-alist))
