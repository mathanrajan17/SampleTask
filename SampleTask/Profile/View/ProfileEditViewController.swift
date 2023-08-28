//
//  ProfileEditViewController.swift
//  SampleTask
//
//  Created by Mathan Rajan J on 27/08/23.
//

import UIKit

class ProfileEditViewController: UIViewController {
    
    var profileDetails: ProfileUser?
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var mobileNumberField: UITextField!
    var completionClosure: ((ProfileUser) -> Void?)?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        nameField.text = profileDetails?.name ?? ""
        emailField.text = profileDetails?.email ?? ""
        mobileNumberField.text = profileDetails?.mobile ?? ""
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        self.view.endEditing(true)
        if let profileDetails = profileDetails {
            DatabaseHandler.instance.updateUserDetails(details: profileDetails)
            completionClosure?(profileDetails)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension ProfileEditViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case nameField:
            profileDetails?.name = textField.text ?? ""
        case emailField:
            profileDetails?.email = textField.text ?? ""
        case mobileNumberField:
            profileDetails?.mobile = textField.text ?? ""
        default:
            break
        }
    }
}
