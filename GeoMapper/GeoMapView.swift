//
//  GridLineMapView.swift
//  GeoMapper
//
//  Created by Ashesh Patel on 2024-11-10.
//
import Turf
import SwiftUI

struct GeoMapView: View {
  var geoJSONObject: GeoJSONObject?
 
  var body: some View {
    MapView(geoJSONObject: geoJSONObject)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          NavigationLink {
            GridLineView(geoJSONObject: geoJSONObject)
          } label: {
            Text("Add Grid Line")
          }
        }
      }
  }
}

