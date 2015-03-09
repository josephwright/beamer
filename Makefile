################################################################
################################################################
# Makefile for beamer                                          #
################################################################
################################################################

TMPDIR   = /tmp/beamer
BUILDDIR = $(TMPDIR)/beamer

ROOTFILES = \
	AUTHORS   \
	ChangeLog \
	FILES     \
	INSTALL   \
	README    \
	TODO

STRUCTURE = \
	base                            \
	base/art                        \
	base/emulation                  \
	base/emulation/examples         \
	base/multimedia                 \
	base/themes/color               \
	base/themes/font                \
	base/themes/inner               \
	base/themes/outer               \
	base/themes/theme               \
	base/themes/theme/compatibility \
	base/translator                 \
	doc                             \
	doc/licenses                    \
	examples/a-conference-talk      \
	examples/a-lecture              \
	solutions/conference-talks      \
	solutions/generic-talks         \
	solutions/short-talks

TRANSLATOR = \
	basic        \
	bibliography \
	environment  \
	months       \
	numbers      \
	theorem

all: ctan

clean:
	rm -rf $(TMPDIR)
	pushd ./doc/ ;\
	make clean ; \
	popd
	pushd ./examples/ ;\
	make clean ; \
	popd

ctan:
	mkdir -p $(BUILDDIR)/
	for I in $(ROOTFILES) ; do \
	  cp ./$$I $(BUILDDIR)/ ; \
	done
	for I in $(STRUCTURE) ; do \
	  mkdir -p $(BUILDDIR)/$$I  ; \
	  cp ./$$I/*.* $(BUILDDIR)/$$I/ ; \
	done
	for I in $(TRANSLATOR) ; do \
	  mkdir -p $(BUILDDIR)/base/translator/dicts/translator-$$I-dictionary  ; \
	  cp ./base/translator/dicts/translator-$$I-dictionary/*.* $(BUILDDIR)/base/translator/dicts/translator-$$I-dictionary/ ; \
	done
	mkdir -p $(BUILDDIR)/doc/licenses
	cp ./doc/licenses/LICENSE $(BUILDDIR)/doc/licenses/
	cp ./doc/Makefile $(BUILDDIR)/doc/
	pushd $(BUILDDIR)/doc ; \
	make all ; \
	popd
	cp ./examples/Makefile $(BUILDDIR)/examples/
	pushd $(BUILDDIR)/examples ; \
	make all ; \
	popd
	pushd $(TMPDIR) ; \
	zip -ll -q -r -X beamer.zip . ; \
	popd
	cp $(TMPDIR)/beamer.zip .
	
	
	