//
//  NowPlayingViewController.swift
//  NowPlayingInMenuBar
//

import AppKit
import SnapKit

class NowPlayingViewController: NSViewController {
    
    private var viewModel: NowPlayingViewModel!
    
    private var imageView: NSImageView = NSImageView()
    private var titleLabel: NSLabel = {
        let label = NSLabel()
        label.alignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    private var artistLabel: NSLabel = {
        let label = NSLabel()
        label.alignment = .center
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private var albumLabel: NSLabel = {
        let label = NSLabel()
        label.alignment = .center
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let stackView = {
        let view = NSStackView()
        view.orientation = .vertical
        view.alignment = .centerX
        view.edgeInsets = NSEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        view.distribution = .fillProportionally
        view.spacing = 8
        return view
    }()
    private let blurEffectView = NSVisualEffectView()
    
    init(viewModel: NowPlayingViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        blurEffectView.frame = view.bounds
        blurEffectView.material = .hudWindow
        blurEffectView.blendingMode = .withinWindow
        blurEffectView.state = .active
        view.addSubview(blurEffectView, positioned: .below, relativeTo: stackView)
        
        updateUI()
    }
    
    private func setupLayout() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(artistLabel)
        stackView.addArrangedSubview(albumLabel)
        view.addSubview(stackView)

        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageView.snp.width)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(400)
        }
        
        for subview in stackView.arrangedSubviews {
            if subview is NSLabel {
                subview.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 8).isActive = true
                subview.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -8).isActive = true
            }
        }
    }
    
    func updateUI() {
        imageView.image = viewModel.artwork
        titleLabel.stringValue = viewModel.title
        artistLabel.stringValue = viewModel.artist
        albumLabel.stringValue = viewModel.album
        
        if let dominantColor = viewModel.artwork.dominantColor {
            view.layer?.backgroundColor = dominantColor.cgColor
        }
    }
}

extension NSImage {
    var dominantColor: NSColor? {
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        let ciImage = CIImage(cgImage: cgImage)

        let context = CIContext(options: nil)
        guard let filter = CIFilter(name: "CIAreaAverage") else { return nil }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(CIVector(cgRect: ciImage.extent), forKey: kCIInputExtentKey)

        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: CGRect(x: 0, y: 0, width: 1, height: 1)),
              let dataProvider = cgImage.dataProvider,
              let data = dataProvider.data,
              let bytes = CFDataGetBytePtr(data) else { return nil }

        let red = CGFloat(bytes[0]) / 255.0
        let green = CGFloat(bytes[1]) / 255.0
        let blue = CGFloat(bytes[2]) / 255.0
        let alpha = CGFloat(bytes[3]) / 255.0

        return NSColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
