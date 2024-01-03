//
//  AdViewModel.swift
//  SmashVideos
//
//  Created by Mac on 28/07/2023.
//

import Foundation

class AdViewModel {
    fileprivate let service = NetworkManager()
    var message: String?
    var AddPromotionM : AddPromotionM?
   
    //addPromotionApi
    func addPromotionApi(endPoint: String, parameters : [String : Any], completion: @escaping ((ViewModelState) -> Void)) {
        service.addPromotion(endpoint: endPoint, parameters: parameters) { [weak self] result in
            switch result {
            case .success(let response):
                if (response.code == 200) {
                    self?.AddPromotionM = response
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
