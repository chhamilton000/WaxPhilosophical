//
//  UploadImageService.swift
//  WaxPhilosophical
//
//  Created by Caley Hamilton on 10/26/23.
//

import FirebaseStorage
import SwiftUI

class UploadImageService: ObservableObject{
    static let shared = UploadImageService()

    /// Uploads a new profile image for a user to Firebase Storage.
    ///
    /// - Parameters:
    ///   - newProfileImage: The image data to upload.
    ///   - userID: The ID of the user for whom the profile image is being uploaded.
    ///   - fileType: The file type of the image (default is "jpg").
    ///
    /// - Returns: The download URL of the uploaded image as a string.
    ///
    /// - Throws: An error if the upload or download URL retrieval fails.
    func upload(newProfileImage: Data, userID: String, fileType: String = "jpg") async throws -> String {
        let bucketRef = Storage.storage().reference()
        
        // Create a folder for the user based on their userID
        let userFolderRef = bucketRef.child("profilePictures/\(userID)")
        
        // Keep the profile image name constant within each user's folder
        let profileImageFileName = "profile.\(fileType)"
        
        // Create a reference to the new profile image's intended storage location
        let newProfileImageStorageLocation = userFolderRef.child(profileImageFileName)
        
        // Create metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/\(fileType)"
        
        // Upload the new profile image
        let _ = try await newProfileImageStorageLocation.putDataAsync(newProfileImage, metadata: metadata)
        
        // Retrieve and return the download URL for the new profile image
        let downloadedUrl = try await newProfileImageStorageLocation.downloadURL()
        
        return downloadedUrl.absoluteString
    }
    
    
    /// Uploads a new profile image for a user to Firebase Storage, and deletes any existing profile image.
    ///
    /// - Parameters:
    ///   - newProfileImage: The image data to upload.
    ///   - userID: The ID of the user for whom the profile image is being uploaded.
    ///
    /// - Returns: The download URL of the uploaded image as a string.
    ///
    /// - Throws: An error if the upload or download URL retrieval fails.
    func uploadAndCleanUpProfileImage(newProfileImage: Data, for userID: String, fileType: String = "jpg") async throws -> String {
        let bucketRef = Storage.storage().reference()
        
        // Create a folder for the user based on their userID
        let userFolderRef = bucketRef.child("profilePictures/\(userID)")
        
        // Generate a unique file name for the new profile image
        let uniqueFileName = "profile.\(fileType)"
        
        // Create a reference to the new profile image's intended storage location
        let newProfileImageStorageLocation = userFolderRef.child(uniqueFileName)
        
        // Delete any existing profile image
        let existingProfileImageRef = userFolderRef.child(uniqueFileName)
        do {
            try await existingProfileImageRef.delete()
        } catch {
            // Handle error (e.g., file not found)
            print("Error deleting existing profile image: \(error)")
        }
        
        // Create metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/\(fileType)"
        
        // Upload the new profile image
        let _ = try await newProfileImageStorageLocation.putDataAsync(newProfileImage, metadata: metadata)
        
        // Retrieve and return the download URL for the new profile image
        let downloadedUrl = try await newProfileImageStorageLocation.downloadURL()
        return downloadedUrl.absoluteString
    }

}
