//
//  Operation for downloading info about Person from the database
//

import Foundation

class PersonLoadOperation: Operation {
    let personId: String
    var person: Person?
    var loadingCompleteHandler: (() -> ())?
    
    init(_ personId: String) {
        self.personId = personId
    }
    
    override func main() {
        if isCancelled { return }
        DatabaseManager.getPerson(with: personId, completion: { [weak self] person in
            guard self?.isCancelled == false else { return }
            self?.person = person
            guard let loadingCompleteHandler = self?.loadingCompleteHandler else { return }
            DispatchQueue.main.async {
                loadingCompleteHandler()
            }
        })
    }
}
