install.packages("rfishbase", 
                 repos = c("http://packages.ropensci.org", "http://cran.rstudio.com"), 
                 type="source")
library(rfishbase)
?species
species(c("Labroides bicolor", "Bolbometopon muricatum"), fields = species_fields$habitat) 
?cites
??cites
head(species_fields)
table(species_fields$stocks)
?stocks
stocks(c("Labroides bicolor"), fields = c("CITES_Code"))
stocks("Labroides bicolor")
fecundity()
?list_fields
species_fields
StockDefs
length(stocks(fields = c("CITES_Code")))

unique(CITES$CITES_Code)
CITES <- stocks(fields = c("CITES_Code"), limit = 33710)

#works
CITES <- data.frame(stocks(fields = c("CITES_Code"), limit = 33710), stringsAsFactors = FALSE)

#ways of removing NAs
table(CITES$CITES_Code, exclude = NA) #works
CITES.t <- CITES[ CITES$CITES_Code != is.na(CITES$CITES_Code),]

which(CITES$CITES_Code == )
cites.r <- CITES[ - which(is.na(CITES$CITES_Code)) , ]

unique(CITES$CITES_Code)
which(is.na(CITES$CITES_Code))

CITES[CITES$CITES_Code == "Appendix II",]

cites.sp <- cites.r$sciname

species(cites.sp, fields = species_fields$habitat) 

