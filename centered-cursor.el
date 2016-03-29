;;; centered-cursor.el --- recenter cursor automatically -*- lexical-binding: t; -*-

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

;;;###autoload
(define-minor-mode centered-cursor-mode
    "Center cursor within window restricted to buffer boundaries." nil nil nil
    (if centered-cursor-mode
        (add-hook 'post-command-hook #'centered-cursor-recenter nil 'local)
      (remove-hook 'post-command-hook #'centered-cursor-recenter 'local)))

;;;###autoload
(define-global-minor-mode global-centered-cursor-mode
    centered-cursor-mode centered-cursor-mode)

(defun centered-cursor-recenter ()
  "Center the point while keeping window within buffer contents."
  (let ((middle-line (ceiling (/ (window-screen-lines) 2))))
    ;; scroll-commands such as <C-v>, <M-v> change the window scroll
    ;; and only move cursor by side effect.
    ;;
    ;; To ensure that cursor stays remains centered we need to change
    ;; its position and recenter in case it stopped on EOB.
    (when (function-get this-command 'scroll-command)
      (move-to-window-line middle-line))
    (recenter middle-line)))

(defun turn-on-centered-cursor ()
  "Unconditionally turn on Centered Cursor mode."
  (centered-cursor-mode 1))

(defun turn-offcentered ()
  "Unconditionally turn off Centered Cursor mode."
  (centered-cursor-mode -1))

(provide 'centered-cursor)
;;; centered-cursor.el ends here
