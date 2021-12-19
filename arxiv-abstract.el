;; Defining the arxiv-abstract-mode
(require 'arxiv-vars)

(defun arxiv-insert-with-face (string face-property)
  "wrapper function to insert a string with given face property.
the optional misc is a plist for modification of additional properties"
  (insert (propertize string 'font-lock-face face-property)))

(defun arxiv-get-plist ()
  (interactive)
  (print (text-properties-at (point))))

(defun arxiv-format-abstract-page (entry)
  (arxiv-insert-with-face (format "\n%s\n\n" (cdr (assoc 'title entry))) '(arxiv-title-face (:height 1.2 :weight semi-bold)))
  ;; author list
  (let ((authors (cdr (assoc 'authors entry))))
    (dolist (author authors)
      (arxiv-insert-with-face (format "%s" author) '(arxiv-author-face (:height 1.1 :underline t)))
      (insert ", ")))
  (delete-char -2)
  (insert "\n\n")
  ;; abstract
  (let ((abstract (cdr (assoc 'abstract entry))))
    (arxiv-insert-with-face "    " arxiv-abstract-face)
    (setq abstract (replace-regexp-in-string "^ +" "" abstract))    
    (insert (propertize abstract 'font-lock-face arxiv-abstract-face 'wrap-prefix "    ")))
  ;; highlight math
  (save-excursion
    (while (search-backward-regexp "\\$[^$]+\\$" nil t)
      (add-text-properties (match-beginning 0) (match-end 0) '(font-lock-face arxiv-abstract-math-face))))
  ;; comment
  (if (cdr (assoc 'comment entry))
      (arxiv-insert-with-face (format "\n\nComments: %s" (cdr (assoc 'comment entry))) arxiv-subfield-face)
    (arxiv-insert-with-face "\n\nComments: N/A" arxiv-subfield-face))
  ;; subject
  (arxiv-insert-with-face (format "\nSubjects: ") arxiv-subfield-face)
  (let* ((main-cat t) (cats (cdr (assoc 'categories entry))))
    (dolist (cat cats)
      (let (field)
	(setq field (symbol-name (cdr (assoc (intern-soft cat) arxiv-subject-classifications))))
	(if main-cat
	    (progn ; the main subject is in bold
	      (arxiv-insert-with-face (format "%s " (replace-regexp-in-string "_" " " field)) 'arxiv-subfield-face-bold)
	      (arxiv-insert-with-face (format "(%s)" cat) 'arxiv-subfield-face-bold)
	      (setq main-cat nil))
	  (insert (propertize (format "%s " (replace-regexp-in-string "_" " " field)) 'font-lock-face arxiv-subfield-face 'wrap-prefix "  "))
	  (insert (propertize (format "(%s)" cat) 'font-lock-face arxiv-subfield-face 'wrap-prefix "  ")))
	(arxiv-insert-with-face "; " arxiv-subfield-face))))
  (delete-char -2)
  ;; journal/DOI
  (when (cdr (assoc 'journal entry)) (arxiv-insert-with-face (format "\nJournal: %s" (cdr (assoc 'journal entry))) arxiv-subfield-face))
  (when (cdr (assoc 'DOI entry)) (arxiv-insert-with-face (format "\nDOI: %s" (cdr (assoc 'DOI entry))) arxiv-subfield-face))
  ;; times
  (arxiv-insert-with-face (format "\nSubmitted: %s" (cdr (assoc 'date entry))) arxiv-subfield-face)
  (arxiv-insert-with-face (format "\nUpdated: %s" (cdr (assoc 'updated entry))) arxiv-subfield-face))

(defvar arxiv-abstractmode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET") 'arxiv-open-current-url)
    (define-key map (kbd "SPC") 'arxiv-show-hide-abstract)
    (define-key map (kbd "d") 'arxiv-download-pdf)
    (define-key map (kbd "e") 'arxiv-download-pdf-export-bibtex)
    (define-key map (kbd "b") 'arxiv-export-bibtex)
    (define-key map (kbd "q") 'arxiv-exit)
    map))

(define-derived-mode arxiv-abstract-mode text-mode "arXiv-abstract"
  "Major mode for reading arXiv abstracts."  
)
  

(provide 'arxiv-abstract)

;;; arxiv-abstract.el ends here
