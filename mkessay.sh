#!/usr/bin/env bash

make_cmd="#!/usr/bin/env bash

pandoc --filter pandoc-citeproc trabajo.md format.yaml --pdf-engine=xelatex -o final.pdf"

format="---
geometry: margin=2.5cm
fontsize: 12pt
documentclass: article
link-citations: true
csl: vancouver.csl
bibliography: references.bib
header-includes:
    - \usepackage{setspace}
    - \onehalfspacing
    - \newcommand\qed{\hfill\rule{1em}{1em}}
---"

header="
---
title: Tratamiento multidisciplinar del cáncer de cuello uterino
author:
    - Ricardo Ander-Egg
abstract: |

    En los estadíos IB-1/2 el tratamiento es cirugía radical, para los estdíos
    IB3 en adelante el tratamiento es quimioterapia, junto con radioterapia
    externa y braquiterapia.

---

\newpage
"

touch references.bib

echo "$format" >> format.yaml
echo "$make_cmd" >> make.sh
echo "$header" >> trabajo.md

if [[ $1 == 'apa' ]]; then
    wget https://raw.githubusercontent.com/citation-style-language/styles/master/apa.csl
elif [[ $1 == 'nejm' ]]; then
    wget https://github.com/citation-style-language/styles/blob/master/the-new-england-journal-of-medicine.csl
else
    wget https://raw.githubusercontent.com/citation-style-language/styles/master/vancouver.csl
fi
