;;; centered-cursor.el --- recenter cursor automatically -*- lexical-binding: t; -*-


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

;;; Cod

;;;###autoload
(define-minor-mode centered-cursor-mode
    "Center cursor within window restricted to buffer boundaries." nil nil nil
    (if centered-cursor-mode
        (add-hook 'post-command-hook #'centered-cursor-recenter nil 'local)
      (remove-hook 'post-command-hook #'centered-cursor-recenter 'local)))

;;;###au toload
(define-global-minor-mode global-centered-cursor-mode
    centered-cursor-mode centered-cursor-mode)

(defun centered-cursor-recenter ()
  "Center the point while keeping window within buffer contents."
  (if (function-get real-this-command 'scroll-command)
      ;; Scroll command move visible part of the buffer instead of the cursor.
      ;; Therefore we need to recenter the cursor after chaning window position.
      (when (and (> (window-start) 1) (< (window-end) (point-max)))
        (move-to-window-line (ceiling (/ (window-screen-lines) 2))))
    (when (eq (current-buffer) (window-buffer))
      (recenter))
    (let* ((shown-height (cdr (window-text-pixel-size (selected-window)
                                                      (window-start)
                                                      (window-end))))
           (dead-height (- (window-pixel-height) shown-height))
           (shown-lines (count-lines (window-start) (window-end) t))
           (line-height (if (zerop shown-height) 0
                          (/ shown-height shown-lines)))
           (window-lines (if (zerop line-height) (window-height)
                           (/ (window-pixel-height) line-height)))
           (dead-lines (- window-lines shown-lines)))
      ;; (message "dead-lines: %s, window-lines: %s, line-height: %s"
      ;;          dead-lines window-lines line-height)
      (scroll-down (if (zerop shown-height) 0
                     (max 0 (- dead-lines 3)))))))

(provide 'centered-cursor)
;;; centered-cursor.el ends here
