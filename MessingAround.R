#initial set up------
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
species("Labroides bicolor")
fecundity()
?list_fields
species_fields
StockDefs
length(stocks(fields = c("CITES_Code")))

unique(CITES$CITES_Code)

#getting CITES data ------
CITES <- data.frame(stocks(fields = c("CITES_Code"), limit = 33710), stringsAsFactors = FALSE)


#ways of removing NAs
table(CITES$CITES_Code, exclude = NA) #works
CITES.t <- CITES[ CITES$CITES_Code != is.na(CITES$CITES_Code),]

#way of removing NAs that works with this data
which(CITES$CITES_Code == )
cites.r <- CITES[ - which(is.na(CITES$CITES_Code)) , ]

unique(CITES$CITES_Code)
which(is.na(CITES$CITES_Code))

CITES[CITES$CITES_Code == "Appendix II",]

#object of CITES species
cites.sp <- cites.r$sciname

#habitat of cites species 
c.habitat <- species(cites.sp, fields = species_fields$habitat) 

#isolating the speices with a certian characteristic 
c.habitat[c.habitat$AnaCat == "non-migratory",]
which(c.habitat$AnaCa == "non-migratory")

hab.non.mig <- c.habitat[(which(c.habitat$AnaCa == "non-migratory")), ]
length(which(c.habitat$AnaCa == "non-migratory"))

#displaying totals the easy way
table(c.habitat$AnaCat)

#morphology of species, length has all, weight isnt bad
cites.morph <- species(cites.sp, fields = species_fields$morph) 


length.mean.cites <- mean(cites.morph$Length, na.rm = TRUE)

morph.all <- species(fields = species_fields$morph, limit = 40000) #this one for now
morph.all <- species(fields = species_fields$morph, query = morph_feilds$Length, limit = 40000)
?species

#######ask Thor about normal distribution of the sample
hist(morph.all$Length)
hist(log10(morph.all$Length))

c.length.trans <- log10(cites.morph$Length)


d.c <- cites.all[ - which(is.na(cites.all$Length)),]
d.a <- morph.all[ - which(is.na(morph.all$Length)),]

hist(log10(cites.morph$Length), breaks = 30)
hist((cites.morph$Length), breaks = 30)

#non parametric Kolmogorov-Smirnov Test becsue not a normal dsitribution 
ks.test(d.c$Length, d.a$Length)

str(morph.all)
str(cites.morph)
?wilcox.test
?complete.cases

#if the data is split completely in half 
hist(c.length.trans[c.length.trans < 1.85], breaks =10)
hist(c.length.trans[c.length.trans > 1.85], breaks =10)
#it looks like there are two populations in CITES sample
#one lines up with the population, one is larger 


#transformed mean of population
trans.mean.all <- mean(log10(morph.all$Length), na.rm = TRUE)

t.test(log10(cites.morph$Length), mu = trans.mean.all)
t.test(c.length.trans[c.length.trans < 1.85], mu = trans.mean.all) #not signifigant
t.test(c.length.trans[c.length.trans > 1.85], mu = trans.mean.all) #signifigantly different

#find the specific species part of the second distribution 
####how does the length of each >,< statment not add up to the legth of the whole thing????
length(c.length.trans)
length(c.length.trans[c.length.trans > 1.85])
length(c.length.trans[c.length.trans < 1.85])

cites.sig <- cites.morph[ which(log10(cites.morph$Length) > 1.85), ]

cites.depth <- species(cites.$sciname, fields = species_fields$depth)

cites.fishing <- species(cites.sig$sciname, fields = species_fields$fishing)

cites.sig.all <- cites.all[ which(log10(cites.morph$Length) > 1.85), ]
cites.nsig.all <- cites.all[ which(log10(cites.morph$Length) < 1.85), ]

table(cites.sig.all$Genus)
unique(cites.sig.all$Genus)

table(cites.nsig.all$Genus)
unique(cites.nsig.all$Genus)





#kicking hippocampus out
h <- cites.all[- grep("Hippocampus", cites.all$Genus),]

hist(log10(h$Length), breaks = 30)

t.test((log10(h$Length)), mu = trans.mean.all)

ah.ex <- h[ - grep("Acipenser", h$Genus), ]

hist(ah.ex$Length, breaks = 20)
hist(log10(ah.ex$Length), breaks = 20)











#other bits------
length.mean.all <- mean(morph.all$Length, na.rm = TRUE)
length(morph.all$Length)

#number of CITES species with length values
length(cites.morph$Length[which(cites.morph$Length != "NA")])
length(morph.all$Length[which(morph.all$Length != "NA")])






#begingin of loop to compare all cites species and see what variable has the highest number,
#therefo the most in common....
#this probably wont work because there is such a mix of characters and numbers
#could add an if character, print unique, if num take mean?

cites.all <- species(cites.sp)
x <- rep(NA, length(cites.sp))

for(i in 1:ncol(cites.all)) {
 i <- 2
 x <- unique(cites.all$i)
}

rm(list = ls...)

