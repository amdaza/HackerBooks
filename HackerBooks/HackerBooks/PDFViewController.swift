//
//  PDFViewController.swift
//  HackerBooks
//
//  Created by Alicia Daza on 12/07/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController, UIWebViewDelegate {

    // MARK: - Properties
    var model: Book

    @IBOutlet weak var browser: UIWebView!

    @IBOutlet weak var activityView: UIActivityIndicatorView!


    // MARK: - Initialization
    init(model: Book) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Sync
    func syncModelWithView() {
        self.browser.delegate = self
        
        activityView.startAnimating()
        
        // Get data by default
        if let pdf = model.pdf {
            let savedData = pdf.pdfData as Data!

            browser.load(savedData!, mimeType: "application/pdf",
                     textEncodingName: "UTF-8", baseURL: URL(string: "https://google.com")! )
        

            // Load real data if not loaded
            if (!pdf.loaded){
                if let urlString = model.pdf?.remoteUrl,
                    let url = URL(string: urlString),
                    let pdfData = try? Data(contentsOf: url){
                
                    browser.load(pdfData, mimeType: "application/pdf",
                             textEncodingName: "UTF-8", baseURL: URL(string: "https://google.com")! )
                    
                    pdf.pdfData = pdfData as NSData
                    pdf.loaded = true
                }
            }
        }
    }


    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Subscribe notification
        let nc = NotificationCenter.default

        // My version
        nc.addObserver(self, selector: #selector(PDFViewController.bookDidChange(_:)), name: NSNotification.Name(rawValue: BookDidChangeNotification), object: nil)

        // New version
        //nc.addObserver(self, selector: @selector(bookDidChange), name: BookDidChangeNotification, object: nil)

        syncModelWithView()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        // Stop activity view
        activityView.stopAnimating()

        // Hide it
        activityView.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Unsubscribe from all notifications
        let nc = NotificationCenter.default
        nc.removeObserver(self)

    }

    // MARK: - Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func bookDidChange(_ notification: Notification) {

        // Get user info
        let info = (notification as NSNotification).userInfo!

        // Get book
        let book = info[BookKey] as? Book

        // Reload model
        model = book!

        // Sync
        syncModelWithView()
    }





}
