//
//  ContentView.swift
//  Weather Test App
//
//  Created by Andrey Kapitalov on 07.12.2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
            NavigationView {
                List(viewModel.filteredMainData, id: \.name) { item in
                    NavigationLink(destination: DetailView(city: item.name)) {
                        ExtractedView(cityName: item.name.capitalized, icon: item.weather[0].icon, temp: item.main.temp, timeZone: item.timezone)
                    }
                }
                .listStyle(.plain)
                .searchable(text: $viewModel.searchText)
                .navigationTitle("Weather")
                
            }
            .accentColor(.white)
            .onAppear {
                viewModel.createMainData()
            }
    }
}

struct ExtractedView: View {
    
    var cityName = ""
    var time = 2.0
    var icon = ""
    var temp = 0.0
    var timeZone = 0.0
    
    // MARK: - Init
    init(cityName: String, icon: String, temp: Double, timeZone: Double) {
        self.cityName = cityName
        self.icon = icon
        self.temp = temp
        self.timeZone = timeZone
    }
    
    // MARK: - Function
    func getCurrentDatefromUnixWithTimeZone(timeZone: Double) -> String {
        let offset = Int(timeZone)
        let interval = Date().timeIntervalSince1970
        let currentDate = Date(timeIntervalSince1970: interval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: offset)
        
        let stringDate = dateFormatter.string(from: currentDate)
        return stringDate
    }
    
    func temperature(temp: Double) -> String {
        return String(format: "%.F", temp)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(getCurrentDatefromUnixWithTimeZone(timeZone: timeZone))")
                    .font(.footnote)
                    .padding(.trailing)
                Text("\(cityName)")
                    .font(.system(size: 26))
                    .padding(.trailing)
            }
            Spacer()
            HStack {
                Image(icon)
                    .resizable()
                    .frame(width: 42, height: 42)
                    .padding(.trailing, 5)
                HStack {
                    Spacer()
                    Text("\(temperature(temp: temp))º")
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 40, weight: .thin))
                }
                    .frame(width: 100)
            }
        }
    }
}

// MARK: - PreviewProvider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
