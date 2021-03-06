library(bnspatial)
library(testthat)
##################### GENERAL features #######################
# Make PDF vignettes
# Add example in risk analysis (see balbi 2016 on flood risk)
# Swap current example
# Read xml files and change loading network function


##############################################################
## extractByMask
# % FIX CHECK FOR MISSING NA
 
##############################################################
## queryNet
# % FIX Harmonize with .freezeEvidence the first bit of queryNet, lots of redundancy
# % FIX Ignore extra columns when in evidence tab, instead of throwing error

##############################################################
## mapTarget
# % FIX COORD.REF. OUTPUT RASTERS
# % FIX OUTPUT VALUE OF MOST LIKELY CLASS (to correspod if integer are provided)
# % ADD UTILITY VALUE
# % ADD AN EXAMPLE USING MIDVALUES
# % ADD Output algoritms now hidden (e.g. expected value) to exportable functions
data(ConwyData)
network <- LandUseChange
target <- 'FinalLULC'
statesProb <- queryNet(network, target, evidence)

## Good
mapTarget(target, statesProb, msk=ConwyLU)
mapTarget(target, statesProb, msk=ConwyLU, what = c("class", "entropy", "probability"))
mapTarget(target, statesProb, msk=ConwyLU, what = c("class", "entropy", "probability"))
head(mapTarget(target, statesProb, msk=ConwyLU, spatial=FALSE))
mapTarget(target, statesProb, msk=ConwyLU, what = c("clss", "entropy"))
mp <- mapTarget('FinalLULC', statesProb, what='probability', targetState='forest', msk=ConwyLU); plot(mp$Probability$forest)
mp <- mapTarget('FinalLULC', statesProb, targetState='forest', msk=ConwyLU); plot(mp$Probability$forest)
mapTarget('FinalLULC', statesProb, what='probability', targetState=c('forest','other'), msk=ConwyLU)
s = statesProb[,1:2]; mapTarget('FinalLULC', s, targetState='forest', msk=ConwyLU)

## Bad
mp <- mapTarget('FinalLULC', statesProb, what='pbabity', targetState='forest', msk=ConwyLU); plot(mp$Probability$forest)
mp <- mapTarget('FinalLULC', statesProb, what='probability', targetState='fest', msk=ConwyLU); plot(mp$Probability$forest)
mapTarget('FinalLULC', statesProb, targetState=c('forest','xy'), msk=ConwyLU)
s = statesProb[,1:2]; plot(mapTarget('FinalLULC', s, msk=ConwyLU))
mapTarget(target, statesProb, msk=ConwyLU)

mapTarget(target, statesProb, what = c("class", "entropy"), msk,
          midvals = NULL, targetState = colnames(statesProb), spatial = TRUE,
          exportRaster = FALSE, path = getwd())

##############################################################
## loadNetwork
# % FIX UNDERSCORES REMOVAL (gRain:::.getNodeSpec AND gRain:::.toCamel)
# % CHANGE rewrite all external file reading, remove dependency from gRain there
# % ADD read genie native formats directly xml files
# % ADD read utility nodes
raw = system.file("extdata", "LandUseChange.net", package = "bnspatial")

## Good
loadNetwork(raw)
loadNetwork(raw, 'FinalLULC')
data("ConwyData")
loadNetwork(LandUseChange)
loadNetwork(LandUseChange,'FinalLULC')

## Bad
loadNetwork(LandUseChange,'FinalLULC','FinalLULC')
loadNetwork(LandUseChange,'FinalLULC','FinalLULC')
loadNetwork('FinalLULC',LandUseChange)
loadNetwork(system.file("extdata", "LandUseChange.xls", package = "bnspatial"), 'FinalLULC')
loadNetwork(LandUseChange,'Final')


##############################################################
## linkNode
# % NOTE: FIX ORDER OF NODE STATES BETWEEN CLASSIFICATION AND SPATIAL DATA
data("ConwyData")

## TO FIX

## Good
linkNode(system.file("extdata", "ConwyLU.tif", package = "bnspatial"), network=LandUseChange, node='CurrentLULC', intervals=c(2, 3, 1))
linkMultiple(list(ConwyLU,ConwySlope,ConwyStatus), LandUseChange, LUclasses, verbose=TRUE)
linkNode(layer=ConwyLU, network=LandUseChange, node='CurrentLULC', intervals=c(2, 3, 1))
spatialData <- c(ConwyLU,ConwySlope,ConwyStatus)
linkMultiple(spatialData, LandUseChange, LUclasses, verbose = FALSE)

## Bad


##############################################################
## dataDiscretize

s <- runif(100)

## TO FIX

## Good
dataDiscretize(s, classBoundaries=c(0.2, 0.5, 0.8))
dataDiscretize(s, classBoundaries=3)
dataDiscretize(s, classBoundaries=3, method = 'quantile')
dataDiscretize(s, classBoundaries=3, method = 'equal')
dataDiscretize(s, classBoundaries=3, classStates=c('a', 'b', 'c'))
dataDiscretize(s, classBoundaries=3, classStates=c('a', 'b', 'c'), method = 'equal')
dataDiscretize(s, classStates=c('a', 'b', 'c'))
dataDiscretize(s, classStates=c('a', 'b', 'c'), method = 'equal')
dataDiscretize(s, classStates=c('a', 'b'))
dataDiscretize(s, classStates=c(1, 2))
dataDiscretize(s, classBoundaries=c(-Inf,0.2,Inf)) 
dataDiscretize(s, classBoundaries=c(-Inf, 0.2, 0.5, 0.8))
dataDiscretize(s, classBoundaries=c(0.2, 0.5, 0.8, Inf))

## Bad
dataDiscretize(s)
dataDiscretize(s, classBoundaries=3, method = 'quanle')
dataDiscretize(s, classBoundaries=c(0.5, 0.2)) 
dataDiscretize(s, classBoundaries=c(0.5, 0.8, 0.2)) 
dataDiscretize(s, classBoundaries=c(0.8, 0.5, 0.2)) 
dataDiscretize(s, classBoundaries=0.2) 
dataDiscretize(s, classBoundaries=0) 
dataDiscretize(s, classBoundaries=1) 
dataDiscretize(s, classBoundaries=2.1) 
dataDiscretize(s, classBoundaries=2, classStates=c('a', 'b', 'c'))
dataDiscretize(s, classBoundaries=3, classStates=c('a', 'b'))
dataDiscretize(s, classBoundaries=c(0.8, 0.5, 0.2), classStates=c('a', 'b'))
dataDiscretize(s, classBoundaries='2')
dataDiscretize(s, classBoundaries=c(Inf,0.2,Inf))
dataDiscretize(s, classStates=3)
dataDiscretize(s, classStates='a')
dataDiscretize(s, classBoundaries=c(1, 2))

## Warning
dataDiscretize(s, classBoundaries=c(-Inf,1.2,Inf)) 
dataDiscretize(s, classBoundaries=c(-Inf,0.8,1.1,1.2,Inf))
dataDiscretize(s, classBoundaries=c(1.2, 2, 3.1))
dataDiscretize(s, classBoundaries=c(0.2, 0.5)) ## Borderline (should fail in a BN context)
dataDiscretize(s, classBoundaries=c(0.2, 0.5, 0.8, 0.8, 1.0))
dataDiscretize(s, classBoundaries=c(0.5, 0.5))

##############################################################
## aoi
# % FIX: make RAT=FALSE in `msk <- raster::raster(msk, RAT=FALSE)` even when an input layer is provided

## TO FIX

## Good


##############################################################
### Use testthat

expect_error(dataDiscretize(s, classBoundaries=c(0.5, 0.2)) ) 
expect_error(dataDiscretize(s, classBoundaries=c(0.5, 0.8, 0.2)) )
expect_error(dataDiscretize(s, classBoundaries=c(0.8, 0.5, 0.2)) )
expect_error(dataDiscretize(s, classBoundaries=0.2) )
expect_error(dataDiscretize(s, classBoundaries=0) )
expect_error(dataDiscretize(s, classBoundaries=1) )
expect_error(dataDiscretize(s, classBoundaries=2.1) )
expect_error(dataDiscretize(s, classBoundaries=3, method = 'quanle') )


##############################################################
## setClasseses

## TO FIX

## Good
setClasses(c('ConwySlope', 'ConwyLU', 'ConwyStatus'), list(c('flat', 'moderate', 'steep'),
c('forest', 'arable', 'other'), c('public', 'private', 'protected')),
list(c(-Inf, 0, 5, Inf), c(2, 3, 1), (c(4, 3, 1))), w='N:/delTest.txt')

## Bad
setClasses(c('CurrentLULC', 'LegalStatus'), list(c('flat', 'moderate', 'steep'),
c('forest', 'arable', 'other'), c('public', 'private', 'protected')),
    list(c(-Inf, 0, 5, Inf), c(2, 3, 1), (c(4, 3, 1))), w='N:/delTest.txt')
setClasses(c('CurrentLULC', 'LegalStatus'), 
    list(c('forest', 'arable', 'other'), c('public', 'private', 'protected')),
    list(c(-Inf, 0, 5, Inf), c(2, 3, 1), (c(4, 3, 1))), w='N:/delTest.txt')
setClasses(c('CurrentLULC', 'LegalStatus'), 
    list(c('forest', 'arable', 'other'), c('public', 'private', 'protected')),
    list(c(3, 1), (c(4, 3, 1))), wr='N:/delTest.txt')
setClasses(c('CurrentLULC', 'LegalStatus'), 
    list(c('forest', 'arable', 'other'), c('public', 'private', 'protected')),
    list(c(0.5, 4, 3, 1), (c(4, 3, 1))), wr='N:/delTest.txt')
setClasses(c('ConwyLU', 'ConwyStatus'), 
    list(c('flat', 'moderate', 'steep'), c('forest', 'arable', 'other'), c('public', 'private', 'protected')),
    list(c(-Inf, 0, 5, Inf), c(2, 3, 1), (c(4, 3, 1))), w='N:/delTest.txt')


########## BIGGER DATA (below data evidence is provided for only few nodes, as query 
########## time start growing afterwards)
library(raster); library(bnspatial)

#net = loadNetwork('N:\\A.net')
net = loadNetwork('N:\\Hepar.net')

r = raster('N:/bnspatial\\inst\\extdata\\ConwyLU.tif')

set.seed(99)
spNodes = net$universe$levels[sample(1:70, 30)]

secs = vector()
for (i in 1:30){
    ls = list()
    for(n in seq(i)){
        rr = r
        nNA = which(is.finite(getValues(rr)))
        rr[nNA] = sample(length(spNodes[[n]]), length(nNA), replace=TRUE)
        assign(names(spNodes[n]), rr)
        ls = c(ls, get(names(spNodes[n])))
        cat(
            paste(names(spNodes[n]), '\n', 
                  paste(spNodes[[n]], collapse=','), '\n', 
                  paste(sample(length(spNodes[[n]])), collapse=','), '\n', sep='')
            , file="N:/classes.txt", append=TRUE)
    }
    pr = proc.time()
    bnspatial(net, 'Cirrhosis', ls, 'N:/classes.txt', spatial=FALSE, what='entropy', inparallel=TRUE, verbose=FALSE)
    file.remove("N:/classes.txt")
    print(proc.time() - pr)
    secs = c(secs, proc.time() - pr)
}

plot(1:length(secs),secs)
