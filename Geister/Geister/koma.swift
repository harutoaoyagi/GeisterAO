import UIKit

class Koma : UIView{
    
    var ghost = ""
    
    var first = true
    
    //駒を作成する
    func komaMake(mathView: UIView,komaType: String,start: Bool) {
        let ghostImage = UIImageView()
        //位置とサイズ設定
        ghostImage.frame = CGRect(x: 0, y: 0, width: mathView.frame.size.width, height: mathView.frame.size.height)
        
        ghost = komaType
        first = start
        
        ghostImage.tag = mathView.tag + 200
        //imageを設定
        switch ghost {
        case "ghost":
            ghostImage.image = UIImage(named: "ghost")
        case "ghostR":
            ghostImage.image = UIImage(named: "redghost")
        case "ghostB":
            ghostImage.image = UIImage(named: "blueghost")
        default:break
        }
        
        if !start{ //180度回転
            let angle:CGFloat = CGFloat((180.0 * Double.pi) / 180.0)
            ghostImage.transform = CGAffineTransform(rotationAngle: angle)
        }
        mathView.addSubview(ghostImage)
    }
    //指定されたオバケを消去
    func removeKoma(mathView: UIView, tag: [Int]) {
        for subView in mathView.subviews {
            for i in 0..<tag.count{
                if  subView.tag == tag[i] + 200 {
                    subView.removeFromSuperview()
                }
            }
        }
    }
    //矢印表示
    func arrow(mathView: UIView,contrast: Bool) {
        let arrowImage = UIImageView()
        
        first = contrast
        
        arrowImage.frame = CGRect(x: 15, y: 8, width: 30, height: 50)
        arrowImage.image = UIImage(named: "up")
        
        if !contrast{ //180度回転
            let angle:CGFloat = CGFloat((180.0 * Double.pi) / 180.0)
            arrowImage.transform = CGAffineTransform(rotationAngle: angle)
        }
        
        mathView.addSubview(arrowImage)
    }
}



