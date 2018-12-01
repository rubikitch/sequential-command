;;; sequential-command.el --- Many commands into one command
;; $Id: sequential-command.el,v 1.3 2010/05/04 08:55:35 rubikitch Exp $

;; Copyright (C) 2009  rubikitch

;; Author: rubikitch <rubikitch@ruby-lang.org>
;; Keywords: convenience, lisp
;; URL: http://www.emacswiki.org/cgi-bin/wiki/download/sequential-command.el

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

;; Integrating multiple commands into one command is sometimes
;; useful. Pressing C-e at the end of line is useless and adding the
;; other behavior in this situation is safe.
;;
;; For example, defining `my-end': if point is at the end of line, go
;; to the end of buffer, otherwise go to the end of line. Just evaluate it!
;;
;; (define-sequential-command my-end  end-of-line end-of-buffer)
;; (global-set-key "\C-e" 'my-end)
;;
;; Consequently, pressing C-e C-e is `end-of-buffer'!
;;
;; `define-sequential-command' is a macro that defines a command whose
;; behavior is changed by sequence of calls of the same command.
;;
;; `sequential-command-return' is a command to return to the position when sequence
;; of calls of the same command was started.
;;
;; See sequential-command-config.el if you want examples.
;;
;; http://www.emacswiki.org/cgi-bin/wiki/download/sequential-command-config.el

;;; Commands:
;;
;; Below are complete command list:
;;
;;  `sequential-command-return'
;;    Return to the position when sequence of calls of the same command was started.
;;
;;; Customizable Options:
;;
;; Below are customizable option list:
;;

;;; Demonstration:

;; Execute M-x sequential-command-demo. And press C-x C-z many times.

;;; Bug Report:
;;
;; If you have problem, send a bug report via M-x sequential-command-send-bug-report.
;; The step is:
;;  0) Setup mail in Emacs, the easiest way is:
;;       (setq user-mail-address "your@mail.address")
;;       (setq user-full-name "Your Full Name")
;;       (setq smtpmail-smtp-server "your.smtp.server.jp")
;;       (setq mail-user-agent 'message-user-agent)
;;       (setq message-send-mail-function 'message-smtpmail-send-it)
;;  1) Be sure to use the LATEST version of sequential-command.el.
;;  2) Enable debugger. M-x toggle-debug-on-error or (setq debug-on-error t)
;;  3) Use Lisp version instead of compiled one: (load "sequential-command.el")
;;  4) Do it!
;;  5) If you got an error, please do not close *Backtrace* buffer.
;;  6) M-x sequential-command-send-bug-report and M-x insert-buffer *Backtrace*
;;  7) Describe the bug using a precise recipe.
;;  8) Type C-c C-c to send.
;;  # If you are a Japanese, please write in Japanese:-)

;;; History:

;; $Log: sequential-command.el,v $
;; Revision 1.3  2010/05/04 08:55:35  rubikitch
;; Added bug report command
;;
;; Revision 1.2  2009/02/17 03:04:18  rubikitch
;; * Add demo.
;; * Rename file name.
;; * New macro: `define-sequential-command'.
;; * New command: `sequential-command-return'.
;;
;; Revision 1.1  2009/02/17 01:24:04  rubikitch
;; Initial revision
;;

;;; Code:

(defvar sequential-command-version "$Id: sequential-command.el,v 1.3 2010/05/04 08:55:35 rubikitch Exp $")
(eval-when-compile (require 'cl))

(defvar sequential-command-store-count 0)
(defvar sequential-command-start-position nil
  "Stores `point' and `window-start' when sequence of calls of the same
 command was started. This variable is updated by `sequential-command-count'")

(defun sequential-command-count* ()
  "Returns number of times `this-command' was executed.
It also updates `sequential-command-start-position'."
  (if (eq last-command this-command)
      (incf sequential-command-store-count)
    (setq sequential-command-start-position  (cons (point) (window-start))
          sequential-command-store-count     0)))

(defmacro define-sequential-command (name &rest commands)
  "Define a command whose behavior is changed by sequence of calls of the same command."
  (let ((cmdary (apply 'vector commands)))
    `(defun ,name ()
       ,(concat "Sequential command of "
                (mapconcat
                 (lambda (cmd) (format "`%s'" (symbol-name cmd)))
                 commands " and ")
                ".")
       (interactive)
       (call-interactively
        (aref ,cmdary (mod (sequential-command-count*) ,(length cmdary)))))))
;; (macroexpand '(define-sequential-command foo beginning-of-line beginning-of-buffer))

(defun sequential-command-return ()
  "Return to the position when sequence of calls of the same command was started."
  (interactive)
  (goto-char (car sequential-command-start-position))
  (set-window-start (selected-window) (cdr sequential-command-start-position)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;  demonstration                                                     ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun sequential-command-demo ()
  (interactive)
  (global-set-key "\C-x\C-z" 'sequential-command-count-test)
  (message "Press C-x C-z repeatedly"))

(defun sequential-command-count-test ()
  (interactive)
  (message "sequential-command-count: %d" (sequential-command-count*)))

(define-sequential-command sequential-command-home
  beginning-of-line back-to-indentation beginning-of-buffer sequential-command-return)

;;;; Bug report
(defvar sequential-command-maintainer-mail-address
  (concat "rubiki" "tch@ru" "by-lang.org"))
(defvar sequential-command-bug-report-salutation
  "Describe bug below, using a precise recipe.

When I executed M-x ...

How to send a bug report:
  1) Be sure to use the LATEST version of sequential-command.el.
  2) Enable debugger. M-x toggle-debug-on-error or (setq debug-on-error t)
  3) Use Lisp version instead of compiled one: (load \"sequential-command.el\")
  4) If you got an error, please paste *Backtrace* buffer.
  5) Type C-c C-c to send.
# If you are a Japanese, please write in Japanese:-)")
(defun sequential-command-send-bug-report ()
  (interactive)
  (reporter-submit-bug-report
   sequential-command-maintainer-mail-address
   "sequential-command.el"
   (apropos-internal "^seq" 'boundp)
   nil nil
   sequential-command-bug-report-salutation))

(provide 'sequential-command)

;; How to save (DO NOT REMOVE!!)
;; (emacswiki-post "sequential-command.el")
;;; sequential-command.el ends here
