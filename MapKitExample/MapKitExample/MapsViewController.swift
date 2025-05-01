//
//  ViewController.swift
//  MapKitExample
//
//  Created by Aslan Korkmaz on 1.05.2025.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var selectedCoordinate: CLLocationCoordinate2D?
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.textColor = .label
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter Name"
        return textField
    }()
    
    let noteNameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.textColor = .label
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter Note"
        return textField
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.tintColor = .blue
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let mapkit: MKMapView = {
        let mapkit = MKMapView()
        mapkit.translatesAutoresizingMaskIntoConstraints = false
        mapkit.showsUserLocation = true
        return mapkit
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapkit)
        view.addSubview(nameTextField)
        view.addSubview(noteNameTextField)
        view.addSubview(saveButton)
        mapkit.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        constraints()
        
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 1
        mapkit.addGestureRecognizer(gestureRecognizer)
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            noteNameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            noteNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noteNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            mapkit.topAnchor.constraint(equalTo: noteNameTextField.bottomAnchor, constant: 16),
            mapkit.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapkit.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            saveButton.topAnchor.constraint(equalTo: mapkit.bottomAnchor, constant: 16),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude,
                                              longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.9,
                                    longitudeDelta: 0.9)
        
        let region = MKCoordinateRegion(center: location,
                                        span: span)
        mapkit.setRegion(region, animated: true)
        
        
    }
    
    @objc func addAnnotation(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let gestureLocation = gestureRecognizer.location(in: mapkit)
            selectedCoordinate = mapkit.convert(gestureLocation, toCoordinateFrom: mapkit)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = selectedCoordinate!
            annotation.title = nameTextField.text
            annotation.subtitle = noteNameTextField.text
            mapkit.addAnnotation(annotation)
        }
    }
    
    @objc func saveButtonTapped() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPlace = Entity(context: context)
        if let name = nameTextField.text, !name.isEmpty {
            newPlace.name = name
        } else {
            newPlace.name = "Unnamed"
        }
        
        newPlace.note = noteNameTextField.text
        newPlace.id = UUID()
        if let coordinate = selectedCoordinate {
            newPlace.latitute = coordinate.latitude
            newPlace.longitute = coordinate.longitude
        }
        
        
        do {
            try context.save()
            print("kayıt edildi")
        } catch {
            fatalError("Unresolved error \(error), \(error.localizedDescription)")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}

