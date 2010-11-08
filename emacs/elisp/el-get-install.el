;; To install el-get and el-gotten packages the first time, do:
;;
;; emacs -q dot/emacs/elisp/el-get-install
;;
;; M-x eval-curent buffer
;;
;; The -q is to avoid loading configuration that requires el-get.
;;
;; If you see errors about "-v" not supported, it means your git is
;; too old.
;;
;; Then, exit emacs and restart it w/out -q to install required
;; packages.

(let* ((el-get-dir        (expand-file-name "~/.emacs.d/el-get/"))
       (dummy             (unless (file-directory-p el-get-dir)
                            (make-directory el-get-dir t)))
       (package           "el-get")
       (bname             "*el-get bootstrap*") ; both process and buffer name
       (pdir              (concat (file-name-as-directory el-get-dir) package))
       (git               (or (executable-find "git") (error "Unable to find `git'")))
       (url               "git://github.com/dimitri/el-get.git")
       (el-get-sources    `((:name ,package :type "git" :url ,url :features el-get :compile "el-get.el")))
       (default-directory el-get-dir)
       (process-connection-type nil) ; pipe, no pty (--no-progress)
       (clone             (start-process bname bname git "--no-pager" "clone" "-v" url package)))
  (set-window-buffer (selected-window) (process-buffer clone))
  (set-process-sentinel
   clone
   `(lambda (proc change)
      (when (eq (process-status proc) 'exit)
        (setq default-directory (file-name-as-directory ,pdir))
        (setq el-get-sources ',el-get-sources)
        (load (concat (file-name-as-directory ,pdir) ,package ".el"))
        (el-get-init "el-get")
        (with-current-buffer (process-buffer proc)
          (goto-char (point-max))
          (insert "\nCongrats, el-get is installed and ready to serve!"))))))

