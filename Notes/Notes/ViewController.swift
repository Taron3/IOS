//
//  ViewController.swift
//  Notes
//
//  Created by 3 on 11/1/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var selectedIndex: Int?
    var tableData = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        configureNavigationController()
        
        tableData = AppDelegate.fetchData()
    }
    
    func configureNavigationController() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        navigationItem.title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.searchController = UISearchController(searchResultsController: nil)
    }
    
    @IBAction func newNote(_ sender: UIButton) {
        let noteContentViewController = storyboard?.instantiateViewController(identifier: "NoteContentViewController") as! NoteContentViewController
        
        noteContentViewController.note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: AppDelegate.viewContext) as? Note
        noteContentViewController.delegate = self 
                
        navigationController?.pushViewController(noteContentViewController, animated: true)
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCellTableViewCell.identifier, for: indexPath) as! NoteCellTableViewCell        
        configure(cell, at: indexPath)
        
        return cell
    }
     
    func configure(_ cell: NoteCellTableViewCell, at indexPath: IndexPath) {
        let theNote = tableData[indexPath.row]

        cell.titleLabel.text = theNote.title
        cell.descriptionLabel.text = theNote.additionalText
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
        let selectedNote = tableData[selectedIndex!]
        let noteContentViewController = storyboard?.instantiateViewController(identifier: "NoteContentViewController") as! NoteContentViewController
        
        selectedNote.identifier = Int64(selectedIndex!)
        noteContentViewController.note = selectedNote
        noteContentViewController.delegate = self
        
        navigationController?.pushViewController(noteContentViewController, animated: true)
    }
}

extension ViewController: NoteContentDelegate {
    func didUpdateNote(with newNote: Note) {
        if let rowIndex = selectedIndex, newNote.identifier == Int64(selectedIndex!) {
            tableData[rowIndex] = newNote
        } else {
            tableData.append(newNote)
        }
        
        tableView.reloadData()
    }
}


