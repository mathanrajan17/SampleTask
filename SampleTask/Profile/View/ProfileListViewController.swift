//
//  ProfileListViewController.swift
//  SampleTask
//
//  Created by Mathan Rajan J on 27/08/23.
//

import UIKit

class ProfileListViewController: UIViewController {
    
    var database = DatabaseHandler()

    @IBOutlet weak var profileListTableView: UITableView!
    var profileList: [ProfileUser] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Task {
            await getProfileList()
        }
    }
    
    
    func getProfileList() async {
        do {
            let responce = try await RestService.sharedInstance.getPhotosList()
            self.constructListValues(response: responce)
            self.profileListTableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func constructListValues(response: [ProfileDetails]) {
        let coreDataProfiles = DatabaseHandler.instance.fetch(type: ProfileUser.self)
        var updatedProfiles: [ProfileUser] = []
        for responseProfile in response {
            if let coreDataProfile = coreDataProfiles.first(where: { $0.profileId == responseProfile.profileId }) {
                let valuesMatch = coreDataProfile.profileId == responseProfile.profileId
                if valuesMatch {
                    updatedProfiles.append(coreDataProfile)
                }
            } else {
                if let user = responseProfile.add() {
                    updatedProfiles.append(user)
                }
            }
        }
        self.profileList = updatedProfiles
    }
    
    func moveEditViewController(profileDetails: ProfileUser, indexPath: IndexPath) {
        if let listViewController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifier.profileEditViewController) as? ProfileEditViewController {
            listViewController.profileDetails = profileDetails
            listViewController.completionClosure  = { details in
                self.refreshTableView(indexPath: indexPath, details: details)
            }
            self.navigationController?.pushViewController(listViewController, animated: true)
        }
    }
    
    
    func refreshTableView(indexPath: IndexPath, details: ProfileUser) {
        DispatchQueue.main.async {
            self.profileList[indexPath.row] = details
            self.profileListTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

extension ProfileListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.profileListTableViewCell) as? ProfileListTableViewCell {
            cell.nameLabel.text = profileList[indexPath.row].name
            cell.emailLabel.text = profileList[indexPath.row].email
            cell.mobileLabel.text = profileList[indexPath.row].mobile 
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.moveEditViewController(profileDetails: profileList[indexPath.row], indexPath: indexPath)
    }
}


