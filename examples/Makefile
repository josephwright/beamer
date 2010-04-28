examples = \
  beamerexample1 \
  beamerexample2.article \
  beamerexample2.beamer \
  beamerexample3 \
  beamerexample5 \
  beamerexample6

all: $(examples:%=%.pdf)

beamerexample2.article.pdf: beamerexample2.article.tex \
  beamerexample2.beamer.pdf 
	pdflatex $(@:%.pdf=%.tex)
	pdflatex $(@:%.pdf=%.tex)

%.pdf: %.tex
	pdflatex $(@:%.pdf=%.tex)
	pdflatex $(@:%.pdf=%.tex)
