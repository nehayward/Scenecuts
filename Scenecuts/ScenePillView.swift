import SwiftUI

struct ScenePillView: View {
    var body: some View {
        HStack {
            Image(systemName: "flame.fill")
            Text("Cozy")
        }
        .padding()
        .background(.clear)
//        .background {
//            Capsule()
//                .foregroundStyle(.ultraThinMaterial)
//        }
    }
}


#Preview {
    ScenePillView()
}
