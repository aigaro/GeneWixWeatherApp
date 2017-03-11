//
//  ViewController.swift
//  uusIlm
//
//  Created by Aigar on 22/02/17.
//  Copyright © 2017 Aigar. All rights reserved.
//
import UIKit
import Alamofire
import Alamofire_Synchronous
import SWXMLHash

var weather = WeatherData()
var date = 0
var weatherPlace = 0
var weatherInt = 0

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherData()
        date1Button.layer.backgroundColor = UIColor.lightGray.cgColor
        windRange.isHidden = false
        placePicker.delegate = self
        placePicker.dataSource = self
    }
    
    //pickerView
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weather.weatherPlaces.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return weather.weatherPlaces[row]
        
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        weatherInt = row
       print(weatherInt)
        weatherPlace = row
        weatherData()
    }
    
    
    //Add guard statement. func() needed? What type of variable is XMLIndexer?
//    guard if let Alamofire.request("https://www.ilmateenistus.ee/ilma_andmed/xml/forecast.php").responseString().data else {return}
    let xmlTwo = Alamofire.request("https://www.ilmateenistus.ee/ilma_andmed/xml/forecast.php").responseString().data
    
    @IBOutlet weak var dayTemp: UILabel!
    @IBOutlet weak var nightTemp: UILabel!
    @IBOutlet weak var dayText: UILabel!
    @IBOutlet weak var nightText: UILabel!
    @IBOutlet weak var descriptionDay: UILabel!
    @IBOutlet weak var descriptionNight: UILabel!
    @IBOutlet weak var windRange: UILabel!
    @IBOutlet weak var date1Button: UIButton!
    @IBOutlet weak var date2Button: UIButton!
    @IBOutlet weak var date3Button: UIButton!
    @IBOutlet weak var date4Button: UIButton!
    @IBOutlet weak var placePicker: UIPickerView!
    @IBOutlet weak var phenomenon: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBAction func buttonPress(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            date = 0
            reset_bg_color()
            date1Button.layer.backgroundColor = UIColor.lightGray.cgColor
            windRange.isHidden = false
        case 1:
            date = 1
            reset_bg_color()
            date2Button.layer.backgroundColor = UIColor.lightGray.cgColor
            windRange.isHidden = true
        case 2:
            date = 2
            reset_bg_color()
            date3Button.layer.backgroundColor = UIColor.lightGray.cgColor
            windRange.isHidden = true
        case 3:
            date = 3
            reset_bg_color()
            date4Button.layer.backgroundColor = UIColor.lightGray.cgColor
            windRange.isHidden = true
        default:
            return
        }
        weatherData()
    }
    
    func reset_bg_color() {
        for button_bg in [date1Button, date2Button, date3Button, date4Button] {
            button_bg?.layer.backgroundColor = nil
        }
    }
    
    func weatherData() {
        
        let parsedData =  SWXMLHash.parse(self.xmlTwo!)
        guard abs(weather.tempMinDay) < 51 && abs(weather.tempMaxDay) < 51 && abs(weather.tempMinNight) < 51 && abs(weather.tempMaxNight) < 51 else {return}
        
        weather.tempMinDay = Int(parsedData["forecasts"]["forecast"][date]["day"]["tempmin"].element!.text!)!
        weather.tempMaxDay = Int(parsedData["forecasts"]["forecast"][date]["day"]["tempmax"].element!.text!)!
        weather.weatherTextDay = parsedData["forecasts"]["forecast"][date]["day"]["text"].element!.text!
        
        weather.tempMinNight = Int(parsedData["forecasts"]["forecast"][date]["night"]["tempmin"].element!.text!)!
        weather.tempMaxNight = Int(parsedData["forecasts"]["forecast"][date]["night"]["tempmax"].element!.text!)!
        weather.weatherTextNight = parsedData["forecasts"]["forecast"][date]["night"]["text"].element!.text!
        
        guard weatherPlace < 6 else {return} // last three don't have temp, app crashes
        
        weather.weatherPlacePhenomenonDay = parsedData["forecasts"]["forecast"][date]["day"]["place"][weatherPlace]["phenomenon"].element!.text!
        weather.weatherPlacePhenomenonNight = parsedData["forecasts"]["forecast"][date]["night"]["place"][weatherPlace]["phenomenon"].element!.text!
        weather.weatherPlaceTemperatureNight = Int(parsedData["forecasts"]["forecast"][date]["night"]["place"][weatherPlace]["tempmin"].element!.text!)!
        weather.weatherPlaceTemperatureDay = Int(parsedData["forecasts"]["forecast"][date]["day"]["place"][weatherPlace]["tempmax"].element!.text!)!
            
        
        
        self.temperature.text = "\(weather.weatherPlaceTemperatureNight) kuni \(weather.weatherPlaceTemperatureDay) "
        self.phenomenon.text = "Päeval on \(weather.weatherDictionary[weather.weatherPlacePhenomenonDay]!) \n Öösel on \(weather.weatherDictionary[weather.weatherPlacePhenomenonNight]!)"
        weatherImage.image = UIImage(named: weather.weatherPlacePhenomenonDay)
        
        for button in [date1Button, date2Button, date3Button, date4Button] {
            button?.layer.borderWidth = 1
            button?.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        for layer in [dayTemp, nightTemp, dayText, nightText, descriptionDay, descriptionNight, windRange] {
            layer?.layer.borderWidth = 1
            
            
            for i in 0...3 {
                weather.chosenDate.append(parsedData["forecasts"]["forecast"][i].element!.attribute(by: "date")!.text)
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let date1 = formatter.date(from: weather.chosenDate[0])
            let date2 = formatter.date(from: weather.chosenDate[1])
            let date3 = formatter.date(from: weather.chosenDate[2])
            let date4 = formatter.date(from: weather.chosenDate[3])
            formatter.dateStyle = .medium
            let date1a = formatter.string(from: date1!)
            let date2a = formatter.string(from: date2!)
            let date3a = formatter.string(from: date3!)
            let date4a = formatter.string(from: date4!)
            
            self.date1Button.setTitle(date1a, for: .normal)
            self.date2Button.setTitle(date2a, for: .normal)
            self.date3Button.setTitle(date3a, for: .normal)
            self.date4Button.setTitle(date4a, for: .normal)
            
            for elem in parsedData["forecasts"]["forecast"][0]["day"]["wind"] {weather.arrayMin.append(Int( elem["speedmin"].element!.text! )!) }
            for elem in parsedData["forecasts"]["forecast"][0]["day"]["wind"] {weather.arrayMax.append(Int(elem["speedmax"].element!.text! )!) }
            
            self.windRange.text = "Tuule kiirus tänasel päeval on \(weather.arrayMin.max()!) kuni \(weather.arrayMax.max()!) m/s"
            
            switch Int(weather.tempMaxDay) {
            case -100 ... -1:
                self.dayText.text = "Päeval on külma miinus \(weather.temperatureArray[weather.tempMinDay*(-1)]) kuni \(weather.temperatureArray[weather.tempMaxDay*(-1)]) kraadi"
                self.dayTemp.text = "Päeval külma \(weather.tempMinDay) kuni \(weather.tempMaxDay) °C"
            case 0:
                self.dayText.text = "Päeval on külma miinus \(weather.temperatureArray[weather.tempMinDay*(-1)]) kuni \(weather.temperatureArray[weather.tempMaxDay]) kraadi"
                self.dayTemp.text = "Päeval on külma \(weather.tempMinDay) kuni \(weather.tempMaxDay) °C"
            case 1...100:
                switch Int(weather.tempMinDay) {
                case -100..<0:
                    self.dayText.text = "Päeval on külma miinus \(weather.temperatureArray[abs(weather.tempMinDay)]) kuni pluss \(weather.temperatureArray[weather.tempMaxDay]) kraadi"
                    self.dayTemp.text = "Päeval on külma \(weather.tempMinDay) kuni \(weather.tempMaxDay) °C"
                case 0...100:
                    self.dayText.text = "Päeval on sooja \(weather.temperatureArray[abs(weather.tempMinDay)]) kuni \(weather.temperatureArray[weather.tempMaxDay]) kraadi"
                    self.dayTemp.text = "Päeval on sooja \(weather.tempMinDay) kuni \(weather.tempMaxDay) °C"
                default:
                    return
                }
            default:
                return
            }
            
            switch Int(weather.tempMaxNight) {
            case -100 ... -1:
                self.nightText.text = "Öösel on külma miinus \(weather.temperatureArray[weather.tempMinNight*(-1)]) kuni \(weather.temperatureArray[weather.tempMaxNight*(-1)]) kraadi"
                self.nightTemp.text = "Öösel on külma \(weather.tempMinNight) kuni \(weather.tempMaxNight) °C"
            case 0:
                self.nightText.text = "Öösel on külma miinus \(weather.temperatureArray[weather.tempMinNight*(-1)]) kuni \(weather.temperatureArray[weather.tempMaxNight]) kraadi"
                self.nightTemp.text = "Öösel on külma \(weather.tempMinNight) kuni \(weather.tempMaxNight) °C"
            case 1...100:
                switch Int(weather.tempMinNight) {
                case -100..<0:
                    self.nightText.text = "Öösel on külma miinus \(weather.temperatureArray[abs(weather.tempMinNight)]) kuni pluss \(weather.temperatureArray[weather.tempMaxNight]) kraadi"
                    self.nightTemp.text = "Öösel on külma \(weather.tempMinNight) kuni \(weather.tempMaxNight) °C"
                case 0...100:
                    self.nightText.text = "Öösel on sooja \(weather.temperatureArray[weather.tempMinNight]) kuni \(weather.temperatureArray[weather.tempMaxNight]) kraadi"
                    self.nightTemp.text = "Öösel on sooja \(weather.tempMinNight) kuni \(weather.tempMaxNight) °C"
                default:
                    return
                }
            default:
                return
            }
            
            self.descriptionDay.text = "Päev. \(weather.weatherTextDay)"
            self.descriptionNight.text = "Öö. \(weather.weatherTextNight)"
        }
        
        
        
        
    }
    
    
}

