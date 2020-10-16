//
//  TextRecognitionManager.swift
//  MacroPepelelipa
//
//  Created by Leonardo Oliveira on 16/10/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import Vision

internal class TextRecognitionManager {
    
    // MARK: - Variables and Constants
    
    private var currentBuffer: CVPixelBuffer?
    private var results: [VNRecognizedTextObservation]?
    private var image: CIImage?
    private var requestHandler: VNImageRequestHandler?
    private var resultTextRecognition = String()
    
    private lazy var textRecognitionRequest: VNRecognizeTextRequest = {
        let textRecognition = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        textRecognition.recognitionLanguages = ["pt-BR", "en-US"]
        textRecognition.usesLanguageCorrection = true
        textRecognition.recognitionLevel = .accurate
        textRecognition.usesCPUOnly = true
        return textRecognition
    }()
    
    // MARK: - Functions
    
    /**
     With the image that the user sends, this method transforms this image into a CIImage and creates the requestHandler, calling another function, performOCRRequest().
     If the image can't be converted into a CIImage, the text recognition request is canceled. The result of the request, our string, is then returned.
     - Parameter image: the image that the user requested be recognized.
     - Returns: A String with the result of the text recognition.
     */
    internal func imageRequest(toImage image: UIImage) -> String {
        if let ciImage = CIImage(image: image) {
            requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            
            performOCRRequest()
        } else {
            textRecognitionRequest.cancel()
            requestHandler = nil
        }
        
        return resultTextRecognition
    }
    
    /**
     This method executes the textRecognitionRequest. If it does not work, it will return the error with the localize description.
     */
    private func performOCRRequest() {
        do {
            try self.requestHandler?.perform([self.textRecognitionRequest])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /**
     This method obtains the results that the text recognition request aquires.
     - Parameter request: the actual request being made;
     - Parameter error: error that might happen.
     */
    private func recognizeTextHandler(request: VNRequest, error: Error?) {
        self.results = self.textRecognitionRequest.results as? [VNRecognizedTextObservation]
        
        if let results = self.results {
            var transcript: String = ""
            for observation in results {
                transcript.append(observation.topCandidates(1)[0].string)
                transcript.append(" ")
            }
            resultTextRecognition = transcript
        }
    }
}

