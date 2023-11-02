//
//  LoginView.swift

import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @EnvironmentObject var viewModel: AuthService
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Wax Philosophical")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 72)
                                        
                    Image("philosophyIcon")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFill()
                        .frame(width: 220, height: 100)
                        .padding(.bottom, 80)
                    
                    
                    VStack(spacing: 20) {
                        CustomTextField(text: $email, placeholder: Text("Email"), imageName: "envelope")
                            .padding()
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        
                        CustomSecureField(text: $password, placeholder: Text("Password"))
                            .padding()
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 32)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {  }, label: {
                            Text("Forgot Password?")
                                .font(.footnote)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.top, 16)
                                .padding(.trailing, 32)
                        })
                    }
                    
                    Button(action: {
                        Task{
                            try await viewModel.login(withEmail: email, password: password)
                        }
                    }, label: {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(width: 360, height: 50)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .padding()
                    })
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: RegistrationView().navigationBarBackButtonHidden(true),
                        label: {
                            HStack {
                                Text("Don't have an account?")
                                    .font(.system(size: 14))
                                
                                Text("Sign Up")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.bottom, 40)
                        })
                }
                .padding(.top, 88)
            }
            .background(BlueLinearGradient())
            .ignoresSafeArea()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
