//
//  Constants.swift
//  The Weather App
//
//  Created by yusuf_kildan on 15/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import Foundation

typealias DownloadCompleted = ()->()
var isMetric = true
struct ThreeHourForecastData {
    private(set) var dateWithTime: String!
    private(set) var imageIconId: String!
    private var temperatureK: Int!
    
    var temperature: String! {
        return "\(convertTemp(temperatureK))º"
    }
    
    init(dateTime: String, imageId: String, tempK: Int) {
        self.dateWithTime = dateTime
        self.imageIconId = imageId
        self.temperatureK = tempK
    }
}

struct DailyForecastData {
    private(set) var dayName : String!
    private(set) var imageIconId : String!
    private var _tempMin : Int!
    private var _tempMax : Int!
    
    var tempMin : String? {
        
        return "\(convertTemp(_tempMin))º"
    }
    var tempMax : String?{
        return "\(convertTemp(_tempMax))º"
    }
    
    init(dayName : String,imageIconId : String , tempMax : Int ,tempMin : Int) {
        self.dayName = dayName
        self.imageIconId = imageIconId
        self._tempMin = tempMin
        self._tempMax = tempMax
    }
}
let weatherDescriptionDict = [
    "clear sky" : "Açık",
    "few clouds" : "Az bulutlu",
    "scattered clouds" : "Dağınk bulutlu",
    "broken clouds" : "Parçalı bulutlu",
    "shower rain" : "Kısa süreli yağmur",
    "rain" : "Yağmurlu",
    "thunderstorm" : "Sağanak yağış",
    "snow" : "Karlı",
    "mist" : "Sisli"
]

let weatherImageDict = [
    "01d" : "Sun",
    "01n" : "Bright Moon",
    
    "02d" : "Partly Cloudy Day",
    "02n" : "Partly Cloudy Night",
    
    "03d" : "Clouds",
    "03n" : "Clouds",
    
    "04d" : "Clouds",
    "04n" : "Clouds",
    
    "09d" : "Light Rain",
    "09n" : "Light Rain",
    
    "10d" : "Rain",
    "10n" : "Rain",
    
    "11d" : "Storm",
    "11n" : "Storm",
    
    "13d" : "Snow",
    "13n" : "Snow",
    
    "50d" : "Fog Day",
    "50n" : "Fog Night"


]


// Standard path is BaseUrl + Weather/Forecast/WeekForecast + City/Location + KeyPrefix 

struct ApiCall {
    private static let BaseUrl = "http://api.openweathermap.org/data/2.5/"
    private static let Weather = "weather?"
    private static let Forecast = "forecast?"
    private static let DailyForecast = "daily?"
    static var City = "q="
    static var Location = ""
    private static let KeyPrefix = "&APPID="
    private static let APIKey = "e86f277ef313b7554a37049b02d3224f"
 
   
    static var CurrentWeather: String {
        
        return BaseUrl + Weather + City + KeyPrefix + APIKey
    }
    static var CurrentWeatherWithLocation: String {
        return BaseUrl + Weather + Location + KeyPrefix + APIKey
    }
    
    static var ThreeHourForecast: String {
        return BaseUrl + Forecast + City + KeyPrefix + APIKey
    }
    static var ThreeHourForecastWithLocation: String {
        return BaseUrl + Forecast + Location + KeyPrefix + APIKey
    }
    
   
    static var DailyForecastWithLocation: String {
        return BaseUrl + Forecast + Location + KeyPrefix + APIKey
    }
}
func convertTemp(temp : Int)->Int {
    if isMetric {
       return Int(temp - 273)
    }else {
        //T(K) × 9/5 - 459.67
        return Int((temp*9/5)-(459))
    }
}

