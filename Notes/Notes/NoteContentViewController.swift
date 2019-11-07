//
//  NoteContentViewController.swift
//  Notes
//
//  Created by 3 on 11/3/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import UIKit


class NoteContentViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textViewOutlet: UITextView! {
        didSet {
            textViewOutlet.delegate = self
        }
    }
    
    var note: Note!
    weak var delegate: NoteContentDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureNavigationItem()

        guard let noteContent = note.content else {
            return
        }
        textViewOutlet.text = noteContent
    }
    
    func configureNavigationItem() {
        navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 0.9833580852, green: 0.5869337916, blue: 0.03047441877, alpha: 1)
        let rightButton = UIBarButtonItem(title: "Done",
                                          style: .plain,
                                          target: self,
                                          action: #selector(doneTapped))
        rightButton.tintColor = .clear
        navigationItem.rightBarButtonItem = rightButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if note.content == nil {
            textViewOutlet.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveNote()
    }
    
    func saveNote() {
        guard let text = textViewOutlet.text, let note = note else {
            return
        }
        
        let firstLine = String(text.split(separator: "\n").first ?? "")
        
        if firstLine.isEmpty {
            return
        } else if firstLine.isBlank {
            note.title = "New Note"
            note.additionalText = "No additional text"
        } else {
            let contentLines = text.split(separator: "\n")
            let additionalText = String(contentLines.count > 1 ? contentLines[1] : "No additional text" )
            note.title = firstLine
            note.additionalText = additionalText
            note.content = text
        }
        
        try? AppDelegate.viewContext.save()
        delegate?.didUpdateNote(with: note)
    }
    
    @objc func doneTapped() {
        textViewOutlet.resignFirstResponder()
        navigationItem.rightBarButtonItem?.tintColor = .clear
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
          navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.9833580852, green: 0.5869337916, blue: 0.03047441877, alpha: 1)
      }
}

protocol NoteContentDelegate: class {
    func didUpdateNote(with newNote: Note)

}

extension String {
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespaces).isEmpty
    }
}

