;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Set first frame to maximised
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; PROJECTILE folders
(setq projectile-project-search-path
      '("~/Documents/"
        "~/Documents/Work/"
        "~/Documents/Websites/"
        "~/Documents/Programmes/Libraries/Python/"
        "~/Documents/Programmes/Libraries/Latex/"
        "~/Documents/Programmes/Libraries/Web/"
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

;; Move line kb
(map! :n "M-l" ":m-2")
(map! :n "M-a" ":m+")

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
(evil-define-command evil-insert-char (&optional count char)
  "Insert COUNT times character CHAR."
  (interactive "pc")
  (insert (make-string count char)))

(evil-define-command evil-append-char (&optional count char)
  "Append COUNT times character CHAR."
  (interactive "pc")
  (when (not (eolp))
    (forward-char))
  (insert (make-string count char))
  (backward-char))

(map! :n "l" #'evil-insert-char
      :n "L" #'evil-append-char)

;; Add symbol motions
(map! (:map evil-motion-state-map
        "é" 'forward-symbol
        "É" 'sp-backward-symbol)
      (:map evil-inner-text-objects-map
        "é" 'evil-inner-symbol))
(after! 'multiple-cursors
  (nconc evil-mc-custom-known-commands
         '((forward-symbol . ((:default . evil-mc-execute-default-call-with-count)
                              (visual . evil-mc-execute-visual-call-with-count)))
           (sp-backward-symbol . ((:default . evil-mc-execute-default-call-with-count)
                                  (visual . evil-mc-execute-visual-call-with-count))))))

;; Moving by paragraphs does not add to the jump list
(evil-define-motion evil-forward-paragraph (count)
  "Move to the end of the COUNT-th next paragraph."
  :type exclusive
  (evil-signal-at-bob-or-eob count)
  (evil-forward-end 'evil-paragraph count)
  (unless (eobp) (forward-line)))


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
;; Set mypy config file
(setq! flycheck-python-mypy-ini "~/.config/mypy/config")
(setq-default flycheck-disabled-checkers '(python-mypy python-pycompile))

;; Python-cells
(use-package! python-cell
  :init
  ;; Make python cell mode default
  (add-hook! 'python-mode-hook #'python-cell-mode)

  :config

  (defun python-cell-previous-cell ()
    "Move to beginning of cell or previous cell")

  ;; Move cells
  (map! (:map python-cell-mode-map
          :nv "]g" #'python-cell-forward-cell
          :nv "[g" #'python-cell-backward-cell))

  ;; Add ipython sections to imenu
  (add-hook 'python-mode-hook
            (lambda ()
              (add-to-list'imenu-generic-expression
               (list "Sections" python-cell-cellbreak-regexp 1))
              (imenu-add-to-menubar "Position")
              (setq imenu-create-index-function 'python-merge-imenu)))
  (defun python-merge-imenu ()
    (interactive)
    (let ((mode-imenu (python-imenu-create-index))
          (custom-imenu (imenu--generic-function imenu-generic-expression)))
      (append mode-imenu custom-imenu)))

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

(defface font-lock-ds-arguments-face
  '((t :inherit font-lock-doc-face
       :slant normal)) "Face for docstring arguments."
)

(font-lock-add-keywords 'python-mode
                        '(("[ ^:]*:param \\([a-zA-Z0-9_^:]*\\):" 1 "font-lock-ds-arguments-face" t)))
