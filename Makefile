
all: sitemap html

html:
	emacs --no-site-file -batch -l .deterministic-ids -eval '(progn (dolist (file command-line-args-left) (with-current-buffer (find-file-noselect file) (org-html-export-to-html) ) ) )' *.org

sitemap:
	{ echo '#+TITLE: sitemap';echo '#+SETUPFILE: setupfile.org';for fn in $$(ls *.org|grep -v -e setupfile.org -e sitemap.org); do echo '- [['./"$$fn"][$$(head -n1 "$$fn" | cut -d' ' -f2-)']]'; done; } > sitemap.org

