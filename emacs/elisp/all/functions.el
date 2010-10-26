(defun insert-time () "Insert current time"
  (interactive)
  (insert (current-time-string)))
(global-set-key "\C-cd" 'insert-time)

(defun insert-buffer-name () "Insert current buffer name"
  (interactive)
  (insert (buffer-name)))
(global-set-key "\C-cn" 'insert-buffer-name)
