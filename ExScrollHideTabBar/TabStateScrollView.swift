//
//  TabStateScrollView.swift
//  ExScrollHideTabBar
//
//  Created by 심성곤 on 9/17/24.
//

import SwiftUI

// https://www.youtube.com/watch?v=Q0rb4M6n2ns
/// 스크롤 할 때 탭바 사라지는 스크롤 뷰
struct TabStateScrollView<Content: View>: View {
    var axis: Axis.Set
    var showsIndicator: Bool
    @Binding var tabState: Visibility
    var content: Content
    init(axis: Axis.Set, showsIndicator: Bool, tabState: Binding<Visibility>, @ViewBuilder content: @escaping () -> Content) {
        self.axis = axis
        self.showsIndicator = showsIndicator
        self._tabState = tabState
        self.content = content()
    }
    
    var body: some View {
        ScrollView(axis) {
            content
        }
        .background {
            CustomGesture {
                handleTabState($0)
            }
        }
        .scrollIndicators(showsIndicator ? .visible : .hidden)
    }
    
    func handleTabState(_ gesture: UIPanGestureRecognizer) {
        //let offesetY = gesture.translation(in: gesture.view).y
        let velocityY = gesture.velocity(in: gesture.view).y
        if velocityY < 0 {
            if -(velocityY / 5) > 60 && tabState == .visible {
                tabState = .hidden
            }
        } else {
            if (velocityY / 5) > 40 && tabState == .hidden {
                tabState = .visible
            }
        }
    }
}

fileprivate struct CustomGesture: UIViewRepresentable {
    var onChange: (UIPanGestureRecognizer) -> ()
    
    private let gestureID = "CUSTOMGESTRUE"
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onChange: onChange)
    }
    
    func makeUIView(context: Context) -> some UIView {
        .init()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let superView = uiView.superview?.superview,
               !(superView.gestureRecognizers?.contains(where: { $0.name == gestureID }) ?? false) {
                let gesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.gestureChange(gesture:)))
                gesture.name = gestureID
                gesture.delegate = context.coordinator
                superView.addGestureRecognizer(gesture)
            }
        }
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var onChange: (UIPanGestureRecognizer) -> ()
        
        init(onChange: @escaping (UIPanGestureRecognizer) -> ()) {
            self.onChange = onChange
        }
        
        @objc
        func gestureChange(gesture: UIPanGestureRecognizer) {
            onChange(gesture)
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            true
        }
    }
}

#Preview {
    ContentView()
}

