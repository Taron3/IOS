//
//  ViewController.swift
//  TableView
//
//  Created by Narek Safaryan on 10/24/19.
//  Copyright © 2019 Narek Safaryan. All rights reserved.
//

import UIKit


struct MaskJson: Codable {
    let iconURL: String
    let locKey: String
    let resourceID: String
    let blendMode: String
    let orientation: String
    
    enum CodingKeys: String, CodingKey {
         case iconURL = "icon_url"
         case locKey = "loc_key"
         case resourceID = "resource_id"
         case blendMode = "blendMode"
         case orientation = "orientation"
     }
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableData = [MaskJson]()
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let path = Bundle.main.path(forResource: "mask", ofType: "json"),
            let json = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
            let jsonData = try? JSONDecoder().decode([MaskJson].self, from: json) else {
                return
        }
        
        tableData = jsonData
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cellId")
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! CustomCell
         
        config(cell, for: indexPath)
        
        return cell
    }
    
    func config(_ cell: CustomCell, for indexPath: IndexPath) {
        let maskJson = tableData[indexPath.row]
        
        let url: String = maskJson.iconURL
        cell.tag = indexPath.row
        
        let loader = ImageLoader(with: url) { [weak cell] (image) in
            
            if let cell = cell, cell.tag == indexPath.row {
                cell.textLabel?.text = maskJson.locKey
                cell.imageView?.image = image
            }
            
        }

        cell.setImageLoader(loader)
    }
}



// MARK: - CustomCell
class CustomCell: UITableViewCell {
    var imageLoader: ImageLoader?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageLoader(_ loader: ImageLoader) {
        imageLoader?.cancel()
        imageView?.image = nil
        
        imageLoader = loader
        imageLoader?.load()
    }
    
    override func prepareForReuse() {
        textLabel?.text = nil
        imageView?.image = nil
    }
}



// MARK: - ImageLoader
class ImageLoader {
    var urlString: String!
    var completionBlock: ((UIImage?) -> Void)?
    
    init(with url: String, completion: @escaping (UIImage?) -> Void) {
        urlString = url
        completionBlock = completion
    }
    
    func load() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(downloadComplete),
                                               name: NSNotification.Name.init("download-success"),
                                               object: nil)
        Downloader.shared.download(urlString: urlString)
    }
    
    @objc func downloadComplete(note: NSNotification) {
        guard let info = note.userInfo,
            let url = info["url"] as? String,
            url == urlString else {
            return
        }
                
        let img = info["image"] as? UIImage
        if let block = completionBlock {
            block(img)
        }
    }
    
    func cancel() {
        NotificationCenter.default.removeObserver(self)
        completionBlock = nil
    }
}


// MARK: - Downloader
class Downloader {
    static let shared = Downloader()
    
    func download(urlString: String) {
        guard let imageName = urlString.split(separator: "/").last,
            let documentDirectoryURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
                return
        }
        let imagesURL = documentDirectoryURL.appendingPathComponent(String(imageName))
        
        DispatchQueue.global().async {
            var data = Data()
            if FileManager.default.fileExists(atPath: imagesURL.path) {
                data = try! Data(contentsOf: imagesURL)
            } else {
                guard let imageData = try? Data(contentsOf: URL(string: urlString)!) else {
                    return
                }
                data = imageData
                try? data.write(to: imagesURL)
            }
            
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                var info = [String: Any]()
                info["image"] = image
                info["url"] = urlString
                NotificationCenter.default.post(name: NSNotification.Name.init("download-success"),
                                                object: nil,
                                                userInfo: info)
            }
        }
        
    }
    
    
}



