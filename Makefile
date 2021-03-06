
CWD    = $(CURDIR)
MODULE = $(notdir $(CWD))

NOW = $(shell date +%d%m%y)
REL = $(shell git rev-parse --short=4 HEAD)

TEX  = $(MODULE).tex header.tex
TEX += language/language.tex language/preface.tex language/history.tex language/about.tex language/getit.tex
TEX += language/basics.tex language/objects.tex language/backread.tex
TEX += language/syntax.tex language/literals.tex language/idents.tex language/messages.tex 
TEX += language/getstart.tex language/finding.tex language/blocks.tex language/conts.tex
TEX += language/classes.tex language/basobj.tex language/collections.tex language/control.tex language/classman.tex language/abstract.tex
TEX += language/classdef.tex language/example.tex language/procdef.tex language/app.tex language/saving.tex
TEX += language/cascade.tex language/cascades.tex language/prims.tex language/numbers.tex
TEX += language/simulation.tex language/icecream.tex language/further.tex
TEX += language/generator.tex
TEX += language/filters.tex language/goal.tex language/genops.tex language/getfurs.tex
TEX += language/graph.tex language/process.tex
TEX += refs.tex
TEX += projects/projects.tex
TEX += implement/implement.tex implement/overview.tex implement/objects.tex
TEX += implement/bytecode.tex implement/process.tex implement/interpre.tex
TEX += implement/typeless.tex implement/unscoped.tex implement/interact.tex
TEX += implement/multi.tex implement/sysover.tex

IMG  = little.jpeg
IMG += language/fig_1_1.png language/fig_1_2.png language/fig_1_3.png
IMG += language/tbl1.png language/fig_4_1.png language/fig_4_2.png
IMG += language/fig_4_3_a.png language/fig_4_3_b.png
IMG += language/fig_6_1.png language/numbers.png
IMG += language/fig_7_1.png language/fig_7_2.png language/fig_7_3.png
IMG += language/fig_8_1.png language/fig_8_2.png language/fig_8_3.png
IMG += language/filter_1.png language/filter_2.png language/filter_3.png
IMG += implement/val.png implement/tagval.png implement/classval.png
IMG += implement/fig_11_1.png implement/fig_11_2.png
IMG += implement/fig_11_3.png implement/fig_11_4.png
IMG += implement/fig_11_5.png implement/fig_11_x.png
IMG += implement/fig_11_6.png

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

################################################################# SHADOW git	

.PHONY: merge release

MERGE  = Makefile README.md .gitignore doc
MERGE += $(TEX) $(SRC) $(IMG)

merge:
	git checkout master
	git checkout shadow -- $(MERGE)

release: pdf
	git tag $(NOW)-$(REL)
	git push -v && git push -v --tags
	git checkout shadow
