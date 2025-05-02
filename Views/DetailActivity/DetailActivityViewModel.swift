//
//  DetailActivityViewModel.swift
//  ascenttt
//
//  Created by Auliya Michelle Adhana on 18/04/25.
//
import SwiftUI
import CoreData

enum DetailActivityInputType {
    case location
    case racquetName
    case title
}

class DetailActivityViewModel: ObservableObject {

    private var context: NSManagedObjectContext
    @Published var selectedItem: RecordSkill

    init(context: NSManagedObjectContext, selectedItem: RecordSkill) {
        self.context = context
        self.selectedItem = selectedItem
    }


    func saveTextToCoreData(_ inputText: String, for inputType: DetailActivityInputType) {

        switch inputType {
        case .location:
            selectedItem.location = inputText
        case .racquetName:
            selectedItem.racquetName = inputText
        case .title:
            selectedItem.name = inputText
        }

        do {
            try context.save()
            print("Changes saved successfully.")
        } catch {
            print("Failed to save text: \(error.localizedDescription)")
        }
    }

    func saveImageToCoreData(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }

        let filename = UUID().uuidString + ".jpg"
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(filename)

        do {
            try imageData.write(to: url)
            selectedItem.imageUrl = url.path
            try context.save()
            print("Saved image at: \(url.path)")
        } catch {
            print("Failed to save image: \(error)")
        }
    }

}
