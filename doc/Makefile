rerun = "(There were undefined references|Rerun to get (cross-references|the bars) right)"
doc   = beameruserguide

themes = Antibes Berkeley Berlin Copenhagen Darmstadt \
  Dresden Frankfurt Goettingen Hannover Ilmenau JuanLesPins \
  Luebeck Malmoe Madrid Marburg Montpellier PaloAlto \
  Pittsburgh Rochester Singapore Szeged Warsaw \
  default boxes

fontthemes = bold default italics romanum sansserifstructure serifstructure

colorthemes = default darktitles

layoutthemes = bars lined miniframestop shadow sidebar smoothbars smoothtree split tree

elementthemes = circles rectangles rounded

all: $(doc).pdf

beameruserguide.pdf: $(doc).tex \
 $(themes:%=beamerugtheme%.pdf) \
 $(fontthemes:%=beamerugfonttheme%.pdf) \
 $(colorthemes:%=beamerugcolortheme%.pdf) \
 $(elementthemes:%=beamerugelementtheme%.pdf) \
 $(layoutthemes:%=beameruglayouttheme%.pdf) 
	pdflatex $(doc).tex
	(egrep -q $(rerun) $(doc).log && pdflatex $(doc).tex) || true

beamerugtheme%.pdf: beamerthemeexample.tex
	pdflatex \\def\\themename{$(@:beamerugtheme%.pdf=%)}\\input beamerthemeexample.tex;
	mv beamerthemeexample.pdf $@

beamerugfonttheme%.pdf: beamerfontthemeexample.tex
	pdflatex \\def\\themename{$(@:beamerugfonttheme%.pdf=%)}\\input beamerfontthemeexample.tex;
	mv beamerfontthemeexample.pdf $@

beamerugcolortheme%.pdf: beamercolorthemeexample.tex
	pdflatex \\def\\themename{$(@:beamerugcolortheme%.pdf=%)}\\input beamercolorthemeexample.tex;
	mv beamercolorthemeexample.pdf $@

beamerugelementtheme%.pdf: beamerelementthemeexample.tex
	pdflatex \\def\\themename{$(@:beamerugelementtheme%.pdf=%)}\\input beamerelementthemeexample.tex;
	mv beamerelementthemeexample.pdf $@

beameruglayouttheme%.pdf: beamerlayoutthemeexample.tex
	pdflatex \\def\\themename{$(@:beameruglayouttheme%.pdf=%)}\\input beamerlayoutthemeexample.tex;
	mv beamerlayoutthemeexample.pdf $@

clean:
	rm -f *.aux *.log *.bbl *.blg *.ps *.dvi *.pdf *.toc *.out *.snm
