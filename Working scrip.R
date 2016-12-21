
#visualizing the frequencies of fish lengths for all species and CITES code species 
hist(morph.all$Length)
hist(cites.all$Length)

#transforming the distributions to become more normal 
hist(log10(morph.all$Length)) #this one is normal
hist(log10(cites.all$Length), breaks = 30) #this one is bimodal 

#running a non parametric test because the CITES data is non normal
d.c <- cites.all[ - which(is.na(cites.all$Length)),]
d.a <- morph.all[ - which(is.na(morph.all$Length)),]

kstest <- ks.test(d.c$Length, d.a$Length) 
#< 2.2e-16 

######Investigating why there might be this non normal distrubution ------
#if the data is split completely in half it forms two mostly normal distributions 
hist(c.length.trans[c.length.trans < 1.85], breaks =10)
hist(c.length.trans[c.length.trans > 1.85], breaks =10)
#it looks like there are two populations in CITES sample
#one lines up with the population, one is larger 

##### Running t tests on each half of the CITES data -----

#saving the transformed mean of population to compare to
trans.mean.all <- mean(log10(morph.all$Length), na.rm = TRUE)
#storing the log transformed cites length data
c.length.trans <- log10(cites.all$Length)

#t test on all transformed cites length data and population length
t.test(c.length.trans, mu = trans.mean.all)
#t test on all transformed cites length data and population length
t.test(c.length.trans[c.length.trans < 1.85], mu = trans.mean.all) #not signifigant
#t test on all transformed cites length data and population length
t.test(c.length.trans[c.length.trans > 1.85], mu = trans.mean.all) #signifigantly different

##### Investigating what makes up each half of the data

#Storing each half of the data in objects
cites.sig.all <- cites.all[ which(log10(cites.all$Length) > 1.85), ]
cites.nsig.all <- cites.all[ which(log10(cites.all$Length) < 1.85), ]

#looking at what genus are in each data half
table(cites.sig.all$Genus)
unique(cites.sig.all$Genus)

table(cites.nsig.all$Genus)
unique(cites.nsig.all$Genus)

#hippocampus makes up a large portion of one of the data halves
#removing hippocampus to be able to more easily investigate all other species 
h <- cites.all[- grep("Hippocampus", cites.all$Genus),]

hist(log10(h$Length), breaks = 30)

t.test((log10(h$Length)), mu = trans.mean.all) 
# p < 2.2e-16

#### Save pdfs of main histograms 
pdf(paste(p.figures, "HistWithHippo.pdf", sep = ""))
hist(log10(cites.all$Length), breaks = 30, main = "", xlab = "Length (log 10, cm)", ylab = "Frequency")
dev.off()

pdf(paste(p.figures, "HistWithoutHippo.pdf", sep = ""))
hist(log10(h$Length), breaks = 30, main = "", xlab = "Length (log 10, cm)", ylab = "Frequency")
dev.off()
hist(log10(morph.all$Length))

pdf(paste(p.figures, "HistAllSp.pdf", sep = ""))
hist(log10(morph.all$Length), breaks = 30, main = "", xlab = "Length (log 10, cm)", ylab = "Frequency")
dev.off()
