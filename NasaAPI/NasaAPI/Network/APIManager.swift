//
//  APIManager.swift
//  NasaAPI
//
//  Created by Fernando Gutiérrez on 04/01/24.
//

import Foundation

protocol APIManagerDelegate {
    func didUpdateAPODData(_ apiManager: APIManager, apod: APODData)
    func didFailWithError(error: Error)
}

struct APIManager {
    
    var delegate: APIManagerDelegate?
    
    func fetchAPOD() {
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=wdP3KAEPlhEP7oHwmHY6Vkm79zdkU3HtssEqvHeF"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // 1.- CREATE A URL
        if let url = URL(string: urlString) {
            // 2.- CREATE A URL SESSION OBJECT
            let session = URLSession(configuration: .default)
            
            // 3.- CREATE A TASK
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data {
                    if let apod = self.parseJSON(safeData) {
                        self.delegate?.didUpdateAPODData(self, apod: apod)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ apodData: Data) -> APODData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(APODData.self, from: apodData)
            print(decodedData)
            let copyright = decodedData.copyright
            let date = decodedData.date
            let explanation = decodedData.explanation
            let hdurl = decodedData.hdurl
            let title = decodedData.title
            let url = decodedData.url
            
            let apod = APODData(copyright: copyright, date: date, explanation: explanation, hdurl: hdurl, title: title, url: url)
            return apod
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
    

