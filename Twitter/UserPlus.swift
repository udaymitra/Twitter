//
//  UserPlus.swift
//  Twitter
//
//  Created by Soumya on 10/11/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class UserPlus: NSObject {
    private(set) var user: User!
    private(set) var favoritesCount: Int?
    private(set) var tweetsCount: Int?
    private(set) var profileBannerImageUrl: NSURL?

    init(dictionary: NSDictionary) {
        self.user = User(dictionary: dictionary)

        tweetsCount = dictionary["statuses_count"] as? Int
        favoritesCount = dictionary["favourites_count"] as? Int
        if let profileBannerUrl = dictionary["profile_banner_url"] as? String {
            profileBannerImageUrl = NSURL(string: profileBannerUrl)
        }
    }
}
