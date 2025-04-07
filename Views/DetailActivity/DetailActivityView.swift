//
//  DetailActivityView.swift
//  ascenttt
//
//  Created by Auliya Michelle Adhana on 30/09/24.
//

import SwiftUI
import PhotosUI

struct DetailActivityView: View {
    var item: FetchedResults<RecordSkill>.Element
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isEditingTitle = false
    @State private var editedTitle = ""
    @State private var titleTextCharacter: Int = 0
    
    @State private var isEditingRacquet = false
    @State private var editedRacquetName = ""
    @State private var racquetTextCharacter: Int = 0
    
    @State private var isEditingLocation = false
    @State private var editedLocation = ""
    @State private var locationTextCharacter: Int = 0
    
    @State private var showingPicker: Bool = false
    @State private var showImagePicker = false
    @State private var showActionSheet = false
    @State private var shouldPresentCamera = false
    
    @State private var image: UIImage?
    @State private var badmintonItem: PhotosPickerItem?
    @State private var badmintonImage: Image? = nil
    
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Text(dateFormat(item.datetime) == "" ? "-/-/-" : dateFormat(item.datetime))
                        .font(Font.custom("SF Pro", size: 12))
                    Spacer()
                }
                HStack{
                    Text(editedTitle.isEmpty ? morningGame : editedTitle)
                        .font(Font.custom("SF Pro", size: 15))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .foregroundColor(.neutralBlack)
                    
                    Image(systemName: "pencil")
                        .foregroundStyle(Color.neutralBlack)
                    
                }
                .onTapGesture {
                    isEditingTitle = true
                }
                .padding(.top, 4)
                
                HStack{
                    VStack(alignment:.trailing){
                        Text(item.duration ?? "00:00")
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundColor(.neutralBlack)
                        Text(durationText)
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Spacer()
                    VStack(alignment:.trailing){
                        Text("\(item.caloriesBurned, specifier: "%.01f")")
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundColor(.neutralBlack)
                        Text(avgCal)
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment:.trailing){
                        Text("\(Int(item.avgHeartRate))")
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundColor(.neutralBlack)
                        Text(avgHeartRate)
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundColor(.gray)
                    }
                }.padding(.top, 12)
                
                HStack{
                    VStack(alignment:.trailing){
                        Text("\(item.hitTotal )")
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundColor(.neutralBlack)
                        Text(tryingText)
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment:.trailing){
                        Text(String(format: "%.2f", Double(item.avgDistance)))
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundColor(.neutralBlack)
                        Text(avgDistance)
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment:.trailing){
                        Text("25%")
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundColor(.neutralBlack)
                        Text(successRate)
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundColor(.gray)
                    }
                }.padding(.top, 12)
                
                ZStack{
                    Rectangle().fill(.grayStroke1)
                    VStack(spacing: 8){
                        Image(systemName: "camera.fill")
                            .font(.title)
                            .foregroundStyle(.neutralBlack)
                        Text(inputBadmintonPhotoText)
                            .font(Font.custom("SF Pro", size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    badmintonImage?
                        .resizable()
                        .frame(height: 289)
                }
                .frame(height: 289)
                .padding(.top, 24)
                .onTapGesture {
                    showingPicker = true
                    showActionSheet = true
                }
                .confirmationDialog("", isPresented: $showActionSheet, titleVisibility: .hidden) {
                    Button("Take Photo") {
                        showImagePicker = true
                        shouldPresentCamera = true
                    }
                    Button("Choose from Gallery") {
                        showImagePicker = true
                        shouldPresentCamera = false
                    }
                    Button("Cancel", role: .cancel) {
                    }
                }.sheet(isPresented: $showImagePicker) {
                    ImagePicker(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: $badmintonImage)
                    
                }
                
                
                HStack{
                    Text(editedRacquetName.isEmpty ? racquetName : editedRacquetName)
                        .font(Font.custom("SF Pro", size: 15))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .foregroundColor(.gray)
                    
                    Image(systemName: "pencil")
                        .foregroundStyle(Color.neutralBlack)
                }.onTapGesture {
                    isEditingRacquet = true
                }.padding(.top, 24)
                
                HStack{
                    Text(editedLocation.isEmpty ? location : editedLocation)
                        .font(Font.custom("SF Pro", size: 15))
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.neutralBlack)
                    
                }
                .padding(.top, 24)
                .onTapGesture {
                    isEditingLocation = true
                }
                
                .sheet(isPresented: $isEditingLocation) {
                    EditableTextSheet(
                        isPresented: $isEditingLocation,
                        text: $editedLocation,
                        placeholder: locationPlaceholder,
                        maxCharacters: 32
                    )
                }
                .sheet(isPresented: $isEditingRacquet) {
                    EditableTextSheet(
                        isPresented: $isEditingRacquet,
                        text: $editedRacquetName,
                        placeholder: racquetNamePlaceholder,
                        maxCharacters: 32
                    )
                }
                .sheet(isPresented: $isEditingTitle) {
                    EditableTextSheet(
                        isPresented: $isEditingTitle,
                        text: $editedTitle,
                        placeholder: morningGame,
                        maxCharacters: 32
                    )
                }
                
            }
            
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.greenMain)
                }
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var image: Image?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = Image(uiImage: uiImage)
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No update logic needed for this example
    }
}

//#Preview {
//    DetailActivityView()
//}
