//
//  EditProfileView.swift


import SwiftUI
import KingfisherSwiftUI

struct EditProfileView: View {
    
    @Binding var isShowing: Bool
    var user: AppUser
    
    @EnvironmentObject var userService: UserService
    @EnvironmentObject var sharedViewModel: ProfileViewModel
    
        
    @State var fullnameInput: String = ""
    @State private var showImagePicker: Bool = false
    @State private var inputImage: UIImage?
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    isShowing.toggle()
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.blue)
                        .font(.system(size: 16, weight: .semibold))
                })
                
                Spacer()
                                
                Text("Edit Profile")
                    .font(.system(size: 18, weight: .semibold))
                
                Spacer()
                
                Button(action: {
                    updateFullnameIfNecessary()
                    isShowing = false
                    Task{
                        await uploadSelectedImage(image: inputImage)
                    }
                }, label: {
                    Text("Done")
                        .foregroundColor(.blue)
                        .font(.system(size: 16, weight: .semibold))
                })
//                .onChange(of: userService.currentUser?.profileImageUrl) { _ in
//                    DispatchQueue.main.async {
//                        isShowing = false
//                    }
//                }
            }
            .padding()
            
            VStack() {
                Button(action: {
                    DispatchQueue.main.async { showImagePicker.toggle() }
                }, label: {
//                    if let profileImageUrl = userService.currentUser?.profileImageUrl{
//                    if let profileImageUrl = profileImageUrl{
//                        KFImage(URL(string: profileImageUrl))
//                            .resizable()
//                            .scaledToFill()
//                            .clipped()
//                            .frame(width: 128, height: 128)
//                            .clipShape(Circle())
//                            .padding(.top)
//                    } else {
                    if let inputImage = inputImage{
                        Image(uiImage: inputImage)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: 128, height: 128)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill.badge.plus")
                            .resizable()
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 128, height: 128)
                    }
                    
                })
            }
            .frame(width: UIScreen.main.bounds.width, height: 200)
            .background(Color(.systemGray5))
            .padding(.bottom)
                VStack {
                    HStack(alignment: .center, spacing: 6) {
                        Text("Full Name")
                            .font(.system(size: 14, weight: .semibold))
                            .frame(width: 100)
                        
                        TextField("fullname...", text: $fullnameInput)
                            .font(.system(size: 15))
                        
                        Spacer()
                        
                    }
                    Divider()
                        .padding(.bottom)
                    
//                    HStack(alignment: .center, spacing: 4) {
//                        Text("Username")
//                            .font(.system(size: 14, weight: .semibold))
//                            .frame(width: 100)
//                        HStack(spacing: 0){
//                            Text("@")
//                                .foregroundColor(usernameInput.isEmpty ? Color.gray.opacity(0.5) : .primary)
//                            TextField("@\(userService.currentUser?.username ?? "username...")", text: $usernameInput)
//                        }
//                        .font(.system(size: 15))
//                            .foregroundColor(.blue)
//                        Spacer()
//
//                    }
//                    .padding(.top, -16)
//                    Divider()
                }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding()
            Spacer()
        }
        .disabled(isLoading)
        .overlay{
            ZStack{
                Color.gray.opacity(0.5)
                    .ignoresSafeArea()
                ProgressView()
            }
            .opacity(isLoading ? 1 : 0)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: self.$inputImage)
        }
    }
    
    func uploadSelectedImage(image: UIImage?) async {
        
        if let image, let imageData = image.jpegData(compressionQuality: 1.0) {
             await userService.uploadProfilePic(profilePicData: imageData)
        }
    }
    
    func updateFullnameIfNecessary(){
        if fullnameInput != userService.currentUser!.fullname{
//            user.fullname = fullnameInput
           userService.update(fullname: fullnameInput)
        }
    }
}


