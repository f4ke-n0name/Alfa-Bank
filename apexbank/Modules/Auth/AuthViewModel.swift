struct FieldState {
    let text: String
    let hasError: Bool
    let errorMessage: String
}

struct AuthViewModel {
    let emailState: FieldState
    let passwordState: FieldState
    let errorBanner: String
    let isLoading: Bool
}
