//
//  MapView 2.swift
//  GeoMapper
//
//  Created by Ashesh Patel on 2024-11-10.
//
import SwiftUI
import MapKit
import Turf

struct GridLineMapView: UIViewRepresentable {
  var geoJSONObject: GeoJSONObject?
 
  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.delegate = context.coordinator
 
    if let overlays = geoJSONObject?.overlays {
      mapView.addOverlays(overlays)
      if let region = geoJSONObject?.region(topOffset: 10, bottomOffset: 10, leftoffset: 10, rightOffset: -10) {
        mapView.setRegion(region, animated: true)
      }
    }
  
    
    return mapView
  }
  
  func updateUIView(_ uiView: MKMapView, context: Context) {
   
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: NSObject, MKMapViewDelegate {
    var parent: GridLineMapView
    
    init(_ parent: GridLineMapView) {
      self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      if let polygon = overlay as? MKPolygon {
        let renderer = MKPolygonRenderer(polygon: polygon)
        renderer.strokeColor = UIColor.systemOrange
        renderer.fillColor = UIColor.systemOrange.withAlphaComponent(0.2)
        renderer.lineWidth = 2
        return renderer
      }  else if let multiPolygon = overlay as? MKMultiPolygon {
        let renderer = MKMultiPolygonRenderer(multiPolygon: multiPolygon)
        renderer.strokeColor = UIColor.systemGreen
        renderer.fillColor = UIColor.systemGreen.withAlphaComponent(0.2)
        renderer.lineWidth = 2
        return renderer
      } else {
        return MKOverlayRenderer(overlay: overlay)
      }
    }
  }
}
