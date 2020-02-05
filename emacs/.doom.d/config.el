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

(map! :map magit-mode-map "M-n" nil)
(map! (:map override
        "M-t" #'evil-window-right
        "M-n" #'evil-window-left
        "M-g" #'evil-window-up
        "M-r" #'evil-window-down))

(setq scroll-step 5)
(evil-define-motion scroll-n-lines-up (count)
  "Scroll `scroll-step' up"
  (evil-scroll-line-up scroll-step))
(evil-define-motion scroll-n-lines-down (count)
  "Scroll `scroll-step' down"
  (evil-scroll-line-down scroll-step))
(map!
        "<M-up>" #'scroll-n-lines-up
        "<M-down>" #'scroll-n-lines-down)

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

(setq display-line-numbers-type 'relative)

(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-scroll-amount
      '(1 ((shift) . 1) ((control) . nil)))


(setq! flycheck-check-syntax-automatically '(mode-enabled save))

;; Python
;; Make python cell mode default
(add-hook! 'python-mode-hook #'python-cell-mode)

(defun python-cell-range-function ()
  "Function to call to return highlight range.
Highlight only the cell title. Return nil if the title
is off screen."
  (save-match-data
    (save-excursion
      (progn (end-of-line)
             (if (re-search-backward python-cell-cellbreak-regexp nil t)
                 (let ((start (goto-char (match-beginning 0)))
                       (end (goto-char (match-end 0))))
                   `(,start . ,end))
               nil))))
  )


;; Make default shell ipython
(setq! python-shell-interpreter "ipython"
       python-shell-interpreter-args "console --simple-prompt"
       python-shell-prompt-detect-failure-warning nil)

;; Function to find existing kernel by its filename
(defun jupyter-connect-name (filename)
  "Connect to a jupyter kernel by its `filename'."
  (interactive (list (read-string "Connection file name: ")))
  ;; client (jupyter-connect-repl (concat "~/.local/share/jupyter/runtime/" filename) filename))
  (setq client (jupyter-connect-repl (concat "~/.local/share/jupyter/runtime/" filename) filename))
  (jupyter-repl-associate-buffer client))

;; maybe must connect it to buffer too
;; set a buffer name for jupyter repl / client ?


;; Send cell to jupyter
(defun jupyter-eval-cell ()
  "Eval current IPython cell."
  (interactive)
  (let (
        (start (save-excursion (python-beginning-of-cell)
                               (point)))
        (end (save-excursion (python-end-of-cell)
                             (point))))
  (jupyter-eval-region start end)))

;; Keybinds for jupyter-emacs
(map! :map jupyter-repl-interaction-mode-map "M-i" nil)
(map! :leader
      (:prefix-map ("r" . "run")
        :desc "Connect to kernel" "k" #'jupyter-connect-name
        :desc "Send line ro region" "l" #'jupyter-eval-line-or-region
        :desc "Send string" "s" #'jupyter-eval-string-command
        :desc "Send cell" "c" #'jupyter-eval-cell
        ))
