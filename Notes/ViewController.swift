//
//  ViewController.swift
//  Notes
//
//  Created by n on 15.11.2022.
//

import UIKit

class ViewController: UITableViewController {
//MARK: - properties
    var notes = [Note]()

//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Notes"
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
        addButton.tintColor = UIColor(red: 1, green: 0.749, blue: 0, alpha: 1)
        navigationItem.leftBarButtonItem = addButton
        
        let defaults = UserDefaults.standard
        if let savedNotes = defaults.object(forKey: "savedNotes") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedNotes)
            } catch {
                print("Failed to save notes.")
            }
        }
    }
    
//MARK: - numberOfRows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
//MARK: - cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.body
        return cell
    }

//MARK: - didSelectRow
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            vc.detailNote = note
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//MARK: - addNewNote
    @objc func addNewNote() {
        let newNote = Note(title: "Note \(notes.count + 1)", body: "")
        notes.append(newNote)
        print(notes.count)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            vc.detailNote = newNote
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//MARK: - save
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedNotes = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(savedNotes, forKey: "savedNotes")
        } else {
            print("Failed to save notes.")
        }
    }
    
//MARK: - editNote
    func editNote(note: Note) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            vc.detailNote = note
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//MARK: - updateNotes
    func updateNote(note: Note) {
        save()
        tableView.reloadData()
    }
    
//MARK: - deleteSwipe
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        tableView.reloadData()
        save()
        
    }
}
