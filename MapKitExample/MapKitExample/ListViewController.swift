//
//  ListViewController.swift
//  MapKitExample
//
//  Created by Aslan Korkmaz on 1.05.2025.
//

import UIKit
import CoreData

class ListViewController: UIViewController {
    
    let tableView = UITableView()
    var nameList = [String]()
    var idList = [UUID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
        tableView.reloadData()
    }
    
    @objc private func add() {
        let vc = MapsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setup() {
        setTableView()
        view.addSubview(tableView)
        view.backgroundColor = .white
        constraints()
        fetchData()
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func fetchData() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
        
        do {
            let fetchedData = try context.fetch(fetchRequest)
            nameList.removeAll()
            idList.removeAll()
            
            for data in fetchedData {
                if let name = data.name {
                    nameList.append(name)
                }
                if let id = data.id {
                    idList.append(id)
                }
            }
            tableView.reloadData()
            print("fetch data")
        } catch {
            print("fetch error \(error.localizedDescription)" )
        }
        
    }
    
    private func constraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = nameList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", idList[indexPath.row].uuidString)
            
            do {
                let results = try context.fetch(fetchRequest)
                if let objectToDelete = results.first {
                    context.delete(objectToDelete)
                    try context.save()
                    
                    nameList.remove(at: indexPath.row)
                    idList.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            } catch {
                print("Error deleting \(error)")
            }
            
        }
    }
}
