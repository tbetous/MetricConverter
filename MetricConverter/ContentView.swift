//
//  ContentView.swift
//  MetricConverter
//
//  Created by Thomas Betous on 31/12/2023.
//

import SwiftUI

enum MetricType: String, CaseIterable, Identifiable {
    case temperature = "Temperature"
    case length = "Length"
    case duration = "Duration"
    case volume = "Volume"
    
    var id: Self { self }
}

struct ContentView: View {
    let temperatureUnits: [UnitTemperature] = [UnitTemperature.celsius, UnitTemperature.fahrenheit, UnitTemperature.kelvin]
    let lengthUnits: [UnitLength] = [UnitLength.meters, UnitLength.kilometers, UnitLength.feet, UnitLength.yards, UnitLength.miles]
    let durationUnits: [UnitDuration] = [UnitDuration.seconds, UnitDuration.minutes, UnitDuration.hours]
    let volumeUnits: [UnitVolume] = [UnitVolume.milliliters, UnitVolume.liters, UnitVolume.cups, UnitVolume.pints, UnitVolume.gallons]
    
    @State private var metricType: MetricType = .temperature
    @State private var valueUnit: Dimension = UnitTemperature.celsius
    @State private var conversionUnit: Dimension = UnitTemperature.fahrenheit
    @State private var value: Double = 0
    @FocusState private var valueIsFocused: Bool
    
    var units: [Dimension] {
        switch metricType {
        case .temperature:
            return temperatureUnits
        case .length:
            return lengthUnits
        case .duration:
            return durationUnits
        case .volume:
            return volumeUnits
        }
        
    }
    
    var conversion: Measurement<Dimension> {
        return Measurement(value: value, unit: valueUnit).converted(to: conversionUnit)
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Which type of metric to convert?") {
                    Picker("Select metric type", selection: $metricType) {
                        ForEach(MetricType.allCases) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                }
                
                Section("What value should be converted from?") {
                    TextField("Value", value: $value, format: .number)
                        .focused($valueIsFocused)
                        .keyboardType(.decimalPad)
                    Picker("Select unit type", selection: $valueUnit) {
                        ForEach(units, id: \.self.symbol) {
                            Text($0.symbol).tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("What it should be converted to?") {
                    Picker("Select unit type", selection: $conversionUnit) {
                        ForEach(units, id: \.self.symbol) {
                            Text($0.symbol).tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Result") {
                    Text("The result is : \(conversion.formatted())")
                }
            }
            .navigationTitle("Metric converter")
            .onChange(of: metricType) {
                valueUnit = units[0]
                conversionUnit = units[1]
            }
            .toolbar {
                if valueIsFocused {
                    Button("Done") {
                        valueIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
