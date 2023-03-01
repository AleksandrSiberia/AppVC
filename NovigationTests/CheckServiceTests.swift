//
//  CheckServiceTests.swift
//  NovigationTests
//
//  Created by Александр Хмыров on 01.03.2023.
//

import Foundation
import XCTest
import FirebaseAuth
import FirebaseCore

@testable import Novigation



final class CheckServiceTests: XCTestCase {

    var sut: CheckService?

    var handle: AuthStateDidChangeListenerHandle?

    var resultCheck: String?




    override func setUpWithError() throws {

        FirebaseApp.configure()

        sut = CheckService()
    }


    override func tearDownWithError() throws {

    }


    func testCheckCredentials() {


        // when

        handle = Auth.auth().addStateDidChangeListener { auth, user in

        }

//        Auth.auth().signIn(withEmail: "unit@test.ru", password: "123456789a") {_,_ in
//
//            print("🏓")
//        }

        sut?.checkCredentials(withEmail: "unit@test.ru", password: "123456789a", completion: {  resultCheck in


            // then

            self.resultCheck = resultCheck
        })

        XCTAssertEqual(self.resultCheck , "Открыть доступ")

    }
}
