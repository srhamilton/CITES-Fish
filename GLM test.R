#creating glms to see if length, depth, or a combination of these can be used to 
#predict if a species has a CITES code or not

#changing Cites_Code into a binary responce 
for(i in 1:length(n.t3$Cites_Code)) { 
  if (is.na(n.t3$Cites_Code[i])) {
    n.t3$Cites_Code[i] <- 0
  } else
    n.t3$Cites_Code[i] <- 1
}

#unlisting collumns to make them easier to work with 
n.t3$Length <- unlist(n.t3$Length)
n.t3$SpecCode <- unlist(n.t3$SpecCode)
n.t3$Cites_Code <- unlist(n.t3$Cites_Code)
n.t3$MaxDepth <- unlist(n.t3$MaxDepth)

str(n.t3)

#removing rows that don't have a value for length and depth
n.t3 <- n.t3[ - which(is.na(n.t3$Length)),]
n.t3 <- n.t3.t[ - which(is.na(n.t3$MaxDepth)),]

#creating different GLMs
glm0 <- glm(Cites_Code ~ 1, data = n.t3, family = binomial)

glm1 <- glm(Cites_Code ~ Length, data = n.t3, family = binomial)
glm2 <- glm(Cites_Code ~ MaxDepth, data = n.t3, family = binomial)
glm3 <- glm(Cites_Code ~ Length + MaxDepth, data = n.t3, family = binomial)

#testing the glms for fit
glm0$deviance / glm0$df.residual
glm1$deviance / glm1$df.residual
glm2$deviance / glm2$df.residual
glm3$deviance / glm3$df.residual

#finding the model with the best fit
anova(glm0, glm1, test = "Chisq")
anova(glm0, glm2, test = "Chisq")
anova(glm1, glm3, test = "Chisq")
anova(glm2, glm3, test = "Chisq")
anova(glm0, glm3, test = "Chisq")


####how to draw a line for a glm that has more than one variable?
par(mfrow = c(1,1))
plot(n.t3$MaxDepth, n.t3$Cites_Code)

range.for.predict <- seq(min(n.t3$MaxDepth), max(n.t3$MaxDepth), 0.1)
pred.response <- predict(glm2, list(MaxDepth = range.for.predict), type = "response")
lines(range.for.predict, pred.response, col = "red", lwd = 1)

#making specifications for the figure below
jitter.t <- c(0.3) 
col.t <- c("#2B1575") #colour
alpha.t <- c(50, "FF") #transparency 

#saving a pdf of a figure of the relationship between length and CITES codes to the figures folder
pdf(paste(p.figures, "Length_CITES.pdf", sep = ""))
plot(n.t3$Length, jitter(n.t3$Cites_Code, jitter.t), xlab = "Fish Length (cm)", ylab = "CITES Code", pch = 16, col = paste(col.t[1], alpha.t[1], sep = ""), las = 1)
range.for.predict <- seq(min(n.t3$Length), max(n.t3$Length), 0.1)
pred.response <- predict(glm1, list(Length = range.for.predict), type = "response")
lines(range.for.predict, pred.response, col = "red", lwd = 1)
dev.off()


