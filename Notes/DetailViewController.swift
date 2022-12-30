//
//  DetailViewController.swift
//  Notes
//
//  Created by n on 15.11.2022.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var detailNote: Note!
    weak var delegate: ViewController!
    
//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = detailNote.body

        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
        shareButton.tintColor = UIColor(red: 1, green: 0.749, blue: 0, alpha: 1)
        saveButton.tintColor = UIColor(red: 1, green: 0.749, blue: 0, alpha: 1)
        navigationItem.rightBarButtonItems = [saveButton, shareButton]
        self.navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 0.749, blue: 0, alpha: 1)

        //keyboard setup
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
//MARK: - shareNote
    @objc func shareNote() {
        let message = textView.text!
        let avc = UIActivityViewController(activityItems: [message], applicationActivities: [])
        avc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(avc, animated: true)
    }
    
//MARK: - saveNote
    @objc func saveNote() {
        detailNote.body = textView.text
        delegate.updateNote(note: detailNote)
        navigationController?.popViewController(animated: true)
    }
    
//MARK: - adjustForKeyboard
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        textView.scrollIndicatorInsets = textView.contentInset
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
}
