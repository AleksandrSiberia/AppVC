//
//  VideoViewController.swift
//  Novigation
//
//  Created by Александр Хмыров on 05.10.2022.
//

import UIKit
import AVFoundation



class VideoViewController: UIViewController {

    private var videos: [String] = []


    private lazy var tableViewVideo: UITableView = {
        var tableViewVideo = UITableView()
        tableViewVideo.delegate = self
        tableViewVideo.dataSource = self
        tableViewVideo.translatesAutoresizingMaskIntoConstraints = false
        tableViewVideo.register( VideoTableViewCell.self, forCellReuseIdentifier: VideoTableViewCell.name)
        tableViewVideo.backgroundColor = .orange
        return tableViewVideo
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableViewVideo)
        


        NSLayoutConstraint.activate([
            self.tableViewVideo.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableViewVideo.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableViewVideo.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableViewVideo.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      
        ])
    }
}



extension VideoViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
 //       self.videos.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewVideo.dequeueReusableCell(withIdentifier: VideoTableViewCell.name, for: indexPath) as! VideoTableViewCell
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }


}


