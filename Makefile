
CWD    = $(CURDIR)
MODULE = $(notdir $(CWD))

NOW = $(shell date +%d%m%y)
REL = $(shell git rev-parse --short=4 HEAD)

TEX  = $(MODULE).tex header.tex

LATEX = pdflatex -halt-on-error

$(MODULE).pdf: $(TEX) $(SRC) $(IMG) .vscode/settings.json
	$(LATEX) $< | tail -n7
	$(LATEX) $< | tail -n7

pdf: $(MODULE)_$(NOW)-$(REL).pdf
$(MODULE)_$(NOW)-$(REL).pdf: $(MODULE).pdf Makefile
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook \
		-dNOPAUSE -dQUIET -dBATCH -sOutputFile=$@ $<


########################################################################## VSCode

ifeq ($(OS),Windows_NT)
VSCsettings = .vscode/windows.json
else
VSCsettings = .vscode/linux.json
endif

vscode: .vscode/settings.json
.vscode/settings.json: $(VSCsettings)
	cp $< $@

###################################################################### DOC	

WGET = wget -c --no-check-certificate

doc: doc/LittleSmalltalk.pdf

doc/LittleSmalltalk.pdf:
	$(WGET)	-O $@ http://sdmeta.gforge.inria.fr/FreeBooks/LittleSmalltalk/ALittleSmalltalk.pdf

