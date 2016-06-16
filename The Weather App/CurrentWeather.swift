//
//  CurrentWeather.swift
//  The Weather App
//
//  Created by yusuf_kildan on 15/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import Foundation
import Alamofire
class CurrentWeather : Weather {
    private var tempKelvin : Int!//
    private var maxTempKelvin : Int!//
    private var minTempKelvin : Int!//
    private(set) var humidity : Int!//
    private(set) var pressure : Int!//
    private(set) var city : String!//
    private(set) var country : String!//
    private(set) var weatherDescription : String!//
    private(set) var iconId: String!//
    private(set) var cloudPercent : Int!//
    private(set) var windDirection : Int!
    
    private var windSpeedMetric: Double!
    private var windSpeed: String {
        return isMetric ? "\(windSpeedMetric)ms" :
            String(format: "%.1f", Double(windSpeedMetric * 3600) / 1609.344) + "mh"
    }
    
    
    var temperature : String {
        let suffix = isMetric ? "C" : "F"
        return "\(tempKelvin)°\(suffix)"
    }
    
    var maxTemperature : String {
        return "\(maxTempKelvin)°"
    }
    var minTemperature : String {
        return "\(minTempKelvin)°"
    }
    
    //http://climate.umn.edu/snow_fence/components/winddirectionanddegreeswithouttable3.htm
    var windData: String {
        var windData = ""
        if let degrees = windDirection {
            switch degrees {
            case 349 ... 360, 0...11:   windData = "n "
            case 12...33:               windData = "nne "
            case 34...56:               windData = "ne "
            case 57...78:               windData = "ene "
            case 79...101:              windData = "e "
            case 102...123:             windData = "ese "
            case 124...146:             windData = "se "
            case 147...168:             windData = "sse "
            case 169...191:             windData = "s "
            case 192...213:             windData = "ssw "
            case 214...236:             windData = "sw "
            case 237...258:             windData = "wsw "
            case 259...281:             windData = "w "
            case 282...303:             windData = "wnw "
            case 304...326:             windData = "nw "
            case 327...348:             windData = "nnw "
            default:                    windData = ""
            }
        }
        return windData + windSpeed
    }
    
    func getCurrenWeatherData(completion : DownloadCompleted){
        Alamofire.request(.GET,self.url).responseJSON { (response) in
            if let dict = response.result.value as? [String : AnyObject] {
                 print(dict)
                if let main = dict["main"] as? [String : AnyObject] {
                    
                    if let tempKelvin = main["temp"] as? Float {
                        self.tempKelvin = Int(tempKelvin)
                    }
                    if let pressure = main["pressure"] as? Float {
                        self.pressure = Int(pressure)
                    }
                    if let humidity = main["humidity"] as? Float {
                        self.humidity = Int(humidity)
                    }
                    if let temp_min = main["temp_min"] as? Float {
                        self.minTempKelvin = Int(temp_min)
                    }
                    if let temp_max = main["temp_max"] as? Float {
                        self.maxTempKelvin = Int(temp_max)
                    }
                }
                
                if let sys = dict["sys"] as? [String : AnyObject] {
                    if let country = sys["country"] as? String {
                        self.country = country
                    }
                }
                
                if let weather = dict["weather"] as? [[String : AnyObject]] {
                    if let description = weather[0]["description"] as? String {
                        self.weatherDescription = description
                    }
                    
                    if let icon = weather[0]["icon"] as? String {
                        self.iconId = icon
                    }
                }
                if let city = dict["name"] as? String {
                    self.city = city
                }
                if let clouds = dict["clouds"] as? [String : AnyObject] {
                    if let all = clouds["all"] as? Int{
                        self.cloudPercent = all
                    }
                }
                if let wind = dict["wind"] as? [String : AnyObject] {
                    if let speed = wind["speed"] as? Double{
                        self.windSpeedMetric = speed
                    }
                    if let direction = wind["deg"] as? Int {
                        self.windDirection = direction
                    }
                }
             
                 completion()
                print("JSON datas parsed")
            }
        }
        
       
    }
    
    
    
}