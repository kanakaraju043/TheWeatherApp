//
//  ThreeHoursWeather.swift
//  The Weather App
//
//  Created by yusuf_kildan on 16/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import Foundation
import Alamofire
class ThreeHoursWeather : Weather {
    private(set) var dateWithTime: String!
    private(set) var imageIconId: String!
    private var temperatureK: Int!
    var threeHoursWeatherDatas = [ThreeHourForecastData]()
    func getThreeHoursWeatherData(completion : DownloadCompleted) {
        let counter = 16
        Alamofire.request(.GET,url).responseJSON { (response) in
            if let dict = response.result.value as? [String : AnyObject] {
                if let listData = dict["list"] as? [[String : AnyObject]] {
                    for index in 0...counter {
                        var list = listData[index]
                        
                        var temperature : Int!
                        if let main = list["main"] as? [String : AnyObject] {
                            if let temp = main["temp"] as? Int {
                                temperature = temp
                            }
                        }
                        
                        var formattedTime = ""
                        if let utcDateTime = list["dt"] as? Int {
                           formattedTime = self.getTimeInDesiredFormat(utcDateTime)
                        }
                        
                        var imageId = ""
                        if let weather = list["weather"] as? [[String: AnyObject]] {
                            if let iconID = weather[0]["icon"] as? String {
                                imageId = iconID
                            }
                        }
                        
                        let  forecast = ThreeHourForecastData(dateTime: formattedTime, imageId: imageId, tempK: temperature)
                        print(formattedTime)
                        print(imageId)
                        print(temperature)
                        self.threeHoursWeatherDatas.append(forecast)
                        
                    }
                }
            }
            
            completion()
        }
    
    }
    
    
    
    
    private func getTimeInDesiredFormat(utcDateTime: Int) -> String {
        let readableDateTime = NSDate(timeIntervalSince1970: Double(utcDateTime))
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "EEE"
        let dayName = dateFormatter.stringFromDate(readableDateTime)
        
        /*  **********************************************
         GETTING THE DESIRED TIME FORMAT
         Getting the time format is quite convoluted.
         The steps are explained below:
         1.  Make a formatter with a valid time format to convert the localTime
         string back into an NSDate.
         2.  Convert the string back into an NSDate.
         4.  If the check passes, change the format to the desired format
         5.  Create a string from the NSDate using the new format.
         **********************************************  */
        
        let localTime = NSDateFormatter.localizedStringFromDate(readableDateTime,
                                                                dateStyle: .NoStyle, timeStyle: .ShortStyle)
        
        let timeFormatter = NSDateFormatter()
        var stringToDateFormat = ""
        var dateToStringFormat = ""
        
        if localTime.containsString("AM") || localTime.containsString("PM") {
            stringToDateFormat = "h:mm a"
            dateToStringFormat = "ha"
        } else {
            stringToDateFormat = "H:mm"
            dateToStringFormat = "H"
        }
        
        timeFormatter.dateFormat = stringToDateFormat
        if let formattedTime = timeFormatter.dateFromString(localTime) {
            timeFormatter.dateFormat = dateToStringFormat
            let timeInDesiredFormat = timeFormatter.stringFromDate(formattedTime)
            return dayName + " " + timeInDesiredFormat
        }
        print("ThreeHourForecast: TimeFormat Error")
        return "Error"
    }

    

}