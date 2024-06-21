ORG := $(filter-out index.org, $(wildcard *.org */index.org))
OUT := $(ORG:org=html)

all: html index.html

html: $(OUT)

%.html: %.org
	emacs --no-site-file -batch -l .deterministic-ids -eval '(progn (dolist (file command-line-args-left) (with-current-buffer (find-file-noselect file) (org-html-export-to-html) ) ) )' $<

index.org: $(ORG)
	{ echo "#+TITLE: xfnw's org wiki thing"; echo '#+SETUPFILE: setupfile.org'; echo '* top level directories'; printf '%s\n' */ | busybox sort -f | while read fn; do [ -f "$${fn}index.org" ] && echo "- [[./$$fn][$$fn]]"; done; echo '* top level pages'; printf '%s\n' *.org | grep -v '^\(setupfile\.org\|index\.org\)$$' | busybox sort -f | while read fn; do echo "- [[./$$fn][$$(head -n1 "$$fn" | cut -d' ' -f2-)]]"; done; } > index.org

clean:
	rm -f *.html~
	git gc
	git repack -Ad
	git prune

