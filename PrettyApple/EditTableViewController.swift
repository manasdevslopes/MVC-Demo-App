import UIKit

class EditTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Model:
    var product: Product?
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UITextField!
    @IBOutlet weak var productDescriptionTextView: UITextView!

    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Product"
        productImageView.image = product?.image
        productTitleLabel.text = product?.title
        productDescriptionTextView.text = product?.description
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        product?.title = productTitleLabel.text!
        product?.description = productDescriptionTextView.text
        product?.image = productImageView.image!
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // dismiss the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UIScrollViewDelegate
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        productDescriptionTextView.resignFirstResponder()
        productTitleLabel.resignFirstResponder()
    }
    
    // MARK: - Table View Interaction
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 && indexPath.row == 0 {
            return indexPath
        } else {
            return nil
        }
    }
    
    // MARK: - Image Picker Controller
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        UIAlertController -- 2 buttons
//        1. Camera , 2 gallery
        
//        if clicked on 1st button write below code with type camera
//        if clicked on 2nd open gallery
        if indexPath.section == 0 && indexPath.row == 0{
            let alert = UIAlertController(title: "Choose", message: "Choose from below:-", preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: .default ) { (action) in
                self.actionSheetClicked(actionSheetClicked: 0)
            }
            let galleryAction = UIAlertAction(title: "Gallery", style: .default) {(action) in
                self.actionSheetClicked(actionSheetClicked: 1)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(cameraAction)
            alert.addAction(galleryAction)
            alert.addAction(cancelAction)
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        product?.image = image
        productImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func actionSheetClicked(actionSheetClicked:Int) {
        let picker = UIImagePickerController()
        
        switch actionSheetClicked {
        // .Camera
        case 0:
            picker.sourceType = UIImagePickerControllerSourceType.camera
        case 1:
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        default: break;
        }
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}





























