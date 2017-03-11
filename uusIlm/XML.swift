//
//  XML.swift
//  uusIlm
//
//  Created by Aigar on 22/02/17.
//  Copyright © 2017 Aigar. All rights reserved.
//

import UIKit
import SWXMLHash

struct WeatherData:  XMLIndexerDeserializable {
    
    var temperatureArray: [String] = ["null", "üks", "kaks", "kolm", "neli", "viis", "kuus", "seitse", "kaheksa", "üheksa", "kümme", "üksteist", "kaksteist", "kolmteist", "neliteist", "viisteist", "kuusteist", "seitseteist", "kaheksateist", "üheksateist", "kakskümmend", "kakskümmend üks", "kakskümmend kaks", "kakskümmend kolm", "kakskümmend neli", "kakskümmend viis", "kakskümmend kuus", "kakskümmend seitse", "kakskümmend kaheksa", "kakskümmend üheksa", "kolmkümmend", "kolmkümmend üks", "kolmkümmend kaks", "kolmkümmend kolm", "kolmkümmend neli", "kolmkümmend viis", "kolmkümmend kuus", "kolmkümmend seitse", "kolmkümmend kaheksa", "kolmkümmend üheksa", "nelikümmend", "nelikümmend üks", "nelikümmend kaks", "nelikümmend kolm", "nelikümmend neli", "nelikümmend viis", "nelikümmend kuus", "nelikümmend seitse", "nelikümmend kaheksa", "nelikümmend üheksa", "viiskümmend"]
    
    var weatherDictionary: [String:String] = ["Clear": "Selge", "Few clouds": "Vähene pilvisus", "Variable clouds": "Vahelduv pilvisus", "Cloudy with clear spells": "Pilves selgimistega", "Cloudy": "Pilves", "Light snow shower": "Nõrk hooglumi", "Moderate snow shower": "Mõõdukas hooglumi", "Heavy snow shower": "Tugev hooglumi", "Light shower": "Nõrk hoogvihm", "Moderate shower": "Mõõdukas hoogvihm", "Heacy shower": "Tugev hoogvihm", "Light rain": "Nõrk vihm", "Moderate rain": "Mõõdukas vihm", "Heavy rain": "Tugev vihm", "Risk of glaze": "Jäiteoht", "Light sleet": "Nõrk lörtsisadu", "Moderate sleet": "Mõõdukas lörtsisadu", "Light snowfall": "Nõrk lumesadu", "Moderate snowfall": "Mõõdukas lumesadu", "Heavy snowfall": "Tugev lumesadu", "Snowstorm": "Lumetuisk", "Drifting snow": "Pinnatuisk", "Hail": "Rahe", "Mist": "Uduvine", "Fog": "Udu", "Thunder": "Äike", "Thunderstorm": "Äikesevihm"]
    
    var weatherPlaces: [String] = ["Harku", "Jõhvi", "Tartu", "Pärnu", "Kuressaare", "Türi", "Kuusiku", "Väike-Maarja", "Võrtsjärv"]
    
    var tempMinDay = Int()
    var tempMaxDay = Int()
    var weatherTextDay = String()
    var arrayMin = [Int]()
    var arrayMax = [Int]()
    
    var tempMinNight = Int()
    var tempMaxNight = Int()
    var weatherTextNight = String()
    
    
    var weatherDate = [String]()
    var chosenDate = [String]()
    
    var weatherPlacePhenomenonDay = String()
    var weatherPlacePhenomenonNight = String()
    
    var weatherPlaceTemperatureNight = Int()
    var weatherPlaceTemperatureDay = Int()
    
    var testString = String()
    
    
}

