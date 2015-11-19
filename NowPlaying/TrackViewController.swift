import Cocoa

class TrackViewController: NSViewController, TrackInfoDelegate {

    var trackInfoController = TrackInfoController()
    @IBOutlet weak var artistLabel: NSTextField!
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var albumLabel: NSTextField!
    @IBOutlet weak var tweetButon: NSButton!
    @IBOutlet weak var albumImage: NSImageView!
    
    @IBAction func buttonClicked (sender: AnyObject) {
        let sharingService = NSSharingService(named: NSSharingServiceNamePostOnTwitter)
        let trackInfo = trackInfoController.getInfo()
        let trackImage = trackInfoController.getImage()
        let text = trackInfo["name"]! + " / " + trackInfo["artist"]! + " #nowplaying"
        var items: [AnyObject] = [text]
        if trackImage != nil {
            items.append(trackImage!)
        }
        sharingService?.performWithItems(items)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackInfoController.delegate = self
        NSDistributedNotificationCenter.defaultCenter().addObserver(trackInfoController, selector: "onPlay:", name: "com.apple.iTunes.playerInfo", object: nil)
        updateTrackInfo(trackInfoController.getInfo(), image: trackInfoController.getImage())
    }
    
    func updateTrackInfo(info: Dictionary<String, String>, image: NSImage?) {
        artistLabel.stringValue = info["artist"]!
        nameLabel.stringValue = info["name"]!
        albumLabel.stringValue = info["album"]!
        albumImage.image = image
    }
    
}
