;; flyspell
(require 'flyspell)
(defun turn-on-flyspell-mode () (flyspell-mode 1))
(defun turn-off-flyspell-mode () (flyspell-mode 0))
(add-hook 'text-mode-hook 'turn-on-flyspell-mode)
(add-hook 'message-mode-hook 'turn-on-flyspell-mode)
(add-hook 'fundamenal-mode-hook 'turn-on-flyspell-mode t)

(which-func-mode 1)
