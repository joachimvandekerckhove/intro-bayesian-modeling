RERUN := "(undefined references|Rerun to get (cross-references|the bars|point totals) right|Table widths have changed. Rerun LaTeX.|Linenumber reference failed)"
RERUNBIB := "No file.*\.bbl|Citation.*undefined|.*There were undefined references"

all: pdf/00-intro-bayes.pdf  pdf/01-medium-bayes.pdf  pdf/02-advanced-bayes.pdf  pdf/03-super-bayes.pdf  pdf/10-mpt-recognition-memory.pdf  pdf/11-mpt-with-jasp.pdf  pdf/12-mpt-solution.pdf

pdf/%.pdf: src/%.Rmd
	Rscript -e "rmarkdown::render(input='$<',output_dir='pdf')"
	
pdf/%.pdf: src/%.tex
	pdflatex -jobname=$(basename $@) $< 
	bibtex $(basename $@) 
	bibtex $(basename $@) 
	bibtex $(basename $@) 
	pdflatex -jobname=$(basename $@) $< 
	pdflatex -jobname=$(basename $@) $< 

latexmk:
	-latexmk -pvc -pdf $(DOC)

push:
	git add . && git commit -am"Automated commit" && git push
  
tidy:
	-rm -f pdf/*.aux pdf/*.dvi pdf/*.log pdf/*.bbl pdf/*.blg pdf/*.brf pdf/*.fls pdf/*.toc pdf/*.thm pdf/*.out pdf/*.vrb pdf/*.snm pdf/*.nav pdf/*.fdb_latexmk

clean:
	-rm -f pdf/*

.PHONY: all tidy clean
