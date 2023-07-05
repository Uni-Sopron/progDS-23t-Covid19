# COVID-19 ADATOK ELEMZÉSE – JULIA

Ebben a feladatban a koronavírusra vonatkozó adatokat vizsgálom meg és elemzem a Julia programnyelv segítségével. 

Az adatokat a következő forrásból merítettem: 
[raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv](https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv)

Ezen adatok feldolgozásával és néhány vizualizációért felelős könyvtár használatával egészen látványos elemzéseket sikerült létrehoznom.

## Az adatok feldolgozása után egy ilyen adatsort kaptam: 

![](Aspose.Words.9b9cc0c9-fffb-42af-86ec-e912d909d72b.001.png)



## Az elemzésem során ezeket a csomagokat használtam:

* using Distributions

* using StatsBase

* using CSV

* using DataFrames

* using StatsPlots

* using Plots

* gr()

* using Dates

* using Statistics

Az adatfeldolgozásnál a dátumot a megfelelő formátumra kellett hozni, hogy aztán könnyebben dolgozhassak vele, mivel az adatsorban csak az évszámnak a vége volt benne. Pl. a 2012 csak 12-ként volt jelen. Ezt a problémát a  a következő kódrészlettel tudtam megoldani.



```julia
 date_strings = String.(names(data))[5:end]
 format = Dates.DateFormat("m/d/Y") 
 dates = parse.(Date, date_strings, format) + Year(2000) 
```


Az 5. Oszloptól az adatsor végéig csak a dátumok voltak, ezeket kitettem egy date\_strings-be, 
majd a format változóba megadtam a dátumok formátumát. Ezután a dates-be beleraktam a dátumokat a megfelelő formátumban, hozzáadva 2000-et, hogy olvashatóbbak legyenek. 

A vizualizáció során haszáltam plot,bar,scratter vizualizációs elemeket.

## Először kimutattam az US Covid esetszámokat vonaldiagramon. Ezek a következőképpen alakultak:

![](Aspose.Words.9b9cc0c9-fffb-42af-86ec-e912d909d72b.002.png)

## Majd ugyanezzel az adatokkal egy bar plot-ban is megjelenítettem őket:

![](Aspose.Words.9b9cc0c9-fffb-42af-86ec-e912d909d72b.003.png)

## A következő lépésben kíváncsi voltam arra, hogy Andorrában hogyan alakultak az esetszámok:

![](Aspose.Words.9b9cc0c9-fffb-42af-86ec-e912d909d72b.004.png)

## Az US adatokat napi szinten is lebontottam, amelyek a következőképpen alakultak:

![](Aspose.Words.9b9cc0c9-fffb-42af-86ec-e912d909d72b.005.png)

## A napi adatokra rátettem a heti átlag fertőzésszámot:

![](Aspose.Words.9b9cc0c9-fffb-42af-86ec-e912d909d72b.006.png)

## Írtam egy függvényt, amely egy adott ország megadásával kimutatja az esetszámokat egy line plot segítségével:

```
function plot_cases_by_country(country)

    country_data = filter(row -> row.country == country, data_2)
    cases = Matrix{Union{Missing, Int64}}(country_data[:, 5:end])
    cases = cases'
    plot(dates, cases, xlabel = "Date", ylabel = "Cases", label = country, legend = :topleft)
end

plot_cases_by_country("Hungary")


```

