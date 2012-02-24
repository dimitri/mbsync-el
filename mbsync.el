;;; mbsync.el --- run mbsync to fetch mails

(require 'gnus)

(defvar mbsync-executable (executable-find "mbsync")
  "Where to find the `mbsync' utility")

(defvar mbsync-args '("-a")
  "List of options to pass to the `mbsync' command")

(defun mbsync ()
  "run the `mbsync' command, synchronously"
  (interactive)
  (let* ((buffer "*mbsync*")
	 (yes    (make-temp-file "mbsync"))
	 ;; mbsync might ask about certificates validation
	 (dummy (with-temp-file yes (insert "yes\n")))
	 (ret
	  (apply 'call-process mbsync-executable yes buffer nil mbsync-args)))
    (if (member ret '(0 1))		; WTF?
	(message "mbsync is done")
      (set-window-buffer (selected-window) buffer))))

(add-hook 'gnus-get-top-new-news-hook 'mbsync))

(provide 'mbsync)
