
import Foundation

struct UserDefaultKey {
    static let Localize = "localize"
    static let userInfo = "userInfo"
}

class LocalStorage {
    static let shared = LocalStorage()
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    func setLocalize(_ localized: String) {
        defaults.setValue(localized, forKey: UserDefaultKey.Localize)
        NotificationCenter.default.post(name: .LangeuageChange, object: nil)
    }
    
    func getLocalize() -> String {
        if defaults.object(forKey: UserDefaultKey.Localize) != nil {
            return defaults.object(forKey: UserDefaultKey.Localize) as! String
        }
        return "en"
    }
    
    func setUserInfo( _ userData : UserToken )
    {
       
        do {
            let data = try encoder.encode(userData)
            
            let archivedData = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
            
            defaults.set(archivedData, forKey: UserDefaultKey.userInfo)
        }catch {
            print(error.localizedDescription)
        }
       
    }
    
    func getUserInfo() -> UserToken?
    {
        print("getUserInfo")

        guard let archivedData = defaults.data(forKey: UserDefaultKey.userInfo) else {
            return nil
        }
        
        let data =  NSKeyedUnarchiver.unarchiveObject(with: archivedData) as? Data
    
        return  try? decoder.decode(UserToken.self, from: data!)
       
    }
    
  
    
}
