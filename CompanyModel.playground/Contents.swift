

class Employee: CustomStringConvertible {
    enum Gender: String {
        case man
        case woman
    }
    
    let name: String
    var gender: Gender
    weak var team: Team?
    
    
    init(name: String, gender: Gender) {
        self.name = name
        self.gender = gender
    }
    
    var description: String {
        return "Hi, I'm \(name)"
    }
}


extension Employee: Equatable {
    static func == (lhs: Employee, rhs: Employee) -> Bool {
        return lhs.name == rhs.name && lhs.gender == rhs.gender
    }
}


class Designer: Employee {
    var project: String?
    
    func design(project: String) {
        self.project = project
    }
    
    override var description: String {
        var str = super.description
        str += "\nI'm a Designer " + (project != nil ? "Working on \(project!)" : "")
        
        return str
    }
}

class Developer: Employee {
    enum Platform: String {
        case ios
        case android
        case web
    }
    
    var platform: Platform
    var project: String?
    
    init(name: String, gender: Gender, platform: Platform) {
        self.platform = platform
        super.init(name: name, gender: gender)
    }
    
    func develop(project: String) {
        self.project = project
    }
    
    override var description: String {
        var str = super.description
        str += "\nI'm a \(platform.rawValue) Developer " + (project != nil ? "Working on \(project!)" : "")
        
        return str
    }
}


class ProductManager: Employee {
    var project: String?
    
    func manage(project: String) {
        self.project = project
    }
    
    override var description: String {
        var str = super.description
        str += "\nI'm a Product Manager " + (project != nil ? "Working on \(project!)" : "")
        
        return str
    }
}


class Team {
    enum Profession: String {
        case developer = "Developer"
        case designer = "Designer"
        case productManager = "Product Manager"
        
        static func profession(for member: Employee) -> Profession? {
            switch member {
            case is Developer:
                return .developer
            case is Designer:
                return .designer
            case is ProductManager:
                return .productManager
            default:
                return nil
            }
        }
    }
    
    var name: String
    var members: [Profession: [Employee]]
    
    init(name: String) {
        self.name = name
        members = [.developer: [],
                   .designer: [],
                   .productManager: [] ]
    }
    
    func add(member: Employee) {
        guard let profession = Profession.profession(for: member) else {
            return
        }
        
        members[profession]?.append(member)
        member.team = self
    }

}

extension Team: CustomStringConvertible {
    var description: String {
        var str = "\(self.name.uppercased()) \n"
        for (profession, employees) in members {
            str += "\n" + profession.rawValue.uppercased() + "\n"
            str += employees.map { $0.name }.joined(separator: ", ") + "\n"
        }
        return str
    }
}

class Company {
    var name: String
    var employees = [Employee]()
    var teams = [Team]()
    
    init(name: String) {
        self.name = name
    }
    
    func register(employee: Employee, team: Team) {
        if !employees.contains(employee) {
            employees.append(employee)
            team.add(member: employee)
        }
    }
    
    func createTeam(name: String, members: [Employee]) {
        let newTeam = Team(name: name)

        for employee in members {
            newTeam.add(member: employee)
            }
        teams.append(newTeam)
        }
    
}

extension Company: CustomStringConvertible {
    var description: String {
        var str = "Company: \(self.name.uppercased()) \n"
        str += teams.map { $0.description }.joined(separator: "\n\n\n")
        
        return str
    }
}

// First Team
var james: Designer! = Designer(name: "James", gender: .man)
var patricia: Designer! = Designer(name: "Patricia", gender: .man)

var john: ProductManager! = ProductManager(name: "Jhon", gender: .man)

var mary: Developer! = Developer(name: "Mary", gender: .woman, platform: .ios)
var richard: Developer! = Developer(name: "Richrad", gender: .man, platform: .ios)
var susan: Developer! = Developer(name: "Susan", gender: .woman, platform: .web)


// Second Team
var robert: Designer! = Designer(name: "Robert", gender: .man)
var jennifer: Designer! = Designer(name: "Jenifer", gender: .woman)

var elizabeth: ProductManager! = ProductManager(name: "Elizabet", gender: .woman)
var david: ProductManager! = ProductManager(name: "David", gender: .man)

var jessica: Developer! = Developer(name: "Jesica", gender: .woman, platform: .ios)
var thomas: Developer! = Developer(name: "Thomas", gender: .man, platform: .android)
// Registrated
var joseph: Developer! = Developer(name: "Joseph", gender: .man, platform: .web)


// Create company
var firstCompany: Company! = Company(name: "First Company")
firstCompany.createTeam(name: "First Team", members: [james, patricia, john, mary, richard, susan])
firstCompany.createTeam(name: "Second Team", members: [robert, jennifer, elizabeth, david, jessica, thomas])

firstCompany.register(employee: joseph, team: firstCompany.teams.first { $0.name == "Second Team" }! )

print(firstCompany!)
//print(joseph!)


