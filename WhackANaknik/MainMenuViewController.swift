//
//  MainMenuViewController.swift
//  WhackANaknik
//
//  Created by neemdor semel on 18/08/2017.
//  Copyright © 2017 naknik inc. All rights reserved.
//

import UIKit
import CoreData

class MainMenuViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var image: UIImage?
    
    @IBAction func pickImage(_ sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source" , message: "Choose a source" , preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default , handler: { (UIAlertAction) in
            if(UIImagePickerController.isSourceTypeAvailable(.camera)){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                print("camera not available")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default , handler: { (UIAlertAction) in imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Default", style: .default , handler: { (UIAlertAction) in
            self.image = #imageLiteral(resourceName: "party.png")
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default , handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Highscores(_ sender: UIButton) {
        performSegue(withIdentifier: "High Scores", sender: self)
    }
    @IBAction func Map(_ sender: UIButton) {
        performSegue(withIdentifier: "Map", sender: self)
    }
    @IBAction func StartGame(_ sender: UIButton) {
        performSegue(withIdentifier: "Start Game", sender: image)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let theDestination = (segue.destination as? GameViewController){
            theDestination.image = sender as? UIImage
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
