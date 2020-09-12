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
    
    enum TextStrings: String {
        case weatherInformationFailed = "weatherInformationFailed_text"
        case reacquisition = "reacquisition_text"
        case ok = "ok_text"
    }
    
    private let key = "&appid=e9ade01ff87c33b0a59707b99c1bf421"
    private let url = "https://api.openweathermap.org/data/2.5/weather?q="
    private let imageUrl = "https://openweathermap.org/img/wn/"
    private let highest = "HighestTemperature(↑):"
    private let lowest = "LowestTemperature(↓):"
    private let humidity = "Humidity:"
    
    var status: Status = .none
    
    var whetherResult: WhetherResult?
    
    var baseColor: UIColor { UIColor(red: 220/255, green: 223/255, blue: 223/255, alpha: 100/100) }
    var symbolColor: UIColor { UIColor(red: 113/255, green: 107/255, blue: 107/255, alpha: 100/100) }
    
    var setUrl: String { (self.url + "\(HomeViewModel.cityString ?? .empty),jp" + self.key) }
    var getImageUrl: String { (self.imageUrl + "\(self.whetherResult?.icon ?? .empty)@2x.png") }
    var getWhetherMain: String { self.whetherResult?.main ?? .empty }
    var getTemperature: String { "\(floor(self.whetherResult?.temp ?? 0.0) / 10)°" }
    var getHighestTemperature: String { self.highest + "\(floor(self.whetherResult?.temp_max ?? 0.0) / 10)°" }
    var getLowestTemperature: String { self.lowest + "\(floor(self.whetherResult?.temp_min ?? 0.0) / 10)°" }
    var getHumidity: String { self.humidity + "\(self.whetherResult?.humidity ?? 0.0)%" }
    var getDetailsLabelText: String { (("\(self.getHighestTemperature)\n") + "\(self.getLowestTemperature)\n") + self.getHumidity }
    var getCityName: String { self.whetherResult?.cityName ?? .empty }
    var haveYouAlreadyDone: Bool { UserDefaults.standard.bool(forKey: "prefectures") }
    
    static private var cityString: String? {
        get { UserDefaults.standard.string(forKey: "city") }
        set { UserDefaults.standard.set(newValue, forKey: "city") }
    }
    
    func textString(_ key: TextStrings) -> String { .LocalizedString(key.rawValue, tableName: "Diary") }
    func deletaCityString() { UserDefaults.standard.removeObject(forKey: "city") }
    
    static func setPrefectures(set: Bool) { UserDefaults.standard.set(set, forKey: "Home") }
    static func setCity(city: String?) { self.cityString = city }
    
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
            return try decoder.decode(WeatherResponse.self, from: data)
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
