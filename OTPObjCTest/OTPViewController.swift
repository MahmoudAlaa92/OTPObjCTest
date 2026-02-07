//
//  OTPViewController.swift
//  
//  Fixed version with proper state management
//

import UIKit
import SwiftUI
import Modern_OTP

@objc public class OTPViewController: UIViewController {
    
    private var hostingController: UIHostingController<OTPContainerWrapper>?
    
    @objc public var onSuccess: (() -> Void)?
    @objc public var onError: (() -> Void)?
    
    private let expectedCode: String
    private let digitCount: Int
    
    @objc public init(expectedCode: String, digitCount: Int = 4) {
        self.expectedCode = expectedCode
        self.digitCount = digitCount
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // Create wrapper view that manages its own state
        let wrapperView = OTPContainerWrapper(
            expectedCode: expectedCode,
            digitCount: digitCount,
            onSuccess: { [weak self] in
                self?.onSuccess?()
            },
            onError: { [weak self] in
                self?.onError?()
            }
        )
        
        hostingController = UIHostingController(rootView: wrapperView)
        
        if let hostingController = hostingController {
            addChild(hostingController)
            view.addSubview(hostingController.view)
            hostingController.view.frame = view.bounds
            hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            hostingController.didMove(toParent: self)
            hostingController.view.backgroundColor = .clear
        }
    }
}

// MARK: - SwiftUI Wrapper with State Management

struct OTPContainerWrapper: View {
    let expectedCode: String
    let digitCount: Int
    let onSuccess: () -> Void
    let onError: () -> Void
    
    @State private var isSuccess = false
    
    var body: some View {
        OTPContainerView(
            expectedCode: expectedCode,
            digitCount: digitCount,
            isSuccess: $isSuccess,
            onSuccess: onSuccess,
            onError: onError
        )
    }
}
