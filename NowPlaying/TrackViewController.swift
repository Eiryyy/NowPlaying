import Cocoa

class TrackViewController: NSViewController, TrackInfoDelegate {

    var trackInfoController = TrackInfoController()
    @IBOutlet weak var artistLabel: NSTextField!
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var albumLabel: NSTextField!
    @IBOutlet weak var tweetButon: NSButton!
    
    @IBAction func buttonClicked (sender: AnyObject) {
        let sharingService = NSSharingService(named: NSSharingServiceNamePostOnTwitter)
        let trackInfo = trackInfoController.getInfo()
        let text = trackInfo["name"]! + " / " + trackInfo["artist"]! + " #nowplaying"
        sharingService?.performWithItems([text])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackInfoController.delegate = self
        NSDistributedNotificationCenter.defaultCenter().addObserver(trackInfoController, selector: "onPlay:", name: "com.apple.iTunes.playerInfo", object: nil)
        updateTrackInfo(trackInfoController.getInfo())
    }
    
    func updateTrackInfo(info: Dictionary<String, String>) {
        artistLabel.stringValue = info["artist"]!
        nameLabel.stringValue = info["name"]!
        albumLabel.stringValue = info["album"]!
    }
    
}
