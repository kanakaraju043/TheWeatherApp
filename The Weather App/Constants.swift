//
//  Constants.swift
//  The Weather App
//
//  Created by yusuf_kildan on 15/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import Foundation

typealias DownloadCompleted = ()->()
var isMetric = false
struct ThreeHourForecastData {
    private(set) var dateWithTime: String!
    private(set) var imageIconId: String!
    private var temperatureK: Int!
    
    var temperature: String! {
        return "\(temperatureK)º"
    }
    
    init(dateTime: String, imageId: String, tempK: Int) {
        self.dateWithTime = dateTime
        self.imageIconId = imageId
        self.temperatureK = tempK
    }
}

let weatherImageDict = [
    "01d" : "Sun",
    "01n" : "Moon",
    
    "02d" : "Partly Cloudy Day",
    "02n" : "Partly Cloudy Day",
    
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
    "50n" : "Fog Night"]


// Standard path is BaseUrl + Weather/Forecast/WeekForecast + City/Location + KeyPrefix 

struct ApiCall {
    private static let BaseUrl = "http://api.openweathermap.org/data/2.5/"
    private static let Weather = "weather?"
    private static let Forecast = "forecast?"
    private static let DailyForecast = "daily?"
    static var City = "q=osaka"
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
        return BaseUrl + DailyForecast + Location + KeyPrefix + APIKey
    }
}


