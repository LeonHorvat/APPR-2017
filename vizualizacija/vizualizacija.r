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
  geom_line(size = 1.5) + theme_minimal()


# pregled izkoriščenosti letal  

g2 <- zracni_promet %>% filter(mednarodni != "Mednarodni prevoz - let po tujini") %>%
  group_by(leto) %>% 
  summarise(izkoriscenost = sum(potniki*izkoriscenost)/sum(potniki)) %>%
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
  





# Uvozimo zemljevid 
zemljevid_slo <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip",
                             "OB/OB", encoding = "Windows-1250")
zemljevid_slo <- pretvori.zemljevid(zemljevid_slo)

# tabela prihodov in prenočitev z enakimi imeni občin kot v zemljevidu
prihodi_obcine <- filter(prihodi_prenocitve, !(obcina %in% c('ZDRAVILIŠKE OBČINE', 'GORSKE OBČINE', 'DRUGE OBČINE', 'OBMORSKE OBČINE', 'MESTNE OBČINE')))

imena_obcin1 <- unique(prihodi_obcine$obcina) %>% sort()
  
imena_obcin2 <- levels(zemljevid_slo$OB_UIME)

razlicni <- imena_obcin2 != imena_obcin1
primerjava <- data.frame(imena_obcin1, imena_obcin2, stringsAsFactors = FALSE)[razlicni, ]
row.names(primerjava) <- NULL
for (i in 1:nrow(primerjava)){
  prihodi_obcine$obcina[prihodi_obcine$obcina == primerjava$imena_obcin1[i]] <- primerjava$imena_obcin2[i]
}
prihodi_obcine$obcina <- factor(prihodi_obcine$obcina, levels = imena_obcin2)












