//
//  VideoTableViewCell.swift
//  Novigation
//
//  Created by Александр Хмыров on 05.10.2022.
//

import UIKit
import AVFoundation

protocol NameClass {
    static var name: String { get }
}

class VideoTableViewCell: UITableViewCell {

    private var play: Bool = false

    private var videoViewController: VideoViewController?

    private var videoImageView: UIImageView = {
        var videoImageView = UIImageView()
        videoImageView.translatesAutoresizingMaskIntoConstraints = false
        videoImageView.contentMode = .scaleAspectFit
        return videoImageView
    }()

    private var player: AVPlayer?

    private var playerLayer: AVPlayerLayer?

    private lazy var videoPlayerView: UIView = {
        var videoPlayerView = UIView()
        videoPlayerView.backgroundColor = .black
        videoPlayerView.translatesAutoresizingMaskIntoConstraints = false
        videoPlayerView.layer.cornerRadius = 20
        videoPlayerView.layer.masksToBounds = true
        return videoPlayerView
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor(named: "grey")

        videoPlayerView.addSubview(videoImageView)
        contentView.addSubview(videoPlayerView)


        NSLayoutConstraint.activate([
            videoPlayerView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            videoPlayerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            videoPlayerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            videoPlayerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),

            videoImageView.centerYAnchor.constraint(equalTo: videoPlayerView.centerYAnchor),
            videoImageView.widthAnchor.constraint(equalTo: videoPlayerView.widthAnchor),
            videoImageView.heightAnchor
                .constraint(equalTo: videoPlayerView.widthAnchor)
        ])
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer!.frame = self.videoPlayerView.bounds
    }


    override func awakeFromNib() {
        super.awakeFromNib()
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


    func setupVideoTableViewCell(nameVideo: String, nameFoto: String, videoViewController: VideoViewController) {

        videoImageView.image = UIImage(named: nameFoto)

        self.videoViewController = videoViewController

        player = AVPlayer(url: Bundle.main.url(forResource:  nameVideo, withExtension: "mp4")!)
        playerLayer = AVPlayerLayer(player: player)
        videoPlayerView.layer.addSublayer(playerLayer!)
    }
}


extension VideoTableViewCell: NameClass {
    static var name: String {
        return String(describing: self)
    }
}


extension VideoTableViewCell: VideoViewControllerOutput {

    func stopVideo() {
        player?.pause()
    }

    func playPauseVideo(videoViewController: VideoViewController) {

        guard
            play == false
        else  {
            player!.pause()
            play = false
            return
        }
        player!.play()
        play = true
        videoImageView.isHidden = true
    }


}
