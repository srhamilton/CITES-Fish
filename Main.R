#What is the relationship bewteen a species length and/or maximim depth, and whether or not they are listed under CITES?

#This script pulls all nessasary data from the Fish Base database using the library "rfishabse"

#"Working script.R" compares the mean length of all fish species to the mean length of CITES species(with and without genus "Hippocampus")

#"GLM test.r" uses Generalized Linear Models to find out if length and/or depth are explanatory variables for species having a CITES code

# Paths and creation of folders ----

# assign working directory to an object
wkdr <- getwd()

#list of folders we want
folders <- c("raw data", "scripts", "figures", "data output")

#create these folders if we dont have them already
for(i in 1:length(folders)){
  if(file.exists(folders[i]) == "FALSE") {
    dir.create(folders[i])
  }
}

# create paths to the new folders in the working directory
p.rawdata <- paste(wkdr, "/raw data/", sep = "")
p.dataoutput <- paste(wkdr, "/data output/", sep = "")
p.analysis <- paste(wkdr, "/analysis/", sep = "")
p.figures <- paste(wkdr, "/figures/", sep = "")





# Pulling data from the database-----

#### --- What fish species have a cites code? ---------
#pull the data for CITES codes of all species
CITES <- data.frame(stocks(fields = c("CITES_Code"), limit = 33710), stringsAsFactors = FALSE)

#remove all of the NAs only keeping the species that have a CITES code
cites.r <- CITES[ - which(is.na(CITES$CITES_Code)) , ]
str(cites.r)
#object with names of species that have CITES code
cites.sp <- cites.r$sciname

#### --- What data can the species function pull for all CITES species? -----
#Pulling all of the species data for CITES species
cites.all <- species(cites.sp)
str(cites.all)

#the species function seems to make collumns in data frames lists, so this unlists them
for(i in 1:length(ncol(cites.all))) {
  cites.all[ ,i+1] <- unlist(cites.all[ ,i+1])
}


#save cites.all as a csv file
write.csv(cites.all, file = paste(p.rawdata,  "/Cites.All.csv", sep = ""))

#### --- We are going to be investigating fish length so we can pull morphology data for all species----
#morphology of all species
morph.all <- data.frame(species(fields = species_fields$morph, limit = 40000), stringsAsFactors = FALSE)

str(morph.all)
tt <- unlist(morph.all$sciname)
str(tt)
length(tt)
morph.t <- cbind(tt, morph.all[, -1])

#unlisting them ----- COME BACK TO THIS   
for(i in 1:length(ncol(morph.all))) {
  morph.all[ ,i+1] <- unlist(morph.all[ ,i+1])
}
str(morph.all)
morph.all$sciname <- lapply(morph.all$sciname, as.character)
as.character(morph.all$sciname)

#####how to unlist the species names and make them become a character vector?
write.csv(morph.all, file = paste(p.rawdata,  "/morph.all.csv", sep = ""))



#### --- Pulling depth data for all species ----
all.depth <- data.frame(species(fields = species_fields$depth, limit = 40000), stringsAsFactors = FALSE)

# Creating data table n.t3 with CITES data, as well as Length and Max Depth----

#Out of the morphology data for all species I only want the Length, scientific names and species codes
d.t <- data.frame(cbind(morph.all$sciname, morph.all$Length, morph.all$SpecCode))
names(d.t) <- c("sciname", "Length", "SpecCode")

#I want to know the CITES codes for all species, and still want to keep track of the names and codes assiciated with them
d.t2 <- data.frame(cbind(CITES$sciname, CITES$CITES_Code, CITES$SpecCode))
names(d.t2) <- c("sciname", "Cites_Code", "SpecCode")

#create a new data frame with both length and CITES codes
d.t3 <- merge(d.t, d.t2)

#I want to know the max deptj of all species
n.t <- data.frame(cbind(all.depth$sciname, all.depth$SpecCode, all.depth$DepthRangeDeep))
names(n.t) <- c("sciname", "SpecCode", "MaxDepth")

#merge the lenght/CITES data frame with the depth infomation to have it all in one place 
n.t3 <- data.frame(merge(d.t3, n.t), stringsAsFactors = FALSE)

write.csv(n.t3, file = paste(p.rawdata,  "/LengthDepthCITES.csv", sep = ""))
