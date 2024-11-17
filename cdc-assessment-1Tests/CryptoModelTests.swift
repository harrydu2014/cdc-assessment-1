//
//  CryptoModelTests.swift
//  cdc-assessment-1Tests
//
//  Created by Harry, Du on 2024/11/17.
//

import XCTest
@testable import cdc_assessment_1

class CryptoModelTests: XCTestCase {

    func testCryptoModelDecoding() {
        guard let url = Bundle.main.url(forResource: "crypto_list", withExtension: "json") else {
            XCTFail("Missing file: crypto_list.json")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let cryptoModels = try decoder.decode([CryptoModel].self, from: data)

            XCTAssertEqual(cryptoModels.count, 3)
            XCTAssertEqual(cryptoModels[0].title, "Bitcoin")
            XCTAssertEqual(cryptoModels[1].title, "Ethereum")
            XCTAssertEqual(cryptoModels[2].title, "Cardano")
        } catch {
            XCTFail("Decoding failed: \(error)")
        }
    }
}
