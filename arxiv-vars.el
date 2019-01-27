;; Defining the common variables for arxiv-mode

(defgroup arxiv nil
  "A mode for reading arXiv abstracts"
  :prefix "arxiv-"
  :group 'applications)

(defgroup arxiv-fontification nil
  "Faces for the arxiv mode"
  :group 'arxiv)

(defgroup arxiv-preferences nil
  "General preferences for the arxiv mode"
  :group 'arxiv)

(defvar arxiv-keyword-list-default nil
  "A list of highlighting keywords for arXiv mode.")

(defvar arxiv-mode-hook nil
  "A list of functions to call when entering arxiv-mode.")

(defvar arxiv-mode-map nil
  "Key map for arxiv-mode.")

(defvar arxiv-mode-syntax-table (make-syntax-table text-mode-syntax-table))

(defvar arxiv-highlight-overlays [nil nil nil])

(defvar arxiv-entry-list nil
  "Entries for arXiv articles.")

(defvar arxiv-current-entry nil
  "Current entry in the arXiv article list.")

(defcustom arxiv-entries-per-page 100
  "Number of entries per page in the article list."
  :group 'arxiv-preferences
  :type 'integer)

(defcustom arxiv-default-browser "firefox"
  "Default browser for opening the arXiv url."
  :group 'arxiv-preferences
  :type 'string)

;; Defining custom faces
(defvar arxiv-title-face 'arxiv-title-face)
(defface arxiv-title-face 
  '((t (:inherit font-lock-keyword-face :height 1.2 :family "Lucida Grande")))
  "Face name for article titles in the arXiv article list."
  :group 'arxiv-fontification)

(defvar arxiv-keyword-face 'arxiv-keyword-face)
(defface arxiv-keyword-face
  '((t (:inherit font-lock-constant-face)))
  "Face name for keywords in the arXiv article list."
  :group 'arxiv-fontification)

(defvar arxiv-abstract-face 'arxiv-abstract-face)
(defface arxiv-abstract-face
  '((t (:inherit font-lock-string-face)))
  "Face name for abstract in the arXiv abstract viewing window."
  :group 'arxiv-fontification)

(defvar arxiv-abstract-math-face 'arxiv-abstract-math-face)
(defface arxiv-abstract-math-face
  '((t (:inherit font-lock-reference-face :height 1.0 :family "Monospace")))
  "Face name for the latex content in abstract in the arXiv
abstract viewing window."
  :group 'arxiv-fontification)

(defvar arxiv-keyword-list-abstract nil
  "A list of highlighting keywords for arXiv abstract viewing mode")

(defvar arxiv-abstract-mode-hook nil
  "A list of functions to call when entering arxiv-abstract-mode.")

(defvar arxiv-abstract-syntax-table nil)
(setq arxiv-abstract-syntax-table
      (let ((synTable (make-syntax-table text-mode-syntax-table)))

        ;; bash style comment: “# …” 
        ;; (modify-syntax-entry ?# "< b" synTable)
        ;; (modify-syntax-entry ?\n "> b" synTable)
        (modify-syntax-entry ?$ "($" synTable)
        (modify-syntax-entry ?$ ")$" synTable)

        synTable))

(provide 'arxiv-vars)

;; end of arxiv-vars.el
