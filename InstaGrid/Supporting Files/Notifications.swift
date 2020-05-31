//
//  Notifications.swift
//  InstaGrid
//
//  Created by Lomig Enfroy on 31/05/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let pictureChanged = Notification.Name("PicturesChanged")
    static let layoutChanged  = Notification.Name("LayoutChanged")
}

extension Notification {
  enum Key: String {
    case images
    case layout
  }
}
