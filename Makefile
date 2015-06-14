TEXDIR=~/texmf
LATEX=${TEXDIR}/tex/latex
DOCS=${TEXDIR}/doc


class:
	latex "\PassOptionsToClass{produce}{codedoc} \input{photobook.tex}"

doc:
	latexmk -pdf photobook.tex


install: class doc
	@echo "Installing files locally (in your home folder)"
	mkdir -p ${LATEX}
	cp photobook.cls ${LATEX}
	mkdir -p ${DOCS}
	cp photobook.pdf ${DOCS}

clean:
	latexmk -C
