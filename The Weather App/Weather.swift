//
//  Weather.swift
//  The Weather App
//
//  Created by yusuf_kildan on 15/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import Foundation
class Weather {
    private var _url : String!
    
    var url : String{
        return _url
    }
    
    init(url : String ){
        self._url = url
    }
}