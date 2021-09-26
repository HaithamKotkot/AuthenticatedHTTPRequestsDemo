/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import UIKit
import Alamofire

class Auth {
  static let defaultsKey = "TIL-API-KEY"
  let defaults = UserDefaults.standard

  var token: String? {
    get {
      return defaults.string(forKey: Auth.defaultsKey)
    }
    set {
      defaults.set(newValue, forKey: Auth.defaultsKey)
    }
  }
  
  func logout() {
    self.token = nil
    DispatchQueue.main.async {
      guard let applicationDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      let rootController = UIStoryboard(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginNavigation")
      applicationDelegate.window?.rootViewController = rootController
    }
  }

  func login(username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
    let path = "http://localhost:8080/api/users/login"
    let credentialsHeaders = HTTPHeader.authorization(username: username, password: password)
    AF.request(path, method: .post, headers: [credentialsHeaders]).validate().responseDecodable(of: Token.self) { response in
      switch response.result {
      case .success(let token):
        self.token = token.token
        completion(.success(()))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
