//
//  DailyWeather.swift
//  The Weather App
//
//  Created by yusuf_kildan on 16/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import Foundation
import Alamofire
class DailyWeather : Weather {
    
    private(set) lazy var dailyForecastDatas = [DailyForecastData]()
    func getDailyWeatherData(completion : DownloadCompleted) {
        Alamofire.request(.GET , url).responseJSON { (response) in
            if let dict = response.result.value as? [String : AnyObject] {
                self.dailyForecastDatas.removeAll()
                if let listData = dict["list"] as? [[String : AnyObject]] {
                    print(listData)
                    for  i in 0..<listData.count {
                        let list = listData[i]
                        if let utcTime = list["dt"] as? Int {
                            let date = NSDate(timeIntervalSince1970: Double(utcTime))
                            let component = NSCalendar.currentCalendar().component(.Hour, fromDate: date)
                            
                            print(component)
                            if component == 15 {
                              
                                let dateFormatter = NSDateFormatter()
                                dateFormatter.locale = NSLocale.currentLocale()
                                dateFormatter.dateFormat = "EEEE"
                                let dayName = dateFormatter.stringFromDate(date)
                                
                                var iconId = ""
                                if let weather = list["weather"] as? [[String : AnyObject]] {
                                    if let icon = weather[0]["icon"] as? String {
                                        iconId = icon
                                    }
                                }
                                var max_Temp = 0,min_Temp = 0
                                if let main = list["main"] as? [String : AnyObject] {
                                    if let maxTemp = main["temp_max"] as? Int {
                                        max_Temp = maxTemp
                                    }
                                    if let minTemp = main["temp_min"] as? Int {
                                        min_Temp = minTemp
                                    }
                                }
                                let weather = DailyForecastData(dayName: dayName, imageIconId: iconId, tempMax: max_Temp, tempMin: min_Temp)
                                self.dailyForecastDatas.append(weather)
                               
                             
                            }
                            
                            completion()
                        }
                    }
                }
            }
        }
    }
}