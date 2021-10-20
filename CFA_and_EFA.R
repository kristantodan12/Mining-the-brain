#----------------------------------------------------------------------------------------------------------
# Date: 01/04/2021
# Contributors: Xinyang Liu, Andrea Hildebrandt, Daniel Kristanto
# Topic: Factor analyses of brain IOU v.s. covariances of performance scores in 15 HCP tasks
# Manuscript: What the brain's structural properties reveal about the ontology of human intelligence
#----------------------------------------------------------------------------------------------------------
#install.packages("semPlot")
library(psych)
library(lavaan)
library(GPArotation)
library(semPlot)

#####################
#  1. Data import
#####################

# Brain IOU matrix

matrix.IOU.p <- read.csv("IOU_G1_R1.txt", header = FALSE) #load IOU matrix from 1 sample

rownames(matrix.IOU.p) <- c("Gf1","Gf2","Gf3","Gc1","Gc2","Gm1","Gm2","EF1","EF2","EF3","EF4","Gs1","Gs2","Gs3","Gs4")
colnames(matrix.IOU.p) <- c("Gf1","Gf2","Gf3","Gc1","Gc2","Gm1","Gm2","EF1","EF2","EF3","EF4","Gs1","Gs2","Gs3","Gs4")

matrix.IOU.p <- as.matrix(matrix.IOU.p)



# Data frame of performance scores

behav_dat <- read.table("behav_or.txt", header=F, sep = ",")
names(behav_dat) <- c("Gf1","Gf2","Gf3","Gc1","Gc2",
                      "Gm1","Gm2","EF1",
                      "EF2","EF3","EF4","Gs1","Gs2","Gs3","Gs4")


######################################
#  2. EFA for the brain IOU
######################################

# Scree plot

fa.parallel(matrix.IOU.p,n.obs=838,fm="minres",fa="fa",main="Parallel Analysis Scree Plots (Positive IOU Matrix)",
            n.iter=20,show.legend=TRUE,sim=TRUE,quant=.95,cor="cor",use="pairwise",plot=TRUE,correct=.5)

# Factor analysis

# 1 factor
fa(matrix.IOU.p, nfactors=1, n.obs = 838, rotate="promax")

# 2 factors
fa(matrix.IOU.p, nfactors=2, n.obs = 838, rotate="promax")

# 3 factors
fa(matrix.IOU.p, nfactors=3, n.obs = 838, rotate="promax")

# 4 factors
fa(matrix.IOU.p, nfactors=4, n.obs = 838, rotate="promax")

# 5 factors
fa(matrix.IOU.p, nfactors=5, n.obs = 838, rotate="promax")


####################################
#  3. CFA for the behavioral data
####################################

mod_behav <- '  
                gf =~ Gf1 + Gf2 + Gf3
                gc =~ Gc1 + Gc2
                gm =~ Gm1 + Gm2
                EF =~ EF1 + EF2 + EF3 + EF4
                gs =~ Gs1 + Gs2 + Gs3 + Gs4
                
                EF1 ~~ EF2
                EF3 ~~ EF4
                Gs3 ~~ Gs4
                
               '
fit_behav <- cfa(mod_behav, data = behav_dat, meanstructure = F, std.lv=TRUE)
pred <- lavPredict(fit_behav)
summary(fit_behav, fit.measures=TRUE, standardized=TRUE)

#####################
#  4. CFA on the IOU
#####################

mod_IOU.p <- '  
              gf =~ Gf1 + Gf2 + Gf3
              gc =~ Gc1 + Gc2
              gm =~ Gm1 + Gm2
              EF =~ EF1 + EF2 + EF3 + EF4
              gs =~ Gs1 + Gs2 + Gs3 + Gs4

Gf1 ~~ 1*Gf1
Gf2 ~~ 1*Gf2
Gf3 ~~ 1*Gf3
Gc1 ~~ 1*Gc1
Gc2 ~~ 1*Gc2
Gm1 ~~ 1*Gm1
Gm2 ~~ 1*Gm2
EF1 ~~ 1*EF1
EF2 ~~ 1*EF2
EF3 ~~ 1*EF3
EF4 ~~ 1*EF4
Gs1 ~~ 1*Gs1
Gs2 ~~ 1*Gs2
Gs3 ~~ 1*Gs3
Gs4 ~~ 1*Gs4

'
fit_IOU.p <- cfa(mod_IOU.p, sample.cov=matrix.IOU.p, sample.nobs=838, meanstructure=FALSE, std.lv=TRUE)
summary(fit_IOU.p , fit.measures=TRUE, standardized=TRUE)


