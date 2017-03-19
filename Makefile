input=./opn/main/
output=./opn/out/tmp
lva-name= $(shell cat ./opn/conf/name)
lva-nr= $(shell cat ./opn/conf/nr)
lva-type= $(shell cat ./opn/conf/type)

SHELL:=/bin/bash

acess= opn cld
mode= exm hlp lab skp ue
type= bsp mdl mpc thr txt
sorting= chp date
opt = ang lsg hyb
everything=$(foreach acess,$(acess),$(foreach mode,$(mode),$(foreach type, $(type),$(foreach opt,$(opt),$(acess)-$(mode)-$(type)-$(opt)))))


all:	list $(everything)
list:
	$(foreach acess,$(acess),$(foreach mode,$(mode),$(foreach type,$(type),$(shell find ./$(acess)/$(mode)/$(type)/ -name *.tex| sort -t '/' -k6,6 -n -k7,7 -n| awk '{printf "\\input{%s}\n", $$1}' > ./tmp/$(acess)-$(mode)-$(type).tex))))
test:
	find $(foreach acess,$(acess),$(foreach mode,$(mode),$(foreach type,$(type),./$(acess)/$(mode)/$(type)/))) -name *.tex -mmin -60 | sort -t '/' -k6,6 -n -k7,7 -n | awk '{printf "\\input{%s}\n", $$1}' > ./tmp/test.tex;\
	latexmk -pdf -synctex=1 -interaction=errorstopmode -output-directory='${output}' '${input}/test.tex'\
	mv ${output}/*.pdf ./opn/out/

define PROGRAMM_temp =
$(1)-$(2)-$(3)-$(4): list
	if [ -a "./$(1)/main/$(2)/$(2)-$(3)-$(4).tex" ]; then printf "\\input{./tmp/$(1)-$(2)-$(3).tex}" > ./tmp/input.tex ; if [ $(1) == cld ]; then printf "\n\\input{./tmp/opn-$(2)-$(3).tex}" >> ./tmp/input.tex ; fi ; latexmk -f -pdf -synctex=1 -interaction=nonstopmode -output-directory='./tmp' './$(1)/main/$(2)/$(2)-$(3)-$(4).tex'; mv ./tmp/$(2)-$(3)-$(4).pdf ./$(1)/out/$(2)/$(3)/$(lva-type)-$(lva-nr)-$(lva-name)-$(2)-$(3)-$(4).pdf; fi;
	
endef

$(foreach acess,$(acess),$(foreach mode,$(mode),$(foreach type, $(type),$(foreach opt,$(opt),$(eval $(call PROGRAMM_temp,$(acess),$(mode),$(type),$(opt)))))))

clean:
	rm -f ./tmp/*.{tex,ps,pdf,fls,fdb,log,aux,out,dvi,bbl,blg,toc,synctex.gz}*
	


