;;; beamer.el --- AUCTeX style for the latex-beamer class

;; Copyright (C) 2004 Thomas Baumann
;; License: GPL, see the file COPYING in the base directory of AUCTeX

;; Author: Thomas Baumann <thomas.baumann@ch.tum.de>
;; Created: 2003-12-20
;; Version: $Id$
;; Keywords: tex

;;; Commentary:

;; This file adds support for the latex-beamer class.
;;
;; This file is intended to be used with the AUCTeX-Package.
;; Put this File into your TeX-style-path. You may also
;; byte-compile this file.

;;; Code:
(TeX-add-style-hook "beamer"
 (function
  (lambda ()
    (defvar beamer-use-section-labels-flag nil
      "Controls whether section labels are added")
    (unless beamer-use-section-labels-flag
      (make-local-variable 'LaTeX-section-hook)
      (setq LaTeX-section-hook
             '(LaTeX-section-heading
               LaTeX-section-title
               LaTeX-section-section)))

    (setq LaTeX-item-list
          (append '(("itemize" . LaTeX-item-beamer)
                    ("enumerate" . LaTeX-item-beamer))
                  LaTeX-item-list))

    (TeX-add-symbols
     '("alert" 1)
     '("alt" TeX-arg-beamer-overlay-spec 2)
     '("beamerbutton" 1)
     '("beamergotobutton" 1)
     '("beamerreturnbutton" 1)
     '("beamerskipbutton" 1)
     '("frame" TeX-arg-beamer-frametitle)
     '("frametitle" 1)
     '("hyperlink" TeX-arg-beamer-overlay-spec 2)
     '("hyperlinkslideprev" TeX-arg-beamer-overlay-spec 1)
     '("hyperlinkslidenext" TeX-arg-beamer-overlay-spec 1)
     '("hyperlinkframestart" TeX-arg-beamer-overlay-spec 1)
     '("hyperlinkframeend" TeX-arg-beamer-overlay-spec 1)
     '("hyperlinkframestartnext" TeX-arg-beamer-overlay-spec 1)
     '("hyperlinkframeendprev" TeX-arg-beamer-overlay-spec 1)
     '("hyperlinkpresentationstart" TeX-arg-beamer-overlay-spec 1)
     '("hyperlinkpresentationend" TeX-arg-beamer-overlay-spec 1)
     '("hyperlinkappendixstart" TeX-arg-beamer-overlay-spec 1)
     '("hyperlinkappendixend" TeX-arg-beamer-overlay-spec 1)
     '("hyperlinkdocumentstart" TeX-arg-beamer-overlay-spec 1)
     '("hyperlinkdocumentend" TeX-arg-beamer-overlay-spec 1)
     '("hypertarget" TeX-arg-beamer-overlay-spec 2)
     '("institute" 1)
     '("invisible" TeX-arg-beamer-overlay-spec 1)
     '("label" TeX-arg-beamer-overlay-spec 1)
     '("logo" 1)
     '("note" TeX-arg-beamer-note 1)
     '("only" TeX-arg-beamer-overlay-spec 1)
     '("onslide" TeX-arg-beamer-overlay-spec)
     '("partpage")
     '("pause")
     '("structure" TeX-arg-beamer-overlay-spec 1)
     '("temporal" TeX-arg-beamer-overlay-spec 3)
     '("titlepage")
     '("titlegraphic" 1)
     '("uncover" TeX-arg-beamer-overlay-spec 1)
     '("visible" TeX-arg-beamer-overlay-spec 1)
     )
    
    (LaTeX-add-environments
     '("actionenv")
     '("alertblock" 1)
     '("beamerboxesrounded" 1)
     '("block" 1)
     '("column" "Width")
     "columns"
     "columnsonlytextwidth"
     '("exampleblock" 1)
     '("onlyenv" (lambda (env &rest ignore)
                   (LaTeX-insert-environment
                    env
                    (let ((overlay (read-input "Overlay: ")))
                      (if (not (zerop (length overlay)))
                          (format "<%s>" overlay))))))
     '("overlayarea" "Area width" "Area height")
     '("overprint"  (lambda (env &rest ignore)
                      (LaTeX-insert-environment
                       env
                       (let ((overlay (read-input "Overlay: ")))
                         (if (not (zerop (length overlay)))
                             (format "{%s}" overlay)))))))

    )))

(defun TeX-arg-beamer-overlay-spec (optional &optional prompt)
  "Prompt for overlay specification." 
  (let ((overlay (read-input "Overlay: ")))
    (if (not (zerop (length overlay)))
        (progn (insert "<" overlay ">")))
    (indent-according-to-mode)))

(defun TeX-arg-beamer-frametitle (optional &optional prompt)
  "Prompt for the frametitle."
  (let ((title (read-input "What title: ")))
    (if (not (zerop (length title)))
        (progn (insert TeX-grop TeX-esc "frametitle" TeX-grop 
                       title TeX-grcl TeX-grcl))
      (progn (insert TeX-grop TeX-grcl)))))

(defun LaTeX-item-beamer ()
  "Insert a new item with an optional overlay argument."
  (TeX-insert-macro "item")
  (delete-horizontal-space)
  (TeX-arg-beamer-overlay-spec 0)
  (insert " ")
  (indent-according-to-mode))
  
(defun TeX-arg-beamer-note (optional &optional prompt)
  "Prompt for overlay specification and optional argument."
  (let ((overlay (read-input "Overlay: "))
        (options (read-input "Options: ")))
    (if (not (zerop (length overlay)))
        (progn (insert "<" overlay ">")))
    (if (not (zerop (length options)))
        (progn (insert "[" options "]")))
    (indent-according-to-mode)))

