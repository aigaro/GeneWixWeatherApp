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
var weatherPlaceDefault = 0

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherData()
        date1Button.layer.backgroundColor = UIColor.lightGray.cgColor
        windRange.isHidden = false
        placePicker.delegate = self
        placePicker.dataSource = self
        placePicker.isHidden = false
        if weatherPlace > 5 {
            phenomenon.isHidden = true
            temperature.isHidden = true
            weatherImage.isHidden = true
            weatherPlace = 5
        }

    }
    
        override func viewDidAppear(_ animated: Bool) {
            if let defaultPlace = UserDefaults.standard.integer(forKey: "defaultPlace") as? Int {
                self.placePicker.selectRow(defaultPlace, inComponent: 0, animated: true)
            }

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
        weatherPlace = row
        weatherPlaceDefault = row
        UserDefaults.standard.set(row, forKey: "defaultPlace")

        weatherData()
    }
    
    //Add guard statement. Why does it not work?
    //    guard let xmlTwo = Alamofire.request("https://www.ilmateenistus.ee/ilma_andmed/xml/forecast.php").responseString().data else {
    //    return
    //    }
    
    @IBAction func buttonPress(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            date = 0
            resetBGColor()
            date1Button.layer.backgroundColor = UIColor.lightGray.cgColor
            windRange.isHidden = false
            placePicker.isHidden = false
            phenomenon.isHidden = false
            temperature.isHidden = false
            weatherImage.isHidden = false

        case 1:
            date = 1
            resetBGColor()
            date2Button.layer.backgroundColor = UIColor.lightGray.cgColor
            windRange.isHidden = true
            placePicker.isHidden = true
            phenomenon.isHidden = true
            temperature.isHidden = true
            weatherImage.isHidden = true

        case 2:
            date = 2
            resetBGColor()
            date3Button.layer.backgroundColor = UIColor.lightGray.cgColor
            windRange.isHidden = true
            placePicker.isHidden = true
            phenomenon.isHidden = true
            temperature.isHidden = true
            weatherImage.isHidden = true
            
        case 3:
            date = 3
            resetBGColor()
            date4Button.layer.backgroundColor = UIColor.lightGray.cgColor
            windRange.isHidden = true
            placePicker.isHidden = true
            phenomenon.isHidden = true
            temperature.isHidden = true
            weatherImage.isHidden = true
            
        default:
            return
        }
        weatherData()
    }
    
    func resetBGColor() {
        for button_bg in [date1Button, date2Button, date3Button, date4Button] {
            button_bg?.layer.backgroundColor = nil
        }
    }
    
    func weatherData() {
        
        if let weatherPlaceDefault = UserDefaults.standard.integer(forKey: "defaultPlace") as? Int {
            weatherPlace = weatherPlaceDefault
        }
        
        let parsedData =  SWXMLHash.parse(self.xmlTwo!)
        guard abs(weather.tempMinDay) < 51 && abs(weather.tempMaxDay) < 51 && abs(weather.tempMinNight) < 51 && abs(weather.tempMaxNight) < 51 else {return}
        
        weather.tempMinDay = Int(parsedData["forecasts"]["forecast"][date]["day"]["tempmin"].element!.text!)!
        weather.tempMaxDay = Int(parsedData["forecasts"]["forecast"][date]["day"]["tempmax"].element!.text!)!
        weather.weatherTextDay = parsedData["forecasts"]["forecast"][date]["day"]["text"].element!.text!
        weather.tempMinNight = Int(parsedData["forecasts"]["forecast"][date]["night"]["tempmin"].element!.text!)!
        weather.tempMaxNight = Int(parsedData["forecasts"]["forecast"][date]["night"]["tempmax"].element!.text!)!
        weather.weatherTextNight = parsedData["forecasts"]["forecast"][date]["night"]["text"].element!.text!
        
        if date == 0 {
        phenomenon.isHidden = false
        temperature.isHidden = false
        weatherImage.isHidden = false
        }
        
        if weatherPlace > 5 {
            phenomenon.isHidden = true
            temperature.isHidden = true
            weatherImage.isHidden = true
            weatherPlace = 5
        }
        
        weather.weatherPlacePhenomenonDay = parsedData["forecasts"]["forecast"][0]["day"]["place"][weatherPlace]["phenomenon"].element!.text!
        weather.weatherPlacePhenomenonNight = parsedData["forecasts"]["forecast"][0]["night"]["place"][weatherPlace]["phenomenon"].element!.text!
        weather.weatherPlaceTemperatureNight = Int(parsedData["forecasts"]["forecast"][0]["night"]["place"][weatherPlace]["tempmin"].element!.text!)!
        weather.weatherPlaceTemperatureDay = Int(parsedData["forecasts"]["forecast"][0]["day"]["place"][weatherPlace]["tempmax"].element!.text!)!
        
        self.temperature.text = "\(weather.weatherPlaceTemperatureNight) kuni \(weather.weatherPlaceTemperatureDay) "
        self.phenomenon.text = "Päeval on \(weather.weatherDictionary[weather.weatherPlacePhenomenonDay]!.lowercased()) \n Öösel on \(weather.weatherDictionary[weather.weatherPlacePhenomenonNight]!.lowercased())"
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
