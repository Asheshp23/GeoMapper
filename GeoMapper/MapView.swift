//
//  MapView.swift
//  GeoMapper
//
//  Created by Ashesh Patel on 2024-10-23.
//
import SwiftUI
import MapKit
import Turf

struct MapView: UIViewRepresentable {
  var geoJSONObject: GeoJSONObject?
  
  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.delegate = context.coordinator
    if let overlays = geoJSONObject?.overlays {
      mapView.addOverlays(overlays)
      if let region = geoJSONObject?.region {
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
    var parent: MapView
    
    init(_ parent: MapView) {
      self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      if let polygon = overlay as? MKPolygon {
        let renderer = MKPolygonRenderer(polygon: polygon)
        renderer.strokeColor = UIColor.systemOrange
        renderer.fillColor = UIColor.systemOrange.withAlphaComponent(0.2)
        renderer.lineWidth = 2
        return renderer
      } else if let polyline = overlay as? MKPolyline {
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.systemBlue
        renderer.lineWidth = 3
        return renderer
      } else if let multiPolygon = overlay as? MKMultiPolygon {
        let renderer = MKMultiPolygonRenderer(multiPolygon: multiPolygon)
        renderer.strokeColor = UIColor.systemGreen
        renderer.fillColor = UIColor.systemGreen.withAlphaComponent(0.2)
        renderer.lineWidth = 2
        return renderer
      } else if let multiPolyline = overlay as? MKMultiPolyline {
        let renderer = MKMultiPolylineRenderer(multiPolyline: multiPolyline)
        renderer.strokeColor = UIColor.systemPurple
        renderer.lineWidth = 3
        return renderer
      } else {
        return MKOverlayRenderer(overlay: overlay)
      }
    }
  }
}
