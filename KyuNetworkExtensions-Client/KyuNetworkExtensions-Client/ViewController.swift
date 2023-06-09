//
//  ViewController.swift
//  KyuNetworkExtensions-Client
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet private weak var textView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		Task {
			let mediaLibraryService = MediaLibraryService(apiKey: "DEMO_KEY")
			do {
				let apodItem = try await mediaLibraryService.getAPOD(date: Date())
				self.textView.text = apodItem.description
			} catch let error {
				self.textView.text = error.localizedDescription
			}
		}
	}
}
