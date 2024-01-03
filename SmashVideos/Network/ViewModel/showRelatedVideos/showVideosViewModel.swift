//
//  showVideosViewModel.swift
//  WOOW
//
//  Created by Zubair Ahmed on 24/11/2022.
//

import Foundation
class showVideosViewModel {
    fileprivate let service = NetworkManager()
    var showvideoModel : showVideosModel?
    var videoModelArray = [VideosModel]()
    
    var videoDetails : VideoDetailModel?
    var message: String?
    func showRelatedVideo(endPoint: String, parameters : [String : Any], completion: @escaping ((ViewModelState) -> Void)) {
        service.showRelatedVideos(endpoint: endPoint, parameters: parameters) { [weak self] result in
            switch result {
            case .success(let response):
                if (response.code == 200) {
                    self?.showvideoModel = response
                    completion(.success)
                }else{
                    completion(.failure)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                self?.message = error.localizedDescription
                completion(.failure)
            }
        }
    }
    
    func showVideoDetail(endPoint: String, parameters : [String : Any], completion: @escaping ((ViewModelState) -> Void)) {
        service.showVideoDetail(endpoint: endPoint, parameters: parameters) { [weak self] result in
            switch result {
            case .success(let response):
                if (response.code == 200) {
                    self?.videoDetails = response
                    completion(.success)
                }else{
                    completion(.failure)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                self?.message = error.localizedDescription
                completion(.failure)
            }
        }
    }
}
