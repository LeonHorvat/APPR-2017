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
  melt(id.vars="leto")

g1 <- ggplot(potniki_in_prihodi, aes(x = leto, y = value, group = variable, colour = variable)) + 
  geom_line() + theme_minimal()

#


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
