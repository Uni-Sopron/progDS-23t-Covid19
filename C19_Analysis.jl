
using Distributions
using StatsBase
using CSV
using DataFrames
using StatsPlots
using Plots
gr()
using Dates
using Statistics


url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"

download(url, "covid_data.csv")
data= CSV.read("./covid_data.csv", DataFrame)

data_2 = rename(data, 1 => "province", 2 => "country")
countries = data[1:end, 2]
countries = collect(data[:, 2])

date_strings = String.(names(data))[5:end] 
format = Dates.DateFormat("m/d/Y")
dates = parse.(Date, date_strings, format) + Year(2000)



US_row = findfirst(countries .== "US")
data[US_row, :]
UC_data_row = data[US_row, :]
US_data = convert(Vector, getproperty.(Ref(UC_data_row), names(UC_data_row)[5:end]))
plot(dates, US_data, xticks=dates[1:250:end], xrotation=45, leg=:topleft, 
label="US data", m=:o)
xlabel!("date")
ylabel!("confirmed cases in US")
title!("US confirmed COVID-19 cases")




Andorra_row = findfirst(countries .== "Andorra")
data[Andorra_row, :]
Andorra_data_row = data[Andorra_row, :]
Andorra_data = convert(Vector, getproperty.(Ref(Andorra_data_row), names(Andorra_data_row)[5:end]))
plot(dates, Andorra_data, xticks=dates[1:250:end], xrotation=10, leg=:topleft, 
label="Andorra data", m=:o)
xlabel!("date")
ylabel!("confirmed cases in Andorra")
title!("Andorra confirmed COVID-19 cases")



bar(dates, US_data,
xticks=dates[1:500:end],
xrotation=40,
leg=:topleft,
label="US data",
xlabel="Date",
ylabel="Confirmed cases in US",
title="US confirmed COVID-19 cases")   


scatter(US_data,m=:o,alpha=0.5,ms=2,xlabel="day",ylabel="cumulative cases",leg=false, title="Covid-19 Cumulative Cases over 1000 Days")  



daily_cases= diff(US_data)
plot(dates[2:end], daily_cases, m=:o,leg=false,xlabel="days",ylabel="daily US cases", alpha=0.5, title="US daily cases")


running_mean = [mean(daily_cases[i-6:i]) for i in 7:length(daily_cases)]
plot(daily_cases,label="raw daily cases")
plot!(running_mean, m=:o, label = "running weekly mean",leg=:topleft, xlabel="days",ylabel="Weekly mean",title="Weekly mean cases in US")


function plot_cases_by_country(country)
    
    country_data = filter(row -> row.country == country, data_2)
    cases = Matrix{Union{Missing, Int64}}(country_data[:, 5:end])
    cases = cases'
    plot(dates, cases, xlabel = "Date", ylabel = "Cases", label = country, legend = :topleft)

end

plot_cases_by_country("Hungary")

