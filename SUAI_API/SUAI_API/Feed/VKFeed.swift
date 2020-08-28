//
//  VKFeed.swift
//  SUAI_API
//
//  Created by Кирилл on 28.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation


// MARK: - FeedElement
struct VKFeedElement:Codable {
    let from_id: Int
    let date: Int
    let text: String?
    let comments: VKCountable
    let likes: VKCountable
    let reposts: VKCountable
    let views: VKCountable
    let attachments: [FeedAttachment]?
    
    struct VKCountable:Codable {
        let count: Int
    }

    // MARK: - FeedAttachment
    struct FeedAttachment :Codable{
        let type: String
        let photo: Photo?
        let link: Link?
        let video: Video?
        
        enum AttachmentType:String,Codable{
            case audio = "audio"
            case link = "link"
            case photo = "photo"
            case poll = "poll"
            case video = "video"
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
}
