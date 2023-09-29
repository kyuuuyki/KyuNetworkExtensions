//
//  ViewController.swift
//  KyuNetworkExtensions-Client
//
//  swiftlint:disable prohibited_interface_builder

import UIKit

class ViewController: UIViewController {
	@IBOutlet private weak var textView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		Task {
			let mediaLibraryService = MediaLibraryService(apiKey: "INVALID_API_KEY")
			do {
				let apodItem = try await mediaLibraryService.getAPOD(date: Date())
				self.textView.text = apodItem.description
			} catch {
				self.textView.text = error.localizedDescription
			}
		}
	}
}
