
import Foundation

enum UserDefaultKey : String {
    case Localize = "localize"
    case userToken = "userToken"
    case userInfo = "userInfo"
}

class LocalStorage {
    static let shared = LocalStorage()
    var token : String {
        return getData(key: .userToken, UserToken.self )?.access_token ?? ""
    }
    var user_id : String {
        return getData(key: .userToken, UserToken.self )?.user_id ?? ""
    }
    
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    func setLocalize(_ localized: String) {
        defaults.setValue(localized, forKey: UserDefaultKey.Localize.rawValue)
        NotificationCenter.default.post(name: .LangeuageChange, object: nil)
    }
    
    func getLocalize() -> String {
        if defaults.object(forKey: UserDefaultKey.Localize.rawValue) != nil {
            return defaults.object(forKey: UserDefaultKey.Localize.rawValue) as! String
        }
        return "en"
    }
    
    func setData ( _ data : Codable  , _ key : UserDefaultKey)
    {
        
        do {
            let data = try encoder.encode(data)
            
            let archivedData = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
            
            defaults.set(archivedData, forKey: key.rawValue )
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func getData < T : Codable > ( key : UserDefaultKey , _ type : T.Type ) -> T? {
        print("getUserInfo")
        
        guard let archivedData = defaults.data(forKey: key.rawValue) else {
            return nil
        }
        
        let data =  NSKeyedUnarchiver.unarchiveObject(with: archivedData) as? Data
        
        return  try? decoder.decode(T.self, from: data!)
    }
    
    //    func setUserInfo( _ userData : UserToken )
    //    {
    //
    //        do {
    //            let data = try encoder.encode(userData)
    //
    //            let archivedData = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
    //
    //            defaults.set(archivedData, forKey: UserDefaultKey.userToken)
    //        }catch {
    //            print(error.localizedDescription)
    //        }
    //
    //    }
    
    //    func getUserInfo() -> UserToken?
    //    {
    //        print("getUserInfo")
    //
    //        guard let archivedData = defaults.data(forKey: UserDefaultKey.userToken) else {
    //            return nil
    //        }
    //
    //        let data =  NSKeyedUnarchiver.unarchiveObject(with: archivedData) as? Data
    //
    //        return  try? decoder.decode(UserToken.self, from: data!)
    //
    //    }
    //
    
    //    func setUserInfo( _ userData : User )
    //    {
    //
    //        do {
    //            let data = try encoder.encode(userData)
    //
    //            let archivedData = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
    //
    //            defaults.set(archivedData, forKey: UserDefaultKey.userInfo)
    //        }catch {
    //            print(error.localizedDescription)
    //        }
    //
    //    }
    //
    //    func getUserInfo() -> UserToken?
    //    {
    //        print("getUserInfo")
    //
    //        guard let archivedData = defaults.data(forKey: UserDefaultKey.userToken) else {
    //            return nil
    //        }
    //
    //        let data =  NSKeyedUnarchiver.unarchiveObject(with: archivedData) as? Data
    //
    //        return  try? decoder.decode(UserToken.self, from: data!)
    //
    //    }
    
    
    
}
