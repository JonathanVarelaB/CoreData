
import Foundation

class User{
    var id: Int16 = 0
    var username: String = ""
    var password: String = ""
    var age: String = ""
    
    init(id: Int16, username: String, password: String, age: String){
        self.id = id
        self.username = username
        self.password = password
        self.age = age
    }
}
