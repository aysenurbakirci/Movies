//
//  GIFHUD.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 22.10.2021.
//

import UIKit

final class GiFHUD: UIView {

    // MARK: Constants

    let hudSize: CGFloat = 80
    let fadeDuration: TimeInterval = 0.3
    let overlayAlpha: CGFloat = 0.3
    // swiftlint:disable:next force_cast
    var appWindow: UIWindow {
        get {
            return (UIApplication.shared.delegate?.window ?? UIWindow(frame: UIScreen.main.bounds))!
        }
    }

    // MARK: Variables
    var overlayView: UIView?
    var imageView = UIImageView()
    var shown: Bool

    // MARK: Singleton
    class var instance: GiFHUD {
        struct Static {
            static let inst: GiFHUD = GiFHUD()
        }
        return Static.inst
    }

    // MARK: Init

    init() {
        self.shown = false
        super.init(frame: CGRect(x: 0, y: 0, width: hudSize, height: hudSize))
        loadView()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: HUD
    // Show on top off window with overlay
    class func showWithOverlay() {
        guard !instance.shown else { return }
        dismiss(complate: {
            instance.appWindow.addSubview(self.instance.overlay())
            show()
        })
    }

    func loadView() {
        imageView.removeFromSuperview()
        self.removeFromSuperview()

        alpha = 0
        center = appWindow.center
        clipsToBounds = false
        layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        layer.cornerRadius = hudSize/2
        layer.masksToBounds = true
        layer.borderWidth = 2
        imageView = gifImageView()
        imageView.frame = bounds.insetBy(dx: 0, dy: 0)
        imageView.startAnimating()
        addSubview(imageView)
        appWindow.addSubview(self)
    }

    func gifImageView() -> UIImageView {
        let image = UIImageView()
        image.animationImages = (1...122).compactMap { UIImage(named: "loadingRed\($0)") }
        image.animationDuration = 3
        return image
    }

    // Show on top off window
    class func show() {
        instance.loadView()
        dismiss(complate: {
            self.instance.appWindow.bringSubviewToFront(self.instance)
            instance.shown = true
            instance.fadeInHud()
        })
    }

    // Dismiss on window
    class func dismiss() {
        guard self.instance.shown else { return }
        instance.overlay().removeFromSuperview()
        instance.fadeOutHud()
    }

    class func dismiss(complate: @escaping () -> Void) {
        guard self.instance.shown else { return complate() }

        self.instance.fadeOutHud(complated: {
            instance.overlay().removeFromSuperview()
            complate()
        })
    }

    // MARK: Effects

    func fadeInHud() {
        UIView.animate(withDuration: fadeDuration, animations: {
            self.alpha = 1
        })
    }

    func fadeOutHud() {
        self.shown = false
        UIView.animate(withDuration: fadeDuration, animations: {
            self.alpha = 0
        })
    }

    func fadeOutHud(complated: @escaping () -> Void) {
        self.shown = false
        UIView.animate(withDuration: fadeDuration, animations: {
            self.alpha = 0
        }, completion: { (_) in
            complated()
        })
    }

    func overlay() -> UIView {
        if overlayView == nil {
            overlayView = UIView(frame: appWindow.frame)
            overlayView?.backgroundColor = .black
            overlayView?.alpha = 0

            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.overlayView!.alpha = self.overlayAlpha
            })
        }
        return overlayView!
    }
}
