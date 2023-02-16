//
//  PhotosTableViewCell.swift
//  Novigation
//
//  Created by Александр Хмыров on 18.06.2022.
//

import UIKit

import StorageService


class PhotosTableViewCell: UITableViewCell {


    private var widthItem: CGFloat = 0
    private var neededWidth: CGFloat = 0
    var timer: Timer?

    private enum Constraints {
        static let NumberItemInLine: CGFloat = 4
    }

    private lazy var labelCollectionPhoto: UILabel = {
        var labelCollectionPhoto = UILabel()
        labelCollectionPhoto.text = NSLocalizedString("labelCollectionPhoto", tableName: "ProfileViewControllerLocalizable", comment: "Gallery")
        labelCollectionPhoto.translatesAutoresizingMaskIntoConstraints = false
        labelCollectionPhoto.numberOfLines = 0
        labelCollectionPhoto.font = .systemFont(ofSize: 20, weight: .bold)
        return labelCollectionPhoto
    }()

    private lazy var arrow: UILabel = {
        let arrow = UILabel()
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.text = ">"
        arrow.numberOfLines = 0
        arrow.font = .systemFont(ofSize: 24, weight: .regular)
        return arrow
    }()

    private lazy var collectionFlowLayout: UICollectionViewFlowLayout = {
        var collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        collectionFlowLayout.minimumInteritemSpacing = 8
        collectionFlowLayout.scrollDirection = .horizontal
        return collectionFlowLayout
    }()

    private lazy var photoCollectionView: UICollectionView = {
        var photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionFlowLayout)
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self

        photoCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        photoCollectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.nameCollectionCell)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return photoCollectionView
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)

        self.contentView.addSubview(labelCollectionPhoto)
        self.contentView.addSubview(arrow)
        self.contentView.addSubview(photoCollectionView)

        setupConstraints()
        autoScrollCollectionView()
    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupConstraints() {

        let sectionInsetLR = collectionFlowLayout.sectionInset.left + collectionFlowLayout.sectionInset.right

        let allInteritemSpacing = collectionFlowLayout.minimumInteritemSpacing * 3

        let screenWidth = UIScreen.main.bounds.width

        let widthHeightCollection = (screenWidth - sectionInsetLR - allInteritemSpacing) / 4 + collectionFlowLayout.sectionInset.top + collectionFlowLayout.sectionInset.bottom


        print(sectionInsetLR)

        NSLayoutConstraint.activate([

            labelCollectionPhoto.topAnchor.constraint(equalTo: contentView.topAnchor, constant: collectionFlowLayout.sectionInset.top),
            labelCollectionPhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: collectionFlowLayout.sectionInset.left),
            labelCollectionPhoto.trailingAnchor.constraint(equalTo: arrow.leadingAnchor),
            labelCollectionPhoto.bottomAnchor.constraint(equalTo: photoCollectionView.topAnchor),

            arrow.centerYAnchor.constraint(equalTo: labelCollectionPhoto.centerYAnchor),
            arrow.leadingAnchor.constraint(equalTo: labelCollectionPhoto.trailingAnchor),
            arrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -collectionFlowLayout.sectionInset.right),
            arrow.widthAnchor.constraint(equalTo: arrow.heightAnchor),

            photoCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoCollectionView.heightAnchor.constraint(equalToConstant: widthHeightCollection )

         ])
    }



    private func autoScrollCollectionView() {

        var count: Int = 1

        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in

            let width: Int = Int(self.neededWidth)

            let contentSizeWidth = Int(self.photoCollectionView.contentSize.width)
            let contentOffset = count * width
            self.photoCollectionView.contentOffset = CGPoint(x: contentOffset, y: 0)
            count += 1

            if contentOffset + width + 20 > contentSizeWidth {
                count = 0
                self.photoCollectionView.contentOffset = CGPoint(x: 0, y: 0)
                //   self.timer = timer
                //    timer.invalidate()
            }

        }

    }
}





extension PhotosTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.nameCollectionCell, for: indexPath) as? PhotosCollectionViewCell else {
            let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            return cell }

        cell.clipsToBounds = true
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        cell.setupImage(arrayImages[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let spacingItem = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0

        let sectionInsetAll = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero

        let neededWidth = collectionView.frame.width - (Constraints.NumberItemInLine - 1) * spacingItem - sectionInsetAll.left - sectionInsetAll.right

        self.neededWidth = collectionView.frame.width - sectionInsetAll.left + spacingItem - 5


        let widthItem = floor (neededWidth / Constraints.NumberItemInLine)
        self.widthItem = widthItem
        return CGSize(width: widthItem, height: widthItem)
    }
}

extension PhotosTableViewCell: ProfileViewControllerOutput {
    func timerStop() {
        self.timer?.invalidate()
    }


}
