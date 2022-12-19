//
//  ViewModel.swift
//  Weather Test App
//
//  Created by Andrey Kapitalov on 18.12.2022.
//
import SwiftUI

// MARK: - ViewModel
class ViewModel: ObservableObject {
    
    @Published var searchText = ""
    @Published var mainData: [MainModel] = []
    @Published var detailData: MainModel?
    @Published var hourlyData: HourlyModel?
    @Published var weeklyData: WeeklyModel?
    @Published var informationData: InformationModel?
    
    var weeklyArrayData: [ListElement] {
        weeklyData?.list.compactMap({ element in
            element
        }) ?? []
        }
    
    var weeklyArray: [ListElement] {
        weeklyArrayData.filter { unixToDateHH(time: $0.dt) == "15" }
    }
    
    var hourlyArrayData: [ListElement] {
        hourlyData?.list.compactMap({ HourlyElement in
            HourlyElement
        }) ?? []
        }
    
    var filteredMainData: [MainModel] {
        mainData.filter { element in
                searchText.isEmpty ? true : element.name.lowercased().contains(searchText.lowercased())
            }
        }
    
    // MARK: Functions
    func unixToDateHH(time: Double) -> String {
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH"
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
    
    func dayOfWeek(time: Double) -> String {
            let date = Date(timeIntervalSince1970: time)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date).capitalized
        }
    
    // MARK: createMainData
    func createMainData() {
        for element in cityList {
            mainFetch(city: element)
        }
    }
    
    // MARK: mainFetch
    func mainFetch(city: String) {
        let fetchCity = city.replacingOccurrences(of: " ", with: "%20")
        let stringUrl = "http://api.openweathermap.org/data/2.5/weather?q=\(fetchCity)&units=metric&appid=5d4e113a1e03af59c17a0fa8c33e4a89"
        guard let url = URL(string: stringUrl) else { return }
        let tast = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let decodeData = try JSONDecoder().decode(MainModel.self, from: data)
                DispatchQueue.main.async {
                    self?.mainData.append(decodeData)
                }
            } catch {
                print("error JSON decoder")
            }
        }
        tast.resume()
    }
    
    // MARK: detailFetch
    func detailFetch(city: String) {
        let fetchCity = city.replacingOccurrences(of: " ", with: "%20")
        let stringUrl = "http://api.openweathermap.org/data/2.5/weather?q=\(fetchCity)&units=metric&appid=5d4e113a1e03af59c17a0fa8c33e4a89"
        guard let url = URL(string: stringUrl) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let decodeData = try JSONDecoder().decode(MainModel?.self, from: data)
                DispatchQueue.main.async {
                    self?.detailData = decodeData
                }
            } catch {
                print("error JSON decoder")
            }
        }
        task.resume()
    }
    
    // MARK: - weeklyFetch
    func weeklyFetch(city: String) {
        let fetchCity = city.replacingOccurrences(of: " ", with: "%20")
        let stringUrl = "http://api.openweathermap.org/data/2.5/forecast?q=\(fetchCity)&units=metric&APPID=c49f2a5b07ce03250befb407c4410be3"
        guard let url = URL(string: stringUrl) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let decodeData = try JSONDecoder().decode(WeeklyModel?.self, from: data)
                DispatchQueue.main.async {
                    self?.weeklyData = decodeData
                }
            } catch {
                print("error JSON decoder")
            }
        }
        task.resume()
    }
    
    // MARK: - hourlyFetch
    func hourlyFetch(city: String) {
        let fetchCity = city.replacingOccurrences(of: " ", with: "%20")
        let stringUrl = "http://api.openweathermap.org/data/2.5/forecast?q=\(fetchCity)&exclude=daily,minutely,current,alerts&units=metric&appid=5d4e113a1e03af59c17a0fa8c33e4a89"
        guard let url = URL(string: stringUrl) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let decodeData = try JSONDecoder().decode(HourlyModel?.self, from: data)
                DispatchQueue.main.async {
                    self?.hourlyData = decodeData
                }
            } catch {
                print("error JSON decoder")
            }
        }
        task.resume()
    }
    
    // MARK: - informationFetch
    func informationFetch(city: String) {
        let fetchCity = city.replacingOccurrences(of: " ", with: "%20")
        let stringUrl = "http://api.openweathermap.org/data/2.5/weather?q=\(fetchCity)&units=metric&APPID=c49f2a5b07ce03250befb407c4410be3"

        guard let url = URL(string: stringUrl) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let decodeData = try JSONDecoder().decode(InformationModel?.self, from: data)
                DispatchQueue.main.async {
                    self?.informationData = decodeData
                }
            } catch {
                print("error JSON decoder")
            }
        }
        task.resume()
    }
}

