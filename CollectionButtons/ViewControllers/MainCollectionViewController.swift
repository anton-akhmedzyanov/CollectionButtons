//
//  MainCollectionViewController.swift
//  CollectionButtons
//
//  Created by Anton Akhmedzyanov on 10.05.2023.
//

import UIKit

enum UserAction: CaseIterable {
    case showImage
    case fetchCourse
    case fetchCourses
    case aboutSwiftBook
    case aboutSwiftBook2
    case showCourses
    case postRQSTDict
    case postRQSTModel
    
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
        case .postRQSTDict:
            return "postRQSTDict"
        case .postRQSTModel:
            return "postRQSTModel"
        }
    }
}

enum Alert: String {
    case success = "Success"
    case failed = "Failed"

var message: String {
        switch self {
            
        case .success:
            return " You can see the result in the Debag ared"
        case .failed:
            return " You can see error in the Debag ared"
        }
    }

}

final class MainCollectionViewController: UICollectionViewController {
    
    private var userActions = UserAction.allCases
    private let netWorkManger = NetWorkManager.shared
    //MARK: - Navigattion
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTableVC" {
            guard let coursesVC = segue.destination as? ListTableViewController else {return}
            coursesVC.fetchcourses()
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userAction", for: indexPath)
        guard let userAC = cell as? UserActionCell else {return UICollectionViewCell()}
        userAC.userActionCellLabel.text = userActions[indexPath.item].title
        return cell
    }
    
    //MARK: - UICollectionDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        
        switch userAction {
            
        case .showImage: performSegue(withIdentifier: "showImageVC", sender: nil)
        case .fetchCourse: fetchCourse()
        case .fetchCourses: fetchCourses()
        case .aboutSwiftBook: fetchInfoAboutUs()
        case .aboutSwiftBook2: fetchInfoAboutUsWithEmptyFields()
        case .showCourses: performSegue(withIdentifier: "showTableVC", sender: nil)
        case .postRQSTDict: postRequestWithDict()
        case .postRQSTModel: postRequestWithModel()
        }
    }
    
    // MARK: - Private Methods
    
    private func showAlert(withStatus status: Alert) {
        let alert = UIAlertController(title: status.rawValue, message: status.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async { [unowned self] in
            present(alert, animated: true)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48 , height: 100)
    }
}
  
    //MARK: - Networking
    
extension MainCollectionViewController {
    private func fetchCourse() {
        netWorkManger.fetchCourse(from: Link.courseURL.url) { [weak self] result in
            switch result {
            case .success(let course):
                print(course)
                self?.showAlert(withStatus: .success)
            case .failure(let failure):
                print(failure)
                self?.showAlert(withStatus: .failed)
            }
        }
    }
    
    private func fetchCourses() {
        netWorkManger.fetch([Course].self, from: Link.coursesURL.url) {[weak self] result in
            switch result {
            case .success(let courses):
                print(courses)
                self?.showAlert(withStatus: .success)
            case .failure(let failure):
                print(failure)
                self?.showAlert(withStatus: .failed)
            }
        }
    }
    
    private func fetchInfoAboutUs() {
        netWorkManger.fetch(SwiftBookInfo.self, from: Link.aboutUsURL.url) { [weak self] result in
            switch result {
            case .success(let infoSwiftBook):
                print(infoSwiftBook)
                self?.showAlert(withStatus: .success)
            case .failure(let failure):
                print(failure)
                self?.showAlert(withStatus: .failed)
            }
        }
        
    }
    
    private func fetchInfoAboutUsWithEmptyFields() {
        netWorkManger.fetch(SwiftBookInfo.self, from: Link.aboutUsURL2.url) { [weak self] result in
            switch result {
            case .success(let infoSwiftBook):
                print(infoSwiftBook)
                self?.showAlert(withStatus: .success)
            case .failure(let failure):
                print(failure)
                self?.showAlert(withStatus: .failed)
            }
        }
    }
    
    private func postRequestWithDict() {
        let parametrs = [
            "name": "Networking",
            "imageUrl": "inahe url.ru",
            "numberOfLessons": "10",
            "numberOfTests": "8"
        ]
        netWorkManger.postRequest(with: parametrs, to: Link.postRequest.url) { result in
            switch result {
            case .success(let json):
                print(json)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    private func postRequestWithModel() {
        let course = Course(name: "Network",
                            imageUrl: Link.imageURL.url,
                            numberOfLessons: 3,
                            numberOfTests: 2)
        
        netWorkManger.postRequestModel(with: course, to: Link.postRequest.url) { result in
            switch result {
            case .success(let course):
                print(course)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
