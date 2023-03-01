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




    override func setUpWithError() throws {

        FirebaseApp.configure()

        NetworkService.shared.startMonitoring()

        sut = CheckService()
    }



    override func tearDownWithError() throws {



        NetworkService.shared.stopMonitoring()

        sut = nil
    }



    func testCheckCredentialsSuccess() throws {

        try XCTSkipUnless(
            NetworkService.shared.statusNetworkIsSatisfied,
                    "‼️ Network connectivity needed for this test."
                )

        // given

        var result: String?


        // when

        let expectation = expectation(description: "")

        sut?.checkCredentials(withEmail: "unit@test.ru", password: "123456789a", completion: {  resultCheck in


            // then

            result = resultCheck

            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        XCTAssertEqual(result, "Открыть доступ")
    }

}
