//
//  ProfileView.swift
//  meokQ-Boss-ios
//
//  Created by apple on 10/10/23.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    @AppStorage("uid") var uid: String = ""
    
    @State private var isShowingImagePicker: Bool = false
    @State private var selectedImage = UIImage()
    @Binding var viewTitle: String
    @Binding var mode: EditedMode
    
    @ObservedObject var marketStore: MarketStore
    @FocusState private var isFocused: Bool
    @StateObject private var keyboardHandler = KeyboardHandler()
    
    var body: some View {
        ScrollView(.vertical) {
            BackgroundHStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("상호명")
                    switch mode {
                    case .edit:
                        TextField("상호명을 입력해주세요", text: $marketStore.market.name)
                            .focused($isFocused)
                    case .view:
                        Text(marketStore.market.name == "" ? "미등록" : marketStore.market.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Spacer()
                Button(action: {
                    isShowingImagePicker = true
                }) {
                    if marketStore.market.marketImages == "" {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        KFImage(URL(string: "\(marketStore.market.marketImages)"))
                            .placeholder { //플레이스 홀더 설정
                                Image(uiImage: selectedImage)
                            }
                            .onSuccess {r in //성공
                                Log("King succes: \(r)")
                            }
                            .onFailure { e in //실패
                                Log("King failure: \(e)")
                            }
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(width: 80, height: 80)
                .background {
                    Color.gray
                }
                .cornerRadius(40)
                .disabled(mode == .view)
            }
            BackgroundHStack {
                Text("퀘스트 개수")
                Text("\(marketStore.market.missionCount)개")
            }
            BackgroundVStack {
                Text("주소")
                switch mode {
                case .edit:
                    TextField("주소를 입력해주세요", text: $marketStore.market.address)
                        .focused($isFocused)
                case .view:
                    Text(marketStore.market.name == "" ? "미등록" : marketStore.market.address)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            BackgroundVStack {
                Text("영업 시작 시간")
                switch mode {
                case .edit:
                    TextField("영업 시작 시간을 입력해주세요", text: $marketStore.market.openingTime)
                        .focused($isFocused)
                case .view:
                    Text(marketStore.market.name == "" ? "미등록" : marketStore.market.openingTime)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            BackgroundVStack {
                Text("영업 마감 시간")
                switch mode {
                case .edit:
                    TextField("영업 마감 시간을 입력해주세요", text: $marketStore.market.closingTime)
                        .focused($isFocused)
                case .view:
                    Text(marketStore.market.name == "" ? "미등록" : marketStore.market.closingTime)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            BackgroundVStack {
                Text("영업장 전화번호")
                switch mode {
                case .edit:
                    TextField("영업장 전화번호를 입력해주세요", text:
                                $marketStore.market.phoneNumber)
                    .keyboardType(.numberPad)
                    .focused($isFocused)
                case .view:
                    Text(marketStore.market.name == "" ? "미등록" : marketStore.market.phoneNumber)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Button(action: {
                isFocused = false
                switch mode {
                case .edit:
                    FirebaseStorageManager.uploadImage(image: selectedImage, pathRoot: uid) { url in
                        guard let url = url?.absoluteString else {
                            Log("Image upload error")
                            return
                        }
                        marketStore.market.marketImages = url
                        Task {
                            marketStore.market.marketId = uid
                            await marketStore.updateMarket(marketId: uid)
                        }
                    }
                    mode = .view
                case .view:
                    mode = .edit
                }
            }) {
                switch mode {
                case .edit:
                    Text("저장")
                case .view:
                    Text("수정")
                }
            }
            .padding(.bottom, keyboardHandler.keyboardHeight)
        }
        .padding()
        .background(Color.LightYellow)
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .onTapGesture {
            isFocused = false
        }
        .onAppear {
            viewTitle = "내 정보"
        }
    }
    
    struct BackgroundHStack<Content>: View where Content: View {
        @ViewBuilder let content: Content
        
        var body: some View {
            HStack(alignment: .center, spacing: 10) {
                content
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white)
            }
        }
    }
    
    struct BackgroundVStack<Content>: View where Content: View {
        @ViewBuilder let content: Content
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                content
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white)
            }
        }
    }
}

#Preview {
    ProfileView(viewTitle: .constant("내 정보"), mode: .constant(.view), marketStore: MarketStore())
}
