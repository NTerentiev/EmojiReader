//
//  EmojiTableViewController.swift
//  EmojiReader
//
//  Created by Никита Терентьев on 23.09.2022.
//

import UIKit

class EmojiTableViewController: UITableViewController {
    
    var objects = [
        Emoji(emoji: "😘", name: "Love Kiss", description: "Let's love each other", isFavourite: false),
        Emoji(emoji: "🫴", name: "Hand", description: "Give a hand to help someone", isFavourite: false),
        Emoji(emoji: "😶‍🌫️", name: "Smoke", description: "Smoking it's to bad", isFavourite: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Emoji Reader"
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveSegue" else { return }
        let sourceVC = segue.source as! NewEmojiTableViewController
        let emoji = sourceVC.emoji
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            objects[selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
        } else {
            let newIndexPath = IndexPath(row: objects.count, section: 0)
            objects.append(emoji)
            tableView.insertRows(at: [newIndexPath], with: .fade)
        }
    }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            super.prepare(for: segue, sender: sender)
            guard segue.identifier == "editEmoji" else { return }
            
            let indexPath = tableView.indexPathForSelectedRow!
            let emoji = objects[indexPath.row]
            let navigationVC = segue.destination as! UINavigationController
            let newEmojiVC = navigationVC.topViewController as! NewEmojiTableViewController
            newEmojiVC.emoji = emoji
            newEmojiVC.title = "Edit"
        }

        
        
        // MARK: - Table view data source
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return objects.count
        }
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emojiCell", for: indexPath) as! EmojiTableViewCell
            let object = objects[indexPath.row]
            cell.set(object: object)
            
            return cell
        }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                objects.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
        override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
        override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            let movedEmoji = objects.remove(at: sourceIndexPath.row)
            objects.insert(movedEmoji, at: destinationIndexPath.row)
            tableView.reloadData()
        }
        
        func doneAction(at indexPath: IndexPath) -> UIContextualAction {
            let action = UIContextualAction(style: .destructive, title: "Done") {
                (action, view, completion) in
                self.objects.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                completion(true)
            }
            action.backgroundColor = .systemGreen
            action.image = UIImage(systemName: "checkmark.circle")
            return action
        }
        
        override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let done = doneAction(at: indexPath)
            let favoutite = favouriteAction(at: indexPath)
            return UISwipeActionsConfiguration(actions: [done, favoutite])
        }
        
        func favouriteAction(at indexPath: IndexPath) -> UIContextualAction {
            var object = objects[indexPath.row]
            let action = UIContextualAction(style: .normal, title: "Like") { (action, view, completion) in
                object.isFavourite = !object.isFavourite
                self.objects[indexPath.row] = object
                completion(true)
            }
            action.backgroundColor = object.isFavourite ? .systemRed : .systemGray5
            action.image = object.isFavourite ? UIImage(systemName: "suit.heart.fill") : UIImage(systemName: "suit.heart")
            return action
        }
        
    }
