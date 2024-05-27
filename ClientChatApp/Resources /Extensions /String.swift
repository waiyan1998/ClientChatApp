
import Foundation

extension String {
    
    var isValid  : Bool {
        
        return self == "" || self.isEmpty  ? false : true
        
    }
    
    var firstCharactor: String? {
           guard self.count > 0 else {
               return nil
           }
           return String(self.prefix(1))
       }
    
    func decode<T : Codable> ( as type : T.Type ) -> T?{
        let decoder = JSONDecoder()
        let data = self.data(using: .utf8)
        
        return try? decoder.decode(T.self, from: data!)
    }
    
}
