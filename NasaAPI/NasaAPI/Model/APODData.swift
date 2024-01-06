//
//  APODData.swift
//  NasaAPI
//
//  Created by Fernando Gutiérrez on 04/01/24.
//

import Foundation

struct APODData: Decodable {
    let copyright: String
    let date: String
    let explanation: String
    let hdurl: String
    let title: String
    let url: String
}

