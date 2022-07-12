RERUN := "(undefined references|Rerun to get (cross-references|the bars|point totals) right|Table widths have changed. Rerun LaTeX.|Linenumber reference failed)"
RERUNBIB := "No file.*\.bbl|Citation.*undefined"

all: pdf/00-intro-bayes.pdf  pdf/01-medium-bayes.pdf  pdf/02-advanced-bayes.pdf  pdf/03-super-bayes.pdf  pdf/10-mpt-recognition-memory.pdf  pdf/11-mpt-with-jasp.pdf

pdf/%.pdf: src/%.Rmd
	Rscript -e "rmarkdown::render(input='$<',output_dir='pdf')"
	
pdf/%.pdf: src/%.tex
	pdflatex -jobname=$(basename $@) $< 
	@egrep -q $(RERUNBIB) $*.log && bibtex $* && pdflatex $<; true
	@egrep -q $(RERUN) $*.log && pdflatex $<; true
	@egrep -q $(RERUN) $*.log && pdflatex $<; true

latexmk:
	-latexmk -pvc -pdf $(DOC)

tidy:
	-rm -f pdf/*.aux pdf/*.dvi pdf/*.log pdf/*.bbl pdf/*.blg pdf/*.brf pdf/*.fls pdf/*.toc pdf/*.thm pdf/*.out pdf/*.vrb pdf/*.snm pdf/*.nav pdf/*.fdb_latexmk

clean:
	-rm -f pdf/*

.PHONY: all tidy clean
