import UIKit
import SpriteKit

class ShopViewController: UIViewController {

    weak var gameVC: GameViewController?
    
    @IBOutlet var currentSkinDescriptionLabel: UILabel!
    @IBOutlet var currentSkinCoinCostLabel: UILabel!
    @IBOutlet var currentSkinNameLabel: UILabel!
    @IBOutlet var coinCountLabel: UILabel!
    @IBOutlet var selectOrBuyButton: UIButton!
    @IBOutlet var priceView: UIView!
    @IBOutlet var unlockedLabel: UILabel!
    
    var currentIndex = 0
    var skinShowing: Skin?
    let skins = SkinsSingleton.shared.skins
    
    init(gameVC: GameViewController) {
        self.gameVC = gameVC
        super.init(nibName: "ShopViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skinShowing = skins[currentIndex]
        coinCountLabel.text = "\(UserDefaultsService.fetchCoinsCount())"
        gameVC?.currentGame?.deadNodeLeft.alpha = 0
        gameVC?.currentGame?.deadNodeRight.alpha = 0
        gameVC?.currentGame?.player.node.alpha = 1
        gameVC?.currentGame?.player.moveToInitialPosition()
        gameVC?.currentGame?.prepareCenario()
        gameVC?.currentGame?.count = 0
        gameVC?.currentGame?.prepareCenario()
        reloadData()
    }
    
    func selectSkin(_ skin: Skin) {
        // To do
        print("Select skin")
        UserDefaultsService.setSelectedSkinName(skin.name)
        reloadData()
    }
    
    func buySkin(_ skin: Skin) {
        // To do
        print("Buy skin")
        
        var coinsCount = UserDefaultsService.fetchCoinsCount()
        
        if coinsCount >= (skin.coinCost!) {
            coinsCount -= skin.coinCost!
            UserDefaultsService.setCoinsCount(coinsCount)
            
            var unlockedSkinNamesArray = UserDefaultsService.fetchUnlockedSkinsNames()
            unlockedSkinNamesArray.append(skin.name)
            UserDefaultsService.setUnlockedSkinsNames(unlockedSkinNamesArray)
            
            reloadData()
        }
    }
    
    func isSkinUnlocked(_ skin: Skin) -> Bool {
        let unlockedSkinsNames = UserDefaultsService.fetchUnlockedSkinsNames()
        if unlockedSkinsNames.contains(skinShowing!.name) {
            return true
        } else {
            return false
        }
    }
    
    func isSkinSelected(_ skin: Skin) -> Bool {
        let skinImageNameSelected = UserDefaultsService.fetchSelectedSkinName()
        if skin.name == skinImageNameSelected {
            return true
        } else {
            return false
        }
    }
    
    func previousSkin() {
        if currentIndex > 0 {
            print("Previous skin")
            currentIndex -= 1
            reloadData()
        }
    }
    
    func nextSkin() {
        if currentIndex < skins.count - 1 {
            print("Next skin")
            currentIndex += 1
            reloadData()
        }
    }
    
    func buyAllSkins() {
        // To do
    }
    
    func closeShop() {
        self.view.removeFromSuperview()
        self.removeFromParent()
        gameVC?.showHome()
        
        let selectedSkin = SkinsSingleton.shared.skins.first { skin in
            skin.name == UserDefaultsService.fetchSelectedSkinName()
        }
        
        gameVC?.currentGame?.player.node.texture = SKTexture(imageNamed: selectedSkin!.spriteImageName)
    }
    
    func reloadData() {
        skinShowing = skins[currentIndex]
        currentSkinNameLabel.text = skinShowing?.name.uppercased()
        currentSkinDescriptionLabel.text = skinShowing?.description
        currentSkinCoinCostLabel.text = "\(skinShowing?.coinCost ?? 0)"
        gameVC?.currentGame?.player.node.texture = SKTexture(imageNamed: skinShowing!.spriteImageName)
        coinCountLabel.text = "\(UserDefaultsService.fetchCoinsCount())"
        
        if isSkinUnlocked(skinShowing!) {
            selectOrBuyButton.setTitle("SELECT", for: .normal)
            selectOrBuyButton.alpha = 1
            priceView.alpha = 0
            unlockedLabel.alpha = 1
        } else {
            selectOrBuyButton.setTitle("BUY", for: .normal)
            selectOrBuyButton.alpha = 1
            priceView.alpha = 1
            unlockedLabel.alpha = 0
        }
        
        if isSkinSelected(skinShowing!) {
            selectOrBuyButton.setTitle("SELECTED", for: .normal)
            selectOrBuyButton.alpha = 0.8
        }
    }
    
    @IBAction func closeShop(_ sender: Any) {
        closeShop()
    }
    
    @IBAction func previousSkin(_ sender: Any) {
        previousSkin()
    }
    
    @IBAction func nextSkin(_ sender: Any) {
        nextSkin()
    }
    
    @IBAction func selectOrBuy(_ sender: Any) {
        if isSkinUnlocked(skinShowing!) {
            selectSkin(skinShowing!)
        } else {
            buySkin(skinShowing!)
        }
    }
}
