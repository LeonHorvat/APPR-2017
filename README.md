# Analiza turizma v Sloveniji

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2016/17

## Tematika

Analiziral bom turizem v Sloveniji. Osredotočil se bom na prihode in prenočitve domačih in tujih turistov po posameznih občinah in po skupinah nastanitvenih objektov od leta 2008 do 2015. Te podatke bom primerjal s prenočitvenimi zmogljivostmi turističnih objektov v občinah. Pregledal bom tudi vire informacij, na podlagi katerih so se tuji gosti odločili za prihod v Slovenijo. Primerjal bom tudi podatke letališkega potniškega prometa, prihode in odhode letal iz tujine, njihovo izkoriščenost in si ogledal, koliko turistov pride v Slovenijo z letalom.

Podatki:

* http://pxweb.stat.si/pxweb/Database/Ekonomsko/21_gostinstvo_turizem/02_21645_nastanitev_letno/02_21645_nastanitev_letno.asp
* http://pxweb.stat.si/pxweb/Database/Ekonomsko/21_gostinstvo_turizem/10_tuji_turisti/10_21765_tuji_znac_prihoda_obc/10_21765_tuji_znac_prihoda_obc.asp
* http://pxweb.stat.si/pxweb/Database/Ekonomsko/22_transport/05_22219_zracni_transport/05_22219_zracni_transport.asp
* https://sl.wikipedia.org/wiki/Letali%C5%A1%C4%8De_Edvarda_Rusjana_Maribor

Podatki so v obliki CSV in HTML

Zasnova podatkovnega modela:

Prva tabela bo vsebovala prihode in prenočitve po vrsti občine, občinah, po državi izvora turista, letno. Naslednja bo imela podatke o prenočitevnih zmogljivosti. Tretja bo vsebovala prihode in prenočitve po skupinah nastanitvenih objektov, četrta pa še o strukturi informacij, ki so vplivale na prihod turistov v Slovenijo.
V naslednjem sklopu tabel pa bom pogledal zračni potniški promet. V eni tabeli bodo predstavljeni prihodi in odhodi letal po državah na letališču Jožeta Pučnika Ljubljana, v drugi pa izkoriščenost letal, oboje po letih. Dodal bom še tabelo števila potnikov na letališču Edvarda Rusjana Maribor skozi leta.

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`. Ko ga prevedemo,
se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`. Podatkovni
viri so v mapi `podatki/`. Zemljevidi v obliki SHP, ki jih program pobere, se
shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `maptools` - za uvoz zemljevidov
* `sp` - za delo z zemljevidi
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `reshape2` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)
