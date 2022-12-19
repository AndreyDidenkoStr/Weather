//
//  DetailView.swift
//  Weather Test App
//
//  Created by Andrey Kapitalov on 09.12.2022.
//

import SwiftUI

struct DetailView: View {
    
    // MARK: - with dismiss controller
    @Environment(\.presentationMode) var presentationMode
    
    var city: String = ""
    @StateObject var viewModel = ViewModel()
    @State var offsetY: CGFloat = 0
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                let safeAreaTop = proxy.safeAreaInsets.top
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        VStack {
                            HeaderView(safeAreaTop, cityName: viewModel.detailData?.name ?? "",
                                       temp: viewModel.detailData?.main.temp ?? 0.0,
                                       description: viewModel.detailData?.weather[0].description ?? "",
                                       hightemp: viewModel.detailData?.main.temp_max ?? 0.0,
                                       lowTemp: viewModel.detailData?.main.temp_min ?? 0.0)
                                .padding(.top)
                                .offset(y: -offsetY)
                                
                        }
                        .zIndex(1)
 
                        VStack(alignment: .leading) {
                            ForEach(viewModel.weeklyArray, id: \.self) { element in
                                WeekViewElement(time: element.dt, icon: element.weather[0].icon, hTemp: element.main.temp_max, lTemp: element.main.temp_min)
                            }
                        }
                        Rectangle()
                            .foregroundColor(.white)
                            .opacity(0.4)
                            .frame(height: 0.5)
                        
                        // Text plase
                        HStack {
                            Text("Cloudy conditions will continue all day. Wind gusts are up ti 9 mph.")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.white)
                                
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        Rectangle()
                            .foregroundColor(.white)
                            .opacity(0.4)
                            .frame(height: 0.5)
                        
                        // Information blocks
                        InformationBlockView(leftName: ConstantsString.sunrise.rawValue,
                                             leftValue: unixToDateTimeZone(time: viewModel.informationData?.sys.sunrise ?? 0.0),
                                             rightName: ConstantsString.sunset.rawValue,
                                             rightValue: unixToDateTimeZone(time: viewModel.informationData?.sys.sunset ?? 0.0))
                        
                        InformationBlockView(leftName: ConstantsString.speed.rawValue,
                                             leftValue: "\(viewModel.informationData?.wind.speed ?? 0.0) ms",
                                             rightName: ConstantsString.visibility.rawValue,
                                             rightValue: "\(viewModel.informationData?.visibility ?? 0) m")
                        
                        InformationBlockView(leftName: ConstantsString.pressure.rawValue,
                                             leftValue: "\(viewModel.informationData?.main.pressure ?? 0) kPa",
                                             rightName: ConstantsString.humidity.rawValue,
                                             rightValue: "\(viewModel.informationData?.main.humidity ?? 0) %")
                        
                        InformationBlockView(leftName: ConstantsString.feels_like.rawValue,
                                             leftValue: "\(viewModel.informationData?.main.feels_like ?? 0) º",
                                             rightName: "",
                                             rightValue: "")
                    }
                    .offset(coordinateSpace: .named("SCROLL")) { offset in
                        offsetY = offset
                    }
                }
            }
            .coordinateSpace(name: "SCROLL")
            .background(.blue)
            .ignoresSafeArea(.all)
            .onAppear {
                fetchAllData(city: city)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image("back")
                        .resizable()
                        .frame(width: 25, height: 25)
                    }
                
            }
        }
    }
    
    // MARK: Functions
    func fetchAllData(city: String) {
        viewModel.detailFetch(city: city)
        viewModel.hourlyFetch(city: city)
        viewModel.weeklyFetch(city: city)
        viewModel.informationFetch(city: city)
    }
    
    func unixToDateTimeZone(time: Double) -> String {
        let offset = Int(viewModel.informationData?.timezone ?? 0.0)
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: offset)
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
    
    // MARK: - ViewBuilder
    @ViewBuilder
    func InformationBlockView(leftName: String, leftValue: String, rightName: String, rightValue: String) -> some View {
            HStack() {
                HStack {
                    VStack(alignment: .leading) {
                                    Text(leftName)
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(.white)
                                        .opacity(0.5)
                                    Text("\(leftValue)")
                                        .font(.system(size: 28, weight: .regular))
                                        .foregroundColor(.white)
                            }
                    .padding(.leading, 20)
                        Spacer()
                }
                .frame(maxWidth: .infinity)
                HStack {
                    VStack(alignment: .leading) {
                                Text(rightName)
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(.white)
                                    .opacity(0.5)
                                Text("\(rightValue)")
                                    .font(.system(size: 28, weight: .regular))
                                    .foregroundColor(.white)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            Rectangle()
                .foregroundColor(.white)
                .opacity(0.4)
                .frame(height: 0.5)
        }

    @ViewBuilder
    func WeekViewElement(time: Double,
                         icon: String,
                         hTemp: Double,
                         lTemp: Double) -> some View {
        
        let dayOfWeek = viewModel.dayOfWeek(time: time)
        HStack {
            Text("\(dayOfWeek)")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.white)
                    .frame(width: 120, alignment: .leading)
            Spacer()
            HStack {
                Image(icon)
                    .resizable()
                    .frame(width: 42, height: 42)
                    .padding(.trailing)
                Text("50%")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(uiColor: UIColor(red: 0.486, green: 0.812, blue: 0.976, alpha: 1)))
            }
            Spacer()
            HStack {
                Text("\(String(format: "%.F", hTemp))")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 45, alignment: .trailing)
                Text("\(String(format: "%.F", lTemp))")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color(uiColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)))
                    .frame(width: 40, alignment: .trailing)
            }
                
        }
        .padding(.leading, 13)
        .padding(.top, 3)
        .padding(.trailing)
    }
    
    @ViewBuilder
    func HourleView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Rectangle()
                .foregroundColor(.white)
                .opacity(0.4)
                .frame(height: 0.5)
            HStack(spacing: 25) {
                ForEach(viewModel.hourlyArrayData, id: \.self) { element in
                    HourlyCard(time: element.dt, icon: element.weather[0].icon, temp: element.main.temp)
                }
            }
            .padding(.top, 4)
            .padding(.leading)
            .padding(.trailing)
            Rectangle()
                .foregroundColor(.white)
                .opacity(0.4)
                .frame(height: 0.5)
        }
    }
    
    @ViewBuilder
    func HourlyCard(time: Double,
                    icon: String,
                    temp: Double) -> some View {
        VStack {
            Text(unixToDateTimeZone(time: time))
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
            Image(icon)
                .resizable()
                .foregroundColor(.yellow)
                .frame(width: 42, height: 42)
                .padding(.bottom, 5)
            Text("\(String(format: "%.F", temp))º")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .padding(.leading, 5)
        }
    }
    
    @ViewBuilder
    func HeaderView(_ safeAreaTop: CGFloat,
                    cityName: String,
                    temp: Double,
                    description: String,
                    hightemp: Double,
                    lowTemp: Double) -> some View {
        let progress = -(offsetY / 200) > 1 ? -1 : (offsetY > 0 ? 0 : (offsetY / 200))
        HStack {
            VStack {
                Text("\(cityName)")
                    .font(.system(size: 34, weight: .regular,design: .default))
                    .foregroundColor(.white)
                ZStack(alignment: .top ) {
                    Text("\(String(format: "%.F", temp))º | \(description.capitalized)")
                        .font(.system(size: 20, weight: .regular, design: .default))
                        .foregroundColor(.white)
                        .opacity(0 - progress)
                    VStack {
                        Text("\(String(format: "%.F", temp))º")
                            .font(.system(size: 96, weight: .thin, design: .default))
                            .foregroundColor(.white)
                            .padding(.leading)
                        Text("\(description.capitalized)")
                            .font(.system(size: 20, weight: .regular, design: .default))
                            .foregroundColor(.white)
                        HStack {
                            Text("H:\(String(format: "%.F", hightemp))º")
                                .font(.system(size: 20, weight: .regular, design: .default))
                                .foregroundColor(.white)
                            Text("L:\(String(format: "%.F", lowTemp))º")
                                .font(.system(size: 20, weight: .regular, design: .default))
                                .foregroundColor(.white)
                        }
                    }
                    .opacity(1 + progress)
                    .padding(.bottom, 50)
                }
                HourleView()
                    .offset(y: progress * 190)
            }
        }
        .background {
            Rectangle()
                .fill(.blue)
                .padding(.top, -50)
                .padding(.bottom, -progress * 190)
        }
        .ignoresSafeArea(.all)
        .padding(.top, safeAreaTop + 30)
    }
}

// MARK: - PreviewProvider
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}

// MARK: - Offset Preference Key
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Offset View Extension
extension View {
    @ViewBuilder
    func offset(coordinateSpace: CoordinateSpace, completion: @escaping (CGFloat) -> ()) -> some View {
        self.overlay {
            GeometryReader { proxy in
                let minY = proxy.frame(in: coordinateSpace).minY
                Color.clear
                    .preference(key: OffsetKey.self,value: minY)
                    .onPreferenceChange(OffsetKey.self) { value in
                        completion(value)
                    }
            }
        }
    }
}

