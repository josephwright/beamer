examples = \
  a-conference-talk/beamerexample-conference-talk \
  a-lecture/beamerexample-lecture-beamer-version \
  a-lecture/beamerexample-lecture-print-version

all: $(examples:%=%.pdf)

%.pdf: %.tex
	pdflatex $(@:%.pdf=%.tex)
	pdflatex $(@:%.pdf=%.tex)
	rm -f *.aux *.log *.nav *.out *.snm *.toc *.vrb

clean:
	rm -f *.aux *.log *.nav *.pdf *.out *.snm *.toc *.vrb
