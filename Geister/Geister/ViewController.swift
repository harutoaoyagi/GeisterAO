import UIKit

class ViewController: UIViewController ,UITextFieldDelegate{
    //盤面
    var field : [[Int]] = [[0,0,0,0,0,0],
                           [0,0,0,0,0,0],
                           [0,0,0,0,0,0],
                           [0,0,0,0,0,0],
                           [0,0,0,0,0,0],
                           [0,0,0,0,0,0]]
    //AI盤面
    var AIField : [[Int]] = [[0,0,0,0,0,0],
                             [0,0,0,0,0,0],
                             [0,0,0,0,0,0],
                             [0,0,0,0,0,0],
                             [0,0,0,0,0,0],
                             [0,0,0,0,0,0]]
    //出口盤面
    var exportField : [[Int]] = [[0,0],[0,0]]
    //盤面X,Y
    var cX = 0
    var cY = 0
    //前の盤面X,Y
    var prX = 0
    var prY = 0
    //出口盤面X,Y
    var exportX = 0
    var exportY = 0
    //盤面作成のX,Y
    var Y = 0
    var X = 0
    //進行
    var start = 0
    //ゲームターン
    var turn = 0
    //先攻後攻
    var order = 0
    //オバケのターン
    var ghostTurn = 0
    //オバケの種類確認
    var ghostType = 0
    var prGhostCheck = 0
    var prGhostColor = 0
    //脱出前の確認結果
    var exportCheck = 0
    //オバケの周囲４方向の確認結果
    var backtagTotal = (0,0,0,0)
    //オバケの合計数
    var ghostTotal = (0,0,0,0)
    var ghostTag = [(color: Int,tag: Int)]()
    //盤面全てのオバケのtag
    var ghostTagTotal : [Int] = []
    //判定結果
    var judgeCount = 0
    //ユーザーネーム
    var userName = ""
    //グリーン背景
    let backR = UIView()
    let backD = UIView()
    let backL = UIView()
    let backU = UIView()
    //オバケ画像 
    let ghostB_U = UIImageView()
    let ghostR_U = UIImageView()
    let ghostR_A = UIImageView()
    let ghostB_A = UIImageView()
    //マスの親viewを imageViewで作成
    var parentView = UIImageView()
    //盤面のマスViewをまとめて管理するための配列
    var mathsArray = [UIView]()
    
    @IBOutlet weak var label: UILabel! //主要なラベル
    @IBOutlet weak var first: UIButton! //先攻ボタン
    @IBOutlet weak var second: UIButton! //後攻ボタン
    @IBOutlet weak var correct: UIButton! //決定ボタン
    //敵と自分の名前ラベル
    @IBOutlet weak var name_A: UILabel!
    @IBOutlet weak var name_U: UILabel!
    //ユーザーネーム入力
    @IBOutlet var enterName: UITextField!
    //オバケの合計数表示ラベル
    @IBOutlet weak var countR_U: UILabel!
    @IBOutlet weak var countB_U: UILabel!
    @IBOutlet weak var countR_A: UILabel!
    @IBOutlet weak var countB_A: UILabel!
    //終了ボタン
    @IBOutlet weak var end: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //非表示設定
        name_U.isHidden = true
        name_A.isHidden = true
        correct.isHidden = true
        end.isHidden = true
        
        // 画像
        ghostB_U.image = UIImage(named: "blueghost")
        ghostR_U.image = UIImage(named: "redghost")
        ghostR_A.image = UIImage(named: "redghost")
        ghostB_A.image = UIImage(named: "blueghost")
        
        // 画像の位置とフレームを設定
        ghostB_U.frame = CGRect(x:0, y:0, width:62, height:65)
        ghostR_U.frame = CGRect(x:0, y:0, width:62, height:65)
        ghostR_A.frame = CGRect(x:0, y:0, width:62, height:65)
        ghostB_A.frame = CGRect(x:0, y:0, width:62, height:65)
        
        backR.frame = CGRect(x: 0, y: 0, width: 61,height: 64)
        backD.frame = CGRect(x: 0, y: 0, width: 61,height: 64)
        backL.frame = CGRect(x: 0, y: 0, width: 61,height: 64)
        backU.frame = CGRect(x: 0, y: 0, width: 61,height: 64)
        
        ghostB_U.center = CGPoint(x:225, y:500)
        ghostR_U.center = CGPoint(x:99, y:500)
        ghostR_A.center = CGPoint(x:99, y:0)
        ghostB_A.center = CGPoint(x:225, y:0)
        //背景色
        backR.backgroundColor = UIColor.lightcolor()
        backD.backgroundColor = UIColor.lightcolor()
        backL.backgroundColor = UIColor.lightcolor()
        backU.backgroundColor = UIColor.lightcolor()
        //tag付け
        backR.tag = 100
        backD.tag = 101
        backL.tag = 102
        backU.tag = 103
        
        label.text = "先攻か後攻をへ選んでください"
        
        self.enterName.delegate = self
    }
    
    //先攻後攻の決定
    @IBAction func action(_ sender: UIButton) {
        //0:先攻,1:後攻
        switch sender.tag {
        case 0:
            start = 1
            order = 1
        case 1:
            start = 1
            order = 2
        default:break
        }
        userName = enterName.text!
        // 表示非表示
        first.isHidden = true
        second.isHidden = true
        enterName.isHidden = true
        label.isHidden = true
        correct.isHidden = false
        name_U.isHidden = false
        name_A.isHidden = false
        //テキスト表示
        label.text = "オバケの配置を決めてください"
        name_U.text = userName
        
        parentView.frame = CGRect(x: 3.5,y: 116,width: self.view.frame.size.width-5,height: 564)
        
        parentView.isUserInteractionEnabled = true
        
        self.view.addSubview(parentView)
        
        //盤面を生成
        while Y != 8 {
            while X != 6 {
                
                // タップを定義
                let tap = UITapGestureRecognizer(target: self, action: #selector(viewTap(_:)))
                
                let figure_x = CGFloat(62 * X)
                let figure_y = CGFloat(65 * Y)
                
                let figure = UIView(frame:CGRect(x: figure_x,y: figure_y,width: 62,height: 65))
                
                if X != 0 {
                    figure.frame.origin.x -= CGFloat(X)
                }
                if Y != 0 {
                    figure.frame.origin.y -= CGFloat(Y)
                }
                
                figure.layer.borderWidth = 1
                
                //mathに識別番号を与える
                figure.tag = ((X + 1) * 10) + (Y + 1)
                X += 1
                
                figure.addGestureRecognizer(tap)
                parentView.addSubview(figure)
                self.mathsArray.append(figure)
            }
            X = 0
            Y += 1
        }
        //指定した場所に画像やオバケを表示
        for mathView in mathsArray {
            switch mathView.tag {
            case 26,36,46,56,27,37,47,57:
                Koma().komaMake(mathView: mathView,komaType: "ghost",start: true)
            case 22,32,42,52,23,33,43,53:
                Koma().komaMake(mathView: mathView,komaType: "ghost",start: false)
            case 11,61:
                Koma().arrow(mathView: mathView,contrast: true)
            case 18,68:
                Koma().arrow(mathView: mathView,contrast: false)
            case 28,38,48,58,21,31,41,51:
                mathView.removeFromSuperview()
            default:break
            }
        }
        AIField = AI().komaAIPlace()
        //AIのオバケ配置
        for i in  0..<6 {
            for j in 0..<6 {
                switch AIField[i][j] {
                case 3:
                    field[i][j] = 3
                case 4:
                    field[i][j] = 4
                default:break
                }
            }
        }
    }
    //画面をタップしたときの処理
    @objc func viewTap(_ sender:UITapGestureRecognizer) {
        //tagを取得
        let senderView = sender.view
        //盤面X座標の取得
        switch senderView!.tag/10 {
        case 1:
            cX = 0
            exportX = 0
        case 2:
            cX = 1
        case 3:
            cX = 2
        case 4:
            cX = 3
        case 5:
            cX = 4
        case 6:
            cX = 5
            exportX = 1
        default:break
        }
        //盤面Y座標の取得
        switch senderView!.tag%10 {
        case 1:
            exportY = 0
        case 2:
            cY = 0
        case 3:
            cY = 1
        case 4:
            cY = 2
        case 5:
            cY = 3
        case 6:
            cY = 4
        case 7:
            cY = 5
        case 8:
            exportY = 1
        default:break
        }
        //ユーザーのオバケの配置決め
        if start == 1 {
            for i in 1..<5 {
                if cX == i && (cY == 4 || cY == 5) {
                    prGhostColor += 1
                    //同じ場所を選択した場合の変更
                    //1:青,2:赤
                    switch field[cX][cY] {
                    case 1:
                        prGhostColor = 2
                    case 2:
                        prGhostColor = 1
                    default:
                        break
                    }
                    field[cX][cY] = prGhostColor
                    //オバケの配置
                    switch prGhostColor {
                    case 1:
                        Koma().komaMake(mathView: senderView!,komaType: "ghostB",start: true)
                    case 2:
                        Koma().komaMake(mathView: senderView!,komaType: "ghostR",start: true)
                        prGhostColor = 0
                    default:break
                    }
                }
            }
        }
        //ゲーム開始
        if start == 2 {
            ghostTag = Check().komaCoordinate(field: field)
            for i in 0..<ghostTag.count {
                ghostTagTotal.append(ghostTag[i].tag)
            }
            //選択可能な場所のグリーン背景を消去
            for eachView in self.mathsArray {
                Check().removeBack(mathView: eachView)
            }
            //ユーザー
            if (order + turn) % 2 == 1 {
                ghostTurn += 1
                backtagTotal = Check().checkTag(field: field, x: cX, y: cY,order: order,turn: turn)
                ghostType = Check().komaCheck(field: field, x: cX, y: cY)
                exportCheck = Check().exportCheck(field: field, x: cX, y: cY, order: order, turn: turn)
                //1:青,2:赤
                if ghostType == 1 || ghostType == 2{
                    for mathView in mathsArray {
                        switch mathView.tag {
                        case backtagTotal.0:
                            mathView.addSubview(backR)
                            mathView.bringSubviewToFront(backR)
                        case backtagTotal.1:
                            mathView.addSubview(backD)
                            mathView.bringSubviewToFront(backD)
                        case backtagTotal.2:
                            mathView.addSubview(backL)
                            mathView.bringSubviewToFront(backL)
                        case backtagTotal.3:
                            mathView.addSubview(backU)
                            mathView.bringSubviewToFront(backU)
                        default:break
                        }
                    }
                    prGhostCheck = ghostType
                    prX = cX
                    prY = cY
                }else if ghostTurn == 1 {
                    ghostTurn = 0
                }
                //オバケ移動
                if ghostTurn == 2 {
                    if (prX - cX) * (prX - cX) + (prY - cY) * (prY - cY) == 1 {
                        field[cX][cY] = prGhostCheck
                        field[prX][prY] = 0
                        ghostTurn = 0
                        turn += 1
                        prGhostCheck = 0
                        //選択可能な場所のグリーン背景を消去
                        for eachView in mathsArray {
                            Check().removeBack(mathView: eachView)
                        }
                    }else if (exportX == 0 || exportX == 1) && (exportY == 0 || exportY == 1) {
                        if exportCheck == 1 || exportCheck == 2 {
                            exportField[exportX][exportX] = 1
                            ghostTurn = 0
                        }else{
                            ghostTurn = 1
                        }
                    }else{
                        ghostTurn = 1
                    }
                }
            }
            //AI
            if (order + turn) % 2 == 0 {
                //AIに渡すために敵オバケを隠す
                for i in  0..<6 {
                    for j in 0..<6 {
                        switch field[i][j] {
                        case 1,2:
                            AIField[i][j] = 1
                        case 3:
                            AIField[i][j] = 3
                        case 4:
                            AIField[i][j] = 4
                        default:
                            AIField[i][j] = 0
                        }
                    }
                }
                AIField = AI().move(field: AIField, turn: turn,userRed: ghostTotal.1,userBlue: ghostTotal.0)
                //AIからのを代入
                for i in  0..<6 {
                    for j in 0..<6 {
                        switch AIField[i][j] {
                        case 3:
                            field[i][j] = 3
                        case 4:
                            field[i][j] = 4
                        case 5:
                            exportField[i][j] = 4
                        case 0:
                            field[i][j] = 0
                        default:break
                        }
                    }
                }
                turn += 1
            }
            
            ghostTag = Check().komaCoordinate(field: field)
            //ユーザーの赤青とAIのオバケのtag
            var userRedGhost : [Int] = []
            var userBlueGhost : [Int] = []
            var AIGhost : [Int] = []
            
            for i in 0..<ghostTag.count {
                switch ghostTag[i].color {
                case 1:
                    userRedGhost.append(ghostTag[i].tag)
                case 2:
                    userBlueGhost.append(ghostTag[i].tag)
                case 3,4:
                    AIGhost.append(ghostTag[i].tag)
                default:break
                }
            }
            //オバケを消去
            for eachView in mathsArray {
                Koma().removeKoma(mathView: eachView, tag: ghostTagTotal)
            }
            //オバケの表示
            for mathView in mathsArray {
                for i in 0..<userRedGhost.count {
                    if mathView.tag == userRedGhost[i]{
                        Koma().komaMake(mathView: mathView,komaType: "ghostB",start: true)
                    }
                }
                for j in 0..<userBlueGhost.count {
                    if mathView.tag == userBlueGhost[j]{
                        Koma().komaMake(mathView: mathView,komaType: "ghostR",start: true)
                    }
                }
                for k in 0..<AIGhost.count {
                    if mathView.tag == AIGhost[k]{
                        Koma().komaMake(mathView: mathView,komaType: "ghost",start: false)
                    }
                }
            }
            //オバケの数の確認　表示
            ghostTotal = Check().komaCount(field:field)
            countB_U.text = "x\(ghostTotal.0)"
            countR_U.text = "x\(ghostTotal.1)"
            countR_A.text = "x\(ghostTotal.2)"
            countB_A.text = "x\(ghostTotal.3)"
            
            judgeCount = Check().judge(komaTotal: ghostTotal, exportField: exportField)
        }
        //1:ユーザーの勝ち,2:AIの勝ち
        switch judgeCount {
        case 1:
            label.isHidden = false
            label.text = "あなたの勝ち"
            start = 3
        case 2:
            label.isHidden = false
            label.text = "AIの勝ち"
            start = 3
        default:break
        }
        //ゲーム終了
        if start == 3 {
            end.isHidden = false
            for mathView in mathsArray{
                Check().removeBack(mathView: mathView)
            }
            return
        }
        print(field)
    }
    //オバケの配置の時の数と完了確認
    @IBAction func correct(_ sender: UIButton) {
        ghostTotal = Check().komaCount(field: field)
        label.isHidden = false
        //青のオバケが４つより少ない時
        if ghostTotal.0 < 4 {
            label.text = "青のオバケを４つにしてください"
            //赤のオバケが４つより少ない時
        }else if ghostTotal.1 < 4 {
            label.text = "赤のオバケを４つにしてください"
        }
        //どちらも揃った時
        if ghostTotal.0 == 4 && ghostTotal.1 == 4 {
            
            start = 2
            correct.isHidden = true
            label.isHidden = true
            
            parentView.addSubview(ghostB_U)
            parentView.addSubview(ghostR_U)
            parentView.addSubview(ghostR_A)
            parentView.addSubview(ghostB_A)
            
            countB_U.text = "x\(ghostTotal.0)"
            countR_U.text = "x\(ghostTotal.1)"
            countB_A.text = "x\(ghostTotal.2)"
            countR_A.text = "x\(ghostTotal.3)"
            
            //ユーザーが後攻だった場合
            if (order + turn) % 2 == 0 {
                //AIに渡すために敵オバケを隠す
                ghostTag = Check().komaCoordinate(field: field)
                for i in 0..<ghostTag.count {
                    ghostTagTotal.append(ghostTag[i].tag)
                }
                
                for i in  0..<6 {
                    for j in 0..<6 {
                        switch field[i][j] {
                        case 1,2:
                            AIField[i][j] = 1
                        case 3:
                            AIField[i][j] = 3
                        case 4:
                            AIField[i][j] = 4
                        default:
                            AIField[i][j] = 0
                        }
                    }
                }
                AIField = AI().move(field: AIField, turn: turn,userRed: ghostTotal.0,userBlue: ghostTotal.1)
                //AIからのを代入
                for i in  0..<6 {
                    for j in 0..<6 {
                        switch AIField[i][j] {
                        case 3:
                            field[i][j] = 3
                        case 4:
                            field[i][j] = 4
                        case 5:
                            exportField[i][j] = 4
                        case 0:
                            field[i][j] = 0
                        default:break
                        }
                    }
                }
                turn += 1
            }
            ghostTag = Check().komaCoordinate(field: field)
            
            var userRedGhost : [Int] = []
            var userBlueGhost : [Int] = []
            var AIGhost : [Int] = []
            
            for i in 0..<ghostTag.count {
                switch ghostTag[i].color {
                case 1:
                    userRedGhost.append(ghostTag[i].tag)
                case 2:
                    userBlueGhost.append(ghostTag[i].tag)
                case 3,4:
                    AIGhost.append(ghostTag[i].tag)
                default:break
                }
            }
            //オバケを消去
            for eachView in mathsArray {
                Koma().removeKoma(mathView: eachView, tag: ghostTagTotal)
            }
            
            for mathView in mathsArray {
                for i in 0..<userRedGhost.count {
                    if mathView.tag == userRedGhost[i]{
                        Koma().komaMake(mathView: mathView,komaType: "ghostB",start: true)
                    }
                }
                for j in 0..<userBlueGhost.count {
                    if mathView.tag == userBlueGhost[j]{
                        Koma().komaMake(mathView: mathView,komaType: "ghostR",start: true)
                    }
                }
                for k in 0..<AIGhost.count {
                    if mathView.tag == AIGhost[k]{
                        Koma().komaMake(mathView: mathView,komaType: "ghost",start: false)
                    }
                }
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterName.resignFirstResponder()
        name_U.text = enterName.text
        return true
    }
}

extension UIColor {
    class func lightcolor() -> UIColor {
        return UIColor(red: 0 / 255, green: 255 / 255, blue: 0 / 255, alpha: 0.2)
    }
}
