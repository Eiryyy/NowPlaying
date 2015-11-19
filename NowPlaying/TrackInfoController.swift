import Foundation
import Cocoa

protocol TrackInfoDelegate: class {
    func updateTrackInfo(info: Dictionary<String,String>, image: NSImage?)
}

class TrackInfoController: NSObject {
    var delegate: TrackInfoDelegate! = nil
    private var store: Dictionary<String,String> = [
        "name": "No name",
        "artist": "No artist",
        "album": "No album"
    ]
    private var imageStore: NSImage?
    override init() {
        super.init()
        self.setStore()
    }
    
    func onPlay (notification: NSNotification?) {
        self.setStore()
        delegate.updateTrackInfo(self.store, image: self.imageStore)
    }
    
    func setStore () {
        let appleScript = "tell application \"iTunes\"\n"
            + "set trackName to name of current track\n"
            + "set trackArtist to artist of current track\n"
            + "set trackAlbum to album of current track\n"
            + "tell artwork 1 of current track\n"
            + "set artData to raw data\n"
            + "end tell\n"
            + "return {trackName,trackArtist,trackAlbum,artData}\n"
            + "end tell"
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: appleScript) {
            if let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error) {
                self.store["name"] = output.descriptorAtIndex(1)?.stringValue! ?? "No name"
                self.store["artist"] = output.descriptorAtIndex(2)?.stringValue! ?? "No artist"
                self.store["album"] = output.descriptorAtIndex(3)?.stringValue! ?? "No album"
                if let imageData = output.descriptorAtIndex(4)?.data {
                    let image = NSImage(data: imageData)
                    self.imageStore = image
                } else {
                    self.imageStore = nil
                }
            }
        }
    }
    
    func getInfo () -> Dictionary<String,String> {
        return self.store
    }
    
    func getImage () -> NSImage? {
        return self.imageStore
    }
    
}