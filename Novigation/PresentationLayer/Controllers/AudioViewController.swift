//
//  AudioViewController.swift
//  Novigation
//
//  Created by Александр Хмыров on 04.10.2022.
//

import UIKit
import AVFoundation


class AudioViewController: UIViewController {

    private var play: Bool = false

    private var tracks: [String] = ["Tinlicker_Robert_Miles_-_Children", "Paul_Van_Dyk_Aly_Fila_-_SHINE_Ibiza_Anthem", "Ben_Gold_-_Xtravaganza", "Armin_van_Buuren_Wrabel_-_Feel_Again", "Armin_van_Buuren_-_In_And_Out_Of_Love"]

    private var numberTrack: Int = 0

    private lazy var player: AVPlayer = {
        var player = AVPlayer()
        var url = Bundle.main.url(forResource: self.tracks[self.numberTrack], withExtension: "mp3")
        guard
            let urlAudio = url
        else {
            return AVPlayer()
        }
        player = AVPlayer(url: urlAudio)
        return player
    }()


    private lazy var playerLayer: AVPlayerLayer = {
        var playerLayer = AVPlayerLayer(player: self.player)
        return playerLayer
    }()


    private lazy var audioPlayerView: UIView = {
        var audioPlayerView = UIView()
        audioPlayerView.backgroundColor = .black
        audioPlayerView.translatesAutoresizingMaskIntoConstraints = false
        audioPlayerView.layer.addSublayer(playerLayer)
        return audioPlayerView
    }()


    private lazy var labelTrackName: UILabel = {
        var labelTrackName = UILabel()
        labelTrackName.text = self.tracks[self.numberTrack]
        labelTrackName.translatesAutoresizingMaskIntoConstraints = false
        labelTrackName.textColor = .white
        labelTrackName.numberOfLines = 0
        labelTrackName.clipsToBounds = true
        return labelTrackName
    }()


    private lazy var buttonPlayPauseAudio: UIButton = {
        let action = UIAction { action in
            guard self.play == false
            else  {
                self.player.pause()
                self.play = false
                return
            }
            self.player.play()
            self.play = true
        }
        var buttonPlayPauseAudio = UIButton(primaryAction: action)
        buttonPlayPauseAudio.setTitle( "buttonPlayPauseAudio".audioViewControllerLocalizable , for: .normal)
        buttonPlayPauseAudio.translatesAutoresizingMaskIntoConstraints = false
        buttonPlayPauseAudio.backgroundColor = UIColor(named: "grey")
        buttonPlayPauseAudio.layer.cornerRadius = 12

        buttonPlayPauseAudio.setTitleColor( UIColor(named: "orange"), for: .selected)
        return buttonPlayPauseAudio
    }()


    private lazy var buttonStopPlay: UIButton = {
        let action = UIAction { _ in
            self.player.seek(to: CMTime.zero)
            self.player.pause()
            self.play = false
        }
        var buttonStopPlay = UIButton(primaryAction: action)
        buttonStopPlay.setTitle( "buttonStopPlay".audioViewControllerLocalizable, for: .normal)
        buttonStopPlay.backgroundColor = UIColor(named: "grey")
        buttonStopPlay.layer.cornerRadius = 12
        buttonStopPlay.setTitleColor(UIColor(named: "orange"), for: .selected)
        buttonStopPlay.translatesAutoresizingMaskIntoConstraints = false
        return buttonStopPlay
    }()


    private lazy var buttonTrackBack: UIButton = {
        var action = UIAction { _ in
            if self.numberTrack > 0 {
                self.player.pause()
                var url = Bundle.main.url(forResource: self.tracks[self.numberTrack - 1], withExtension: "mp3" )
                self.numberTrack -= 1
                self.player = AVPlayer(url: url!)
                self.player.play()
                self.labelTrackName.text = self.tracks[self.numberTrack]
            }
            else { return }
        }
        var buttonTrackBack = UIButton(primaryAction: action)
        buttonTrackBack.setTitle("buttonTrackBack".audioViewControllerLocalizable, for: .normal)
        buttonTrackBack.backgroundColor = UIColor(named: "grey")
        buttonTrackBack.layer.cornerRadius = 12
        buttonTrackBack.setTitleColor(UIColor(named: "orange"), for: .normal)
        buttonTrackBack.translatesAutoresizingMaskIntoConstraints = false
        return buttonTrackBack
    }()


    private lazy var buttonTrackForward: UIButton = {
        var action = UIAction { _ in

            if self.tracks.count - 1 > self.numberTrack {
                self.player.pause()
                var url = Bundle.main.url(forResource: self.tracks[self.numberTrack + 1], withExtension: "mp3" )
                self.numberTrack += 1
                self.player = AVPlayer(url: url!)
                self.player.play()
                self.labelTrackName.text = self.tracks[self.numberTrack]
            }
            else { return }
        }
        var buttonTrackForward = UIButton(primaryAction: action)
        buttonTrackForward.setTitle("buttonTrackForward".audioViewControllerLocalizable, for: .normal)
        buttonTrackForward.backgroundColor = UIColor(named: "grey")
        buttonTrackForward.layer.cornerRadius = 12
        buttonTrackForward.setTitleColor(UIColor(named: "orange"), for: .normal)
        buttonTrackForward.translatesAutoresizingMaskIntoConstraints = false
        return buttonTrackForward
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(audioPlayerView)
        audioPlayerView.addSubview(buttonPlayPauseAudio)
        audioPlayerView.addSubview(buttonStopPlay)
        audioPlayerView.addSubview(labelTrackName)
        audioPlayerView.addSubview(buttonTrackBack)
        audioPlayerView.addSubview(buttonTrackForward)

        setupConstrains()
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.playerLayer.frame = self.audioPlayerView.bounds
    }



    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.player.pause()
    }


    func setupConstrains() {

        let safeAria = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            audioPlayerView.topAnchor.constraint(equalTo: safeAria.topAnchor),
            audioPlayerView.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor),
            audioPlayerView.trailingAnchor.constraint(equalTo: safeAria.trailingAnchor),
            audioPlayerView.bottomAnchor.constraint(equalTo: safeAria.bottomAnchor),


            labelTrackName.topAnchor.constraint(equalTo: audioPlayerView.topAnchor, constant: 100),
            labelTrackName.centerXAnchor.constraint(equalTo: audioPlayerView.centerXAnchor),

            buttonPlayPauseAudio.centerYAnchor.constraint(equalTo: audioPlayerView.centerYAnchor),
            buttonPlayPauseAudio.centerXAnchor.constraint(equalTo: audioPlayerView.centerXAnchor),

            buttonTrackBack.centerYAnchor.constraint(equalTo: buttonPlayPauseAudio.centerYAnchor),
            buttonTrackBack.trailingAnchor.constraint(equalTo: buttonPlayPauseAudio.leadingAnchor, constant: -20),

            buttonTrackForward.leadingAnchor.constraint(equalTo: buttonPlayPauseAudio.trailingAnchor, constant: 20),
            buttonTrackForward.centerYAnchor.constraint(equalTo: buttonPlayPauseAudio.centerYAnchor),


            buttonStopPlay.centerXAnchor.constraint(equalTo: buttonPlayPauseAudio.centerXAnchor),
            buttonStopPlay.topAnchor.constraint(equalTo: buttonPlayPauseAudio.bottomAnchor, constant: 20),
        ])
    }
}



extension String {
    var audioViewControllerLocalizable: String {
        return NSLocalizedString(self, tableName: "AudioViewControllerLocalizable", comment: "")
    }
}
