//
// Operation for downloading info about Person from the database
//

import Foundation

class PersonLoadOperation: Operation {
    let personId: String
    var person: Person?
    var loadingCompleteHandler: ((Person) -> ())?
    
    init(_ personId: String) {
        self.personId = personId
    }
    
    override func main() {
        if isCancelled { return }
        DatabaseManager.getPerson(with: personId, completion: { [weak self] person in
            guard self?.isCancelled == false else { return }
            guard let loadingCompleteHandler = self?.loadingCompleteHandler,
                let person = person else { return }
            DispatchQueue.main.async {
                loadingCompleteHandler(person)
            }
        })
    }
}
