import Lottie
import SwiftUI

struct LottieButton: UIViewRepresentable {
    @Binding var isPlaying: Bool

    var animationFileName: String
    var animationView: LottieAnimationView?
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Find the Lottie AnimationView in the subviews
        if let animationView = uiView.subviews.first(where: { $0 is LottieAnimationView }) as? LottieAnimationView {
            if isPlaying {
                animationView.play()
            } else {
                animationView.stop()
            }
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieButton>) -> UIView {
         let view = UIView(frame: .zero)
         
         let animationView = LottieAnimationView()
         let animation = LottieAnimation.named(animationFileName)

         animationView.animation = animation
         animationView.contentMode = .scaleAspectFit
         animationView.loopMode = .playOnce
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
