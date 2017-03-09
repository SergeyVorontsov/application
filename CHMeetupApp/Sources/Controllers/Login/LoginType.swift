//
//  LoginType.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 27/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

enum LoginType {
  case vk
  case fb
  case twitter

  var title: String {
    switch self {
    case .vk:
      return "VK"
    case .fb:
      return "Facebook"
    case .twitter:
      return "Twitter"
    }
  }

  var schemeAuth: URL? {
    let schemeAuthString: String
    switch self {
    case .vk:
      // swiftlint:disable:next line_length
      schemeAuthString = "vkauthorize://authorize?sdk_version=1.4.6&client_id=\(Constants.Vkontakte.clientId)&scope=\(Constants.Vkontakte.scope)&revoke=1&v=5.40"
    case .fb, .twitter:
      return nil
    }
    return URL(string: schemeAuthString)
  }

  var scheme: URL {
    var schemeString: String
    switch self {
    case .vk:
      schemeString = "vk://"
    case .fb:
      schemeString = "fb://"
    case .twitter:
      schemeString = "twitter://"
    }
    return URL(string: schemeString)!
  }

  var urlAuth: URL {
    let urlAuthString: String
    switch self {
    case .vk:
      // swiftlint:disable:next line_length
      urlAuthString = "https://oauth.vk.com/authorize?revoke=1&response_type=token&display=mobile&scope=\(Constants.Vkontakte.scope)&v=5.40&redirect_uri=\(Constants.Vkontakte.redirect)&sdk_version=1.4.6&client_id=\(Constants.Vkontakte.clientId)"
    case .fb:
      // swiftlint:disable:next line_length
      urlAuthString = "https://www.facebook.com/v2.8/dialog/oauth?client_id=\(Constants.Facebook.clientId)&redirect_uri=\(Constants.Facebook.redirect)"
    case .twitter:
      urlAuthString = ""
    }
    return URL(string: urlAuthString)!
  }

  var isAppExists: Bool {
    switch self {
    case .vk:
      return UIApplication.shared.canOpenURL(LoginType.vk.scheme)
    case .fb, .twitter:
      return false
    }
  }

  func token(from url: URL) -> String {
    let fromUrl: String = url.absoluteString
    var firstPosition: Int
    var lastPosition: Int
    switch self {
    case .vk:
      let findStringBegin = "access_token="
      let findStringEnd = "&expires_in"
      let rangeBegin = fromUrl.range(of: findStringBegin)!
      let rangeEnd = fromUrl.range(of: findStringEnd)!
      let indexBegin = fromUrl.distance(from: fromUrl.startIndex, to: rangeBegin.lowerBound)
      let indexEnd =  fromUrl.distance(from: fromUrl.startIndex, to: rangeEnd.lowerBound)
      firstPosition = Int(indexBegin.toIntMax() + findStringBegin.characters.count)
      lastPosition =  Int(indexEnd.toIntMax())
    case .fb:
      let findStringBegin = "code="
      let range = fromUrl.range(of: findStringBegin)!
      let index = fromUrl.distance(from: fromUrl.startIndex, to: range.lowerBound)
      firstPosition = Int(index.toIntMax() + findStringBegin.characters.count)
      lastPosition = Int(fromUrl.distance(from: fromUrl.startIndex, to: fromUrl.endIndex).toIntMax())
    case .twitter:
      return ""
    }
    return fromUrl.substring(with: Range<Int>(uncheckedBounds: (firstPosition, lastPosition)))
  }

}
