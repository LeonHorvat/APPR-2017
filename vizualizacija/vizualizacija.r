# 3. faza: Vizualizacija podatkov

#preliminarna vizualizacija

# pregled rasti turizma v Sloveniji skozi leta in pregled rasti potnikov v zracnem prometu v Sloveniji(Ljubljana in Maribor)
potniki_po_letih <- letaliski_promet %>% group_by(leto) %>% 
  summarise(stevilo_potnikov = sum(stevilo_potnikov)) %>%
  rbind(potniki_mb) %>% group_by(leto) %>%
  summarise(stevilo_potnikov = sum(stevilo_potnikov))

prihodi_po_letih <- prihodi_prenocitve %>% 
  filter(prihod_prenocitev == "Prihodi turistov - SKUPAJ") %>%
  group_by(leto) %>% summarise(prihodi = sum(stevilo))

potniki_in_prihodi <- inner_join(prihodi_po_letih, potniki_po_letih) %>%
  melt(id.vars="leto", variable.name = "meritev", value.name = 'stevilo')

g1 <- ggplot(potniki_in_prihodi, aes(x = leto, y = stevilo, group = meritev, colour = meritev)) + 
  geom_line() + theme_minimal()


# pregled izkoriščenosti letal  

g2 <- zracni_promet %>% filter(mednarodni != "Mednarodni prevoz - let po tujini") %>%
  group_by(leto) %>% 
  summarise(izkoriscenost = sum(potniki_1000*izkoriscenost)/sum(potniki_1000)) %>%
  ggplot(aes(x = leto, y = izkoriscenost)) +
  geom_line(size = 1.5, color = 'royalblue') + theme_minimal()

# pregled izkoriščenosti nastanitvenih kapacitet

prenocitve_po_letih <- prihodi_prenocitve %>% 
  filter(prihod_prenocitev == "Prenočitve turistov - SKUPAJ") %>%
  group_by(leto) %>% summarise(prenocitve = sum(stevilo))

zmogljivost_letno <- zmogljivosti %>% 
  filter(meritev == 'Zmogljivosti - ležišča - stalna') %>%
  group_by(leto) %>% summarise(stevilo = sum(stevilo)*365)

izkoriscenost <- inner_join(prenocitve_po_letih, zmogljivost_letno)
izkoriscenost["izkoriscenost"] <- NA
izkoriscenost$izkoriscenost <- izkoriscenost$prenocitve / izkoriscenost$stevilo
  
g3 <-  ggplot(izkoriscenost, aes(x = leto, y = izkoriscenost)) + 
  geom_line(size = 1.5, color = 'royalblue') + theme_minimal()
  




# Uvozimo zemljevid.
zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip",
                             "OB/OB", encoding = "Windows-1250")
levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
  { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels = levels(obcine$obcina))
zemljevid <- pretvori.zemljevid(zemljevid)

# Izračunamo povprečno velikost družine
povprecja <- druzine %>% group_by(obcina) %>%
  summarise(povprecje = sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))
