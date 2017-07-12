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

g1 <- ggplot(potniki_in_prihodi, aes(x = leto, y = stevilo/1e6, group = meritev, colour = meritev)) + 
  geom_line(size = 1.5) + theme_minimal() + xlab("Leto") + ylab("Milijoni") +
  scale_colour_discrete(name="Meritev",
                     breaks=c("prihodi", "stevilo_potnikov"),
                     labels=c("Prihodi turistov", "Letalski potniki"))
  


# pregled izkoriščenosti letal  

g2 <- zracni_promet %>% filter(mednarodni != "Mednarodni prevoz - let po tujini") %>%
  group_by(leto) %>% 
  summarise(izkoriscenost = sum(potniki*izkoriscenost)/sum(potniki)) %>%
  ggplot(aes(x = leto, y = izkoriscenost)) + xlab("Leto") + ylab("Izkoriščenost") +
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
  xlab("Leto") + ylab("Izkoriščenost") +
  geom_line(size = 1.5, color = 'royalblue') + theme_minimal()
  





# Uvozimo zemljevid 
zemljevid_slo <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip",
                             "OB/OB", encoding = "Windows-1250")
zemljevid_slo <- pretvori.zemljevid(zemljevid_slo)

# tabela prihodov in prenočitev z enakimi imeni občin kot v zemljevidu
prihodi_obcine <- filter(prihodi_prenocitve, !(obcina %in% c('ZDRAVILIŠKE OBČINE', 'GORSKE OBČINE', 'DRUGE OBČINE', 'OBMORSKE OBČINE', 'MESTNE OBČINE', 'LJUBLJANA')))

imena_obcin1 <- unique(prihodi_obcine$obcina) %>% sort()
  
imena_obcin2 <- levels(zemljevid_slo$OB_UIME)

razlicni <- imena_obcin2 != imena_obcin1
primerjava <- data.frame(imena_obcin1, imena_obcin2, stringsAsFactors = FALSE)[razlicni, ]
row.names(primerjava) <- NULL
for (i in 1:nrow(primerjava)){
  prihodi_obcine$obcina[prihodi_obcine$obcina == primerjava$imena_obcin1[i]] <- primerjava$imena_obcin2[i]
}
prihodi_obcine$obcina <- factor(prihodi_obcine$obcina, levels = imena_obcin2)

# zemljevid Slovenije pobarvan glede na število prenočitev v občini leta 2016
prenocitve_obcine_2016 <- prihodi_obcine %>% 
  filter(leto == 2016, prihod_prenocitev == 'Prenočitve turistov - SKUPAJ') %>%
  group_by(obcina) %>% summarise(stevilo = log(sum(stevilo), 1.00005))

z1 <- ggplot() + geom_polygon(data = inner_join(zemljevid_slo, prenocitve_obcine_2016, by = c("OB_UIME"='obcina')),
                              aes(x = long, y = lat, group = group, fill = stevilo)) + 
      scale_fill_continuous(name="Logaritmirano število prenočitev")


# zemljevid Slovenije pobarvan glede na povprečno število prenočitev turista v občini leta 2016
nocitve_obcine_2016 <- prihodi_obcine %>% filter(leto == 2016) %>%
  dcast(obcina ~ prihod_prenocitev, sum)
nocitve_obcine_2016['nocitve'] <- NA
nocitve_obcine_2016$nocitve <- nocitve_obcine_2016$'Prenočitve turistov - SKUPAJ' / nocitve_obcine_2016$'Prihodi turistov - SKUPAJ' 

z2 <- ggplot() + geom_polygon(data = inner_join(zemljevid_slo, nocitve_obcine_2016, by = c("OB_UIME"='obcina')),
                              aes(x = long, y = lat, group = group, fill = nocitve)) + 
      scale_fill_continuous(name="Nočitve")


# primerjava števila turistov iz posamezne države in števila letalskih potnikov
drzave_turist <- prihodi_prenocitve %>% 
  filter(leto == 2015, prihod_prenocitev == 'Prihodi turistov - SKUPAJ', drzava != 'DOMAČI', drzava != 'TUJI') %>%
  group_by(drzava) %>% summarise(stevilo_turistov = sum(stevilo))

drzave_letala <- letaliski_promet %>% 
  filter(leto == 2015, prihod_odhod == 'Prihod letal') %>% 
  group_by(drzava) %>% summarise(stevilo_potnikov = sum(stevilo_potnikov))

drzave_primerjava <- inner_join(drzave_turist, drzave_letala)
drzave_primerjava["razlika"] <- NA
drzave_primerjava$razlika <- drzave_primerjava$stevilo_turistov - drzave_primerjava$stevilo_potnikov

order.razlika <- order(drzave_primerjava$razlika, decreasing = TRUE)
drzave_primerjava <- drzave_primerjava[order.razlika, ]

g4 <- ggplot(drzave_primerjava, aes(x=drzava, y=razlika)) + 
  xlab('Država') + ylab('Razlika') + 
  geom_col(aes(fill = stevilo_potnikov)) + 
  scale_x_discrete(limits= drzave_primerjava$drzava) +
  theme(axis.text.x = element_text(angle = 90, size = 7), axis.title.x = element_blank()) + 
  scale_fill_continuous(name="Število letalskih potnikov")
  
  
  
  
  

