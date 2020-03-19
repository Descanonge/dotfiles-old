;;; .doom.d/config.el -*- lexical-binding: t; -*-


;; PROJECTILE folders
(setq projectile-project-search-path
      '("~/Documents/"
        "~/Documents/Work/"
        "~/Documents/Programmes/Libraries/Python/"
        "~/Documents/Programmes/Libraries/Latex/"
        "~/Documents/Programmes/Applications/"))


;; Comment kb
(map! :leader
      "%" #'comment-line)

;; Change window kb
(map! :map magit-mode-map "M-n" nil)
(map! (:map override
        "M-t" #'evil-window-right
        "M-n" #'evil-window-left
        "M-g" #'evil-window-up
        "M-r" #'evil-window-down))
(map! :leader
        :desc "Diff" "gd" #'magit-diff)

;; Org move item kb
(map! (:map evil-org-mode-map
        :niv "M-l" #'org-metaup
        :niv "M-a" #'org-metadown
        :niv "M-i" #'org-metaleft
        :niv "M-e" #'org-metaright))

(map! (:map evil-window-map
        "N" #'+evil/window-move-left
        "T" #'+evil/window-move-right
        "G" #'+evil/window-move-up
        "R" #'+evil/window-move-down))

;; Insert a single character
(evil-define-command evil-insert-char (count char)
  "Insert COUNT times character CHAR."
  (interactive "<c><C>")
  (setq count (or count 1))
  (insert (make-string count char)))

(evil-define-command evil-append-char (count char)
  "Append COUNT times character CHAR."
  (interactive "<c><C>")
  (setq count (or count 1))
  (when (not (eolp))
    (forward-char))
  (insert (make-string count char))
  (backward-char))

(map! :n "l" #'evil-insert-char
      :n "L" #'evil-append-char)

;; Move line kb
(map! :n "M-l" ":m-2")
(map! :n "M-a" ":m+")

;; Centered mode kb
(map! :map doom-leader-toggle-map
      :desc "Centered window" "c" #'centered-window-mode-toggle)
;; Visual line mode kb
(map! :map doom-leader-toggle-map
      :desc "Visual line mode" "v" #'visual-line-mode)

;; Scrolling
(setq scroll-step 5)
(evil-define-motion scroll-n-lines-up (count)
  "Scroll `scroll-step' up"
  (evil-scroll-line-up scroll-step))
(evil-define-motion scroll-n-lines-down (count)
  "Scroll `scroll-step' down"
  (evil-scroll-line-down scroll-step))
(map! (:map override
        "<M-up>" #'scroll-n-lines-up
        "<M-down>" #'scroll-n-lines-down))

;; Scroll in magit buffers
(map! (:map magit-mode-map
        :prefix "z"
        :nv "t" #'evil-scroll-line-to-top))

;; Set theme
(require 'doom-themes)
(load-theme 'doom-one-light)

(doom-themes-org-config)

;; Remove buffer size indication
(after! doom-modeline
  (setq size-indication-mode nil)
  (setq doom-modeline-buffer-encoding nil))

;; Set first frame to maximised
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; Set projectile search method
(after! projectile
  (setq projectile-indexing-method 'hybrid))

;; Set org notes folders
(org-projectile-per-project)
(setq org-projectile-per-project-filepath "TODO.org")
(setq org-agenda-files (append org-agenda-files (org-projectile-todo-files)))
(setq org-projectile-projects-file
      "~/org/")

;; Set Avy keys
(setq! avy-keys '(?n ?r ?t ?d ?e ?a ?i ?u))

;; Set line numbers default
(setq display-line-numbers-type 'relative)


;; Set flycheck to check at save
(setq! flycheck-check-syntax-automatically '(mode-enabled save))

;; Python
;; Make python cell mode default
(require 'python-cell)
(add-hook! 'python-mode-hook #'python-cell-mode)

;; Set cell mode highlight
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
  "Connect to a jupyter kernel by its FILENAME."
  (interactive (list (ivy-read "Connection file name: "
                               (mapcar #'car
                                       (reverse (cl-sort
        (seq-subseq (directory-files-and-attributes "~/.local/share/jupyter/runtime/") 2)
        #'time-less-p :key #'(lambda (x) (nth 6 x))))))))
  (setq client (jupyter-connect-repl (concat "~/.local/share/jupyter/runtime/" filename) filename))
  (jupyter-repl-associate-buffer client))

;; Send cell to jupyter
(defun jupyter-eval-cell ()
  "Eval current IPython cell."
  (interactive)
  (let (
        (start (save-excursion (python-cell-beginning-of-cell)
                               (point)))
        (end (save-excursion (python-cell-end-of-cell)
                             (point))))
  (jupyter-eval-region start end)))

;; Jupyter kb
;; TODO: only in python-mode
(map! :map jupyter-repl-interaction-mode-map "M-i" nil)
(map! :leader
      (:prefix-map ("r" . "run")
        :desc "Connect to kernel" "k" #'jupyter-connect-name
        :desc "Send line or region" "l" #'jupyter-eval-line-or-region
        :desc "Send string" "s" #'jupyter-eval-string-command
        :desc "Send cell" "c" #'jupyter-eval-cell
        :desc "Send buffer" "b" #'jupyter-eval-buffer
        :desc "Interrupt kernel" "i" #'jupyter-interrupt-kernel
        ))

;; Multi cursor kb
(map! (:when (featurep! :editor multiple-cursors)
        :prefix "gz"
        :nv "j" nil
        :desc "Make, move next line" :nv "<down>" #'evil-mc-make-cursor-move-next-line
        :nv "k" nil
        :desc "Make, move prev line" :nv "<up>" #'evil-mc-make-cursor-move-prev-line
        ))
