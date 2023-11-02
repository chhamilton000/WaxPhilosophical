//
//  SideMenuAction.swift
//  WaxPhilosophical
//
//  Created by Caley Hamilton on 10/26/23.
//

import SwiftUI

struct SideMenuAction: ViewModifier{
    @Binding var showMenu: Bool
    @Binding var offset: CGFloat
    @GestureState var gestureOffset: CGFloat = 0
    @State var lastStoredOffset: CGFloat = 0
    let SCREENWIDTH = UIScreen.main.bounds.width
    let SCREENHEIGHT = UIScreen.main.bounds.height

    func body(content: Content) -> some View {
        let sideBarWidth = SCREENWIDTH - 90
        return content
            .frame(width: SCREENWIDTH + sideBarWidth)
            .offset(x: -sideBarWidth / 2)
            .offset(x: offset > 0 ? offset : 0)
            .gesture(
            
                DragGesture()
                    .updating($gestureOffset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded(endBehavior(_:))
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .animation(.easeOut, value: offset == 0)
            .onChange(of: showMenu) { newValue in
                
                // Preview issues...
                
                if showMenu && offset == 0{
                    offset = sideBarWidth
                    lastStoredOffset = offset
                }
                
                if !showMenu && offset == sideBarWidth{
                    offset = 0
                    lastStoredOffset = 0
                }
            }
            .onChange(of: gestureOffset) { newValue in
                offsetChangeBehavior()
            }
    }
    func endBehavior(_ value: DragGesture.Value){
        
        let sideBarWidth = SCREENWIDTH - 90
        
        let translation = value.translation.width
        
        withAnimation{
            // Checking...
            if translation > 0{
                
                if translation > (sideBarWidth / 2){
                    // showing menu...
                    offset = sideBarWidth
                    showMenu = true
                }
                else{
                    
                    // Extra cases...
                    if offset == sideBarWidth || showMenu{
                        return
                    }
                    offset = 0
                    showMenu = false
                }
            }
            else{
                
                if -translation > (sideBarWidth / 2){
                    offset = 0
                    showMenu = false
                }
                else{
                    
                    if offset == 0 || !showMenu{
                        return
                    }
                    
                    offset = sideBarWidth
                    showMenu = true
                }
            }
        }
        
        // storing last offset...
        lastStoredOffset = offset
    }
    func offsetChangeBehavior(){
        let sideBarWidth = SCREENWIDTH - 90
        
        offset = (gestureOffset != 0) ? ((gestureOffset + lastStoredOffset) < sideBarWidth ? (gestureOffset + lastStoredOffset) : offset) : offset
        
        offset = (gestureOffset + lastStoredOffset) > 0 ? offset : 0
    }
}

