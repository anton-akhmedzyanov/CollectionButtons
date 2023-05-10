//
//  ListTableViewController.swift
//  CollectionButtons
//
//  Created by Anton Akhmedzyanov on 06.05.2023.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    private var courses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
    }
    
    // MARK: - Table view data source
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let courseCell = cell as? CourseCell else { return UITableViewCell() }
        let course = courses[indexPath.row]
        courseCell.configure(with: course)
        
        return cell
    }
    
}
    //MARK: - Networking
   extension ListTableViewController {
        func fetchcourses() {
            URLSession.shared.dataTask(with: Link.coursesURL.url) {[weak self] data, _, error in
                guard let data else {
                    print(error?.localizedDescription ?? "No error description")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    self?.courses = try decoder.decode([Course].self, from: data)
                    
                    DispatchQueue.main.async { 
                    self?.tableView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }.resume()
        }
    }

