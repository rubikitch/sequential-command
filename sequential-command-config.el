;;; sequential-command-config.el --- Examples of sequential-command.el
;; $Id: sequential-command-config.el,v 1.3 2009/03/22 09:09:58 rubikitch Exp $

;; Copyright (C) 2009  rubikitch

;; Author: rubikitch <rubikitch@ruby-lang.org>
;; Keywords: extensions, convenience
;; URL: http://www.emacswiki.org/cgi-bin/wiki/download/sequential-command-config.el

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; Examples of sequential-command.el .

;;; Commands:
;;
;; Below are complete command list:
;;
;;  `sequential-command-setup-keys'
;;    Rebind C-a, C-e, M-u, M-c, and M-l to sequential-command-* commands.
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;

;;; History:

;; $Log: sequential-command-config.el,v $
;; Revision 1.3  2009/03/22 09:09:58  rubikitch
;; New command: `sequential-command-setup-keys'
;;
;; Revision 1.2  2009/02/17 12:56:26  rubikitch
;; fixed typo
;;
;; Revision 1.1  2009/02/17 03:13:47  rubikitch
;; Initial revision
;;

;;; Code:

(defvar sequential-command-config-version "$Id: sequential-command-config.el,v 1.3 2009/03/22 09:09:58 rubikitch Exp $")
(require 'sequential-command)

(define-sequential-command sequential-command-home
  beginning-of-line beginning-of-buffer sequential-command-return)
(define-sequential-command sequential-command-end
  end-of-line end-of-buffer sequential-command-return)

(defun sequential-command-upcase-backward-word ()
  (interactive)
  (upcase-word (- (1+ (sequential-command-count*)))))
(defun sequential-command-capitalize-backward-word ()
  (interactive)
  (capitalize-word (- (1+ (sequential-command-count*)))))
(defun sequential-command-downcase-backward-word ()
  (interactive)
  (downcase-word (- (1+ (sequential-command-count*)))))

(when (require 'org nil t)
  (define-sequential-command org-sequential-command-home
    org-beginning-of-line beginning-of-buffer sequential-command-return)
  (define-sequential-command org-sequential-command-end
    org-end-of-line end-of-buffer sequential-command-return))

(defun sequential-command-setup-keys ()
  "Rebind C-a, C-e, M-u, M-c, and M-l to sequential-command-* commands.
If you use `org-mode', rebind C-a and C-e."
  (interactive)
  (global-set-key "\C-a" 'sequential-command-home)
  (global-set-key "\C-e" 'sequential-command-end)
  (global-set-key "\M-u" 'sequential-command-upcase-backward-word)
  (global-set-key "\M-c" 'sequential-command-capitalize-backward-word)
  (global-set-key "\M-l" 'sequential-command-downcase-backward-word)
  (when (require 'org nil t)
    (define-key org-mode-map "\C-a" 'org-sequential-command-home)
    (define-key org-mode-map "\C-e" 'org-sequential-command-end)))

(provide 'sequential-command-config)

;; How to save (DO NOT REMOVE!!)
;; (emacswiki-post "sequential-command-config.el")
;;; sequential-command-config.el ends here
