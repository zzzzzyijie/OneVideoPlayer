//
//  WebViewPrintRenderer.swift
//  JianxiaozhiAI
//
//  Created by Jie on 2020/11/17.
//  Copyright © 2020 Jie. All rights reserved.
//

import Foundation

//  --------- WebView截图 ----------

public class WebViewPrintRenderer: UIPrintPageRenderer {
    
    // Formatter
    private var formatter: UIPrintFormatter
    // contentSize
    private var contentSize: CGSize
    
    
    required init(formatter: UIPrintFormatter, contentSize: CGSize) {
        self.formatter = formatter
        self.contentSize = contentSize
        super.init()
        self.addPrintFormatter(formatter, startingAtPageAt: 0)
    }
    
    public override var paperRect: CGRect {
        return CGRect(origin: .zero, size: contentSize)
    }
    
    public override var printableRect: CGRect {
        return CGRect(origin: .zero, size: contentSize)
    }
    
    private func printContentToPDFPage() -> CGPDFPage? {
        let data = NSMutableData()
        UIGraphicsBeginPDFContextToData(data, self.paperRect, nil)
        self.prepare(forDrawingPages: NSMakeRange(0, 1))
        let bounds = UIGraphicsGetPDFContextBounds()
        UIGraphicsBeginPDFPage()
        self.drawPage(at: 0, in: bounds)
        UIGraphicsEndPDFContext()

        let cfData = data as CFData
        guard let provider = CGDataProvider(data: cfData) else {
            return nil
        }
        let pdfDocument = CGPDFDocument(provider)
        let pdfPage = pdfDocument?.page(at: 1)

        return pdfPage
    }
    
    private func covertPDFPageToImage(_ pdfPage: CGPDFPage) -> UIImage? {
        let pageRect = pdfPage.getBoxRect(.trimBox)
        let contentSize = CGSize(width: floor(pageRect.size.width), height: floor(pageRect.size.height))
        
        UIGraphicsBeginImageContextWithOptions(contentSize, true, 2.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        context.setFillColor(UIColor.white.cgColor)
        context.setStrokeColor(UIColor.white.cgColor)
        context.fill(pageRect)

        context.saveGState()
        context.translateBy(x: 0, y: contentSize.height)
        context.scaleBy(x: 1.0, y: -1.0)

        context.interpolationQuality = .low
        context.setRenderingIntent(.defaultIntent)
        context.drawPDFPage(pdfPage)
        context.restoreGState()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
    
    public func printContentToImage() -> UIImage? {
        guard let pdfPage = self.printContentToPDFPage() else {
            return nil
        }

        let image = self.covertPDFPageToImage(pdfPage)
        return image
    }
}
