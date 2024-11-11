import SwiftUI
import Turf

struct GridLineView: View {
  var geoJSONObject: GeoJSONObject?

  var body: some View {
    VStack {
      GridLineMapView(geoJSONObject: geoJSONObject)
    }
  }
}

#Preview {
  GridLineView()
}
