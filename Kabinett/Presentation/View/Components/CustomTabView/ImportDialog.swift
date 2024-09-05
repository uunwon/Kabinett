//
//  ImportDialog.swift
//  Kabinett
//
//  Created by 김정우 on 8/27/24.
//

import SwiftUI

struct ImportDialog: View {
    @EnvironmentObject var viewModel: CustomTabViewModel
    var body: some View {
        EmptyView()
            .confirmationDialog("편지를 불러올 방법을 선택하세요.", isPresented: $viewModel.showImportDialog, titleVisibility: .visible) {
                Button("촬영하기") {
                    viewModel.hideOptions()
                    viewModel.showCamera = true
                }
                Button("앨범에서 가져오기") {
                    viewModel.hideOptions()
                    viewModel.showPhotoLibrary = true
                }
                Button("취소", role: .cancel) {
                    viewModel.showImportDialog = false
                    viewModel.showOptions = true
                }
            }
    }
}
