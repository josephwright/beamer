#$/bin/sh

for i in \
  Antibes Berkeley Berlin Copenhagen Darmstadt \
  Dresden Goettingen Hannover Ilmenau JuanLesPins \
  Luebeck Malmoe Marburg Montpellier PaloAlto \
  Pittsburgh Rochester Singapore Szeged Warsaw; do
  pdflatex \\def\\theme\{"$i"\}\\input beamerthemeexample.tex;
  mv beamerthemeexample.pdf beameruserguideexample"$i".pdf;
done

