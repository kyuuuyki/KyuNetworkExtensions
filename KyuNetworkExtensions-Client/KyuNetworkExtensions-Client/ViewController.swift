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
				let date = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
				let apodItem = try await mediaLibraryService.getAPOD(date: date)
				self.textView.text = apodItem.description
			} catch {
				self.textView.text = String(describing: error)
			}
		}
	}
}
