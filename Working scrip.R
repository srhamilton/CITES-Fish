
#pull the data for CITES codes
CITES <- data.frame(stocks(fields = c("CITES_Code"), limit = 33710), stringsAsFactors = FALSE)

#remove all of the NAs only keeping the species that have a CITES code
cites.r <- CITES[ - which(is.na(CITES$CITES_Code)) , ]
str(cites.r)
#object with names of species that have CITES code
cites.sp <- cites.r$sciname

#morphology of species, length has all, weight isnt bad
cites.morph <- species(cites.sp, fields = species_fields$morph) 

morph.all <- species(fields = species_fields$morph, limit = 40000)

