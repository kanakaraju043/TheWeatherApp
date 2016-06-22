//
//  ViewController.swift
//  The Weather App
//
//  Created by yusuf_kildan on 14/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import MapKit

class ViewController: UIViewController{
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var mainTempImage: UIImageView!
    @IBOutlet weak var mainTempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var lastUpdatedTimeLabel: UILabel!
    @IBOutlet weak var lastUpdatedDayLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var atmosphericPressureLabel: UILabel!
    @IBOutlet weak var highLowLabel: UILabel!
    @IBOutlet weak var cloudPercentageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var currentWeather : CurrentWeather?
    var threeHoursWeather : ThreeHoursWeather?
    var dailyWeather : DailyWeather?
    var isUpdated = false
    var locationManager : CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
    
            if let cond =  NSUserDefaults.standardUserDefaults().valueForKey("state") as? Bool {
                isMetric = cond
            }
            isUpdated = false
            tableView.delegate = self
            tableView.dataSource = self
            tableView.showsVerticalScrollIndicator = false
            
            
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = UIColor.whiteColor()
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            containerView.hidden = true

       
        
    }
    override func viewDidAppear(animated: Bool) {
        if !Reachability.isConnectedToNetwork() {
            containerView.hidden = true
            showInternetError()
        }else {
            containerView.hidden = false
        }
    }
    func showInternetError(){
        let alert = UIAlertController(title: "Internet bağlantısı yok!", message: "Lütfen internet bağlantınızı kontrol ediniz.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    func updateUIWithLocalData() {
      
        func getWeekDayName() -> String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.stringFromDate(NSDate())
        }
        
        func getTimeInLocalFormat() -> String {
            return NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .NoStyle, timeStyle: .ShortStyle)
        }
        
        self.lastUpdatedDayLabel.text = getWeekDayName()
        self.lastUpdatedTimeLabel.text = getTimeInLocalFormat()
    }
    func updateUI(){
        updateUIWithLocalData()
        if let currentWeather = currentWeather {
            currentWeather.getCurrenWeatherData({
                self.cityNameLabel.text = self.currentWeather!.city
                self.countryNameLabel.text = self.currentWeather!.country
                if let imageString = weatherImageDict["\(currentWeather.iconId)"] {
                    self.mainTempImage.image = UIImage(named: imageString)
                }
                self.mainTempLabel.text = currentWeather.temperature
                self.weatherDescriptionLabel.text = currentWeather.weatherDescription
                self.windSpeedLabel.text = currentWeather.windData
                self.humidityLabel.text = "\(currentWeather.humidity)%"
                self.atmosphericPressureLabel.text = "\(currentWeather.pressure)mb"
                self.highLowLabel.text = "\(currentWeather.maxTemperature)/\(currentWeather.minTemperature)"
                self.cloudPercentageLabel.text = "\(currentWeather.cloudPercent)%"
            })
            
            
        }
        
        if let threeHoursWeather = threeHoursWeather{
            threeHoursWeather.getThreeHoursWeatherData({
                self.collectionView.reloadData()
            })
            
        }
        
        if let dailyWeather = dailyWeather {
            dailyWeather.getDailyWeatherData({
                self.tableView.reloadData()
            })
        }
        
    }
    
    
    func getCityName(location  :CLLocation,completion : (cityName : String)->()){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first {
                if let cityName = placemark.administrativeArea {
                    print(cityName)
                    completion(cityName: cityName)
                }
                print(placemark)
            }
        }
        
    }
    
    
    @IBAction func settings(sender : AnyObject) {
        
        performSegueWithIdentifier("settings", sender: nil)
    
    }

    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        updateUI()
    }
    
    
}

//------------------------------------------------------------------------
extension ViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first{
            if !isUpdated {
                print("______________________________________________________________")
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                getCityName(location, completion: { (cityName) in
                    ApiCall.City = "q=\(cityName)"
                    ApiCall.Location = "lat=\(latitude)&lon=\(longitude)"
                    self.currentWeather = CurrentWeather(url: ApiCall.CurrentWeatherWithLocation)
                    
                    self.threeHoursWeather = ThreeHoursWeather(url: ApiCall.ThreeHourForecastWithLocation)
                    self.dailyWeather = DailyWeather(url: ApiCall.DailyForecastWithLocation)
                    
                    self.isUpdated = true
                    self.updateUI()
                self.containerView.hidden = false
                })
                
            
            }
            
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.debugDescription)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }else if status == .Denied {
            print("Denied")
            let alertController = UIAlertController(
                title: "Uygulamaya izin vermediniz!",
                message: "Hava durumunu öğrenebilmek için lütfen ayarlardan konum erişimine izin veriniz!",
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "İptal", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Ayarları Aç", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
    }
    
    
}

//------------------------------------------------------------------------
extension ViewController : UITableViewDelegate , UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableViewCell") as! DailyForecastTableViewCell
        if let data = dailyWeather?.dailyForecastDatas[indexPath.row] {
            cell.configureCell(data)
        }
     
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dailyWeather != nil {
            return (dailyWeather?.dailyForecastDatas.count)!
            
        }else {
            return 1
        }
    }
    
}
//------------------------------------------------------------------------
extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if threeHoursWeather != nil {
            return (threeHoursWeather?.threeHoursWeatherDatas.count)!
        }else {
            return 1
        }
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCell", forIndexPath: indexPath) as! ThreeHoursFCollectionViewCell
        if let data = threeHoursWeather?.threeHoursWeatherDatas[indexPath.row] {
            cell.configureCell(data)
        }
      
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(80, 100)
    }
    
}
