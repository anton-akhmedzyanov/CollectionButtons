//
//  CollectionViewController.swift
//  CollectionButtons
//
//  Created by Anton Akhmedzyanov on 06.05.2023.
//

import UIKit

enum Alert {
    case success
    case failed
    
    var title: String {
        switch self {
            
        case .success:
            return "Success"
        case .failed:
            return "Failed"
        }
    }
    
    var message: String {
        switch self {
            
        case .success:
            return "You can see the results in the Debug area"
        case .failed:
            return "You can see error in the DEbug area"
        }
    }
}

enum Link {
    case imageURL
    case courseURL
    case coursesURL
    case aboutUsURL
    case aboutUsURL2
    case postRequest
    case courseImageURL
    
    var url: URL {
        switch self {
            
        case .imageURL:
            return URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/23/Lake_mapourika_NZ.jpeg")!
        case .courseURL:
            return URL(string: "https://swiftbook.ru//wp-content/uploads/api/api_course")!
        case .coursesURL:
            return URL(string: "https://swiftbook.ru//wp-content/uploads/api/api_courses")!
        case .aboutUsURL:
            return URL(string: "https://swiftbook.ru//wp-content/uploads/api/api_website_description")!
        case .aboutUsURL2:
            return URL(string: "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields")!
        case .postRequest:
            return URL(string: "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields")!
        case .courseImageURL:
            return URL(string: "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields")!
        }
    }
}




enum UserAction: CaseIterable {
    case showImage
    case fetchCourse
    case fetchCourses
    case aboutSwiftBook
    case aboutSwiftBook2
    case showCourses
    case postRQSTWithDict
    case postrqstWithModel
    
    var title: String {
        switch self {
        case .showImage:
            return "showImage"
        case .fetchCourse:
            return "fetchCourse"
        case .fetchCourses:
            return "fetchCourses"
        case .aboutSwiftBook:
            return "aboutSwiftBook"
        case .aboutSwiftBook2:
            return "aboutSwiftBook2"
        case .showCourses:
            return "showCourses"
        case .postRQSTWithDict:
            return "post RQST with Dict"
        case .postrqstWithModel:
            return "post RQST with Model"
        }
    }
}

final class CollectionViewController: UICollectionViewController {
    
    private let titles = UserAction.allCases
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titles.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userAction", for: indexPath)
        guard let cell = cell as? UserActionCell else {return UICollectionViewCell() }
        cell.userActionCellLabel.text = titles[indexPath.item].title
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = titles[indexPath.item]
        switch userAction {
            
        case .showImage: performSegue(withIdentifier: "showImageVC", sender: nil)
        case .fetchCourse: fetchCourse()
        case .fetchCourses: fetchCourses()
        case .aboutSwiftBook: fetchInfoAboutUs()
        case .aboutSwiftBook2: fetchInfoAboutWithEmptyFields()
        case .showCourses: performSegue(withIdentifier: "showTableVC", sender: nil)
        case .postRQSTWithDict: fletchpostRQSTWithDict()
        case .postrqstWithModel: fletchpostrqstWithModel()
        }
    }
    //MARK: - Private Methods
    private func showAlert(withStatus status: Alert) {
        let alert = UIAlertController(title: status.title, message: status.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async {
            [unowned self] in
            present(alert, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTableVC" {
            guard let coursesVC = segue.destination as? ListTableViewController else { return }
            coursesVC.fetchcourses()
        }
    }
    
}
        //MARK: - UICollectionViewDelegateFlowLayout

        extension CollectionViewController: UICollectionViewDelegateFlowLayout {
            func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {
                CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
            }
        }

// MARK: - Networking
extension CollectionViewController {
    private func fetchCourse() {
        URLSession.shared.dataTask(with: Link.courseURL.url) {[weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let course = try decoder.decode(Course.self, from: data)
                print(course)
                self?.showAlert(withStatus: .success)
            } catch {
                print(error.localizedDescription)
                self?.showAlert(withStatus: .failed)
            }
        }.resume()
    }
    
     func fetchCourses() {
        URLSession.shared.dataTask(with: Link.coursesURL.url) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "no error description")
                return
            }
            do {
                let decoder = JSONDecoder()
                let courses = try decoder.decode([Course].self, from: data)
                print(courses)
                self?.showAlert(withStatus: .success)
            }
            catch {
                print(error.localizedDescription)
                self?.showAlert(withStatus: .failed)
            }
        }.resume()
}
    
    private func fetchInfoAboutUs() {
        URLSession.shared.dataTask(with: Link.aboutUsURL.url) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "no error description")
                return
            }
            do {
                let decoder = JSONDecoder()
                let sbInfo = try decoder.decode(SwiftBookInfo.self, from: data)
                print(sbInfo)
                self?.showAlert(withStatus: .success)
            }
            catch {
                print(error.localizedDescription)
                self?.showAlert(withStatus: .failed)
            }
        }.resume()
    }
    
    private func fetchInfoAboutWithEmptyFields() {
        URLSession.shared.dataTask(with: Link.aboutUsURL2.url) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "no error description")
                return
            }
            do {
                let decoder = JSONDecoder()
                let sbInfo = try decoder.decode(SwiftBookInfo.self, from: data)
                print(sbInfo)
                self?.showAlert(withStatus: .success)
            }
            catch {
                print(error.localizedDescription)
                self?.showAlert(withStatus: .failed)
            }
        }.resume()
    }
    private func fletchpostRQSTWithDict() {
        
    }
    private func fletchpostrqstWithModel() {
        
    }
}
