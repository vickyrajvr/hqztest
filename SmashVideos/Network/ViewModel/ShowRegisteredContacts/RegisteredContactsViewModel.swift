//
//  RegisteredContactsViewModel.swift
//  WOOW
//
//  Created by Zubair Ahmed on 30/03/2023.
//

import Foundation
class RegisteredContactsViewModel {
    fileprivate let service = NetworkManager()
    var message: String?
    var showRegisteredModel : ShowRegisteredContactsM?
    func showRegisteredContacts(endPoint: String, parameters : [String : Any], completion: @escaping ((ViewModelState) -> Void)) {
        service.showRegisteredContacts(endpoint: endPoint, parameters: parameters) { [weak self] result in
            switch result {
            case .success(let response):
                if (response.code == 200) {
                    self?.showRegisteredModel = response
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
