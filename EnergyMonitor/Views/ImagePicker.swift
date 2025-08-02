//
//  ImagePicker.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    let onImageSelected: (UIImage) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    if let uiImage = image as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.onImageSelected(uiImage)
                        }
                    }
                }
            }
        }
    }
}
