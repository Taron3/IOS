//
//  ProfileViewController.swift
//  AutolayoutProgramaticly
//
//  Created by 3 on 10/19/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var imageView: UIImageView!
    var nameLabel: UILabel!
    var surnameLabel: UILabel!
    var profileContent: UIView!
    
    var regularConstraintsImageView = [NSLayoutConstraint]()
    var compactConstraintsImageView = [NSLayoutConstraint]()
    
    var regularConstraintsProfileContent = [NSLayoutConstraint]()
    var compactConstraintsProfileContent = [NSLayoutConstraint]()
    
    var user: User {
        guard let userImage = UIImage(named: "img") else {
            preconditionFailure("Couldn't get an image")
        }
        return User(name: "Name", surname: "Surname", image: userImage )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
        setupNameLabel()
        setupSurnameLabel()
        setupProfileContent()
    }

    
    func setupImageView() {
        imageView = UIImageView()
        imageView.image = user.image
        view.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        regularConstraintsImageView = [
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 3)
        ]
        compactConstraintsImageView = [
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 2),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 3)
        ]
        
        activateConstraints()
    }
    
    func setupNameLabel() {
        nameLabel = UILabel()
        nameLabel.text = user.name
        view.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 18),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18)
        ] )
        
    }
    
    func setupSurnameLabel() {
        surnameLabel = UILabel()
        surnameLabel.text = user.surname
        view.addSubview(surnameLabel)
        
        surnameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            surnameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 18),
            surnameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18)
        ] )

    }
    
    func setupProfileContent() {
        profileContent = UIView()
        profileContent.backgroundColor = .lightGray
        view.addSubview(profileContent)
        
        profileContent.translatesAutoresizingMaskIntoConstraints = false
        
        regularConstraintsProfileContent = [
            profileContent.topAnchor.constraint(equalTo: surnameLabel.bottomAnchor, constant: 18),
            profileContent.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileContent.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            profileContent.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        compactConstraintsProfileContent = [
            profileContent.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileContent.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 18),
            profileContent.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            profileContent.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        activateConstraints()
    }

    func activateConstraints() {
        NSLayoutConstraint.deactivate(regularConstraintsImageView + compactConstraintsImageView +
                                      regularConstraintsProfileContent + compactConstraintsProfileContent)
        
        if traitCollection.verticalSizeClass == .regular && UIDevice.current.userInterfaceIdiom == .phone {
            NSLayoutConstraint.activate(regularConstraintsImageView + regularConstraintsProfileContent)
                                         
        } else {
            NSLayoutConstraint.activate(compactConstraintsImageView + compactConstraintsProfileContent)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        activateConstraints()
    }
    
    
}
