import UIKit
import CoreData

class ViewController: UITableViewController{
    
    var appDelegate: AppDelegate? = nil
    var context: NSManagedObjectContext? = nil
    var entity: NSEntityDescription? = nil
    var newUser: AnyObject? = nil
    var users: [User] = []
    var counter: Int16 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.context = self.appDelegate?.persistentContainer.viewContext
        self.entity = NSEntityDescription.entity(forEntityName: "Users", in: self.context!)
        self.load()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = self.users[indexPath.row].username
        cell.detailTextLabel?.text = self.users[indexPath.row].age
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let update = UITableViewRowAction(style: .normal, title: "Update") { action, index in
            self.update(index: editActionsForRowAt[1])
        }
        update.backgroundColor = .blue
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.delete(index: editActionsForRowAt[1])
        }
        delete.backgroundColor = .red
        return [update, delete]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func load(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do{
            let result = try self.context?.fetch(request) as! [Users]
            if result.last != nil{
                self.counter = (result.last?.id)!
            }
            var id: Int16 = 0
            var username: String = ""
            var password: String = ""
            var age: String = ""
            var currentUser: User? = nil
            self.users = []
            for data in result as [NSManagedObject] {
                id = data.value(forKey: "id") as! Int16
                username = data.value(forKey: "username") as! String
                password = data.value(forKey: "password") as! String
                age = data.value(forKey: "age") as! String
                currentUser = User(id: id, username: username, password: password, age: age)
                self.users.append(currentUser!)
            }
            self.tableView.reloadData()
        }
        catch{
            print("Failed load")
        }
    }
    
    func add(){
        self.newUser = NSManagedObject(entity: self.entity!, insertInto: self.context)
        self.counter += 1
        self.newUser?.setValue(self.counter, forKey: "id")
        self.newUser?.setValue("Usuario \(self.counter)", forKey: "username")
        self.newUser?.setValue("pass\(self.counter)", forKey: "password")
        self.newUser?.setValue("\(self.counter * 2)", forKey: "age")
        self.commit()
        self.load()
    }
    
    func delete(index: Int){
        let predicate = NSPredicate(format: "id == %d", self.users[index].id)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetchRequest.predicate = predicate
        do {
            let fetchedEntities = try self.context?.fetch(fetchRequest)
            if let entityToDelete = fetchedEntities?.first {
                self.context?.delete(entityToDelete as! NSManagedObject)
            }
        } catch {
            // Do something in response to error condition
        }
        self.commit()
        self.load()
    }
    
    func update(index: Int){
        let predicate = NSPredicate(format: "id == %d", self.users[index].id)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetchRequest.predicate = predicate
        do {
            let fetchedEntities = try self.context?.fetch(fetchRequest) as! [Users]
            fetchedEntities.first?.age = "100"
        } catch {
            // Do something in response to error condition
        }
        self.commit()
        self.load()
    }
    
    func commit(){
        do{
            try self.context?.save()
        }
        catch{
            print("Failed saving")
        }
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        self.add()
    }
    
}

