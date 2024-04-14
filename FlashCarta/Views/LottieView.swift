import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    
    var animationFileName: String
    var animationView: LottieAnimationView?
    let loopMode: LottieLoopMode
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
         let view = UIView(frame: .zero)
         
         let animationView = LottieAnimationView()
         let animation = LottieAnimation.named(animationFileName)

         animationView.animation = animation
         animationView.contentMode = .scaleAspectFit
         animationView.loopMode = loopMode
         animationView.play()
         
         animationView.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(animationView)
         
         NSLayoutConstraint.activate([
             animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
             animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
         ])
         
         return view
     }
}
