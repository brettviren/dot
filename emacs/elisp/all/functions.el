(defun insert-time () "Insert current time"
  (interactive)
  (insert (current-time-string)))
(global-set-key "\C-cd" 'insert-time)

(defun insert-buffer-name () "Insert current buffer name"
  (interactive)
  (insert (buffer-name)))
(global-set-key "\C-cn" 'insert-buffer-name)

;; (defun electric-pair ()
;;   "If at end of line, insert character pair without surrounding spaces.
;;    Otherwise, just insert the typed character."
;;   (interactive)
;;   (if (eolp) (let (parens-require-spaces) (insert-pair)) 
;;     (self-insert-command 1)))
;; (add-hook 'python-mode-hook
;;           (lambda ()
;;             (define-key python-mode-map "\"" 'electric-pair)
;;             (define-key python-mode-map "\'" 'electric-pair)
;;             (define-key python-mode-map "(" 'electric-pair)
;;             (define-key python-mode-map "[" 'electric-pair)
;;             (define-key python-mode-map "{" 'electric-pair)))
;; (add-hook 'c++-mode-hook
;;           (lambda ()
;;             (define-key c++-mode-map "\"" 'electric-pair)
;;             (define-key c++-mode-map "\'" 'electric-pair)
;;             (define-key c++-mode-map "<" 'electric-pair)
;;             (define-key c++-mode-map "(" 'electric-pair)
;;             (define-key c++-mode-map "[" 'electric-pair)
;;             (define-key c++-mode-map "{" 'electric-pair)))
;; (add-hook 'latex-mode-hook
;;           (lambda ()
;;             ;(define-key latex-mode-map "\"" 'electric-pair)
;;             (define-key latex-mode-map "\'" 'electric-pair)
;;             (define-key latex-mode-map "(" 'electric-pair)
;;             (define-key latex-mode-map "$" 'electric-pair)
;;             (define-key latex-mode-map "[" 'electric-pair)
;;             (define-key latex-mode-map "{" 'electric-pair)))
