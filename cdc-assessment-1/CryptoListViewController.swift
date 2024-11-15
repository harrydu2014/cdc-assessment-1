//
//  Untitled.swift
//  cdc-assessment-1
//
//  Created by Harry, Du on 2024/11/15.
//

import SwiftUI

struct CryptoListView: View {
    @State private var cryptos: [CryptoModel] = []
    @State private var showAlert = false
    @State private var showList = false
    
    var body: some View {
        NavigationView {
            VStack {
                if showList {
                    List(cryptos, id: \.title) { crypto in
                        NavigationLink(destination: CryptoDetailView()) {
                            Text(crypto.title)
                                .frame(height: 100)
                        }
                    }
                    .listStyle(PlainListStyle())
                } else {
                    
                    VStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .padding(.bottom, 20)
                        
                        Button(action: loadCrypto) {
                            Text("Load Crypto")
                                .font(.title)
                                .frame(width: UIScreen.main.bounds.width / 2, height: 40)
                                .foregroundColor(Color(red: 0.0, green: 0.176, blue: 0.455))
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Load Crypto With Error"), dismissButton: .default(Text("Dismiss")))
            }
        }
    }

    private func loadCrypto() {
        guard let url = Bundle.main.url(forResource: "crypto_list", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            self.showAlert = true
            return
        }

        do {
            let cryptoResponse = try JSONDecoder().decode(CryptoResponse.self, from: data)
            self.cryptos = cryptoResponse.data
            self.showList = true
        } catch {
            self.showAlert = true
        }
    }
}

struct CryptoResponse: Codable {
    let data: [CryptoModel]
}

#Preview {
    CryptoListView()
}
