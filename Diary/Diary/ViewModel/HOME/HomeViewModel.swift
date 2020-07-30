//
//  HomeViewModel.swift
//  Diary
//
//  Created by futami on 2020/07/23.
//  Copyright © 2020 futami. All rights reserved.
//

import UIKit
import RxSwift

class HomeViewModel {
    enum Status {
        case success
        case error
        case none
    }
    
    private let key = "&appid=e9ade01ff87c33b0a59707b99c1bf421"
    private let url = "https://api.openweathermap.org/data/2.5/weather?q="
    private let imageUrl = "https://openweathermap.org/img/wn/"
    
    var status: Status = .none
    
    var whetherResult: WhetherResult?
    
    var baseColor: UIColor {
        return UIColor(red: 220/255, green: 223/255, blue: 223/255, alpha: 100/100)
    }
    
    var symbolColor: UIColor {
        return UIColor(red: 113/255, green: 107/255, blue: 107/255, alpha: 100/100)
    }
    
    var setUrl: String {
        print((self.url + "\(HomeViewModel.cityString ?? ""),jp" + self.key))
        return (self.url + "\(HomeViewModel.cityString ?? ""),jp" + self.key)
    }
    
    var getImageUrl: String {
        return (self.imageUrl + "\(self.whetherResult?.icon ?? "")@2x.png")
    }
    
    var getWhetherMain: String {
        return self.whetherResult?.main ?? ""
    }
    
    var getTemperature: String {
        return "\(floor(self.whetherResult?.temp ?? 0.0) / 10)°"
    }
    
    static private var cityString: String? {
        get {
            UserDefaults.standard.string(forKey: "city")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "city")
        }
    }
    
    var getHighestTemperature: String {
        return "HighestTemperature(↑): \(floor(self.whetherResult?.temp_max ?? 0.0) / 10)°"
    }
    
    var getLowestTemperature: String {
        return "LowestTemperature(↓): \(floor(self.whetherResult?.temp_min ?? 0.0) / 10)°"
    }
    
    var getHumidity: String {
        return "Humidity: \(self.whetherResult?.humidity ?? 0.0)%"
    }
    
    var getDetailsLabelText: String {
        return (("\(self.getHighestTemperature)\n") + "\(self.getLowestTemperature)\n") + self.getHumidity
    }
    
    var getCityName: String {
        return self.whetherResult?.cityName ?? ""
    }
    
    var haveYouAlreadyDone: Bool {
        return UserDefaults.standard.bool(forKey: "prefectures")
    }
    
    static func setPrefectures(set: Bool) {
        UserDefaults.standard.set(set, forKey: "prefectures")
    }
    
    func deletaCityString() {
        UserDefaults.standard.removeObject(forKey: "city")
    }
    
    static func setCity(city: String?) {
        self.cityString = city
    }
    
    func getWhether() -> Observable<Data> {
        return Observable.create { observer in
            if let apiUrl = URL(string: self.setUrl) {
                let task = URLSession(configuration: .default)
                    .dataTask(with: URLRequest(url: apiUrl)) { data, response, error in
                        defer { observer.onCompleted() }
                        guard let data = data else {
                            self.status = .error
                            return
                        }
                        guard let response = self.pase(data: data) else {
                            self.status = .error
                            return
                        }
                        self.upDataWhetherResult(response: response)
                        self.status = .success
                }
                task.resume()
            }
            return Disposables.create()
        }
    }
    
    func pase(data: Data) -> WeatherResponse? {
        let decoder = JSONDecoder()
        do {
            let decode = try decoder.decode(WeatherResponse.self, from: data)
            return decode
        } catch {
            return nil
        }
    }
    
    func upDataWhetherResult(response: WeatherResponse) {
        response.weather.forEach {
        self.whetherResult = WhetherResult(temp: response.main.temp,
                                           temp_min: response.main.temp_min,
                                           temp_max: response.main.temp_max,
                                           humidity: response.main.humidity,
                                           main: $0.main,
                                           icon: $0.icon,
                                           cityName: response.name)
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
