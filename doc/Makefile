rerun = "(There were undefined references|Rerun to get (cross-references|the bars) right)"
doc   = beameruserguide

themes = Antibes Berkeley Berlin Copenhagen Darmstadt \
  Dresden Frankfurt Goettingen Hannover Ilmenau JuanLesPins \
  Luebeck Malmoe Madrid Marburg Montpellier PaloAlto \
  Pittsburgh Rochester Singapore Szeged Warsaw \
  default boxes

fontthemes = default serif structurebold structureitalicserif structuresmallcapsserif 

colorthemes = default crane albatross seahorse whale rose orchid sidebartab lily structure dove seagull beetle fly

outerthemes = default infolines miniframes shadow sidebar smoothbars smoothtree split tree

innerthemes = default circles rectangles rounded

all: $(doc).pdf

beameruserguide.pdf: $(doc).tex \
 $(themes:%=beamerugtheme%.pdf) \
 $(fontthemes:%=beamerugfonttheme%.pdf) \
 $(colorthemes:%=beamerugcolortheme%.pdf) \
 $(innerthemes:%=beameruginnertheme%.pdf) \
 $(outerthemes:%=beamerugoutertheme%.pdf) 
	pdflatex $(doc).tex
	makeindex beameruserguide.idx
	(egrep -q $(rerun) $(doc).log && pdflatex $(doc).tex) || true

beamerugtheme%.pdf: beamerthemeexample.tex beamerthemeexamplebase.tex ../themes/theme/beamertheme%.sty
	pdflatex \\def\\themename{$(@:beamerugtheme%.pdf=%)}\\input beamerthemeexample.tex;
	mv beamerthemeexample.pdf $@

beamerugfonttheme%.pdf: beamerfontthemeexample.tex beamerthemeexamplebase.tex ../themes/font/beamerfonttheme%.sty
	pdflatex \\def\\themename{$(@:beamerugfonttheme%.pdf=%)}\\input beamerfontthemeexample.tex;
	mv beamerfontthemeexample.pdf $@

beamerugcolortheme%.pdf: beamercolorthemeexample.tex beamerthemeexamplebase.tex ../themes/color/beamercolortheme%.sty
	pdflatex \\def\\themename{$(@:beamerugcolortheme%.pdf=%)}\\input beamercolorthemeexample.tex;
	mv beamercolorthemeexample.pdf $@

beameruginnertheme%.pdf: beamerinnerthemeexample.tex beamerthemeexamplebase.tex ../themes/inner/beamerinnertheme%.sty
	pdflatex \\def\\themename{$(@:beameruginnertheme%.pdf=%)}\\input beamerinnerthemeexample.tex;
	mv beamerinnerthemeexample.pdf $@

beamerugoutertheme%.pdf: beamerouterthemeexample.tex beamerthemeexamplebase.tex ../themes/outer/beameroutertheme%.sty
	pdflatex \\def\\themename{$(@:beamerugoutertheme%.pdf=%)}\\input beamerouterthemeexample.tex;
	mv beamerouterthemeexample.pdf $@

clean:
	rm -f *.aux *.log *.bbl *.blg *.ps *.dvi *.pdf *.toc *.out *.snm
