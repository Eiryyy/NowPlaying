import Foundation

protocol TrackInfoDelegate: class {
    func updateTrackInfo(info: Dictionary<String,String>)
}

class TrackInfoController: NSObject {
    var delegate: TrackInfoDelegate! = nil
    private var store: Dictionary<String,String> = [
            "artist": "No artist",
            "name": "No name",
            "album": "No album"
        ]
    override init() {
        let appleScript = "tell application \"iTunes\"\n"
            + "set trackName to name of current track\n"
            + "set trackArtist to artist of current track\n"
            + "set trackAlbum to album of current track\n"
            + "return {trackName,trackArtist,trackAlbum}\n"
            + "end tell"
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: appleScript) {
            if let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error) {
                self.store["name"] = (output.descriptorAtIndex(1)?.stringValue)!
                self.store["artist"] = (output.descriptorAtIndex(2)?.stringValue)!
                self.store["album"] = (output.descriptorAtIndex(3)?.stringValue)!
            }
        }
    }
    func onPlay (notification: NSNotification?) {
        self.store["artist"] = notification?.userInfo?["Artist"] as? String ?? "No artist"
        self.store["name"] = notification?.userInfo?["Name"] as? String ?? "No name"
        self.store["album"] = notification?.userInfo?["Album"] as? String ?? "No album"
        delegate.updateTrackInfo(self.store)
    }
    
    func getInfo () -> Dictionary<String,String> {
        return self.store
    }
    
}