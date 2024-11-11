//
//  GeoMapperView.swift
//  GeoMapper
//
//  Created by Ashesh Patel on 2024-10-23.
//

import SwiftUI
import MapKit
import GeoJSONSwiftHelper
import Turf

struct GeoMapperView: View {
  @State private var isMapViewPresented: Bool = false
  @State private var geoJSONString: String = ""
  @State private var showAlert = false
  @State private var geoJSONObject: GeoJSONObject?
  @State private var isValidGeoJSON: Bool = false
  @State private var showErrorAlert: Bool = false
  @State private var errorMessage: String = ""
  @State private var currentRotation: CGFloat = 0 // Track rotation angle
  @State private var currentOffset: CGSize = .zero // Track offset (translation)

  
  var body: some View {
    NavigationStack {
      VStack(spacing: 20) {
        TextEditor(text: $geoJSONString)
          .frame(minHeight: 200)
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 10)
              .stroke(isValidGeoJSON ? Color.green : Color.gray, lineWidth: 1)
          )
          .padding()
          .overlay(alignment: .topTrailing) {
            if !geoJSONString.isEmpty {
              Button(action: { showAlert.toggle() }) {
                Image(systemName: "multiply.circle.fill")
                  .font(.system(size: 24))
                  .foregroundColor(.red)
                  .padding(8)
              }
            }
          }
          .onChange(of: geoJSONString) { _, _ in
            validateGeoJSON()
          }
        
        HStack {
          Button(action: pasteGeoJSON) {
            Label("Paste GeoJSON", systemImage: "doc.on.clipboard")
          }
          .buttonStyle(.bordered)
          
          NavigationLink {
            GeoMapView(geoJSONObject: geoJSONObject)
          } label: {
            Label("View on Map", systemImage: "map")
          }
          .buttonStyle(.borderedProminent)
          .disabled(!isValidGeoJSON)
        }
        
        if isValidGeoJSON {
          Text("Valid GeoJSON")
            .foregroundColor(.green)
            .font(.caption)
        }
      }
      .padding()
      .navigationTitle("GeoMapper")
      .alert(isPresented: $showAlert) {
        Alert(
          title: Text("Clear GeoJSON"),
          message: Text("Are you sure you want to clear the GeoJSON?"),
          primaryButton: .destructive(Text("Clear")) {
            geoJSONString = ""
            isValidGeoJSON = false
          },
          secondaryButton: .cancel()
        )
      }
      .alert("Error", isPresented: $showErrorAlert, presenting: errorMessage) { _ in
        Button("OK", role: .cancel) {
        
        }
      } message: { error in
        Text(error)
      }
    }
  }
  
  private func pasteGeoJSON() {
    if let pasteboardString = UIPasteboard.general.string {
      geoJSONString = pasteboardString
      validateGeoJSON()
    }
  }
  
  private func validateGeoJSON() {
    guard !geoJSONString.isEmpty else {
      isValidGeoJSON = false
      return
    }
    
    if let geoJSONObject = GeoJSONObject.create(from: geoJSONString) {
      self.geoJSONObject = geoJSONObject
      isValidGeoJSON = true
    } else {
      errorMessage = "Invalid GeoJSON format"
      isValidGeoJSON = false
      showErrorAlert = true
    }
  }
  
  private func viewItOnMap() {
    if isValidGeoJSON {
      isMapViewPresented = true
    }
  }
}

struct GeoMapperView_Previews: PreviewProvider {
  static var previews: some View {
    GeoMapperView()
  }
}
