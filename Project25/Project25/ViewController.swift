//
//  ViewController.swift
//  Project25
//
//  Created by Lorenzo Pesci on 08/04/2020.
//  Copyright © 2020 Lorenzo Pesci. All rights reserved.
//


import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  var images = [UIImage]()
  
  var peerID = MCPeerID(displayName: UIDevice.current.name)
  var mcSession: MCSession?
  var mcAdvertiserAssistant: MCAdvertiserAssistant?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Selfie Share"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
   
    mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
    mcSession?.delegate = self
    
  }
  
  @objc func importPicture() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    dismiss(animated: true)
    images.insert(image, at: 0)
    collectionView.reloadData()
 
    guard let mcSession = mcSession else { return }
    if mcSession.connectedPeers.count > 0 {
      if let imageData = image.pngData() {
        do {
          try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
        } catch {
          let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "OK", style: .default))
          present(ac, animated: true)
        }
      }
    }
    
  }
  
  @objc func showConnectionPrompt() {
    let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Host a Session", style: .default, handler: startHosting))
    ac.addAction(UIAlertAction(title: "Join a Session", style: .default, handler: joinSession))
    ac.addAction(UIAlertAction(title: "Send Message", style: .default, handler: sendMessage))
    ac.addAction(UIAlertAction(title: "Connected Peers", style: .default, handler: showConnectedPeers))
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(ac, animated: true)
  }
  
  func startHosting(action: UIAlertAction) {
    guard let mcSession = mcSession else { return }
    mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
    mcAdvertiserAssistant?.start()
  }
  
  func joinSession(action: UIAlertAction) {
    guard let mcSession = mcSession else { return }
  
    let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
    mcBrowser.delegate = self
    present(mcBrowser, animated: true)
  }
  
  func sendMessage(action: UIAlertAction) {
    let ac = UIAlertController(title: "Message", message: nil, preferredStyle: .alert)
    ac.addTextField()
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    ac.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak self, weak ac] _ in
      if let text = ac?.textFields?[0].text {
        let data = Data(text.utf8)
        self?.sendText(data)
      }
    }))
    present(ac, animated: true)
    
  }
  
  func sendText(_ data: Data) {
    guard let mcSession = mcSession else { return }
    if !mcSession.connectedPeers.isEmpty {
      do {
        try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
      }
      catch {
        let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
      }
    }
  }
  
  func showConnectedPeers(action: UIAlertAction) {
    var peersText = ""
    var peersAvailable = false
    
    if let mcSession = mcSession {
      if mcSession.connectedPeers.count > 0 {
        peersAvailable = true
        for peer in mcSession.connectedPeers {
          peersText += "\n\(peer.displayName)"
        }
      }
    }
    
    if !peersAvailable {
      peersText += "\nNo peer connected"
    }
    
    let ac = UIAlertController(title: "Connected Peers", message: peersText, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
    
    if let imageView = cell.viewWithTag(1000) as? UIImageView {
      imageView.image = images[indexPath.item]
    }
    return cell
  }
}


extension ViewController: MCSessionDelegate, MCBrowserViewControllerDelegate {
  
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    switch state {
    case .connected:
      print("Connected: \(peerID.displayName)")
    case .connecting:
      print("Connecting: \(peerID.displayName)")
    case .notConnected:
      print("Not connected: \(peerID.displayName)")
      let ac = UIAlertController(title: "Disconnected", message: "\(peerID.displayName) is disconnected", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
    @unknown default:
      print("Unknown state received: \(peerID.displayName)")
    }
  }
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    DispatchQueue.main.async { [weak self] in
      if let image = UIImage(data: data) {
        self?.images.insert(image, at: 0)
        self?.collectionView.reloadData()
      } else {
        let text = String(decoding: data, as: UTF8.self)
        let alert = UIAlertController(title: "Message:", message: "\n\(text)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self?.present(alert, animated: true)
      }
    }
  }
  
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    
  }
  
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    
  }
  
  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    
  }
  
  func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }
  
  func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }
  
  
}
