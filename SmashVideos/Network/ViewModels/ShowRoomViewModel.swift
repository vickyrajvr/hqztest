//
//  ShowRoomM.swift
//  SmashVideos
//
//  Created by Zubair Ahmed on 11/04/2023.
//

import Foundation
class ShowRoomViewModel {
    fileprivate let service = NetworkManager()
    var message: String?
    var showRoomM : ShowRoomM?
    var roomObjectArray = [ShowRoomObject]()
    
    var showUserJoinRoom : ShowUserJoinedRoomsM?
    var joinRoomArray = [JoinedRoomsObject]()
    
    var joinRoomM : JoinRoomM?
    
    var leaveRoomM : LeaveRoomM?
    
    var deleteRoomM : DeleteRoomM?
    
    var addRoomM : AddRoomM?
    
    var assignModeratorM : AssignModeratorM?
    
    var roomDetailsM : ShowRoomDetailM?
    // ShowRoomApi
    func showRoomApi(endPoint: String, parameters : [String : Any], completion: @escaping ((ViewModelState) -> Void)) {
        service.showRooms(endpoint: endPoint, parameters: parameters) { [weak self] result in
            switch result {
            case .success(let response):
                if (response.code == 200) {
                    self?.showRoomM = response
                    if response.msg?.count ?? 0 > 0 {
                        self?.roomObjectArray = response.msg!
                    }else {
                        
                    }
                    
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
    
    //ShowUserJoinRoomApi
    func ShowUserJoinRoomApi(endPoint: String, parameters : [String : Any], completion: @escaping ((ViewModelState) -> Void)) {
        service.showUserJoinedRooms(endpoint: endPoint, parameters: parameters) { [weak self] result in
            switch result {
            case .success(let response):
                if (response.code == 200) {
                    self?.showUserJoinRoom = response
                    if response.msg?.count ?? 0 > 0 {
                        self?.joinRoomArray = response.msg!
                    }else {
                        
                    }
                    
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
    
    
    //JoinRoomApi
    func joinRoom(endPoint: String, parameters : [String : Any], completion: @escaping ((ViewModelState) -> Void)) {
        service.joinRoom(endpoint: endPoint, parameters: parameters) { [weak self] result in
            switch result {
            case .success(let response):
                if (response.code == 200) {
                    self?.joinRoomM = response
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
    
    //LeaveRoomApi
    func leaveRoom(endPoint: String, parameters : [String : Any], completion: @escaping ((ViewModelState) -> Void)) {
        service.leaveRoom(endpoint: endPoint, parameters: parameters) { [weak self] result in
            switch result {
            case .success(let response):
                if (response.code == 200) {
                    self?.leaveRoomM = response
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
    //DeleteRoomApi
    func deleteRoom(endPoint: String, parameters : [String : Any], completion: @escaping ((ViewModelState) -> Void)) {
        service.deleteRoom(endpoint: endPoint, parameters: parameters) { [weak self] result in
            switch result {
            case .success(let response):
                if (response.code == 200) {
                    self?.deleteRoomM = response
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
    //AddRoomAPI
    func AddRoom(endPoint: String, parameters : [String : Any], completion: @escaping ((ViewModelState) -> Void)) {
        service.AddRoom(endpoint: endPoint, parameters: parameters) { [weak self] result in
            switch result {
            case .success(let response):
                if (response.code == 200) {
                    self?.addRoomM = response
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
    
    //showRoomDetailAPI
    func showRoomDetail(endPoint: String, parameters : [String : Any], completion: @escaping ((ViewModelState) -> Void)) {
        service.showRoomDetail(endpoint: endPoint, parameters: parameters) { [weak self] result in
            switch result {
            case .success(let response):
                if (response.code == 200) {
                    self?.roomDetailsM = response
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
    
    //assignModerator
    func assignModerator(endPoint: String, parameters : [String : Any], completion: @escaping ((ViewModelState) -> Void)) {
        service.assignModerator(endpoint: endPoint, parameters: parameters) { [weak self] result in
            switch result {
            case .success(let response):
                if (response.code == 200) {
                    self?.assignModeratorM = response
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
