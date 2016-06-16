//
//  ThreeHoursFCollectionViewCell.swift
//  The Weather App
//
//  Created by yusuf_kildan on 15/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import UIKit

class ThreeHoursFCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    func configureCell(weatherData : ThreeHourForecastData){
        if let date = weatherData.dateWithTime {
            dateTimeLabel.text = date
        }
        
        if let temp = weatherData.temperature {
            temperature.text = temp
        }
        if let iconImage = weatherImageDict[weatherData.imageIconId] {
            weatherImage.image = UIImage(named : iconImage)
        }
    
    }
}
