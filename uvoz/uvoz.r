#Uvoz podatkov LEON HORVAT


#tabela, ki prikazuje letališki promet

stolpci1 <- c("Leto", "Prihod_odhod", "Redni_posebni", "Država", "Število potnikov")
letaliski_promet1 <- read.csv2("podatki/Letaliski_potniski_promet_glede_na_prihod_odhod_letal,_po_drzavah,_LJP,_letno,_(do_Malte).csv",
                               na = "-",
                               header = FALSE)
colnames(letaliski_promet1) <- stolpci1

letaliski_promet2 <- read.csv2("podatki/Letaliski_potniski_promet_glede_na_prihod_odhod_letal,_po_drzavah,_LJP,_letno,_(od Maroka).csv",
                               na = "-",
                               header = FALSE)
colnames(letaliski_promet2) <- stolpci1

letaliski_promet1$Država <- as.character(letaliski_promet1$Država)
letaliski_promet2$Država <- as.character(letaliski_promet2$Država)

letaliski_promet <- rbind(letaliski_promet1, letaliski_promet2)
letaliski_promet <- letaliski_promet %>% filter(Prihod_odhod != "Prihod/odhod letal - SKUPAJ",
                            Redni_posebni != "Redni/posebni prevoz - SKUPAJ",
                            Država != "Države prihoda/odhoda letal - SKUPAJ")


#tabela s prenočitvenimi zmogljivostmi

stolpci2 <- c("obcina","objekt","leto","meritev", "stevilo")
zmogljivosti <- read.csv2("podatki/Prenocitvene_zmogljivosti1.csv",
                          na = c("-",""," ","..."),
                          header = FALSE,
                          skip = 1)
colnames(zmogljivosti) <- stolpci2
zmogljivosti <- zmogljivosti[-c(30303:30325), ] %>% 
                fill(1:3) %>%
                drop_na(stevilo)
                
zmogljivosti$stevilo <- parse_integer(zmogljivosti$stevilo)
                        

#tabela s prihodi in prenočitvami turistov posamezne države

stolpci3 <- c("skupaj", "obcina", "drzava", "leto", "prihod_prenocitev", "stevilo")
prihodi_prenocitve1 <- read.csv2("podatki/Prihodi_in_prenocitve1.csv",
                                 na = c("-", "z", " ", ""),
                                 header = FALSE,
                                 skip = 2)
colnames(prihodi_prenocitve1) <- stolpci3
prihodi_prenocitve2 <- read.csv2("podatki/Prihodi_in_prenocitve2.csv",
                                 na = c("-", "z", " ", ""),
                                 header = FALSE,
                                 skip = 2)
colnames(prihodi_prenocitve2) <- stolpci3
prihodi_prenocitve3 <- read.csv2("podatki/Prihodi_in_prenocitve3.csv",
                                 na = c("-", "z", " ", ""),
                                 header = FALSE,
                                 skip = 2)
colnames(prihodi_prenocitve3) <- stolpci3
prihodi_prenocitve <- rbind(prihodi_prenocitve1,prihodi_prenocitve2,prihodi_prenocitve3)

prihodi_prenocitve$skupaj <- NULL

prihodi_prenocitve <- prihodi_prenocitve %>%
                    fill(1:3) %>%
                    drop_na(stevilo)


#tabela o zracnem prometu

stolpci4 <- c("leto", "redni_posebni", "mednarodni", "potniki_1000", "izkoriscenost")
zracni_promet <- read.csv2("podatki/Zracni_potniski_promet_in_izkoriscenost_letal.csv",
                           header = FALSE,
                           col.names = stolpci4)

zracni_promet <- zracni_promet %>% filter(redni_posebni != "Redni/posebni prevoz - SKUPAJ",
                                          mednarodni != "Mednarodni prevoz - SKUPAJ")


#tabela o potnikih letalisca maribor

link <- "https://sl.wikipedia.org/wiki/Letali%C5%A1%C4%8De_Edvarda_Rusjana_Maribor"
stran <- html_session(link) %>% read_html()
potniki_mb <- stran %>% html_nodes(xpath="//table[@class='wikitable']") %>%.[[2]]%>% html_table()

names(potniki_mb) <- c("leto", "stevilo_potnikov", "rast")

potniki_mb$"stevilo_potnikov" <- gsub(",","",potniki_mb$"stevilo_potnikov") %>% parse_integer()



