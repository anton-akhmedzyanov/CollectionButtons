//
//  CourseCell.swift
//  CollectionButtons
//
//  Created by Anton Akhmedzyanov on 06.05.2023.
//

import UIKit

final class CourseCell: UITableViewCell {
    
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet var courseNameLabel: UILabel!
    @IBOutlet var numberofLesson: UILabel!
    @IBOutlet var numberOfTest: UILabel!
    
    private let network = NetWorkManager.shared
    
    func configure(with course: Course) {
        courseNameLabel.text = course.name
        numberofLesson.text = "Number of lessons:\(course.numberOfLessons)"
        numberOfTest.text = "Number of tests: \(course.numberOfTests)"
       
        network.fetchImage(from: course.imageUrl) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.courseImage.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
        }
    }
}
