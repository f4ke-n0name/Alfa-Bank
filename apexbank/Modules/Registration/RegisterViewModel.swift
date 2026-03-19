struct RegisterFieldState {
    let hasError: Bool
    let errorMessage: String
}

struct RegisterViewModel {
    let firstNameState: RegisterFieldState
    let lastNameState: RegisterFieldState
    let emailState: RegisterFieldState
    let passwordState: RegisterFieldState
    let errorBanner: String
    let isLoading: Bool
}
