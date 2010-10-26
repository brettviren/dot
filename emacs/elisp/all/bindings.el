;;;; ispell
(require 'ispell)
(global-set-key "\C-cw" 'ispell-word)
(global-set-key "\C-cb" 'ispell-buffer)

;;;; Bind some keys
(global-set-key "\C-H" 'delete-backward-char)
(global-set-key "\M-\C-H" 'backward-kill-word)
(global-set-key "\M-g" 'goto-line)
(global-set-key "\C-cl" 'eval-current-buffer)

;;; move around multiple windows
(global-set-key (kbd "S-<right>") 'windmove-right)
(global-set-key (kbd "S-<left>") 'windmove-left)
(global-set-key (kbd "S-<up>") 'windmove-up)
(global-set-key (kbd "S-<down>") 'windmove-down)
