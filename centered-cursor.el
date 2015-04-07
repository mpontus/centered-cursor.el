;;; centered-cursor.el --- recenter window and cursor automatically -*- lexical-binding: t; -*-

;; Copyright (C) 2015  Michael Pontus

;; Author: Michael Pontus <m.pontus@gmail.com>
;; Keywords: convenience

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package provides minor mode, that when active will cause
;; window to recenter on cursor while staying within buffer bounds.
;; It means in addition to recentering window will not display past
;; buffer end.

;; Scroll commands, that would normally in such case prevent window
;; from scrolling past certain point, are handled by forcing the
;; cursor to recenter within window before and after adjusting it.

;;; Code:

(defun centered-cursor-recenter ()
  (ignore-errors
    (if (function-get this-command 'scroll-command)
        (move-to-window-line nil))
    (recenter (save-excursion
                (- (1+ (vertical-motion
                        (floor (window-screen-lines) 2))))))
    (if (function-get this-command 'scroll-command)
        (move-to-window-line nil))))

;;;###autoload
(define-minor-mode centered-cursor-mode
    "Center cursor within window restricted to buffer boundaries."
  nil nil nil
  (if centered-cursor-mode
      (progn
        (add-hook 'pre-command-hook #'centered-cursor-pre-command nil 'local))
    (remove-hook 'pre-command-hook #'centered-cursor-pre-command 'local)))

(define-global-minor-mode global-centered-cursor-mode
    centered-cursor-mode centered-cursor-mode)

(provide 'centered-cursor)
;;; centered-cursor.el ends here
