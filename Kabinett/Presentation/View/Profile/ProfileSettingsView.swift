//
//  ProfileSettingsView.swift
//  Kabinett
//
//  Created by Yule on 8/14/24.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct ProfileSettingsView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea(.all)
            VStack {
                photoPickerView()
                userInfoInputFields()
            }
            .navigationTitle("프로필 설정")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .padding(.leading, 5)
                        }
                        .foregroundColor(.primary900)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            await viewModel.completeProfileUpdate()
                            viewModel.newUserName = ""
                            viewModel.showSettingsView = false
                        }
                    } label: {
                        Text("완료")
                            .fontWeight(.medium)
                            .font(.system(size: 19))
                            .foregroundColor(.contentPrimary)
                            .padding(.trailing, UIScreen.main.bounds.width * 0.0186)
                    }
                }
            }
        }
        .onDisappear {
            viewModel.croppedImage = nil
            viewModel.selectedImageItem = nil
        }
        .sheet(isPresented: $viewModel.isShowingCropper) {
            if let profileImage = viewModel.selectedImage {
                ImageCropper(viewModel: viewModel, isShowingCropper: $viewModel.isShowingCropper, imageToCrop: profileImage)
            }
        }
    }
    
    @ViewBuilder
    private func photoPickerView() -> some View {
        PhotosPicker(
            selection: $viewModel.selectedImageItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            ZStack {
                Circle()
                    .foregroundColor(.primary300)
                    .frame(width: 110, height: 110)
                
                if let croppedImage = viewModel.croppedImage {
                    Image(uiImage: croppedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 110, height: 110)
                        .clipShape(Circle())
                }
                
                else if let image = viewModel.currentWriter.imageUrlString {
                    KFImage(URL(string: image))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 110, height: 110)
                        .clipShape(Circle())
                }
                Image(systemName: "photo")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
            }
        }
        .onChange(of: viewModel.selectedImageItem) { oldItem, newItem in
            viewModel.handleImageSelection(newItem: newItem)
        }
        .padding(.bottom, 10)
    }
    
    @ViewBuilder
    private func userInfoInputFields() -> some View {
        VStack {
            TextField(viewModel.displayName, text: $viewModel.newUserName)
                .textFieldStyle(ProfileOvalTextFieldStyle())
                .autocorrectionDisabled(true)
                .keyboardType(.alphabet)
                .submitLabel(.done)
                .frame(alignment: .center)
                .multilineTextAlignment(.center)
                .font(Font.system(size: 25, design: .default))
                .padding(.bottom, 10)
            
            Text(viewModel.currentWriter.formattedNumber)
                .fontWeight(.light)
                .font(.system(size: 16))
                .monospaced()
        }
    }
    
    struct ProfileOvalTextFieldStyle: TextFieldStyle {
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding(10)
                .background(
                    Capsule()
                        .stroke(Color.primary300, lineWidth: 1)
                        .background(Capsule().fill(Color.white))
                )
                .frame(width: 270, height: 54)
        }
    }
}
