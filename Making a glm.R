#cites success, non cites failure, can length explain the listing?

d.t <- data.frame(cbind(morph.all$sciname, morph.all$Length, morph.all$SpecCode))
names(d.t) <- c("sciname", "Length", "SpecCode")
d.t2 <- data.frame(cbind(CITES$sciname, CITES$CITES_Code, CITES$SpecCode))
names(d.t2) <- c("sciname", "Cites_Code", "SpecCode")
d.t3 <- merge(d.t, d.t2)

#changing Cites_Code into a binary responce 
for(i in 1:length(d.t3$Cites_Code)) { 
  if (is.na(d.t3$Cites_Code[i])) {
    d.t3$Cites_Code[i] <- 0
   } else
    d.t3$Cites_Code[i] <- 1
}

#unlisting collumns to make them easier to work with 
d.t3$Cites_Code <- unlist(d.t3$Cites_Code)
d.t3$Length <- unlist(d.t3$Length)
d.t3$SpecCode <- unlist(d.t3$SpecCode)
str(d.t3)

#removing collumns that don't ahve a value for length
d.t3 <- d.t3[ - which(is.na(d.t3$Length)),]

plot(d.t3$Length, d.t3$Cites_Code)

#making a glm

glm0 <- glm(Cites_Code ~ Length, data = d.t3, family = binomial)
summary(glm0)
plot(glm0)

length.range.for.predict <- seq(min(d.t3$Length), max(d.t3$Length), 0.1)
pred.response <- predict(glm0, list(Length = length.range.for.predict), type = "response")
lines(length.range.for.predict, pred.response, col = "red", lwd = 1)

glm0$deviance / glm0$df.residual

#Trying out getting rid of a potential outlier
#removing the max length value
d.t4 <- d.t3[ - which(d.t3$Length == (max(d.t3$Length))), ]

max(d.t4$Length)

glm1 <- glm(Cites_Code ~ Length, data = d.t4, family = binomial)
summary(glm1)
plot(glm1)

glm1$deviance / glm1$df.residual

#reploting without the max 
plot(d.t4$Length, d.t4$Cites_Code)
length.range.for.predict <- seq(min(d.t4$Length), max(d.t4$Length), 0.1)
pred.response <- predict(glm1, list(Length = length.range.for.predict), type = "response")
lines(length.range.for.predict, pred.response, col = "red", lwd = 1)

 

