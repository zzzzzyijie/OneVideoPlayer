//
//  WKWebView+JExtension.swift
//  JianxiaozhiAI
//
//  Created by Jie on 2020/10/22.
//  Copyright © 2020 Jie. All rights reserved.
//

import WebKit


public extension WKWebView {
    // 适应加载html
    func fit_loadHTMLString(htmlText: String) {
        let htmlHeader = "<!DOCTYPE html><html><head><meta charset=utf-8><meta http-equiv=X-UA-Compatible content=\"IE=edge\"><meta name=viewport content=\"width=device-width,initial-scale=1,user-scalable=no\"><link rel=\"stylesheet\" href=\"https://cdn1.jianzhikeji.com/static/libs/quill.css\"></head><body><div style='width:100%;position:relative'>"
        let htmlFooter = "</div></body><html/>"
        let html = htmlHeader + htmlText + htmlFooter
        let fitHtml = html.replacingOccurrences(of: "<img", with: "<img style=\"display:block; height: auto; width:100%;text-align:center\"")
        loadHTMLString(fitHtml, baseURL: nil)
    }
}


public extension WKWebView { // 依赖 WebViewPrintRenderer.swift
    // webView 截图
    func webSnapshot() -> UIImage? {
        let renderer = WebViewPrintRenderer(formatter: self.viewPrintFormatter(), contentSize: self.scrollView.contentSize)
        return renderer.printContentToImage()
    }
}
