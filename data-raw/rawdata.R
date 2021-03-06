## Build the .RData from raw

## Make an empty blank (vanilla) R session (or better restart the R session in vanilla mode)
rm(list=ls()) ## note this may not be enough

## Land use change example
library(raster)
library(bnspatial)

ConwyData <- list()

rawPath <- system.file("extdata/ConwyStatus.tif", package = "bnspatial")
ConwyData$ConwyStatus <- readAll(raster(rawPath))

rawPath <- system.file("extdata/ConwySlope.tif", package = "bnspatial")
ConwySlope <- raster(rawPath)
ConwySlope[ConwySlope == 128] <- NA
ConwyData$ConwySlope <- ConwySlope

rawPath <- system.file("extdata/ConwyLU.tif", package = "bnspatial")
ConwyData$ConwyLU <- readAll(raster(rawPath))

rawPath <- system.file("extdata/LUclasses.txt", package = "bnspatial")
ConwyData$LUclasses <- importClasses(rawPath)

rawPath <- system.file("extdata/LandUseChange.net", package = "bnspatial")
ConwyData$LandUseChange <- loadNetwork(rawPath,'FinalLULC')

spDataLst <- linkMultiple(c(ConwyLU, ConwySlope, ConwyStatus), LandUseChange, LUclasses, verbose = FALSE)
coord <- aoi(ConwyLU, xy=TRUE)
ConwyData$evidence <- bulkDiscretize(spDataLst, coord)

rm(rawPath)
rm(coord)
rm(ConwySlope)
rm(spDataLst)
rm(.Random.seed)
#save('ConwyData', file=system.file("data/ConwyData.RData", package = "bnspatial"))

