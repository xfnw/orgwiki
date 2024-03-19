ORG := $(filter-out sitemap.org, $(wildcard *.org))
OUT := $(ORG:org=html)

all: sitemap.html $(OUT)

%.html: %.org
	emacs --no-site-file -batch -l .deterministic-ids -eval '(progn (dolist (file command-line-args-left) (with-current-buffer (find-file-noselect file) (org-html-export-to-html) ) ) )' $<

sitemap.org: $(ORG)
	{ echo '#+TITLE: sitemap';echo '#+SETUPFILE: setupfile.org'; find . \( -path './.git' -o -path './media' \) -prune -o -name '*.org' -not -name 'sitemap.org' -not -name 'setupfile.org' -print | busybox sort -f | while read fn; do echo '- [['"$$fn"][$$(head -n1 "$$fn" | cut -d' ' -f2-)']]'; done; } > sitemap.org

clean:
	rm -f *.html~
	git gc
	git repack -Ad
	git prune

