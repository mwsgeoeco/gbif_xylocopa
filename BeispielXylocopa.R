

####################################
#### 1. GBIF Daten laden ###########
####################################


library(rgbif)
library(sf)
library(mapview)


# auslesen Xylocopa violacea
Xylocopa2023 <- occ_data(scientificName = "Xylocopa violacea", country="DE", hasCoordinate = TRUE, limit = 20000, year="2023")# 

Xylocopa2018 <- occ_data(scientificName = "Xylocopa violacea", country="DE", hasCoordinate = TRUE, limit = 20000, year="2018")# 

Xylocopa2013 <- occ_data(scientificName = "Xylocopa violacea", country="DE", hasCoordinate = TRUE, limit = 20000, year="2013")# 



Xylocopa <- rbind(Xylocopa2023$data[,c("scientificName", "decimalLatitude", "decimalLongitude","year")], Xylocopa2018$data[,c("scientificName", "decimalLatitude", "decimalLongitude","year")], Xylocopa2013$data[,c("scientificName", "decimalLatitude", "decimalLongitude","year")])

######################################################
# 2. Umwandeln in räumliche Objekte
######################################################

# auslesen der relevanten Tabelle
Xylocopa_spatial <- as.data.frame(Xylocopa)


Xylocopa_spatial <- st_as_sf(Xylocopa_spatial, coords = c("decimalLongitude", "decimalLatitude"), crs = st_crs(4326))


# testplot
windows(width=5, height=5)
par(mar=c(0.5, 0.5, 2, 0.5))
plot(st_geometry(Xylocopa_spatial), main="Xylocopa")
# das sieht komisch aus!

# hier gibt es offenbar ein paar Ausreißer, die nicht in Deutschland liegen. Wir laden den Umriss von Deutschland und filtern. (Datei = "Germany_grenze.shp")

#############################################################
########## 3.  Auswahl von Objekten in Deutschland ##########
#############################################################

setwd("") # Pfad anpassen

# einlesen der Daten
de_outline <- st_read("Germany_grenze.shp")

de_outline <- st_transform(de_outline, to=st_crs(4326))

# Filtern der Punkte in Deutschland
# zunächst muss man noch mal die Koordinatensysteme harmonisieren, sonst gibt es probleme beim filtern
de_outline <- st_transform(de_outline, crs=st_crs(Xylocopa_spatial))  

# filtern
Xylocopa_spatial_filter <-  st_filter(Xylocopa_spatial, de_outline)

# wir plotten zur Kontrolle
mapview(Xylocopa_spatial_filter[,"year"], map.types="OpenStreetMap", cex = 2 )


######################################################
#### 4. Plotten der Ausbreitung auf Karten 
######################################################

# Auswahl von Zeitschritten über die Jahreszahlen 2010 bis 2014
y2013 <- Xylocopa_spatial_filter$year==2013

# wir plotten zur Kontrolle
mapview(Xylocopa_spatial_filter[y2013,"year"], map.types="OpenStreetMap", cex = 2 )


## wir plotten den ersten Zeitschritt
windows(width=5, height=5)
par(mar=c(0.5, 0.5, 2, 0.5))
plot(st_geometry(de_outline))
plot(st_geometry(Xylocopa_spatial_filter[y2013,]), add=T)
mtext(substitute(paste(italic('Xylocopa'), " 2013")))


# Auswahl von Zeitschritten über die Jahreszahlen 2010 bis 2014
y2018 <- Xylocopa_spatial_filter$year==2018 

windows(width=5, height=5)
par(mar=c(0.5, 0.5, 2, 0.5))
plot(st_geometry(de_outline))
plot(st_geometry(Xylocopa_spatial_filter[y2018,]), add=T)
mtext(substitute(paste(italic('Xylocopa'), " 2018")))


# Auswahl von Zeitschritten über die Jahreszahlen 2010 bis 2014
y2023 <- Xylocopa_spatial_filter$year==2023 

windows(width=5, height=5)
par(mar=c(0.5, 0.5, 2, 0.5))
plot(st_geometry(de_outline))
plot(st_geometry(Xylocopa_spatial_filter[y2023,]), add=T)
mtext(substitute(paste(italic('Xylocopa'), " 2023")))

