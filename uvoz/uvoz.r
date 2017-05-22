# 2. faza: Uvoz podatkov

# Funkcija, ki uvozi občine iz Wikipedije
#uvozi.obcine <- function() {
#  link <- "http://sl.wikipedia.org/wiki/Seznam_ob%C4%8Din_v_Sloveniji"
#  stran <- html_session(link) %>% read_html()
#  tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
#    .[[1]] %>% html_table(dec = ",")
#  colnames(tabela) <- c("obcina", "povrsina", "prebivalci", "gostota", "naselja",
#                        "ustanovitev", "pokrajina", "regija", "odcepitev")
#  tabela$obcina <- gsub("Slovenskih", "Slov.", tabela$obcina)
#  tabela$obcina[tabela$obcina == "Kanal ob Soči"] <- "Kanal"
#  tabela$obcina[tabela$obcina == "Loški potok"] <- "Loški Potok"
#  for (col in colnames(tabela)) {
#   tabela[tabela[[col]] == "-", col] <- NA
#  }
#  for (col in c("povrsina", "prebivalci", "gostota", "naselja", "ustanovitev")) {
#    if (is.numeric(tabela[[col]])) {
#      next()
#    }
#    tabela[[col]] <- gsub("[.*]", "", tabela[[col]]) %>% as.numeric()
#  }
#  for (col in c("obcina", "pokrajina", "regija")) {
#    tabela[[col]] <- factor(tabela[[col]])
#  }
#  return(tabela)
#}

# Funkcija, ki uvozi podatke iz datoteke druzine.csv
#uvozi.druzine <- function(obcine) {
#  data <- read_csv2("podatki/druzine.csv", col_names = c("obcina", 1:4),
#                    locale = locale(encoding = "Windows-1250"))
#  data$obcina <- data$obcina %>% strapplyc("^([^/]*)") %>% unlist() %>%
#    strapplyc("([^ ]+)") %>% sapply(paste, collapse = " ") %>% unlist()
#  data$obcina[data$obcina == "Sveti Jurij"] <- "Sveti Jurij ob Ščavnici"
#  data <- data %>% melt(id.vars = "obcina", variable.name = "velikost.druzine",
#                        value.name = "stevilo.druzin")
#  data$velikost.druzine <- as.numeric(data$velikost.druzine)
#  data$obcina <- factor(data$obcina, levels = obcine)
#  return(data)
#}

# Zapišimo podatke v razpredelnico obcine
#obcine <- uvozi.obcine()

# Zapišimo podatke v razpredelnico druzine.
#druzine <- uvozi.druzine(levels(obcine$obcina))

# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.

#Uvoz podatkov LEON HORVAT
require(readr)
library(readr)
library(dplyr)


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
                          skip = 1,
                          col.names = stolpci2)
zmogljivosti <- zmogljivosti[-c(30303:30325), ] %>% 
                fill(1:3) %>%
                drop_na(stevilo)
                
zmogljivosti$stevilo <- parse_integer(zmogljivosti$stevilo)
                        

#tabela s prihodi in prenočitvami turistov posamezne države

stolpci3 <- c("skupaj", "obcina", "drzava", "leto", "prihod-prenocitev", "stevilo")
prihodi_prenocitve1 <- read.csv2("podatki/Prihodi_in_prenocitve1.csv",
                                 na = c("-", "z", " ", ""),
                                 col.names = stolpci3,
                                 skip = 1)
prihodi_prenocitve2 <- read.csv2("podatki/Prihodi_in_prenocitve2.csv",
                                 na = c("-", "z", " ", ""),
                                 col.names = stolpci3,
                                 skip = 1)
prihodi_prenocitve3 <- read.csv2("podatki/Prihodi_in_prenocitve3.csv",
                                 na = c("-", "z", " ", ""),
                                 col.names = stolpci3,
                                 skip = 1)
prihodi_prenocitve <- rbind(prihodi_prenocitve1,prihodi_prenocitve2,prihodi_prenocitve3)

prihodi_prenocitve$skupaj <- NULL

prihodi_prenocitve <- prihodi_prenocitve %>%
                    fill(1:3) %>%
                    drop_na(stevilo)


#tabela o zracnem prometu

stolpci4 <- c("leto", "redni-posebni", "mednarodni", "potniki(1000)", "izkoriscenost(%)")
zracni_promet <- read.csv2("podatki/Zracni_potniski_promet_in_izkoriscenost_letal.csv",
                           header = FALSE,
                           col.names = stolpci4)








