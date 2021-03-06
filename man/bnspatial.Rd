% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bnspatial.R
\name{bnspatial}
\alias{bnspatial}
\title{Spatialize the Bayesian network}
\usage{
bnspatial(network, target, spatialData, lookup, msk = NULL,
  what = c("class", "entropy"), midvals = NULL, targetState = NULL,
  spatial = TRUE, inparallel = FALSE, exportRaster = FALSE, path = NULL,
  verbose = TRUE, ...)
}
\arguments{
\item{network}{The Bayesian network. An object of class \code{grain} (from package \href{https://cran.r-project.org/package=bnlearn}{bnlearn}), or a character (the path to the \emph{.net} file to be imported)}

\item{target}{character. The node of interest to be modelled and mapped.}

\item{spatialData}{character or list of objects of class 'RasterLayer'. The raster files corresponding to nodes, as vector of full file paths or as list of rasters (objects of class 'RasterLayer').}

\item{lookup}{character or a formatted list. This argument can be provided as path to a comma separated file or a formatted list (see \code{\link{setClasses}} )}

\item{msk}{a character (path to raster file), a raster (object of class "RasterLayer"), or a list of rasters. 
The reference raster(s) to be used as mask. All model outputs will have the same resolution and same extent as this raster(s). 
All locations with no data (i.e. NA) cells in \code{msk} will be ignored as well.}

\item{what}{character. The required output, one or more of these values are valid:
\itemize{
\item{\code{"class"}} returns the relatively  most likely states.
\item{\code{"entropy"}} calculates the Shannon index and returns the entropy given the state probabilities.
\item{\code{"probability"}} returns an object for each state of the target node, with associated probability.
\item{\code{"expected"}} gives the expected value for the target node (see Details). Only valid for continuous target nodes. \code{midValues} argument must be provided.
\item{\code{"variation"}} returns the coefficient of variation, as a measure of uncertainty.
}}

\item{midvals}{vector of length equal to the number of states of the target node. Applies only if the target node is a continuous 
variable, in which case \code{midvals} must contain the mid values for each of the intervals}

\item{targetState}{character. One or more states of interest from the target node. Applies only 
when argument \code{what} includes \code{'probability'}. Default is set to all states of the node.}

\item{spatial}{logical. Should the output be spatially explicit -i.e. a georeferenced raster? 
Default is TRUE, returning an object of class "RasterLayer". If FALSE, returns a data.frame 
with one row for each non NA cell in \code{msk} raster and in columns the output required by \code{mask} argument.}

\item{inparallel}{logical or integer. Should the function use parallel processing facilities? Default is FALSE: a single process will be launched. If TRUE, all cores/processors but one will be used.
Alternatively, an integer can be provided to dictate the number of cores/processors to be used.}

\item{exportRaster}{Logical or character. Should the spatial output be exported to a raster file? 
Applies only if argument \code{spatial=TRUE}. When \code{exportRaster=TRUE}, rasters will be 
exported in .tif format. A character specifying another extension can be provided, in which case the 
raster will be exported in that format. Only formats listed by \link[raster]{writeFormats} are valid.}

\item{path}{The directory to store the output files, when \code{exportRaster} is not FALSE. 
Default is the working directory (\code{getwd()}). File names are set by a default naming convention, see Details.}

\item{verbose}{logical. If \code{verbose = TRUE} a summary of class boundaries and associated nodes and data will be printed to screen for quick checks.}

\item{...}{Additional arguments to fix a state (i.e. setting evidence) to one or more nodes, 
as known and independent from any spatial data (e.g. the case of non-spatial variables 
which are equal everywhere). Node name is provided as argument and the associated fixed state as 
character; both node and state names must be typed accordingly to their names in the network.}
}
\value{
A list of "RasterLayer" objects or a data.frame, depending on input arguments: see \code{\link{mapTarget}}. 
Some basic information about discretization and network/data link are printed on screen during execution.
}
\description{
This function wraps most bnspatial package functions to ease the spatial implementation of Bayesian networks with minimal user interaction.
}
\details{
bnspatial

The expected value is calculated by summing the mid values of target node states weighted by their probability: 
\code{p1 * midVal_1 + p2 * midval_2 + ... + pn * midval_n}\cr
When a RasterLayer is exported to a file, the file name is set by default, accordingly to the following naming convention:
\itemize{
\item{\code{"class"}} \emph{<target node name>}_Class.\emph{<file format  -default .tif>}
\item{\code{"entropy"}} \emph{<target node name>}_ShanEntropy.\emph{<file format  -default .tif>}
\item{\code{"probability"}} \emph{<target node name>}_Probability_.\emph{<targetState>}.\emph{<file format  -default .tif>}
\item{\code{"expected"}} \emph{<target node name>}_ExpectedValue.\emph{<file format  -default .tif>}
\item{\code{"variation"}} \emph{<target node name>}_CoefVariation.\emph{<file format  -default .tif>}
}
An additional comma separated file (.csv) is written to the same directory when \code{"class"}, 
providing a key to interpret the raster values and the state they refer to.
}
\examples{
data(ConwyData)
list2env(ConwyData, environment())

network <- LandUseChange
spatialData <- c(ConwyLU, ConwySlope, ConwyStatus)
lookup <- LUclasses

bn <- bnspatial(network, 'FinalLULC', spatialData, lookup)
bn

}
\seealso{
\code{\link{setClasses}}; \code{\link{mapTarget}}; \code{\link{linkNode}}; \code{\link{loadNetwork}}
}
