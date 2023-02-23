//
//  VideoViewController.swift
//  Novigation
//
//  Created by Александр Хмыров on 05.10.2022.
//

import UIKit
import AVFoundation

protocol VideoViewControllerOutput {
    func playPauseVideo(videoViewController: VideoViewController)

    func stopVideo()
}


class VideoViewController: UIViewController {

    private var videos: [String] = ["Record", "record2", "Siberia"]

    private var fotos: [String] = ["photo_1", "photo_2", "photo_3"]

    private var cells: [VideoViewControllerOutput] = []

    private lazy var tableViewVideo: UITableView = {
        var tableViewVideo = UITableView()
        tableViewVideo.delegate = self
        tableViewVideo.dataSource = self
        tableViewVideo.translatesAutoresizingMaskIntoConstraints = false
        tableViewVideo.register( VideoTableViewCell.self, forCellReuseIdentifier: VideoTableViewCell.name)
        tableViewVideo.backgroundColor = UIColor(named: "grey")
        return tableViewVideo
    }()



    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableViewVideo)

        view.backgroundColor = UIColor(named: "grey")

        let safeAria = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            tableViewVideo.topAnchor.constraint(equalTo: safeAria.topAnchor),
            tableViewVideo.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor),
            tableViewVideo.trailingAnchor.constraint(equalTo: safeAria.trailingAnchor),
            tableViewVideo.bottomAnchor.constraint(equalTo: safeAria.bottomAnchor),
        ])
    }


    func reloadTableViewVideo() {
        tableViewVideo.reloadData()
    }


    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        cells.forEach {  $0.stopVideo() }
    }
}



extension VideoViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableViewVideo.dequeueReusableCell(withIdentifier: VideoTableViewCell.name, for: indexPath) as? VideoTableViewCell, fotos.count - 1 >= indexPath.row, videos.count - 1 >= indexPath.row
        else { return UITableViewCell() }

        cell.setupVideoTableViewCell(nameVideo: videos[indexPath.row], nameFoto: fotos[indexPath.row], videoViewController: self)
        cells.append(cell)
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        400
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = cells[indexPath.row]

        cell.playPauseVideo(videoViewController: self)

    }
}


