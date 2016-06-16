//
//  ViewController.swift
//  The Weather App
//
//  Created by yusuf_kildan on 14/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import UIKit
import Alamofire
import iAd
import CoreLocation
import MapKit
class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource ,CLLocationManagerDelegate,UICollectionViewDelegateFlowLayout{
    
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
    @IBOutlet weak var metricSwitch: UISwitch!
    @IBOutlet weak var banner: ADBannerView!
    @IBOutlet weak var tableView: UITableView!

    var currentWeather : CurrentWeather?
    var threeHoursWeather : ThreeHoursWeather?
    
    private let locationManager = CLLocationManager()
    private var ignoreReceivedLocation = false {
        didSet {
            if ignoreReceivedLocation == true {
                NSTimer.scheduledTimerWithTimeInterval(6, target: self,
                                                       selector: #selector(ViewController.resetLocationReceived), userInfo: nil, repeats: false)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 80, height: 100)
        flowLayout.scrollDirection = .Horizontal
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.collectionViewLayout = flowLayout
        
      
        getLocationData()
      
        

   
       
    
    }
    func updateUI(){
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

    }
    
    private func getLocationData() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        }
    }
    func getCityName(location  :CLLocation,completion : (cityName : String)->()){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                if let cityName = placemark.administrativeArea {
                   print(cityName)
                    completion(cityName: cityName)
                }
            }
        }
    
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       print("a")
        if ignoreReceivedLocation == false {
            print("b")
            if let location = manager.location {
                 getCityName(location, completion: { (cityName) in
                    
                    ApiCall.City = "q=\(cityName)"
                    self.currentWeather = CurrentWeather(url: ApiCall.CurrentWeather)
                    self.updateUI()
                 })
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                
                ApiCall.Location = "lat=\(latitude)&lon=\(longitude)"
                                threeHoursWeather = ThreeHoursWeather(url: ApiCall.ThreeHourForecastWithLocation)
               ignoreReceivedLocation = true
                updateUI()
            }
        }
       
    }

    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.debugDescription)
    }
    //Three hours - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableViewCell")!
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    //Daily Forecast - CollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if threeHoursWeather != nil {
           return (threeHoursWeather?.threeHoursWeatherDatas.count)!
        }else {
            return 0
        }
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCell", forIndexPath: indexPath) as! ThreeHoursFCollectionViewCell
            cell.configureCell((threeHoursWeather?.threeHoursWeatherDatas[indexPath.row])!)
        return cell
    }
    
    func resetLocationReceived(){
        ignoreReceivedLocation = false
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        banner.hidden = false
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        print(error.debugDescription)
        banner.hidden = true
    }
    
    

}

