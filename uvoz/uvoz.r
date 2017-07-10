#Uvoz podatkov LEON HORVAT


#tabela, ki prikazuje letališki promet

stolpci1 <- c("leto", "prihod_odhod", "redni_posebni", "drzava", "stevilo_potnikov")
letaliski_promet1 <- read_csv2("podatki/Letaliski_potniski_promet_glede_na_prihod_odhod_letal,_po_drzavah,_LJP,_letno,_(do_Malte).csv",
                               na = "-",
                               col_names = stolpci1,
                               locale = locale(encoding = "Windows-1250"))

letaliski_promet2 <- read_csv2("podatki/Letaliski_potniski_promet_glede_na_prihod_odhod_letal,_po_drzavah,_LJP,_letno,_(od Maroka).csv",
                               na = "-",
                               col_names = stolpci1,
                               locale = locale(encoding = "Windows-1250"))

letaliski_promet <- rbind(letaliski_promet1, letaliski_promet2)
letaliski_promet <- letaliski_promet %>% filter(prihod_odhod != "Prihod/odhod letal - SKUPAJ",
                            redni_posebni != "Redni/posebni prevoz - SKUPAJ",
                            drzava != "Države prihoda/odhoda letal - SKUPAJ") %>%
                            drop_na(stevilo_potnikov)


#tabela s prenočitvenimi zmogljivostmi

stolpci2 <- c("obcina","objekt","leto","meritev", "stevilo")
zmogljivosti <- read_csv2("podatki/Prenocitvene_zmogljivosti1.csv",
                          na = c("-",""," ","..."),
                          col_names = stolpci2,
                          skip = 1,
                          locale = locale(encoding = "Windows-1250"))

zmogljivosti <- zmogljivosti[-c(30303:30325), ] %>% 
                fill(1:3) %>%
                drop_na(meritev)
zmogljivosti[is.na(zmogljivosti)] <- 0
                        

#tabela s prihodi in prenočitvami turistov posamezne države

stolpci3 <- c("skupaj", "obcina", "drzava", "leto", "prihod_prenocitev", "stevilo")
prihodi_prenocitve1 <- read_csv2("podatki/Prihodi_in_prenocitve1.csv",
                                 na = c("-", "z", " ", ""),
                                 col_names = stolpci3,
                                 skip = 2,
                                 locale = locale(encoding = "Windows-1250"))

prihodi_prenocitve2 <- read_csv2("podatki/Prihodi_in_prenocitve2.csv",
                                 na = c("-", "z", " ", ""),
                                 col_names = stolpci3,
                                 skip = 2,
                                 locale = locale(encoding = "Windows-1250"))

prihodi_prenocitve3 <- read_csv2("podatki/Prihodi_in_prenocitve3.csv",
                                 na = c("-", "z", " ", ""),
                                 col_names = stolpci3,
                                 skip = 2,
                                 locale = locale(encoding = "Windows-1250"))

prihodi_prenocitve <- rbind(prihodi_prenocitve1,prihodi_prenocitve2,prihodi_prenocitve3)

prihodi_prenocitve$skupaj <- NULL
prihodi_prenocitve$stevilo[is.na(prihodi_prenocitve$stevilo)] <- 0

prihodi_prenocitve <- prihodi_prenocitve %>%
                    fill(1:3) %>%
                    drop_na(prihod_prenocitev) %>% filter(!(obcina %in% c('LJUBLJANA', 'SLOVENIJA')))


#tabela o zracnem prometu

stolpci4 <- c("leto", "redni_posebni", "mednarodni", "potniki", "izkoriscenost")
zracni_promet <- read_csv2("podatki/Zracni_potniski_promet_in_izkoriscenost_letal.csv",
                           col_names = stolpci4,
                           locale = locale(encoding = "Windows-1250"))

zracni_promet <- zracni_promet %>% filter(redni_posebni != "Redni/posebni prevoz - SKUPAJ",
                                          mednarodni != "Mednarodni prevoz - SKUPAJ")
zracni_promet$izkoriscenost <- zracni_promet$izkoriscenost / 1000

#tabela o potnikih letalisca maribor

link <- "https://sl.wikipedia.org/wiki/Letali%C5%A1%C4%8De_Edvarda_Rusjana_Maribor"
stran <- html_session(link) %>% read_html()
potniki_mb <- stran %>% html_nodes(xpath="//table[@class='wikitable']") %>%.[[2]]%>% html_table()

names(potniki_mb) <- c("leto", "stevilo_potnikov", "rast")

potniki_mb$"stevilo_potnikov" <- gsub(",","",potniki_mb$"stevilo_potnikov") %>% parse_integer()

potniki_mb$"rast" <- NULL

