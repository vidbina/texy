TEXtoDVI=xelatex
DVItoPS=dvips
PStoPDF=ps2pdf
VIEWER=evince
RM=rm -f
M4=m4 -I
GPIC=gpic -t
FILENAME=$(wildcard *.tex)
CMPATH=~/.TeX/packages/Circuit_macros7.3.1
IMG=$(wildcard graphics/*.svg)
PIC=$(wildcard circuits/*.m4)

RECIPE=$(FILENAME:.tex=.pdf)

M4CONV=
GPICTEX=

.PHONY: all
all: graphx text glos index bib text
#$(RECIPE)
	@echo '--------------------------'

.PHONY: preview
preview: all
	evince $(RECIPE) &

#%.dvi: %.tex
#	$(TEXtoDVI) $<
#
#%.ps: %.dvi
#	$(DVItoPS) $<
#
#%.pdf: %.ps
#	$(PStoPDF) $<

.PHONY: bib
bib:
	bibtex $(FILENAME:.tex=)

.PHONY: glos
glos:
	makeglossaries $(FILENAME:.tex=)

.PHONY: index
index:
	makeindex $(FILENAME)

.PHONY: pic
pic: 
#m4 -I $(CMPATH) libcct.m4 $(PIC) > $(PIC:.m4=.pic)
#gpic -t $(PIC:.m4=.pic) > $(PIC:.m4=.tex)
	$(foreach FILE, $(PIC), $(M4) $(CMPATH) libcct.m4 $(FILE) > $(FILE:.m4=.pic);)
	$(foreach FILE, $(PIC), $(GPIC) $(FILE:.m4=.pic) > $(FILE:.m4=.tex);)

.PHONY: text
text:
	xelatex --shell-escape $(FILENAME)

.PHONY: graphx
graphx:
	$(foreach FILE, $(IMG), $(INKSCAPE) --file=$(FILE) --export-pdf=$(FILE:.svg=.pdf) --export-latex;)

.PHONY: nuke
nuke:
	$(RM) *.bbl
	$(RM) *.blg
	$(RM) *.lof
	$(RM) *.lot
	$(RM) *.toc
	$(RM) *.out
	$(RM) *.log
	$(RM) *.aux
	$(RM) *.ind
	$(RM) *.ilg
	$(RM) *.glg
	$(RM) *.glo
	$(RM) *.gls
	$(RM) *.ist

.PHONY: clean
clean:
	$(RM) *.ps
	$(RM) *.dvi
	$(RM) *.pdf

.PHONY: unpic
unpic:
	$(RM) circuits/*.pic
	$(RM) circuits/*.tex

.PHONY: wipe
wipe:
	$(RM) graphics/*.pdf_tex
	$(RM) graphics/*.pdf
