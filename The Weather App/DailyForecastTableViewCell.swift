//
//  DailyForecastTableViewCell.swift
//  The Weather App
//
//  Created by yusuf_kildan on 15/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import UIKit

class DailyForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var hightTemperature: UILabel!
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var lowTemperature: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(dailyForecastData : DailyForecastData) {
        if let hightTemperature = dailyForecastData.tempMax {
            self.hightTemperature.text = hightTemperature 
        }
        if let dayName = dailyForecastData.dayName {
            self.dayNameLabel.text = dayName
        }
        if let lowTemperature = dailyForecastData.tempMin {
            self.lowTemperature.text = lowTemperature
        }
        if let iconId = dailyForecastData.imageIconId {
            let icon = weatherImageDict[iconId]!
            self.weatherImage.image = UIImage(named: icon)
        }
    }
}
