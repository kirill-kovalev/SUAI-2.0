import UIKit
import SUAI_API


PocketAPI.shared.setToken("ba222b76bafd64a3650e09f7514a2b1f7c672629d3a42dea2aa614b3a27de256dad08779f00159a548a44")




struct FeedSource{
    let name:String
    let owner_id:Int
}
class SAFeed{
    var sourcelist:[FeedSource] = []
    
    
    
    
    func loadSourceList(){
        PocketAPI.shared.syncLoadTask(method: .getFeedOrder) { (data) in
            do{
                let a = try JSONDecoder().decode([String:Int].self, from: data)
                for (key,value) in a{
                    self.sourcelist.append(FeedSource(name: key, owner_id: value))
                }
            }catch{
                print(error)
            }
        }
    }
    
    
    init() {
        loadSourceList()
    }
    
    
    
    
    
}


// MARK: - FeedElement
struct VKFeedElement:Codable {
    let fromID: Int
    let date: Int
    let text: String
    let comments: VKCountable
    let likes: VKCountable
    let reposts: VKCountable
    let views: VKCountable
    let attachments: [FeedAttachment]?
    
    struct VKCountable:Codable {
        let count: Int
    }
}

// MARK: - FeedAttachment
struct FeedAttachment :Codable{
    let type: AttachmentType
    let photo: Photo?
    let link: Link?
    let video: Video?
    
    enum AttachmentType:String,Codable{
        case audio
        case link
        case photo
        case poll
        case video
    }
}
// MARK: - Photo
struct Photo:Codable {
    let sizes: [Size]
    let text: String
}
// MARK: - Size
struct Size:Codable {
    let height: Int
    let url: String
    let width: Int
}
// MARK: - Link
struct Link :Codable{
    let url: String
    let title: String
    let linkDescription: String
    let photo: Photo
    let caption: String?
}
// MARK: - Video
struct Video:Codable{
    let image: [Size]
    let title: String
}

let f = SAFeed()
f.loadSourceList()
let owner = f.sourcelist.map{$0.owner_id}.first!
PocketAPI.shared.syncLoadTask(method: .getFeed, params:["owner_id":owner]) { (data) in
    do{
        let a = try JSONDecoder().decode([VKFeedElement].self, from: data)
        print(a)
    }catch{
        print(String(data: data, encoding: .utf8))
        print(error)
    }
}






