#' UK Railway Network
#'
#' Latitude and longitude of all railway tracks in the United Kingdom.
#'
#' Data from a \href{https://www.whatdotheyknow.com/request/latitude_and_longitude_of_all_ra}{Freedom
#' of Information request}.
#'
#' ## Caveats
#'
#' The NetworkLinks dataset contains a geographic representation of the Network
#' Model at track level ELR  TRID track centre line. This model is constructed
#' of individual links that form the national network. The track level model is
#' represented as polyline. The baseline data for this layer was originally
#' created by the Corporate Network Model CNM in 2005. This was then updated
#' with new survey data from the Geospatial Model Stabilisation Project GMS.
#' Where GMS updates have been undertaken the track model has a positional
#' accuracy  0.5 meters x and y. Since the GMS project finished in early 2014
#' the data is being checked against GEOGIS, as part of the data improvement
#' process and where necessary updates are taking place. Since late 2017 this
#' updating process has now become part of managing INM and the Network Model
#' and INM are one of the same.
#'
#' @format A data frame with 49484 rows and 7 variables:
#' \describe{
#'   \item{\code{fid}}{}
#'   \item{\code{elr}}{Engineer's Line Reference}
#'   \item{\code{trid}}{Track ID}
#'   \item{\code{lat_start}}{Starting latitude}
#'   \item{\code{lat_end}}{Ending latitude}
#'   \item{\code{lon_start}}{Starting longitude}
#'   \item{\code{lon_end}}{Starting longitude}
#' }
#' @source \url{https://www.whatdotheyknow.com/request/latitude_and_longitude_of_all_ra}
"railways"

#' UK Railway Stations
#' @noRd
"railway_stations"

#' Schools in England
#'
#' Ofsted (Office for Standards in Education, Children’s Services and Skills) is
#' the UK government department responsible for inspecting schools and other
#' social care services for children.
#' @noRd
"schools_england"

#' Schools in Wales
#'
#' @noRd
"schools_wales"

#' Local Authorities
#' @noRd
"local_authority"

#' Postal Codes
#'
#' Postal codes have four components:
#'
#' - Area       (eg. JE)
#' - District   (eg. JE1)
#' - Sector     (eg. JE1 0)
#' - Unit       (eg. JE1 0BD)
#'
#' @noRd
"postal"

#' Postbox Locations
#'
#' @noRd
"postboxes"
