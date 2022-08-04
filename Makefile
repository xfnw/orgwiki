
html:
	emacs --no-site-file -batch -l .deterministic-ids -eval '(progn (dolist (file command-line-args-left) (with-current-buffer (find-file-noselect file) (org-html-export-to-html) ) ) )' *.org

