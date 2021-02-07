//
//  ViewController.swift
//  Drawing-iOS
//
//  Created by Prasan Dhareshwar on 1/10/21.
//

import UIKit
import PencilKit
import PhotosUI

class ViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver {

    @IBOutlet weak var canvasView: PKCanvasView!
    
    @IBOutlet weak var pencilFingerButton: UIBarButtonItem!
    
    var toolPicker: PKToolPicker!
    
    let canvasWidth: CGFloat = 768
    let canvasOverscrollHeight : CGFloat = 500
    
    var drawing = PKDrawing()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvasView.delegate = self
        canvasView.drawing = drawing
        
        canvasView.alwaysBounceVertical = true
        canvasView.drawingPolicy = .anyInput
        
        if #available(iOS 14.0, *) {
            toolPicker = PKToolPicker()
        } else {
            // Set up the tool picker, using the window of our parent because our view has not
            // been added to a window yet.
            let window = parent?.view.window
            toolPicker = PKToolPicker.shared(for: window!)
        }
//        let toolPicker = PKToolPicker.init()
        
        toolPicker.addObserver(canvasView)
        toolPicker.setVisible(true, forFirstResponder: canvasView)
            
        canvasView.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let canvasScale = canvasView.bounds.width / canvasWidth
        canvasView.minimumZoomScale = canvasScale
        canvasView.maximumZoomScale = canvasScale
        canvasView.zoomScale = canvasScale
        
        updateContentSizeForDrawing()
        
        canvasView.contentOffset = CGPoint(x: 0, y: -canvasView.adjustedContentInset.top)
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    @IBAction func toggleFingerOrPencil(_ sender: Any) {
//        canvasView.allowsFingerDrawing.toggle()
        canvasView.drawingPolicy = .default
        pencilFingerButton.title = canvasView.drawingPolicy == .anyInput ? "Finger": "Pencil"
    }

    @IBAction func saveDrawingToCameraRoll(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(canvasView.bounds.size, false, UIScreen.main.scale)
        
        canvasView.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if image != nil {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image!)
            }, completionHandler: {success, error in
                
            })
        }
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        updateContentSizeForDrawing()
    }
    
    func updateContentSizeForDrawing(){
        let drawing = canvasView.drawing
        let contentHeight: CGFloat
        
        if !drawing.bounds.isNull {
            contentHeight = max(canvasView.bounds.height, (drawing.bounds.maxY + self.canvasOverscrollHeight) * canvasView.zoomScale)
        }
        else {
            contentHeight = canvasView.bounds.height
        }
        
        canvasView.contentSize = CGSize(width: canvasWidth * canvasView.zoomScale, height: contentHeight)
    }
    
}

