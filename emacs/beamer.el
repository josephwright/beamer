; Copyright 2004 by Thomas Baumann <thomas.baumann@ch.tum.de> and 
; Till Tantau <tantau@users.sourceforge.net>.  
;
; This program can be redistributed and/or modified under the terms
; of the GNU Public License, version 2.

; This file is  due to Thomas Baumann <thomas.baumann@ch.tum.de>.

(TeX-add-style-hook "beamer"
 (function
  (lambda ()
;; uncomment the following lines if you dont't want labels
;; for sections and subsections
;;     (make-local-variable 'LaTeX-section-hook)
;;     (setq LaTeX-section-hook
;;           '(LaTeX-section-heading
;;             LaTeX-section-title
;;             LaTeX-section-section))
    (TeX-add-symbols
     '("alert" 1)
     '("column" "Width")
     '("frame" TeX-arg-beamer-frametitle)
     '("frametitle" 1)
     '("institute" 1)
     '("invisible" TeX-arg-beamer-overlay-spec 1)
     '("only" TeX-arg-beamer-overlay-spec 1)
     '("partpage")
     '("pause")
     '("structure" 1)
     '("titlepage")
     '("uncover" TeX-arg-beamer-overlay-spec 1)
     )
    
    (LaTeX-add-environments
     '("alertblock" 1)
     '("block" 1)
     "columns"
     "columnsonlytextwidth"
     '("exampleblock" 1)
     ))))

(defun TeX-arg-beamer-overlay-spec (optional &optional prompt)
  "Prompt for overlay specification."
  (let ((overlay (read-input "Overlay: ")))
    (if (not (zerop (length overlay)))
        (progn (insert "<" overlay ">")))))

(defun TeX-arg-beamer-frametitle (optional &optional prompt)
  "Prompt for the frametitle."
  (let ((title (read-input "What title: ")))
    (if (not (zerop (length title)))
        (progn (insert TeX-grop TeX-esc "frametitle" TeX-grop
                       title TeX-grcl TeX-grcl))
      (progn (insert TeX-grop TeX-grcl)))))

