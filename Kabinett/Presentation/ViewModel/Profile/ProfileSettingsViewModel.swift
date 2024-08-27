//
//  ProfileSettingsViewModel.swift
//  Kabinett
//
//  Created by Yule on 8/15/24.
//

import SwiftUI
import Combine
import PhotosUI

class ProfileSettingsViewModel: ObservableObject {
    private let profileUseCase: ProfileUseCase
    
    @Published var userName: String = ""
    @Published var newUserName: String = ""
    @Published var profileImage: UIImage?
    @Published var formattedKabinettNumber: String = ""
    @Published var appleID: String = "figfigure33@gmail.com"
    @Published var shouldNavigateToSettings = false
    @Published var selectedImageItem: PhotosPickerItem?
    @Published var selectedImage: UIImage?
    @Published var isShowingImagePicker = false
    @Published var isShowingCropper = false
    @Published var croppedImage: UIImage?
    @Published var isProfileUpdated = false
    
    init(profileUseCase: ProfileUseCase) {
        self.profileUseCase = profileUseCase
        
        Task {
            await loadInitialData()
        }
    }
    
    private func loadInitialData() async {
        let writer = await profileUseCase.getCurrentWriter()
        DispatchQueue.main.async {
            self.userName = writer.name
            self.formattedKabinettNumber = self.formatKabinettNumber(writer.kabinettNumber)
            if let imageUrlString = writer.profileImage, // 이미지 url로 저장하는지? 유즈케이스랑 라이터랑 타입이 다름
               let imageUrl = URL(string: imageUrlString),
               let imageData = try? Data(contentsOf: imageUrl),
               let image = UIImage(data: imageData) {
                self.profileImage = image
            } else {
                self.profileImage = nil
            }
        }
    } // 프로필 이미지 없을 때 탭바 이미지도 설정하기
    
    private func formatKabinettNumber(_ number: Int) -> String {
        return String(format: "%03d-%03d", number / 1000, number % 1000)
    }
    
    var isUserNameVaild: Bool {
        return !newUserName.isEmpty
    }
    
    var displayName: String {
        return newUserName.isEmpty ? userName : newUserName
    }
    
    func updateUserName() {
        if isUserNameVaild {
            userName = newUserName
        }
    }
    
    func updateProfileImage() {
        if let croppedImage = croppedImage {
            self.profileImage = croppedImage
            isProfileUpdated = true
            print("Profile image updated in ViewModel. New image size: \(croppedImage.size)")
        } else {
            print("No image to update")
        }
    }
    
    func selectProfileImage() {
        isShowingImagePicker = true
    }
    
    func completeProfileUpdate() {
        updateUserName()
        updateProfileImage()
        objectWillChange.send()
    }
    
    func crop(image: UIImage, cropArea: CGRect, imageViewSize: CGSize) {
        let scaleX = image.size.width / imageViewSize.width * image.scale
        let scaleY = image.size.height / imageViewSize.height * image.scale
        let scaledCropArea = CGRect(
            x: cropArea.origin.x * scaleX,
            y: cropArea.origin.y * scaleY,
            width: cropArea.size.width * scaleX,
            height: cropArea.size.height * scaleY
        )
        
        guard let cutImageRef: CGImage =
                image.cgImage?.cropping(to: scaledCropArea) else {
            return
        }
        
        let croppedImage = UIImage(cgImage: cutImageRef)
        DispatchQueue.main.async {
            self.croppedImage = croppedImage
            self.isShowingCropper = false
        }
    }
}
