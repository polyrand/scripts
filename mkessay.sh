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
title: Lorem ipsum dolor sit amet, consectetur adipiscing elit
author:
    - Ricardo Ander-Egg
    - "NIUB: 17138844"
abstract: |

    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam sollicitudin augue nec ligula congue, et semper nulla volutpat. Sed erat nulla, consequat sit amet molestie sit amet, dictum eu purus. Morbi sit amet fringilla magna, sed euismod lorem. Sed elementum orci quis pellentesque facilisis. In mollis, justo a lobortis luctus, ipsum mauris consectetur diam, in vehicula sem neque ac nunc. Mauris viverra lacinia lectus, non blandit nisi ultrices in. Vivamus vehicula velit at fringilla dapibus. In at augue nibh. Ut dui sapien, viverra sed felis vitae, feugiat finibus dolor. In sapien sapien, convallis semper venenatis quis, tincidunt ac magna. Cras condimentum egestas accumsan. Suspendisse eros nisi, cursus eget tellus sit amet, condimentum iaculis nisl.

---

\newpage





## Fuentes

::: {#refs}
:::

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
