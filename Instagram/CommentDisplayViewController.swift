//
//  CommentDisplayViewController.swift
//  Instagram
//
//  Created by 松原保子 on 2018/02/15.
//  Copyright © 2018年 Yasuko.Matsubara. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CommentDisplayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func commentButton(_ sender: Any) {
        let commentViewController = self.storyboard?.instantiateViewController(withIdentifier: "Comment")
        present(commentViewController!, animated: true, completion: nil)
    }
    
    var postCommentArray: [PostCommentData] = []

    var observing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.observing == false {
            // 要素が追加されたらpostCommentArrayに追加してTableViewを再表示する
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let postId = appDelegate.postId
            let commentsRef = Database.database().reference().child(Const.PostPath).child(postId!).child(Const.PostCommentPath)
            
            commentsRef.observe(.childAdded, with: { (snapshot) -> Void in
                
                // PostDataクラスを生成して受け取ったデータを設定する
                if let uid = Auth.auth().currentUser?.uid {
                    let postData = PostCommentData(snapshot: snapshot, myId: uid)
                    self.postCommentArray.insert(postData, at: 0)
                    
                    // TableViewを再表示する
                    self.tableView.reloadData()
                }
            })
            
        }
        // DatabaseのobserveEventが上記コードにより登録されたため
        // trueとする
        observing = true
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postCommentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Cellに値を設定する.
        let comment = postCommentArray[indexPath.row]
        cell.textLabel?.text = "\(comment.commentName!) : \(comment.comments!)"
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: comment.date! as Date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // Auto Layoutを使ってセルの高さを動的に変更する
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
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
