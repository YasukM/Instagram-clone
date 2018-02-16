//
//  CommentViewController.swift
//  
//
//  Created by 松原保子 on 2018/02/14.
//
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class CommentViewController: UIViewController {

    var postArray: [PostData] = []
    
    @IBOutlet weak var commentTextField: UITextField!

    @IBAction func sendButton(_ sender: Any) {
                
        // postDataに必要な情報を取得しておく
        let name = Auth.auth().currentUser?.displayName
        let time = NSDate.timeIntervalSinceReferenceDate
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let postId = appDelegate.postId
        
        // 増えたcommentsをFirebaseに保存する
        let postRef = Database.database().reference().child(Const.PostPath).child(postId!).child(Const.PostCommentPath)
        let postCommentData = ["commentName" : name!, "comments": commentTextField.text!, "time": String(time)]
        
        postRef.childByAutoId().setValue(postCommentData)
        
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "送信しました")
        
        // 全てのモーダルを閉じる
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        // 画面を閉じる
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
