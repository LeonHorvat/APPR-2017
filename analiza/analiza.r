# 4. faza: Analiza podatkov

#menjava imen občin še v tabeli zmogljivosti
zmogljivosti_obcine <- filter(zmogljivosti, !(obcina %in% c('ZDRAVILIŠKE OBČINE', 'GORSKE OBČINE', 'DRUGE OBČINE', 'OBMORSKE OBČINE', 'MESTNE OBČINE', 'LJUBLJANA')))

imena_obcin1 <- unique(zmogljivosti_obcine$obcina) %>% sort()

imena_obcin2 <- levels(zemljevid_slo$OB_UIME)

razlicni <- imena_obcin2 != imena_obcin1
primerjava <- data.frame(imena_obcin1, imena_obcin2, stringsAsFactors = FALSE)[razlicni, ]
row.names(primerjava) <- NULL
for (i in 1:nrow(primerjava)){
  zmogljivosti_obcine$obcina[zmogljivosti_obcine$obcina == primerjava$imena_obcin1[i]] <- primerjava$imena_obcin2[i]
}
zmogljivosti_obcine$obcina <- factor(zmogljivosti_obcine$obcina, levels = imena_obcin2)

#razvrščanje
grupiranje1 <- prihodi_obcine %>% 
  filter(prihod_prenocitev == 'Prihodi turistov - SKUPAJ',leto == 2016) %>%
  dcast(obcina ~ drzava)
                                           
grupiranje2 <- zmogljivosti_obcine %>% 
  filter(leto == 2016, meritev == 'Zmogljivosti - ležišča - SKUPAJ') %>%
  dcast(obcina ~ objekt)
grupiranje2[is.na(grupiranje2)] <- 0

grupiranje <- inner_join(grupiranje1, grupiranje2) 
obcine <- grupiranje$obcina
grupiranje <- grupiranje %>% 
  select(-obcina) %>% scale()
rownames(grupiranje) <- obcine

k <- kmeans(grupiranje, 4, nstart = 1000)

skupine <- data.frame(GEO = obcine, skupina = factor(k$cluster))

z3 <- ggplot() + geom_polygon(data = zemljevid_slo %>% left_join(skupine, by = c("OB_UIME" = "GEO")),
                             aes(x = long, y = lat, group = group, fill = skupina))





