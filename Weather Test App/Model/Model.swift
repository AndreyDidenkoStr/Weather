//
//  Model.swift
//  Weather Test App
//
//  Created by Andrey Kapitalov on 20.12.2022.
//

// MARK: Main Model
struct MainModel: Codable, Hashable {
    
    var dt: Double
    var name: String
    var weather: [MainWeather]
    var main: MainTemp
    var timezone: Double
}

struct MainTemp: Codable, Hashable {
    var temp: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Int
    var humidity: Int
    var feels_like: Double
}

struct MainWeather: Codable, Hashable {
    var icon: String
    var description: String
}

// MARK: - Hourly Model
struct HourlyModel: Codable, Hashable {
    var list: [ListElement]
}

struct ListElement: Codable, Hashable {
    var dt: Double
    var main: MainTemp
    var weather: [MainWeather]
}

// MARK: - Weekly Model
struct WeeklyModel: Codable, Hashable {
    var list: [ListElement]
}

// MARK: - Information Model
struct InformationModel: Codable, Hashable {
    var timezone: Double
    var sys: Sys
    var main: MainTemp
    var visibility: Int
    var wind: Wind
}

struct Sys: Codable, Hashable {
    var sunrise: Double
    var sunset: Double
}

struct Wind: Codable, Hashable {
    var speed: Double
}
