;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here



(map! :leader
      "%" #'comment-line)

;; (map! :leader
;;       (:prefix-map ("r" . "run")
;;         :desc "run line" "l" #'elpy-shell-send-statement
;;         :desc "run buffer" "b" #'elpy-shell-send-buffer
;;         :desc "run codecell" "c" #'elpy-shell-send-codecell
;;         :desc "run def" "d" #'elpy-shell-send-defun
;;         :desc "run line & step" "L" #'elpy-shell-send-statement-and-step
;;         :desc "run buffer & step" "B" #'elpy-shell-send-buffer-and-step
;;         :desc "run codecell & step" "C" #'elpy-shell-send-codecell-and-step
;;         :desc "run def & step" "D" #'elpy-shell-send-defun-and-step))

(map! (:map override
        "M-t" #'evil-window-right
        "M-n" #'evil-window-left
        "M-g" #'evil-window-up
        "M-r" #'evil-window-down))

(setq scroll-step 5)
(map! (:map override
        "<M-up>" (lambda () (interactive) (evil-scroll-line-up scroll-step))
        "<M-down>" (lambda () (interactive) (evil-scroll-line-down scroll-step))))

(map! :n "M-l" ":m-2")
(map! :n "M-a" ":m+")

(require 'doom-themes)
(load-theme 'doom-one-light)

(doom-themes-org-config)


;; PROJECTILE folders
(setq projectile-project-search-path
      '("~/Documents/"
        "~/Documents/Work/"
        "~/Documents/Programmes/Libraries/Python/"
        "~/Documents/Programmes/Libraries/Latex/"
        "~/Documents/Programmes/Applications/"))


(use-package! projectile
  :init
  (setq projectile-indexing-method 'hybrid))

(org-projectile-per-project)
(setq org-projectile-per-project-filepath "TODO.org")
(setq org-agenda-files (append org-agenda-files (org-projectile-todo-files)))
(setq org-projectile-projects-file
      "~/org/")

(setq! avy-keys '(?n ?r ?t ?d ?e ?a ?i ?u))


(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-scroll-amount
      '(1 ((shift) . 1) ((control) . nil)))


(setq! flycheck-check-syntax-automatically '(mode-enabled save))

;; Python
(add-hook! 'python-mode-hook #'python-cell-mode)
(setq! python-shell-interpreter "ipython"
       python-shell-interpreter-args "console --simple-prompt"
       python-shell-prompt-detect-failure-warning nil)

