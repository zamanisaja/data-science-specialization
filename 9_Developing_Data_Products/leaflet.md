---
title: "Covid map of Italy"
author: "Saja"
output: 
  html_document:
    keep_md: true
---



## Introduction
This is a demo document to create a map of counts of cvoid patients in Italy, using leaflet.



```r
library("tidyverse")
library("leaflet")
```

### Getting the data

For this demo I'll be using this [github][1] repository.



Now lets read the data.


```r
df <- read_csv("./data/latest.csv")
df <- df %>%
    select(c("denominazione_regione", "lat", "long", "totale_casi"))


names(df) <- c("name", "latitude", "longitude", "cases")
head(df)
```

```
## # A tibble: 6 × 4
##   name                  latitude longitude   cases
##   <chr>                    <dbl>     <dbl>   <dbl>
## 1 Abruzzo                   42.4      13.4  425222
## 2 Basilicata                40.6      15.8  144287
## 3 Calabria                  38.9      16.6  410409
## 4 Campania                  40.8      14.3 1791258
## 5 Emilia-Romagna            44.5      11.3 1554149
## 6 Friuli Venezia Giulia     45.6      13.8  396049
```

Now I'm going to draw a map of italy with total number of new cases in each region of italy.


```r
df %>%
    leaflet() %>%
    addTiles() %>%
    addCircles(weight = 1, radius = df$cases / 100, color = "red", popup = df$name)
```

```{=html}
<div id="htmlwidget-49ea031db0a687354c4b" style="width:672px;height:480px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-49ea031db0a687354c4b">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org\">OpenStreetMap<\/a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA<\/a>"}]},{"method":"addCircles","args":[[42.35122196,40.63947052,38.90597598,40.83956555,44.49436681,45.6494354,41.89277044,44.41149315,45.46679409,43.61675973,41.55774754,46.49933453,46.06893511,45.0732745,41.12559576,39.21531192,38.11569725,43.76923077,43.10675841,45.73750286,45.43490485],[13.39843823,15.80514834,16.59440194,14.25084984,11.3417208,13.76813649,12.48366722,8.9326992,9.190347404,13.5188753,14.65916051,11.35662422,11.12123097,7.680687483,16.86736689,9.110616306,13.3623567,11.25588885,12.38824698,7.320149366,12.33845213],[4252.22,1442.87,4104.09,17912.58,15541.49,3960.49,16856.63,4690.67,30117.42,4924.97,698.25,2250.34,1730.11,12374.56,11864.03,3421.7,12769.96,11966.5,3011.9,375.96,18325.87],null,null,{"interactive":true,"className":"","stroke":true,"color":"red","weight":1,"opacity":0.5,"fill":true,"fillColor":"red","fillOpacity":0.2},["Abruzzo","Basilicata","Calabria","Campania","Emilia-Romagna","Friuli Venezia Giulia","Lazio","Liguria","Lombardia","Marche","Molise","P.A. Bolzano","P.A. Trento","Piemonte","Puglia","Sardegna","Sicilia","Toscana","Umbria","Valle d'Aosta","Veneto"],null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null,null]}],"limits":{"lat":[38.11569725,46.49933453],"lng":[7.320149366,16.86736689]}},"evals":[],"jsHooks":[]}</script>
```
This data generated on: Wed Jun 29 09:02:14 2022

[1]: https://github.com/pcm-dpc/COVID-19 "Health Ministery"
