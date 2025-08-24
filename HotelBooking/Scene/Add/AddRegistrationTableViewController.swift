//
//  AddRegistrationTableViewController.swift
//  HotelBooking
//
//  Created by Baris on 13.07.2023.
//

import UIKit

// MARK: - Add Registration Table View Controller
final class AddRegistrationTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var checkInDateLabel: UILabel!
    @IBOutlet private weak var checkInDatePicker: UIDatePicker!
    @IBOutlet private weak var checkOutDateLabel: UILabel!
    @IBOutlet private weak var checkOutDatePicker: UIDatePicker!
    @IBOutlet private weak var numberOfAdultsLabel: UILabel!
    @IBOutlet private weak var numberOfAdultsStepper: UIStepper!
    @IBOutlet private weak var numberOfChildrenLabel: UILabel!
    @IBOutlet private weak var numberOfChildrenStepper: UIStepper!
    @IBOutlet private weak var wifiSwitch: UISwitch!
    @IBOutlet private weak var roomTypeLabel: UILabel!
    
    // MARK: - Dependencies
    private let viewModel: AddRegistrationViewModelProtocol
    
    // MARK: - Properties

    
    private var isCheckInDatePickerVisible = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerVisible
        }
    }
    
    private var isCheckOutDatePickerVisible = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
        }
    }
    
    // MARK: - Computed Properties
    var currentRegistration: Registration? {
        return viewModel.currentRegistration
    }
    
    // MARK: - Initialization
    init(container: DIContainerProtocol = DIContainer()) {
        self.viewModel = container.resolve(AddRegistrationViewModelProtocol.self)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        let container = DIContainer()
        self.viewModel = container.resolve(AddRegistrationViewModelProtocol.self)
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureInitialValues()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        setupNavigationBar()
        setupDatePickers()
        setupSteppers()
        setupTextFields()
        bindViewModel()
    }
    
    private func bindViewModel() {
        // Bind text fields to view model
        firstNameTextField.addTarget(self, action: #selector(firstNameChanged), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(lastNameChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Add Registration"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveButtonTapped)
        )
    }
    
    private func setupDatePickers() {
        let minimumDate = viewModel.minimumCheckInDate
        
        checkInDatePicker.minimumDate = minimumDate
        checkInDatePicker.date = viewModel.checkInDate
        
        checkOutDatePicker.minimumDate = viewModel.minimumCheckOutDate
        checkOutDatePicker.date = viewModel.checkOutDate
        
        // Hide pickers initially
        isCheckInDatePickerVisible = false
        isCheckOutDatePickerVisible = false
    }
    
    private func setupSteppers() {
        numberOfAdultsStepper.minimumValue = Constants.GuestLimits.minAdults
        numberOfAdultsStepper.maximumValue = Constants.GuestLimits.maxAdults
        numberOfAdultsStepper.stepValue = Constants.GuestLimits.stepValue
        numberOfAdultsStepper.value = viewModel.numberOfAdults
        
        numberOfChildrenStepper.minimumValue = Constants.GuestLimits.minChildren
        numberOfChildrenStepper.maximumValue = Constants.GuestLimits.maxChildren
        numberOfChildrenStepper.stepValue = Constants.GuestLimits.stepValue
        numberOfChildrenStepper.value = viewModel.numberOfChildren
    }
    
    private func setupTextFields() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
    }
    
    private func configureInitialValues() {
        updateDateLabels()
        updateGuestLabels()
        updateRoomTypeLabel()
    }
    
    // MARK: - IBActions
    @IBAction private func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        validateAndSaveRegistration()
    }
    
    @objc private func firstNameChanged() {
        viewModel.firstName = firstNameTextField.text ?? ""
    }
    
    @objc private func lastNameChanged() {
        viewModel.lastName = lastNameTextField.text ?? ""
    }
    
    @objc private func emailChanged() {
        viewModel.email = emailTextField.text ?? ""
    }
    
    @IBAction private func datePickerValueChanged(_ sender: UIDatePicker) {
        if sender == checkInDatePicker {
            viewModel.updateCheckInDate(sender.date)
            checkOutDatePicker.minimumDate = viewModel.minimumCheckOutDate
            checkOutDatePicker.date = viewModel.checkOutDate
        } else {
            viewModel.checkOutDate = sender.date
        }
        updateDateLabels()
    }
    
    @IBAction private func stepperValueChanged(_ sender: UIStepper) {
        if sender == numberOfAdultsStepper {
            viewModel.numberOfAdults = sender.value
        } else {
            viewModel.numberOfChildren = sender.value
        }
        updateGuestLabels()
    }
    
    @IBAction private func wifiSwitchValueChanged(_ sender: UISwitch) {
        viewModel.hasWifi = sender.isOn
    }
    
    // MARK: - Private Methods
    private func updateDateLabels() {
        checkInDateLabel.text = viewModel.checkInDateFormatted
        checkOutDateLabel.text = viewModel.checkOutDateFormatted
    }
    
    private func updateGuestLabels() {
        numberOfAdultsLabel.text = viewModel.numberOfAdultsText
        numberOfChildrenLabel.text = viewModel.numberOfChildrenText
    }
    
    private func updateRoomTypeLabel() {
        roomTypeLabel.text = viewModel.roomTypeDisplayText
    }
    
    private func validateAndSaveRegistration() {
        let validationResult = viewModel.validateRegistration()
        
        switch validationResult {
        case .valid:
            // Save registration logic here
            performSegue(withIdentifier: Constants.Segues.saveRegistration, sender: currentRegistration)
        case .invalid(let message):
            showErrorAlert(message: message)
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Validation Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func toggleDatePicker(for indexPath: IndexPath) {
        switch indexPath {
        case viewModel.checkInDateLabelIndexPath:
            if isCheckOutDatePickerVisible {
                isCheckOutDatePickerVisible = false
            }
            isCheckInDatePickerVisible.toggle()
            
        case viewModel.checkOutDateLabelIndexPath:
            if isCheckInDatePickerVisible {
                isCheckInDatePickerVisible = false
            }
            isCheckOutDatePickerVisible.toggle()
            
        default:
            break
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

// MARK: - Table View Delegate & Data Source
extension AddRegistrationTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.selectRoomType,
           let destination = segue.destination as? SelectRoomTypeTableViewController {
            destination.delegate = self
            destination.selectedRoomType = viewModel.roomType
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case viewModel.checkInDatePickerIndexPath:
            return isCheckInDatePickerVisible ? Constants.UI.datePickerHeight : 0
        case viewModel.checkOutDatePickerIndexPath:
            return isCheckOutDatePickerVisible ? Constants.UI.datePickerHeight : 0
        default:
            return Constants.UI.defaultRowHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == viewModel.checkInDateLabelIndexPath || indexPath == viewModel.checkOutDateLabelIndexPath {
            toggleDatePicker(for: indexPath)
        }
    }
}

// MARK: - Text Field Delegate
extension AddRegistrationTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Perform validation if needed
        if textField == emailTextField {
            validateEmailField()
        }
    }
    
    private func validateEmailField() {
        let result = viewModel.validateEmail()
        if case .invalid = result {
            // Show validation feedback (red border, etc.)
            emailTextField.layer.borderColor = UIColor.red.cgColor
            emailTextField.layer.borderWidth = Constants.UI.borderWidth
        } else {
            // Clear validation feedback
            emailTextField.layer.borderColor = UIColor.clear.cgColor
            emailTextField.layer.borderWidth = 0
        }
    }
}

// MARK: - Select Room Type Delegate
extension AddRegistrationTableViewController: SelectRoomTypeTableViewControllerDelegate {
    
    func didSelect(roomType: RoomType) {
        viewModel.roomType = roomType
        updateRoomTypeLabel()
    }
}
