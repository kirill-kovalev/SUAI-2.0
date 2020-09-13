// MARK: - FeedElement
public struct VKFeedElement:Codable {
    let from_id: Int
	let id: Int
    let date: Int
    let text: String?
    let comments: VKCountable?
    let likes: VKCountable?
    let reposts: VKCountable?
    let views: VKCountable?
    let attachments: [FeedAttachment]?
    let copy_history:[VKFeedElement]?
    
    struct VKCountable:Codable {
        let count: Int
    }

    // MARK: - FeedAttachment
    struct FeedAttachment :Codable{
        let type: String
        let photo: Photo?
        let link: Link?
        let video: Video?
        let doc:Doc?
    }
    // MARK: - Photo
    struct Photo:Codable {
        let sizes: [Size]
        let text: String?
    }
    // MARK: - Doc
    struct Doc:Codable {
        let preview: Preview?
        let title: String?
    }
    struct Preview:Codable{
        let photo: Photo?
    }
    // MARK: - Size
    struct Size:Codable {
        let height: Int
        let url: String?
        let src: String?
        let width: Int
    }
    // MARK: - Link
    struct Link :Codable{
        let url: String
        let title: String
        let description: String
        let photo: Photo?
        let caption: String?
    }
    // MARK: - Video
    struct Video:Codable{
        let image: [Size]
        let title: String
    }
    
    
    public func getPhoto() -> String?{
        let attachs = self.attachments
        if attachs != nil {
            for attach in attachs! {
                if attach.type == "photo"{
                    let url = attach.photo?.sizes.last?.url
                    if url != nil { return url}
                } else if attach.type == "link"{
                    let url = attach.link?.photo?.sizes.last?.url
                    if url != nil { return url}
                } else if attach.type == "video"{
                    let url = attach.video?.image.last?.url
                    if url != nil { return url}
                }
                else if attach.type == "doc"{
                    let url = attach.doc?.preview?.photo?.sizes.last?.src
                    if url != nil { return url}
                }
            }
        }
        if self.copy_history != nil {
            for post in self.copy_history! {
                let url = post.getPhoto()
                if url != nil { return url}
            }
        }
        return nil
    }
    public func getLikes() ->Int {
        return self.likes?.count ?? 0
    }
    public func getReposts() ->Int {
        return self.reposts?.count ?? 0
    }
    public func getComments() ->Int {
        return self.comments?.count ?? 0
    }
    public func getViews() ->Int {
        return self.views?.count ?? 0
    }
    
    public func getDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self.date))
    }
    public func getText() ->String{
		
        return self.text ??
			self.attachments?.first?.link?.title ??
			self.attachments?.first?.photo?.text ??
			self.attachments?.first?.video?.title ??
			self.attachments?.first?.doc?.title ?? ""
    }
    
    
}
